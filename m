Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3BNDEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:04:41 -0500
Received: from mout.gmx.net ([212.227.17.20]:59835 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3BNDEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:04:40 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18d4B1uXSUd9KivoSFydn4FsSCPeKsSNq7RuCm6dA
	vUIVnqeNS5yJTZ
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Huewe <peterhuewe@gmx.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Sebastian Hahn <snsehahn@cip.cs.fau.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/rtl8192u/ieee80211: Fix buffer overflow in ieee80211_softmac_wx.c
Date: Thu, 14 Feb 2013 04:08:55 +0100
Message-Id: <1360811335-26244-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clang/scan-build complains about a possible buffer overflow in
ieee80211_wx_get_name:

.../staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c:499:3:
warning: String copy function overflows destination buffer
	strcat(wrqu->name," link..");

.../staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c:497:3:
warning: String copy function overflows destination buffer
	strcat(wrqu->name," linked");

The buffer wrqu->name is only IFNAMSIZ bytes big (currently 16),
so if we have a "802.11b/g/n linked" device we overrun the buffer by 3
bytes.

-> Use strlcopy / strlcat to populate the name.
This is done in a similar fashion in
staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c

While at it cleaned some whitespace issues.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |   29 ++++++++++---------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index 45422db..60746b8 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -482,22 +482,23 @@ int ieee80211_wx_get_name(struct ieee80211_device *ieee,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *extra)
 {
-	strcpy(wrqu->name, "802.11");
-	if(ieee->modulation & IEEE80211_CCK_MODULATION){
-		strcat(wrqu->name, "b");
-		if(ieee->modulation & IEEE80211_OFDM_MODULATION)
-			strcat(wrqu->name, "/g");
-	}else if(ieee->modulation & IEEE80211_OFDM_MODULATION)
-		strcat(wrqu->name, "g");
-	if (ieee->mode & (IEEE_N_24G | IEEE_N_5G))
-		strcat(wrqu->name, "/n");
+	strlcpy(wrqu->name, "802.11", IFNAMSIZ);
+	if (ieee->modulation & IEEE80211_CCK_MODULATION) {
+		strlcat(wrqu->name, "b", IFNAMSIZ);
+		if (ieee->modulation & IEEE80211_OFDM_MODULATION)
+			strlcat(wrqu->name, "/g", IFNAMSIZ);
+	} else if (ieee->modulation & IEEE80211_OFDM_MODULATION) {
+		strlcat(wrqu->name, "g", IFNAMSIZ);
+	}
 
-	if((ieee->state == IEEE80211_LINKED) ||
-		(ieee->state == IEEE80211_LINKED_SCANNING))
-		strcat(wrqu->name," linked");
-	else if(ieee->state != IEEE80211_NOLINK)
-		strcat(wrqu->name," link..");
+	if (ieee->mode & (IEEE_N_24G | IEEE_N_5G))
+		strlcat(wrqu->name, "/n", IFNAMSIZ);
 
+	if ((ieee->state == IEEE80211_LINKED) ||
+	    (ieee->state == IEEE80211_LINKED_SCANNING))
+		strlcat(wrqu->name, " linked", IFNAMSIZ);
+	else if (ieee->state != IEEE80211_NOLINK)
+		strlcat(wrqu->name, " link..", IFNAMSIZ);
 
 	return 0;
 }
-- 
1.7.8.6

