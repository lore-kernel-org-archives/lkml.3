Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaKXWTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:19:32 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59477 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaKXWTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:19:30 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Mon, 24 Nov 2014 23:19:27 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201406182122.29623@pali> <CAL_JsqK5j8PvYfq+tct4RMr63TWDYGfi_TA28k5m4KyG=UuNbg@mail.gmail.com>
In-Reply-To: <CAL_JsqK5j8PvYfq+tct4RMr63TWDYGfi_TA28k5m4KyG=UuNbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2263090.uf8FviFA5I";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411242319.27481@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2263090.uf8FviFA5I
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 June 2014 22:46:19 Rob Herring wrote:
> On Wed, Jun 18, 2014 at 2:22 PM, Pali Roh=C3=A1r=20
<pali.rohar@gmail.com> wrote:
> > On Wednesday 18 June 2014 21:07:35 Rob Herring wrote:
> >> On Wed, Jun 18, 2014 at 11:54 AM, Pali Roh=C3=A1r
> >=20
> > <pali.rohar@gmail.com> wrote:
> >> > Machine name from board description is some generic name
> >> > on DT kernel. DT provides machine name property which is
> >> > specific for board, so use it instead generic one when
> >> > possible.
> >> >=20
> >> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >> > ---
> >> >=20
> >> >  arch/arm/kernel/setup.c |    7 +++++--
> >> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >> >=20
> >> > diff --git a/arch/arm/kernel/setup.c
> >> > b/arch/arm/kernel/setup.c index 8a16ee5..fbc7b4f 100644
> >> > --- a/arch/arm/kernel/setup.c
> >> > +++ b/arch/arm/kernel/setup.c
> >> > @@ -875,10 +875,13 @@ void __init setup_arch(char
> >> > **cmdline_p)
> >> >=20
> >> >         setup_processor();
> >> >         mdesc =3D setup_machine_fdt(__atags_pointer);
> >> >=20
> >> > -       if (!mdesc)
> >> > +       if (mdesc)
> >> > +               machine_name =3D
> >> > of_flat_dt_get_machine_name(); +       else
> >> >=20
> >> >                 mdesc =3D
> >> >                 setup_machine_tags(__atags_pointer,
> >> >                 __machine_arch_type);
> >> >        =20
> >> >         machine_desc =3D mdesc;
> >> >=20
> >> > -       machine_name =3D mdesc->name;
> >> > +       if (!machine_name)
> >> > +               machine_name =3D mdesc->name;
> >> >=20
> >> >         if (mdesc->reboot_mode !=3D REBOOT_HARD)
> >> >        =20
> >> >                 reboot_mode =3D mdesc->reboot_mode;
> >>=20
> >> I did a similar patch previously[1]. Like my original
> >> patch, your patch unconditionally changes the name which
> >> could be considered part of the userspace ABI. It's
> >> arguably not good practice for userspace to depend on the
> >> name, but there are likely cases that do. So I think this
> >> needs to be optional and only use the DT name if the
> >> machine desc name is NULL.
> >>=20
> >> So something like the below and then change the machine
> >> descriptors you care about. The default generic DT machine
> >> desc should definitely be changed.
> >>=20
> >> I had a follow-up discussion with Grant about his concerns
> >> in the thread about knowing which machine desc used to
> >> boot. He said he was okay if just the machine desc address
> >> is printed out.
> >>=20
> >>=20
> >> diff --git a/arch/arm/kernel/setup.c
> >> b/arch/arm/kernel/setup.c index 50e198c..1479250 100644
> >> --- a/arch/arm/kernel/setup.c
> >> +++ b/arch/arm/kernel/setup.c
> >> @@ -887,7 +887,7 @@ void __init setup_arch(char
> >> **cmdline_p)
> >>=20
> >>         if (!mdesc)
> >>        =20
> >>                 mdesc =3D setup_machine_tags(__atags_pointer,
> >>=20
> >> __machine_arch_type);
> >>=20
> >>         machine_desc =3D mdesc;
> >>=20
> >> -       machine_name =3D mdesc->name;
> >> +       machine_name =3D mdesc->name ? mdesc->name :
> >> of_flat_dt_get_machine_name();
> >>=20
> >>         if (mdesc->reboot_mode !=3D REBOOT_HARD)
> >>        =20
> >>                 reboot_mode =3D mdesc->reboot_mode;
> >>=20
> >> [1]
> >> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-> >> No vem=
ber/208878.html
> >=20
> > Hi,
> >=20
> > now legacy board code for Nokia N900 (RX-51) is migrating to
> > DT kernel and there is problem with info which
> > /proc/cpuinfo reports
>=20
> Thanks for providing your motivation which was missing from
> the commit message.
>=20
> > New DT kernel (3.16-rc1) reports:
> >=20
> > # busybox cat /proc/cpuinfo
> > processor       : 0
> > model name      : ARMv7 Processor rev 3 (v7l)
> > Features        : swp half thumb fastmult vfp edsp thumbee
> > neon vfpv3 tls vfpd32
> > CPU implementer : 0x41
> > CPU architecture: 7
> > CPU variant     : 0x2
> > CPU part        : 0xc08
> > CPU revision    : 3
> >=20
> > Hardware        : Generic OMAP3 (Flattened Device Tree)
> > Revision        : 0000
> > Serial          : 0000000000000000
> >=20
> > But legacy board code kernel reports:
> >=20
> > # busybox cat /proc/cpuinfo
> > processor       : 0
> > model name      : ARMv7 Processor rev 3 (v7l)
> > Features        : swp half thumb fastmult vfp edsp thumbee
> > neon vfpv3 tls vfpd32
> > CPU implementer : 0x41
> > CPU architecture: 7
> > CPU variant     : 0x2
> > CPU part        : 0xc08
> > CPU revision    : 3
> >=20
> > Hardware        : Nokia RX-51 board
> > Revision        : 0012
> > Serial          : 0000000000000000
> >=20
> > Basically in DT kernel is missing Hardware, Revision and
> > probably also Serial key. (Now I used only qemu for testing
> > which set serial key to 0). All these informations is used
> > by userspace applications which determinate how to behave.
>=20
> It is somewhat fragile to expect the name in the DT to match
> the old name from the kernel. As your patch to n900 dts
> shows, we'd probably have to update every dts file to make
> them match. While I think we should work to remove this
> string from the kernel, userspace depending on the DT model
> string is a bad idea. For example, if you had some platform
> with multiple OEMs just rebranding the same base design, they
> may all want to put their own model string into each product.
> The true h/w id is the compatible string.
>=20
> Serial number is easy. There is already a standard although
> not widely used property for it with "/serial-number". You
> just need to wire it up to cpuinfo.
>=20

There is no "/serial-number" property in kernel:

$ ls -l -a /sys/bus/soc/devices/soc0/
drwxr-xr-x    3 0        0                0 Jan  1 00:00 .
drwxr-xr-x   18 0        0                0 Jan  1 00:00 ..
=2Dr--r--r--    1 0        0             4096 Jan  1 00:00 family
=2Dr--r--r--    1 0        0             4096 Jan  1 00:00 machine
drwxr-xr-x    2 0        0                0 Jan  1 00:00 power
=2Dr--r--r--    1 0        0             4096 Jan  1 00:00 revision
lrwxrwxrwx    1 0        0                0 Jan  1 00:00=20
subsystem -> ../../bus/soc
=2Dr--r--r--    1 0        0             4096 Jan  1 00:00 type
=2Drw-r--r--    1 0        0             4096 Jan  1 00:00 uevent

> > So without this patch DT migration for Nokia N900 cannot be
> > done without breaking userspace - which is not
> > acceptable...
>=20
> I agree, but I would like to come up with something that
> prevents future dependence on this string.
>=20
> > Also I still did not know why DT kernel does not report
> > Revision number which is passed by bootloader via atags.
> > Any idea?
>=20
> Probably because no one cared until now and revision info for
> every SOC is different. I would like to see revision info set
> in the DT in a standard way and remove the various SOC
> specific kernel implementations.
>=20
> Rob

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2263090.uf8FviFA5I
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRzru8ACgkQi/DJPQPkQ1KBRACgyv7Yql578v0cHY0IuOdRVprW
anoAoJG3o+0d8BXW2QbnGOk4VXREJQws
=ifjm
-----END PGP SIGNATURE-----

--nextPart2263090.uf8FviFA5I--
