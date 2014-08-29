Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaH2SmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:42:11 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:35110 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaH2SmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:42:09 -0400
X-CheckPoint: {5400C981-0-2100090A-C0000000}
Message-ID: <201408291842.s7TIg7HN028765@farm-0039.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 29 Aug 2014 14:31:14 -0400
Subject: [PATCH 1/2] Add strscpy() as a new string copy primitive
To: Randy Dunlap <rdunlap@infradead.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
References: <1406383386-1400-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <53E13D78.6000903@tilera.com> <CAFo99gZ1rOqD-RFN7Shx4mWO4kfVLCXpuxUWqOwK5uY6uwAh3Q@mail.gmail.com> <201408061838.s76Ic6lV014201@farm-0039.internal.tilera.com> <53E32022.2090006@infradead.org> <CAFo99gYMtpVo9=dZ-dW5iiiRgKGjwxwaLBe6C5Ci9v6-7o8H+A@mail.gmail.com> <53E935DE.6050201@infradead.org>
In-Reply-To: <53E935DE.6050201@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both strncpy and strlcpy suffer from the fact that they do
partial copies of strings into the destination when the target
buffer is too small.  This is frequently pointless since an
overflow of the target buffer may make the result invalid.

strncpy() makes it relatively hard to even detect the error
condition, and with strlcpy() you have to duplicate the buffer
size parameter to test to see if the result exceeds it.
By returning zero in the failure case, we both make testing
for it easy, and by simply not copying anything in that case,
we make it mandatory for callers to test the error code.

To catch lazy programmers who don't check, we also place a NUL at
the start of the destination buffer (if there is space) to
ensure that the result is an invalid string.

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 include/linux/string.h |  3 +++
 lib/string.c           | 29 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index d36977e029af..b9e9b2b5f6c6 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -25,6 +25,9 @@ extern char * strncpy(char *,const char *, __kernel_size_t);
 #ifndef __HAVE_ARCH_STRLCPY
 size_t strlcpy(char *, const char *, size_t);
 #endif
+#ifndef __HAVE_ARCH_STRSCPY
+size_t strscpy(char *, const char *, size_t);
+#endif
 #ifndef __HAVE_ARCH_STRCAT
 extern char * strcat(char *, const char *);
 #endif
diff --git a/lib/string.c b/lib/string.c
index 992bf30af759..bbd67b3343dc 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -160,6 +160,35 @@ size_t strlcpy(char *dest, const char *src, size_t size)
 EXPORT_SYMBOL(strlcpy);
 #endif
 
+#ifndef __HAVE_ARCH_STRSCPY
+/**
+ * strscpy - Copy a C-string into a sized buffer, but only if it fits
+ * @dest: Where to copy the string to
+ * @src: Where to copy the string from
+ * @size: size of destination buffer
+ *
+ * Use this routine to avoid copying too-long strings.
+ * The routine returns the total number of bytes copied
+ * (including the trailing NUL) or zero if the buffer wasn't
+ * big enough.  To ensure that programmers pay attention
+ * to the return code, the destination has a single NUL
+ * written at the front (if size is non-zero) when the
+ * buffer is not big enough.
+ */
+size_t strscpy(char *dest, const char *src, size_t size)
+{
+	size_t len = strnlen(src, size) + 1;
+	if (len > size) {
+		if (size)
+			dest[0] = '\0';
+		return 0;
+	}
+	memcpy(dest, src, len);
+	return len;
+}
+EXPORT_SYMBOL(strscpy);
+#endif
+
 #ifndef __HAVE_ARCH_STRCAT
 /**
  * strcat - Append one %NUL-terminated string to another
-- 
1.8.3.1

