Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbaJVMwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:52:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049AbaJVMwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:52:10 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>, stable@vger.kernel.org
Subject: [PATCH] bitmap: Fix undefined shift in __bitmap_shift_{left|right}()
Date: Wed, 22 Oct 2014 14:51:45 +0200
Message-Id: <1413982305-7272-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If __bitmap_shift_left() or __bitmap_shift_right() are asked to shift by
a multiple of BITS_PER_LONG, they will try to shift a long value by
BITS_PER_LONG bits which is undefined. Change the functions to avoid the
undefined shift.

Coverity-id: 1192175
Coverity-id: 1192174
CC: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/bitmap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index cd250a2e14cb..b499ab6ada29 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -131,7 +131,9 @@ void __bitmap_shift_right(unsigned long *dst,
 		lower = src[off + k];
 		if (left && off + k == lim - 1)
 			lower &= mask;
-		dst[k] = upper << (BITS_PER_LONG - rem) | lower >> rem;
+		dst[k] = lower >> rem;
+		if (rem)
+			dst[k] |= upper << (BITS_PER_LONG - rem);
 		if (left && k == lim - 1)
 			dst[k] &= mask;
 	}
@@ -172,7 +174,9 @@ void __bitmap_shift_left(unsigned long *dst,
 		upper = src[k];
 		if (left && k == lim - 1)
 			upper &= (1UL << left) - 1;
-		dst[k + off] = lower  >> (BITS_PER_LONG - rem) | upper << rem;
+		dst[k + off] = upper << rem;
+		if (rem)
+			dst[k + off] |= lower >> (BITS_PER_LONG - rem);
 		if (left && k + off == lim - 1)
 			dst[k + off] &= (1UL << left) - 1;
 	}
-- 
1.8.1.4

