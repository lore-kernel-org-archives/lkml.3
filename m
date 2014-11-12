Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaKLBYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:24:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbaKLBYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:24:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 3.17 097/319] framebuffer: fix screen corruption when copying
Date: Wed, 12 Nov 2014 10:13:55 +0900
Message-Id: <20141112011008.573459464@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5b789da8a7fc357661fc61faaf853e9161cc9700 upstream.

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
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/core/cfbcopyarea.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/video/fbdev/core/cfbcopyarea.c
+++ b/drivers/video/fbdev/core/cfbcopyarea.c
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


