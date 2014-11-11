Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaKKLLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:11:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57880 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaKKLL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 154/170] lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
Date: Tue, 11 Nov 2014 11:08:33 +0000
Message-Id: <1415704129-12709-155-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit ea5d05b34aca25c066e0699512d0ffbd8ee6ac3e upstream.

If __bitmap_shift_left() or __bitmap_shift_right() are asked to shift by
a multiple of BITS_PER_LONG, they will try to shift a long value by
BITS_PER_LONG bits which is undefined.  Change the functions to avoid
the undefined shift.

Coverity id: 1192175
Coverity id: 1192174
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 lib/bitmap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 06f7e4fe8d2d..e5c4ebe586ba 100644
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
2.1.0

