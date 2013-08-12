Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3HLVke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 17:40:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44526 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3HLVkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 17:40:33 -0400
Date: Mon, 12 Aug 2013 22:40:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130812214017.GH6427@sirena.org.uk>
References: <20130811190826.GH6427@sirena.org.uk>
 <20130812020257.GA7028@kroah.com>
 <20130812112344.GS6427@sirena.org.uk>
 <20130812205007.GA5822@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hzEylbkGUV43Aca1"
Content-Disposition: inline
In-Reply-To: <20130812205007.GA5822@kroah.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hzEylbkGUV43Aca1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2013 at 01:50:07PM -0700, Greg Kroah-Hartman wrote:
> On Mon, Aug 12, 2013 at 12:23:44PM +0100, Mark Brown wrote:

> > I don't think they're bus specific - the main issue with a lot of this
> > is that they're outside the infrastructure that the bus standardises so
> > we should have a general way of understanding this.  There will be bits
> > where the bus needs to get involved but the overall pattern is generic.

> The "pattern" is generic, yes, we've been dealing with that for well
> over a decade now (pci hotplug controllers are "out of line" and control
> when/if a PCI is device is added/removed.)

> I'd argue that each bus needs special logic to handle this, just like
> PCI hotplug did it with their hotplug controller logic.  Due to the
> nature of this type of thing, it's all out-of-line hardware that is
> custom to each device type / bus.

I agree that the bus will need some logic to handle this and I also
think Stephen is right that there are going to be some common patterns
for some device classes.  However I do think that this is a common
problem for pretty much all buses so we should be factoring out as much
as possible from the buses so they only have to deal with their bit of
things.  Most of the stuff that's worrying me is not anything the bus
should have any idea about beyond tunnelling the data to the device.

> > This doesn't work in general.  These things aren't really platform
> > specific at all, they're features of the devices that apply to any
> > system using them and while for some use cases (like WiFi and BT power)
> > an external thing that just manually applies power will be enough in
> > other cases we want to know about the device even while it's off and the
> > driver might be able to do extra things at runtime if it knows about for
> > example having some control over signals to the device.

> No, the device isn't platform specific, but the logic needed to turn
> on/off is platform specific, otherwise the device would "just work"
> properly as the bus is self-discoverable.

> Much like rfkill is, as you point out.  Those are all platform specific.

This is not just about power control - that's one of the simpler
applications but you're talking about essentially anything that might be
handled by platform data (or by the configuration SEPROMs on a
freestanding device for that matter, why would you put down an extra
part to configure the device when you can just load things from the AP).

> > For example in the Slimbus case we're normally talking about audio
> > CODECs.  In order to preserve the userspace API the device has to appear
> > to be present at all times, the driver will remember the settings the
> > user is making to be applied when it actually powers up and indeed the
> > powering up should be kicked off as a result of userspac acting on the
> > apparently present device.

> That's some horrible hardware, who thought of that?

It's actually pretty nice hardware in many regards; the bus is a bit
underspecified for maximum bandwidth in modern systems but it gives you
standardised multi-drop data streaming over two wires muxed with control
which helps with the pin counts and with simplifying the system hardware
design.

The disappearing from the bus thing is because you're aiming to hit low
power idle (but still functioning) states consuming very small numbers
of microamps, even having a clock running is measurable.

> > > Perhaps a semi-generic "platform" driver could be created, that knows
> > > how to handle these settings in the DT, but odds are, that might be
> > > difficult to make generic enough to cover a wide range of boards, but
> > > without specifics, it's hard to tell.

> > There's things like the rfkill stuff already, and the reset controller
> > on the way, but again this only covers a fairly small subset of the
> > issues.

> "small subset"?  How common is this type of thing?

Well, for Slimbus it's absolutely the norm, I've never seen a Slimbus
device that didn't have a need for platform data.  The small subset
there is of the problems rather than the devices - you'll cover a large
set of devices with a common helper like rfkill but trying to handle
everything with that pattern doesn't seem like it'll work.

--hzEylbkGUV43Aca1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCVY+AAoJELSic+t+oim9TPMP/jvJfidUU9IFPSmFnmyREH/j
Th3x/SOQDmRiJnfo7kr7Yj3HI17+RcYzra09fHts1bEOx9R/pjEYuXDOb0wJlP4S
9ZTIfxuxkrVg/g/1Y3x0ea3c3qmrprucq6Fa4vqL1B8qJG/Fi1CYdsxKelPYW9T3
84QPFFSprz0sMMpBYkfA7ifvS4UACYUlwrW+kx4nxS8nKF1gr5b//NHtPY/N5mhI
Dw2KXsn1gtMFb3b9UdEaWL5EnjlIHJo7zjACC2z7wTlOfFXv/iu9FKMyz/sPh4dI
Mx36oTHQ19Rl8NrURG5D6RsYf1WhU/YIGyP/QjrOku8U2iDbWPYFnbZ7XHfrNUTS
5AjEmIlYPWQyEAeWfKsRqoMy70DbtV5KcNomB97xxtnHbKrji83hFGF2cnWgca8h
NXSCwQyvO2Dr5xONg9xe4iyiFf9cT7d9SJC4/84r31KJtGP7Lz3jNWbbsxEmNLUN
2j3U4iRTsv/1Mz2b4BMi/WJy9DjOldrryGSW7Adbco1TpPojX84dnvppkVJRHt3m
LA0jSVhdJNpGohuctwLEnY/BHsqAC8bH4Gd3RvhDRK/K461hQpD27L1V0KILywlg
KkXdZhCey9ay0Y7CFH2xY4wqF8nLJOZAijerWS0pMwk2gHtoXszeZ/tQrubP5tkb
4Nlmfx+/m9BC5Hg87r0F
=Qv1R
-----END PGP SIGNATURE-----

--hzEylbkGUV43Aca1--
