Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaAPRI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:08:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55746 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaAPRI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:08:26 -0500
Date: Thu, 16 Jan 2014 17:08:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, jslaby@suse.cz
Message-ID: <20140116170814.GI17314@sirena.org.uk>
References: <1389848602-30985-1-git-send-email-tushar.behera@linaro.org>
 <20140116161841.GA7476@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zgY/UHCnsaNnNXRx"
Content-Disposition: inline
In-Reply-To: <20140116161841.GA7476@kroah.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] tty: Fallback to use dynamic major number
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zgY/UHCnsaNnNXRx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 08:18:41AM -0800, Greg KH wrote:
> On Thu, Jan 16, 2014 at 10:33:22AM +0530, Tushar Behera wrote:
> > In a multi-platform scenario, the hard-coded major/minor numbers in
> > serial drivers may conflict with each other. A typical scenario is
> > observed with amba-pl011 and samsung-uart drivers, both of these
> > drivers use same set of major/minor numbers. If both of these drivers
> > are enabled, probe of samsung-uart driver fails because the desired
> > node is busy.

> Why would both drivers ever be loaded at the same time?  Don't they bind
> to different hardware devices, and as such, never will be in the same
> system?

No, the issue is happening because the drivers are registering things
at module load time and not at device instantiation time.  While the
drivers won't actually be run together things like the multiplatform
defconfig and distro configs will build them in since people tend to
like to get serial early on.

> The driver shouldn't be registering it's tty devices if the hardware
> isn't present in the system, so how can this codepath ever happen?

A quick and unscientific poll of serial drivers seems to suggest that
uart_register_driver() is normally called when the module is loaded (if
it shouldn't be this is at least a very common error pattern).  This in
turn calls tty_register_driver() which checks for duplicates in major
prior to any device being instantiated.  Simply having the module
present is enough to cause problems.

> > The issue is fixed by adding a fallback in driver core, so that we can
> > use dynamic major number in case device node allocation fails for
> > hard-coded major/minor number.

> Did you test this out?  You still get userspace breakage with it :(

Yes.  I should put my hands up and say that this was my idea.  The
theory is that any system using static allocation for a device shouldn't
be affected (modulo races, it's not perfect obviously), any currently
broken system with a userspace with a dynamic dev will start working and
any breakage is confined to drivers which duplicated major numbers (and
even then only on systems with static /dev).

The other solutions I can think of are moving tty_register_driver() to
device probe time, allowing tty_register_driver() to accept duplicate
majors and the complaining when the devices actually get instantiated
or changing major numbers where there is a duplicate which is guaranteed
to break at least some userspaces with static devices (which was the
original patch you complained about).  The first two solutions look a
bit fun though perhaps they fall out more easily than I suspect.

--zgY/UHCnsaNnNXRx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2BH6AAoJELSic+t+oim90iUP+wZDDKtQKY+mIaCWRUfSkx1M
2kCyz5UsdBUjAE2xJV8JWJzcL4AJ0sqy+Vt6v14bam1gFPRdDsJ1dlzK/nk+XPiV
aLnrw3HO5rCR7SDrnnGXOiVzyVDLcB9bg61ACqHEvqAKCZjOgZ4yf6MGSVGLF7NA
e+LMV9xght7cU94QjhHb0359HVs8VJpj6BQf6Mcrr/aKeoTWRGP3JdKHlDdbiJTI
ySrTpKwh8JcBGlTIhbwowbEj6WCYVv/h5E88HI0ZyghW/G2qRw0zpFhcCPjcYdrs
Wo08hWGsw64TchnBvhyFC1KK3Wh9OJX9m+PEYCgj7/G6882QBqm+A+8Q65NpAg8D
A6NY+2+DjU9wajIEA05opqCcXaiLdZFjMCxhr2TaAE8vdlqwlV2fZhX2Kc7VpAzM
WFGPwZUp/bEYVvsGSQv0i6ugo8zffOZr8GQdsCh01/HU/5SCIPxaXXP02Zd2Z3jY
aU0e3WbZlemN3dRw8Hz8RF5EPhCddqVrDnucavKZzVAexx+vcFtDSiG2Eq/PKliR
w/nP8xT0o4Bee76vi3tzXTbAo00kJhogsEAsFO4qf++dmLDPb2IgED+ys5io1qrY
h7CQ2235BSzVsIUG3NWpH/BRNRD2T78lXb+UiAPt3+Xhow8ic5iaacr6OH/wSO0A
YRpnqFBWu59EvbRDsxit
=2aNp
-----END PGP SIGNATURE-----

--zgY/UHCnsaNnNXRx--
