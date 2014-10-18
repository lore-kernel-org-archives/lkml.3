Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaJRWBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 18:01:11 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:49990 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaJRWBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 18:01:09 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] lib: string.c:  Added a function strzcpy
Date: Sun, 19 Oct 2014 00:03:20 +0200
Message-Id: <1413669800-6058-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a function strzcpy which works the same as strncpy,
but guaranteed to produce the trailing null character.

There are many places in the code where strncpy used although it
must be zero terminated, and switching to strlcpy is not an option
because the string must nonetheless be fyld with zero characters.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 include/linux/string.h |    1 +
 lib/string.c           |   31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index d36977e..d789ee5e 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -22,6 +22,7 @@ extern char * strcpy(char *,const char *);
 #ifndef __HAVE_ARCH_STRNCPY
 extern char * strncpy(char *,const char *, __kernel_size_t);
 #endif
+extern char *strzcpy(char *, const char *, __kernel_size_t);
 #ifndef __HAVE_ARCH_STRLCPY
 size_t strlcpy(char *, const char *, size_t);
 #endif
diff --git a/lib/string.c b/lib/string.c
index f3c6ff5..582a832 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -134,6 +134,37 @@ char *strncpy(char *dest, const char *src, size_t count)
 EXPORT_SYMBOL(strncpy);
 #endif
 
+/**
+ * strzcpy - Copy a length-limited, C-string
+ * @dest: Where to copy the string to
+ * @src: Where to copy the string from
+ * @count: The maximum number of bytes to copy
+ *
+ * The result is %NUL-terminated,
+ * as long as count is greater than zero.
+ *
+ * In the case where the length of @src is less than  that  of
+ * count, the remainder of @dest will be padded with %NUL.
+ *
+ */
+char *strzcpy(char *dest, const char *src, size_t count)
+{
+	char *tmp = dest;
+
+	while (count) {
+		if ((*tmp = *src) != 0)
+			src++;
+		tmp++;
+		count--;
+	}
+
+	if (dest != tmp)
+		*--tmp = '\0';
+
+	return dest;
+}
+EXPORT_SYMBOL(strzcpy);
+
 #ifndef __HAVE_ARCH_STRLCPY
 /**
  * strlcpy - Copy a C-string into a sized buffer
-- 
1.7.10.4

