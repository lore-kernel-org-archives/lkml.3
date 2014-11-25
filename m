Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaKYLMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:12:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58840 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbaKYKmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 167/254] iwlwifi: fix RFkill while calibrating
Date: Tue, 25 Nov 2014 10:38:37 +0000
Message-Id: <1416912004-5928-168-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 31b8b343e019e0a0c57ca9c13520a87f9cab884b upstream.

If the RFkill interrupt fires while we calibrate, it would
make the firmware fail and the driver wasn't able to recover.
Change the flow so that the driver will kill the firmware
in that case.

Since we have now two flows that are calling
trans_stop_device (the RFkill interrupt and the
op_mode_mvm_start function) - we need to better sync this.
Use the STATUS_DEVICE_ENABLED in the pcie transport in an
atomic way to achieve this.

This fixes: https://bugzilla.kernel.org/show_bug.cgi?id=86231

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[ luis: used Emmanuel's backport to 3.17 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c       | 10 +++++++++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      | 11 ++++++++++-
 drivers/net/wireless/iwlwifi/pcie/trans.c   |  4 ++--
 5 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index bf720a875e6b..c77e6bcc63d5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -282,7 +282,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (WARN_ON_ONCE(mvm->init_ucode_complete))
+	if (WARN_ON_ONCE(mvm->init_ucode_complete || mvm->calibrating))
 		return 0;
 
 	iwl_init_notification_wait(&mvm->notif_wait,
@@ -332,6 +332,8 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 		goto out;
 	}
 
+	mvm->calibrating = true;
+
 	/* Send TX valid antennas before triggering calibrations */
 	ret = iwl_send_tx_ant_cfg(mvm, mvm->fw->valid_tx_ant);
 	if (ret)
@@ -356,11 +358,17 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 			MVM_UCODE_CALIB_TIMEOUT);
 	if (!ret)
 		mvm->init_ucode_complete = true;
+
+	if (ret && iwl_mvm_is_radio_killed(mvm)) {
+		IWL_DEBUG_RF_KILL(mvm, "RFKILL while calibrating.\n");
+		ret = 1;
+	}
 	goto out;
 
 error:
 	iwl_remove_notification(&mvm->notif_wait, &calib_wait);
 out:
+	mvm->calibrating = false;
 	if (iwlmvm_mod_params.init_dbg && !mvm->nvm_data) {
 		/* we want to debug INIT and we have no NVM - fake */
 		mvm->nvm_data = kzalloc(sizeof(struct iwl_nvm_data) +
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 98556d03c1ed..08572e212d8f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -651,6 +651,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	iwl_trans_stop_device(mvm->trans);
 
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
+	mvm->calibrating = false;
 
 	/* just in case one was running */
 	ieee80211_remain_on_channel_expired(mvm->hw);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index fcc6c29482d0..a20f882af758 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -486,6 +486,7 @@ struct iwl_mvm {
 	enum iwl_ucode_type cur_ucode;
 	bool ucode_loaded;
 	bool init_ucode_complete;
+	bool calibrating;
 	u32 error_event_table;
 	u32 log_event_table;
 	u32 umac_error_event_table;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 6b4f3525fdca..1cacf0f55d9a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -718,6 +718,7 @@ void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state)
 static bool iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+	bool calibrating = ACCESS_ONCE(mvm->calibrating);
 
 	if (state)
 		set_bit(IWL_MVM_STATUS_HW_RFKILL, &mvm->status);
@@ -726,7 +727,15 @@ static bool iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 
 	wiphy_rfkill_set_hw_state(mvm->hw->wiphy, iwl_mvm_is_radio_killed(mvm));
 
-	return state && mvm->cur_ucode != IWL_UCODE_INIT;
+	/* iwl_run_init_mvm_ucode is waiting for results, abort it */
+	if (calibrating)
+		iwl_abort_notification_waits(&mvm->notif_wait);
+
+	/*
+	 * Stop the device if we run OPERATIONAL firmware or if we are in the
+	 * middle of the calibrations.
+	 */
+	return state && (mvm->cur_ucode != IWL_UCODE_INIT || calibrating);
 }
 
 static void iwl_mvm_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 3aefff039df0..9788fc59c13b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -835,7 +835,8 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	 * restart. So don't process again if the device is
 	 * already dead.
 	 */
-	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
+	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
+		IWL_DEBUG_INFO(trans, "DEVICE_ENABLED bit was set and is now cleared\n");
 		iwl_pcie_tx_stop(trans);
 		iwl_pcie_rx_stop(trans);
 
@@ -865,7 +866,6 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	/* clear all status bits */
 	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 	clear_bit(STATUS_INT_ENABLED, &trans->status);
-	clear_bit(STATUS_DEVICE_ENABLED, &trans->status);
 	clear_bit(STATUS_TPOWER_PMI, &trans->status);
 	clear_bit(STATUS_RFKILL, &trans->status);
 
-- 
2.1.0

