Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaAZXQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 18:16:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59796 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaAZXQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 18:16:36 -0500
Date: Sun, 26 Jan 2014 23:15:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <linux@roeck-us.net>, LM Sensors <lm-sensors@lm-sensors.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>
Message-ID: <20140126231543.GN11727@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
 <20140126211357.6fa68909@endymion.delvare>
 <52E573B6.9040903@roeck-us.net>
 <20140126214936.7736f530@endymion.delvare>
 <20140126212256.GK11727@sirena.org.uk>
 <20140126224425.724698cd@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xrUWgNVErK0vNKPg"
Content-Disposition: inline
In-Reply-To: <20140126224425.724698cd@endymion.delvare>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: lm90 driver no longer working on PCs in 3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xrUWgNVErK0vNKPg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 10:44:25PM +0100, Jean Delvare wrote:
> On Sun, 26 Jan 2014 21:22:56 +0000, Mark Brown wrote:

> > They only worked with a debug option turned on and generated warnings
> > every time they were used...  that kernel config would've been actively
> > broken for devices that wanted to do anything at all interesting with
> > the regulators and would've been prone to issues with init ordering and
> > races in any cases where there are actually regulators.

> No, you don't get what I'm saying. For PC users, the lm90 did not

I understand perfectly well thank you very much.

> request a regulator and things worked because the kernel isn't supposed
> to take care about things like that on PC machines. Now that the lm90
> driver does request a regulator, it fails on PC machines because no
> regulator is declared.

If and only if the user has enabled the regulator API on a platform that
hasn't fully configured it; if the user has not enabled the regulator
API it'll stub itself out and they'll never see it.

> Don't tell me that it is expected that things will fail if
> CONFIG_REGULATOR is enabled on a system which doesn't need it. It
> doesn't make any sense. If kernels would fail as soon as any enabled
> option wasn't actually needed, no system would boot out there.

It's very easy to generate unbootable kernels by changing the kernel
config, I'd not immediately expect a randomly generated config to do
anything useful and things like FW_LOADER_USER_HELPER can be rather
miserable if you turn them on (that one produces enormous delays during
init which look awfully like hangs when you're watching your board
boot).

> If regulator is enabled but not needed, that's something the regulator
> subsystem should figure out at run-time so that it can stub everything
> out and things keep working.

To repeat this is something the platform needs to tell the API; the only
safe thing that API is able to do by itself is hope that something is
going to turn up later on and supply some data.  Supplying stubs and
then trying to substitute the real thing in later isn't going to be
terribly clever, worst case we end up in the situation where a driver
talks to a device that has no power or partial power because we've hit
an init ordering race.  Requiring platforms to flag in code when they
use regulators isn't something that seems like it's going to be deployed
smoothly and quickly, I'd be concerned that'd cause as much trouble as
it avoids - up until now the kernel config has been sufficient.

I think the 90% fix here (aside from Ubuntu disabling regulators in the
kernel config which would be sane too) is that ACPI based systems ought
to be flagging that they have full constraints as soon as they boot and
decide they have ACPI in the same way that DT ones do, we can be pretty
confident that a system using ACPI will have all supplies taken care of
transparently by the platform.  This would deal with the PC situation at
any rate which is probably most of the users who care and aren't already
using DT.

The regulator API is in general conservative about what it does since
incorrect operation of regulators can cause lasting physical damage to
the system, in general doing nothing and generating errors will be
safer and we'd much rather deal with people running into that than with
damaged boards.  The general approach is that it only does operations it
was specifically told by some outside source were OK.  What it's doing
here is essentially saying that it doesn't know what's going on so it's
punting and hoping something tells it later on.

--xrUWgNVErK0vNKPg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5ZccAAoJELSic+t+oim9vzkP/i/Gn/u1w4qXPPZqSxMvy/bp
V9au3NLG+ovSzsuF8FuA8mYE3ZYqVlJzPuTmCRPh7UwfLWeflSldo+gYwg6bcGUc
YZQoUn+j0OEStmhq/WTZNt06NES/ZOUiohmmf1qkbnAgHGQBt5io8kELW+PeYpIe
Gg3271oPZiJWF13VpnYujfzs6uxY8s8De8HXlF3MJHFDguq1qirFRv5UJYryBUv3
L5kOBIqmwVfuhBa99Bt2sBMvKtOLEwUzC/Eljc45B2fqyw7etAbRkX3V8Yqs38Jd
uvkIQt40GsPQovdHnpEH3hrmWC6q+MUTFdbozH3F3WjjUx4++bxCyaDkuh2i+C6p
lcWokOfjhs8sv23zJKM/WNXz0WrPEsLTPbSEC4s17dw+PUqc8uRsR7hpZDWM2EFs
CN5az4cTmPybp2zlugIiShElkzwIN4GFIahzGOE/CRbr5r3qQc5lttRSUiNphK46
VT7D3xpz5wLclMVt8C66ssCETAstHwbWR+XklRba8VyaTSb6vtI/B+hzTt+TL82s
6xFo+oySju877LQog2lwFRiS4PNLwN43O2rCHDg6J+/yB804km123cfCQlOKjhtx
1jP0PTq+xk7f+f24tkBlr63AjjrxKWnXXUAFiywL0FCt/qN47/hXTKsciPDNXWAD
L4Tx705ntkgzieYQAu3n
=Ar8/
-----END PGP SIGNATURE-----

--xrUWgNVErK0vNKPg--
