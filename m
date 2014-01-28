Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaA1MfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:35:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60600 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaA1Me6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:34:58 -0500
Date: Tue, 28 Jan 2014 12:34:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Wei Ni <wni@nvidia.com>,
        linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>
Message-ID: <20140128123444.GL11841@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
 <20140126211357.6fa68909@endymion.delvare>
 <52E573B6.9040903@roeck-us.net>
 <20140126214936.7736f530@endymion.delvare>
 <52E58330.90602@roeck-us.net>
 <52E58656.7000903@roeck-us.net>
 <20140126235103.GP11727@sirena.org.uk>
 <52E6951C.60609@wwwdotorg.org>
 <20140127185031.GA28910@roeck-us.net>
 <20140127230447.7e8be3a4@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bgx/+k0aatK7HQM2"
Content-Disposition: inline
In-Reply-To: <20140127230447.7e8be3a4@endymion.delvare>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [lm-sensors] lm90 driver no longer working on PCs in 3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bgx/+k0aatK7HQM2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2014 at 11:04:47PM +0100, Jean Delvare wrote:

> I have no idea, really. I have seen multiple patches flying around,
> each seems to have its own merits, but I simply don't know which is
> going in the direction. I don't know a thing about regulators, OF, DT
> etc. so I am really not the right person to make a decision about this.

So, regulators are in this context about providing power to the device.
Devices tend to work a lot better if they have power, we probably
shouldn't ignore errors in that because that's generally considered bad
form to ignore errors and the consequences of ignoring such errors are
typically bad if they are real.  Managing the power explicitly in
drivers both allows greater power saving in systems that are power
sensitive and allows us to ensure that we power on supplies for devices
before we try to use the devices in systems where we have to do that
=66rom Linux.  A big part of deploying this in a system is telling the
regulator API which devices are supplied by which regulators.

Having said all that many platforms just don't care about power on this
level (we're talking leakage currents here) and have no runtime power
managment available to the operating system.  These platforms probably
shouldn't enable the regulator API at all since it does nothing for them
so if the regulator API is disabled it provides stubs which look like
always on regulators.

If the platform tells the regulator API that it knows everything about
how devices on the platform are powered then the subsystem can safely
assume that any normal power supply that it doesn't explicitly know
about is there outside of Linux's control since otherwise the hardware
would be non-functional.  One way that can happen is if the platform is
using DT, that does cover a lot of the platforms that use regulators but
that's not the only way - specifying full constraints does this too.
There was a bug here in the regulator core, I've committed a fix for it
now which will go to Linus soon.

The patch I posted "ACPI: Flag use of ACPI and ACPI idioms for power
supplies to regulator API" (which is applied now) makes systems using
ACPI do the same thing, covering essentially all desktop and server
systems which I believe is going to cover essentially all non-DT users
who might run into this outside of an embedded context.  We could also
do the same for some architectures, and many are already covered by
virtue of using DT.

The problem cases that remain are with platforms that don't tell the
regulator core that they've handed over the full list of supply mappings
to the core.  Unfortunately the regulator API predates deferred probe so
with platform data it uses a mechanism based on handing over supply
mappings when a regulator is registered which totally fails to work with
deferred probe unless you defer any missing mapping since a regulator
may be registered later providing the supply.  It used to work OK prior
to deferred probe but that relied on init order hacks to do so which
aren't sustainable long term.  The fix for this is to add a new
registration method that the board can call during early init separately
to registering devices, that hasn't been done yet.  I will try to get
it done this release cycle but I wouldn't be comfortable rolling it out
as a bug fix.

> All I can say is: either someone comes up with a patch set which
> properly fixes the regression for all lm90 drivers users, or I will have
> to revert commit 3e0f964f.

If you're going to do something like that it would seem safer to just
ignore error handling in the driver instead.  That would at least have a
chance of powering the device on when Linux needs to do so, obviously it
won't relaibly do the right thing in all cases but affected systems
would have had issues with the unmodified driver anyway as the power
wouldn't be enabled.

Personally I think that providing ACPI is updated the problems are
mostly mitigated and are on the same order as something that might
trigger a timeout in the userspace firmware loader; it's not good but
it's fairly easily discoverable and resolvable for the people who run
into it as they are likely to be developers rather than end users and
the number of affected users is likely to be small (you'd have to have
an affected device in a system that hasn't told the regulator core it
has full mappings and also have enabled the regulator API).  It
therefore seems reasonable to leave the driver as it is while waiting
for an improved regulator registration method to be merged which I will
try to do as soon as possible.

Does that make sense?

--bgx/+k0aatK7HQM2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS56PhAAoJELSic+t+oim9g2EP/RFl6FvV8Q00zh4IoOIGrYAh
lrYkk8Nn266VnXPyvCS2EQ087fzmJa88kiVuKwxFx6hgWGVdeleeRtAx3k9Sx8gJ
e8wCzN+rYOPK50yNCalwQEQ+AzAX9WEV60vMWD2RewQ1nXel4qxLJu1jhdl4gO9E
U+Ifum+75EcW9MMhgW7quJZgz8RQW7rksHrp5wC1XBSYxUna7wjlIt5UNmQyjsjD
v66rEg8RoQ2XwxwvJTcj9pVnVpWZ2Zj+gSFAJRGbeOClNlBgpIvkcYFfKFUalyeX
C+hmhvI/3g323lId5AmdMkqAOZPJOYTEudDYSmTR5BGm1j/ufp1xgZwx8Ycgf1mx
1dMEfO/Kc8nA1gSnfs9ut1gihA61AlYNvUJvvrkSRwY0qBcW3c+ANUpaFT3Ab3jd
kiejnmLlOQvS2IjA6LLdRlWX1+gyYJUV/OKRUoeCrgqc7lpSppIpNZn8J1bsIlpO
VfStDVk9TXFhfTvpwm6d6rq1acBIB0FR+MJz+yz1lI/AmMlfBL0nTwyYWBwzAVef
kwKE6Fkv727ohZVDyaTEoH90/alAvHEDfGmoTqscTA4LL1Hc5XLNohmZplSSQ15k
OUiBnhECcMhWEf74vjBd4wIG8eZXKBr+OIstZEukJpq+7lJKGYSrjU0hsOMsAP7s
4tpro62aWFZp5+VvVRXS
=pJQn
-----END PGP SIGNATURE-----

--bgx/+k0aatK7HQM2--
