Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaHDQx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:53:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56622 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Barton Xu" <tank.xuhan@gmail.com>,
        "Steffen Weber" <steffen.weber@gmail.com>,
        "Arthur Chen" <axchen@nvidia.com>, "Lv Zheng" <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.944125690@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 36/94] ACPI / EC: Fix race condition in
 ec_transaction_completed()
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit c0d653412fc8450370167a3268b78fc772ff9c87 upstream.

There is a race condition in ec_transaction_completed().

When ec_transaction_completed() is called in the GPE handler, it could
return true because of (ec->curr == NULL). Then the wake_up() invocation
could complete the next command unexpectedly since there is no lock between
the 2 invocations. With the previous cleanup, the IBF=0 waiter race need
not be handled any more. It's now safe to return a flag from
advance_condition() to indicate the requirement of wakeup, the flag is
returned from a locked context.

The ec_transaction_completed() is now only invoked by the ec_poll() where
the ec->curr is ensured to be different from NULL.

After cleaning up, the EVT_SCI=1 check should be moved out of the wakeup
condition so that an EVT_SCI raised with (ec->curr == NULL) can trigger a
QR_SC command.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/ec.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -165,16 +165,17 @@ static int ec_transaction_completed(stru
 	unsigned long flags;
 	int ret = 0;
 	spin_lock_irqsave(&ec->curr_lock, flags);
-	if (!ec->curr || (ec->curr->flags & ACPI_EC_COMMAND_COMPLETE))
+	if (ec->curr && (ec->curr->flags & ACPI_EC_COMMAND_COMPLETE))
 		ret = 1;
 	spin_unlock_irqrestore(&ec->curr_lock, flags);
 	return ret;
 }
 
-static void advance_transaction(struct acpi_ec *ec)
+static bool advance_transaction(struct acpi_ec *ec)
 {
 	struct transaction *t;
 	u8 status;
+	bool wakeup = false;
 
 	pr_debug(PREFIX "===== %s =====\n", in_interrupt() ? "IRQ" : "TASK");
 	status = acpi_ec_read_status(ec);
@@ -190,21 +191,25 @@ static void advance_transaction(struct a
 		} else if (t->rlen > t->ri) {
 			if ((status & ACPI_EC_FLAG_OBF) == 1) {
 				t->rdata[t->ri++] = acpi_ec_read_data(ec);
-				if (t->rlen == t->ri)
+				if (t->rlen == t->ri) {
 					t->flags |= ACPI_EC_COMMAND_COMPLETE;
+					wakeup = true;
+				}
 			} else
 				goto err;
 		} else if (t->wlen == t->wi &&
-			   (status & ACPI_EC_FLAG_IBF) == 0)
+			   (status & ACPI_EC_FLAG_IBF) == 0) {
 			t->flags |= ACPI_EC_COMMAND_COMPLETE;
-		return;
+			wakeup = true;
+		}
+		return wakeup;
 	} else {
 		if ((status & ACPI_EC_FLAG_IBF) == 0) {
 			acpi_ec_write_cmd(ec, t->command);
 			t->flags |= ACPI_EC_COMMAND_POLL;
 		} else
 			goto err;
-		return;
+		return wakeup;
 	}
 err:
 	/*
@@ -215,13 +220,14 @@ err:
 		if (in_interrupt() && t)
 			++t->irq_count;
 	}
+	return wakeup;
 }
 
 static void start_transaction(struct acpi_ec *ec)
 {
 	ec->curr->irq_count = ec->curr->wi = ec->curr->ri = 0;
 	ec->curr->flags = 0;
-	advance_transaction(ec);
+	(void)advance_transaction(ec);
 }
 
 static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data);
@@ -255,7 +261,7 @@ static int ec_poll(struct acpi_ec *ec)
 					return 0;
 			}
 			spin_lock_irqsave(&ec->curr_lock, flags);
-			advance_transaction(ec);
+			(void)advance_transaction(ec);
 			spin_unlock_irqrestore(&ec->curr_lock, flags);
 		} while (time_before(jiffies, delay));
 		pr_debug(PREFIX "controller reset, restart transaction\n");
@@ -644,12 +650,10 @@ static u32 acpi_ec_gpe_handler(acpi_hand
 	struct acpi_ec *ec = data;
 
 	spin_lock_irqsave(&ec->curr_lock, flags);
-	advance_transaction(ec);
-	spin_unlock_irqrestore(&ec->curr_lock, flags);
-	if (ec_transaction_completed(ec)) {
+	if (advance_transaction(ec))
 		wake_up(&ec->wait);
-		ec_check_sci(ec, acpi_ec_read_status(ec));
-	}
+	spin_unlock_irqrestore(&ec->curr_lock, flags);
+	ec_check_sci(ec, acpi_ec_read_status(ec));
 	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
 }
 

