Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967536Ab3HICSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:18:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967479Ab3HIB6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 032/102] iwlwifi: mvm: refuse connection to APs with BI < 16
Date: Thu,  8 Aug 2013 18:57:08 -0700
Message-Id: <20130809015017.372088046@linuxfoundation.org>
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

commit 48bc13072109ea58465542aa1ee31b4e1065468a upstream.

Due to a firmware bug, it crashes when the beacon interval
is smaller than 16. Avoid this by refusing the station state
change creating the AP station, causing mac80211 to abandon
the attempt to connect to the AP, and eventually wpa_s to
blacklist it.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -987,6 +987,21 @@ static int iwl_mvm_mac_sta_state(struct
 	mutex_lock(&mvm->mutex);
 	if (old_state == IEEE80211_STA_NOTEXIST &&
 	    new_state == IEEE80211_STA_NONE) {
+		/*
+		 * Firmware bug - it'll crash if the beacon interval is less
+		 * than 16. We can't avoid connecting at all, so refuse the
+		 * station state change, this will cause mac80211 to abandon
+		 * attempts to connect to this AP, and eventually wpa_s will
+		 * blacklist the AP...
+		 */
+		if (vif->type == NL80211_IFTYPE_STATION &&
+		    vif->bss_conf.beacon_int < 16) {
+			IWL_ERR(mvm,
+				"AP %pM beacon interval is %d, refusing due to firmware bug!\n",
+				sta->addr, vif->bss_conf.beacon_int);
+			ret = -EINVAL;
+			goto out_unlock;
+		}
 		ret = iwl_mvm_add_sta(mvm, vif, sta);
 	} else if (old_state == IEEE80211_STA_NONE &&
 		   new_state == IEEE80211_STA_AUTH) {
@@ -1015,6 +1030,7 @@ static int iwl_mvm_mac_sta_state(struct
 	} else {
 		ret = -EIO;
 	}
+ out_unlock:
 	mutex_unlock(&mvm->mutex);
 
 	return ret;


