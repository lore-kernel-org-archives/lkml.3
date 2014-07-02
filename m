Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaGBNWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:22:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:22494 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbaGBNUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:20:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,588,1400050800"; 
   d="scan'208";a="452518119"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/6] lib80211: re-use string_escape_mem_any_np()
Date: Wed,  2 Jul 2014 16:20:26 +0300
Message-Id: <1404307229-19186-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel we have function to escape a given string. Let's use it instead of
custom approach.

This fixes a bug. The current implementation wrongly prints octal numbers: only
two first digits are used in case when 3 are required and the rest of the
string ends up cut off.

Additionally the \f, \v, \a, and \e are escaped to their alphabetic
representation. It's safe to do since the print_ssid() is currently used for
messaging only.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/wireless/lib80211.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index a55c27b..0c2f67b 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/string_helpers.h>
 
 #include <net/lib80211.h>
 
@@ -48,31 +49,10 @@ static void lib80211_crypt_deinit_handler(unsigned long data);
 
 const char *print_ssid(char *buf, const char *ssid, u8 ssid_len)
 {
-	const char *s = ssid;
 	char *d = buf;
 
 	ssid_len = min_t(u8, ssid_len, IEEE80211_MAX_SSID_LEN);
-	while (ssid_len--) {
-		if (isprint(*s)) {
-			*d++ = *s++;
-			continue;
-		}
-
-		*d++ = '\\';
-		if (*s == '\0')
-			*d++ = '0';
-		else if (*s == '\n')
-			*d++ = 'n';
-		else if (*s == '\r')
-			*d++ = 'r';
-		else if (*s == '\t')
-			*d++ = 't';
-		else if (*s == '\\')
-			*d++ = '\\';
-		else
-			d += snprintf(d, 3, "%03o", *s);
-		s++;
-	}
+	d += string_escape_mem_any_np(ssid, ssid_len, buf, ~0UL, NULL);
 	*d = '\0';
 	return buf;
 }
-- 
2.0.0

