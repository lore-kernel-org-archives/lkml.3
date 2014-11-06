Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaKFWi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:38:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58527 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaKFWiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:38:51 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 132/162] iwlwifi: configure the LTR
Date: Thu,  6 Nov 2014 14:36:36 -0800
Message-Id: <1415313426-9622-133-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 9180ac50716a097a407c6d7e7e4589754a922260 upstream.

The LTR is the handshake between the device and the root
complex about the latency allowed when the bus exits power
save. This configuration was missing and this led to high
latency in the link power up. The end user could experience
high latency in the network because of this.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h        |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 35 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |  1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c           |  9 +++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c       | 16 ++++++-----
 6 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 143292b..2379419 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -484,6 +484,7 @@ enum iwl_trans_state {
  *	Set during transport allocation.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @pm_support: set to true in start_hw if link pm is supported
+ * @ltr_enabled: set to true if the LTR is enabled
  * @dev_cmd_pool: pool for Tx cmd allocation - for internal use only.
  *	The user should use iwl_trans_{alloc,free}_tx_cmd.
  * @dev_cmd_headroom: room needed for the transport's private use before the
@@ -508,6 +509,7 @@ struct iwl_trans {
 	u8 rx_mpdu_cmd, rx_mpdu_cmd_hdr_size;
 
 	bool pm_support;
+	bool ltr_enabled;
 
 	/* The following fields are internal only */
 	struct kmem_cache *dev_cmd_pool;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index 5cb93ae..71eee38 100644
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
index bad5a55..c079783 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -141,6 +141,7 @@ enum {
 
 	/* Power - legacy power table command */
 	POWER_TABLE_CMD = 0x77,
+	LTR_CONFIG = 0xee,
 
 	/* Thermal Throttling*/
 	REPLY_THERMAL_MNG_BACKOFF = 0x7e,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 70e5297..d6de231 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -431,6 +431,15 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 			goto error;
 	}
 
+	if (mvm->trans->ltr_enabled) {
+		struct iwl_ltr_config_cmd cmd = {
+			.flags = cpu_to_le32(LTR_CFG_FLAG_FEATURE_ENABLE),
+		};
+
+		WARN_ON(iwl_mvm_send_cmd_pdu(mvm, LTR_CONFIG, 0,
+					     sizeof(cmd), &cmd));
+	}
+
 	ret = iwl_mvm_power_update_device_mode(mvm);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index bb58342..50620a7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -310,6 +310,7 @@ static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(REPLY_BEACON_FILTERING_CMD),
 	CMD(REPLY_THERMAL_MNG_BACKOFF),
 	CMD(MAC_PM_POWER_TABLE),
+	CMD(LTR_CONFIG),
 	CMD(BT_COEX_CI),
 };
 #undef CMD
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index f69aeb3..e7b2565 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -121,6 +121,7 @@ static void iwl_pcie_apm_config(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u16 lctl;
+	u16 cap;
 
 	/*
 	 * HW bug W/A for instability in PCIe bus L0S->L1 transition.
@@ -131,16 +132,17 @@ static void iwl_pcie_apm_config(struct iwl_trans *trans)
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
1.9.1

