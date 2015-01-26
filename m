Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbbAZTJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:09:52 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:42209 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694AbbAZTJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:09:50 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Subject: [PATCH] ARM: /proc/cpuinfo: DT: Add support for Revision
Date: Mon, 26 Jan 2015 20:09:45 +0100
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
  boundary="nextPart3152027.NJWSLrD9o8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501262009.45854@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3152027.NJWSLrD9o8
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Ok, here is patch which set Revision field (global variable system_rev) in =
/proc/cpuinfo from DT=20
revision property:

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 11c54de..9946c1b 100644
=2D-- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -19,6 +19,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/smp.h>
+#include <linux/libfdt_env.h>
=20
 #include <asm/cputype.h>
 #include <asm/setup.h>
@@ -26,6 +27,7 @@
 #include <asm/smp_plat.h>
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
+#include <asm/system_info.h>
=20
=20
 #ifdef CONFIG_SMP
@@ -204,6 +206,8 @@ static const void * __init arch_get_next_mach(const cha=
r *const **match)
 const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 {
 	const struct machine_desc *mdesc, *mdesc_best =3D NULL;
+	unsigned long dt_root;
+	const u32 *prop;
=20
 #ifdef CONFIG_ARCH_MULTIPLATFORM
 	DT_MACHINE_START(GENERIC_DT, "Generic DT based system")
@@ -215,17 +219,16 @@ const struct machine_desc * __init setup_machine_fdt(=
unsigned int dt_phys)
 	if (!dt_phys || !early_init_dt_verify(phys_to_virt(dt_phys)))
 		return NULL;
=20
+	dt_root =3D of_get_flat_dt_root();
 	mdesc =3D of_flat_dt_match_machine(mdesc_best, arch_get_next_mach);
=20
 	if (!mdesc) {
 		const char *prop;
 		int size;
=2D		unsigned long dt_root;
=20
 		early_print("\nError: unrecognized/unsupported "
 			    "device tree compatible list:\n[ ");
=20
=2D		dt_root =3D of_get_flat_dt_root();
 		prop =3D of_get_flat_dt_prop(dt_root, "compatible", &size);
 		while (size > 0) {
 			early_print("'%s' ", prop);
@@ -246,5 +249,10 @@ const struct machine_desc * __init setup_machine_fdt(u=
nsigned int dt_phys)
 	/* Change machine number to match the mdesc we're using */
 	__machine_arch_type =3D mdesc->nr;
=20
+	/* Set system revision from DT */
+	prop =3D of_get_flat_dt_prop(dt_root, "revision", NULL);
+	if (prop)
+		system_rev =3D fdt32_to_cpu(*prop);
+
 	return mdesc;
 }


And here is patch which convert ATAG revision into DT revision property and=
 append it into DT in=20
decompress code:

diff --git a/arch/arm/boot/compressed/atags_to_fdt.c b/arch/arm/boot/compre=
ssed/atags_to_fdt.c
index 9448aa0..e7e1cc9 100644
=2D-- a/arch/arm/boot/compressed/atags_to_fdt.c
+++ b/arch/arm/boot/compressed/atags_to_fdt.c
@@ -171,6 +171,8 @@ int atags_to_fdt(void *atag_list, void *fdt, int total_=
space)
 					cpu_to_fdt32(atag->u.mem.size);
 			}
=20
+		} else if (atag->hdr.tag =3D=3D ATAG_REVISION) {
+			setprop_cell(fdt, "/", "revision", atag->u.revision.rev);
 		} else if (atag->hdr.tag =3D=3D ATAG_INITRD2) {
 			uint32_t initrd_start, initrd_size;
 			initrd_start =3D atag->u.initrd.start;


I tested it on DT booted Nokia N900 and it is working, in /proc/cpuinfo is =
revision from ATAG.

I do not know which DT property to use for storing HW Revision, so if "/rev=
ision" is not correct one,=20
let me know what to use instead. Also you can add my Signed-off-by for both=
 patches.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3152027.NJWSLrD9o8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTGkPkACgkQi/DJPQPkQ1IHbQCfcRK+I47cYyW2jBZbk623mWL8
kegAoKIzg7kV8HJOHGr7Jgy8mmdNJa2z
=tz4i
-----END PGP SIGNATURE-----

--nextPart3152027.NJWSLrD9o8--
