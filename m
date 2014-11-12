Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbaKLBcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:32:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaKLBc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:32:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 245/319] lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
Date: Wed, 12 Nov 2014 10:16:23 +0900
Message-Id: <20141112011033.376535769@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/bitmap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -131,7 +131,9 @@ void __bitmap_shift_right(unsigned long
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
@@ -172,7 +174,9 @@ void __bitmap_shift_left(unsigned long *
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


