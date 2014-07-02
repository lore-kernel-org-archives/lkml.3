Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaGBNVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:21:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:15960 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbaGBNVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:21:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,588,1400050800"; 
   d="scan'208";a="567258217"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4/6] staging: wlan-ng: re-use string_escape_mem()
Date: Wed,  2 Jul 2014 16:20:27 +0300
Message-Id: <1404307229-19186-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a generic function to escape strings by given criteria. Let's use it
instead of custom approach.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/wlan-ng/prism2sta.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 209e4db..1e44c09 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -61,6 +61,7 @@
 #include <linux/workqueue.h>
 #include <linux/byteorder/generic.h>
 #include <linux/ctype.h>
+#include <linux/string_helpers.h>
 
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -81,27 +82,6 @@
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
 
@@ -862,8 +842,11 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_NICSERIALNUMBER,
 					snum, HFA384x_RID_NICSERIALNUMBER_LEN);
 	if (!result) {
-		wlan_mkprintstr(snum, HFA384x_RID_NICSERIALNUMBER_LEN,
-				pstr, sizeof(pstr));
+		result = string_escape_mem(snum,
+				HFA384x_RID_NICSERIALNUMBER_LEN,
+				pstr, sizeof(pstr), ESCAPE_HEX | ESCAPE_NP,
+				NULL);
+		pstr[result] = '\0';
 		netdev_info(wlandev->netdev, "Prism2 card SN: %s\n", pstr);
 	} else {
 		netdev_err(wlandev->netdev, "Failed to retrieve Prism2 Card SN\n");
-- 
2.0.0

