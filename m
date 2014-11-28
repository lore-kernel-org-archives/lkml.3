Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaK1QCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:02:09 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:44736 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaK1QCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:02:06 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] lib: bitmap: Remove redundant code from __bitmap_shift_left
Date: Fri, 28 Nov 2014 17:01:10 +0100
Message-Id: <1417190476-18066-8-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first of these conditionals is completely redundant: If k ==
lim-1, we must have off==0, so the second conditional will also
trigger and then it wouldn't matter if upper had some high bits
set. But the second conditional is in fact also redundant, since it
only serves to clear out some high-order "don't care" bits of dst,
about which no guarantee is made.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/bitmap.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 2362601..acea8ae 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -157,7 +157,7 @@ void __bitmap_shift_left(unsigned long *dst, const unsigned long *src,
 			unsigned int shift, unsigned int nbits)
 {
 	int k;
-	unsigned int lim = BITS_TO_LONGS(nbits), left = nbits % BITS_PER_LONG;
+	unsigned int lim = BITS_TO_LONGS(nbits);
 	unsigned int off = shift/BITS_PER_LONG, rem = shift % BITS_PER_LONG;
 	for (k = lim - off - 1; k >= 0; --k) {
 		unsigned long upper, lower;
@@ -170,13 +170,8 @@ void __bitmap_shift_left(unsigned long *dst, const unsigned long *src,
 			lower = src[k - 1] >> (BITS_PER_LONG - rem);
 		else
 			lower = 0;
-		upper = src[k];
-		if (left && k == lim - 1)
-			upper &= (1UL << left) - 1;
-		upper <<= rem;
+		upper = src[k] << rem;
 		dst[k + off] = lower | upper;
-		if (left && k + off == lim - 1)
-			dst[k + off] &= (1UL << left) - 1;
 	}
 	if (off)
 		memset(dst, 0, off*sizeof(unsigned long));
-- 
2.0.4

