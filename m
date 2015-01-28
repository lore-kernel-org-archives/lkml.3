Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbbA1WIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:08:36 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35404 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbbA1UUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:20:11 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Fabian Frederick <fabf@skynet.be>, Bjorn Helgaas <bhelgaas@google.com>,
        Ryan Mallon <rmallon@gmail.com>, Masanari Iida <standby24x7@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] lib/vsprintf.c: Fix potential NULL deref in hex_string
Date: Wed, 28 Jan 2015 14:25:41 +0100
Message-Id: <1422451543-12401-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422451543-12401-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1422451543-12401-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper hex_string() is broken in two ways. First, it doesn't
increment buf regardless of whether there is room to print, so callers
such as kasprintf() that try to probe the correct storage to allocate
will get a too small return value. But even worse, kasprintf() (and
likely anyone else trying to find the size of the result) pass NULL
for buf and 0 for size, so we also have end == NULL. But this means
that the end-1 in hex_string() is (char*)-1, so buf < end-1 is true
and we get a NULL pointer deref. I double-checked this with a trivial
kernel module that just did a kasprintf(GFP_KERNEL, "%14ph",
"CrashBoomBang").

Nobody seems to be using %ph with kasprintf, but we might as well fix
it before it hits someone.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/vsprintf.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index ec337f64f52d..0d57be58448f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -748,11 +748,19 @@ char *resource_string(char *buf, char *end, struct resource *res,
 	return string(buf, end, sym, spec);
 }
 
+static char*
+write_bytes(char *buf, char *end, const char *bytes, unsigned count)
+{
+	if (buf < end)
+		memcpy(buf, bytes, min_t(unsigned, end - buf, count));
+	return buf + count;
+}
+
 static noinline_for_stack
 char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
 		 const char *fmt)
 {
-	int i, len = 1;		/* if we pass '%ph[CDN]', field width remains
+	int i, j, len = 1;	/* if we pass '%ph[CDN]', field width remains
 				   negative value, fallback to the default */
 	char separator;
 
@@ -782,11 +790,16 @@ char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
 	if (spec.field_width > 0)
 		len = min_t(int, spec.field_width, 64);
 
-	for (i = 0; i < len && buf < end - 1; i++) {
-		buf = hex_byte_pack(buf, addr[i]);
+	for (i = 0; i < len; i += 8) {
+		char tmp[24]; /* 8*2 hex chars + 8 separators */
+		char *t = tmp;
 
-		if (buf < end && separator && i != len - 1)
-			*buf++ = separator;
+		for (j = i; j < len && j < i+8; ++j) {
+			t = hex_byte_pack(t, addr[j]);
+			if (separator && j != len-1)
+				*t++ = separator;
+		}
+		buf = write_bytes(buf, end, tmp, t - tmp);
 	}
 
 	return buf;
-- 
2.1.3

