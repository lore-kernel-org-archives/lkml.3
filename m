Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbbAIJni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:43:38 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:59327 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbbAIJn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:43:29 -0500
Date: Fri, 9 Jan 2015 10:43:25 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Anatol Pomozov <anatol.pomozov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Mark Rutland <mark.rutland@arm.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH] timekeeping: Move persistent clock registration code
 from ARM to kernel
Message-ID: <20150109094324.GA27845@ulmo>
References: <1415388855-35074-1-git-send-email-anatol.pomozov@gmail.com>
 <20141110095325.GC12126@ulmo>
 <CAOMFOmXpAm5iKCLFyorTW+n9YmgZMmrDGGe736tJX8C6BYQv-A@mail.gmail.com>
 <alpine.DEB.2.11.1411132334400.3935@nanos>
 <CALAqxLXYVLXZafNH_ag3WDFHkhMe5t23zLbvg7Sq+4_rTfy+Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <CALAqxLXYVLXZafNH_ag3WDFHkhMe5t23zLbvg7Sq+4_rTfy+Kw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2014 at 03:21:22PM -0800, John Stultz wrote:
> On Thu, Nov 13, 2014 at 2:46 PM, Thomas Gleixner <tglx@linutronix.de> wro=
te:
> > On Mon, 10 Nov 2014, Anatol Pomozov wrote:
> >> On Mon, Nov 10, 2014 at 1:53 AM, Thierry Reding
> >> <thierry.reding@gmail.com> wrote:
> >> > On Fri, Nov 07, 2014 at 11:34:15AM -0800, Anatol Pomozov wrote:
> >> >> ARM timekeeping functionality allows to register persistent/boot cl=
ock dynamically.
> >> >> This code is arch-independent and can be useful on other plaforms a=
s well.
> >> >>
> >> >> As a byproduct of this change, tegra20_timer becomes ARM64 compatib=
le.
> >> >>
> >> >> Tested: backported the change to chromeos-3.14 kernel ran on tegra =
64bit
> >> >> board, made sure high-resolution clock works.
> >> >
> >> > Using this on an upstream kernel doesn't work, though, because 64-bit
> >> > ARM doesn't implement struct delay_timer which the driver needs since
> >> > v3.17.
> >> >
> >> > But I suppose the delay timer infrastructure could be moved into the
> >> > core similar to the persistent and boot clock as this patch does.
> >>
> >> Thanks. It makes sense, I will send it in a separate patch, once this
> >> one will be reviewed. On our kernel I haven't seen this issue as we
> >> still use 3.14.
> >
> > That's why you should test/compile your stuff on latest greatest and
> > not on a year old conglomorate of unknown provenance. :)
> >
> > Aside of that I really wonder why we need that persistent_clock stuff
> > at all. We already have mechanisms to register persistent clocks AKA
> > RTCs after the early boot process and update the wall clock time
> > before we actually need it. Nothing in early boot depends on correct
> > wall clock at all.
> >
> > So instead of adding more extra persistent clock nonsense, can we just
> > move all of that to the place where it belongs, i.e. RTC?
>=20
> Sigh.. I've got this on an eventual todo list.. The big problem though
> is that the RTC infrastructure can't be called with irqs off, so its
> not as optimal for measuring suspend time.

Is that because many RTC devices are accessed over something like I2C or
SPI where interrupts are needed? Or are there additional reasons?

> Some of the suspend-time measurement with clocksources that don't halt
> is interesting here.
>=20
> So we need to add to the RTC infrastructure special accessors that are
> safe when irqs are off, and we can then deprecate the persistent clock
> bits. There's still evaluation quirks with setting the time earlier in
> boot or not (possibly some rng effects as well there), but that could
> be worked out if we had the suspend timing via safe RTC interfaces
> sorted.

If it's only about slow busses, perhaps we could copy what other
subsystems have been doing and add a ->can_sleep flag to RTC devices to
mark those that can't be accessed with IRQs off.

Having extra accessors seems to me like it won't work well. As I
understand it we have two types of RTC devices: those that use slow
busses and hence can't be accessed with interrupts off, and those that
don't use a slow bus and therefore can be used with interrupts disabled.
For the former I don't think it's possible to implement accessors that
are safe when IRQs are disabled and for the latter the accessors don't
need to be special. So I think a simple flag should be enough.

I've been thinking a little about how the implementation could look in
practice. Would we simply add code to the weak implementation of the
read_persistent_clock() function (kernel/time/timekeeping.c) which looks
for an RTC device usable as persistent clock?

So something like this:

	void __weak read_persistent_clock(struct timespec *ts)
	{
		struct rtc_device *rtc;

		rtc =3D rtc_class_open_persistent();
		if (rtc) {
			struct rtc_time tm;
			int err;

			err =3D rtc_read_time(rtc, &tm);
			rtc_class_close(rtc);

			if (!err) {
				rtc_tm_to_timespec(&tm, ts);
				return;
			}
		}

		ts->tv_sec =3D 0;
		tv->tv_nsec =3D 0;
	}

Where rtc_class_open_persistent() could be like rtc_class_open(), except
that it uses a match function like this:

	static int __rtc_match_persistent(struct device *dev, const void *data)
	{
		struct rtc_device *rtc =3D to_rtc_device(dev);

		return !rtc->can_sleep;
	}

If you still prefer to do this with accessors I suspect something very
similar could be done.

Adding Paul, who's been looking into this as well, to Cc.

Thierry

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUr6K8AAoJEN0jrNd/PrOhmJsQAKkLmpTCxArnB2KMmfyJjbmh
zmuB6aVOYMzH2tC1ATQk1rjFDJfv+UWi3KeBYOX6W1BykE/wHpKhyGuTuZlrocNC
VKcUF/+qMa0DS41VYJ/I8Rfls81vwuotMz5P8YZRa+fxC2H5DQtmMP4WTUqTdLJ3
erJVjlmpncsx8qbkhhAtOXzkXKVBVd6lM2fDOQVcptSQn12VwtSS2jwQXOG+/6rl
QZogAOVfQ0Rl1LX5yJ/uhWsnOlnljnt/5UG36h705nTi4l+QSbk/pfNvxU2ixiD0
ptnDW9LqdN+haZYoFBeKAhK/vwIyCJ+sHx2MCJNOujWifJxhm+2JxO05LmyWbyCG
BWNa88kIAPqGrsWfCYmIxB1Aug9oDvfZZyFz2ZJ+ou1ivAK3bGlpnjbYDWJRMwuA
V2SmANGybJFR6lxzhIuMWxT1jCz0ZifoGOG1/aqqMoO5X+KZ1bruXceqzRHMKx9l
BDtYqIObHBLK+eR1wWHYJJ+s9bI8ftzzNEa9GpBLYHGfbAJgnyr2jneCriyKsD+T
hjvT+cq9045xHlKfkNmtpuH40Lw3zhmX0x8MxYdkmc335jOFA6i/3XEaLMP8XBk6
QPl4bECFwjXjTM/xP2pdUaJfQPB3lelsZTr50SMWHuobrYtpkjRcIG6AO6tAPXek
N13i1Ir9N0eFqJW2xW7z
=foB/
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
