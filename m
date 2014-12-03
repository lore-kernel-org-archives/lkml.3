Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaLCLzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:55:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaLCL1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:14 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 017/101] iwlwifi: configure the LTR
Date: Wed,  3 Dec 2014 12:25:39 +0100
Message-Id: <9546673d9dc0c6c642d7f4740622d15d7fb980f9.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9180ac50716a097a407c6d7e7e4589754a922260 upstream.

The LTR is the handshake between the device and the root
complex about the latency allowed when the bus exits power
save. This configuration was missing and this led to high
latency in the link power up. The end user could experience
high latency in the network because of this.

Cc: <stable@vger.kernel.org> [3.10+]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h        |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 35 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |  1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c           |  9 +++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c       | 16 ++++++-----
 6 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 80b47508647c..c8d1e378f631 100644
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
index 8e7ab41079ca..4dacb20bf490 100644
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
index 66264cc5a016..cd59ae18ea8f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -138,6 +138,7 @@ enum {
 
 	/* Power - legacy power table command */
 	POWER_TABLE_CMD = 0x77,
+	LTR_CONFIG = 0xee,
 
 	/* Thermal Throttling*/
 	REPLY_THERMAL_MNG_BACKOFF = 0x7e,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index c76299a3a1e0..08f12006ca77 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -424,6 +424,15 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
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
 	IWL_DEBUG_INFO(mvm, "RT uCode started.\n");
 	return 0;
  error:
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 1fd08baa0d32..e3cdc97380d3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -303,6 +303,7 @@ static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(REPLY_BEACON_FILTERING_CMD),
 	CMD(REPLY_THERMAL_MNG_BACKOFF),
 	CMD(MAC_PM_POWER_TABLE),
+	CMD(LTR_CONFIG),
 };
 #undef CMD
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index dc875f4befef..67536a26df39 100644
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
2.1.3

