Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaAMOqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:46:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaAMO00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathy Vanhoef <vanhoefm@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 59/96] ath9k_htc: properly set MAC address and BSSID mask
Date: Mon, 13 Jan 2014 14:24:22 +0000
Message-Id: <1389623099-18783-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathy Vanhoef <vanhoefm@gmail.com>

commit 657eb17d87852c42b55c4b06d5425baa08b2ddb3 upstream.

Pick the MAC address of the first virtual interface as the new hardware MAC
address. Set BSSID mask according to this MAC address. This fixes CVE-2013-4579.

Signed-off-by: Mathy Vanhoef <vanhoefm@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 25 +++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/main.c         |  5 +++--
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index abbd6ef..204619e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -139,21 +139,26 @@ static void ath9k_htc_bssid_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	struct ath9k_vif_iter_data *iter_data = data;
 	int i;
 
-	for (i = 0; i < ETH_ALEN; i++)
-		iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
+	if (iter_data->hw_macaddr != NULL) {
+		for (i = 0; i < ETH_ALEN; i++)
+			iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
+	} else {
+		iter_data->hw_macaddr = mac;
+	}
 }
 
-static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
+static void ath9k_htc_set_mac_bssid_mask(struct ath9k_htc_priv *priv,
 				     struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_vif_iter_data iter_data;
 
 	/*
-	 * Use the hardware MAC address as reference, the hardware uses it
-	 * together with the BSSID mask when matching addresses.
+	 * Pick the MAC address of the first interface as the new hardware
+	 * MAC address. The hardware will use it together with the BSSID mask
+	 * when matching addresses.
 	 */
-	iter_data.hw_macaddr = common->macaddr;
+	iter_data.hw_macaddr = NULL;
 	memset(&iter_data.mask, 0xff, ETH_ALEN);
 
 	if (vif)
@@ -164,6 +169,10 @@ static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
 						   &iter_data);
 
 	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
+
+	if (iter_data.hw_macaddr)
+		memcpy(common->macaddr, iter_data.hw_macaddr, ETH_ALEN);
+
 	ath_hw_setbssidmask(common);
 }
 
@@ -1091,7 +1100,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ath9k_htc_set_bssid_mask(priv, vif);
+	ath9k_htc_set_mac_bssid_mask(priv, vif);
 
 	priv->vif_slot |= (1 << avp->index);
 	priv->nvifs++;
@@ -1154,7 +1163,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 
 	ath9k_htc_set_opmode(priv);
 
-	ath9k_htc_set_bssid_mask(priv, vif);
+	ath9k_htc_set_mac_bssid_mask(priv, vif);
 
 	/*
 	 * Stop ANI only if there are no associated station interfaces.
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 278ce3d..2b9207e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1297,8 +1297,9 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	/*
-	 * Use the hardware MAC address as reference, the hardware uses it
-	 * together with the BSSID mask when matching addresses.
+	 * Pick the MAC address of the first interface as the new hardware
+	 * MAC address. The hardware will use it together with the BSSID mask
+	 * when matching addresses.
 	 */
 	memset(iter_data, 0, sizeof(*iter_data));
 	iter_data->hw_macaddr = common->macaddr;
-- 
1.8.3.2

