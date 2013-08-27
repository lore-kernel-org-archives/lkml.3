Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3H0B0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:26:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3H0BG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:06:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 12/74] iwlwifi: mvm: dont set the MCAST queue in STAs queue list
Date: Mon, 26 Aug 2013 18:08:10 -0700
Message-Id: <20130827010427.194362877@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 837fb69f10588caafc883c4473a864660e1403ce upstream.

The MCAST queue should be enabled after DTIM only.
According to fw API, the MCAST must not be attached to any
station, but should appear in the mcast_qid of the AP's
mac context only.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |    5 +----
 drivers/net/wireless/iwlwifi/mvm/sta.c      |    3 ---
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -193,14 +193,11 @@ static void iwl_mvm_mac_iface_iterator(v
 u32 iwl_mvm_mac_get_queues_mask(struct iwl_mvm *mvm,
 				struct ieee80211_vif *vif)
 {
-	u32 qmask, ac;
+	u32 qmask = 0, ac;
 
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
 		return BIT(IWL_MVM_OFFCHANNEL_QUEUE);
 
-	qmask = (vif->cab_queue != IEEE80211_INVAL_HW_QUEUE) ?
-		BIT(vif->cab_queue) : 0;
-
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 		if (vif->hw_queue[ac] != IEEE80211_INVAL_HW_QUEUE)
 			qmask |= BIT(vif->hw_queue[ac]);
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -226,9 +226,6 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		if (vif->hw_queue[i] != IEEE80211_INVAL_HW_QUEUE)
 			mvm_sta->tfd_queue_msk |= BIT(vif->hw_queue[i]);
 
-	if (vif->cab_queue != IEEE80211_INVAL_HW_QUEUE)
-		mvm_sta->tfd_queue_msk |= BIT(vif->cab_queue);
-
 	/* for HW restart - need to reset the seq_number etc... */
 	memset(mvm_sta->tid_data, 0, sizeof(mvm_sta->tid_data));
 


