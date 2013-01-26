Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3AZFwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 00:52:15 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55344 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3AZFwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 00:52:03 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-cb-51036f02e005
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org
Cc: Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>, hyojun.im@lge.com,
        chan.jeong@lge.com, gunho.lee@lge.com, minchan.kim@lge.com,
        namhyung.kim@lge.com, raphael.andy.lee@gmail.com,
        Kyungsik Lee <kyungsik.lee@lge.com>
Subject: [RFC PATCH 1/4] decompressors: add lz4 decompressor module
Date: Sat, 26 Jan 2013 14:50:44 +0900
Message-Id: <1359179447-31118-2-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com>
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for LZ4 decompression in the kernel.
LZ4 Decompression APIs for kernel are based on LZ4 implementation
by Yann Collet.

LZ4 homepage : http://fastcompression.blogspot.com/p/lz4.html
LZ4 source repository : http://code.google.com/p/lz4/

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
---
 include/linux/lz4.h      |  62 +++++++++++++++
 lib/lz4/lz4_decompress.c | 199 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/lz4/lz4defs.h        | 129 ++++++++++++++++++++++++++++++
 3 files changed, 390 insertions(+)
 create mode 100644 include/linux/lz4.h
 create mode 100644 lib/lz4/lz4_decompress.c
 create mode 100644 lib/lz4/lz4defs.h

diff --git a/include/linux/lz4.h b/include/linux/lz4.h
new file mode 100644
index 0000000..df03dd8
--- /dev/null
+++ b/include/linux/lz4.h
@@ -0,0 +1,62 @@
+#ifndef __LZ4_H__
+#define __LZ4_H__
+/*
+ * LZ4 Decompressor Kernel Interface
+ *
+ * Copyright (C) 2013, LG Electronics, Kyungsik Lee <kyungsik.lee@lge.com>
+ * Based on LZ4 implementation by Yann Collet.
+ *
+ * LZ4 - Fast LZ compression algorithm
+ * Copyright (C) 2011-2012, Yann Collet.
+ * BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are
+ * met:
+ *
+ * * Redistributions of source code must retain the above copyright
+ * notice, this list of conditions and the following disclaimer.
+ * * Redistributions in binary form must reproduce the above
+ * copyright notice, this list of conditions and the following disclaimer
+ * in the documentation and/or other materials provided with the
+ * distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You can contact the author at :
+ * - LZ4 homepage : http://fastcompression.blogspot.com/p/lz4.html
+ * - LZ4 source repository : http://code.google.com/p/lz4/
+ */
+
+
+/*
+ * LZ4_COMPRESSBOUND()
+ * Provides the maximum size that LZ4 may output in a "worst case" scenario
+ * (input data not compressible)
+ */
+#define LZ4_COMPRESSBOUND(isize) (isize + ((isize)/255) + 16)
+
+/*
+ * lz4_decompress()
+ *	src     : source address of the compressed data
+ *	src_len : is the input size, therefore the compressed size
+ *	dest	: output buffer address of the decompressed data
+ *	dest_len: is the size of the destination buffer
+ *			(which must be already allocated)
+ *	return  : Success if return 0
+ *		  Error if return (< 0)
+ *	note :  Destination buffer must be already allocated.
+ */
+int lz4_decompress(const char *src, size_t src_len, char *dest,
+			size_t *dest_len);
+#endif
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
new file mode 100644
index 0000000..e8beb6b
--- /dev/null
+++ b/lib/lz4/lz4_decompress.c
@@ -0,0 +1,199 @@
+/*
+ * LZ4 Decompressor for Linux kernel
+ *
+ * Copyright (C) 2013 LG Electronics Co., Ltd. (http://www.lge.com/)
+ *
+ * Based on LZ4 implementation by Yann Collet.
+ *
+ * LZ4 - Fast LZ compression algorithm
+ * Copyright (C) 2011-2012, Yann Collet.
+ * BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are
+ * met:
+ *
+ *     * Redistributions of source code must retain the above copyright
+ * notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above
+ * copyright notice, this list of conditions and the following disclaimer
+ * in the documentation and/or other materials provided with the
+ * distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You can contact the author at :
+ *  - LZ4 homepage : http://fastcompression.blogspot.com/p/lz4.html
+ *  - LZ4 source repository : http://code.google.com/p/lz4/
+ */
+
+#ifndef STATIC
+#include <linux/module.h>
+#include <linux/kernel.h>
+#endif
+
+#include <asm/unaligned.h>
+#include <linux/lz4.h>
+#include "lz4defs.h"
+
+
+int lz4_uncompress_unknownoutputsize(
+				const char *source,
+				char *dest,
+				int isize,
+				size_t maxoutputsize)
+{
+	const BYTE * restrict ip = (const BYTE*) source;
+	const BYTE * const iend = ip + isize;
+	const BYTE *ref;
+
+
+	BYTE *op = (BYTE *) dest;
+	BYTE * const oend = op + maxoutputsize;
+	BYTE *cpy;
+
+	size_t dec32table[] = {0, 3, 2, 3, 0, 0, 0, 0};
+#if LZ4_ARCH64
+	size_t dec64table[] = {0, 0, 0, -1, 0, 1, 2, 3};
+#endif
+
+	/* Main Loop */
+	while (ip < iend) {
+
+		unsigned token;
+		size_t length;
+
+		/* get runlength */
+		token = *ip++;
+		length = (token >> ML_BITS);
+		if (length == RUN_MASK) {
+			int s = 255;
+			while ((ip < iend) && (s == 255)) {
+				s = *ip++;
+				length += s;
+			}
+		}
+		/* copy literals */
+		cpy = op + length;
+		if ((cpy > oend - COPYLENGTH) ||
+			(ip + length > iend - COPYLENGTH)) {
+
+			if (cpy > oend)
+				goto _output_error;/* writes beyond buffer */
+
+			if (ip + length != iend)
+				goto _output_error;/*
+						    * Error: LZ4 format requires
+						    * to consume all input
+						    * at this stage
+						    */
+			memcpy(op, ip, length);
+			op += length;
+			break;/* Necessarily EOF, due to parsing restrictions */
+		}
+		LZ4_WILDCOPY(ip, op, cpy);
+		ip -= (op-cpy);
+		op = cpy;
+
+		/* get offset */
+		LZ4_READ_LITTLEENDIAN_16(ref, cpy, ip);
+		ip += 2;
+		if (ref < (BYTE * const)dest)
+			goto _output_error;
+			/*
+			 * Error : offset creates reference
+			 * outside of destination buffer
+			 */
+
+		/* get matchlength */
+		length = (token & ML_MASK);
+		if (length == ML_MASK) {
+			while (ip < iend) {
+				int s = *ip++;
+				length += s;
+				if (s == 255)
+					continue;
+				break;
+			}
+		}
+
+		/* copy repeated sequence */
+		if (unlikely(op - ref < STEPSIZE)) {
+#if LZ4_ARCH64
+			size_t dec64 = dec64table[op - ref];
+#else
+			const int dec64 = 0;
+#endif
+				op[0] = ref[0];
+				op[1] = ref[1];
+				op[2] = ref[2];
+				op[3] = ref[3];
+				op += 4;
+				ref += 4;
+				ref -= dec32table[op - ref];
+				PUT4(ref, op);
+				op += STEPSIZE-4; ref -= dec64;
+		} else {
+			LZ4_COPYSTEP(ref, op);
+		}
+		cpy = op + length - (STEPSIZE-4);
+		if (cpy > oend - COPYLENGTH) {
+			if (cpy > oend)
+				goto _output_error; /* write outside of buf */
+
+			LZ4_SECURECOPY(ref, op, (oend - COPYLENGTH));
+			while (op < cpy)
+				*op++ = *ref++;
+			op = cpy;
+			/*
+			 * Check EOF (should never happen, since last 5 bytes
+			 * are supposed to be literals)
+			 */
+			if (op == oend)
+				goto _output_error;
+			continue;
+		}
+		LZ4_SECURECOPY(ref, op, cpy);
+		op = cpy; /* correction */
+	}
+	/* end of decoding */
+	return (int) (((char *)op)-dest);
+
+	/* write overflow error detected */
+_output_error:
+	return (int) (-(((char *)ip)-source));
+}
+
+int lz4_decompress(const char *src, size_t src_len, char *dest,
+		size_t *dest_len)
+{
+	int ret = -1;
+	int out_len = 0;
+
+	out_len = lz4_uncompress_unknownoutputsize(src, dest, src_len,
+					*dest_len);
+	if (out_len < 0)
+		goto exit_0;
+	*dest_len = out_len;
+
+	return 0;
+exit_0:
+	return ret;
+}
+
+#ifndef STATIC
+EXPORT_SYMBOL_GPL(lz4_decompress);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZ4 Decompressor");
+#endif
diff --git a/lib/lz4/lz4defs.h b/lib/lz4/lz4defs.h
new file mode 100644
index 0000000..5b9666b
--- /dev/null
+++ b/lib/lz4/lz4defs.h
@@ -0,0 +1,129 @@
+/*
+ * LZ4 Decompressor for Linux kernel
+ *
+ * Copyright (C) 2013, LG Electronics, Kyungsik Lee <kyungsik.lee@lge.com>
+ *
+ * Based on LZ4 implementation by Yann Collet.
+ *
+ * LZ4 - Fast LZ compression algorithm
+ * Copyright (C) 2011-2012, Yann Collet.
+ * BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are
+ * met:
+ *
+ *     * Redistributions of source code must retain the above copyright
+ * notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above
+ * copyright notice, this list of conditions and the following disclaimer
+ * in the documentation and/or other materials provided with the
+ * distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You can contact the author at :
+ *  - LZ4 homepage : http://fastcompression.blogspot.com/p/lz4.html
+ *  - LZ4 source repository : http://code.google.com/p/lz4/
+ */
+
+/*
+ * Detects 64 bits mode
+ */
+#if (defined(__x86_64__) || defined(__x86_64) || defined(__amd64__) \
+	|| defined(__ppc64__) || defined(__LP64__))
+#define LZ4_ARCH64 1
+#else
+#define LZ4_ARCH64 0
+#endif
+
+/*
+ * Compiler Options
+ */
+#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L /* C99 */
+/* "restrict" is a known keyword */
+#else
+#define restrict	/* Disable restrict */
+#endif
+
+/*
+ * Architecture-specific macros
+ */
+#define BYTE	u8
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+typedef struct _U32_S { u32 v; } U32_S;
+typedef struct _U64_S { u64 v; } U64_S;
+
+#define A32(x) (((U32_S *)(x))->v)
+#define A64(x) (((U64_S *)(x))->v)
+
+#define PUT4(s, d) (A32(d) = A32(s))
+#define PUT8(s, d) (A64(d) = A64(s))
+#else /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
+
+#define PUT4(s, d) \
+	put_unaligned(get_unaligned((const u32 *) s), (u32 *) d)
+#define PUT8(s, d) \
+	put_unaligned(get_unaligned((const u64 *) s), (u64 *) d)
+#endif
+
+#define COPYLENGTH 8
+#define ML_BITS  4
+#define ML_MASK  ((1U << ML_BITS) - 1)
+#define RUN_BITS (8 - ML_BITS)
+#define RUN_MASK ((1U << RUN_BITS) - 1)
+
+#if LZ4_ARCH64/* 64-bit */
+#define STEPSIZE 8
+
+#define LZ4_COPYSTEP(s, d)	\
+	do {	\
+		PUT8(s, d);	\
+		d += 8;	\
+		s += 8;	\
+	} while (0)
+
+#define LZ4_COPYPACKET(s, d)	LZ4_COPYSTEP(s, d)
+
+#define LZ4_SECURECOPY(s, d, e)	\
+	do {				\
+		if (d < e) {		\
+			LZ4_WILDCOPY(s, d, e);	\
+		}	\
+	} while (0)
+
+#else	/* 32-bit */
+#define STEPSIZE 4
+
+#define LZ4_COPYSTEP(s, d)	\
+	do {	\
+		PUT4(s, d);	\
+		d += 4;	\
+		s += 4;	\
+	} while (0)
+
+#define LZ4_COPYPACKET(s, d)	\
+	do {			\
+		LZ4_COPYSTEP(s, d);	\
+		LZ4_COPYSTEP(s, d);	\
+	} while (0)
+
+#define LZ4_SECURECOPY	LZ4_WILDCOPY
+#endif
+
+#define LZ4_READ_LITTLEENDIAN_16(d, s, p) \
+	(d = s - get_unaligned_le16(p))
+#define LZ4_WILDCOPY(s, d, e)	\
+	do {				\
+		LZ4_COPYPACKET(s, d);	\
+	} while (d < e)
-- 
1.8.0.3

