Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3KZHLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:11:02 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:33720 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3KZHK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:10:56 -0500
Message-ID: <52944976.4060003@monstr.eu>
Date: Tue, 26 Nov 2013 08:10:46 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        tomi.valkeinen@ti.com, plagnioj@jcrosoft.com
Subject: Re: [PATCH v3] video: add OpenCores VGA/LCD framebuffer driver
References: <1385094870-6962-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-Reply-To: <1385094870-6962-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4JbA0SjNftKHUMmfsCxWXk9WlqNDD3Otc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4JbA0SjNftKHUMmfsCxWXk9WlqNDD3Otc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/22/2013 05:34 AM, Stefan Kristiansson wrote:
> This adds support for the VGA/LCD core available from OpenCores:
> http://opencores.org/project,vga_lcd
>=20
> The driver have been tested together with both OpenRISC and
> ARM (socfpga) processors.
>=20
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> ---
> Changes in v2:
> - Add Microblaze as an example user and fix a typo in Xilinx Zynq
>=20
> Changes in v3:
> - Use devm_kzalloc instead of kzalloc
> - Remove superflous MODULE #ifdef
> ---
>  drivers/video/Kconfig  |  17 ++
>  drivers/video/Makefile |   1 +
>  drivers/video/ocfb.c   | 471 +++++++++++++++++++++++++++++++++++++++++=
++++++++
>  3 files changed, 489 insertions(+)
>  create mode 100644 drivers/video/ocfb.c
>=20
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 84b685f..3b3f31e 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -979,6 +979,23 @@ config FB_PVR2
>  	  (<file:drivers/video/pvr2fb.c>). Please see the file
>  	  <file:Documentation/fb/pvr2fb.txt>.
> =20
> +config FB_OPENCORES
> +	tristate "OpenCores VGA/LCD core 2.0 framebuffer support"
> +	depends on FB
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	default n
> +	help
> +	  This enables support for the OpenCores VGA/LCD core.
> +
> +	  The OpenCores VGA/LCD core is typically used together with
> +	  softcore CPUs (e.g. OpenRISC or Microblaze) or hard processor
> +	  systems (e.g. Altera socfpga or Xilinx Zynq) on FPGAs.
> +
> +	  The source code and specification for the core is available at
> +	  <http://opencores.org/project,vga_lcd>
> +
>  config FB_S1D13XXX
>  	tristate "Epson S1D13XXX framebuffer support"
>  	depends on FB
> diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> index e8bae8d..ae17ddf 100644
> --- a/drivers/video/Makefile
> +++ b/drivers/video/Makefile
> @@ -150,6 +150,7 @@ obj-$(CONFIG_FB_NUC900)           +=3D nuc900fb.o
>  obj-$(CONFIG_FB_JZ4740)		  +=3D jz4740_fb.o
>  obj-$(CONFIG_FB_PUV3_UNIGFX)      +=3D fb-puv3.o
>  obj-$(CONFIG_FB_HYPERV)		  +=3D hyperv_fb.o
> +obj-$(CONFIG_FB_OPENCORES)	  +=3D ocfb.o
> =20
>  # Platform or fallback drivers go here
>  obj-$(CONFIG_FB_UVESA)            +=3D uvesafb.o
> diff --git a/drivers/video/ocfb.c b/drivers/video/ocfb.c
> new file mode 100644
> index 0000000..3bf5f67
> --- /dev/null
> +++ b/drivers/video/ocfb.c
> @@ -0,0 +1,471 @@
> +/*
> + * OpenCores VGA/LCD 2.0 core frame buffer driver
> + *
> + * Copyright (C) 2013 Stefan Kristiansson, stefan.kristiansson@saunala=
hti.fi
> + *
> + * This file is licensed under the terms of the GNU General Public Lic=
ense
> + * version 2.  This program is licensed "as is" without any warranty o=
f any
> + * kind, whether express or implied.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/mm.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/fb.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +
> +/* OCFB register defines */
> +#define OCFB_CTRL	0x000
> +#define OCFB_STAT	0x004
> +#define OCFB_HTIM	0x008
> +#define OCFB_VTIM	0x00c
> +#define OCFB_HVLEN	0x010
> +#define OCFB_VBARA	0x014
> +#define OCFB_PALETTE	0x800
> +
> +#define OCFB_CTRL_VEN	0x00000001 /* Video Enable */
> +#define OCFB_CTRL_HIE	0x00000002 /* HSync Interrupt Enable */
> +#define OCFB_CTRL_PC	0x00000800 /* 8-bit Pseudo Color Enable*/
> +#define OCFB_CTRL_CD8	0x00000000 /* Color Depth 8 */
> +#define OCFB_CTRL_CD16	0x00000200 /* Color Depth 16 */
> +#define OCFB_CTRL_CD24	0x00000400 /* Color Depth 24 */
> +#define OCFB_CTRL_CD32	0x00000600 /* Color Depth 32 */
> +#define OCFB_CTRL_VBL1	0x00000000 /* Burst Length 1 */
> +#define OCFB_CTRL_VBL2	0x00000080 /* Burst Length 2 */
> +#define OCFB_CTRL_VBL4	0x00000100 /* Burst Length 4 */
> +#define OCFB_CTRL_VBL8	0x00000180 /* Burst Length 8 */
> +
> +#define PALETTE_SIZE	256
> +
> +#define OCFB_NAME	"OC VGA/LCD"
> +
> +static char *mode_option;
> +
> +static const struct fb_videomode default_mode =3D {
> +	/* 640x480 @ 60 Hz, 31.5 kHz hsync */
> +	NULL, 60, 640, 480, 39721, 40, 24, 32, 11, 96, 2,
> +	0, FB_VMODE_NONINTERLACED
> +};
> +
> +struct ocfb_dev {
> +	struct fb_info info;
> +	/* Physical and virtual addresses of control regs */
> +	phys_addr_t regs_phys;
> +	int regs_phys_size;
> +	void __iomem *regs;
> +	/* flag indicating whether the regs are little endian accessed */
> +	int little_endian;
> +	/* Physical and virtual addresses of framebuffer */
> +	phys_addr_t fb_phys;
> +	void __iomem *fb_virt;
> +	u32 pseudo_palette[PALETTE_SIZE];
> +};
> +
> +struct ocfb_par {
> +	void __iomem *pal_adr;
> +};
> +
> +static struct ocfb_par ocfb_par_priv;
> +
> +static struct fb_var_screeninfo ocfb_var;
> +static struct fb_fix_screeninfo ocfb_fix;
> +
> +#ifndef MODULE
> +static int __init ocfb_setup(char *options)
> +{
> +	char *curr_opt;
> +
> +	if (!options || !*options)
> +		return 0;
> +
> +	while ((curr_opt =3D strsep(&options, ",")) !=3D NULL) {
> +		if (!*curr_opt)
> +			continue;
> +		mode_option =3D curr_opt;
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
> +static inline u32 ocfb_readreg(struct ocfb_dev *fbdev, loff_t offset)
> +{
> +	if (fbdev->little_endian)
> +		return ioread32(fbdev->regs + offset);
> +	else
> +		return ioread32be(fbdev->regs + offset);
> +}
> +
> +static void ocfb_writereg(struct ocfb_dev *fbdev, loff_t offset, u32 d=
ata)
> +{
> +	if (fbdev->little_endian)
> +		iowrite32(data, fbdev->regs + offset);
> +	else
> +		iowrite32be(data, fbdev->regs + offset);
> +}
> +
> +static int ocfb_setupfb(struct ocfb_dev *fbdev)
> +{
> +	unsigned long bpp_config;
> +	struct fb_var_screeninfo *var =3D &fbdev->info.var;
> +	struct device *dev =3D fbdev->info.device;
> +	u32 hlen;
> +	u32 vlen;
> +
> +	/* Disable display */
> +	ocfb_writereg(fbdev, OCFB_CTRL, 0);
> +
> +	/* Register framebuffer address */
> +	fbdev->little_endian =3D 0;
> +	ocfb_writereg(fbdev, OCFB_VBARA, fbdev->fb_phys);
> +
> +	/* Detect endianess */
> +	if (ocfb_readreg(fbdev, OCFB_VBARA) !=3D fbdev->fb_phys) {
> +		fbdev->little_endian =3D 1;
> +		ocfb_writereg(fbdev, OCFB_VBARA, fbdev->fb_phys);
> +	}
> +
> +	/* Horizontal timings */
> +	ocfb_writereg(fbdev, OCFB_HTIM, (var->hsync_len - 1) << 24 |
> +		      (var->right_margin - 1) << 16 | (var->xres - 1));
> +
> +	/* Vertical timings */
> +	ocfb_writereg(fbdev, OCFB_VTIM, (var->vsync_len - 1) << 24 |
> +		      (var->lower_margin - 1) << 16 | (var->yres - 1));
> +
> +	/* Total length of frame */
> +	hlen =3D var->left_margin + var->right_margin + var->hsync_len +
> +		var->xres;
> +
> +	vlen =3D var->upper_margin + var->lower_margin + var->vsync_len +
> +		var->yres;
> +
> +	ocfb_writereg(fbdev, OCFB_HVLEN, (hlen - 1) << 16 | (vlen - 1));
> +
> +	bpp_config =3D OCFB_CTRL_CD8;
> +	switch (var->bits_per_pixel) {
> +	case 8:
> +		if (!var->grayscale)
> +			bpp_config |=3D OCFB_CTRL_PC;  /* enable palette */
> +		break;
> +
> +	case 16:
> +		bpp_config |=3D OCFB_CTRL_CD16;
> +		break;
> +
> +	case 24:
> +		bpp_config |=3D OCFB_CTRL_CD24;
> +		break;
> +
> +	case 32:
> +		bpp_config |=3D OCFB_CTRL_CD32;
> +		break;
> +
> +	default:
> +		dev_err(dev, "no bpp specified\n");
> +		break;
> +	}
> +
> +	/* maximum (8) VBL (video memory burst length) */
> +	bpp_config |=3D OCFB_CTRL_VBL8;
> +
> +	/* Enable output */
> +	ocfb_writereg(fbdev, OCFB_CTRL, (OCFB_CTRL_VEN | bpp_config));
> +
> +	return 0;
> +}
> +
> +static int ocfb_setcolreg(unsigned regno, unsigned red, unsigned green=
,
> +			  unsigned blue, unsigned transp,
> +			  struct fb_info *info)
> +{
> +	struct ocfb_par *par =3D (struct ocfb_par *)info->par;
> +	u32 color;
> +
> +	if (regno >=3D info->cmap.len) {
> +		dev_err(info->device, "regno >=3D cmap.len\n");
> +		return 1;
> +	}
> +
> +	if (info->var.grayscale) {
> +		/* grayscale =3D 0.30*R + 0.59*G + 0.11*B */
> +		red =3D green =3D blue =3D (red * 77 + green * 151 + blue * 28) >> 8=
;
> +	}
> +
> +	red >>=3D (16 - info->var.red.length);
> +	green >>=3D (16 - info->var.green.length);
> +	blue >>=3D (16 - info->var.blue.length);
> +	transp >>=3D (16 - info->var.transp.length);
> +
> +	if (info->var.bits_per_pixel =3D=3D 8 && !info->var.grayscale) {
> +		regno <<=3D 2;
> +		color =3D (red << 16) | (green << 8) | blue;
> +		ocfb_writereg(par->pal_adr, regno, color);
> +	} else {
> +		((u32 *)(info->pseudo_palette))[regno] =3D
> +			(red << info->var.red.offset) |
> +			(green << info->var.green.offset) |
> +			(blue << info->var.blue.offset) |
> +			(transp << info->var.transp.offset);
> +	}
> +
> +	return 0;
> +}
> +
> +static int ocfb_init_fix(struct ocfb_dev *fbdev)
> +{
> +	struct fb_var_screeninfo *var =3D &fbdev->info.var;
> +	struct fb_fix_screeninfo *fix =3D &fbdev->info.fix;
> +
> +	strcpy(fix->id, OCFB_NAME);
> +
> +	fix->line_length =3D var->xres * var->bits_per_pixel/8;
> +	fix->smem_len =3D fix->line_length * var->yres;
> +	fix->type =3D FB_TYPE_PACKED_PIXELS;
> +
> +	if (var->bits_per_pixel =3D=3D 8 && !var->grayscale)
> +		fix->visual =3D FB_VISUAL_PSEUDOCOLOR;
> +	else
> +		fix->visual =3D FB_VISUAL_TRUECOLOR;
> +
> +	return 0;
> +}
> +
> +static int ocfb_init_var(struct ocfb_dev *fbdev)
> +{
> +	struct fb_var_screeninfo *var =3D &fbdev->info.var;
> +
> +	var->accel_flags =3D FB_ACCEL_NONE;
> +	var->activate =3D FB_ACTIVATE_NOW;
> +	var->xres_virtual =3D var->xres;
> +	var->yres_virtual =3D var->yres;
> +
> +	switch (var->bits_per_pixel) {
> +	case 8:
> +		var->transp.offset =3D 0;
> +		var->transp.length =3D 0;
> +		var->red.offset =3D 0;
> +		var->red.length =3D 8;
> +		var->green.offset =3D 0;
> +		var->green.length =3D 8;
> +		var->blue.offset =3D 0;
> +		var->blue.length =3D 8;
> +		break;
> +
> +	case 16:
> +		var->transp.offset =3D 0;
> +		var->transp.length =3D 0;
> +		var->red.offset =3D 11;
> +		var->red.length =3D 5;
> +		var->green.offset =3D 5;
> +		var->green.length =3D 6;
> +		var->blue.offset =3D 0;
> +		var->blue.length  =3D 5;
> +		break;
> +
> +	case 24:
> +		var->transp.offset =3D 0;
> +		var->transp.length =3D 0;
> +		var->red.offset =3D 16;
> +		var->red.length =3D 8;
> +		var->green.offset =3D 8;
> +		var->green.length =3D 8;
> +		var->blue.offset =3D 0;
> +		var->blue.length =3D 8;
> +		break;
> +
> +	case 32:
> +		var->transp.offset =3D 24;
> +		var->transp.length =3D 8;
> +		var->red.offset =3D 16;
> +		var->red.length =3D 8;
> +		var->green.offset =3D 8;
> +		var->green.length =3D 8;
> +		var->blue.offset =3D 0;
> +		var->blue.length =3D 8;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct fb_ops ocfb_ops =3D {
> +	.owner		=3D THIS_MODULE,
> +	.fb_setcolreg	=3D ocfb_setcolreg,
> +	.fb_fillrect	=3D cfb_fillrect,
> +	.fb_copyarea	=3D cfb_copyarea,
> +	.fb_imageblit	=3D cfb_imageblit,
> +};
> +
> +static int ocfb_probe(struct platform_device *pdev)
> +{
> +	int ret =3D 0;
> +	struct ocfb_dev *fbdev;
> +	struct ocfb_par *par =3D &ocfb_par_priv;
> +	struct resource *res;
> +	struct resource *mmio;
> +	int fbsize;
> +
> +	fbdev =3D devm_kzalloc(&pdev->dev, sizeof(*fbdev), GFP_KERNEL);
> +	if (!fbdev)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, fbdev);
> +
> +	fbdev->info.fbops =3D &ocfb_ops;
> +	fbdev->info.var =3D ocfb_var;
> +	fbdev->info.fix =3D ocfb_fix;
> +	fbdev->info.device =3D &pdev->dev;
> +	fbdev->info.par =3D par;
> +
> +	/* Video mode setup */
> +	if (!fb_find_mode(&fbdev->info.var, &fbdev->info, mode_option,
> +			  NULL, 0, &default_mode, 16)) {
> +		dev_err(&pdev->dev, "No valid video modes found\n");
> +		return -EINVAL;
> +	}
> +	ocfb_init_var(fbdev);
> +	ocfb_init_fix(fbdev);
> +
> +	/* Request I/O resource */
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "I/O resource request failed\n");
> +		return -ENXIO;
> +	}
> +	fbdev->regs_phys =3D res->start;
> +	fbdev->regs_phys_size =3D resource_size(res);
> +	mmio =3D devm_request_mem_region(&pdev->dev, res->start,
> +				       resource_size(res), res->name);
> +	if (!mmio) {
> +		dev_err(&pdev->dev, "I/O memory space request failed\n");
> +		return -ENXIO;
> +	}
> +	fbdev->regs =3D devm_ioremap_nocache(&pdev->dev, mmio->start,
> +					   resource_size(mmio));
> +	if (!fbdev->regs) {
> +		dev_err(&pdev->dev, "I/O memory remap request failed\n");
> +		return -ENXIO;
> +	}


This construction seems to me too complicated and can be simpler.

What about this?
	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
	res->flags &=3D ~IORESOURCE_CACHEABLE;
	fbdev->regs =3D devm_ioremap_resource(&pdev->dev, res);
	if (IS_ERR(fbdev->regs))
		return PTR_ERR(fbdev->regs);

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--4JbA0SjNftKHUMmfsCxWXk9WlqNDD3Otc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKUSXwACgkQykllyylKDCHrqwCfVVxSlwhaSt0CcFYDL6vKM8QV
cNMAn0SmD0fOr274QRUgB9Jy7H+wB5hC
=7z0o
-----END PGP SIGNATURE-----

--4JbA0SjNftKHUMmfsCxWXk9WlqNDD3Otc--
