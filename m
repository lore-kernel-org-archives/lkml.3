Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830Ab3HNLB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:01:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34377 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759687Ab3HNKhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 04/75] iwlwifi: mvm: refuse connection to APs with BI < 16
Date: Wed, 14 Aug 2013 11:35:53 +0100
Message-Id: <1376476624-10011-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - file renamed: drivers/net/wireless/iwlwifi/mvm/mac80211.c ->
    drivers/net/wireless/iwlwifi/iwl-mac80211.c
  - adjusted context
  - changed IWL_ERR 1st argument to 'priv'
  - removed redundant condition in 'if' statement ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index a0b0b78..2c86c55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -776,9 +776,23 @@ int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		if (old_state == IEEE80211_STA_NOTEXIST &&
-		    new_state == IEEE80211_STA_NONE)
+		    new_state == IEEE80211_STA_NONE) {
+			/*
+			 * Firmware bug - it'll crash if the beacon interval is less
+			 * than 16. We can't avoid connecting at all, so refuse the
+			 * station state change, this will cause mac80211 to abandon
+			 * attempts to connect to this AP, and eventually wpa_s will
+			 * blacklist the AP...
+			 */
+			if (vif->bss_conf.beacon_int < 16) {
+				IWL_ERR(priv,
+					"AP %pM beacon interval is %d, refusing due to firmware bug!\n",
+					sta->addr, vif->bss_conf.beacon_int);
+				ret = -EINVAL;
+				goto out_unlock;
+			}
 			op = ADD;
-		else if (old_state == IEEE80211_STA_NONE &&
+		} else if (old_state == IEEE80211_STA_NONE &&
 			 new_state == IEEE80211_STA_NOTEXIST)
 			op = REMOVE;
 		else if (old_state == IEEE80211_STA_AUTH &&
@@ -846,6 +860,7 @@ int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 	if (iwl_is_rfkill(priv))
 		ret = 0;
 
+out_unlock:
 	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
-- 
1.8.3.2

