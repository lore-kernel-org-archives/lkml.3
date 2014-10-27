Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaJ0TV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:21:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52599 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaJ0TCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:02:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 068/105] framebuffer: fix screen corruption when copying
Date: Mon, 27 Oct 2014 11:56:43 -0700
Message-Id: <1414436240-13879-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/video/cfbcopyarea.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/video/cfbcopyarea.c b/drivers/video/cfbcopyarea.c
index bcb5723..6d4bfee 100644
--- a/drivers/video/cfbcopyarea.c
+++ b/drivers/video/cfbcopyarea.c
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
1.9.1

