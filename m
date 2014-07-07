Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaGGPZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:25:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:51283 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbaGGPWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:22:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,618,1400050800"; 
   d="scan'208";a="569435586"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 07/10] lib80211: remove unused print_ssid()
Date: Mon,  7 Jul 2014 18:21:49 +0300
Message-Id: <1404746512-12749-8-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel we have %*pE specifier to print an escaped buffer. All users now
switched to that approach.

This fixes a bug as well. The current implementation wrongly prints octal
numbers: only two first digits are used in case when 3 are required and the
rest of the string ends up cut off.

Additionally by default the \f, \v, \a, and \e are escaped to their alphabetic
representation. It's safe to do since it is currently used for messaging only.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/net/lib80211.h  |  5 -----
 net/wireless/lib80211.c | 32 --------------------------------
 2 files changed, 37 deletions(-)

diff --git a/include/net/lib80211.h b/include/net/lib80211.h
index be95b92..aab0f42 100644
--- a/include/net/lib80211.h
+++ b/include/net/lib80211.h
@@ -32,11 +32,6 @@
 #include <linux/timer.h>
 #include <linux/seq_file.h>
 
-/* print_ssid() is intended to be used in debug (and possibly error)
- * messages. It should never be used for passing ssid to user space. */
-const char *print_ssid(char *buf, const char *ssid, u8 ssid_len);
-#define DECLARE_SSID_BUF(var) char var[IEEE80211_MAX_SSID_LEN * 4 + 1] __maybe_unused
-
 #define NUM_WEP_KEYS	4
 
 enum {
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index a55c27b..4596115 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -46,38 +46,6 @@ static void lib80211_crypt_deinit_entries(struct lib80211_crypt_info *info,
 static void lib80211_crypt_quiescing(struct lib80211_crypt_info *info);
 static void lib80211_crypt_deinit_handler(unsigned long data);
 
-const char *print_ssid(char *buf, const char *ssid, u8 ssid_len)
-{
-	const char *s = ssid;
-	char *d = buf;
-
-	ssid_len = min_t(u8, ssid_len, IEEE80211_MAX_SSID_LEN);
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
-	*d = '\0';
-	return buf;
-}
-EXPORT_SYMBOL(print_ssid);
-
 int lib80211_crypt_info_init(struct lib80211_crypt_info *info, char *name,
 				spinlock_t *lock)
 {
-- 
2.0.1

