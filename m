Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967689Ab3HICPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:15:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967569Ab3HIB64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 034/102] iwlwifi: mvm: fix flushing not started aggregation sessions
Date: Thu,  8 Aug 2013 18:57:10 -0700
Message-Id: <20130809015017.807948129@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit b6658ff80c43bcf84be0bbe371c88af1452e7776 upstream.

When a not fully started aggregation session is destroyed
and flushed, we get a warning, e.g.

  WARNING: at drivers/net/wireless/iwlwifi/pcie/tx.c:1142 iwl_trans_pcie_txq_disable+0x11c/0x160
  queue 16 not used
  Modules linked in: [...]
  Pid: 5135, comm: hostapd Tainted: G        W  O 3.5.0 #10
  Call Trace:
  wlan0: driver sets block=0 for sta 00:03:7f:10:44:d3
   [<ffffffff81036492>] warn_slowpath_common+0x72/0xa0
   [<ffffffff81036577>] warn_slowpath_fmt+0x47/0x50
   [<ffffffffa0368d6c>] iwl_trans_pcie_txq_disable+0x11c/0x160 [iwlwifi]
   [<ffffffffa03a2099>] iwl_mvm_sta_tx_agg_flush+0xe9/0x150 [iwlmvm]
   [<ffffffffa0396c43>] iwl_mvm_mac_ampdu_action+0xf3/0x1e0 [iwlmvm]
   [<ffffffffa0293ad3>] ___ieee80211_stop_tx_ba_session+0x193/0x920 [mac80211]
   [<ffffffffa0294ed8>] __ieee80211_stop_tx_ba_session+0x48/0x70 [mac80211]
   [<ffffffffa029159f>] ieee80211_sta_tear_down_BA_sessions+0x4f/0x80 [mac80211]
   [<ffffffffa028a686>] __sta_info_destroy+0x66/0x370 [mac80211]
   [<ffffffffa028abb4>] sta_info_destroy_addr_bss+0x44/0x70 [mac80211]
   [<ffffffffa02a3e26>] ieee80211_del_station+0x26/0x50 [mac80211]
   [<ffffffffa01e6395>] nl80211_del_station+0x85/0x200 [cfg80211]

when a station deauthenticated from us without fully setting
up the aggregation session.

Fix this by checking the aggregation state before removing
the hardware queue.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/sta.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -898,6 +898,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_
 	struct iwl_mvm_sta *mvmsta = (void *)sta->drv_priv;
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
 	u16 txq_id;
+	enum iwl_mvm_agg_state old_state;
 
 	/*
 	 * First set the agg state to OFF to avoid calling
@@ -907,13 +908,17 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_
 	txq_id = tid_data->txq_id;
 	IWL_DEBUG_TX_QUEUES(mvm, "Flush AGG: sta %d tid %d q %d state %d\n",
 			    mvmsta->sta_id, tid, txq_id, tid_data->state);
+	old_state = tid_data->state;
 	tid_data->state = IWL_AGG_OFF;
 	spin_unlock_bh(&mvmsta->lock);
 
-	if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), true))
-		IWL_ERR(mvm, "Couldn't flush the AGG queue\n");
+	if (old_state >= IWL_AGG_ON) {
+		if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), true))
+			IWL_ERR(mvm, "Couldn't flush the AGG queue\n");
+
+		iwl_trans_txq_disable(mvm->trans, tid_data->txq_id);
+	}
 
-	iwl_trans_txq_disable(mvm->trans, tid_data->txq_id);
 	mvm->queue_to_mac80211[tid_data->txq_id] =
 				IWL_INVALID_MAC80211_QUEUE;
 


