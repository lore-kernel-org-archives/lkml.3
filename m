Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab3E1VWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:22:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59545 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab3E1VVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 13/78] ath9k: fix key allocation error handling for powersave keys
Date: Tue, 28 May 2013 14:19:22 -0700
Message-Id: <1369776027-17859-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 4ef69d0394cba8caa9f75d3f2e53429bfb8b3045 upstream.

If no keycache slots are available, ath_key_config can return -ENOSPC.
If the key index is not checked for errors, it can lead to logspam that
looks like this: "ath: wiphy0: keyreset: keycache entry 228 out of range"
This can cause follow-up errors if the invalid keycache index gets
used for tx.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dd91f8f..a929adc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1236,6 +1236,7 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
 	struct ieee80211_key_conf ps_key = { };
+	int key;
 
 	ath_node_attach(sc, sta, vif);
 
@@ -1243,7 +1244,9 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	    vif->type != NL80211_IFTYPE_AP_VLAN)
 		return 0;
 
-	an->ps_key = ath_key_config(common, vif, sta, &ps_key);
+	key = ath_key_config(common, vif, sta, &ps_key);
+	if (key > 0)
+		an->ps_key = key;
 
 	return 0;
 }
@@ -1260,6 +1263,7 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
 	    return;
 
 	ath_key_delete(common, &ps_key);
+	an->ps_key = 0;
 }
 
 static int ath9k_sta_remove(struct ieee80211_hw *hw,
-- 
1.8.1.2

