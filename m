Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbaLLGWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:22:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51782 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759476AbaLLGRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:15 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mikulas Patocka" <mpatocka@redhat.com>,
        "Tomi Valkeinen" <tomi.valkeinen@ti.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.622933312@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 039/164] framebuffer: fix screen corruption when copying
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/cfbcopyarea.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/video/cfbcopyarea.c
+++ b/drivers/video/cfbcopyarea.c
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

