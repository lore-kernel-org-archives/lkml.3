Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbaEWAxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 20:53:16 -0400
Received: from ozlabs.org ([103.22.144.67]:38031 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaEWAxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 20:53:14 -0400
Date: Fri, 23 May 2014 10:53:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20140523105302.50b19c91@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//6xRZN62JqvoKW.WMhsyJW="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//6xRZN62JqvoKW.WMhsyJW=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-vexpress/v2m.c between commit 86cb8830d957 ("ARM: l2c:
vexpress: convert to generic l2c OF initialisation") from the arm tree
and commits 3b9334ac835b ("mfd: vexpress: Convert custom func API to
regmap") and d2606f81d563 ("ARM: vexpress: Simplify SMP operations for
DT-powered system") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-vexpress/v2m.c
index b2fea70d412d,38f4f6f37770..000000000000
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@@ -369,70 -370,10 +370,9 @@@ MACHINE_START(VEXPRESS, "ARM-Versatile=20
  	.init_machine	=3D v2m_init,
  MACHINE_END
 =20
- static struct map_desc v2m_rs1_io_desc __initdata =3D {
- 	.virtual	=3D V2M_PERIPH,
- 	.pfn		=3D __phys_to_pfn(0x1c000000),
- 	.length		=3D SZ_2M,
- 	.type		=3D MT_DEVICE,
- };
-=20
- static int __init v2m_dt_scan_memory_map(unsigned long node, const char *=
uname,
- 		int depth, void *data)
- {
- 	const char **map =3D data;
-=20
- 	if (strcmp(uname, "motherboard") !=3D 0)
- 		return 0;
-=20
- 	*map =3D of_get_flat_dt_prop(node, "arm,v2m-memory-map", NULL);
-=20
- 	return 1;
- }
-=20
- void __init v2m_dt_map_io(void)
- {
- 	const char *map =3D NULL;
-=20
- 	of_scan_flat_dt(v2m_dt_scan_memory_map, &map);
-=20
- 	if (map && strcmp(map, "rs1") =3D=3D 0)
- 		iotable_init(&v2m_rs1_io_desc, 1);
- 	else
- 		iotable_init(v2m_io_desc, ARRAY_SIZE(v2m_io_desc));
-=20
- #if defined(CONFIG_SMP)
- 	vexpress_dt_smp_map_io();
- #endif
- }
-=20
- void __init v2m_dt_init_early(void)
- {
- 	u32 dt_hbi;
-=20
- 	vexpress_sysreg_of_early_init();
-=20
- 	/* Confirm board type against DT property, if available */
- 	if (of_property_read_u32(of_allnodes, "arm,hbi", &dt_hbi) =3D=3D 0) {
- 		u32 hbi =3D vexpress_get_hbi(VEXPRESS_SITE_MASTER);
-=20
- 		if (WARN_ON(dt_hbi !=3D hbi))
- 			pr_warning("vexpress: DT HBI (%x) is not matching "
- 					"hardware (%x)!\n", dt_hbi, hbi);
- 	}
-=20
- 	versatile_sched_clock_init(vexpress_get_24mhz_clock_base(), 24000000);
- }
-=20
- static const struct of_device_id v2m_dt_bus_match[] __initconst =3D {
- 	{ .compatible =3D "simple-bus", },
- 	{ .compatible =3D "arm,amba-bus", },
- 	{ .compatible =3D "arm,vexpress,config-bus", },
- 	{}
- };
-=20
  static void __init v2m_dt_init(void)
  {
- 	of_platform_populate(NULL, v2m_dt_bus_match, NULL, NULL);
 -	l2x0_of_init(0x00400000, 0xfe0fffff);
+ 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
  }
 =20
  static const char * const v2m_dt_match[] __initconst =3D {
@@@ -442,11 -383,7 +382,9 @@@
 =20
  DT_MACHINE_START(VEXPRESS_DT, "ARM-Versatile Express")
  	.dt_compat	=3D v2m_dt_match,
 +	.l2c_aux_val	=3D 0x00400000,
 +	.l2c_aux_mask	=3D 0xfe0fffff,
- 	.smp		=3D smp_ops(vexpress_smp_ops),
+ 	.smp		=3D smp_ops(vexpress_smp_dt_ops),
  	.smp_init	=3D smp_init_ops(vexpress_smp_init_ops),
- 	.map_io		=3D v2m_dt_map_io,
- 	.init_early	=3D v2m_dt_init_early,
  	.init_machine	=3D v2m_dt_init,
  MACHINE_END

--Sig_//6xRZN62JqvoKW.WMhsyJW=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfpv3AAoJEMDTa8Ir7ZwVtmwP+wSJVB3QfKZ0FeTagoj2Q1El
xLtZHWfRrNokOvFdSFhbfSJ14hA5kcCA65zBwzWk0cWNDxmmSqokGwZaactdozya
Pn0LdOp36aWMKA/QbM8K0l69WrUFVois+OIN7gC099X6Rb1wT3sNMRNvWgxO5LdL
oReTYdldsoi6+G1subh3v5wzH5S402GpMvrS3FzRk984xTMR+XfdMgdLeLmYNU4x
v94k+3AHop7/hON3KYVYhw+lYBMDy8DFQcKM1Uvu8qHXEt/c0C4l0YSz4E0GpHaG
FKBCPMChPX++az3ktlpQL+SAfWy0/gIPg9AEq3P634fSWZ+auzyleDSPGqkyePKw
FAzErrbdZnWpDBCrMA2nuKqt81O1XmORKgEOnAPjDVCKjLd/iNofPfudoQKy+9c2
fbBcN9eavdXqQP4/HknVPiJAcjYvFVEcjqGoOmWgtP+i6DAOxjF7lJi+KMEjgtfN
L2TN7VV3z0xVmiG7s/HiM3qNAXOuC6LyEDxboa+f1RGo0vszZCjpGhJvymnd33V1
xk+onngaenj4sWvableKvf7CpJqy2PT0gAKFIIlku/QRfMpeGJtHcnInBScwInUg
kEFVvdWEOfanou2XXgZvEKA+jAZT225dNqvkgd9lAjl2oTTEeJMk5EjgBYLYfMoL
So4wFTqDAPZFJVhHxd7j
=/yUQ
-----END PGP SIGNATURE-----

--Sig_//6xRZN62JqvoKW.WMhsyJW=--
