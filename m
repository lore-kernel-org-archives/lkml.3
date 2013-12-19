Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3LSL6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:58:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3LSL61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 131/208] iwlwifi: pcie: fix interrupt coalescing for 7260 / 3160
Date: Thu, 19 Dec 2013 11:53:49 +0000
Message-Id: <1387454106-19326-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 6960a059b2c618f32fe549f13287b3d2278c09e9 upstream.

We changed the timeout for the interrupt coealescing for
calibration, but that wasn't effective since we changed
that value back before loading the firmware. Since
calibrations are notification from firmware and not Rx
packets, this doesn't change anyway - the firmware will
fire an interrupt straight away regardless of the interrupt
coalescing value.
Also, a HW issue has been discovered in 7000 devices series.
The work around is to disable the new interrupt coalescing
timeout feature - do this by setting bit 31 in
CSR_INT_COALESCING.
This has been fixed in 7265 which means that we can't rely
on the device family and must have a hint in the iwl_cfg
structure.

Fixes: 99cd47142399 ("iwlwifi: add 7000 series device configuration")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[ luis: backported to 3.11:
  - adjusted context
  - dropped changes to iwl7260_2ac_cfg_high_temp struct ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   | 6 ++++++
 drivers/net/wireless/iwlwifi/iwl-config.h | 3 +++
 drivers/net/wireless/iwlwifi/iwl-csr.h    | 5 +----
 drivers/net/wireless/iwlwifi/pcie/rx.c    | 4 ++++
 drivers/net/wireless/iwlwifi/pcie/trans.c | 3 ---
 5 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 22b7fa5..bf6da4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -124,6 +124,7 @@ const struct iwl_cfg iwl7260_2ac_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7260_NVM_VERSION,
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl7260_2n_cfg = {
@@ -133,6 +134,7 @@ const struct iwl_cfg iwl7260_2n_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7260_NVM_VERSION,
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl7260_n_cfg = {
@@ -142,6 +144,7 @@ const struct iwl_cfg iwl7260_n_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7260_NVM_VERSION,
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl3160_2ac_cfg = {
@@ -151,6 +154,7 @@ const struct iwl_cfg iwl3160_2ac_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3160_NVM_VERSION,
 	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl3160_2n_cfg = {
@@ -160,6 +164,7 @@ const struct iwl_cfg iwl3160_2n_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3160_NVM_VERSION,
 	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl3160_n_cfg = {
@@ -169,6 +174,7 @@ const struct iwl_cfg iwl3160_n_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3160_NVM_VERSION,
 	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index d978846..6937ac3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -205,6 +205,8 @@ struct iwl_eeprom_params {
  * @led_mode: 0=blinking, 1=On(RF On)/Off(RF Off)
  * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
  * @internal_wimax_coex: internal wifi/wimax combo device
+ * @host_interrupt_operation_mode: device needs host interrupt operation
+ *	mode set
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -233,6 +235,7 @@ struct iwl_cfg {
 	enum iwl_led_mode led_mode;
 	const bool rx_with_siso_diversity;
 	const bool internal_wimax_coex;
+	const bool host_interrupt_operation_mode;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index a276af4..6414205 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -463,14 +463,11 @@
  * the CSR_INT_COALESCING is an 8 bit register in 32-usec unit
  *
  * default interrupt coalescing timer is 64 x 32 = 2048 usecs
- * default interrupt coalescing calibration timer is 16 x 32 = 512 usecs
  */
 #define IWL_HOST_INT_TIMEOUT_MAX	(0xFF)
 #define IWL_HOST_INT_TIMEOUT_DEF	(0x40)
 #define IWL_HOST_INT_TIMEOUT_MIN	(0x0)
-#define IWL_HOST_INT_CALIB_TIMEOUT_MAX	(0xFF)
-#define IWL_HOST_INT_CALIB_TIMEOUT_DEF	(0x10)
-#define IWL_HOST_INT_CALIB_TIMEOUT_MIN	(0x0)
+#define IWL_HOST_INT_OPER_MODE		BIT(31)
 
 /*****************************************************************************
  *                        7000/3000 series SHR DTS addresses                 *
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index fd848cd..1c580f2 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -488,6 +488,10 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
 	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+
+	/* W/A for interrupt coalescing bug in 7260 and 3160 */
+	if (trans->cfg->host_interrupt_operation_mode)
+		iwl_set_bit(trans, CSR_INT_COALESCING, IWL_HOST_INT_OPER_MODE);
 }
 
 static void iwl_pcie_rx_init_rxb_lists(struct iwl_rxq *rxq)
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 390e2f0..ca06967 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -276,9 +276,6 @@ static int iwl_pcie_nic_init(struct iwl_trans *trans)
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 	iwl_pcie_apm_init(trans);
 
-	/* Set interrupt coalescing calibration timer to default (512 usecs) */
-	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
-
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	iwl_pcie_set_pwr(trans, false);
-- 
1.8.3.2

