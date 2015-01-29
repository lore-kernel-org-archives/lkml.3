Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbbA2KDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:03:50 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:53499 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761871AbbA2KDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:03:46 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathias Krause <minipli@googlemail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] lib/string_helpers.c: Refactor string_escape_mem
Date: Thu, 29 Jan 2015 11:03:19 +0100
Message-Id: <1422525801-26560-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422525801-26560-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1422451543-12401-1-git-send-email-linux@rasmusvillemoes.dk>
 <1422525801-26560-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When printf is given the format specifier %pE, it needs a way of
obtaining the total output size that would be generated if the buffer
was large enough, and string_escape_mem doesn't easily provide
that. This is a refactorization of string_escape_mem in preparation of
changing its external API to provide that information.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/string_helpers.c | 182 ++++++++++++++++++++-------------------------------
 1 file changed, 72 insertions(+), 110 deletions(-)

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 58b78ba57439..e14dd8555760 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -243,29 +243,21 @@ int string_unescape(char *src, char *dst, size_t size, unsigned int flags)
 }
 EXPORT_SYMBOL(string_unescape);
 
-static int escape_passthrough(unsigned char c, char **dst, size_t *osz)
+static bool escape_passthrough(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 
-	if (*osz < 1)
-		return -ENOMEM;
-
-	*out++ = c;
-
-	*dst = out;
-	*osz -= 1;
-
-	return 1;
+	if (out < end)
+		*out = c;
+	*dst = out + 1;
+	return true;
 }
 
-static int escape_space(unsigned char c, char **dst, size_t *osz)
+static bool escape_space(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 	unsigned char to;
 
-	if (*osz < 2)
-		return -ENOMEM;
-
 	switch (c) {
 	case '\n':
 		to = 'n';
@@ -283,26 +275,23 @@ static int escape_space(unsigned char c, char **dst, size_t *osz)
 		to = 'f';
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	*out++ = '\\';
-	*out++ = to;
+	if (out + 0 < end)
+		out[0] = '\\';
+	if (out + 1 < end)
+		out[1] = to;
 
-	*dst = out;
-	*osz -= 2;
-
-	return 1;
+	*dst = out + 2;
+	return true;
 }
 
-static int escape_special(unsigned char c, char **dst, size_t *osz)
+static bool escape_special(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 	unsigned char to;
 
-	if (*osz < 2)
-		return -ENOMEM;
-
 	switch (c) {
 	case '\\':
 		to = '\\';
@@ -314,71 +303,66 @@ static int escape_special(unsigned char c, char **dst, size_t *osz)
 		to = 'e';
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	*out++ = '\\';
-	*out++ = to;
+	if (out + 0 < end)
+		out[0] = '\\';
+	if (out + 1 < end)
+		out[1] = to;
 
-	*dst = out;
-	*osz -= 2;
-
-	return 1;
+	*dst = out + 2;
+	return true;
 }
 
-static int escape_null(unsigned char c, char **dst, size_t *osz)
+static bool escape_null(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 
-	if (*osz < 2)
-		return -ENOMEM;
-
 	if (c)
-		return 0;
-
-	*out++ = '\\';
-	*out++ = '0';
+		return false;
 
-	*dst = out;
-	*osz -= 2;
+	if (out + 0 < end)
+		out[0] = '\\';
+	if (out + 1 < end)
+		out[1] = '0';
 
-	return 1;
+	*dst = out + 2;
+	return true;
 }
 
-static int escape_octal(unsigned char c, char **dst, size_t *osz)
+static bool escape_octal(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 
-	if (*osz < 4)
-		return -ENOMEM;
-
-	*out++ = '\\';
-	*out++ = ((c >> 6) & 0x07) + '0';
-	*out++ = ((c >> 3) & 0x07) + '0';
-	*out++ = ((c >> 0) & 0x07) + '0';
+	if (out + 0 < end)
+		out[0] = '\\';
+	if (out + 1 < end)
+		out[1] = ((c >> 6) & 0x07) + '0';
+	if (out + 2 < end)
+		out[2] = ((c >> 3) & 0x07) + '0';
+	if (out + 3 < end)
+		out[3] = ((c >> 0) & 0x07) + '0';
 
-	*dst = out;
-	*osz -= 4;
-
-	return 1;
+	*dst = out + 4;
+	return true;
 }
 
-static int escape_hex(unsigned char c, char **dst, size_t *osz)
+static bool escape_hex(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 
-	if (*osz < 4)
-		return -ENOMEM;
-
-	*out++ = '\\';
-	*out++ = 'x';
-	*out++ = hex_asc_hi(c);
-	*out++ = hex_asc_lo(c);
-
-	*dst = out;
-	*osz -= 4;
+	if (out + 0 < end)
+		out[0] = '\\';
+	if (out + 1 < end)
+		out[1] = 'x';
+	if (out + 2 < end)
+		out[2] = hex_asc_hi(c);
+	if (out + 3 < end)
+		out[3] = hex_asc_lo(c);
 
-	return 1;
+	*dst = out + 4;
+	return true;
 }
 
 /**
@@ -440,9 +424,10 @@ static int escape_hex(unsigned char c, char **dst, size_t *osz)
 int string_escape_mem(const char *src, size_t isz, char **dst, size_t osz,
 		      unsigned int flags, const char *esc)
 {
-	char *out = *dst, *p = out;
+	char *p = *dst;
+	char *end = p + osz;
 	bool is_dict = esc && *esc;
-	int ret = 0;
+	int ret;
 
 	while (isz--) {
 		unsigned char c = *src++;
@@ -462,55 +447,32 @@ int string_escape_mem(const char *src, size_t isz, char **dst, size_t osz,
 		    (is_dict && !strchr(esc, c))) {
 			/* do nothing */
 		} else {
-			if (flags & ESCAPE_SPACE) {
-				ret = escape_space(c, &p, &osz);
-				if (ret < 0)
-					break;
-				if (ret > 0)
-					continue;
-			}
-
-			if (flags & ESCAPE_SPECIAL) {
-				ret = escape_special(c, &p, &osz);
-				if (ret < 0)
-					break;
-				if (ret > 0)
-					continue;
-			}
-
-			if (flags & ESCAPE_NULL) {
-				ret = escape_null(c, &p, &osz);
-				if (ret < 0)
-					break;
-				if (ret > 0)
-					continue;
-			}
+			if (flags & ESCAPE_SPACE && escape_space(c, &p, end))
+				continue;
+
+			if (flags & ESCAPE_SPECIAL && escape_special(c, &p, end))
+				continue;
+
+			if (flags & ESCAPE_NULL && escape_null(c, &p, end))
+				continue;
 
 			/* ESCAPE_OCTAL and ESCAPE_HEX always go last */
-			if (flags & ESCAPE_OCTAL) {
-				ret = escape_octal(c, &p, &osz);
-				if (ret < 0)
-					break;
+			if (flags & ESCAPE_OCTAL && escape_octal(c, &p, end))
 				continue;
-			}
-			if (flags & ESCAPE_HEX) {
-				ret = escape_hex(c, &p, &osz);
-				if (ret < 0)
-					break;
+
+			if (flags & ESCAPE_HEX && escape_hex(c, &p, end))
 				continue;
-			}
 		}
 
-		ret = escape_passthrough(c, &p, &osz);
-		if (ret < 0)
-			break;
+		escape_passthrough(c, &p, end);
+	}
+	if (p > end) {
+		*dst = end;
+		return -ENOMEM;
 	}
 
+	ret = p - *dst;
 	*dst = p;
-
-	if (ret < 0)
-		return ret;
-
-	return p - out;
+	return ret;
 }
 EXPORT_SYMBOL(string_escape_mem);
-- 
2.1.3

