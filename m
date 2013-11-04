Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3KDI4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:56:43 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:51642 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3KDI4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:56:41 -0500
Date: Mon, 4 Nov 2013 09:56:37 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Strange location and name for platform  devices when device-tree
 is used.
Message-ID: <20131104085636.GD27445@ulmo.nvidia.com>
References: <20131101145925.66e22f73@notabene.brown>
 <1383279744.28909.26.camel@pasglop>
 <1383280054.28909.30.camel@pasglop>
 <20131101160329.37f3707b@notabene.brown>
 <1383282516.28909.36.camel@pasglop>
 <20131101204749.GA19662@kroah.com>
 <1383347425.28909.63.camel@pasglop>
 <20131102104505.34105cbb@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bajzpZikUji1w+G9"
Content-Disposition: inline
In-Reply-To: <20131102104505.34105cbb@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bajzpZikUji1w+G9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 02, 2013 at 10:45:05AM +1100, NeilBrown wrote:
> On Sat, 02 Nov 2013 10:10:25 +1100 Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>=20
> > On Fri, 2013-11-01 at 13:47 -0700, Greg Kroah-Hartman wrote:
> >=20
> > > > > On my device I seem to have some platform devices registered thro=
ugh
> > > > > device-tree, and some registered through platform_device_add (e.g.
> > > > > 'alarmtimer').  Guaranteeing they remain disjoint sets if the ker=
nel is
> > > > > allowed to evolve independently of the devicetree might be tricky=
=2E...
> > > > > Maybe we need "/sys/devices/platform" and "/sys/devices/dt_platfo=
rm" ??
> > > >=20
> > > > No, I think device-tree created platform devices should go
> > > > to /sys/devices/platform like the "classic" ones.
> > > >=20
> > > > The problem is really how to deal with potential name duplication. =
We
> > > > could try to register, if we get -EEXIST (assuming sysfs returns the
> > > > right stuff), try again with ".1" etc...
> > >=20
> > > How can there be device name collisions?  All platform devices _shoul=
d_
> > > be named uniquely, if not, you have bigger problems...
> >=20
> > The problem is how to create a unique name for a platform device created
> > from a device-tree node.
> >=20
> > Device tree nodes aren't necessarily uniquely named. They are unique
> > under a given parent but that hierarchy isn't preserved when creating
> > corresponding platform devices (and it would be very tricky to do so).
> >=20
> > Currently, we simply append a number to the name when creating them,
> > which is obtained from a global counter.
> >=20
> > Neil is unhappy about that because on his specific hardware, the device
> > has a unique name and thus we introduce a naming difference between
> > device-tree usage and old-style "hard coded" board file usage.
>=20
> It occurs to me that a different approach could solve my problem.
>=20
> My problem stems from the fact that the name of the device on the
> platform-bus is used as the name of the device in the "backlight" class.
>=20
> As Greg writes elsewhere, depending on names with /sys/devices is not
> supported - we need to accept that bus-names might change.
> However names in class devices tend to be a lot more stable.
> Several devices allow these to be explicitly set.
>  leds have 'label'
>  regulators has "regulator-name"
>  gpio-keys has 'label'.
>=20
> I could just teach pwm_bl to allow a 'label' property which would be used=
 in
> place of the platform-bus device name when creating the class/backlight
> device.
>=20
> The maxim "you cannot trust names to remain stable in /sys/devices" can
> justify both the movement of platform devices into /sys/devices/platform,=
 and
> the use of "label" rather than the device-name for creating the class dev=
ice.
>=20
> Does that sound convincing?

I see how this is a general problem, but since you've brought up the
topic of backlights, let me reply to that.

The correct thing, in my opinion, to do here would be to associate the
backlight with whatever device it is attached to. Typically this would
be a display. fbdev has some support for that already, and if I read the
code correctly then it automatically associates any backlight device
with any fbdev device (which obviously breaks once you start having more
of each, but that's probably not a typical use-case).

In my experience associating a backlight with its display and letting
the display driver control the backlight is the only sane solution. On
one hand it makes the association explicit, so userspace doesn't have to
hardcode any sysfs filenames to access the backlight. Furthermore only
the display driver knows when it's safe to turn on and off the backlight
since it controls the flow of pixels to the display.

Currently the Linux backlight framework turns on the backlight right
when it is registered (or more precisely that's what each individual
driver does). That means depending on the probe order the backlight will
light up before there's any meaningful content on the display. In many
cases that may turn out to be just black, but in other cases it may be
random content.

However, I'm not aware of any way to control the backlight from an fbdev
device in userspace. fbdev is also mostly considered obsolete these days
and I've been working on integrating backlight and panels with DRM for
quite a while now. That's also still missing a way to control the
backlight brightness via DRM IOCTLs, but it's on my TODO.

That probably doesn't help with the overall situation, but at least I
think it's what we should be doing for backlight devices.

Thierry

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSd2FEAAoJEN0jrNd/PrOhGigP/0q4i3L6QVPa5hl+tPRXYyK9
PQl7V5X2z8V6e4Oz+soQjQJkYp1QFmmBgmllsS7hXJ58YzSppSxUYnNjKF8QZKTe
nQkbwunYfiOFvfQJtqQEHh7ZEFxH7YcO5gcZsoYW1Ims5EbSJM5erFHFCIAq4r/R
BRnzX/4M4gd8ErBkSyrHt7nehI+uykyGAjciR5BJ/kB2wii/lniVojRfH0sjPW+t
EporN26y7B+dg+fjWeafDZoTvrW31rJAJxO98sGYM8HOTowK0/zabpHyeSdg2+Am
D/lm92G2xwAsGZpp5qdtwEcgyLjbilyoQyjmBnFzdvCSENyaQeg/1lQR+havuq8T
iCTGceIOkDkpkJFIL2skxKYMzcNwmVl/Tf9vOB3lyMmlPksCw0wqyXCGlxwQpk3Z
kPHlfyfmhghUTdWUznocPFSHfi+mr6szZjCr5o7qikDSPi/PnEuWJD1MsmKlYwz2
zapL4dn1OKkTWzzNpnPD5AT7pUu/XiFN8seML0ACZVj4dsAHRR5kUTe15rB4ShFa
E9ixvy87PFUzwPoXXntIXlOgdpU1k5o2rbtjQ2XXCk6KDrKlzicMT4xkpjR8xFnx
DhABbx7GvsggYv55Hm1uh+bzYS7YTQ8U5+nyWZ9KkUbN/opKzWk3AFy9JEDcDTmV
xZ6v5dr95lm/1QVPVy5G
=INAE
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
