Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3LHCVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 21:21:30 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49965 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3LHCV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 21:21:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 02/11] arm: pxa27x: support ICP DAS LP-8x4x
Date: Sun, 8 Dec 2013 03:21:11 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sergei Ianovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
References: <1385879185-22455-3-git-send-email-ynvich@gmail.com> <1386348542-9584-1-git-send-email-ynvich@gmail.com>
In-Reply-To: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312080321.12001.arnd@arndb.de>
X-Provags-ID: V02:K0:NlKifb2oEV3uNYOQWhHVc2uQszorb09re1lTNIW/xHI
 qE030P4vIKOdBdYjKXmPGLPWGY61uZa6dSoA85HAcO6NUcWBzG
 Zl/2dzK1hfD/CSGQmaZ7GkDohR8ssUVHGiDT6oqfWhuYsXgo1y
 uRZ/GrW8y+pWigdUmwvYRyGs1D9WvcEqnMDRmUvqOfhs1/D2qx
 jwRd2yLzAAwphZTZN5943WuuEiVtIoMkcIgguGchDJLVE+r09q
 CkL1jcmEUqj3F7EEYn7pSmZv2PGT6OAfY+e+NFIIZAZjjZSaey
 OgVqNerCW37qaB7B9ZSj9AuneVMv60HPPm9kTs7ZI7tFOVRfgQ
 WPMLW717/mTPY0DM+NTg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 December 2013, Sergei Ianovich wrote:

> new file mode 100644
> index 0000000..2612e60
> --- /dev/null
> +++ b/arch/arm/configs/lp8x4x_defconfig
> @@ -0,0 +1,235 @@
> +CONFIG_CROSS_COMPILE="arm-linux-gnueabi-"

This will break some build bots, please remove it here and add it to your
build environment instead.

> +# CONFIG_LBDAF is not set
> +CONFIG_BLK_CMDLINE_PARSER=y
> +CONFIG_PARTITION_ADVANCED=y
> +CONFIG_BSD_DISKLABEL=y
> +CONFIG_MINIX_SUBPARTITION=y
> +CONFIG_SOLARIS_X86_PARTITION=y
> +CONFIG_UNIXWARE_DISKLABEL=y
> +CONFIG_LDM_PARTITION=y

You have some rather unusual options in here. I'd suggest you go through
the reduced defconfig file and remove all options that look like they
are unnecessary for your system.

It's probably based on some distro config that enables lots of modules
you don't actually want.

> +#define LP8X4X_FPGA_PHYS	0x17000000
> +#define LP8X4X_FPGA_VIRT	((void *) 0xf1000000)
> +#define LP8X4X_P2V(x)		IOMEM((x) - LP8X4X_FPGA_PHYS + LP8X4X_FPGA_VIRT)
> +#define LP8X4X_V2P(x)		((x) - LP8X4X_FPGA_VIRT + LP8X4X_FPGA_PHYS)

I think you misunderstood my comment, the point was that you should
move the IOMEM() to the LP8X4X_FPGA_VIRT definition, like

#define LP8X4X_FPGA_VIRT	((void __iomem *) 0xf1000000)
#define LP8X4X_P2V(x)		(x) - LP8X4X_FPGA_PHYS + LP8X4X_FPGA_VIRT)

which would result in the correct type because of pointer arithmetics.

> +/* board level registers in the FPGA */
> +
> +#define LP8X4X_EOI		LP8X4X_P2V(0x17009006)
> +#define LP8X4X_INSINT		LP8X4X_P2V(0x17009008)
> +#define LP8X4X_ENSYSINT		LP8X4X_P2V(0x1700900A)
> +#define LP8X4X_PRIMINT		LP8X4X_P2V(0x1700900C)
> +#define LP8X4X_SECOINT		LP8X4X_P2V(0x1700900E)
> +#define LP8X4X_ENRISEINT	LP8X4X_P2V(0x17009010)
> +#define LP8X4X_CLRRISEINT	LP8X4X_P2V(0x17009012)
> +#define LP8X4X_ENHILVINT	LP8X4X_P2V(0x17009014)
> +#define LP8X4X_CLRHILVINT	LP8X4X_P2V(0x17009016)
> +#define LP8X4X_ENFALLINT	LP8X4X_P2V(0x17009018)
> +#define LP8X4X_CLRFALLINT	LP8X4X_P2V(0x1700901a)

Thinking about this again, it's actually better if you just get rid of
LP8X4X_P2V() entirely and redefine these to

#define LP8X4X_EOI		0x0006
#define LP8X4X_INSINT		0x0008
...

and change the users to do e.g.

	readl(LP8X4X_FPGA_VIRT + LP8X4X_INSINT);

This is closer to the normal way of adding the offset to an __iomem
pointer returned from ioremap.

> +	platform_device_register_resndata(NULL, "pxa2xx-flash", 0,
> +			&lp8x4x_flash_resources[0], 1,
> +			&lp8x4x_flash_data[0], sizeof(lp8x4x_flash_data[0]));
> +	platform_device_register_resndata(NULL, "pxa2xx-flash", 1,
> +			&lp8x4x_flash_resources[1], 1,
> +			&lp8x4x_flash_data[1], sizeof(lp8x4x_flash_data[1]));
> +	platform_device_register_simple("dm9000", 0,
> +			&lp8x4x_dm9000_resources[0], 3);
> +	platform_device_register_simple("dm9000", 1,
> +			&lp8x4x_dm9000_resources[3], 3);

This looks much better than the first version, a slight improvement IMHO would
be to split the resource arrays into one symbol per device to turn this into

platform_device_register_resndata(NULL, "pxa2xx-flash", 0,
			&lp8x4x_flash_resources0, 1,
			&lp8x4x_flash_data0, sizeof(lp8x4x_flash_data0));
platform_device_register_resndata(NULL, "pxa2xx-flash", 1,
			&lp8x4x_flash_resources1, 1,
			&lp8x4x_flash_data1, sizeof(lp8x4x_flash_data1));

It's not important though if you have a strong preference for the way you
did this, it just seems unusual.

	Arnd
