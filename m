Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab3E2QNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:13:32 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:64710 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab3E2QNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:13:04 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Pallav Joshi <pallav.joshi@xilinx.com>, git-dev@xilinx.com,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 2/3] video: xilinxfb: Do not use out_be32 IO function
Date: Wed, 29 May 2013 18:12:57 +0200
Message-Id: <b05a2b1821043b192bb38d7ba0b04342db26c1f9.1369843969.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <502367ddf6d79b7b343b3165ad54cb9e2d4713db.1369843969.git.michal.simek@xilinx.com>
References: <502367ddf6d79b7b343b3165ad54cb9e2d4713db.1369843969.git.michal.simek@xilinx.com>
In-Reply-To: <502367ddf6d79b7b343b3165ad54cb9e2d4713db.1369843969.git.michal.simek@xilinx.com>
References: <502367ddf6d79b7b343b3165ad54cb9e2d4713db.1369843969.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-20195-1369843980-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-20195-1369843980-0001

out_be32 IO function is not supported by ARM.
It is only available for PPC and Microblaze.

Remove all out_be32 references and start to use __raw_writel
function.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/video/xilinxfb.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 5af341e..dcf0552 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -57,7 +57,7 @@
  * In case of direct PLB access the second control register will be at
  * an offset of 4 as compared to the DCR access where the offset is 1
  * i.e. REG_CTRL. So this is taken care in the function
- * xilinx_fb_out_be32 where it left shifts the offset 2 times in case of
+ * xilinx_fb_out32 where it left shifts the offset 2 times in case of
  * direct PLB access.
  */
 #define NUM_REGS	2
@@ -150,11 +150,11 @@ struct xilinxfb_drvdata {
  * To perform the read/write on the registers we need to check on
  * which bus its connected and call the appropriate write API.
  */
-static void xilinx_fb_out_be32(struct xilinxfb_drvdata *drvdata, u32 offset,
+static void xilinx_fb_out32(struct xilinxfb_drvdata *drvdata, u32 offset,
 				u32 val)
 {
 	if (drvdata->flags & PLB_ACCESS_FLAG)
-		out_be32(drvdata->regs + (offset << 2), val);
+		__raw_writel(val, drvdata->regs + (offset << 2));
 #ifdef CONFIG_PPC_DCR
 	else
 		dcr_write(drvdata->dcr_host, offset, val);
@@ -197,7 +197,7 @@ xilinx_fb_blank(int blank_mode, struct fb_info *fbi)
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
 		/* turn on panel */
-		xilinx_fb_out_be32(drvdata, REG_CTRL, drvdata->reg_ctrl_default);
+		xilinx_fb_out32(drvdata, REG_CTRL, drvdata->reg_ctrl_default);
 		break;

 	case FB_BLANK_NORMAL:
@@ -205,7 +205,7 @@ xilinx_fb_blank(int blank_mode, struct fb_info *fbi)
 	case FB_BLANK_HSYNC_SUSPEND:
 	case FB_BLANK_POWERDOWN:
 		/* turn off panel */
-		xilinx_fb_out_be32(drvdata, REG_CTRL, 0);
+		xilinx_fb_out32(drvdata, REG_CTRL, 0);
 	default:
 		break;

@@ -280,13 +280,13 @@ static int xilinxfb_assign(struct device *dev,
 	memset_io((void __iomem *)drvdata->fb_virt, 0, fbsize);

 	/* Tell the hardware where the frame buffer is */
-	xilinx_fb_out_be32(drvdata, REG_FB_ADDR, drvdata->fb_phys);
+	xilinx_fb_out32(drvdata, REG_FB_ADDR, drvdata->fb_phys);

 	/* Turn on the display */
 	drvdata->reg_ctrl_default = REG_CTRL_ENABLE;
 	if (pdata->rotate_screen)
 		drvdata->reg_ctrl_default |= REG_CTRL_ROTATE;
-	xilinx_fb_out_be32(drvdata, REG_CTRL,
+	xilinx_fb_out32(drvdata, REG_CTRL,
 					drvdata->reg_ctrl_default);

 	/* Fill struct fb_info */
@@ -345,7 +345,7 @@ err_cmap:
 		iounmap(drvdata->fb_virt);

 	/* Turn off the display */
-	xilinx_fb_out_be32(drvdata, REG_CTRL, 0);
+	xilinx_fb_out32(drvdata, REG_CTRL, 0);

 err_fbmem:
 	if (drvdata->flags & PLB_ACCESS_FLAG)
@@ -381,7 +381,7 @@ static int xilinxfb_release(struct device *dev)
 		iounmap(drvdata->fb_virt);

 	/* Turn off the display */
-	xilinx_fb_out_be32(drvdata, REG_CTRL, 0);
+	xilinx_fb_out32(drvdata, REG_CTRL, 0);

 	/* Release the resources, as allocated based on interface */
 	if (drvdata->flags & PLB_ACCESS_FLAG) {
--
1.8.2.3


--=_mimegpg-monstr-desktop-20195-1369843980-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGmKQwACgkQykllyylKDCGPTQCbBayeyuXORsQbC1/LgqAvcvxc
2o0AoIm6qgXDKsJwDTXp5qXu0FYOnj/I
=iADK
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-20195-1369843980-0001--
