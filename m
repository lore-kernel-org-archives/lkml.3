Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaFRTWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:22:36 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:35032 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaFRTWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:22:35 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Wed, 18 Jun 2014 21:22:29 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500-generic; KDE/4.13.0; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <CAL_JsqKw-C6uZBU3hccGmdofXcCcUKTV6z7Af6KwYwnZiy3HoQ@mail.gmail.com>
In-Reply-To: <CAL_JsqKw-C6uZBU3hccGmdofXcCcUKTV6z7Af6KwYwnZiy3HoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1530072.6DFM4huZF6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201406182122.29623@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1530072.6DFM4huZF6
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 June 2014 21:07:35 Rob Herring wrote:
> On Wed, Jun 18, 2014 at 11:54 AM, Pali Roh=C3=A1r=20
<pali.rohar@gmail.com> wrote:
> > Machine name from board description is some generic name on
> > DT kernel. DT provides machine name property which is
> > specific for board, so use it instead generic one when
> > possible.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >=20
> >  arch/arm/kernel/setup.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/arch/arm/kernel/setup.c
> > b/arch/arm/kernel/setup.c index 8a16ee5..fbc7b4f 100644
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -875,10 +875,13 @@ void __init setup_arch(char
> > **cmdline_p)
> >=20
> >         setup_processor();
> >         mdesc =3D setup_machine_fdt(__atags_pointer);
> >=20
> > -       if (!mdesc)
> > +       if (mdesc)
> > +               machine_name =3D
> > of_flat_dt_get_machine_name(); +       else
> >=20
> >                 mdesc =3D setup_machine_tags(__atags_pointer,
> >                 __machine_arch_type);
> >        =20
> >         machine_desc =3D mdesc;
> >=20
> > -       machine_name =3D mdesc->name;
> > +       if (!machine_name)
> > +               machine_name =3D mdesc->name;
> >=20
> >         if (mdesc->reboot_mode !=3D REBOOT_HARD)
> >        =20
> >                 reboot_mode =3D mdesc->reboot_mode;
>=20
> I did a similar patch previously[1]. Like my original patch,
> your patch unconditionally changes the name which could be
> considered part of the userspace ABI. It's arguably not good
> practice for userspace to depend on the name, but there are
> likely cases that do. So I think this needs to be optional
> and only use the DT name if the machine desc name is NULL.
>=20
> So something like the below and then change the machine
> descriptors you care about. The default generic DT machine
> desc should definitely be changed.
>=20
> I had a follow-up discussion with Grant about his concerns in
> the thread about knowing which machine desc used to boot. He
> said he was okay if just the machine desc address is printed
> out.
>=20
>=20
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 50e198c..1479250 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -887,7 +887,7 @@ void __init setup_arch(char **cmdline_p)
>         if (!mdesc)
>                 mdesc =3D setup_machine_tags(__atags_pointer,
> __machine_arch_type);
>         machine_desc =3D mdesc;
> -       machine_name =3D mdesc->name;
> +       machine_name =3D mdesc->name ? mdesc->name :
> of_flat_dt_get_machine_name();
>=20
>         if (mdesc->reboot_mode !=3D REBOOT_HARD)
>                 reboot_mode =3D mdesc->reboot_mode;
>=20
>=20
> [1]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-No
> vember/208878.html

Hi,

now legacy board code for Nokia N900 (RX-51) is migrating to DT =20
kernel and there is problem with info which /proc/cpuinfo reports

New DT kernel (3.16-rc1) reports:

# busybox cat /proc/cpuinfo=20
processor       : 0
model name      : ARMv7 Processor rev 3 (v7l)
=46eatures        : swp half thumb fastmult vfp edsp thumbee neon=20
vfpv3 tls vfpd32=20
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x2
CPU part        : 0xc08
CPU revision    : 3

Hardware        : Generic OMAP3 (Flattened Device Tree)
Revision        : 0000
Serial          : 0000000000000000

But legacy board code kernel reports:

# busybox cat /proc/cpuinfo=20
processor       : 0
model name      : ARMv7 Processor rev 3 (v7l)
=46eatures        : swp half thumb fastmult vfp edsp thumbee neon=20
vfpv3 tls vfpd32=20
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x2
CPU part        : 0xc08
CPU revision    : 3

Hardware        : Nokia RX-51 board
Revision        : 0012
Serial          : 0000000000000000

Basically in DT kernel is missing Hardware, Revision and probably=20
also Serial key. (Now I used only qemu for testing which set=20
serial key to 0). All these informations is used by userspace=20
applications which determinate how to behave.

So without this patch DT migration for Nokia N900 cannot be done=20
without breaking userspace - which is not acceptable...

Also I still did not know why DT kernel does not report Revision=20
number which is passed by bootloader via atags. Any idea?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1530072.6DFM4huZF6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlOh5vUACgkQi/DJPQPkQ1JO0ACgmIuGbcIMkTKm4uawjQXg4k3S
iSUAoKq/GnE+NQSpWpT9ucQnUcxyKTIM
=3IU3
-----END PGP SIGNATURE-----

--nextPart1530072.6DFM4huZF6--
