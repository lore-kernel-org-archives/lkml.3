Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbaGDMDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:03:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbaGDMDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:03:47 -0400
Date: Fri, 4 Jul 2014 22:03:36 +1000
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
Message-ID: <20140704220336.5e809819@notabene.brown>
In-Reply-To: <53B6846A.4030201@goldelico.com>
References: <1403906118-23517-1-git-send-email-lukas@goldelico.com>
	<20140628170820.GF23634@xo-6d-61-c0.localdomain>
	<BD5D0538-BD03-4CD8-8E12-2344AD7ED669@goldelico.com>
	<20140628200410.GA7561@amd.pavel.ucw.cz>
	<53B6846A.4030201@goldelico.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/t+C93uz6I1YIW8hkJhWVaK2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/t+C93uz6I1YIW8hkJhWVaK2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 04 Jul 2014 12:39:38 +0200 Lukas Maerdian <lukas@goldelico.com> wro=
te:

> Hi all!
>=20
> On 28.06.2014 22:04 UTC+0200, Pavel Machek wrote:
> >> And the msec parameter is described as:
> >>
> >> @msec: Anticipated event processing time (in milliseconds).
> >>
> >> Isn't calling pm_wakeup_event() with a non-zero msec the standard
> >> method to handle this situation? And it is used in other drivers. E.g.=
 in
> >> _mmc_detect_change() or hub_suspend().
> >=20
> >  * Notify the PM core of a wakeup event whose source is @ws that will
> >    take                   =20
> >  * approximately @msec milliseconds to be processed by the kernel.  If
> >    @ws is                =20
> >  * not active, activate it.  If @msec is nonzero, set up the @ws'
> >    timer to                   =20
> >  * execute pm_wakeup_timer_fn() in future.                             =
                      =20
> >=20
> > Will take @msec milliseconds to be processed by the _kernel_. Yes, USB
> > probing takes a lot of time in kernel. But you are using this
> > parameter to wait for userspace...
>=20
> Well, it's not exactly waiting for userspace: The kernel goes to
> suspend, before even being fully resumed.
>=20
> In any case, 0 msec (i.e. nothing) seems to be insufficient, even for
> just the in kernel processing. And I think that's exactly the root cause
> of this race condition between the device drivers and the autosleep
> module. Of course this only materializes if CONFIG_PM_AUTOSLEEP and
> CONFIG_PM_WAKELOCKS are enabled, which is rarely used up to now, I guess.
>=20
> I think we either need some way of signaling that the kernel has fully
> finished resuming, before autosleep sets the system to suspend state
> again, or we need to set appropriate delays in the individual device
> drivers, to give them enough time to process the resume event.
>=20
> As the pm_wakeup_event() call is already in place, I assume, that
> setting appropriate processing times for each individual driver was the
> intended way to go...
>=20
> I've CCed Neil Brown, who inserted the pm_wakeup_even() call with a
> 0msec argument in both of the discussed drivers, so maybe he can shed
> some light in this discussion?
>=20
> Best regards,
>   Lukas

You definitely shouldn't need a timeout.

I know I understood the whole "autosleep" design once, but I never really
liked it and memory fades.....

I think that a key part of using autosleep was that userspace needs to use
epoll with the EPOLLWAKEUP flag to listen for any events which can wake from
suspend.

If user-space is doing that properly, then the simple pm_wakeup_event(dev,0)
is enough to ensure that the event gets through epoll and into user-space.
I think userspace needs to take a wakelock before reading the event, though=
 I
don't recall the exact details.

So: if Android is trying to use autosleep and finding that an event wakes t=
he
device but it goes back to sleep again before it can handle the event, then
either the driver isn't doing the basic pm_wakeup_event, or android
user-space isn't using epoll and EPOLLWAKEUP as required.

NeilBrown


--Sig_/t+C93uz6I1YIW8hkJhWVaK2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU7aYGDnsnt1WYoG5AQJgjQ//epEG5ivyNftToOINKhoU+WjCwjEq8976
+pNKp7gPjt+duLuAAQhoXhkDJAaFJzuoBBz8mtfCy+lRBp7cdk2Do+B0W6ngdCvt
tERql3YHoLIsDN1k3VuK7Pbqyx1ngTh9IxA2oss+WDdQ95bv4nqR8mlLrJxaqvbj
UGZ0JOMzII8MSK6DkrR92DXFrXvaPjm/ornCMtw6mTyGfE5UbphMnAG3tu+m7/z5
kwB/5BBEjexyT1slyf5J7nsvucyUMGAdNk/Kctc5WoWrJAYbFinsJjTkfEKzqaMz
d0nvW4W6tWZ/NktgYhNkWS+pYkc/SCQ68V+ReRU92E5JnVTW25sbsIUnNn7tlIs2
N8kIhCzj5bMgDFG1H6mgMdPaAidhjURKrEGuaV5qcjvSNVKDeIikfVG+3XW1JwIn
kWyrULpwoeJISncksDIOoQavSWMgy0tA8q0xiQVlZ5/q3lIM0OCCracvVsjnEiuO
Xwsyv8MftsvETeefgWzaXVIKHANiXJ7EQ4Nz0y2fE+SOgNTS5aFKgsYX5HjaO0eF
7sTYpdLNue2Jh/4ppzALenKJjZHPeB8YRS1kDyE2nW1CBKMnbxjk0dptOdVK5XZ6
JG3pjMFF3AXhzLV5dBEQVCZIiK8+ttdiqr2MyVuz5WAe3Wl99dWzQOl4T09ek0WU
TRKZkg4y2KA=
=ywn+
-----END PGP SIGNATURE-----

--Sig_/t+C93uz6I1YIW8hkJhWVaK2--
