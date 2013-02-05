Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3BEWX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:23:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48041 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab3BEWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:28 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 44/93] iwlegacy: fix IBSS cleanup
Date: Tue,  5 Feb 2013 20:06:33 -0200
Message-Id: <1360102042-10732-45-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit fa4cffcba9e13798ed7c6b8526b91b1631ecb53e upstream.

We do not correctly change interface type when switching from
IBSS mode to STA mode, that results in microcode errors.

Resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=886946

Reported-by: Jaroslav Skarvada <jskarvad@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/iwlegacy/common.c |   35 +++++++++++++-------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 5d4807c..82374de 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -3957,17 +3957,21 @@ il_connection_init_rx_config(struct il_priv *il)
 
 	memset(&il->staging, 0, sizeof(il->staging));
 
-	if (!il->vif) {
+	switch (il->iw_mode) {
+	case NL80211_IFTYPE_UNSPECIFIED:
 		il->staging.dev_type = RXON_DEV_TYPE_ESS;
-	} else if (il->vif->type == NL80211_IFTYPE_STATION) {
+		break;
+	case NL80211_IFTYPE_STATION:
 		il->staging.dev_type = RXON_DEV_TYPE_ESS;
 		il->staging.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
-	} else if (il->vif->type == NL80211_IFTYPE_ADHOC) {
+		break;
+	case NL80211_IFTYPE_ADHOC:
 		il->staging.dev_type = RXON_DEV_TYPE_IBSS;
 		il->staging.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
 		il->staging.filter_flags =
 		    RXON_FILTER_BCON_AWARE_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
-	} else {
+		break;
+	default:
 		IL_ERR("Unsupported interface type %d\n", il->vif->type);
 		return;
 	}
@@ -4550,8 +4554,7 @@ out:
 EXPORT_SYMBOL(il_mac_add_interface);
 
 static void
-il_teardown_interface(struct il_priv *il, struct ieee80211_vif *vif,
-		      bool mode_change)
+il_teardown_interface(struct il_priv *il, struct ieee80211_vif *vif)
 {
 	lockdep_assert_held(&il->mutex);
 
@@ -4560,9 +4563,7 @@ il_teardown_interface(struct il_priv *il, struct ieee80211_vif *vif,
 		il_force_scan_end(il);
 	}
 
-	if (!mode_change)
-		il_set_mode(il);
-
+	il_set_mode(il);
 }
 
 void
@@ -4575,8 +4576,8 @@ il_mac_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	WARN_ON(il->vif != vif);
 	il->vif = NULL;
-
-	il_teardown_interface(il, vif, false);
+	il->iw_mode = NL80211_IFTYPE_UNSPECIFIED;
+	il_teardown_interface(il, vif);
 	memset(il->bssid, 0, ETH_ALEN);
 
 	D_MAC80211("leave\n");
@@ -4685,18 +4686,10 @@ il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 
 	/* success */
-	il_teardown_interface(il, vif, true);
 	vif->type = newtype;
 	vif->p2p = false;
-	err = il_set_mode(il);
-	WARN_ON(err);
-	/*
-	 * We've switched internally, but submitting to the
-	 * device may have failed for some reason. Mask this
-	 * error, because otherwise mac80211 will not switch
-	 * (and set the interface type back) and we'll be
-	 * out of sync with it.
-	 */
+	il->iw_mode = newtype;
+	il_teardown_interface(il, vif);
 	err = 0;
 
 out:
-- 
1.7.9.5

