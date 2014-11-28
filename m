Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaK1QBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:01:48 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:41163 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaK1QBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:01:46 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] lib: bitmap: Eliminate branch in __bitmap_shift_right
Date: Fri, 28 Nov 2014 17:01:05 +0100
Message-Id: <1417190476-18066-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can shift the bits from lower and upper into place before
assembling dst[k]; moving the shift of upper into the branch where we
already know that rem is non-zero allows us to remove a
conditional.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/bitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 2332115..9250c3f 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -127,13 +127,13 @@ void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
 			upper = src[off + k + 1];
 			if (off + k + 1 == lim - 1 && left)
 				upper &= mask;
+			upper <<= (BITS_PER_LONG - rem);
 		}
 		lower = src[off + k];
 		if (left && off + k == lim - 1)
 			lower &= mask;
-		dst[k] = lower >> rem;
-		if (rem)
-			dst[k] |= upper << (BITS_PER_LONG - rem);
+		lower >>= rem;
+		dst[k] = lower | upper;
 		if (left && k == lim - 1)
 			dst[k] &= mask;
 	}
-- 
2.0.4

