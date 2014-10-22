Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaJVROG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:14:06 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37656 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753944AbaJVROE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:14:04 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2014 13:14:04 EDT
Date: Wed, 22 Oct 2014 13:04:33 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141022170433.GA10186@hungrycats.org>
References: <1413881397.30379.7.camel@hadess.net>
 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
 <1413911644.30379.12.camel@hadess.net>
 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
 <1413914978.30379.14.camel@hadess.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <1413914978.30379.14.camel@hadess.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2014 at 08:09:38PM +0200, Bastien Nocera wrote:
> On Tue, 2014-10-21 at 11:00 -0700, John Stultz wrote:
> > On Tue, Oct 21, 2014 at 10:14 AM, Bastien Nocera <hadess@hadess.net> wr=
ote:
> > >> As for: 'Export of "wake reason" when the system wakes up (rtc alarm,
> > >> lid open, etc.) and wakealarm (/sys/class/rtc/foo/wakealarm)
> > >> documentation'
> > >>
> > >> Can you expand more on the rational for the need here? Is this for UI
> > >> for power debugging, or something else?
> > >
> > > No, it would be used for automating backups, or implementing
> > > suspend->hibernation transitions. For example, right before the machi=
ne
> > > suspends, I would schedule it to wake up in a hour. If I get woken up=
 by
> > > the rtc alarm (and not by the user through a lid open), I might:
> > > - check that I'm plugged into the AC, it's night, and in the vicinity=
 of
> > > the server that handles my backups and so backup the system.
> > > - check whether the battery is low, and hibernate the machine (if it
> > > supports it, obviously).
> > >
> > > We cannot do that if we can't make out whether the wake-up came from a
> > > user action, or the alarm we set.
> >=20
> > I suspect wakeup type reporting is maybe not the best way to go about
> > this, since there may be a number of causes for wakeups and they can
> > arrive closely together in different orders, which can result in
> > races.
> >=20
> > For instance, if the machine suspends, and sets an alarm to be woken
> > up at midnight to do a backup, if the user resumes their laptop at
> > 11:59:59, should the backup still proceed at midnight?
>=20
> No. And I would expect that we would get a wake up type of "power
> button" or "lid open" in this case.

I have been using something like this for the last 7 years or so.
The relevant inputs are:

	1. is the user present (is there recent input on HID devices,
	keyboard/mouse, but ignore devices like light sensors, 3D
	accelerometers, and ACPI virtual keys)?

	2. which network connection(s) are available to reach the
	backup server?

	3. how much power is available (if on battery, how much run
	time left?)

	4. what is the policy (do backups happen at a specific time
	of day, or whenever they can?)

	5. was a backup completed successfully in the last N hours?

Note the absence of any information about the cause of recent
suspend/resume activity, or any input from suspend/resume at all.

Most of the inputs are used for table lookup with a bit of logic for
dependent configuration parameters.  e.g. from input #2, if the network
connection is not home or office, use a different threshold for the
amount of battery power required by input #3, assuming that when I'm in
those specific places I am never more than 5 minutes away from AC power.

In my setup a daemon evaluates all the input conditions whenever
any of them change, and if the result is "machine should sleep" then
it simulates #4 over time, sets an alarm for the next time "machine
should not sleep" is asserted, and goes to sleep.  If the next wakeup
event is less than 60 seconds in the future, we might miss the wakeup
alarm, so we just stay on.  The daemon controls the backup process (and
dozens of other power-state-dependent processes) with freezer cgroups.
The backup process knows nothing about power management or scheduling
(nor should it), it is simply running, frozen, or not running according
to the current conditions and the table.

All five inputs are relevant.  I don't want backups while I'm using the
machine as a desktop because of the latency impact on disk and network;
however, when I stop to get a coffee, the backups can proceed until I
get back.  If the only network available incurs per-bit usage charges
or it is a shared busy network with no excess capacity, there will be
no backups regardless of the other conditions.  If the machine has less
than six hours of battery power and no AC feed, there are no backups.

The best part is that in this scheme the backups can be scheduled
opportunistically, i.e.  whenever the machine is awake and required
resources are abundant or underutilized, so by the time midnight rolls
around there are rarely any outstanding backups left to do, and the
machine just sleeps straight through the night.

The same schema gets used for other processes like web browsers, but
with different values (e.g. the web browser runs only when there is
a network connection and one of AC power or recent user input, and is
frozen at other times so that the battery isn't wasted rotating banner
ads that nobody is looking at).

> >   What happens
> > if the user starts to use their machine at 12:00:01?
>=20
> I would expect the backup to stop and be tried again later.

Suspend/resume has nothing to do with this.  Backups should treat
suspend state like a routine transient network failure.  If I suspend
my laptop because I'm moving from one meeting room to another, the TCP
connections used by the backups should survive and backups will continue
as soon as the machine wakes up.  If the machine is suspended too long,
the backup TCP connections will fail, and the backup process will retry
if it's still in-window and stop if it's not.

> > Thus you probably want to have a "user present" status,
>=20
> We can do any sort of thing once the laptop is awake. But right now
> there's no way to know whether the resume is due to a user action or
> not.

This can be a useful thing to have, especially if it can be in the
form of a timestamped log of input events that occurred while userspace
was sleeping, and if it's not available any other way (e.g. by reading
the current state of wakeup button or lid sensor).

That said, I wouldn't advise building anything in userspace on top of
it, or at least not without combining that input with the other inputs.
The specific use cases you mentioned are much better served by ordinary
sensor inputs and userspace state tracking available after the kernel
is running.  The "wake reason" could be another of those inputs.

> >  then use the
> > timerfd() ALARM clockids to set any wakeups you'd like, and when they
> > trigger (if the system was suspended or not), decide to do your backup
> > based the conditionals you had above, using the user-present status in
> > a similar way to how you use AC status.
> >=20
> > I'd suggest looking into some of the details on how Android does its
> > wakelock logic, as well as the timerfd ALARM clockids, since I think
> > this would provide what you need.
>=20
> It doesn't. There's still a whole class of hardware that isn't always on
> as mobile SoCs are, and wakelocks aren't going to help if the kernel
> isn't running and we don't know why it started running again.

Funny, that never stopped me from implementing these use cases on such
hardware.  I didn't even need wakelocks, although I might have implemented
a functional equivalent in userspace.

> > My bigger concern here with your use case though, is that you might be
> > able to use ALARM timers more commonly, but that for much existing
> > hardware, corner cases like programmatic resuming of a laptop while
> > its packed in a bag somewhere might have thermal risks.
>=20
> I'm pretty sure that Windows has done this for years before we did. If
> the laptop cannot suspend reliably, then the user would disable it. We
> cannot keep designing around broken software.

> >   For mobile
> > devices this is an expected design point, but for off-the-shelf
> > laptops with big fans and exhaust vents, I'm not sure how safe this
> > would be, so you may need to constrain this functionality somehow (or
> > look to see if a enforced low-power resume is possible).
>=20
> I think that we won't know whether it's a problem until the point that
> somebody actually implements it.

I have implemented this starting about 9 years ago with a variety of
off-the-shelf laptops, netbooks, DIY Beagleboard-based hardware, etc.
There are two cases:  devices that will run happily inside a laptop
bag, and devices that won't.  The first case is trivial and requires no
further discussion.  The second case requires reliable implementation
of one simple policy:

If the machine wakes up with no AC and the lid closed, assume the machine
is in a laptop bag and go straight back to sleep again.  There is usually
just enough time to do this--and nothing else--before a dangerous amount
of heat builds up (assuming you're waking from S3 suspend or similar...if
you're waking from suspend-to-disk then you've already cooked the laptop
before userspace is running).

If the kernel crashes and fails to suspend or power off, the laptop _will_
be damaged (at the very least there will be a permanent reduction of
battery capacity), but that's true of OSX and Windows too.  If there is
a choice between crashing and powering off, power off by default (an
option to power off on kernel panic would be particularly useful).

Note that there is never a "why are we awake?" input here.  If you really
get to the bottom of this, the only relevant input is "is it safe to
run now, or do I need to suspend immediately?" and you need to monitor
and respond to that input all the time, not just when waking up.  I don't
have a reliable "am I on fire yet?" input on random laptop hardware, so
I must I infer from the closed lid and battery power that some exception
to normal or safe use cases may be in progress.

I've had machines packed in laptop bags that ended up being handled so
roughly by airport people that the power/wakeup buttons on the keyboard
were pressed *through* the display panel.  The machines woke up in a
laptop bag, drained the battery, and generated enough heat to make the
case too hot to touch.  Technically, these machines were woken by user
action, but that doesn't mean they were in a safe operating environment.
The following day I implemented the "immediately go back to sleep
when the lid is closed and not on AC" policy and never looked back.
(of course this assumes reliable lid and AC sensor inputs...)

One note for the kernel PM people here:  if userspace tells the kernel to
suspend, it means suspend.  Immediately.  Right Fscking Now.  Not "wait
20 seconds for some random process stuck in iowait with a network file
server or broken USB device, and then resume again with only kernel
log messages to distinguish between that failure case and a user who
just closed the lid and then changed their mind."  From the kernel,
don't call sync(), and suspend any buffer flushing already in progress.
Dirty buffers will still be in RAM on resume, and can be flushed when
the disks come back up.


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRH46EACgkQgfmLGlazG5yAMQCgxPwf6ds8V4FG0q0t+89PBRA2
KawAoJH7gatdk+oSYBW20Q0rm1j2XBnR
=tCP3
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
