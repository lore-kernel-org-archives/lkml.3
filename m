Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbaGCWo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:44:57 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:36915 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759905AbaGCWnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:43 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 14/18] lib: bitmap: Change parameter of bitmap_*_region to unsigned
Date: Fri,  4 Jul 2014 00:43:00 +0200
Message-Id: <1404427384-11422-15-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the pos parameter of __reg_op to unsigned allows the compiler
to generate slightly smaller and simpler code. Also update its callers
bitmap_*_region to receive and pass unsigned int. The return types of
bitmap_find_free_region and bitmap_allocate_region are still int to
allow a negative error code to be returned. An int is certainly
capable of representing any realistic return value.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h |  6 +++---
 lib/bitmap.c           | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 83c1c7d..2100378 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -140,9 +140,9 @@ extern void bitmap_onto(unsigned long *dst, const unsigned long *orig,
 		const unsigned long *relmap, int bits);
 extern void bitmap_fold(unsigned long *dst, const unsigned long *orig,
 		int sz, int bits);
-extern int bitmap_find_free_region(unsigned long *bitmap, int bits, int order);
-extern void bitmap_release_region(unsigned long *bitmap, int pos, int order);
-extern int bitmap_allocate_region(unsigned long *bitmap, int pos, int order);
+extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
+extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
+extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
 extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
 extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int bits);
 
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 2714df9..c2f3807 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1042,7 +1042,7 @@ enum {
 	REG_OP_RELEASE,		/* clear all bits in region */
 };
 
-static int __reg_op(unsigned long *bitmap, int pos, int order, int reg_op)
+static int __reg_op(unsigned long *bitmap, unsigned int pos, int order, int reg_op)
 {
 	int nbits_reg;		/* number of bits in region */
 	int index;		/* index first long of region in bitmap */
@@ -1108,11 +1108,11 @@ done:
  * Return the bit offset in bitmap of the allocated region,
  * or -errno on failure.
  */
-int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
+int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order)
 {
-	int pos, end;		/* scans bitmap by regions of size order */
+	unsigned int pos, end;		/* scans bitmap by regions of size order */
 
-	for (pos = 0 ; (end = pos + (1 << order)) <= bits; pos = end) {
+	for (pos = 0 ; (end = pos + (1U << order)) <= bits; pos = end) {
 		if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 			continue;
 		__reg_op(bitmap, pos, order, REG_OP_ALLOC);
@@ -1133,7 +1133,7 @@ EXPORT_SYMBOL(bitmap_find_free_region);
  *
  * No return value.
  */
-void bitmap_release_region(unsigned long *bitmap, int pos, int order)
+void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order)
 {
 	__reg_op(bitmap, pos, order, REG_OP_RELEASE);
 }
@@ -1150,7 +1150,7 @@ EXPORT_SYMBOL(bitmap_release_region);
  * Return 0 on success, or %-EBUSY if specified region wasn't
  * free (not all bits were zero).
  */
-int bitmap_allocate_region(unsigned long *bitmap, int pos, int order)
+int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order)
 {
 	if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 		return -EBUSY;
-- 
1.9.2

