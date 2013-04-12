Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3DLMap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:30:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:61871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab3DLMam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:30:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,462,1363158000"; 
   d="scan'208";a="294003681"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        speakup@braille.uwo.ca, devel@driverdev.osuosl.org
Subject: [PATCH 2/4] staging: speakup: remove custom string_unescape_any_inplace
Date: Fri, 12 Apr 2013 15:30:18 +0300
Message-Id: <1365769820-28953-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1365769820-28953-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1365769820-28953-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is generic implementation of the function to unescape strings.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: speakup@braille.uwo.ca
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/speakup/kobjects.c    |  6 +++--
 drivers/staging/speakup/speakup.h     |  1 -
 drivers/staging/speakup/varhandlers.c | 46 -----------------------------------
 3 files changed, 4 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
index d6d9264..943b6c1 100644
--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/kobject.h>
 #include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <linux/sysfs.h>
 #include <linux/ctype.h>
 
@@ -417,7 +418,7 @@ static ssize_t synth_direct_store(struct kobject *kobj,
 		bytes = min_t(size_t, len, 250);
 		strncpy(tmp, ptr, bytes);
 		tmp[bytes] = '\0';
-		spk_xlate(tmp);
+		string_unescape_any_inplace(tmp);
 		synth_printf("%s", tmp);
 		ptr += bytes;
 		len -= bytes;
@@ -605,7 +606,8 @@ ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
 	if (param->data == NULL)
 		return 0;
 	ret = 0;
-	cp = spk_xlate((char *) buf);
+	cp = (char *)buf;
+	string_unescape_any_inplace(cp);
 
 	spk_lock(flags);
 	switch (param->var_type) {
diff --git a/drivers/staging/speakup/speakup.h b/drivers/staging/speakup/speakup.h
index c387a02..0126f71 100644
--- a/drivers/staging/speakup/speakup.h
+++ b/drivers/staging/speakup/speakup.h
@@ -54,7 +54,6 @@ void spk_get_index_count(int *linecount, int *sentcount);
 extern int spk_set_key_info(const u_char *key_info, u_char *k_buffer);
 extern char *spk_strlwr(char *s);
 extern char *spk_s2uchar(char *start, char *dest);
-extern char *spk_xlate(char *s);
 extern int speakup_kobj_init(void);
 extern void speakup_kobj_exit(void);
 extern int spk_chartab_get_value(char *keyword);
diff --git a/drivers/staging/speakup/varhandlers.c b/drivers/staging/speakup/varhandlers.c
index 0099cb1..7f6288f 100644
--- a/drivers/staging/speakup/varhandlers.c
+++ b/drivers/staging/speakup/varhandlers.c
@@ -328,49 +328,3 @@ char *spk_s2uchar(char *start, char *dest)
 	*dest = (u_char)val;
 	return start;
 }
-
-char *spk_xlate(char *s)
-{
-	static const char finds[] = "nrtvafe";
-	static const char subs[] = "\n\r\t\013\001\014\033";
-	static const char hx[] = "0123456789abcdefABCDEF";
-	char *p = s, *p1, *p2, c;
-	int num;
-	while ((p = strchr(p, '\\'))) {
-		p1 = p+1;
-		p2 = strchr(finds, *p1);
-		if (p2) {
-			*p++ = subs[p2-finds];
-			p1++;
-		} else if (*p1 >= '0' && *p1 <= '7') {
-			num = (*p1++)&7;
-			while (num < 32 && *p1 >= '0' && *p1 <= '7') {
-				num <<= 3;
-				num += (*p1++)&7;
-			}
-			*p++ = num;
-		} else if (*p1 == 'x' &&
-				strchr(hx, p1[1]) && strchr(hx, p1[2])) {
-			p1++;
-			c = *p1++;
-			if (c > '9')
-				c = (c - '7') & 0x0f;
-			else
-				c -= '0';
-			num = c << 4;
-			c = *p1++;
-			if (c > '9')
-				c = (c-'7')&0x0f;
-			else
-				c -= '0';
-			num += c;
-			*p++ = num;
-		} else
-			*p++ = *p1++;
-		p2 = p;
-		while (*p1)
-			*p2++ = *p1++;
-		*p2 = '\0';
-	}
-	return s;
-}
-- 
1.8.2.rc0.22.gb3600c3

