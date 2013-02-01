Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3BANJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:09:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:44617 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab3BANJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:09:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 26/89] mwifiex: update config_bands during infra association
Date: Fri,  1 Feb 2013 14:07:41 +0100
Message-Id: <20130201130209.370951271@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit d7b9c5204e9c6810a20d509ee47bc70419096e59 upstream.

Currently "adapter->config_bands" is updated during infra
association only if channel is provided by user in "iw connect"
command. config_bands is used while preparing association
request to calculate supported rates by intersecting our rates
with the rates advertised by AP.

There is corner case in which we include zero rates in
supported rates TLV based on previous IBSS network history,
which leads to association failure.

This patch fixes the problem by correctly updating config_bands.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/cfg80211.c  |   15 +--------------
 drivers/net/wireless/mwifiex/sta_ioctl.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1462,7 +1462,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_pr
 	struct cfg80211_ssid req_ssid;
 	int ret, auth_type = 0;
 	struct cfg80211_bss *bss = NULL;
-	u8 is_scanning_required = 0, config_bands = 0;
+	u8 is_scanning_required = 0;
 
 	memset(&req_ssid, 0, sizeof(struct cfg80211_ssid));
 
@@ -1481,19 +1481,6 @@ mwifiex_cfg80211_assoc(struct mwifiex_pr
 	/* disconnect before try to associate */
 	mwifiex_deauthenticate(priv, NULL);
 
-	if (channel) {
-		if (mode == NL80211_IFTYPE_STATION) {
-			if (channel->band == IEEE80211_BAND_2GHZ)
-				config_bands = BAND_B | BAND_G | BAND_GN;
-			else
-				config_bands = BAND_A | BAND_AN;
-
-			if (!((config_bands | priv->adapter->fw_bands) &
-			      ~priv->adapter->fw_bands))
-				priv->adapter->config_bands = config_bands;
-		}
-	}
-
 	/* As this is new association, clear locally stored
 	 * keys and security related flags */
 	priv->sec_info.wpa_enabled = false;
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -265,6 +265,20 @@ int mwifiex_bss_start(struct mwifiex_pri
 		if (ret)
 			goto done;
 
+		if (bss_desc) {
+			u8 config_bands = 0;
+
+			if (mwifiex_band_to_radio_type((u8) bss_desc->bss_band)
+			    == HostCmd_SCAN_RADIO_TYPE_BG)
+				config_bands = BAND_B | BAND_G | BAND_GN;
+			else
+				config_bands = BAND_A | BAND_AN;
+
+			if (!((config_bands | adapter->fw_bands) &
+			      ~adapter->fw_bands))
+				adapter->config_bands = config_bands;
+		}
+
 		ret = mwifiex_check_network_compatibility(priv, bss_desc);
 		if (ret)
 			goto done;


