Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046AbaFRDSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:18:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:13175 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964909AbaFRDSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:18:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,498,1400050800"; 
   d="scan'208";a="549554015"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 6/9] ACPI/EC: Introduce STARTED/STOPPED flags to replace BLOCKED flag.
Date: Wed, 18 Jun 2014 11:17:57 +0800
Message-Id: <754e8ad1ca548b66ccb76c3bd40a4a089aeaaeef.1403060601.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1403060601.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using the 2 flags, we can indicate an inter-mediate state where the
current transactions should be completed while the new transactions should
be blocked.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   56 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index c3299f6..6891370 100644
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
@@ -285,15 +286,25 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 		udelay(ACPI_EC_MSI_UDELAY);
 	/* start transaction */
 	spin_lock_irqsave(&ec->lock, tmp);
+	if (!test_bit(EC_FLAGS_STARTED, &ec->flags) ||
+	    test_bit(EC_FLAGS_STOPPED, &ec->flags)) {
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
@@ -307,10 +318,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
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
@@ -318,8 +325,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 			goto unlock;
 		}
 	}
-	pr_debug("transaction start (cmd=0x%02x, addr=0x%02x)\n",
-			t->command, t->wdata ? t->wdata[0] : 0);
 	/* disable GPE during transaction if storm is detected */
 	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
 		/* It has to be disabled, so that it doesn't trigger. */
@@ -340,7 +345,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 			t->irq_count);
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
-	pr_debug("transaction end\n");
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);
 unlock:
@@ -470,6 +474,30 @@ static void acpi_ec_clear(struct acpi_ec *ec)
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
+	if (test_bit(EC_FLAGS_STARTED, &ec->flags) &&
+	    !test_and_set_bit(EC_FLAGS_STOPPED, &ec->flags)) {
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
@@ -479,7 +507,7 @@ void acpi_ec_block_transactions(void)
 
 	mutex_lock(&ec->mutex);
 	/* Prevent transactions from being carried out */
-	set_bit(EC_FLAGS_BLOCKED, &ec->flags);
+	acpi_ec_stop(ec);
 	mutex_unlock(&ec->mutex);
 }
 
@@ -492,7 +520,7 @@ void acpi_ec_unblock_transactions(void)
 
 	mutex_lock(&ec->mutex);
 	/* Allow transactions to be carried out again */
-	clear_bit(EC_FLAGS_BLOCKED, &ec->flags);
+	acpi_ec_start(ec);
 
 	if (EC_FLAGS_CLEAR_ON_RESUME)
 		acpi_ec_clear(ec);
@@ -507,7 +535,7 @@ void acpi_ec_unblock_transactions_early(void)
 	 * atomic context during wakeup, so we don't need to acquire the mutex).
 	 */
 	if (first_ec)
-		clear_bit(EC_FLAGS_BLOCKED, &first_ec->flags);
+		acpi_ec_start(first_ec);
 }
 
 static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 * data)
@@ -774,7 +802,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	acpi_enable_gpe(NULL, ec->gpe);
+	acpi_ec_start(ec);
 	status = acpi_install_address_space_handler(ec->handle,
 						    ACPI_ADR_SPACE_EC,
 						    &acpi_ec_space_handler,
@@ -789,7 +817,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 			pr_err("Fail in evaluating the _REG object"
 				" of EC device. Broken bios is suspected.\n");
 		} else {
-			acpi_disable_gpe(NULL, ec->gpe);
+			acpi_ec_stop(ec);
 			acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler);
 			return -ENODEV;
@@ -802,10 +830,10 @@ static int ec_install_handlers(struct acpi_ec *ec)
 
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

