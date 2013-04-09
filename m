Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936656Ab3DICpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:45:25 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45434 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762730Ab3DICpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:45:24 -0400
X-AuditID: 9c930197-b7b50ae00000018c-d8-516380bf30ca
From: Chanho Min <chanho.min@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Guennadi Liakhovetski <lg@denx.de>
Cc: linux-kernel@vger.kernel.org, Chanho Min <chanho.min@lge.com>
Subject: [PATCH v2] bitmap: speedup in bitmap_find_free_region when order is 0
Date: Tue,  9 Apr 2013 11:44:46 +0900
Message-Id: <1365475486-14371-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If bitmap_find_free_region() is called with order=0, We can reduce
for-loops to find 1 free bit. First, It scans bitmap array by the
increment of long type, then find 1 free bit within 1 long type value.

In 32 bits system and 1024 bits size, in the worst case, We need 1024
for-loops to find 1 free bit. But, If This is applied, it takes
64 for-loops. Instead, if free bit is in the first index of the bitmaps,
It will be needed additional 1 for-loop. But from second index, It
will speed up significantly.

Changes compared to v1:
 - Modified unnecessarily complicated code.
 - Fixed the buggy code if `bits' is not an multiple of BITS_PER_LONG.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 lib/bitmap.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 06f7e4f..663fc28 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1099,6 +1099,39 @@ done:
 }
 
 /**
+ * bitmap_find_free_one - find a mem region
+ *	@bitmap: array of unsigned longs corresponding to the bitmap
+ *	@bits: number of bits in the bitmap
+ *
+ * Find one of free (zero) bits in a @bitmap of @bits bits and
+ * allocate them (set them to one).
+ *
+ * Return the bit offset in bitmap of the allocated region,
+ * or -errno on failure.
+ */
+static int __bitmap_find_free_one(unsigned long *bitmap, int bits)
+{
+	int pos, end = BITS_PER_LONG, i;
+	int nlongs_reg = BITS_TO_LONGS(bits);
+	int last_bits = bits % BITS_PER_LONG;
+
+	for (i = 0 ; i < nlongs_reg ; i++) {
+		if (bitmap[i] != ~0UL) {
+			if (i == (nlongs_reg - 1) && last_bits)
+				end = last_bits;
+			for (pos = 0 ; pos < end ; pos++) {
+				if (!__reg_op(&bitmap[i], pos, 0,
+					REG_OP_ISFREE))
+					continue;
+				__reg_op(&bitmap[i], pos, 0, REG_OP_ALLOC);
+				return pos;
+			}
+		}
+	}
+	return -ENOMEM;
+}
+
+/**
  * bitmap_find_free_region - find a contiguous aligned mem region
  *	@bitmap: array of unsigned longs corresponding to the bitmap
  *	@bits: number of bits in the bitmap
@@ -1116,6 +1149,9 @@ int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
 {
 	int pos, end;		/* scans bitmap by regions of size order */
 
+	if (order == 0)
+		return __bitmap_find_free_one(bitmap, bits);
+
 	for (pos = 0 ; (end = pos + (1 << order)) <= bits; pos = end) {
 		if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 			continue;
-- 
1.7.9.5

