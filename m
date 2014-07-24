Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934754AbaGXJs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:48:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55121 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934725AbaGXJsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 103/128] ACPI / EC: Add asynchronous command byte write support
Date: Thu, 24 Jul 2014 10:45:52 +0100
Message-Id: <1406195177-8656-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit f92fca0060fc4dc9227342d0072d75df98c1e5a5 upstream.

Move the first command byte write into advance_transaction() so that all
EC register accesses that can affect the command processing state machine
can happen in this asynchronous state machine advancement function.

The advance_transaction() function then can be a complete implementation
of an asyncrhonous transaction for a single command so that:
 1. The first command byte can be written in the interrupt context;
 2. The command completion waiter can also be used to wait the first command
    byte's timeout;
 3. In BURST mode, the follow-up command bytes can be written in the
    interrupt context directly, so that it doesn't need to return to the
    task context. Returning to the task context reduces the throughput of
    the BURST mode and in the worst cases where the system workload is very
    high, this leads to the hardware driven automatic BURST mode exit.

In order not to increase memory consumption, convert 'done' into 'flags'
to contain multiple indications:
 1. ACPI_EC_COMMAND_COMPLETE: converting from original 'done' condition,
    indicating the completion of the command transaction.
 2. ACPI_EC_COMMAND_POLL: indicating the availability of writing the first
    command byte. A new command can utilize this flag to compete for the
    right of accessing the underlying hardware. There is a follow-up bug
    fix that has utilized this new flag.

The 2 flags are important because it also reflects a key concept of IO
programs' design used in the system softwares. Normally an IO program
running in the kernel should first be implemented in the asynchronous way.
And the 2 flags are the most common way to implement its synchronous
operations on top of the asynchronous operations:
1. POLL: This flag can be used to block until the asynchronous operations
         can happen.
2. COMPLETE: This flag can be used to block until the asynchronous
             operations have completed.
By constructing code cleanly in this way, many difficult problems can be
solved smoothly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=70891
Link: https://bugzilla.kernel.org/show_bug.cgi?id=63931
Link: https://bugzilla.kernel.org/show_bug.cgi?id=59911
Reported-and-tested-by: Gareth Williams <gareth@garethwilliams.me.uk>
Reported-and-tested-by: Hans de Goede <jwrdegoede@fedoraproject.org>
Reported-by: Barton Xu <tank.xuhan@gmail.com>
Tested-by: Steffen Weber <steffen.weber@gmail.com>
Tested-by: Arthur Chen <axchen@nvidia.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/ec.c | 83 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 35 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 769d5a757bd1..02090c6095fe 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -81,6 +81,9 @@ enum {
 	EC_FLAGS_BLOCKED,		/* Transactions are blocked */
 };
 
+#define ACPI_EC_COMMAND_POLL		0x01 /* Available for command byte */
+#define ACPI_EC_COMMAND_COMPLETE	0x02 /* Completed last byte */
+
 /* ec.c is compiled in acpi namespace so this shows up as acpi.ec_delay param */
 static unsigned int ec_delay __read_mostly = ACPI_EC_DELAY;
 module_param(ec_delay, uint, 0644);
@@ -116,7 +119,7 @@ struct transaction {
 	u8 ri;
 	u8 wlen;
 	u8 rlen;
-	bool done;
+	u8 flags;
 };
 
 struct acpi_ec *boot_ec, *first_ec;
@@ -157,63 +160,68 @@ static inline void acpi_ec_write_data(struct acpi_ec *ec, u8 data)
 	outb(data, ec->data_addr);
 }
 
-static int ec_transaction_done(struct acpi_ec *ec)
+static int ec_transaction_completed(struct acpi_ec *ec)
 {
 	unsigned long flags;
 	int ret = 0;
 	spin_lock_irqsave(&ec->lock, flags);
-	if (!ec->curr || ec->curr->done)
+	if (!ec->curr || (ec->curr->flags & ACPI_EC_COMMAND_COMPLETE))
 		ret = 1;
 	spin_unlock_irqrestore(&ec->lock, flags);
 	return ret;
 }
 
-static void start_transaction(struct acpi_ec *ec)
-{
-	ec->curr->irq_count = ec->curr->wi = ec->curr->ri = 0;
-	ec->curr->done = false;
-	acpi_ec_write_cmd(ec, ec->curr->command);
-}
-
 static void advance_transaction(struct acpi_ec *ec)
 {
-	unsigned long flags;
 	struct transaction *t;
 	u8 status;
 
-	spin_lock_irqsave(&ec->lock, flags);
 	pr_debug("===== %s =====\n", in_interrupt() ? "IRQ" : "TASK");
 	status = acpi_ec_read_status(ec);
 	t = ec->curr;
 	if (!t)
-		goto unlock;
-	if (t->wlen > t->wi) {
-		if ((status & ACPI_EC_FLAG_IBF) == 0)
-			acpi_ec_write_data(ec,
-				t->wdata[t->wi++]);
-		else
-			goto err;
-	} else if (t->rlen > t->ri) {
-		if ((status & ACPI_EC_FLAG_OBF) == 1) {
-			t->rdata[t->ri++] = acpi_ec_read_data(ec);
-			if (t->rlen == t->ri)
-				t->done = true;
+		goto err;
+	if (t->flags & ACPI_EC_COMMAND_POLL) {
+		if (t->wlen > t->wi) {
+			if ((status & ACPI_EC_FLAG_IBF) == 0)
+				acpi_ec_write_data(ec, t->wdata[t->wi++]);
+			else
+				goto err;
+		} else if (t->rlen > t->ri) {
+			if ((status & ACPI_EC_FLAG_OBF) == 1) {
+				t->rdata[t->ri++] = acpi_ec_read_data(ec);
+				if (t->rlen == t->ri)
+					t->flags |= ACPI_EC_COMMAND_COMPLETE;
+			} else
+				goto err;
+		} else if (t->wlen == t->wi &&
+			   (status & ACPI_EC_FLAG_IBF) == 0)
+			t->flags |= ACPI_EC_COMMAND_COMPLETE;
+		return;
+	} else {
+		if ((status & ACPI_EC_FLAG_IBF) == 0) {
+			acpi_ec_write_cmd(ec, t->command);
+			t->flags |= ACPI_EC_COMMAND_POLL;
 		} else
 			goto err;
-	} else if (t->wlen == t->wi &&
-		   (status & ACPI_EC_FLAG_IBF) == 0)
-		t->done = true;
-	goto unlock;
+		return;
+	}
 err:
 	/*
 	 * If SCI bit is set, then don't think it's a false IRQ
 	 * otherwise will take a not handled IRQ as a false one.
 	 */
-	if (in_interrupt() && !(status & ACPI_EC_FLAG_SCI))
-		++t->irq_count;
+	if (!(status & ACPI_EC_FLAG_SCI)) {
+		if (in_interrupt() && t)
+			++t->irq_count;
+	}
+}
 
-unlock:
-	spin_unlock_irqrestore(&ec->lock, flags);
+static void start_transaction(struct acpi_ec *ec)
+{
+	ec->curr->irq_count = ec->curr->wi = ec->curr->ri = 0;
+	ec->curr->flags = 0;
+	advance_transaction(ec);
 }
 
 static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data);
@@ -238,15 +246,17 @@ static int ec_poll(struct acpi_ec *ec)
 			/* don't sleep with disabled interrupts */
 			if (EC_FLAGS_MSI || irqs_disabled()) {
 				udelay(ACPI_EC_MSI_UDELAY);
-				if (ec_transaction_done(ec))
+				if (ec_transaction_completed(ec))
 					return 0;
 			} else {
 				if (wait_event_timeout(ec->wait,
-						ec_transaction_done(ec),
+						ec_transaction_completed(ec),
 						msecs_to_jiffies(1)))
 					return 0;
 			}
+			spin_lock_irqsave(&ec->lock, flags);
 			advance_transaction(ec);
+			spin_unlock_irqrestore(&ec->lock, flags);
 		} while (time_before(jiffies, delay));
 		pr_debug(PREFIX "controller reset, restart transaction\n");
 		spin_lock_irqsave(&ec->lock, flags);
@@ -664,10 +674,13 @@ static int ec_check_sci(struct acpi_ec *ec, u8 state)
 static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 	u32 gpe_number, void *data)
 {
+	unsigned long flags;
 	struct acpi_ec *ec = data;
 
+	spin_lock_irqsave(&ec->lock, flags);
 	advance_transaction(ec);
-	if (ec_transaction_done(ec) &&
+	spin_unlock_irqrestore(&ec->lock, flags);
+	if (ec_transaction_completed(ec) &&
 	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) == 0) {
 		wake_up(&ec->wait);
 		ec_check_sci(ec, acpi_ec_read_status(ec));
-- 
1.9.1

