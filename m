Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaGHTdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:33:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54124 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755688AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.288405812@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 093/125] lib/lzo: Rename lzo1x_decompress.c to
 lzo1x_decompress_safe.c
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>

commit b6bec26cea948148a9420e7a0ac337f925de49e7 upstream.

Rename the source file to match the function name and thereby
also make room for a possible future even slightly faster
"non-safe" decompressor version.

Signed-off-by: Markus F.X.J. Oberhumer <markus@oberhumer.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 lib/decompress_unlzo.c          |   2 +-
 lib/lzo/Makefile                |   2 +-
 lib/lzo/lzo1x_decompress.c      | 255 ----------------------------------------
 lib/lzo/lzo1x_decompress_safe.c | 255 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 257 insertions(+), 257 deletions(-)
 delete mode 100644 lib/lzo/lzo1x_decompress.c
 create mode 100644 lib/lzo/lzo1x_decompress_safe.c

--- a/lib/decompress_unlzo.c
+++ b/lib/decompress_unlzo.c
@@ -31,7 +31,7 @@
  */
 
 #ifdef STATIC
-#include "lzo/lzo1x_decompress.c"
+#include "lzo/lzo1x_decompress_safe.c"
 #else
 #include <linux/decompress/unlzo.h>
 #endif
--- a/lib/lzo/Makefile
+++ b/lib/lzo/Makefile
@@ -1,5 +1,5 @@
 lzo_compress-objs := lzo1x_compress.o
-lzo_decompress-objs := lzo1x_decompress.o
+lzo_decompress-objs := lzo1x_decompress_safe.o
 
 obj-$(CONFIG_LZO_COMPRESS) += lzo_compress.o
 obj-$(CONFIG_LZO_DECOMPRESS) += lzo_decompress.o
--- a/lib/lzo/lzo1x_decompress.c
+++ /dev/null
@@ -1,255 +0,0 @@
-/*
- *  LZO1X Decompressor from MiniLZO
- *
- *  Copyright (C) 1996-2005 Markus F.X.J. Oberhumer <markus@oberhumer.com>
- *
- *  The full LZO package can be found at:
- *  http://www.oberhumer.com/opensource/lzo/
- *
- *  Changed for kernel use by:
- *  Nitin Gupta <nitingupta910@gmail.com>
- *  Richard Purdie <rpurdie@openedhand.com>
- */
-
-#ifndef STATIC
-#include <linux/module.h>
-#include <linux/kernel.h>
-#endif
-
-#include <asm/unaligned.h>
-#include <linux/lzo.h>
-#include "lzodefs.h"
-
-#define HAVE_IP(x, ip_end, ip) ((size_t)(ip_end - ip) < (x))
-#define HAVE_OP(x, op_end, op) ((size_t)(op_end - op) < (x))
-#define HAVE_LB(m_pos, out, op) (m_pos < out || m_pos >= op)
-
-#define COPY4(dst, src)	\
-		put_unaligned(get_unaligned((const u32 *)(src)), (u32 *)(dst))
-
-int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
-			unsigned char *out, size_t *out_len)
-{
-	const unsigned char * const ip_end = in + in_len;
-	unsigned char * const op_end = out + *out_len;
-	const unsigned char *ip = in, *m_pos;
-	unsigned char *op = out;
-	size_t t;
-
-	*out_len = 0;
-
-	if (*ip > 17) {
-		t = *ip++ - 17;
-		if (t < 4)
-			goto match_next;
-		if (HAVE_OP(t, op_end, op))
-			goto output_overrun;
-		if (HAVE_IP(t + 1, ip_end, ip))
-			goto input_overrun;
-		do {
-			*op++ = *ip++;
-		} while (--t > 0);
-		goto first_literal_run;
-	}
-
-	while ((ip < ip_end)) {
-		t = *ip++;
-		if (t >= 16)
-			goto match;
-		if (t == 0) {
-			if (HAVE_IP(1, ip_end, ip))
-				goto input_overrun;
-			while (*ip == 0) {
-				t += 255;
-				ip++;
-				if (HAVE_IP(1, ip_end, ip))
-					goto input_overrun;
-			}
-			t += 15 + *ip++;
-		}
-		if (HAVE_OP(t + 3, op_end, op))
-			goto output_overrun;
-		if (HAVE_IP(t + 4, ip_end, ip))
-			goto input_overrun;
-
-		COPY4(op, ip);
-		op += 4;
-		ip += 4;
-		if (--t > 0) {
-			if (t >= 4) {
-				do {
-					COPY4(op, ip);
-					op += 4;
-					ip += 4;
-					t -= 4;
-				} while (t >= 4);
-				if (t > 0) {
-					do {
-						*op++ = *ip++;
-					} while (--t > 0);
-				}
-			} else {
-				do {
-					*op++ = *ip++;
-				} while (--t > 0);
-			}
-		}
-
-first_literal_run:
-		t = *ip++;
-		if (t >= 16)
-			goto match;
-		m_pos = op - (1 + M2_MAX_OFFSET);
-		m_pos -= t >> 2;
-		m_pos -= *ip++ << 2;
-
-		if (HAVE_LB(m_pos, out, op))
-			goto lookbehind_overrun;
-
-		if (HAVE_OP(3, op_end, op))
-			goto output_overrun;
-		*op++ = *m_pos++;
-		*op++ = *m_pos++;
-		*op++ = *m_pos;
-
-		goto match_done;
-
-		do {
-match:
-			if (t >= 64) {
-				m_pos = op - 1;
-				m_pos -= (t >> 2) & 7;
-				m_pos -= *ip++ << 3;
-				t = (t >> 5) - 1;
-				if (HAVE_LB(m_pos, out, op))
-					goto lookbehind_overrun;
-				if (HAVE_OP(t + 3 - 1, op_end, op))
-					goto output_overrun;
-				goto copy_match;
-			} else if (t >= 32) {
-				t &= 31;
-				if (t == 0) {
-					if (HAVE_IP(1, ip_end, ip))
-						goto input_overrun;
-					while (*ip == 0) {
-						t += 255;
-						ip++;
-						if (HAVE_IP(1, ip_end, ip))
-							goto input_overrun;
-					}
-					t += 31 + *ip++;
-				}
-				m_pos = op - 1;
-				m_pos -= get_unaligned_le16(ip) >> 2;
-				ip += 2;
-			} else if (t >= 16) {
-				m_pos = op;
-				m_pos -= (t & 8) << 11;
-
-				t &= 7;
-				if (t == 0) {
-					if (HAVE_IP(1, ip_end, ip))
-						goto input_overrun;
-					while (*ip == 0) {
-						t += 255;
-						ip++;
-						if (HAVE_IP(1, ip_end, ip))
-							goto input_overrun;
-					}
-					t += 7 + *ip++;
-				}
-				m_pos -= get_unaligned_le16(ip) >> 2;
-				ip += 2;
-				if (m_pos == op)
-					goto eof_found;
-				m_pos -= 0x4000;
-			} else {
-				m_pos = op - 1;
-				m_pos -= t >> 2;
-				m_pos -= *ip++ << 2;
-
-				if (HAVE_LB(m_pos, out, op))
-					goto lookbehind_overrun;
-				if (HAVE_OP(2, op_end, op))
-					goto output_overrun;
-
-				*op++ = *m_pos++;
-				*op++ = *m_pos;
-				goto match_done;
-			}
-
-			if (HAVE_LB(m_pos, out, op))
-				goto lookbehind_overrun;
-			if (HAVE_OP(t + 3 - 1, op_end, op))
-				goto output_overrun;
-
-			if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
-				COPY4(op, m_pos);
-				op += 4;
-				m_pos += 4;
-				t -= 4 - (3 - 1);
-				do {
-					COPY4(op, m_pos);
-					op += 4;
-					m_pos += 4;
-					t -= 4;
-				} while (t >= 4);
-				if (t > 0)
-					do {
-						*op++ = *m_pos++;
-					} while (--t > 0);
-			} else {
-copy_match:
-				*op++ = *m_pos++;
-				*op++ = *m_pos++;
-				do {
-					*op++ = *m_pos++;
-				} while (--t > 0);
-			}
-match_done:
-			t = ip[-2] & 3;
-			if (t == 0)
-				break;
-match_next:
-			if (HAVE_OP(t, op_end, op))
-				goto output_overrun;
-			if (HAVE_IP(t + 1, ip_end, ip))
-				goto input_overrun;
-
-			*op++ = *ip++;
-			if (t > 1) {
-				*op++ = *ip++;
-				if (t > 2)
-					*op++ = *ip++;
-			}
-
-			t = *ip++;
-		} while (ip < ip_end);
-	}
-
-	*out_len = op - out;
-	return LZO_E_EOF_NOT_FOUND;
-
-eof_found:
-	*out_len = op - out;
-	return (ip == ip_end ? LZO_E_OK :
-		(ip < ip_end ? LZO_E_INPUT_NOT_CONSUMED : LZO_E_INPUT_OVERRUN));
-input_overrun:
-	*out_len = op - out;
-	return LZO_E_INPUT_OVERRUN;
-
-output_overrun:
-	*out_len = op - out;
-	return LZO_E_OUTPUT_OVERRUN;
-
-lookbehind_overrun:
-	*out_len = op - out;
-	return LZO_E_LOOKBEHIND_OVERRUN;
-}
-#ifndef STATIC
-EXPORT_SYMBOL_GPL(lzo1x_decompress_safe);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("LZO1X Decompressor");
-
-#endif
--- /dev/null
+++ b/lib/lzo/lzo1x_decompress_safe.c
@@ -0,0 +1,255 @@
+/*
+ *  LZO1X Decompressor from MiniLZO
+ *
+ *  Copyright (C) 1996-2005 Markus F.X.J. Oberhumer <markus@oberhumer.com>
+ *
+ *  The full LZO package can be found at:
+ *  http://www.oberhumer.com/opensource/lzo/
+ *
+ *  Changed for kernel use by:
+ *  Nitin Gupta <nitingupta910@gmail.com>
+ *  Richard Purdie <rpurdie@openedhand.com>
+ */
+
+#ifndef STATIC
+#include <linux/module.h>
+#include <linux/kernel.h>
+#endif
+
+#include <asm/unaligned.h>
+#include <linux/lzo.h>
+#include "lzodefs.h"
+
+#define HAVE_IP(x, ip_end, ip) ((size_t)(ip_end - ip) < (x))
+#define HAVE_OP(x, op_end, op) ((size_t)(op_end - op) < (x))
+#define HAVE_LB(m_pos, out, op) (m_pos < out || m_pos >= op)
+
+#define COPY4(dst, src)	\
+		put_unaligned(get_unaligned((const u32 *)(src)), (u32 *)(dst))
+
+int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
+			unsigned char *out, size_t *out_len)
+{
+	const unsigned char * const ip_end = in + in_len;
+	unsigned char * const op_end = out + *out_len;
+	const unsigned char *ip = in, *m_pos;
+	unsigned char *op = out;
+	size_t t;
+
+	*out_len = 0;
+
+	if (*ip > 17) {
+		t = *ip++ - 17;
+		if (t < 4)
+			goto match_next;
+		if (HAVE_OP(t, op_end, op))
+			goto output_overrun;
+		if (HAVE_IP(t + 1, ip_end, ip))
+			goto input_overrun;
+		do {
+			*op++ = *ip++;
+		} while (--t > 0);
+		goto first_literal_run;
+	}
+
+	while ((ip < ip_end)) {
+		t = *ip++;
+		if (t >= 16)
+			goto match;
+		if (t == 0) {
+			if (HAVE_IP(1, ip_end, ip))
+				goto input_overrun;
+			while (*ip == 0) {
+				t += 255;
+				ip++;
+				if (HAVE_IP(1, ip_end, ip))
+					goto input_overrun;
+			}
+			t += 15 + *ip++;
+		}
+		if (HAVE_OP(t + 3, op_end, op))
+			goto output_overrun;
+		if (HAVE_IP(t + 4, ip_end, ip))
+			goto input_overrun;
+
+		COPY4(op, ip);
+		op += 4;
+		ip += 4;
+		if (--t > 0) {
+			if (t >= 4) {
+				do {
+					COPY4(op, ip);
+					op += 4;
+					ip += 4;
+					t -= 4;
+				} while (t >= 4);
+				if (t > 0) {
+					do {
+						*op++ = *ip++;
+					} while (--t > 0);
+				}
+			} else {
+				do {
+					*op++ = *ip++;
+				} while (--t > 0);
+			}
+		}
+
+first_literal_run:
+		t = *ip++;
+		if (t >= 16)
+			goto match;
+		m_pos = op - (1 + M2_MAX_OFFSET);
+		m_pos -= t >> 2;
+		m_pos -= *ip++ << 2;
+
+		if (HAVE_LB(m_pos, out, op))
+			goto lookbehind_overrun;
+
+		if (HAVE_OP(3, op_end, op))
+			goto output_overrun;
+		*op++ = *m_pos++;
+		*op++ = *m_pos++;
+		*op++ = *m_pos;
+
+		goto match_done;
+
+		do {
+match:
+			if (t >= 64) {
+				m_pos = op - 1;
+				m_pos -= (t >> 2) & 7;
+				m_pos -= *ip++ << 3;
+				t = (t >> 5) - 1;
+				if (HAVE_LB(m_pos, out, op))
+					goto lookbehind_overrun;
+				if (HAVE_OP(t + 3 - 1, op_end, op))
+					goto output_overrun;
+				goto copy_match;
+			} else if (t >= 32) {
+				t &= 31;
+				if (t == 0) {
+					if (HAVE_IP(1, ip_end, ip))
+						goto input_overrun;
+					while (*ip == 0) {
+						t += 255;
+						ip++;
+						if (HAVE_IP(1, ip_end, ip))
+							goto input_overrun;
+					}
+					t += 31 + *ip++;
+				}
+				m_pos = op - 1;
+				m_pos -= get_unaligned_le16(ip) >> 2;
+				ip += 2;
+			} else if (t >= 16) {
+				m_pos = op;
+				m_pos -= (t & 8) << 11;
+
+				t &= 7;
+				if (t == 0) {
+					if (HAVE_IP(1, ip_end, ip))
+						goto input_overrun;
+					while (*ip == 0) {
+						t += 255;
+						ip++;
+						if (HAVE_IP(1, ip_end, ip))
+							goto input_overrun;
+					}
+					t += 7 + *ip++;
+				}
+				m_pos -= get_unaligned_le16(ip) >> 2;
+				ip += 2;
+				if (m_pos == op)
+					goto eof_found;
+				m_pos -= 0x4000;
+			} else {
+				m_pos = op - 1;
+				m_pos -= t >> 2;
+				m_pos -= *ip++ << 2;
+
+				if (HAVE_LB(m_pos, out, op))
+					goto lookbehind_overrun;
+				if (HAVE_OP(2, op_end, op))
+					goto output_overrun;
+
+				*op++ = *m_pos++;
+				*op++ = *m_pos;
+				goto match_done;
+			}
+
+			if (HAVE_LB(m_pos, out, op))
+				goto lookbehind_overrun;
+			if (HAVE_OP(t + 3 - 1, op_end, op))
+				goto output_overrun;
+
+			if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
+				COPY4(op, m_pos);
+				op += 4;
+				m_pos += 4;
+				t -= 4 - (3 - 1);
+				do {
+					COPY4(op, m_pos);
+					op += 4;
+					m_pos += 4;
+					t -= 4;
+				} while (t >= 4);
+				if (t > 0)
+					do {
+						*op++ = *m_pos++;
+					} while (--t > 0);
+			} else {
+copy_match:
+				*op++ = *m_pos++;
+				*op++ = *m_pos++;
+				do {
+					*op++ = *m_pos++;
+				} while (--t > 0);
+			}
+match_done:
+			t = ip[-2] & 3;
+			if (t == 0)
+				break;
+match_next:
+			if (HAVE_OP(t, op_end, op))
+				goto output_overrun;
+			if (HAVE_IP(t + 1, ip_end, ip))
+				goto input_overrun;
+
+			*op++ = *ip++;
+			if (t > 1) {
+				*op++ = *ip++;
+				if (t > 2)
+					*op++ = *ip++;
+			}
+
+			t = *ip++;
+		} while (ip < ip_end);
+	}
+
+	*out_len = op - out;
+	return LZO_E_EOF_NOT_FOUND;
+
+eof_found:
+	*out_len = op - out;
+	return (ip == ip_end ? LZO_E_OK :
+		(ip < ip_end ? LZO_E_INPUT_NOT_CONSUMED : LZO_E_INPUT_OVERRUN));
+input_overrun:
+	*out_len = op - out;
+	return LZO_E_INPUT_OVERRUN;
+
+output_overrun:
+	*out_len = op - out;
+	return LZO_E_OUTPUT_OVERRUN;
+
+lookbehind_overrun:
+	*out_len = op - out;
+	return LZO_E_LOOKBEHIND_OVERRUN;
+}
+#ifndef STATIC
+EXPORT_SYMBOL_GPL(lzo1x_decompress_safe);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZO1X Decompressor");
+
+#endif

