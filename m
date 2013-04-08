Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762Ab3DHCYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 22:24:31 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53523 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760854Ab3DHCY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 22:24:29 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-a4-51622a5af3c1
From: Chanho Min <chanho.min@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Guennadi Liakhovetski <lg@denx.de>
Cc: linux-kernel@vger.kernel.org, Chanho Min <chanho.min@lge.com>
Subject: [PATCH] bitmap: speedup in bitmap_find_free_region when order is 0
Date: Mon,  8 Apr 2013 11:23:48 +0900
Message-Id: <1365387828-24326-1-git-send-email-chanho.min@lge.com>
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
will be speed up significantly.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 lib/bitmap.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 06f7e4f..0c1f03a 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1099,6 +1099,37 @@ done:
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
+	int pos, i;
+	unsigned long mask = (unsigned long)(~((unsigned long) 0));
+	int nlongs_reg = BITS_TO_LONGS(bits);
+
+	for (i = 0 ; i < nlongs_reg ; i++) {
+		if ((bitmap[i] & mask) != mask) {
+			for (pos = 0 ; pos < BITS_PER_LONG ; pos++) {
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
@@ -1116,6 +1147,9 @@ int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
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

