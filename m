Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaIPQjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:39:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbaIPQjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:39:00 -0400
Date: Tue, 16 Sep 2014 12:38:53 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] framebuffer: fix screen corruption when copying
Message-ID: <alpine.LRH.2.02.1409161236550.3150@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function bitcpy_rev has a bug that may result in screen corruption.
The bug happens under these conditions:
* the end of the destination area of a copy operation is aligned on a long
  word boundary
* the end of the source area is not aligned on a long word boundary
* we are copying more than one long word

In this case, the variable shift is non-zero and the variable first is
zero. The statements FB_WRITEL(comp(d0, FB_READL(dst), first), dst) reads
the last long word of the destination and writes it back unchanged
(because first is zero). Correctly, we should write the variable d0 to the
last word of the destination in this case.

This patch fixes the bug by introducing and extra test if first is zero.

The patch also removes the references to fb_memmove in the code that is
commented out because fb_memmove was removed from framebuffer subsystem.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

Index: linux-3.16.1/drivers/video/fbdev/core/cfbcopyarea.c
===================================================================
--- linux-3.16.1.orig/drivers/video/cfbcopyarea.c
+++ linux-3.16.1/drivers/video/fbdev/core/cfbcopyarea.c
@@ -55,8 +55,8 @@ bitcpy(struct fb_info *p, unsigned long
 	 * If you suspect bug in this function, compare it with this simple
 	 * memmove implementation.
 	 */
-	fb_memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
-		   (char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
+	memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
+		(char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
 	return;
 #endif
 
@@ -221,8 +221,8 @@ bitcpy_rev(struct fb_info *p, unsigned l
 	 * If you suspect bug in this function, compare it with this simple
 	 * memmove implementation.
 	 */
-	fb_memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
-		   (char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
+	memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
+		(char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
 	return;
 #endif
 
@@ -324,7 +324,10 @@ bitcpy_rev(struct fb_info *p, unsigned l
 				d0 = d0 << left | d1 >> right;
 			}
 			d0 = fb_rev_pixels_in_long(d0, bswapmask);
-			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
+			if (!first)
+				FB_WRITEL(d0, dst);
+			else
+				FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
 			d0 = d1;
 			dst--;
 			n -= dst_idx+1;
