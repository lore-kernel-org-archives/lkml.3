Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbbAWWgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:36:44 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47637 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbAWWgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:36:39 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "linux-omap" <linux-omap@vger.kernel.org>
Subject: Re: N900 v3.19-rc5 arm atags_to_fdt.c is broken
Date: Fri, 23 Jan 2015 23:36:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Laura Abbott <lauraa@codeaurora.org>
References: <201501232239.55801@pali>
In-Reply-To: <201501232239.55801@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2581763.h7yRvStkLW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501232336.36187@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2581763.h7yRvStkLW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 23 January 2015 22:39:55 Pali Roh=C3=A1r wrote:
> Hello,
>=20
> when I boot zImage with appended DT n900 in qemu
> fdt_open_into() function called from file
> arch/arm/boot/compressed/atags_to_fdt.c (in function
> atags_to_fdt) always returns -FDT_ERR_NOSPACE.
>=20
> It means that all ATAGS (including cmdline arguments) passed
> by bootloader are ignored.
>=20
> On real n900 device I see that booted DT version also ignore
> cmdline arguments from bootloader. I cannot debug decompress
> code on real device, but I think it is same problem as in
> qemu.

Looks like this quick patch is fixing above problem:

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/hea=
d.S
index 68be901..4a7d75b 100644
=2D-- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -268,7 +268,7 @@ restart:	adr	r0, LC0
 		 * area.  No GOT fixup has occurred yet, but none of the
 		 * code we're about to call uses any global variable.
 		*/
=2D		add	sp, sp, #0x10000
+		add	sp, sp, #0x20000
 		stmfd	sp!, {r0-r3, ip, lr}
 		mov	r0, r8
 		mov	r1, r6
@@ -289,7 +289,7 @@ restart:	adr	r0, LC0
 		bleq	atags_to_fdt
=20
 		ldmfd	sp!, {r0-r3, ip, lr}
=2D		sub	sp, sp, #0x10000
+		sub	sp, sp, #0x20000
 #endif
=20
 		mov	r8, r6			@ use the appended device tree


=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2581763.h7yRvStkLW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTCzPQACgkQi/DJPQPkQ1J1dgCfeSVVW5Eplof775qo1RzZU6pb
CkYAni5ZKzxZQKK/RREC3FomkshXSMdK
=EW5B
-----END PGP SIGNATURE-----

--nextPart2581763.h7yRvStkLW--
