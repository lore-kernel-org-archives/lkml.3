Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbaDXMHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:07:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46240 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaDXIwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 006/182] mach64: use unaligned access
Date: Thu, 24 Apr 2014 09:48:51 +0100
Message-Id: <1398329507-5911-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit c29dd8696dc5dbd50b3ac441b8a26751277ba520 upstream.

This patch fixes mach64 to use unaligned access to the font bitmap.

This fixes unaligned access warning on sparc64 when 14x8 font is loaded.

On x86(64), unaligned access is handled in hardware, so both functions
le32_to_cpup and get_unaligned_le32 perform the same operation.

On RISC machines, unaligned access is not handled in hardware, so we
better use get_unaligned_le32 to avoid the unaligned trap and warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/aty/mach64_accel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/aty/mach64_accel.c b/drivers/video/aty/mach64_accel.c
index e45833c..182bd68 100644
--- a/drivers/video/aty/mach64_accel.c
+++ b/drivers/video/aty/mach64_accel.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/delay.h>
+#include <asm/unaligned.h>
 #include <linux/fb.h>
 #include <video/mach64.h>
 #include "atyfb.h"
@@ -419,7 +420,7 @@ void atyfb_imageblit(struct fb_info *info, const struct fb_image *image)
 		u32 *pbitmap, dwords = (src_bytes + 3) / 4;
 		for (pbitmap = (u32*)(image->data); dwords; dwords--, pbitmap++) {
 			wait_for_fifo(1, par);
-			aty_st_le32(HOST_DATA0, le32_to_cpup(pbitmap), par);
+			aty_st_le32(HOST_DATA0, get_unaligned_le32(pbitmap), par);
 		}
 	}
 
-- 
1.9.1

