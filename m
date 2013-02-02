Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab3BBLUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 06:20:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58554 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3BBLUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 06:20:50 -0500
Date: Sat, 2 Feb 2013 22:20:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <c.dall@virtualopensystems.com>,
        Will Deacon <will.deacon@arm.com>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the cortex tree with the arm tree
Message-Id: <20130202222036.0db6c1d208843975be1f8dba@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_22_20_36_+1100_WR4bBAlW8CqK=M36"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_22_20_36_+1100_WR4bBAlW8CqK=M36
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Uwe,

Today's linux-next merge of the cortex tree got a conflict in
arch/arm/include/asm/cputype.h between commit 59530adc3f1b ("ARM: Define
CPU part numbers and implementors") from the arm tree and commit
6ebd4d038dbb ("ARM: stub out read_cpuid and read_cpuid_ext for
CPU_CP15=3Dn") from the cortex tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/cputype.h
index ad41ec2,574269e..0000000
--- a/arch/arm/include/asm/cputype.h
+++ b/arch/arm/include/asm/cputype.h
@@@ -59,30 -60,25 +60,43 @@@ extern unsigned int processor_id
  		    : "cc");						\
  		__val;							\
  	})
- #else
- #define read_cpuid(reg) (processor_id)
- #define read_cpuid_ext(reg) 0
- #endif
+=20
+ #else /* ifdef CONFIG_CPU_CP15 */
 =20
 +#define ARM_CPU_IMP_ARM			0x41
 +#define ARM_CPU_IMP_INTEL		0x69
 +
 +#define ARM_CPU_PART_ARM1136		0xB360
 +#define ARM_CPU_PART_ARM1156		0xB560
 +#define ARM_CPU_PART_ARM1176		0xB760
 +#define ARM_CPU_PART_ARM11MPCORE	0xB020
 +#define ARM_CPU_PART_CORTEX_A8		0xC080
 +#define ARM_CPU_PART_CORTEX_A9		0xC090
 +#define ARM_CPU_PART_CORTEX_A5		0xC050
 +#define ARM_CPU_PART_CORTEX_A15		0xC0F0
 +#define ARM_CPU_PART_CORTEX_A7		0xC070
 +
 +#define ARM_CPU_XSCALE_ARCH_MASK	0xe000
 +#define ARM_CPU_XSCALE_ARCH_V1		0x2000
 +#define ARM_CPU_XSCALE_ARCH_V2		0x4000
 +#define ARM_CPU_XSCALE_ARCH_V3		0x6000
 +
  /*
+  * read_cpuid and read_cpuid_ext should only ever be called on machines t=
hat
+  * have cp15 so warn on other usages.
+  */
+ #define read_cpuid(reg)							\
+ 	({								\
+ 		WARN_ON_ONCE(1);					\
+ 		0;							\
+ 	})
+=20
+ #define read_cpuid_ext(reg) read_cpuid(reg)
+=20
+ #endif /* ifdef CONFIG_CPU_CP15 / else */
+=20
+ #ifdef CONFIG_CPU_CP15
+ /*
   * The CPU ID never changes at run time, so we might as well tell the
   * compiler that it's constant.  Use this function to read the CPU ID
   * rather than directly reading processor_id or read_cpuid() directly.
@@@ -92,21 -88,15 +106,30 @@@ static inline unsigned int __attribute_
  	return read_cpuid(CPUID_ID);
  }
 =20
+ #else /* ifdef CONFIG_CPU_CP15 */
+=20
+ static inline unsigned int __attribute_const__ read_cpuid_id(void)
+ {
+ 	return processor_id;
+ }
+=20
+ #endif /* ifdef CONFIG_CPU_CP15 / else */
+=20
 +static inline unsigned int __attribute_const__ read_cpuid_implementor(voi=
d)
 +{
 +	return (read_cpuid_id() & 0xFF000000) >> 24;
 +}
 +
 +static inline unsigned int __attribute_const__ read_cpuid_part_number(voi=
d)
 +{
 +	return read_cpuid_id() & 0xFFF0;
 +}
 +
 +static inline unsigned int __attribute_const__ xscale_cpu_arch_version(vo=
id)
 +{
 +	return read_cpuid_part_number() & ARM_CPU_XSCALE_ARCH_MASK;
 +}
 +
  static inline unsigned int __attribute_const__ read_cpuid_cachetype(void)
  {
  	return read_cpuid(CPUID_CACHETYPE);

--Signature=_Sat__2_Feb_2013_22_20_36_+1100_WR4bBAlW8CqK=M36
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDPaEAAoJEECxmPOUX5FEd7gP/1itwJgcaVl19mhLj27sCsgX
cDmBkhlhFml525IrRJ1wj3Tlf1uCkWueP48zgKfam1Wo8nvpfB6GpN7+gNtWGF7V
beZULR4x2nsDPNlG0BQ5B0BJGSkKxn18kbJODIHRR4czic+H1TPDEExxVifWpxzL
aIzg+HlQHMOiujmPVWhK3f0GhqeKWqhEsanK/QpL4ARxA5hZ5Eqe9v6Yimei/Cc8
3g8FuOc1trIBrhFqluCr61V9cR7Q0X0m4gfpWkY1AQsgVbqHEcuC4J6SW+wMX5Md
vJ2GLI+FDlwr3dBV67XGaOJPmdw/AHXwk21FJbnKC1CuNSx6Up3/6SFagwxTUL7e
7GVngpk1Cc1gvAN4d82qXVscN0Jgl9lysgzAerG/e99k1iL+KiGZ7/ZprjEN0oMG
ipsDtu06pLenT58HcKQONZvhtjVAZvVEEy7Sm57G2EPhXHcMX/uzbgO4PfM78Ykd
CRpQ+2V19ayDNsAVA7t5E+WSUNaDxMRCBzf8oiFMl0ShZhryrUm3urm91FPr0vGI
5I2pP4sjLQBlBLEmpc4c3zgNYNc3+0C1U5SxaFnbUO4/NO3B7cxD6hpUFjYkRMg9
9e8x1AIOhu+WkvRPNstKkmN90qVlVHFYXwpXySURhYX3hJZo1M5P1pNmIBgjpvw7
u/C1rmab9uirJBohbFIS
=f1if
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_22_20_36_+1100_WR4bBAlW8CqK=M36--
