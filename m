Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaHTJnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:43:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:60163 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaHTJm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:42:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,901,1400050800"; 
   d="scan'208";a="587369893"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 05/11] wireless: libertas: print esaped string via %*pE
Date: Wed, 20 Aug 2014 12:42:46 +0300
Message-Id: <1408527772-27224-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach this allows to print escaped strings via recently
added kernel extension: %*pE.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/libertas/cfg.c  | 8 ++------
 drivers/net/wireless/libertas/mesh.c | 7 +++----
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 47a998d..1188814 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -590,7 +590,6 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 		int chan_no = -1;
 		const u8 *ssid = NULL;
 		u8 ssid_len = 0;
-		DECLARE_SSID_BUF(ssid_buf);
 
 		int len = get_unaligned_le16(pos);
 		pos += 2;
@@ -644,10 +643,8 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 			struct ieee80211_channel *channel =
 				ieee80211_get_channel(wiphy, freq);
 
-			lbs_deb_scan("scan: %pM, capa %04x, chan %2d, %s, "
-				     "%d dBm\n",
-				     bssid, capa, chan_no,
-				     print_ssid(ssid_buf, ssid, ssid_len),
+			lbs_deb_scan("scan: %pM, capa %04x, chan %2d, %*pE, %d dBm\n",
+				     bssid, capa, chan_no, ssid_len, ssid,
 				     LBS_SCAN_RSSI_TO_MBM(rssi)/100);
 
 			if (channel &&
@@ -1982,7 +1979,6 @@ static int lbs_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	struct lbs_private *priv = wiphy_priv(wiphy);
 	int ret = 0;
 	struct cfg80211_bss *bss;
-	DECLARE_SSID_BUF(ssid_buf);
 
 	if (dev == priv->mesh_dev)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index 01a67f6..d0c881d 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -93,7 +93,6 @@ static int lbs_mesh_config(struct lbs_private *priv, uint16_t action,
 {
 	struct cmd_ds_mesh_config cmd;
 	struct mrvl_meshie *ie;
-	DECLARE_SSID_BUF(ssid);
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.channel = cpu_to_le16(chan);
@@ -122,9 +121,9 @@ static int lbs_mesh_config(struct lbs_private *priv, uint16_t action,
 	default:
 		return -1;
 	}
-	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %s\n",
-		    action, priv->mesh_tlv, chan,
-		    print_ssid(ssid, priv->mesh_ssid, priv->mesh_ssid_len));
+	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %*pE\n",
+		    action, priv->mesh_tlv, chan, priv->mesh_ssid_len,
+		    priv->mesh_ssid);
 
 	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
 }
-- 
2.1.0

