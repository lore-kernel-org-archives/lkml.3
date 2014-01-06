Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343AbaAFXZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:25:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871AbaAFWk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathy Vanhoef <vanhoefm@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 056/129] ath9k_htc: properly set MAC address and BSSID mask
Date: Mon,  6 Jan 2014 14:38:05 -0800
Message-Id: <20140106223901.205715393@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathy Vanhoef <vanhoefm@gmail.com>

commit 657eb17d87852c42b55c4b06d5425baa08b2ddb3 upstream.

Pick the MAC address of the first virtual interface as the new hardware MAC
address. Set BSSID mask according to this MAC address. This fixes CVE-2013-4579.

Signed-off-by: Mathy Vanhoef <vanhoefm@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   25 +++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/main.c         |    5 +++--
 2 files changed, 20 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -145,21 +145,26 @@ static void ath9k_htc_bssid_iter(void *d
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
@@ -171,6 +176,10 @@ static void ath9k_htc_set_bssid_mask(str
 		ath9k_htc_bssid_iter, &iter_data);
 
 	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
+
+	if (iter_data.hw_macaddr)
+		memcpy(common->macaddr, iter_data.hw_macaddr, ETH_ALEN);
+
 	ath_hw_setbssidmask(common);
 }
 
@@ -1076,7 +1085,7 @@ static int ath9k_htc_add_interface(struc
 		goto out;
 	}
 
-	ath9k_htc_set_bssid_mask(priv, vif);
+	ath9k_htc_set_mac_bssid_mask(priv, vif);
 
 	priv->vif_slot |= (1 << avp->index);
 	priv->nvifs++;
@@ -1139,7 +1148,7 @@ static void ath9k_htc_remove_interface(s
 
 	ath9k_htc_set_opmode(priv);
 
-	ath9k_htc_set_bssid_mask(priv, vif);
+	ath9k_htc_set_mac_bssid_mask(priv, vif);
 
 	/*
 	 * Stop ANI only if there are no associated station interfaces.
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -889,8 +889,9 @@ void ath9k_calculate_iter_data(struct ie
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	/*
-	 * Use the hardware MAC address as reference, the hardware uses it
-	 * together with the BSSID mask when matching addresses.
+	 * Pick the MAC address of the first interface as the new hardware
+	 * MAC address. The hardware will use it together with the BSSID mask
+	 * when matching addresses.
 	 */
 	memset(iter_data, 0, sizeof(*iter_data));
 	memset(&iter_data->mask, 0xff, ETH_ALEN);


