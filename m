Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaGUGG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:06:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:27135 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbaGUGG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:06:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="576279082"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 04/14] ACPI/EC: Refine command storm prevention support.
Date: Mon, 21 Jul 2014 14:05:25 +0800
Message-Id: <421106eb2b195bbecd01137aed9659b33d93c0a1.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refines EC command storm prevention support.

After applying the race fixes series, we almost cannot see any
in-transaction false irqs. The out-transaction false irqs are normal, they
are triggered by EC firmware for various reasons and will become silent
sooner or later. So the out-transaction false irqs are not accounted in the
original EC driver.

The EC commands are handled by different firmware processes, storming
happening to one command doesn't mean anything to another process. So
ideally, we should only enable storm prevention for the current command so
that the next command can try the efficient interrupt mode again.

This patch improves the command storm prevention by disabling GPE right
after the detection and re-enabling it right before completing the command
transaction using the GPE storming prevention APIs.

Though now we can hardly see false irqs, unit tests can be carried out by
changing the storm threshold to 0 and deleting the 2 "return wakeup"
statements from the advance_transaction(). The test result is as follows:
  ACPI : EC: ***** Command(RD_EC) started *****
  ACPI : EC: ===== TASK =====
  ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: EC_SC(W) = 0x80
  ACPI : EC: ===== IRQ =====
  ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: EC_DATA(W) = 0x23
  ACPI : EC: +++++ Polling enabled +++++
  ACPI : EC: EC_SC(R) = 0x02 SCI_EVT=0 BURST=0 CMD=0 IBF=1 OBF=0
# ACPI : EC: ===== TASK =====
  ACPI : EC: EC_SC(R) = 0x01 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=1
  ACPI : EC: EC_DATA(R) = 0x2b
  ACPI : EC: +++++ Polling disabled +++++
  ACPI : EC: ***** Command(RD_EC) stopped *****
  ACPI : EC: ===== IRQ =====
  ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: ***** Command(WR_EC) started *****
  ACPI : EC: ===== TASK =====
  ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: EC_SC(W) = 0x81
* ACPI : EC: ===== IRQ =====
  ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: EC_DATA(W) = 0x04
  ACPI : EC: +++++ Polling enabled +++++
  ACPI : EC: EC_SC(R) = 0x02 SCI_EVT=0 BURST=0 CMD=0 IBF=1 OBF=0
  ACPI : EC: ===== TASK =====
  ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: EC_DATA(W) = 0x01
  ACPI : EC: ===== TASK =====
  ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
  ACPI : EC: +++++ Polling disabled +++++
  ACPI : EC: ***** Command(WR_EC) stopped *****
We can see the command is advanced in the task context after enabling the
polling mode (#) and the next command can still be started from the high
performance IRQ mode (*).

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   55 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 4c7a81b..1c3704c 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -76,11 +76,12 @@ enum ec_command {
 
 enum {
 	EC_FLAGS_QUERY_PENDING,		/* Query is pending */
-	EC_FLAGS_GPE_STORM,		/* GPE storm detected */
 	EC_FLAGS_HANDLERS_INSTALLED,	/* Handlers for GPE and
 					 * OpReg are installed */
 	EC_FLAGS_STARTED,		/* Driver is started */
 	EC_FLAGS_STOPPED,		/* Driver is stopped */
+	EC_FLAGS_COMMAND_STORM,		/* GPE storms occurred to the
+					 * current command processing */
 };
 
 #define ACPI_EC_COMMAND_POLL		0x01 /* Available for command byte */
@@ -138,6 +139,33 @@ static bool acpi_ec_started(struct acpi_ec *ec)
 	       !test_bit(EC_FLAGS_STOPPED, &ec->flags);
 }
 
+static bool acpi_ec_has_gpe_storm(struct acpi_ec *ec)
+{
+	return test_bit(EC_FLAGS_COMMAND_STORM, &ec->flags);
+}
+
+/* --------------------------------------------------------------------------
+                             GPE Enhancement
+   -------------------------------------------------------------------------- */
+
+static void acpi_ec_set_storm(struct acpi_ec *ec, u8 flag)
+{
+	if (!test_bit(flag, &ec->flags)) {
+		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_DISABLE);
+		pr_debug("+++++ Polling enabled +++++\n");
+		set_bit(flag, &ec->flags);
+	}
+}
+
+static void acpi_ec_clear_storm(struct acpi_ec *ec, u8 flag)
+{
+	if (test_bit(flag, &ec->flags)) {
+		clear_bit(flag, &ec->flags);
+		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_ENABLE);
+		pr_debug("+++++ Polling disabled +++++\n");
+	}
+}
+
 /* --------------------------------------------------------------------------
                              Transaction Management
    -------------------------------------------------------------------------- */
@@ -253,8 +281,13 @@ err:
 	 * otherwise will take a not handled IRQ as a false one.
 	 */
 	if (!(status & ACPI_EC_FLAG_SCI)) {
-		if (in_interrupt() && t)
-			++t->irq_count;
+		if (in_interrupt() && t) {
+			if (t->irq_count < ec_storm_threshold)
+				++t->irq_count;
+			/* Allow triggering on 0 threshold */
+			if (t->irq_count == ec_storm_threshold)
+				acpi_ec_set_storm(ec, EC_FLAGS_COMMAND_STORM);
+		}
 	}
 	return wakeup;
 }
@@ -327,24 +360,14 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	ec->curr = t;
 	pr_debug("***** Command(%s) started *****\n",
 		 acpi_ec_cmd_string(t->command));
-	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
-		pr_debug("+++++ Polling enabled +++++\n");
-		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_DISABLE);
-	}
 	start_transaction(ec);
 	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	ret = ec_poll(ec);
 	spin_lock_irqsave(&ec->lock, tmp);
-	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
-		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_ENABLE);
-		pr_debug("+++++ Polling disabled +++++\n");
-	} else if (t->irq_count > ec_storm_threshold) {
-		pr_debug("+++++ Polling scheduled (%d GPE) +++++\n",
-			 t->irq_count);
-		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
-	}
+	if (t->irq_count == ec_storm_threshold)
+		acpi_ec_clear_storm(ec, EC_FLAGS_COMMAND_STORM);
 	pr_debug("***** Command(%s) stopped *****\n",
 		 acpi_ec_cmd_string(t->command));
 	ec->curr = NULL;
@@ -712,7 +735,7 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 	spin_lock_irqsave(&ec->lock, flags);
 	if (advance_transaction(ec))
 		wake_up(&ec->wait);
-	if (!test_bit(EC_FLAGS_GPE_STORM, &ec->flags))
+	if (!acpi_ec_has_gpe_storm(ec))
 		enable = ACPI_REENABLE_GPE;
 	spin_unlock_irqrestore(&ec->lock, flags);
 	ec_check_sci(ec, acpi_ec_read_status(ec));
-- 
1.7.10

