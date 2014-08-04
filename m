Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaHDQuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:50:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56602 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Feng Tang" <feng.tang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.975647202@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 30/94] ACPI / EC: Add more debug info and trivial code
 cleanup
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit b76b51ba0cef13980813373a548a12206e3cd3c9 upstream.

Add more debug info for EC transaction debugging, like the interrupt
status register value, the detail info of a EC transaction.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/ec.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -178,30 +178,32 @@ static void start_transaction(struct acp
 static void advance_transaction(struct acpi_ec *ec, u8 status)
 {
 	unsigned long flags;
+	struct transaction *t = ec->curr;
+
 	spin_lock_irqsave(&ec->curr_lock, flags);
-	if (!ec->curr)
+	if (!t)
 		goto unlock;
-	if (ec->curr->wlen > ec->curr->wi) {
+	if (t->wlen > t->wi) {
 		if ((status & ACPI_EC_FLAG_IBF) == 0)
 			acpi_ec_write_data(ec,
-				ec->curr->wdata[ec->curr->wi++]);
+				t->wdata[t->wi++]);
 		else
 			goto err;
-	} else if (ec->curr->rlen > ec->curr->ri) {
+	} else if (t->rlen > t->ri) {
 		if ((status & ACPI_EC_FLAG_OBF) == 1) {
-			ec->curr->rdata[ec->curr->ri++] = acpi_ec_read_data(ec);
-			if (ec->curr->rlen == ec->curr->ri)
-				ec->curr->done = true;
+			t->rdata[t->ri++] = acpi_ec_read_data(ec);
+			if (t->rlen == t->ri)
+				t->done = true;
 		} else
 			goto err;
-	} else if (ec->curr->wlen == ec->curr->wi &&
+	} else if (t->wlen == t->wi &&
 		   (status & ACPI_EC_FLAG_IBF) == 0)
-		ec->curr->done = true;
+		t->done = true;
 	goto unlock;
 err:
 	/* false interrupt, state didn't change */
 	if (in_interrupt())
-		++ec->curr->irq_count;
+		++t->irq_count;
 unlock:
 	spin_unlock_irqrestore(&ec->curr_lock, flags);
 }
@@ -311,7 +313,8 @@ static int acpi_ec_transaction(struct ac
 		status = -ETIME;
 		goto end;
 	}
-	pr_debug(PREFIX "transaction start\n");
+	pr_debug(PREFIX "transaction start (cmd=0x%02x, addr=0x%02x)\n",
+			t->command, t->wdata ? t->wdata[0] : 0);
 	/* disable GPE during transaction if storm is detected */
 	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
 		/* It has to be disabled, so that it doesn't trigger. */
@@ -327,8 +330,9 @@ static int acpi_ec_transaction(struct ac
 		/* It is safe to enable the GPE outside of the transaction. */
 		acpi_enable_gpe(NULL, ec->gpe);
 	} else if (t->irq_count > ec_storm_threshold) {
-		pr_info(PREFIX "GPE storm detected, "
-			"transactions will use polling mode\n");
+		pr_info(PREFIX "GPE storm detected(%d GPEs), "
+			"transactions will use polling mode\n",
+			t->irq_count);
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
 	pr_debug(PREFIX "transaction end\n");
@@ -404,7 +408,7 @@ int ec_burst_disable(void)
 
 EXPORT_SYMBOL(ec_burst_disable);
 
-int ec_read(u8 addr, u8 * val)
+int ec_read(u8 addr, u8 *val)
 {
 	int err;
 	u8 temp_data;
@@ -643,10 +647,11 @@ static u32 acpi_ec_gpe_handler(acpi_hand
 	u32 gpe_number, void *data)
 {
 	struct acpi_ec *ec = data;
+	u8 status = acpi_ec_read_status(ec);
 
-	pr_debug(PREFIX "~~~> interrupt\n");
+	pr_debug(PREFIX "~~~> interrupt, status:0x%02x\n", status);
 
-	advance_transaction(ec, acpi_ec_read_status(ec));
+	advance_transaction(ec, status);
 	if (ec_transaction_done(ec) &&
 	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) == 0) {
 		wake_up(&ec->wait);

