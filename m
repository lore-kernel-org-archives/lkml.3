Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbaJVMoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:44:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049AbaJVMoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:44:03 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>, stable@vger.kernel.org
Subject: [PATCH] bitmap: Fix undefined shift in __bitmap_shift_left()
Date: Wed, 22 Oct 2014 14:43:51 +0200
Message-Id: <1413981831-6902-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It __bitmap_shift_left() is asked to shift by a multiple of
BITS_PER_LONG, it will try to shift a long value by BITS_PER_LONG bits
which is undefined. Change the function to take this into account.

Coverity-id: 1192175
CC: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/bitmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index cd250a2e14cb..02a8a439fcc7 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -172,7 +172,9 @@ void __bitmap_shift_left(unsigned long *dst,
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

