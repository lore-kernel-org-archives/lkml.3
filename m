Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab3FSHik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:38:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35639 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3FSHij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:38:39 -0400
Date: Wed, 19 Jun 2013 17:38:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <rmk@arm.linux.org.uk>, Robin Holt <holt@sgi.com>
Subject: linux-next: manual merge of the akpm tree with the arm-current tree
Message-Id: <20130619173830.f8e821a88752aa95f8b50cab@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Jun_2013_17_38_30_+1000_QDr2v6AVEk6PL/8D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jun_2013_17_38_30_+1000_QDr2v6AVEk6PL/8D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/arm/kernel/process.c between commit 19ab428f4b79 ("ARM: 7759/1:
decouple CPU offlining from reboot/shutdown") from the  tree and commit
("reboot: move arch/x86 reboot=3D handling to generic kernel") from the
akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/kernel/process.c
index 4f569dc,5cbd139..0000000
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@@ -175,39 -176,16 +175,29 @@@ void arch_cpu_idle(void
  		default_idle();
  }
 =20
- enum reboot_mode reboot_mode =3D REBOOT_HARD;
-=20
- static int __init reboot_setup(char *str)
- {
- 	if ('s' =3D=3D str[0])
- 		reboot_mode =3D REBOOT_SOFT;
- 	return 1;
- }
- __setup("reboot=3D", reboot_setup);
-=20
 +/*
 + * Called by kexec, immediately prior to machine_kexec().
 + *
 + * This must completely disable all secondary CPUs; simply causing those =
CPUs
 + * to execute e.g. a RAM-based pin loop is not sufficient. This allows the
 + * kexec'd kernel to use any and all RAM as it sees fit, without having to
 + * avoid any code or data used by any SW CPU pin loop. The CPU hotplug
 + * functionality embodied in disable_nonboot_cpus() to achieve this.
 + */
  void machine_shutdown(void)
  {
 -#ifdef CONFIG_SMP
 -	smp_send_stop();
 -#endif
 +	disable_nonboot_cpus();
  }
 =20
 +/*
 + * Halting simply requires that the secondary CPUs stop performing any
 + * activity (executing tasks, handling interrupts). smp_send_stop()
 + * achieves this.
 + */
  void machine_halt(void)
  {
 -	machine_shutdown();
 +	smp_send_stop();
 +
  	local_irq_disable();
  	while (1);
  }

--Signature=_Wed__19_Jun_2013_17_38_30_+1000_QDr2v6AVEk6PL/8D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwV/6AAoJEECxmPOUX5FEsjMP/iiNpXm1kr7TdzzbXzJjXGRD
HZKBv8rCHOJlJea4x4Wkpe6V5e2u++b6fem8SGOTKxHl/EQcFYhJiogscamrxVOH
4BGb2+nQ5zl2KzckaQse7ymmjuob0jVewkFC4x9O3zJS8b10pxmjSjN7Ozdn5Ejd
G16Yf1q8+eGxG87E2LF/j5nUuLFfRJDXfryHoF9ddSGwOvwzOHMun8DtUxQXz2GT
6MbFJRgMQglBk5V63eQQfl6GgFmwjrHg+bWM83R9e2u560va9j7B2Z6ROgooeHgp
ms4/ZutGrylk5MT9ty8DJ83YW1R/y8gjuEZSe+6Y1J7JGSW/eUKPduc1ON3vxTIN
uaUlPiJkY6Iq3NXTZrIlRU5tpepO5MKPFcsyJVXIzVPejTJvlsVtt/xm5XgY6MNx
Tk17TpLJCpYC1yafRHXluqDzBUS0C1WSFLaUr+EBZFcY+k5B5ragSeFpEqghqE/3
T9JsDVU6PU6uK6dfFaqRyCmJHoheVZ7FyaJ40tjKaEhKFWODcabxISWOsxQMyBdL
AcXif1AARynp/kEQMKoofpyfil5+7jp9tWGXduySx6CPAesyBXsZ7SYZZDrStLlw
w7Bxg/KOGtVBtD13+NiSo9TFx3InK1KIPhjznQfVg3Fd0+kei+4nkPZjVaVdRZEv
WMFy7Luu2IKerKaeNPXo
=szCs
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jun_2013_17_38_30_+1000_QDr2v6AVEk6PL/8D--
