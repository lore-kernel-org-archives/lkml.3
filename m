Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaGUGFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:05:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:52690 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbaGUGFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:05:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="564766890"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 01/14] ACPI/EC: Introduce STARTED/STOPPED flags to replace BLOCKED flag.
Date: Mon, 21 Jul 2014 14:05:06 +0800
Message-Id: <689fd9fab3320eca2bdc0d9a96f3ce106d1d411d.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using the 2 flags, we can indicate an inter-mediate state where the
current transactions should be completed while the new transactions should
be blocked.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   64 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index a66ab65..28ce2cd 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -79,7 +79,8 @@ enum {
 	EC_FLAGS_GPE_STORM,		/* GPE storm detected */
 	EC_FLAGS_HANDLERS_INSTALLED,	/* Handlers for GPE and
 					 * OpReg are installed */
-	EC_FLAGS_BLOCKED,		/* Transactions are blocked */
+	EC_FLAGS_STARTED,		/* Driver is started */
+	EC_FLAGS_STOPPED,		/* Driver is stopped */
 };
 
 #define ACPI_EC_COMMAND_POLL		0x01 /* Available for command byte */
@@ -128,6 +129,16 @@ static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
 static int EC_FLAGS_CLEAR_ON_RESUME; /* Needs acpi_ec_clear() on boot/resume */
 
 /* --------------------------------------------------------------------------
+                             Device Flags
+   -------------------------------------------------------------------------- */
+
+static bool acpi_ec_started(struct acpi_ec *ec)
+{
+	return test_bit(EC_FLAGS_STARTED, &ec->flags) &&
+	       !test_bit(EC_FLAGS_STOPPED, &ec->flags);
+}
+
+/* --------------------------------------------------------------------------
                              Transaction Management
    -------------------------------------------------------------------------- */
 
@@ -285,15 +296,24 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 		udelay(ACPI_EC_MSI_UDELAY);
 	/* start transaction */
 	spin_lock_irqsave(&ec->lock, tmp);
+	if (!acpi_ec_started(ec)) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 	/* following two actions should be kept atomic */
 	ec->curr = t;
+	pr_debug("***** transaction started (cmd=0x%02x, addr=0x%02x) *****\n",
+		 t->command, t->wdata ? t->wdata[0] : 0);
 	start_transaction(ec);
 	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	ret = ec_poll(ec);
 	spin_lock_irqsave(&ec->lock, tmp);
+	pr_debug("***** transaction stopped (cmd=0x%02x, addr=0x%02x) *****\n",
+		 t->command, t->wdata ? t->wdata[0] : 0);
 	ec->curr = NULL;
+unlock:
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	return ret;
 }
@@ -307,10 +327,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 	if (t->rdata)
 		memset(t->rdata, 0, t->rlen);
 	mutex_lock(&ec->mutex);
-	if (test_bit(EC_FLAGS_BLOCKED, &ec->flags)) {
-		status = -EINVAL;
-		goto unlock;
-	}
 	if (ec->global_lock) {
 		status = acpi_acquire_global_lock(ACPI_EC_UDELAY_GLK, &glk);
 		if (ACPI_FAILURE(status)) {
@@ -318,8 +334,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 			goto unlock;
 		}
 	}
-	pr_debug("transaction start (cmd=0x%02x, addr=0x%02x)\n",
-			t->command, t->wdata ? t->wdata[0] : 0);
 	/* disable GPE during transaction if storm is detected */
 	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
 		/* It has to be disabled, so that it doesn't trigger. */
@@ -340,7 +354,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 			t->irq_count);
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
-	pr_debug("transaction end\n");
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);
 unlock:
@@ -470,6 +483,29 @@ static void acpi_ec_clear(struct acpi_ec *ec)
 		pr_info("%d stale EC events cleared\n", i);
 }
 
+static void acpi_ec_start(struct acpi_ec *ec)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ec->lock, flags);
+	if (!test_and_set_bit(EC_FLAGS_STARTED, &ec->flags))
+		acpi_enable_gpe(NULL, ec->gpe);
+	spin_unlock_irqrestore(&ec->lock, flags);
+}
+
+static void acpi_ec_stop(struct acpi_ec *ec)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ec->lock, flags);
+	if (acpi_ec_started(ec)) {
+		acpi_disable_gpe(NULL, ec->gpe);
+		clear_bit(EC_FLAGS_STARTED, &ec->flags);
+		clear_bit(EC_FLAGS_STOPPED, &ec->flags);
+	}
+	spin_unlock_irqrestore(&ec->lock, flags);
+}
+
 void acpi_ec_block_transactions(void)
 {
 	struct acpi_ec *ec = first_ec;
@@ -479,7 +515,7 @@ void acpi_ec_block_transactions(void)
 
 	mutex_lock(&ec->mutex);
 	/* Prevent transactions from being carried out */
-	set_bit(EC_FLAGS_BLOCKED, &ec->flags);
+	acpi_ec_stop(ec);
 	mutex_unlock(&ec->mutex);
 }
 
@@ -492,7 +528,7 @@ void acpi_ec_unblock_transactions(void)
 
 	mutex_lock(&ec->mutex);
 	/* Allow transactions to be carried out again */
-	clear_bit(EC_FLAGS_BLOCKED, &ec->flags);
+	acpi_ec_start(ec);
 
 	if (EC_FLAGS_CLEAR_ON_RESUME)
 		acpi_ec_clear(ec);
@@ -507,7 +543,7 @@ void acpi_ec_unblock_transactions_early(void)
 	 * atomic context during wakeup, so we don't need to acquire the mutex).
 	 */
 	if (first_ec)
-		clear_bit(EC_FLAGS_BLOCKED, &first_ec->flags);
+		acpi_ec_start(first_ec);
 }
 
 static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 * data)
@@ -774,7 +810,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	acpi_enable_gpe(NULL, ec->gpe);
+	acpi_ec_start(ec);
 	status = acpi_install_address_space_handler(ec->handle,
 						    ACPI_ADR_SPACE_EC,
 						    &acpi_ec_space_handler,
@@ -789,7 +825,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 			pr_err("Fail in evaluating the _REG object"
 				" of EC device. Broken bios is suspected.\n");
 		} else {
-			acpi_disable_gpe(NULL, ec->gpe);
+			acpi_ec_stop(ec);
 			acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler);
 			return -ENODEV;
@@ -802,10 +838,10 @@ static int ec_install_handlers(struct acpi_ec *ec)
 
 static void ec_remove_handlers(struct acpi_ec *ec)
 {
-	acpi_disable_gpe(NULL, ec->gpe);
 	if (ACPI_FAILURE(acpi_remove_address_space_handler(ec->handle,
 				ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
 		pr_err("failed to remove space handler\n");
+	acpi_ec_stop(ec);
 	if (ACPI_FAILURE(acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler)))
 		pr_err("failed to remove gpe handler\n");
-- 
1.7.10

