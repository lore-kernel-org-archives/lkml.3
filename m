Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3EaM45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:56:57 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34493 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab3EaM4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:56:13 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@tabi.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH v3 7/8] video: xilinxfb: Fix sparse warnings
Date: Fri, 31 May 2013 14:55:37 +0200
Message-Id: <ea3d6fcbb9f7a00a9cdbd3d0a7a4d3401265ebf0.1370004925.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8196-1370004968-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8196-1370004968-0001

Use proper casting for fb_virt variable.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v3:
- New patch in this patchset

Changes in v2: None

 drivers/video/xilinxfb.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index f3d4a69..e27a4f6 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -131,7 +131,7 @@ struct xilinxfb_drvdata {
 	dcr_host_t      dcr_host;
 	unsigned int    dcr_len;
 #endif
-	void		*fb_virt;	/* virt. address of the frame buffer */
+	void __iomem	*fb_virt;	/* virt. address of the frame buffer */
 	dma_addr_t	fb_phys;	/* phys. address of the frame buffer */
 	int		fb_alloced;	/* Flag, was the fb memory alloced? */

@@ -273,8 +273,10 @@ static int xilinxfb_assign(struct platform_device *pdev,
 		drvdata->fb_virt = ioremap(pdata->fb_phys, fbsize);
 	} else {
 		drvdata->fb_alloced = 1;
-		drvdata->fb_virt = dma_alloc_coherent(dev, PAGE_ALIGN(fbsize),
-					&drvdata->fb_phys, GFP_KERNEL);
+		drvdata->fb_virt = (__force void __iomem *)
+				   dma_alloc_coherent(dev, PAGE_ALIGN(fbsize),
+						      &drvdata->fb_phys,
+						      GFP_KERNEL);
 	}

 	if (!drvdata->fb_virt) {
@@ -287,7 +289,7 @@ static int xilinxfb_assign(struct platform_device *pdev,
 	}

 	/* Clear (turn to black) the framebuffer */
-	memset_io((void __iomem *)drvdata->fb_virt, 0, fbsize);
+	memset_io(drvdata->fb_virt, 0, fbsize);

 	/* Tell the hardware where the frame buffer is */
 	xilinx_fb_out32(drvdata, REG_FB_ADDR, drvdata->fb_phys);
@@ -307,7 +309,7 @@ static int xilinxfb_assign(struct platform_device *pdev,

 	/* Fill struct fb_info */
 	drvdata->info.device = dev;
-	drvdata->info.screen_base = (void __iomem *)drvdata->fb_virt;
+	drvdata->info.screen_base = drvdata->fb_virt;
 	drvdata->info.fbops = &xilinxfb_ops;
 	drvdata->info.fix = xilinx_fb_fix;
 	drvdata->info.fix.smem_start = drvdata->fb_phys;
@@ -341,8 +343,8 @@ static int xilinxfb_assign(struct platform_device *pdev,

 	if (drvdata->flags & BUS_ACCESS_FLAG) {
 		/* Put a banner in the log (for DEBUG) */
-		dev_dbg(dev, "regs: phys=%x, virt=%p\n", drvdata->regs_phys,
-					drvdata->regs);
+		dev_dbg(dev, "regs: phys=%x, virt=%p\n",
+			(u32)drvdata->regs_phys, drvdata->regs);
 	}
 	/* Put a banner in the log (for DEBUG) */
 	dev_dbg(dev, "fb: phys=%llx, virt=%p, size=%x\n",
@@ -355,8 +357,9 @@ err_regfb:

 err_cmap:
 	if (drvdata->fb_alloced)
-		dma_free_coherent(dev, PAGE_ALIGN(fbsize), drvdata->fb_virt,
-			drvdata->fb_phys);
+		dma_free_coherent(dev, PAGE_ALIGN(fbsize),
+				  (__force void *)drvdata->fb_virt,
+				  drvdata->fb_phys);
 	else
 		iounmap(drvdata->fb_virt);

@@ -388,7 +391,8 @@ static int xilinxfb_release(struct device *dev)

 	if (drvdata->fb_alloced)
 		dma_free_coherent(dev, PAGE_ALIGN(drvdata->info.fix.smem_len),
-				  drvdata->fb_virt, drvdata->fb_phys);
+				  (__force void *)drvdata->fb_virt,
+				  drvdata->fb_phys);
 	else
 		iounmap(drvdata->fb_virt);

--
1.8.2.3


--=_mimegpg-monstr-desktop-8196-1370004968-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGonegACgkQykllyylKDCEZUACePZ/J7l9I/d21unFDJM5QL47Q
/yQAoIANX+aDeer2S5ol5lvTaLD2vnqj
=ctnG
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8196-1370004968-0001--
