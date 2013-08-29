Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab3H2H4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:56:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48710 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3H2H4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:56:32 -0400
Date: Thu, 29 Aug 2013 17:56:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Simon Horman <horms@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: linux-next: manual merge of the arm-soc tree with the v4l-dvb tree
Message-Id: <20130829175629.2f0b6904c481690cc69a582c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_17_56_29_+1000_XDGqXpVRR/U2wtH+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_17_56_29_+1000_XDGqXpVRR/U2wtH+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/setup-r8a7778.c between commit 803c2df21752
("[media] ARM: shmobile: r8a7778: add VIN support") from the v4l-dvb tree
and commits cfa66a81621d ("ARM: shmobile: bockw: add DT reference") and
a66c9744574c ("ARM: shmobile: r8a7778: cleanup registration of mmcif")
from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/setup-r8a7778.c
index 0174f05,604cf36..0000000
--- a/arch/arm/mach-shmobile/setup-r8a7778.c
+++ b/arch/arm/mach-shmobile/setup-r8a7778.c
@@@ -319,55 -281,7 +281,41 @@@ void __init r8a7778_register_hspi(int i
  		hspi_resources + (2 * id), 2);
  }
 =20
- /* MMC */
- static struct resource mmc_resources[] __initdata =3D {
- 	DEFINE_RES_MEM(0xffe4e000, 0x100),
- 	DEFINE_RES_IRQ(gic_iid(0x5d)),
- };
-=20
- void __init r8a7778_add_mmc_device(struct sh_mmcif_plat_data *info)
- {
- 	platform_device_register_resndata(
- 		&platform_bus, "sh_mmcif", -1,
- 		mmc_resources, ARRAY_SIZE(mmc_resources),
- 		info, sizeof(*info));
- }
-=20
 +/* VIN */
 +#define R8A7778_VIN(idx)						\
 +static struct resource vin##idx##_resources[] __initdata =3D {		\
 +	DEFINE_RES_MEM(0xffc50000 + 0x1000 * (idx), 0x1000),		\
 +	DEFINE_RES_IRQ(gic_iid(0x5a)),					\
 +};									\
 +									\
 +static struct platform_device_info vin##idx##_info __initdata =3D {	\
 +	.parent		=3D &platform_bus,				\
 +	.name		=3D "r8a7778-vin",				\
 +	.id		=3D idx,						\
 +	.res		=3D vin##idx##_resources,				\
 +	.num_res	=3D ARRAY_SIZE(vin##idx##_resources),		\
 +	.dma_mask	=3D DMA_BIT_MASK(32),				\
 +}
 +
 +R8A7778_VIN(0);
 +R8A7778_VIN(1);
 +
 +static struct platform_device_info *vin_info_table[] __initdata =3D {
 +	&vin0_info,
 +	&vin1_info,
 +};
 +
 +void __init r8a7778_add_vin_device(int id, struct rcar_vin_platform_data =
*pdata)
 +{
 +	BUG_ON(id < 0 || id > 1);
 +
 +	vin_info_table[id]->data =3D pdata;
 +	vin_info_table[id]->size_data =3D sizeof(*pdata);
 +
 +	platform_device_register_full(vin_info_table[id]);
 +}
 +
- void __init r8a7778_add_standard_devices(void)
+ void __init r8a7778_add_dt_devices(void)
  {
  	int i;
 =20

--Signature=_Thu__29_Aug_2013_17_56_29_+1000_XDGqXpVRR/U2wtH+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHv6tAAoJEECxmPOUX5FEWOQP/iTG+iBT8WyXolJvYpp8dWeh
/aAapIdtZl+PBk+HSTCpjFUb6f3ZUWmeLBcRk88ye/ZvqTG/pp4CfCr5ESGjSL0p
GJnH+4p47xa9GdzbNFb7IJLgF+oucv4l/xFBqQfxbrIxPsRhRs9gZFOc/GQBpQZw
n9kdDUMRFmuM9FZ+ibGDz+ZZdcwjJaz1q/0KWaXlsF3Z6UwDfPCFqLMVXbEKNbQQ
I2qDFTROCIfJV/7WE5FHiq0YOIVfVpVWIMyATcHEONv966SAPlpYnVuFqOBjGrmI
gUN5cQed0RTjfg/yvU4S8XCNVxB4teWvOasC4KvULbMamqC65NNMfyAHsENT+Emj
0mV61oCgL+T8mHa1v+UxAv3OkIudR5eI1N0kaOWINVoSqbb1Fwf9bU6I64XWES2F
SiPoG7Myv5Fcrzpbx+oe2b8gUzWxP/KyH2Ao/dQIHuybvN7z50ncmeqdCd7UABe1
IA+fMd/oAg9AqZliSX+lOdZnxRaB6pI72aEqtGoU4RF0uH19U/D3Qt0DXgf3weul
HWyK4zHjm9aZBp2TOJ8kNH2f1jWf1guyxmg9p8yFjZzWSxk/dIMHEiINz4Q7hgjU
n9bN2tVPFoSGLk8JcMm/DJzYINIsLTv2nE3+H8DRS/dQie/fHp7fJbevidqGvRg6
SfFibso3gYWxfWXFNquf
=T/Rj
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_17_56_29_+1000_XDGqXpVRR/U2wtH+--
