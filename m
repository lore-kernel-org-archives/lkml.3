Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3EaOWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:22:35 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:48207 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3EaOW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:22:28 -0400
Message-ID: <51A8B220.6070308@monstr.eu>
Date: Fri, 31 May 2013 16:22:24 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Timur Tabi <timur@tabi.org>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3 7/8] video: xilinxfb: Fix sparse warnings
References: <cover.1370004925.git.michal.simek@xilinx.com> <ea3d6fcbb9f7a00a9cdbd3d0a7a4d3401265ebf0.1370004925.git.michal.simek@xilinx.com> <51A8A4ED.6070104@tabi.org> <51A8A7B1.3040709@monstr.eu> <51A8A89C.8030404@tabi.org>
In-Reply-To: <51A8A89C.8030404@tabi.org>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2LVILDVRGTUKTCOQRGRAN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2LVILDVRGTUKTCOQRGRAN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/31/2013 03:41 PM, Timur Tabi wrote:
> On 05/31/2013 08:37 AM, Michal Simek wrote:
>> The same is for Microblaze. Driver shares fb_virt for IO memory
>> and for allocated memory. The purpose of this driver wasn't
>> to change the driver logic just resolved sparse warnings.
>> The other way is also wrong.
>> I have compiled this driver with ppc toolchain and it should
>> remove sparse warnings for PPC.
>=20
> But it's not I/O memory.  It's regular memory.  __iomem is for
> memory-mapped I/O, which is limited to a specific range of memory locat=
ions.
>=20
> If sometimes you use regular memory for the framebuffer, and other time=
s
> you use real I/O memory for the framebuffer, then you should have two
> different pointers.

I agree with you and if you like I can change it.
But there will be at least one retype because dma_alloc_coherent returns =
void *
but struct fb_info expects that pointer is __iomem (char __iomem *screen_=
base).
Patch is below.

Thanks,
Michal


diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index f3d4a69..885f294 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -132,8 +132,8 @@ struct xilinxfb_drvdata {
 	unsigned int    dcr_len;
 #endif
 	void		*fb_virt;	/* virt. address of the frame buffer */
+	void __iomem	*fb_virt_io;	/* virt. address of the frame buffer */
 	dma_addr_t	fb_phys;	/* phys. address of the frame buffer */
-	int		fb_alloced;	/* Flag, was the fb memory alloced? */

 	u8 		flags;		/* features of the driver */

@@ -270,24 +270,36 @@ static int xilinxfb_assign(struct platform_device *=
pdev,
 	/* Allocate the framebuffer memory */
 	if (pdata->fb_phys) {
 		drvdata->fb_phys =3D pdata->fb_phys;
-		drvdata->fb_virt =3D ioremap(pdata->fb_phys, fbsize);
+		drvdata->fb_virt_io =3D ioremap(pdata->fb_phys, fbsize);
+
+		if (!drvdata->fb_virt_io) {
+			dev_err(dev, "Could not allocate frame buffer memory\n");
+			rc =3D -ENOMEM;
+			if (drvdata->flags & BUS_ACCESS_FLAG)
+				goto err_fbmem;
+			else
+				goto err_region;
+		}
+
+		/* Clear (turn to black) the framebuffer */
+		memset_io(drvdata->fb_virt_io, 0, fbsize);
 	} else {
-		drvdata->fb_alloced =3D 1;
 		drvdata->fb_virt =3D dma_alloc_coherent(dev, PAGE_ALIGN(fbsize),
 					&drvdata->fb_phys, GFP_KERNEL);
-	}

-	if (!drvdata->fb_virt) {
-		dev_err(dev, "Could not allocate frame buffer memory\n");
-		rc =3D -ENOMEM;
-		if (drvdata->flags & BUS_ACCESS_FLAG)
-			goto err_fbmem;
-		else
-			goto err_region;
+		if (!drvdata->fb_virt_io) {
+			dev_err(dev, "Could not allocate frame buffer memory\n");
+			rc =3D -ENOMEM;
+			if (drvdata->flags & BUS_ACCESS_FLAG)
+				goto err_fbmem;
+			else
+				goto err_region;
+		memset(drvdata->fb_virt, 0, fbsize);
 	}

-	/* Clear (turn to black) the framebuffer */
-	memset_io((void __iomem *)drvdata->fb_virt, 0, fbsize);
+

 	/* Tell the hardware where the frame buffer is */
 	xilinx_fb_out32(drvdata, REG_FB_ADDR, drvdata->fb_phys);
@@ -307,7 +319,11 @@ static int xilinxfb_assign(struct platform_device *p=
dev,

 	/* Fill struct fb_info */
 	drvdata->info.device =3D dev;
-	drvdata->info.screen_base =3D (void __iomem *)drvdata->fb_virt;
+	if (drvdata->fb_virt)
+		drvdata->info.screen_base =3D (__force void __iomem *)
+							drvdata->fb_virt;
+	else
+		drvdata->info.screen_base =3D drvdata->fb_virt_io;
 	drvdata->info.fbops =3D &xilinxfb_ops;
 	drvdata->info.fix =3D xilinx_fb_fix;
 	drvdata->info.fix.smem_start =3D drvdata->fb_phys;
@@ -341,8 +357,8 @@ static int xilinxfb_assign(struct platform_device *pd=
ev,

 	if (drvdata->flags & BUS_ACCESS_FLAG) {
 		/* Put a banner in the log (for DEBUG) */
-		dev_dbg(dev, "regs: phys=3D%x, virt=3D%p\n", drvdata->regs_phys,
-					drvdata->regs);
+		dev_dbg(dev, "regs: phys=3D%x, virt=3D%p\n",
+			(u32)drvdata->regs_phys, drvdata->regs);
 	}
 	/* Put a banner in the log (for DEBUG) */
 	dev_dbg(dev, "fb: phys=3D%llx, virt=3D%p, size=3D%x\n",
@@ -354,11 +370,11 @@ err_regfb:
 	fb_dealloc_cmap(&drvdata->info.cmap);

 err_cmap:
-	if (drvdata->fb_alloced)
+	if (drvdata->fb_virt)
 		dma_free_coherent(dev, PAGE_ALIGN(fbsize), drvdata->fb_virt,
 			drvdata->fb_phys);
 	else
-		iounmap(drvdata->fb_virt);
+		iounmap(drvdata->fb_virt_io);

 	/* Turn off the display */
 	xilinx_fb_out32(drvdata, REG_CTRL, 0);
@@ -386,11 +402,11 @@ static int xilinxfb_release(struct device *dev)

 	fb_dealloc_cmap(&drvdata->info.cmap);

-	if (drvdata->fb_alloced)
+	if (drvdata->fb_virt)
 		dma_free_coherent(dev, PAGE_ALIGN(drvdata->info.fix.smem_len),
 				  drvdata->fb_virt, drvdata->fb_phys);
 	else
-		iounmap(drvdata->fb_virt);
+		iounmap(drvdata->fb_virt_io);

 	/* Turn off the display */
 	xilinx_fb_out32(drvdata, REG_CTRL, 0);


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2LVILDVRGTUKTCOQRGRAN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGosiAACgkQykllyylKDCEXHwCePztRoSE7qPhCjZHj2mK0lmit
0boAn0rcGWto72qGn0ZnGImOM1k8R9JB
=DnSM
-----END PGP SIGNATURE-----

------enig2LVILDVRGTUKTCOQRGRAN--
