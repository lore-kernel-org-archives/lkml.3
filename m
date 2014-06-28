Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbaF1SFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:05:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbaF1Rw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.15 109/139] Revert "offb: Add palette hack for little endian"
Date: Sat, 28 Jun 2014 10:47:50 -0700
Message-Id: <20140628174610.397836148@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/offb.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/video/fbdev/offb.c
+++ b/drivers/video/fbdev/offb.c
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
@@ -129,7 +120,7 @@ static int offb_setcolreg(u_int regno, u
 			mask <<= info->var.transp.offset;
 			value |= mask;
 		}
-		pal[regno] = offb_cmap_byteswap(info, value);
+		pal[regno] = value;
 		return 0;
 	}
 


