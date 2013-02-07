Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab3BGEpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:45:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47032 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3BGEpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:45:10 -0500
Date: Thu, 7 Feb 2013 15:44:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hideki EIRAKU <hdk@igel.co.jp>, Joerg Roedel <joro@8bytes.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: linux-next: manual merge of the arm-soc tree with the iommu tree
Message-Id: <20130207154457.942992d85ab7ab5834067f7e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Feb_2013_15_44_57_+1100_eu4s46E=vry4INld"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Feb_2013_15_44_57_+1100_eu4s46E=vry4INld
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/setup-r8a7740.c between commit f671e0224a7f ("ARM:
mach-shmobile: r8a7740: Add IPMMU device") from the iommu tree and
commits f977ec94f7f2 ("ARM: shmobile: Remove duplicate inclusion of
dma-mapping.h in setup-r8a7740.c") and e67d7afc5674 ("ARM: shmobile:
r8a7740: add TMU timer support") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/setup-r8a7740.c
index b85bea5,30ac79c..0000000
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@@ -27,8 -27,6 +27,7 @@@
  #include <linux/serial_sci.h>
  #include <linux/sh_dma.h>
  #include <linux/sh_timer.h>
- #include <linux/dma-mapping.h>
 +#include <linux/platform_data/sh_ipmmu.h>
  #include <mach/dma-register.h>
  #include <mach/r8a7740.h>
  #include <mach/pm-rmobile.h>
@@@ -263,37 -287,97 +288,128 @@@ static struct platform_device cmt10_dev
  	.num_resources	=3D ARRAY_SIZE(cmt10_resources),
  };
 =20
 +/* IPMMUI (an IPMMU module for ICB/LMB) */
 +static struct resource ipmmu_resources[] =3D {
 +	[0] =3D {
 +		.name	=3D "IPMMUI",
 +		.start	=3D 0xfe951000,
 +		.end	=3D 0xfe9510ff,
 +		.flags	=3D IORESOURCE_MEM,
 +	},
 +};
 +
 +static const char * const ipmmu_dev_names[] =3D {
 +	"sh_mobile_lcdc_fb.0",
 +	"sh_mobile_lcdc_fb.1",
 +	"sh_mobile_ceu.0",
 +};
 +
 +static struct shmobile_ipmmu_platform_data ipmmu_platform_data =3D {
 +	.dev_names =3D ipmmu_dev_names,
 +	.num_dev_names =3D ARRAY_SIZE(ipmmu_dev_names),
 +};
 +
 +static struct platform_device ipmmu_device =3D {
 +	.name           =3D "ipmmu",
 +	.id             =3D -1,
 +	.dev =3D {
 +		.platform_data =3D &ipmmu_platform_data,
 +	},
 +	.resource       =3D ipmmu_resources,
 +	.num_resources  =3D ARRAY_SIZE(ipmmu_resources),
 +};
 +
+ /* TMU */
+ static struct sh_timer_config tmu00_platform_data =3D {
+ 	.name =3D "TMU00",
+ 	.channel_offset =3D 0x4,
+ 	.timer_bit =3D 0,
+ 	.clockevent_rating =3D 200,
+ };
+=20
+ static struct resource tmu00_resources[] =3D {
+ 	[0] =3D {
+ 		.name	=3D "TMU00",
+ 		.start	=3D 0xfff80008,
+ 		.end	=3D 0xfff80014 - 1,
+ 		.flags	=3D IORESOURCE_MEM,
+ 	},
+ 	[1] =3D {
+ 		.start	=3D intcs_evt2irq(0xe80),
+ 		.flags	=3D IORESOURCE_IRQ,
+ 	},
+ };
+=20
+ static struct platform_device tmu00_device =3D {
+ 	.name		=3D "sh_tmu",
+ 	.id		=3D 0,
+ 	.dev =3D {
+ 		.platform_data	=3D &tmu00_platform_data,
+ 	},
+ 	.resource	=3D tmu00_resources,
+ 	.num_resources	=3D ARRAY_SIZE(tmu00_resources),
+ };
+=20
+ static struct sh_timer_config tmu01_platform_data =3D {
+ 	.name =3D "TMU01",
+ 	.channel_offset =3D 0x10,
+ 	.timer_bit =3D 1,
+ 	.clocksource_rating =3D 200,
+ };
+=20
+ static struct resource tmu01_resources[] =3D {
+ 	[0] =3D {
+ 		.name	=3D "TMU01",
+ 		.start	=3D 0xfff80014,
+ 		.end	=3D 0xfff80020 - 1,
+ 		.flags	=3D IORESOURCE_MEM,
+ 	},
+ 	[1] =3D {
+ 		.start	=3D intcs_evt2irq(0xea0),
+ 		.flags	=3D IORESOURCE_IRQ,
+ 	},
+ };
+=20
+ static struct platform_device tmu01_device =3D {
+ 	.name		=3D "sh_tmu",
+ 	.id		=3D 1,
+ 	.dev =3D {
+ 		.platform_data	=3D &tmu01_platform_data,
+ 	},
+ 	.resource	=3D tmu01_resources,
+ 	.num_resources	=3D ARRAY_SIZE(tmu01_resources),
+ };
+=20
+ static struct sh_timer_config tmu02_platform_data =3D {
+ 	.name =3D "TMU02",
+ 	.channel_offset =3D 0x1C,
+ 	.timer_bit =3D 2,
+ 	.clocksource_rating =3D 200,
+ };
+=20
+ static struct resource tmu02_resources[] =3D {
+ 	[0] =3D {
+ 		.name	=3D "TMU02",
+ 		.start	=3D 0xfff80020,
+ 		.end	=3D 0xfff8002C - 1,
+ 		.flags	=3D IORESOURCE_MEM,
+ 	},
+ 	[1] =3D {
+ 		.start	=3D intcs_evt2irq(0xec0),
+ 		.flags	=3D IORESOURCE_IRQ,
+ 	},
+ };
+=20
+ static struct platform_device tmu02_device =3D {
+ 	.name		=3D "sh_tmu",
+ 	.id		=3D 2,
+ 	.dev =3D {
+ 		.platform_data	=3D &tmu02_platform_data,
+ 	},
+ 	.resource	=3D tmu02_resources,
+ 	.num_resources	=3D ARRAY_SIZE(tmu02_resources),
+ };
+=20
  static struct platform_device *r8a7740_early_devices[] __initdata =3D {
  	&scif0_device,
  	&scif1_device,
@@@ -305,7 -389,9 +421,10 @@@
  	&scif7_device,
  	&scifb_device,
  	&cmt10_device,
 +	&ipmmu_device,
+ 	&tmu00_device,
+ 	&tmu01_device,
+ 	&tmu02_device,
  };
 =20
  /* DMA */

--Signature=_Thu__7_Feb_2013_15_44_57_+1100_eu4s46E=vry4INld
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREzFJAAoJEECxmPOUX5FEE1IQAImjCFg+AuS2CRpvwz35E3Lg
3vS8atyRT+gxW+jO85VbSRUuusghsNULHr69MViVR/d5QZPRAJEQdLvmzMnftWbQ
F+TGXvyglWH5H2hCd1CGDrSg98gGaW895I4Yx3LMs86oSvaxVn/evhUKFWrSy8kO
lfXbCI5+/EJ4/KhAUpHSWV3ajuMbQllipbsP2Gm8uvNs3PhKiBw1YXgyT3ao5j9g
OXeCoYbMMf83ekgRGhphyDHNCZ+C4WugYd+bnXZEJUB3ty2E+6sUCEzialsseX0o
j9JYvR49gCkHwLdxLBP3uXTs7VjXrcVdGwkrgwO7YpEtFJHCwEbgxNCcyCq/9lL4
ZJ/0wo5qW6ifIxmML68Jx0jXe+Y8ycE2DELUUDyoFLwXuYZgDe/6fm7Lj/FKhCQD
kQU1X4MxjxpPhB6+IRm8CEpkg+0baZ65vT+M0Qg3wJnK9/heqQj0BlzUy30YkIcz
rR1jnK2DeSd64EQ0wFPUs7Q6rdz524jgkdC3uvt3kvb9iJ467vviSWMOwvAKTQb0
X8h7/hMGfG1Nx02LD99yD76JAUQEgN6N7bygzR99+ds0DqOnkLSEZaDbnMwaQlXG
2aLJ7+2abHciuOLjgYg1JS7hT5fgHB7bGhZ66VlUuJsDDtDekLiJ3sLz8jnTbRbp
xDE2KuqUNnvKQD76K9m9
=5zaY
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Feb_2013_15_44_57_+1100_eu4s46E=vry4INld--
