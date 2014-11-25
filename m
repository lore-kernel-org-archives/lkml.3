Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaKYL3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:29:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58572 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaKYKly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 115/254] framebuffer: fix screen corruption when copying
Date: Tue, 25 Nov 2014 10:37:45 +0000
Message-Id: <1416912004-5928-116-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/fbdev/core/cfbcopyarea.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/core/cfbcopyarea.c b/drivers/video/fbdev/core/cfbcopyarea.c
index bcb57235fcc7..6d4bfeecee35 100644
--- a/drivers/video/fbdev/core/cfbcopyarea.c
+++ b/drivers/video/fbdev/core/cfbcopyarea.c
@@ -55,8 +55,8 @@ bitcpy(struct fb_info *p, unsigned long __iomem *dst, unsigned dst_idx,
 	 * If you suspect bug in this function, compare it with this simple
 	 * memmove implementation.
 	 */
-	fb_memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
-		   (char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
+	memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
+		(char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
 	return;
 #endif
 
@@ -221,8 +221,8 @@ bitcpy_rev(struct fb_info *p, unsigned long __iomem *dst, unsigned dst_idx,
 	 * If you suspect bug in this function, compare it with this simple
 	 * memmove implementation.
 	 */
-	fb_memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
-		   (char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
+	memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
+		(char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
 	return;
 #endif
 
@@ -324,7 +324,10 @@ bitcpy_rev(struct fb_info *p, unsigned long __iomem *dst, unsigned dst_idx,
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
-- 
2.1.0

