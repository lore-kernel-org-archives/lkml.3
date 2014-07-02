Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaGBNVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:21:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:11278 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbaGBNVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:21:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,588,1400050800"; 
   d="scan'208";a="567258223"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6/6] staging: rtl8192u: re-use string_escape_mem()
Date: Wed,  2 Jul 2014 16:20:29 +0300
Message-Id: <1404307229-19186-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use kernel's library function to escape a buffer instead of custom code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211.h | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index 1040bab..bb5f604 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -31,6 +31,7 @@
 #include <linux/sched.h>
 #include <linux/semaphore.h>
 #include <linux/interrupt.h>
+#include <linux/string_helpers.h>
 
 #include <linux/delay.h>
 #include <linux/wireless.h>
@@ -2576,7 +2577,6 @@ static inline int ieee80211_get_scans(struct ieee80211_device *ieee)
 
 static inline const char *escape_essid(const char *essid, u8 essid_len) {
 	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
 	char *d = escaped;
 
 	if (ieee80211_is_empty_essid(essid, essid_len)) {
@@ -2585,15 +2585,8 @@ static inline const char *escape_essid(const char *essid, u8 essid_len) {
 	}
 
 	essid_len = min(essid_len, (u8)IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else {
-			*d++ = *s++;
-		}
-	}
+	d += string_escape_mem(essid, essid_len, escaped, sizeof(escaped) - 1,
+			       ESCAPE_NULL, NULL);
 	*d = '\0';
 	return escaped;
 }
-- 
2.0.0

