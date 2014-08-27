Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaH0Hgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:36:33 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:34768 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaH0Hga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:36:30 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH/RFC 1/2] lib: string: Remove duplicated function
Date: Wed, 27 Aug 2014 09:36:01 +0200
Message-Id: <1409124962-11527-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/string.c contains two functions, strnicmp and strncasecmp, which
do roughly the same thing, namely compare two strings
case-insensitively up to a given bound. They have slightly different
implementations, but the only important difference is that strncasecmp
doesn't handle len==0 appropriately; it effectively becomes strcasecmp
in that case. strnicmp correctly says that two strings are always
equal in their first 0 characters.

strncasecmp is the POSIX name for this functionality. So rename the
non-broken function to the standard name. To minimize the impact on
the rest of the kernel (and since both are exported to modules), make
strnicmp a wrapper for strncasecmp.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/string.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index 992bf30..92c33e1 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -27,14 +27,14 @@
 #include <linux/bug.h>
 #include <linux/errno.h>
 
-#ifndef __HAVE_ARCH_STRNICMP
+#ifndef __HAVE_ARCH_STRNCASECMP
 /**
- * strnicmp - Case insensitive, length-limited string comparison
+ * strncasecmp - Case insensitive, length-limited string comparison
  * @s1: One string
  * @s2: The other string
  * @len: the maximum number of characters to compare
  */
-int strnicmp(const char *s1, const char *s2, size_t len)
+int strncasecmp(const char *s1, const char *s2, size_t len)
 {
 	/* Yes, Virginia, it had better be unsigned */
 	unsigned char c1, c2;
@@ -56,6 +56,13 @@ int strnicmp(const char *s1, const char *s2, size_t len)
 	} while (--len);
 	return (int)c1 - (int)c2;
 }
+EXPORT_SYMBOL(strncasecmp);
+#endif
+#ifndef __HAVE_ARCH_STRNICMP
+int strnicmp(const char *s1, const char *s2, size_t len)
+{
+	return strncasecmp(s1, s2, len);
+}
 EXPORT_SYMBOL(strnicmp);
 #endif
 
@@ -73,20 +80,6 @@ int strcasecmp(const char *s1, const char *s2)
 EXPORT_SYMBOL(strcasecmp);
 #endif
 
-#ifndef __HAVE_ARCH_STRNCASECMP
-int strncasecmp(const char *s1, const char *s2, size_t n)
-{
-	int c1, c2;
-
-	do {
-		c1 = tolower(*s1++);
-		c2 = tolower(*s2++);
-	} while ((--n > 0) && c1 == c2 && c1 != 0);
-	return c1 - c2;
-}
-EXPORT_SYMBOL(strncasecmp);
-#endif
-
 #ifndef __HAVE_ARCH_STRCPY
 /**
  * strcpy - Copy a %NUL terminated string
-- 
2.0.4

