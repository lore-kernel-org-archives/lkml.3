Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbbA1U5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:57:22 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57654 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbbA1U5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:57:18 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Date: Wed, 28 Jan 2015 14:58:22 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <20150127174818.GM26493@n2100.arm.linux.org.uk> <20150128005032.GK28663@atomide.com>
In-Reply-To: <20150128005032.GK28663@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1645923.dkCdYib5XP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501281458.22088@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1645923.dkCdYib5XP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 28 January 2015 01:50:33 Tony Lindgren wrote:
> * Russell King - ARM Linux <linux@arm.linux.org.uk> [150127=20
09:51]:
> > We _could_ (and have in the past) turned round and refused
> > to support these kinds of hacks - which IMHO is quite a
> > reasonable stance to take: the message we should be sending
> > is "if you wish to design new methods without discussing it
> > with us, we reserve the right not to support them in
> > mainline kernels; please discuss with us your
> > requirements."
> >=20
> > Each time that we accept one of these hacks, we're sending a
> > message that says "it's okay to work in this crappy way".
> >=20
> > Yes, I realise that the N900 has little in the way of
> > support, and we can't exert that kind of back pressure
> > (since there's no one to direct that onto to effect any
> > change) so I guess we just have to live with it.
>=20
> I believe after N900 Nokia dropped the custom ATAGs and used
> the kernel cmdline instead. And most of the n900 custom ATAGs
> are not even needed any longer.
>=20

Yes, almost all N900 ATAGs are static and are already hardcoded=20
into kernel or DT file.

Basically there are 4 non static values which are used:

1. ATAG_REVISION

2. ATAG_OMAP
2.1 OMAP_TAG_BOOT_REASON --> boot reason
2.2 OMAP_TAG_VERSION ("nolo") --> for bootloader version
2.3 OMAP_TAG_VERSION ("boot-mode") --> "normal" or "update"

ATAG_OMAP is non standard and contains sub-atags.

bootloader version is static now (as Nokia does not develop it=20
anymore), but boot reason and boot mode are set by bootloader and=20
are needed for userspace. boot mode tells init system/userspace=20
if to start normal OS or only small subset for flashing.

> The ATAG_REVISION is a standard feature that we should support
> naturally. I don't think we should add any custom ATAGs,
> except maybe for the bootreason.
>=20
> > > I think this kind of information (how was board/computer
> > > started) can be useful also for other architectures. E.g.
> > > on laptop you would like to know if if was started by
> > > RTC, power button, WakeOnLan, another ACPI event,
> > > rebooted machine, watchdog, etc... And scripts can act
> > > depending on this event (when by RTC, you need to run
> > > some planned job, when by watchdog reset you should check
> > > what caused that reason...).
> >=20
> > There is a standard way to get the boot information already:
> > look at the watchdog API:
> >=20
> > #define WDIOC_GETBOOTSTATUS     _IOR(WATCHDOG_IOCTL_BASE, 2,
> > int)
> >=20
> > which uses the WDIOF_* flags to indicate the last boot
> > reason.  It probably isn't as flexible as some may desire,
> > but it should provide at least the "watchdog rebooted us"
> > vs "over temperature" vs some other boot reason.
> >=20
> > The other thing to consider is whether we have a way to know
> > what the boot reason was, and what we should do if we do
> > not have a way of supporting some of the boot reasons.  For
> > example, if we have support for RTC alarm based booting,
> > but no way to actually tell if the boot was caused by the
> > RTC alarm triggering.
>=20
> On omaps, the bootrom passes the bootreason in r1 to the
> bootloader that can do whatever it wants with it. We could
> maybe pass it in the kernel cmdline to the watchdog driver
> for user space?
>=20

Not truth for N900. Bootreason depends on PRM_RSTST omap=20
register, state of vbat charger pins, time how long was power key=20
pressed, R&D data stored in CAL partition and other undocumented=20
registers for omap HS devices. I already tried to implement at=20
least some subset of it in userspace (or kernel), but it is=20
impossible because NOLO bootloader clear status of PRM_RSTST=20
register.

There is also copy of PRM_RSTST register stored at address=20
0x4020FFB8 (tracing data) but that address is rewritten (probably=20
by kernel), so we really cannot implement reading bootreason in=20
kernel.

But in early stage in uboot it is possible to read 0x4020FFB8=20
address and get some part of bootreason. But still PRM_RSTST is=20
not enough!

I would be happy if DT kernel can export /proc/atags file with=20
ATAGs passed by bootloader. It would be enough for me. In=20
userspace I can parse content and do what is needed.

In non DT kernel file /proc/atags is always exported.

> Of course the problem is that the signed bootloader on n900
> cannot be modified so the pass through u-boot would have to
> translate the custom ATAG for bootreason into a kernel
> cmdline..
>=20
> But it may actually make sense to add the bootreason ATAGs, it
> seems quite generic to me.
>=20

Which bootreason atag? Invent new? Or use above big ATAG_OMAP=20
structure? Inventing new does not solve anything because all=20
developers does not boot kernel for debugging from uboot -- but=20
directly.

> AFAIK, the other n900 ATAGs can be just ignored.
>=20
> Regards,
>=20
> Tony

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1645923.dkCdYib5XP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTI6v4ACgkQi/DJPQPkQ1KbmwCcCJO+NR4xe7DnXNHxunIuWsfa
e24AnA0IJHhPyl7F6hscPn5+Ew95q2zr
=GY7m
-----END PGP SIGNATURE-----

--nextPart1645923.dkCdYib5XP--
