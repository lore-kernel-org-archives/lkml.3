Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbaLLGSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:18:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52417 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759431AbaLLGSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:18:04 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Don A. Bailey" <donb@securitymouse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Willem Pinckaers" <willem@lekkertech.net>, "Willy Tarreau" <w@1wt.eu>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.266975681@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 035/164] lzo: check for length overrun in variable
 length encoding.
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Willy Tarreau <w@1wt.eu>

commit 72cf90124e87d975d0b2114d930808c58b4c05e4 upstream.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 lib/lzo/lzo1x_decompress_safe.c | 43 +++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

--- a/lib/lzo/lzo1x_decompress_safe.c
+++ b/lib/lzo/lzo1x_decompress_safe.c
@@ -25,6 +25,16 @@
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
@@ -55,12 +65,19 @@ int lzo1x_decompress_safe(const unsigned
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
@@ -116,12 +133,19 @@ copy_literal_run:
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
@@ -134,12 +158,19 @@ copy_literal_run:
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

