Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbaGOViM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:38:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54726 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883AbaGOVhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:37:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 147/198] Revert "offb: Add palette hack for little endian"
Date: Tue, 15 Jul 2014 14:30:17 -0700
Message-Id: <1405459868-15089-148-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 68986c9f0f4552c34c248501eb0c690553866d6e upstream.

This reverts commit e1edf18b20076da83dd231dbd2146cbbc31c0b14.

This patch was a misguided attempt at fixing offb for LE ppc64
kernels on BE qemu but is just wrong ... it breaks real LE/LE
setups, LE with real HW, and existing mixed endian systems
that did the fight thing with the appropriate device-tree
property. Bad reviewing on my part, sorry.

The right fix is to either make qemu change its endian when
the guest changes endian (working on that) or to use the
existing foreign endian support.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/video/offb.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/video/offb.c b/drivers/video/offb.c
index 7d44d66..43a0a52 100644
--- a/drivers/video/offb.c
+++ b/drivers/video/offb.c
@@ -91,15 +91,6 @@ extern boot_infos_t *boot_infos;
 #define AVIVO_DC_LUTB_WHITE_OFFSET_GREEN        0x6cd4
 #define AVIVO_DC_LUTB_WHITE_OFFSET_RED          0x6cd8
 
-#define FB_RIGHT_POS(p, bpp)         (fb_be_math(p) ? 0 : (32 - (bpp)))
-
-static inline u32 offb_cmap_byteswap(struct fb_info *info, u32 value)
-{
-	u32 bpp = info->var.bits_per_pixel;
-
-	return cpu_to_be32(value) >> FB_RIGHT_POS(info, bpp);
-}
-
     /*
      *  Set a single color register. The values supplied are already
      *  rounded down to the hardware's capabilities (according to the
@@ -129,7 +120,7 @@ static int offb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 			mask <<= info->var.transp.offset;
 			value |= mask;
 		}
-		pal[regno] = offb_cmap_byteswap(info, value);
+		pal[regno] = value;
 		return 0;
 	}
 
-- 
1.9.1

