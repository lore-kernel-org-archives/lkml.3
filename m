Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab3FEWHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:07:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925Ab3FEVfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Bondar <alexander.bondar@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 017/127] iwlwifi: mvm: Prevent setting assoc flag in MAC_CONTEXT_CMD
Date: Wed,  5 Jun 2013 14:33:04 -0700
Message-Id: <20130605213219.977295867@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Bondar <alexander.bondar@intel.com>

commit ba283927268d45184c17c37ff78d427e59026229 upstream.

In the normal flow first MAC_CONTEXT_CMD for particular interface is
never sent while associated. The exception is fw restart flow when
resuming from suspend when WoWLAN is enabled. In this case successive
"add" and "modify" MAC_CONTEXT_CMD commands may be sent with assoc flag
set what cause FW mal functioning. To prevent this never set assoc flag
in MAC_CONTEXT_CMD with action "add".

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -586,10 +586,12 @@ static int iwl_mvm_mac_ctxt_send_cmd(str
  */
 static void iwl_mvm_mac_ctxt_cmd_fill_sta(struct iwl_mvm *mvm,
 					  struct ieee80211_vif *vif,
-					  struct iwl_mac_data_sta *ctxt_sta)
+					  struct iwl_mac_data_sta *ctxt_sta,
+					  bool force_assoc_off)
 {
 	/* We need the dtim_period to set the MAC as associated */
-	if (vif->bss_conf.assoc && vif->bss_conf.dtim_period) {
+	if (vif->bss_conf.assoc && vif->bss_conf.dtim_period &&
+	    !force_assoc_off) {
 		u32 dtim_offs;
 
 		/*
@@ -652,7 +654,8 @@ static int iwl_mvm_mac_ctxt_cmd_station(
 	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
 
 	/* Fill the data specific for station mode */
-	iwl_mvm_mac_ctxt_cmd_fill_sta(mvm, vif, &cmd.sta);
+	iwl_mvm_mac_ctxt_cmd_fill_sta(mvm, vif, &cmd.sta,
+				      action == FW_CTXT_ACTION_ADD);
 
 	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
 }
@@ -669,7 +672,8 @@ static int iwl_mvm_mac_ctxt_cmd_p2p_clie
 	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
 
 	/* Fill the data specific for station mode */
-	iwl_mvm_mac_ctxt_cmd_fill_sta(mvm, vif, &cmd.p2p_sta.sta);
+	iwl_mvm_mac_ctxt_cmd_fill_sta(mvm, vif, &cmd.p2p_sta.sta,
+				      action == FW_CTXT_ACTION_ADD);
 
 	cmd.p2p_sta.ctwin = cpu_to_le32(vif->bss_conf.p2p_ctwindow);
 


