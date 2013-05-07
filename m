Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab3EGIQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:16:05 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44501 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993Ab3EGIQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:16:00 -0400
X-AuditID: 9c930197-b7c1fae000001854-f7-5188b83d7c86
From: Chanho Min <chanho.min@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Chanho Min <chanho.min@lge.com>
Subject: [PATCH RESEND v3] bitmap: speed up bitmap_find_free_region
Date: Tue,  7 May 2013 17:15:53 +0900
Message-Id: <1367914553-1999-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In bitmap_find_free_region, If we skip the all-ones words and find bits
in a not-all-ones word, we can improve performance of it.

For example, If bitmap_find_free_region() is called with order=0, First,
It scans bitmap array by the increment of long type, then find 1 free bit
within 1 long type value. In 32 bits system and 1024 bits size, in the worst
case, We need 1024 for-loops to find 1 free bit. But, If this is applied,
it takes 64 for-loops. Instead, It will be needed additional if-comparison
of every word and It can take time slightly as 'Test case 3'. But, In many
cases, It will speed up significantly.

Test cases bellows show the time taken to execute bitmap_find_free_region()
before and after patch.

Test condition : ARMv7 1GHZ 32 bits system, 1024 bits size, gcc 4.6.2

Test case 1: order is 0. all bits are one except that last one bit is zero.
 before patch: 29727 ns
 after patch: 2349 ns

Test case 2: order is 1. all bits are one except that last 2 contiguous bits
are zero.
 before patch: 15475 ns
 after patch: 2225 ns

Test case 3: order is 1. all words are not-all-ones and don't have 2 contiguous
bits except that last 2 contiguous are zero.
 before patch: 15475 ns
 after patch: 16131 ns

Changes compared to v1:
 - Modified unnecessarily complicated code.
 - Fixed the buggy code if `bits' is not an multiple of BITS_PER_LONG.

Changes compared to v2:
 - Removed bitmap_find_free_one and merged it to bitmap_find_free_region.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 lib/bitmap.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 06f7e4f..95e8efc 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1114,14 +1114,21 @@ done:
  */
 int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
 {
-	int pos, end;		/* scans bitmap by regions of size order */
-
-	for (pos = 0 ; (end = pos + (1 << order)) <= bits; pos = end) {
-		if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
-			continue;
-		__reg_op(bitmap, pos, order, REG_OP_ALLOC);
-		return pos;
-	}
+	int pos, end, nbit, i;	/* scans bitmap by regions of size order */
+	int nlongs = BITS_TO_LONGS(bits);
+
+	for (i = 0; i < nlongs; i++)
+		if (bitmap[i] != ~0UL) {
+			pos = i * BITS_PER_LONG;
+			nbit = min(bits, pos + BITS_PER_LONG);
+			for (; (end = pos + (1 << order)) <= nbit; pos = end) {
+				if (!__reg_op(bitmap, pos, order,
+					REG_OP_ISFREE))
+					continue;
+				__reg_op(bitmap, pos, order, REG_OP_ALLOC);
+				return pos;
+			}
+		}
 	return -ENOMEM;
 }
 EXPORT_SYMBOL(bitmap_find_free_region);
-- 
1.7.9.5

