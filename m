Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaKKL06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:26:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57726 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbaKKLLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 125/170] iwlwifi: configure the LTR
Date: Tue, 11 Nov 2014 11:08:04 +0000
Message-Id: <1415704129-12709-126-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 9180ac50716a097a407c6d7e7e4589754a922260 upstream.

The LTR is the handshake between the device and the root
complex about the latency allowed when the bus exits power
save. This configuration was missing and this led to high
latency in the link power up. The end user could experience
high latency in the network because of this.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h        |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 35 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |  1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c           |  9 +++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c       | 16 ++++++-----
 6 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 34d49e171fb4..653fe018e6b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -545,6 +545,7 @@ enum iwl_trans_state {
  *	Set during transport allocation.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @pm_support: set to true in start_hw if link pm is supported
+ * @ltr_enabled: set to true if the LTR is enabled
  * @dev_cmd_pool: pool for Tx cmd allocation - for internal use only.
  *	The user should use iwl_trans_{alloc,free}_tx_cmd.
  * @dev_cmd_headroom: room needed for the transport's private use before the
@@ -571,6 +572,7 @@ struct iwl_trans {
 	u8 rx_mpdu_cmd, rx_mpdu_cmd_hdr_size;
 
 	bool pm_support;
+	bool ltr_enabled;
 
 	/* The following fields are internal only */
 	struct kmem_cache *dev_cmd_pool;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index cbbcd8e284e4..ebfe23d8dd1f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -66,13 +66,46 @@
 
 /* Power Management Commands, Responses, Notifications */
 
+/**
+ * enum iwl_ltr_config_flags - masks for LTR config command flags
+ * @LTR_CFG_FLAG_FEATURE_ENABLE: Feature operational status
+ * @LTR_CFG_FLAG_HW_DIS_ON_SHADOW_REG_ACCESS: allow LTR change on shadow
+ *	memory access
+ * @LTR_CFG_FLAG_HW_EN_SHRT_WR_THROUGH: allow LTR msg send on ANY LTR
+ *	reg change
+ * @LTR_CFG_FLAG_HW_DIS_ON_D0_2_D3: allow LTR msg send on transition from
+ *	D0 to D3
+ * @LTR_CFG_FLAG_SW_SET_SHORT: fixed static short LTR register
+ * @LTR_CFG_FLAG_SW_SET_LONG: fixed static short LONG register
+ * @LTR_CFG_FLAG_DENIE_C10_ON_PD: allow going into C10 on PD
+ */
+enum iwl_ltr_config_flags {
+	LTR_CFG_FLAG_FEATURE_ENABLE = BIT(0),
+	LTR_CFG_FLAG_HW_DIS_ON_SHADOW_REG_ACCESS = BIT(1),
+	LTR_CFG_FLAG_HW_EN_SHRT_WR_THROUGH = BIT(2),
+	LTR_CFG_FLAG_HW_DIS_ON_D0_2_D3 = BIT(3),
+	LTR_CFG_FLAG_SW_SET_SHORT = BIT(4),
+	LTR_CFG_FLAG_SW_SET_LONG = BIT(5),
+	LTR_CFG_FLAG_DENIE_C10_ON_PD = BIT(6),
+};
+
+/**
+ * struct iwl_ltr_config_cmd - configures the LTR
+ * @flags: See %enum iwl_ltr_config_flags
+ */
+struct iwl_ltr_config_cmd {
+	__le32 flags;
+	__le32 static_long;
+	__le32 static_short;
+} __packed;
+
 /* Radio LP RX Energy Threshold measured in dBm */
 #define POWER_LPRX_RSSI_THRESHOLD	75
 #define POWER_LPRX_RSSI_THRESHOLD_MAX	94
 #define POWER_LPRX_RSSI_THRESHOLD_MIN	30
 
 /**
- * enum iwl_scan_flags - masks for power table command flags
+ * enum iwl_power_flags - masks for power table command flags
  * @POWER_FLAGS_POWER_SAVE_ENA_MSK: '1' Allow to save power by turning off
  *		receiver and transmitter. '0' - does not allow.
  * @POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK: '0' Driver disables power management,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 67363080f83d..41a181683a00 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -144,6 +144,7 @@ enum {
 	/* Power - legacy power table command */
 	POWER_TABLE_CMD = 0x77,
 	PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION = 0x78,
+	LTR_CONFIG = 0xee,
 
 	/* Thermal Throttling*/
 	REPLY_THERMAL_MNG_BACKOFF = 0x7e,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 883e702152d5..bf720a875e6b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -475,6 +475,15 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	/* Initialize tx backoffs to the minimal possible */
 	iwl_mvm_tt_tx_backoff(mvm, 0);
 
+	if (mvm->trans->ltr_enabled) {
+		struct iwl_ltr_config_cmd cmd = {
+			.flags = cpu_to_le32(LTR_CFG_FLAG_FEATURE_ENABLE),
+		};
+
+		WARN_ON(iwl_mvm_send_cmd_pdu(mvm, LTR_CONFIG, 0,
+					     sizeof(cmd), &cmd));
+	}
+
 	ret = iwl_mvm_power_update_device(mvm);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index cc2f7de396de..6b4f3525fdca 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -323,6 +323,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(REPLY_BEACON_FILTERING_CMD),
 	CMD(REPLY_THERMAL_MNG_BACKOFF),
 	CMD(MAC_PM_POWER_TABLE),
+	CMD(LTR_CONFIG),
 	CMD(BT_COEX_CI),
 	CMD(PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION),
 	CMD(ANTENNA_COUPLING_NOTIFICATION),
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 788085bc65d7..3aefff039df0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -109,6 +109,7 @@ static void iwl_pcie_apm_config(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u16 lctl;
+	u16 cap;
 
 	/*
 	 * HW bug W/A for instability in PCIe bus L0S->L1 transition.
@@ -119,16 +120,17 @@ static void iwl_pcie_apm_config(struct iwl_trans *trans)
 	 *    power savings, even without L1.
 	 */
 	pcie_capability_read_word(trans_pcie->pci_dev, PCI_EXP_LNKCTL, &lctl);
-	if (lctl & PCI_EXP_LNKCTL_ASPM_L1) {
-		/* L1-ASPM enabled; disable(!) L0S */
+	if (lctl & PCI_EXP_LNKCTL_ASPM_L1)
 		iwl_set_bit(trans, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
-		dev_info(trans->dev, "L1 Enabled; Disabling L0S\n");
-	} else {
-		/* L1-ASPM disabled; enable(!) L0S */
+	else
 		iwl_clear_bit(trans, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
-		dev_info(trans->dev, "L1 Disabled; Enabling L0S\n");
-	}
 	trans->pm_support = !(lctl & PCI_EXP_LNKCTL_ASPM_L0S);
+
+	pcie_capability_read_word(trans_pcie->pci_dev, PCI_EXP_DEVCTL2, &cap);
+	trans->ltr_enabled = cap & PCI_EXP_DEVCTL2_LTR_EN;
+	dev_info(trans->dev, "L1 %sabled - LTR %sabled\n",
+		 (lctl & PCI_EXP_LNKCTL_ASPM_L1) ? "En" : "Dis",
+		 trans->ltr_enabled ? "En" : "Dis");
 }
 
 /*
-- 
2.1.0

