Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaGGKnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:43:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbaGGKmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:42:54 -0400
Date: Mon, 7 Jul 2014 20:42:44 +1000
From: NeilBrown <neilb@suse.de>
To: Lukas Maerdian <lukas@goldelico.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, stern@rowland.harvard.edu
Subject: Re: [PATCH] gpio_keys, twl4030-pwrbutton: stay awake for 1sec on
 resume
Message-ID: <20140707204244.00488846@notabene.brown>
In-Reply-To: <20140704220336.5e809819@notabene.brown>
References: <1403906118-23517-1-git-send-email-lukas@goldelico.com>
	<20140628170820.GF23634@xo-6d-61-c0.localdomain>
	<BD5D0538-BD03-4CD8-8E12-2344AD7ED669@goldelico.com>
	<20140628200410.GA7561@amd.pavel.ucw.cz>
	<53B6846A.4030201@goldelico.com>
	<20140704220336.5e809819@notabene.brown>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/90A8i0iwp1cdgOPYYdGj=iZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/90A8i0iwp1cdgOPYYdGj=iZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 4 Jul 2014 22:03:36 +1000 NeilBrown <neilb@suse.de> wrote:

> On Fri, 04 Jul 2014 12:39:38 +0200 Lukas Maerdian <lukas@goldelico.com> w=
rote:
>=20
> > Hi all!
> >=20
> > On 28.06.2014 22:04 UTC+0200, Pavel Machek wrote:
> > >> And the msec parameter is described as:
> > >>
> > >> @msec: Anticipated event processing time (in milliseconds).
> > >>
> > >> Isn't calling pm_wakeup_event() with a non-zero msec the standard
> > >> method to handle this situation? And it is used in other drivers. E.=
g. in
> > >> _mmc_detect_change() or hub_suspend().
> > >=20
> > >  * Notify the PM core of a wakeup event whose source is @ws that will
> > >    take                   =20
> > >  * approximately @msec milliseconds to be processed by the kernel.  If
> > >    @ws is                =20
> > >  * not active, activate it.  If @msec is nonzero, set up the @ws'
> > >    timer to                   =20
> > >  * execute pm_wakeup_timer_fn() in future.                           =
                        =20
> > >=20
> > > Will take @msec milliseconds to be processed by the _kernel_. Yes, USB
> > > probing takes a lot of time in kernel. But you are using this
> > > parameter to wait for userspace...
> >=20
> > Well, it's not exactly waiting for userspace: The kernel goes to
> > suspend, before even being fully resumed.
> >=20
> > In any case, 0 msec (i.e. nothing) seems to be insufficient, even for
> > just the in kernel processing. And I think that's exactly the root cause
> > of this race condition between the device drivers and the autosleep
> > module. Of course this only materializes if CONFIG_PM_AUTOSLEEP and
> > CONFIG_PM_WAKELOCKS are enabled, which is rarely used up to now, I gues=
s.
> >=20
> > I think we either need some way of signaling that the kernel has fully
> > finished resuming, before autosleep sets the system to suspend state
> > again, or we need to set appropriate delays in the individual device
> > drivers, to give them enough time to process the resume event.
> >=20
> > As the pm_wakeup_event() call is already in place, I assume, that
> > setting appropriate processing times for each individual driver was the
> > intended way to go...
> >=20
> > I've CCed Neil Brown, who inserted the pm_wakeup_even() call with a
> > 0msec argument in both of the discussed drivers, so maybe he can shed
> > some light in this discussion?
> >=20
> > Best regards,
> >   Lukas
>=20
> You definitely shouldn't need a timeout.
>=20
> I know I understood the whole "autosleep" design once, but I never really
> liked it and memory fades.....
>=20
> I think that a key part of using autosleep was that userspace needs to use
> epoll with the EPOLLWAKEUP flag to listen for any events which can wake f=
rom
> suspend.
>=20
> If user-space is doing that properly, then the simple pm_wakeup_event(dev=
,0)
> is enough to ensure that the event gets through epoll and into user-space.
> I think userspace needs to take a wakelock before reading the event, thou=
gh I
> don't recall the exact details.
>=20
> So: if Android is trying to use autosleep and finding that an event wakes=
 the
> device but it goes back to sleep again before it can handle the event, th=
en
> either the driver isn't doing the basic pm_wakeup_event, or android
> user-space isn't using epoll and EPOLLWAKEUP as required.

The man pages for epoll-ctl(2) and epoll(7) now document the use of
EPOLLWAKEUP.
I don't think a formatted version is available yet but the raw version can =
be
seen at
  http://git.kernel.org/cgit/docs/man-pages/man-pages.git/tree/man2/epoll_c=
tl.2
and=20
  http://git.kernel.org/cgit/docs/man-pages/man-pages.git/tree/man7/epoll.7

and you can right-click the "plain" link to down load, then
   man --local-file epoll_ctl.2
to read it nicely.

NeilBrown

--Sig_/90A8i0iwp1cdgOPYYdGj=iZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU7p5pDnsnt1WYoG5AQLQYhAArhHlot4bQTl7IABdktTVrTu8WyvFxMb0
Qax3DguI2rBjIZT0M/bb+Fk5vsOfBp0EU2Je+0Wdj2EFpiR4TAA0BfpjosyjJTx1
TtTAiP5Qm2mGodhx3Jy/HTJeCkwoCvmFgHUPJvjlcJ5xPAPdsqPQImllg9qRrG3i
kqKWr94gxPyMRBSmip69z66DuYNSwQBPTCGbkRtuTe146bLRIxeOTEI5E9XaQFEO
s/0tPWc+Iy1HgICtLhrXf5Ua9Gzdi+3cICvaMpvQq257VN4L+DCvZ8XxoV3lsFge
MYrI9qdtImfHwWfwAfpR4fej2gRAxTtXj8PpyRrOTzzCRiWFKZAjZYz39N8x8+5w
wduyvjiA/i1dlR8IjxlT5FSqrcPKVDYfMvbWi4x8a+X4PKbyaYXwxyHyfVTUFNuk
LlrSPPt2qV3L+O2fCZZOC9heJiPnwC2CCFAkPP5MJA0rgvKl+RT56bwD/OSuE2Dp
ui3Rxg1X3DohdNbPY+pjIT7MpK9UooKnXVLEGAeEFnGyhVOrqhGMc6TiHx1UKAl8
4jDrS4Wap87bxphAf4c0XAGnxAqekvORec5KMxjYBw33wEAhn9fJnMi13JSUBzsa
jHjOGo3enrYntlVEf15X0gH64upKkhfMi+/9+vIomn2PESBPBzS4XJ73SWQHsluT
o/8wmiyRy1Y=
=mdxL
-----END PGP SIGNATURE-----

--Sig_/90A8i0iwp1cdgOPYYdGj=iZ--
