Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaK1QC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:02:56 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36715 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaK1QCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:02:03 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] lib: bitmap: Eliminate branch in __bitmap_shift_left
Date: Fri, 28 Nov 2014 17:01:09 +0100
Message-Id: <1417190476-18066-7-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can shift the bits from lower and upper into place before
assembling dst[k + off]; moving the shift of lower into the branch
where we already know that rem is non-zero allows us to remove a
conditional.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/bitmap.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 5edd71b..2362601 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -167,15 +167,14 @@ void __bitmap_shift_left(unsigned long *dst, const unsigned long *src,
 		 * word below and make them the bottom rem bits of result.
 		 */
 		if (rem && k > 0)
-			lower = src[k - 1];
+			lower = src[k - 1] >> (BITS_PER_LONG - rem);
 		else
 			lower = 0;
 		upper = src[k];
 		if (left && k == lim - 1)
 			upper &= (1UL << left) - 1;
-		dst[k + off] = upper << rem;
-		if (rem)
-			dst[k + off] |= lower >> (BITS_PER_LONG - rem);
+		upper <<= rem;
+		dst[k + off] = lower | upper;
 		if (left && k + off == lim - 1)
 			dst[k + off] &= (1UL << left) - 1;
 	}
-- 
2.0.4

