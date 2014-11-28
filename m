Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaK1QBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:01:55 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:60958 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaK1QBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:01:53 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] lib: bitmap: Yet another simplification in __bitmap_shift_right
Date: Fri, 28 Nov 2014 17:01:07 +0100
Message-Id: <1417190476-18066-5-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If left is 0, we can just let mask be ~0UL, so that anding with it is
a no-op. Conveniently, BITMAP_LAST_WORD_MASK provides precisely what
we need, and we can eliminate left.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/bitmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 20bb314..0d78c96 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -111,9 +111,9 @@ EXPORT_SYMBOL(__bitmap_complement);
 void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
 			unsigned shift, unsigned nbits)
 {
-	unsigned k, lim = BITS_TO_LONGS(nbits), left = nbits % BITS_PER_LONG;
+	unsigned k, lim = BITS_TO_LONGS(nbits);
 	unsigned off = shift/BITS_PER_LONG, rem = shift % BITS_PER_LONG;
-	unsigned long mask = (1UL << left) - 1;
+	unsigned long mask = BITMAP_LAST_WORD_MASK(nbits);
 	for (k = 0; off + k < lim; ++k) {
 		unsigned long upper, lower;
 
@@ -125,12 +125,12 @@ void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
 			upper = 0;
 		else {
 			upper = src[off + k + 1];
-			if (off + k + 1 == lim - 1 && left)
+			if (off + k + 1 == lim - 1)
 				upper &= mask;
 			upper <<= (BITS_PER_LONG - rem);
 		}
 		lower = src[off + k];
-		if (left && off + k == lim - 1)
+		if (off + k == lim - 1)
 			lower &= mask;
 		lower >>= rem;
 		dst[k] = lower | upper;
-- 
2.0.4

