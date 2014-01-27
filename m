Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaA0NTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:19:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59986 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbaA0NTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:19:19 -0500
Date: Mon, 27 Jan 2014 13:18:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Wei Ni <wni@nvidia.com>
Message-ID: <20140127131823.GX11727@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
 <20140126211357.6fa68909@endymion.delvare>
 <52E573B6.9040903@roeck-us.net>
 <20140126214936.7736f530@endymion.delvare>
 <20140126212256.GK11727@sirena.org.uk>
 <20140126224425.724698cd@endymion.delvare>
 <20140126231543.GN11727@sirena.org.uk>
 <CAMuHMdXn=PC9+gZC05_yufLhPgYUy2FhcocRpY-Qatux=kftiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V3VOne4eOnSspFMY"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXn=PC9+gZC05_yufLhPgYUy2FhcocRpY-Qatux=kftiA@mail.gmail.com>
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


--V3VOne4eOnSspFMY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 27, 2014 at 11:10:41AM +0100, Geert Uytterhoeven wrote:
> On Mon, Jan 27, 2014 at 12:15 AM, Mark Brown <broonie@kernel.org> wrote:

> > It's very easy to generate unbootable kernels by changing the kernel
> > config, I'd not immediately expect a randomly generated config to do
> > anything useful and things like FW_LOADER_USER_HELPER can be rather
> > miserable if you turn them on (that one produces enormous delays during
> > init which look awfully like hangs when you're watching your board
> > boot).

> This is not just a randomly generated config where you disable critical
> options. Just enabling a subsystem like the regulator subsystem shouldn't
> give you an unbootable kernel. It's even needed, think multi-platform
> kernels.
> Typically, I'd expect allmodconfig/allyesconfig kernels to actually boot
> (ignoring RAM size issues etc.).

So, not booting is probably not what's going to happen for most systems.
You will in general at least get console output and mostly the realistic
issues for boot failures are netboot in embedded systems.  I'm more than
aware of the idea of multiplatform systems, this is one of the reasons
why things like checking for DT being compiled in don't do the right
thing.

Don't get me wrong, I would prefer it if we had a way to transparently
make this stuff just work and we are getting there - that's what's
driving the recent changes with optional regulators for example - but
just ignoring errors causes other problems.  For DT and (assuming the
patch I sent last night gets applied) ACPI systems I think we're now
pretty much there which should cover the majority of users.  I also
think many architectures (especially older ones that don't see much
active hardware development) could probably do the same thing.

The issues that remain are around platforms which may use regulators but
need to have them come from board data in Linux.  Unfortunately the
mechanism we have for that currently only registers the supply mappings
when the regulator is registered which means it's difficult to tell if
the mappings are going to appear later so the core is never terribly
sure if it knows when everything is set up unless the platform tells it.
Knowing that is the key bit of information that allows us to be more
helpful now we've got regulator_get_optional().

Fortunately outside of the ACPI/DT cases the platforms that are affected
are generally embedded ones where the problems are going to be developer
only and so it should be relatively easy to deal with them (for the most
part just adding a regulator_has_full_constraints() call on the affected
system if disabing the regulator API isn't desirable).  Realistically it
is unlikely to be useful to enable on affected systems though.

The next step is to transition all the platforms in this class to a way
of setting up mappings that could be done purely in machine init (which
means they're in a similar position to DT and ACPI) but that's more work
than could sensibly be done in a bugfix context which is what people are
looking for here.

--V3VOne4eOnSspFMY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5lycAAoJELSic+t+oim95AYP/3KfdRHzyXVPkGIjBoBHizR9
/7cQu3A7t5GG1XbY7yO7XOl/ZLUjAhgM0WDCPWkTrAFl92Wp2Z8Vzo7G/CNcGp0/
U7r0RN0WBhLunelmTW/516UrRSoEOj0ar7Ztp6HpoNLWXaJFjKywhxKIm9W4Pi7M
OQ315swdcBWBApS6i7glCqCjWo993udNMiOswdYO5o82p5GphjTDr+IHfjQN4e0o
jFpA/OgABPdBKV2zd3i828/sXUhLR6KD6SZau43p7O2Igpk8rDuwrT00ZRhp3hqg
kUFUqStgixZqwgs14cURZ4IOqFe1LaCVz4vtPghyWxiACyd6kDZlDwOw9biNc6Zv
PaY7DeJBAaslPdnGPjBQMa7FrjvtLWCE7LIQNorIxJr/jOmrKPrE1btpemmOifkp
nmCzjypAKrxhiXxoq/LDU9cEWxMuQUIc0lSIyhlcPP136ewfQWX5WVJwdHNjiVBq
H2A4fD7ADRIXatTuY6U4vCTfunRVWehP3DI7bPck7w2LMdZtRKt5wAIcqEwykcRR
rty04olSMngAVxpLH2IupCLEAdjPmM7PO2qKu9RfXsfeRXe3pJQhnR1OqmuirExw
0IOx9yIhb7b4CYLsKdArvj7DQQgiKrX+7JUc+QdMx4NG7l4IfqJffXFcz++nSCbk
/Bc5oyPP84GFALnqG0eJ
=x0m3
-----END PGP SIGNATURE-----

--V3VOne4eOnSspFMY--
