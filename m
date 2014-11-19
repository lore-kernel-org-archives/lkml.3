Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbaKSWKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:10:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331AbaKSVEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luciano Coelho <luciano.coelho@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.17 141/141] iwlwifi: fix RFkill while calibrating
Date: Wed, 19 Nov 2014 12:52:44 -0800
Message-Id: <20141119205155.594106411@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/fw.c       |   10 +++++++++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      |   11 ++++++++++-
 drivers/net/wireless/iwlwifi/pcie/trans.c   |    4 ++--
 5 files changed, 23 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -282,7 +282,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mv
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (WARN_ON_ONCE(mvm->init_ucode_complete))
+	if (WARN_ON_ONCE(mvm->init_ucode_complete || mvm->calibrating))
 		return 0;
 
 	iwl_init_notification_wait(&mvm->notif_wait,
@@ -332,6 +332,8 @@ int iwl_run_init_mvm_ucode(struct iwl_mv
 		goto out;
 	}
 
+	mvm->calibrating = true;
+
 	/* Send TX valid antennas before triggering calibrations */
 	ret = iwl_send_tx_ant_cfg(mvm, mvm->fw->valid_tx_ant);
 	if (ret)
@@ -356,11 +358,17 @@ int iwl_run_init_mvm_ucode(struct iwl_mv
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
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -778,6 +778,7 @@ static void iwl_mvm_restart_cleanup(stru
 	iwl_trans_stop_device(mvm->trans);
 
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
+	mvm->calibrating = false;
 
 	/* just in case one was running */
 	ieee80211_remain_on_channel_expired(mvm->hw);
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -541,6 +541,7 @@ struct iwl_mvm {
 	enum iwl_ucode_type cur_ucode;
 	bool ucode_loaded;
 	bool init_ucode_complete;
+	bool calibrating;
 	u32 error_event_table;
 	u32 log_event_table;
 	u32 umac_error_event_table;
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -745,6 +745,7 @@ void iwl_mvm_set_hw_ctkill_state(struct
 static bool iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+	bool calibrating = ACCESS_ONCE(mvm->calibrating);
 
 	if (state)
 		set_bit(IWL_MVM_STATUS_HW_RFKILL, &mvm->status);
@@ -753,7 +754,15 @@ static bool iwl_mvm_set_hw_rfkill_state(
 
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
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -913,7 +913,8 @@ static void iwl_trans_pcie_stop_device(s
 	 * restart. So don't process again if the device is
 	 * already dead.
 	 */
-	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
+	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
+		IWL_DEBUG_INFO(trans, "DEVICE_ENABLED bit was set and is now cleared\n");
 		iwl_pcie_tx_stop(trans);
 		iwl_pcie_rx_stop(trans);
 
@@ -943,7 +944,6 @@ static void iwl_trans_pcie_stop_device(s
 	/* clear all status bits */
 	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 	clear_bit(STATUS_INT_ENABLED, &trans->status);
-	clear_bit(STATUS_DEVICE_ENABLED, &trans->status);
 	clear_bit(STATUS_TPOWER_PMI, &trans->status);
 	clear_bit(STATUS_RFKILL, &trans->status);
 


