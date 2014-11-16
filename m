Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaKPWKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:10:31 -0500
Received: from 1wt.eu ([62.212.114.60]:47926 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaKPWAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:52 -0500
Message-Id: <20141116215330.521414973@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:54:13 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Don A. Bailey" <donb@securitymouse.com>, Willy Tarreau <w@1wt.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 45/48] lzo: check for length overrun in variable length
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 encoding.

From: Willy Tarreau <w@1wt.eu>

This fix ensures that we never meet an integer overflow while adding
255 while parsing a variable length encoding. It works differently from
commit 206a81c ("lzo: properly check for overruns") because instead of
ensuring that we don't overrun the input, which is tricky to guarantee
due to many assumptions in the code, it simply checks that the cumulated
number of 255 read cannot overflow by bounding this number.

The MAX_255_COUNT is the maximum number of times we can add 255 to a base
count without overflowing an integer. The multiply will overflow when
multiplying 255 by more than MAXINT/255. The sum will overflow earlier
depending on the base count. Since the base count is taken from a u8
and a few bits, it is safe to assume that it will always be lower than
or equal to 2*255, thus we can always prevent any overflow by accepting
two less 255 steps.

This patch also reduces the CPU overhead and actually increases performance
by 1.1% compared to the initial code, while the previous fix costs 3.1%
(measured on x86_64).

The fix needs to be backported to all currently supported stable kernels.

Reported-by: Willem Pinckaers <willem@lekkertech.net>
Cc: "Don A. Bailey" <donb@securitymouse.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 72cf90124e87d975d0b2114d930808c58b4c05e4)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 lib/lzo/lzo1x_decompress.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/lib/lzo/lzo1x_decompress.c b/lib/lzo/lzo1x_decompress.c
index 2aa2915..eabee8f 100644
--- a/lib/lzo/lzo1x_decompress.c
+++ b/lib/lzo/lzo1x_decompress.c
@@ -24,6 +24,16 @@
 #define NEED_OP(x)      if (!HAVE_OP(x)) goto output_overrun
 #define TEST_LB(m_pos)  if ((m_pos) < out) goto lookbehind_overrun
 
+/* This MAX_255_COUNT is the maximum number of times we can add 255 to a base
+ * count without overflowing an integer. The multiply will overflow when
+ * multiplying 255 by more than MAXINT/255. The sum will overflow earlier
+ * depending on the base count. Since the base count is taken from a u8
+ * and a few bits, it is safe to assume that it will always be lower than
+ * or equal to 2*255, thus we can always prevent any overflow by accepting
+ * two less 255 steps. See Documentation/lzo.txt for more information.
+ */
+#define MAX_255_COUNT      ((((size_t)~0) / 255) - 2)
+
 int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 			  unsigned char *out, size_t *out_len)
 {
@@ -54,12 +64,19 @@ int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 		if (t < 16) {
 			if (likely(state == 0)) {
 				if (unlikely(t == 0)) {
+					size_t offset;
+					const unsigned char *ip_last = ip;
+
 					while (unlikely(*ip == 0)) {
-						t += 255;
 						ip++;
 						NEED_IP(1);
 					}
-					t += 15 + *ip++;
+					offset = ip - ip_last;
+					if (unlikely(offset > MAX_255_COUNT))
+						return LZO_E_ERROR;
+
+					offset = (offset << 8) - offset;
+					t += offset + 15 + *ip++;
 				}
 				t += 3;
 copy_literal_run:
@@ -115,12 +132,19 @@ copy_literal_run:
 		} else if (t >= 32) {
 			t = (t & 31) + (3 - 1);
 			if (unlikely(t == 2)) {
+				size_t offset;
+				const unsigned char *ip_last = ip;
+
 				while (unlikely(*ip == 0)) {
-					t += 255;
 					ip++;
 					NEED_IP(1);
 				}
-				t += 31 + *ip++;
+				offset = ip - ip_last;
+				if (unlikely(offset > MAX_255_COUNT))
+					return LZO_E_ERROR;
+
+				offset = (offset << 8) - offset;
+				t += offset + 31 + *ip++;
 				NEED_IP(2);
 			}
 			m_pos = op - 1;
@@ -133,12 +157,19 @@ copy_literal_run:
 			m_pos -= (t & 8) << 11;
 			t = (t & 7) + (3 - 1);
 			if (unlikely(t == 2)) {
+				size_t offset;
+				const unsigned char *ip_last = ip;
+
 				while (unlikely(*ip == 0)) {
-					t += 255;
 					ip++;
 					NEED_IP(1);
 				}
-				t += 7 + *ip++;
+				offset = ip - ip_last;
+				if (unlikely(offset > MAX_255_COUNT))
+					return LZO_E_ERROR;
+
+				offset = (offset << 8) - offset;
+				t += offset + 7 + *ip++;
 				NEED_IP(2);
 			}
 			next = get_unaligned_le16(ip);
-- 
1.7.12.2.21.g234cd45.dirty



