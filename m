Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3ARD2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:28:22 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57073 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3ARD2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:28:21 -0500
Date: Fri, 18 Jan 2013 14:28:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20130118142819.5d82c1ff9e3f909a92b5a12d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_Jan_2013_14_28_19_+1100_lQYbwAYdczUHWIgD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Jan_2013_14_28_19_+1100_lQYbwAYdczUHWIgD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-exynos/platsmp.c between commit b1cffebf1029 ("ARM: GIC:
remove direct use of gic_raise_softirq") from the arm-soc tree and commit
3c49d3583839 ("ARM: EXYNOS: Add secure firmware support to secondary CPU
bring-up") from the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/platsmp.c
index 60f7c5b,3226893..0000000
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@@ -20,11 -20,12 +20,12 @@@
  #include <linux/jiffies.h>
  #include <linux/smp.h>
  #include <linux/io.h>
 +#include <linux/irqchip/arm-gic.h>
 =20
  #include <asm/cacheflush.h>
 -#include <asm/hardware/gic.h>
  #include <asm/smp_plat.h>
  #include <asm/smp_scu.h>
+ #include <asm/firmware.h>
 =20
  #include <mach/hardware.h>
  #include <mach/regs-clock.h>
@@@ -145,11 -146,22 +146,22 @@@ static int __cpuinit exynos_boot_second
 =20
  	timeout =3D jiffies + (1 * HZ);
  	while (time_before(jiffies, timeout)) {
+ 		unsigned long boot_addr;
+=20
  		smp_rmb();
 =20
- 		__raw_writel(virt_to_phys(exynos4_secondary_startup),
- 							cpu_boot_reg(phys_cpu));
+ 		boot_addr =3D virt_to_phys(exynos4_secondary_startup);
+=20
+ 		/*
+ 		 * Try to set boot address using firmware first
+ 		 * and fall back to boot register if it fails.
+ 		 */
+ 		if (call_firmware_op(set_cpu_boot_addr, phys_cpu, boot_addr))
+ 			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
+=20
+ 		call_firmware_op(cpu_boot, phys_cpu);
+=20
 -		gic_raise_softirq(cpumask_of(cpu), 0);
 +		arch_send_wakeup_ipi_mask(cpumask_of(cpu));
 =20
  		if (pen_release =3D=3D -1)
  			break;

--Signature=_Fri__18_Jan_2013_14_28_19_+1100_lQYbwAYdczUHWIgD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ+MFTAAoJEECxmPOUX5FEDwAQAKnvqESuyxr/N+HjEG3d3dr+
amtr6Y3qhJPm4gS1PSaCdjTbA2dO1+vvQGFLOsMAL5sEjZsTqWooHztpmHnlyvan
BsepEpjMjHz1ECUozNtV1C9/ilmOR2ZpQp2LiYGp9ZQQhsbqPa6jWsUpv4TwyoeG
2gkOTsDksqJtUODmB/fW+hLlfcUS2fDmzT7XlaV6pusKcmAK9PzV0TubR4xTy415
nMSnybbtJFFNtyW7lD+lbQ2wJ7lPt+rMfr7NeOYz0dSxQ2KzBT9qvLSn/mSqZ/uS
bFVIjE0rajPPznSH68EfJED6chM4EsG+UdvdJZUs2FjrxB9i5oYCn9sut/O22ln4
ph3BbiOu7VjQ+JzryEaqc/gNDD96D0JtgTcyKQZWFFIimGgVgWZyXIrrNiS9kOGD
b7BkQ1m5Ro7MFiQhCFxWt5EasYmzx5KbV1CK6uqJBPFWTSgG1E1caUy5+iyG57NH
h7Y/FFeGqNregRmGHtggCTR7GsuFkdsqta1LP60DMKtHeewHy+Nk43r7vr3XgpHD
G0ldXMySk08D8TLtaiatDyXdwuluiEJCs9tQuALBdYTS1x4vOb6fMro+WOWH+Pt8
/MdDndSXN4j0jEz4vRAwwIXp0qSJBRzo2N/y8fJZYJ0nSTqXOLUvAFzYArqiMBUq
3Q6Tv15t7pXaGI4Xq5t5
=5PXA
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Jan_2013_14_28_19_+1100_lQYbwAYdczUHWIgD--
