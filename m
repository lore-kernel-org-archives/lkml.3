Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab3CLDIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:08:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54729 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab3CLDIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:08:15 -0400
Date: Tue, 12 Mar 2013 14:07:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hideki EIRAKU <hdk@igel.co.jp>, Joerg Roedel <joro@8bytes.org>,
        Magnus Damm <damm@opensource.se>
Subject: linux-next: manual merge of the renesas tree with Linus' tree
Message-Id: <20130312140758.d13f6ae96f195a9adbebf8dd@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_14_07_58_+1100_nVdCudc95_lOtUmT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_14_07_58_+1100_nVdCudc95_lOtUmT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
arch/arm/mach-shmobile/setup-sh73a0.c between commit 9a27dee73f55 ("ARM:
mach-shmobile: sh73a0: Add IPMMU device") from the  tree and commits
73b21f40b61c ("ARM: shmobile: sh73a0: Do not use early devices with DT
reference") and 2a2b1f1bb063 ("ARM: shmobile: INTC External IRQ pin
driver on sh73a0") from the renesas tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/setup-sh73a0.c
index bdab575,95a75af..0000000
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@@ -31,7 -32,7 +32,8 @@@
  #include <linux/sh_dma.h>
  #include <linux/sh_intc.h>
  #include <linux/sh_timer.h>
 +#include <linux/platform_data/sh_ipmmu.h>
+ #include <linux/platform_data/irq-renesas-intc-irqpin.h>
  #include <mach/dma-register.h>
  #include <mach/hardware.h>
  #include <mach/irqs.h>
@@@ -781,36 -782,128 +783,157 @@@ static struct platform_device pmu_devic
  	.resource	=3D pmu_resources,
  };
 =20
 +/* an IPMMU module for ICB */
 +static struct resource ipmmu_resources[] =3D {
 +	[0] =3D {
 +		.name	=3D "IPMMU",
 +		.start	=3D 0xfe951000,
 +		.end	=3D 0xfe9510ff,
 +		.flags	=3D IORESOURCE_MEM,
 +	},
 +};
 +
 +static const char * const ipmmu_dev_names[] =3D {
 +	"sh_mobile_lcdc_fb.0",
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
- static struct platform_device *sh73a0_early_devices_dt[] __initdata =3D {
+ static struct renesas_intc_irqpin_config irqpin0_platform_data =3D {
+ 	.irq_base =3D irq_pin(0), /* IRQ0 -> IRQ7 */
+ };
+=20
+ static struct resource irqpin0_resources[] =3D {
+ 	DEFINE_RES_MEM(0xe6900000, 4), /* ICR1A */
+ 	DEFINE_RES_MEM(0xe6900010, 4), /* INTPRI00A */
+ 	DEFINE_RES_MEM(0xe6900020, 1), /* INTREQ00A */
+ 	DEFINE_RES_MEM(0xe6900040, 1), /* INTMSK00A */
+ 	DEFINE_RES_MEM(0xe6900060, 1), /* INTMSKCLR00A */
+ 	DEFINE_RES_IRQ(gic_spi(1)), /* IRQ0 */
+ 	DEFINE_RES_IRQ(gic_spi(2)), /* IRQ1 */
+ 	DEFINE_RES_IRQ(gic_spi(3)), /* IRQ2 */
+ 	DEFINE_RES_IRQ(gic_spi(4)), /* IRQ3 */
+ 	DEFINE_RES_IRQ(gic_spi(5)), /* IRQ4 */
+ 	DEFINE_RES_IRQ(gic_spi(6)), /* IRQ5 */
+ 	DEFINE_RES_IRQ(gic_spi(7)), /* IRQ6 */
+ 	DEFINE_RES_IRQ(gic_spi(8)), /* IRQ7 */
+ };
+=20
+ static struct platform_device irqpin0_device =3D {
+ 	.name		=3D "renesas_intc_irqpin",
+ 	.id		=3D 0,
+ 	.resource	=3D irqpin0_resources,
+ 	.num_resources	=3D ARRAY_SIZE(irqpin0_resources),
+ 	.dev		=3D {
+ 		.platform_data	=3D &irqpin0_platform_data,
+ 	},
+ };
+=20
+ static struct renesas_intc_irqpin_config irqpin1_platform_data =3D {
+ 	.irq_base =3D irq_pin(8), /* IRQ8 -> IRQ15 */
+ 	.control_parent =3D true, /* Disable spurious IRQ10 */
+ };
+=20
+ static struct resource irqpin1_resources[] =3D {
+ 	DEFINE_RES_MEM(0xe6900004, 4), /* ICR2A */
+ 	DEFINE_RES_MEM(0xe6900014, 4), /* INTPRI10A */
+ 	DEFINE_RES_MEM(0xe6900024, 1), /* INTREQ10A */
+ 	DEFINE_RES_MEM(0xe6900044, 1), /* INTMSK10A */
+ 	DEFINE_RES_MEM(0xe6900064, 1), /* INTMSKCLR10A */
+ 	DEFINE_RES_IRQ(gic_spi(9)), /* IRQ8 */
+ 	DEFINE_RES_IRQ(gic_spi(10)), /* IRQ9 */
+ 	DEFINE_RES_IRQ(gic_spi(11)), /* IRQ10 */
+ 	DEFINE_RES_IRQ(gic_spi(12)), /* IRQ11 */
+ 	DEFINE_RES_IRQ(gic_spi(13)), /* IRQ12 */
+ 	DEFINE_RES_IRQ(gic_spi(14)), /* IRQ13 */
+ 	DEFINE_RES_IRQ(gic_spi(15)), /* IRQ14 */
+ 	DEFINE_RES_IRQ(gic_spi(16)), /* IRQ15 */
+ };
+=20
+ static struct platform_device irqpin1_device =3D {
+ 	.name		=3D "renesas_intc_irqpin",
+ 	.id		=3D 1,
+ 	.resource	=3D irqpin1_resources,
+ 	.num_resources	=3D ARRAY_SIZE(irqpin1_resources),
+ 	.dev		=3D {
+ 		.platform_data	=3D &irqpin1_platform_data,
+ 	},
+ };
+=20
+ static struct renesas_intc_irqpin_config irqpin2_platform_data =3D {
+ 	.irq_base =3D irq_pin(16), /* IRQ16 -> IRQ23 */
+ };
+=20
+ static struct resource irqpin2_resources[] =3D {
+ 	DEFINE_RES_MEM(0xe6900008, 4), /* ICR3A */
+ 	DEFINE_RES_MEM(0xe6900018, 4), /* INTPRI20A */
+ 	DEFINE_RES_MEM(0xe6900028, 1), /* INTREQ20A */
+ 	DEFINE_RES_MEM(0xe6900048, 1), /* INTMSK20A */
+ 	DEFINE_RES_MEM(0xe6900068, 1), /* INTMSKCLR20A */
+ 	DEFINE_RES_IRQ(gic_spi(17)), /* IRQ16 */
+ 	DEFINE_RES_IRQ(gic_spi(18)), /* IRQ17 */
+ 	DEFINE_RES_IRQ(gic_spi(19)), /* IRQ18 */
+ 	DEFINE_RES_IRQ(gic_spi(20)), /* IRQ19 */
+ 	DEFINE_RES_IRQ(gic_spi(21)), /* IRQ20 */
+ 	DEFINE_RES_IRQ(gic_spi(22)), /* IRQ21 */
+ 	DEFINE_RES_IRQ(gic_spi(23)), /* IRQ22 */
+ 	DEFINE_RES_IRQ(gic_spi(24)), /* IRQ23 */
+ };
+=20
+ static struct platform_device irqpin2_device =3D {
+ 	.name		=3D "renesas_intc_irqpin",
+ 	.id		=3D 2,
+ 	.resource	=3D irqpin2_resources,
+ 	.num_resources	=3D ARRAY_SIZE(irqpin2_resources),
+ 	.dev		=3D {
+ 		.platform_data	=3D &irqpin2_platform_data,
+ 	},
+ };
+=20
+ static struct renesas_intc_irqpin_config irqpin3_platform_data =3D {
+ 	.irq_base =3D irq_pin(24), /* IRQ24 -> IRQ31 */
+ };
+=20
+ static struct resource irqpin3_resources[] =3D {
+ 	DEFINE_RES_MEM(0xe690000c, 4), /* ICR4A */
+ 	DEFINE_RES_MEM(0xe690001c, 4), /* INTPRI30A */
+ 	DEFINE_RES_MEM(0xe690002c, 1), /* INTREQ30A */
+ 	DEFINE_RES_MEM(0xe690004c, 1), /* INTMSK30A */
+ 	DEFINE_RES_MEM(0xe690006c, 1), /* INTMSKCLR30A */
+ 	DEFINE_RES_IRQ(gic_spi(25)), /* IRQ24 */
+ 	DEFINE_RES_IRQ(gic_spi(26)), /* IRQ25 */
+ 	DEFINE_RES_IRQ(gic_spi(27)), /* IRQ26 */
+ 	DEFINE_RES_IRQ(gic_spi(28)), /* IRQ27 */
+ 	DEFINE_RES_IRQ(gic_spi(29)), /* IRQ28 */
+ 	DEFINE_RES_IRQ(gic_spi(30)), /* IRQ29 */
+ 	DEFINE_RES_IRQ(gic_spi(31)), /* IRQ30 */
+ 	DEFINE_RES_IRQ(gic_spi(32)), /* IRQ31 */
+ };
+=20
+ static struct platform_device irqpin3_device =3D {
+ 	.name		=3D "renesas_intc_irqpin",
+ 	.id		=3D 3,
+ 	.resource	=3D irqpin3_resources,
+ 	.num_resources	=3D ARRAY_SIZE(irqpin3_resources),
+ 	.dev		=3D {
+ 		.platform_data	=3D &irqpin3_platform_data,
+ 	},
+ };
+=20
+ static struct platform_device *sh73a0_devices_dt[] __initdata =3D {
  	&scif0_device,
  	&scif1_device,
  	&scif2_device,

--Signature=_Tue__12_Mar_2013_14_07_58_+1100_nVdCudc95_lOtUmT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPpwOAAoJEECxmPOUX5FEhGkP/RDJLbUmLJVu8/pwnjdhiMKX
IqjaJ2C2g52H610cMImPEql3Lmzi2E8e93UNi7UV4aO8o+kvgZhFvOx9L+8IJch/
N9/GJUZWxS6fsLatkX+Y+OZ4rlqGmPTkqaXbQgKswyE9VQj9BxGt1N0MtnAonVIc
Ix5IuqUnLVUrhOTr9MrqwAlAMmd8LvQ+Ktp3vNyWe1+nYJfmNRKtmoMSsQl+LxjF
IdSnUu6HHrSNBQKfoqfUdH36HFSuAIzFlQ13BFYEa5kGwvu7VLP2gwVIo+fGvR1N
YUAiJHJWdKKIVDqj8GqNfzxGpzeLE3zbvMKKwepwe4ABuLBcfE6Eb7et+Jl3T21l
R0aAG+2vWroiDQsV+YZrFYWPMvdarXSFSLvaM6adfPzsjg1drTrQB1sDpmcjKP7P
Q+YFnNUMqV7bmDJtmlMYgkv5DwmxfoXpEer2hM5U0WLKsPC0oFVrYxIJ6NeHOvBZ
YZ+XK4SamKWk/Pc/i8nOJnXiJRDToe+NoUu6cT9QsnC5t79SpHWdeTHfpppRXChe
6NlY1yoBnsUQiGdXgT+pMOA+fZnK7m4iElh3KIfW7Wi16XRXA9qZwfmofBPw6l4d
IcD5v4SfYeTWU4Vip9FhFxnsvpcRvA4SqlcES2ALE9enMQPdG6w7SAePqha0pG7g
sFShpqwXulLntRySsjQq
=ehEy
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_14_07_58_+1100_nVdCudc95_lOtUmT--
