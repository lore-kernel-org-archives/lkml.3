Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbbAXJEt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 04:04:49 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:57123 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbAXJEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 04:04:41 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: N900 v3.19-rc5 arm atags_to_fdt.c is broken
Date: Sat, 24 Jan 2015 10:04:37 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: "linux-omap" <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Laura Abbott <lauraa@codeaurora.org>
References: <201501232239.55801@pali> <201501232336.36187@pali> <20150123234855.GB27111@amd>
In-Reply-To: <20150123234855.GB27111@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9180321.85KiyxG8Rs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501241004.37391@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9180321.85KiyxG8Rs
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 24 January 2015 00:48:55 Pavel Machek wrote:
> On Fri 2015-01-23 23:36:36, Pali Roh=C3=A1r wrote:
> > On Friday 23 January 2015 22:39:55 Pali Roh=C3=A1r wrote:
> > > Hello,
> > >=20
> > > when I boot zImage with appended DT n900 in qemu
> > > fdt_open_into() function called from file
> > > arch/arm/boot/compressed/atags_to_fdt.c (in function
> > > atags_to_fdt) always returns -FDT_ERR_NOSPACE.
> > >=20
> > > It means that all ATAGS (including cmdline arguments)
> > > passed by bootloader are ignored.
> > >=20
> > > On real n900 device I see that booted DT version also
> > > ignore cmdline arguments from bootloader. I cannot debug
> > > decompress code on real device, but I think it is same
> > > problem as in qemu.
> >=20
> > Looks like this quick patch is fixing above problem:
> So... something overruns stack, and bigger stack fixes it...?
>=20
> 							Pavel
>=20

Yes, it looks like that DTB file for n900 is too big and=20
atags_to_fdt.c cannot append anything to it (kernel cmdline)...

> > diff --git a/arch/arm/boot/compressed/head.S
> > b/arch/arm/boot/compressed/head.S index 68be901..4a7d75b
> > 100644
> > --- a/arch/arm/boot/compressed/head.S
> > +++ b/arch/arm/boot/compressed/head.S
> > @@ -268,7 +268,7 @@ restart:	adr	r0, LC0
> >=20
> >  		 * area.  No GOT fixup has occurred yet, but none of=20
the
> >  		 * code we're about to call uses any global variable.
> >  	=09
> >  		*/
> >=20
> > -		add	sp, sp, #0x10000
> > +		add	sp, sp, #0x20000
> >=20
> >  		stmfd	sp!, {r0-r3, ip, lr}
> >  		mov	r0, r8
> >  		mov	r1, r6
> >=20
> > @@ -289,7 +289,7 @@ restart:	adr	r0, LC0
> >=20
> >  		bleq	atags_to_fdt
> >  	=09
> >  		ldmfd	sp!, {r0-r3, ip, lr}
> >=20
> > -		sub	sp, sp, #0x10000
> > +		sub	sp, sp, #0x20000
> >=20
> >  #endif
> > =20
> >  		mov	r8, r6			@ use the appended device tree

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart9180321.85KiyxG8Rs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTDYCUACgkQi/DJPQPkQ1JBBACeOPAeqxfpzGp40XeRshhof/AJ
EQIAoJaxpX9yo0YF1B+C+PFo5ltCZt0s
=YwcT
-----END PGP SIGNATURE-----

--nextPart9180321.85KiyxG8Rs--
