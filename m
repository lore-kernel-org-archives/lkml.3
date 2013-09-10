Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3IJQNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:13:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50898 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3IJQNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:13:48 -0400
Date: Tue, 10 Sep 2013 17:13:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130910161321.GM29403@sirena.org.uk>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378733679-19500-2-git-send-email-mika.westerberg@linux.intel.com>
 <20130909154028.GP29403@sirena.org.uk>
 <20130910075100.GK7393@intel.com>
 <20130910122754.GK29403@sirena.org.uk>
 <20130910142631.GL7393@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3+4FpxPSY/W4B3y"
Content-Disposition: inline
In-Reply-To: <20130910142631.GL7393@intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C
 client devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O3+4FpxPSY/W4B3y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 10, 2013 at 05:26:31PM +0300, Mika Westerberg wrote:
> On Tue, Sep 10, 2013 at 01:27:54PM +0100, Mark Brown wrote:

> > > There is one difference though -- runtime PM is now blocked by defaul=
t and
> > > it needs to be unblocked from the userspace per each device.

> > ...as you say.

> > This seems crazy, why on earth would we want to have userspace be forced
> > to manually go through every single device and manually enable power
> > saving?  I can't see anyone finding that helpful and it's going to be a
> > pain to deploy.

> There are things like HID over I2C devices (e.g touch screen) where going
> to lower power states too aggressively makes the touch experience really
> sluggish. However, other HID over I2C devices like sensor hubs it doesn't
> matter that much. In order to get the best performance we have runtime PM
> blocked by default (and leave it up to the user to unblock to get power
> savings).

> That's basically what PCI drivers currently do.

So those specific devices need to implement runtime PM in an appropriate
fashion.  That's no need to implement a poor default for every single
device to work around poor implementations from some, especially when it
requires a userspace update to get acceptable performance again from the
unaffected devices.

> > However I had thought it was just a case of the drivers doing a put()
> > instead of their current code to enable runtime PM (you mention that
> > later on)?

> User still needs to unblock runtime PM for the device. The driver can call
> the runtime PM functions but they don't have any effect until runtime PM =
is
> unblocked by the user.

> However, I don't have problems dropping the call to pm_runtime_forbid() in
> this patch and leave it up to the user to decide whether runtime PM should
> be blocked for the device.

I think this is essential - we can't really go around forcing userspace
updates to restore runtime power management, nobody is going to thank us
for that and it sounds like the issue you're trying to solve is device
specific anyway.

> > > 	- The I2C core makes sure that the device is available (from bus
> > > 	  point of view) when the driver ->probe() is called.

> > I can't understand your last point here at all, sorry.  Can you expand
> > please?

> Sorry about that.

> At least with ACPI enumerated I2C client devices, they might be powered o=
ff
> by the BIOS (there are power resources attached to the devices). So when
> the driver ->probe() is called we can't access the device's registers etc.

> So we bind the device to the ACPI power domain (the second patch in this
> series) and then call pm_runtime_get() for the device. That makes sure th=
at
> the device is accessible when ->probe() is called.

OK, that is very much not the model which embedded systems follow, in
embedded systems the driver for the device is fully in control of its
own power.  It gets resources like GPIOs and regulators which allow it
to make fine grained decisions.

> > So then the obvious followup question is why this is even something that
> > needs to be implemented per bus?  Shouldn't we be enhancing the driver
> > core to do this, or is that the long term plan and this is a step on the
> > road to doing that?

> If we end up all buses implementing the same mechanism, I think it makes
> sense to move it to the driver core.

If we're starting to get a reasonable number of buses following the same
pattern it seems like we're in a position to start=20

--O3+4FpxPSY/W4B3y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSL0UeAAoJELSic+t+oim96B8P/1xTtQ4i4YGbb+od1h0R6yHb
aTo+/dcDE3ogXv0He3Fl4XBhaO4ONHcf+kqAsK4ugkVVJer+2iXiGa5VTROYfdoj
8QbjaxegU+Eyi52NrC1vl2PXSVyp36aI6bAeiNmXweQuVbxkYY01cwTzvg9Sqanz
R/7bl+QRPrc4VdZpsJnEWiQudC2Ps+OJQY/uxyqCT5Y3J4mtJnYTejIHHKQq5WmE
Jr2MzvzDfnXUxbcM0ttTiE5jpE4ev4QXEnivsNmn7RKFhUovGIkQ/vjN14Rv4zqG
cB7k2otZyvxIlrcW+/2YCI2upNV8w7i+ih9+pb2DOPC+o7Lhj5ldqK8VQFQLzxwD
H3+wE2Up7B9Wkgdh/GPQgodBMqakKirYzW5UoGa4JZaGtxD6dCle0YDCEkzcyko0
f0ubT7v8U2D0l5MtoOVnOZ16kRamAGvubxotkcifKnzLFzNyKB+vjKm8s5pSb8YP
5hsolPjCvkDLBjqmEZ081asGFQo3Cfe2lVoZh0eNPCET2fPL2vWu9Ce9G94+kPGA
lxvv7wwMV++mz95Av/G/unnfAyM/AxE2jS/RZ1ts7rCuFAMzXBw6nJvV/z6vDyWk
34ElCaakQVtQDlhhYHIRf76wEOVu2Pfuw6/zj9feq9l8d4C4P5MHKa9whwEAwqNR
Km2kegTipS67UuViybv8
=tc8o
-----END PGP SIGNATURE-----

--O3+4FpxPSY/W4B3y--
