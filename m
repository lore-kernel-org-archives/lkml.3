Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbbAZTQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:16:57 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35457 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbbAZTQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:16:54 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Subject: [PATCH] ARM: /proc/atags: Export also for DT
Date: Mon, 26 Jan 2015 20:16:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201412041857.49341@pali> <CAL_JsqJ9i0jwaL1cyeomQG=bhhcnEgdGWYOqkcwidyk5xOUukg@mail.gmail.com>
In-Reply-To: <CAL_JsqJ9i0jwaL1cyeomQG=bhhcnEgdGWYOqkcwidyk5xOUukg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6109638.u9jTIsBsJt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501262016.52079@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6109638.u9jTIsBsJt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

This patch will cause that decompressor store full ATAG structure into DT t=
ree ("/atags"):

diff --git a/arch/arm/boot/compressed/atags_to_fdt.c b/arch/arm/boot/compre=
ssed/atags_to_fdt.c
index e7e1cc9..1975d7c 100644
=2D-- a/arch/arm/boot/compressed/atags_to_fdt.c
+++ b/arch/arm/boot/compressed/atags_to_fdt.c
@@ -112,7 +112,7 @@ int atags_to_fdt(void *atag_list, void *fdt, int total_=
space)
 	 * address and size for each bank */
 	uint32_t mem_reg_property[2 * 2 * NR_BANKS];
 	int memcount =3D 0;
=2D	int ret, memsize;
+	int ret, memsize, atag_size;
=20
 	/* make sure we've got an aligned pointer */
 	if ((u32)atag_list & 0x3)
@@ -184,6 +184,10 @@ int atags_to_fdt(void *atag_list, void *fdt, int total=
_space)
 		}
 	}
=20
+	/* include the terminating ATAG_NONE */
+	atag_size =3D (char *)atag - (char *)atag_list + sizeof(struct tag_header=
);
+	setprop(fdt, "/", "atags", atag_list, atag_size);
+
 	if (memcount) {
 		setprop(fdt, "/memory", "reg", mem_reg_property,
 			4 * memcount * memsize);



And this patch will export ATAG structure from DT tree ("/atags") into /pro=
c/atags file:

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 9946c1b..0f249a3 100644
=2D-- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -29,6 +29,7 @@
 #include <asm/mach-types.h>
 #include <asm/system_info.h>
=20
+#include "atags.h"
=20
 #ifdef CONFIG_SMP
 extern struct of_cpu_method __cpu_method_of_table[];
@@ -254,5 +255,10 @@ const struct machine_desc * __init setup_machine_fdt(u=
nsigned int dt_phys)
 	if (prop)
 		system_rev =3D fdt32_to_cpu(*prop);
=20
+	/* Save atags */
+	prop =3D of_get_flat_dt_prop(dt_root, "atags", NULL);
+	if (prop)
+		save_atags((void *)prop);
+
 	return mdesc;
 }


Some userspace applications needs access to ATAG structure where can be sto=
red some information passed=20
from bootloader to kernel. Example is Nokia N900 device and NOLO bootloader=
 which provides information=20
about bootreason (device was started by power button or by alarm or restart=
ed...) and bootmode (normal=20
mode or device update mode).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6109638.u9jTIsBsJt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTGkqQACgkQi/DJPQPkQ1KXBgCfft8H1X8FlZZeZv+0IHsX4yhc
Fc4AmgOq+O+vdKENPy4WbP+0HFpv205i
=8Eco
-----END PGP SIGNATURE-----

--nextPart6109638.u9jTIsBsJt--
