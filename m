Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaHQQEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 12:04:07 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34199 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaHQQEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 12:04:05 -0400
From: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
To: Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
Subject: [PATCH 1/1] div64: Speedup generic version
Date: Mon, 18 Aug 2014 00:01:49 +0800
Message-Id: <1408291309-5941-1-git-send-email-zhaoxiu.zeng@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new version do few 64 bits operations.
When high 32 bits of dividend becomes 0, use 32 bits division directly.

Signed-off-by: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
---
 lib/div64.c | 63 +++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 20 deletions(-)

diff --git a/lib/div64.c b/lib/div64.c
index 4382ad7..89b9ed4 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -23,37 +23,60 @@
 /* Not needed on 64bit architectures */
 #if BITS_PER_LONG == 32
 
+typedef union {
+	struct {
+#if defined(__LITTLE_ENDIAN)
+		uint32_t vl;
+		uint32_t vh;
+#else
+		uint32_t vh;
+		uint32_t vl;
+#endif
+	} u;
+	uint64_t v;
+} UINT64;
+
 uint32_t __attribute__((weak)) __div64_32(uint64_t *n, uint32_t base)
 {
-	uint64_t rem = *n;
-	uint64_t b = base;
-	uint64_t res, d = 1;
-	uint32_t high = rem >> 32;
+	UINT64 rem = { .v = *n, };
+	UINT64 res, b;
+	int shift;
+	uint32_t d;
 
 	/* Reduce the thing a bit first */
-	res = 0;
-	if (high >= base) {
-		high /= base;
-		res = (uint64_t) high << 32;
-		rem -= (uint64_t) (high*base) << 32;
+	res.v = 0;
+	if (rem.u.vh >= base) {
+		res.u.vh = rem.u.vh / base;
+		rem.u.vh = rem.u.vh % base;
+		if (!rem.u.vh)
+			goto end;
 	}
 
-	while ((int64_t)b > 0 && b < rem) {
-		b = b+b;
-		d = d+d;
-	}
+	/*
+	 * Here rem.u.vh < base, so "fls(rem.u.vh) <= fls(base)".
+	 * If "fls(rem.u.vh) == fls(base)", shift equals 31.
+	 * else, shift equals "32 + fls(rem.u.vh) - fls(base)"
+	 */
+	shift = 32 + fls(rem.u.vh) - fls(base) - (fls(rem.u.vh) == fls(base));
+	b.u.vl = base << shift;
+	b.u.vh = base >> (32 - shift);
+	d = 1UL << shift;
 
 	do {
-		if (rem >= b) {
-			rem -= b;
-			res += d;
+		if (rem.v >= b.v) {
+			rem.v -= b.v;
+			res.u.vl |= d;
 		}
-		b >>= 1;
+		b.v >>= 1;
 		d >>= 1;
-	} while (d);
+	} while (rem.u.vh);
+
+end:
+	res.u.vl |= rem.u.vl / base;
+	rem.u.vl = rem.u.vl % base;
 
-	*n = res;
-	return rem;
+	*n = res.v;
+	return rem.u.vl;
 }
 
 EXPORT_SYMBOL(__div64_32);
-- 
1.9.3

