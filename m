Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaFDXVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaFDXVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.14 042/228] iwlwifi: mvm: delay enabling smart FIFO until after beacon RX
Date: Wed,  4 Jun 2014 16:21:11 -0700
Message-Id: <20140604232349.426078856@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 0229cdafb6f67064a217591d48b0f6abf14e8385 upstream.

If we have no beacon data before association, delay smart FIFO
enablement until after we have this data.

Not doing so can cause association failures in extremely silent
environments (usually only a shielded box/room) as beacon RX is
not sent to the host immediately, and then the association time
event ends without the host receiving any beacon even though it
was on the air - it's just stuck on the FIFO.

Fixes: 1f3b0ff8ecce ("iwlwifi: mvm: Add Smart FIFO support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    1 +
 drivers/net/wireless/iwlwifi/mvm/sf.c       |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -971,6 +971,7 @@ static void iwl_mvm_bss_info_changed_sta
 		 */
 		iwl_mvm_remove_time_event(mvm, mvmvif,
 					  &mvmvif->time_event_data);
+		iwl_mvm_sf_update(mvm, vif, false);
 	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS |
 			      BSS_CHANGED_QOS)) {
 		ret = iwl_mvm_power_update_mode(mvm, vif);
--- a/drivers/net/wireless/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sf.c
@@ -274,7 +274,8 @@ int iwl_mvm_sf_update(struct iwl_mvm *mv
 				return -EINVAL;
 			if (changed_vif->type != NL80211_IFTYPE_STATION) {
 				new_state = SF_UNINIT;
-			} else if (changed_vif->bss_conf.assoc) {
+			} else if (changed_vif->bss_conf.assoc &&
+				   changed_vif->bss_conf.dtim_period) {
 				mvmvif = iwl_mvm_vif_from_mac80211(changed_vif);
 				sta_id = mvmvif->ap_sta_id;
 				new_state = SF_FULL_ON;


