Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab3HNXzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:55:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46301 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3HNXzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:55:40 -0400
Date: Thu, 15 Aug 2013 00:55:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130814235519.GS2401@sirena.org.uk>
References: <20130814184643.GL2401@sirena.org.uk>
 <Pine.LNX.4.44L0.1308141514440.1701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TegBI+r9roYdcP94"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308141514440.1701-100000@iolanthe.rowland.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TegBI+r9roYdcP94
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 03:39:20PM -0400, Alan Stern wrote:

> I don't see the point of all this.  Obviously the device can't be used
> until it physically appears on the bus.  What benefit do you get from
> registering it and making it available to userspace before that?

Two things.  One is that some devices have the ability to perform useful
functions when powered down sufficiently that they can't run a complex
bus, providing notification when they need to wake up (or being woken up
if the power on comes from userspace).  The other is that then userspace
can just see the device and start using it when it needs it without
having to have a mechanism to discover that there's something there with
manual power control.

This can also be an issue in cases where we compose multiple physical
devices into composite ones for userspace (embedded audio and video do
this a lot for example).  A given bit of hardware may only be useful in
some circumstances.

> Well, basic "power this on" stuff is pretty much all we have discussed=20
> in this thread so far.  What other sorts of things are going to be=20
> needed for a general solution?

If you look elsewhere at the stuff I've been saying about Slimbus that's
the nastiest case I'm aware of in terms of the bus itself - that's got
the devices with low power modes that do useful things with the device
(and bus) mostly powered off and things like that.  Things like activity
detection of various kinds where the device is monitoring for activity
in a low power state.

I've also mentioned the devices that need platform data which is a part
of this too; one reason for knowing that the device is there before it
appears is so that we can pass platform data/DT/whatever to it.

> Now I'm getting confused.  It seems we're talking about at least three
> very different things here:

>      A: Devising a mechanism for platform code to do things involving
> 	devices that are dynamically registered on discoverable buses.

If we need random platform code then we're failing, half the point of
things like DT and ACPI is to avoid writing random board code.  we do
want to pass data to devices for their drivers to use but having to have
random bits of per board code would be really sad.

>      B: Telling the subsystem and driver code for a discoverable bus
> 	that a particular device is present before it has been=20
> 	detected.

>      C: Implementing a mechanism whereby drivers can take a device
> 	off-line while still pretending to userspace that the device
> 	is still present, by bringing it back on-line as needed.

> I don't see much connection between these things.  Perhaps you can
> explain in more detail.

I think the solutions for these overlap so much they're the same thing.
The situation we're in in in your case B is just the idle case for
condition C - if we know about the device before it's been detected then
if it's been removed we just go back into the situation where we know
about it but it isn't powered.

> (BTW, it's worth mentioning that C has already been done, in the form
> of runtime PM.  The difference may be that you propose to take the
> device so far off-line that it disappears from the bus.  AFAICS, this
> would be purely a private matter to be arranged between the subsystem
> and the driver; it does not need to be handled at the level of the
> device-model or PM core.)

Actually runtime PM is actually already used for completely offlining
devices on buses that are too blind to notice - it's only an issue on
buses that can notice insertion and removal and want to do something
about it.  The use cases I'm describing already happen in mainline today
for devices on the dumber buses.

I think if we've got something which the hardware engineers can do on
multiple buses then they probably will so we should have at least a
pattern for how it's going to work over multiple buses rather than
having to handle different models for different buses.  I'll try to have
a think about what that pattern might be at some point (in my copious
free time).

--TegBI+r9roYdcP94
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDBjkAAoJELSic+t+oim9Xw4P/iLwgpfVn03B9OGPl8t0nxly
cAPmm5qSC8dBWPFYDYIfxkg7tcwfM0CLEls7hDzo+2IOUlHlDWgpyIVdNXxgx+Q7
OzrH9+ldA0oRXh2cp1DMGNVsmGVxPY1mmbCXB1OR33pls24jpuuUV3SZhHZqHyvB
2lB3+uKuO1DGOg47y0aPFosA/w1wJSa38j0tsKUzpznOR9ztIADbNP9mrhUR0twd
GTXpe4ZX0fRm8F8vnlhkPtR5MGXT43k61OcV83Q7m74FPOowWBcY2BGLhdmtvY9Z
qa0YZSlEqI0nlXxxdWMrrQcrYdmvZWKoV4jCAnLdx7oe91t3qZ6FZXMhkyrbDAYW
gDfEHe713DxBcD8ZvsPw0oqRVS/4vVTmv+zVzoXqNV1OUjkB2lp14IC3vLO26TA+
5ZxqiPQlq58yfZyZyy3BYAe0AL3qHN4Gc7j3xnH2L5uZmv3gn/XFi/TrKPMCONVf
HDsm4we9bGZf142cINmr2r3x0kYPyzV1oGgXPmIqvf+2o3VswHESgzB7IOGPKKzG
oF5ZqdYG7D1Qj60meiDVK75tTc9WbASU79PpqBJLjD9vmX9H4jVf96fRIPYtG7kE
3ACbJEolfL7XnQ/yPtSzHWvYzeET0YK0BADtPjd5a8P0KP10ZdCp4Hp+I66gZSla
gWtSUt7iEZREJZMfVU5A
=5cs0
-----END PGP SIGNATURE-----

--TegBI+r9roYdcP94--
