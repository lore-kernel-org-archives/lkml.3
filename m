Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162AbaKCFQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:16:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:24181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaKCFQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:16:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,305,1413270000"; 
   d="scan'208";a="625257171"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 1/6] ACPI/EC: Introduce STARTED/STOPPED flags to replace BLOCKED flag.
Date: Mon,  3 Nov 2014 13:16:14 +0800
Message-Id: <e1228a3433fbbd8448d5522bef4e080763b1c18f.1414988981.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414988981.git.lv.zheng@intel.com>
References: <cover.1414988981.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using the 2 flags, we can indicate an inter-mediate state where the
current transactions should be completed while the new transactions should
be dropped.

The comparison of the old flag and the new flags:
  Old			New
  about to set BLOCKED	STOPPED set / STARTED set
  BLOCKED set		STOPPED clear / STARTED clear
  BLOCKED clear		STOPPED clear / STARTED set
The new period is between the point where we are about to set BLOCKED and
the point when the BLOCKED is set. The GPE is disabled during this period.
The new flags allow us to add acpi_ec_stopped() check to only check with
STOPPED flag to implement transaction flushing. This is not done in this
patch.

No functional changes except that after applying this patch, the GPE
enabling/disabling is protected by the EC specific lock. We can do this
because of recent ACPICA GPE API enhancement. This is reasonable as the GPE
disabling/enabling state should only be determined by the EC driver's state
machine which is protected by the EC spinlock.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Ortwin Glück <odi@odi.ch>
---
 drivers/acpi/ec.c |   56 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 5f9b74b..192cd11 100644
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
@@ -129,6 +130,16 @@ static int EC_FLAGS_CLEAR_ON_RESUME; /* Needs acpi_ec_clear() on boot/resume */
 static int EC_FLAGS_QUERY_HANDSHAKE; /* Needs QR_EC issued when SCI_EVT set */
 
 /* --------------------------------------------------------------------------
+ *                           Device Flags
+ * -------------------------------------------------------------------------- */
+
+static bool acpi_ec_started(struct acpi_ec *ec)
+{
+	return test_bit(EC_FLAGS_STARTED, &ec->flags) &&
+	       !test_bit(EC_FLAGS_STOPPED, &ec->flags);
+}
+
+/* --------------------------------------------------------------------------
  *                           Transaction Management
  * -------------------------------------------------------------------------- */
 
@@ -354,7 +365,7 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 	if (t->rdata)
 		memset(t->rdata, 0, t->rlen);
 	mutex_lock(&ec->mutex);
-	if (test_bit(EC_FLAGS_BLOCKED, &ec->flags)) {
+	if (!acpi_ec_started(ec)) {
 		status = -EINVAL;
 		goto unlock;
 	}
@@ -511,6 +522,35 @@ static void acpi_ec_clear(struct acpi_ec *ec)
 		pr_info("%d stale EC events cleared\n", i);
 }
 
+static void acpi_ec_start(struct acpi_ec *ec)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ec->lock, flags);
+	if (!test_and_set_bit(EC_FLAGS_STARTED, &ec->flags)) {
+		pr_debug("+++++ Starting EC +++++\n");
+		acpi_enable_gpe(NULL, ec->gpe);
+		pr_info("+++++ EC started +++++\n");
+	}
+	spin_unlock_irqrestore(&ec->lock, flags);
+}
+
+static void acpi_ec_stop(struct acpi_ec *ec)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ec->lock, flags);
+	if (acpi_ec_started(ec)) {
+		pr_debug("+++++ Stopping EC +++++\n");
+		set_bit(EC_FLAGS_STOPPED, &ec->flags);
+		acpi_disable_gpe(NULL, ec->gpe);
+		clear_bit(EC_FLAGS_STARTED, &ec->flags);
+		clear_bit(EC_FLAGS_STOPPED, &ec->flags);
+		pr_info("+++++ EC stopped +++++\n");
+	}
+	spin_unlock_irqrestore(&ec->lock, flags);
+}
+
 void acpi_ec_block_transactions(void)
 {
 	struct acpi_ec *ec = first_ec;
@@ -520,7 +560,7 @@ void acpi_ec_block_transactions(void)
 
 	mutex_lock(&ec->mutex);
 	/* Prevent transactions from being carried out */
-	set_bit(EC_FLAGS_BLOCKED, &ec->flags);
+	acpi_ec_stop(ec);
 	mutex_unlock(&ec->mutex);
 }
 
@@ -533,7 +573,7 @@ void acpi_ec_unblock_transactions(void)
 
 	mutex_lock(&ec->mutex);
 	/* Allow transactions to be carried out again */
-	clear_bit(EC_FLAGS_BLOCKED, &ec->flags);
+	acpi_ec_start(ec);
 
 	if (EC_FLAGS_CLEAR_ON_RESUME)
 		acpi_ec_clear(ec);
@@ -548,7 +588,7 @@ void acpi_ec_unblock_transactions_early(void)
 	 * atomic context during wakeup, so we don't need to acquire the mutex).
 	 */
 	if (first_ec)
-		clear_bit(EC_FLAGS_BLOCKED, &first_ec->flags);
+		acpi_ec_start(first_ec);
 }
 
 static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 *data)
@@ -816,7 +856,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	acpi_enable_gpe(NULL, ec->gpe);
+	acpi_ec_start(ec);
 	status = acpi_install_address_space_handler(ec->handle,
 						    ACPI_ADR_SPACE_EC,
 						    &acpi_ec_space_handler,
@@ -831,7 +871,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 			pr_err("Fail in evaluating the _REG object"
 				" of EC device. Broken bios is suspected.\n");
 		} else {
-			acpi_disable_gpe(NULL, ec->gpe);
+			acpi_ec_stop(ec);
 			acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler);
 			return -ENODEV;
@@ -844,7 +884,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 
 static void ec_remove_handlers(struct acpi_ec *ec)
 {
-	acpi_disable_gpe(NULL, ec->gpe);
+	acpi_ec_stop(ec);
 	if (ACPI_FAILURE(acpi_remove_address_space_handler(ec->handle,
 				ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
 		pr_err("failed to remove space handler\n");
-- 
1.7.10

