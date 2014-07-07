Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaGGPY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:24:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:61235 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbaGGPWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:22:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,618,1400050800"; 
   d="scan'208";a="539766380"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 08/10] staging: wlan-ng: use %*pEhp to print SN
Date: Mon,  7 Jul 2014 18:21:50 +0300
Message-Id: <1404746512-12749-9-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a generic specifier to print an escaped buffer by given criteria. Let's
use it instead of custom approach.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/wlan-ng/prism2sta.c | 28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 209e4db..688e827 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -60,7 +60,6 @@
 #include <linux/netdevice.h>
 #include <linux/workqueue.h>
 #include <linux/byteorder/generic.h>
-#include <linux/ctype.h>
 
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -81,27 +80,6 @@
 #include "hfa384x.h"
 #include "prism2mgmt.h"
 
-/* Create a string of printable chars from something that might not be */
-/* It's recommended that the str be 4*len + 1 bytes long */
-#define wlan_mkprintstr(buf, buflen, str, strlen) \
-{ \
-	int i = 0; \
-	int j = 0; \
-	memset(str, 0, (strlen)); \
-	for (i = 0; i < (buflen); i++) { \
-		if (isprint((buf)[i])) { \
-			(str)[j] = (buf)[i]; \
-			j++; \
-		} else { \
-			(str)[j] = '\\'; \
-			(str)[j+1] = 'x'; \
-			(str)[j+2] = hex_asc_hi((buf)[i]); \
-			(str)[j+3] = hex_asc_lo((buf)[i]); \
-			j += 4; \
-		} \
-	} \
-}
-
 static char *dev_info = "prism2_usb";
 static wlandevice_t *create_wlan(void);
 
@@ -607,7 +585,6 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
 	u16 temp;
 	u8 snum[HFA384x_RID_NICSERIALNUMBER_LEN];
-	char pstr[(HFA384x_RID_NICSERIALNUMBER_LEN * 4) + 1];
 
 	/* Collect version and compatibility info */
 	/*  Some are critical, some are not */
@@ -862,9 +839,8 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_NICSERIALNUMBER,
 					snum, HFA384x_RID_NICSERIALNUMBER_LEN);
 	if (!result) {
-		wlan_mkprintstr(snum, HFA384x_RID_NICSERIALNUMBER_LEN,
-				pstr, sizeof(pstr));
-		netdev_info(wlandev->netdev, "Prism2 card SN: %s\n", pstr);
+		netdev_info(wlandev->netdev, "Prism2 card SN: %*pEhp\n",
+			    HFA384x_RID_NICSERIALNUMBER_LEN, snum);
 	} else {
 		netdev_err(wlandev->netdev, "Failed to retrieve Prism2 Card SN\n");
 		goto failed;
-- 
2.0.1

