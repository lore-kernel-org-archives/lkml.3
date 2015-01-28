Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbbA1EQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:16:11 -0500
Received: from mail.kernel.org ([198.145.29.136]:37635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760859AbbA1EQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:16:08 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        "Don A. Bailey" <donb@securitymouse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 030/177] lzo: check for length overrun in variable length encoding.
Date: Wed, 28 Jan 2015 12:07:07 +0800
Message-Id: <1422418236-12852-60-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 lib/lzo/lzo1x_decompress_safe.c | 43 +++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/lib/lzo/lzo1x_decompress_safe.c b/lib/lzo/lzo1x_decompress_safe.c
index 569985d..a1c387f 100644
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
@@ -55,12 +65,19 @@ int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
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
-- 
1.9.1

