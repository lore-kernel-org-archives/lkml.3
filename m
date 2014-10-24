Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaJXVTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 17:19:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46946 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaJXVTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 17:19:04 -0400
Date: Fri, 24 Oct 2014 22:18:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Rob Clark <robdclark@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, lgirdwood@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, David Brown <davidb@codeaurora.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Message-ID: <20141024211848.GP3729@sirena.org.uk>
References: <1414178111-19525-1-git-send-email-balbi@ti.com>
 <20141024201138.GL3729@sirena.org.uk>
 <CAF6AEGssn23wSaSCY-MH+CUk1YD2g7Ld+rejQq0BSHUAcXgZEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oSMU0HVueUMCAvn0"
Content-Disposition: inline
In-Reply-To: <CAF6AEGssn23wSaSCY-MH+CUk1YD2g7Ld+rejQq0BSHUAcXgZEQ@mail.gmail.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: stub out devm_regulator_get_exclusive
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oSMU0HVueUMCAvn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 24, 2014 at 04:36:24PM -0400, Rob Clark wrote:

> iirc, I was using _get_exclusive() in a few places where I wanted to
> be sure not to get dummy-regulator in cases where I should
> -EPROBE_DEFER instead (since probe order with DT is slightly
> hilarious, and since I depend on a few other drivers I end up
> deferring at least a couple times at boot)... I don't quite remember
> the details.  But afaict regulator_get() still allows dummy-regulator,
> which is what I specifically don't want.

No, this is actually making things worse.  You will only get a dummy
regulator from regulator_get() if no regulator at all is mapped in the
DT, if one is mapped then you'll always get either an -EPROBE_DEFER or
the real regulator.  Right now the driver is broken with respect to
-EPROBE_DEFER since it just completely ignores the error code and
carries on happily if any error is returned which means that the
behaviour is going to be unstable on any given system, what happens will
depend on probe order which could in turn depend on what's been built
modular and so on.

As far as I can tell the only thing the driver does with the regulator
it's grabbing exclusively is enable it in probe() and that's going to
work just as well with the dummy regulator anyway so I can't see any
reason to worry if the driver is getting one.

> If you have a recommendation for a better way, I am all ears.

Just use regulator_get() (or better, devm_regulator_get()) and pay
attention to the errors.  The driver should also disable the regulator
on remove and I'd be surprised if the other two regulators shouldn't be
using a normal _get() too.  If there is a good reason to use _optional()
then the code should be changed to use ERR_PTR() rather than NULL to
check for missing regulators and the driver needs to keep them enabled
as long as it's using them.

Given that the two optional regulators are only set to one specific
value it's a bit surprising that the DT doesn't do this but I guess it's
possible there could be broken DTs out there that do give permission for
set_voltage() for a range rather than specifying the correct voltage.

--oSMU0HVueUMCAvn0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUSsI3AAoJECTWi3JdVIfQeUwH/jPLNZhRL4z2STMPZ6I3A1B/
o9ELkEqtrRbyFQ5B+icjv0pDm9c/OyqQcFk/ciFXmI8WJMa63HcWOh0EzR7G07hC
/30dJ1UlK9sz92OgNQBjeztS6ZLAioFnUfMRvM1OIxlQZXxB8Sec48Z8VAcEO8U+
zXll+fEeJB7X/z05K2lwXj8ojGA+nNh4h7WbrUaUnQ8HJOGZ0J7tSFlz6ho7aqJQ
7bo+OWQGufcJC46gTJrUr7zX/9QBo98Ub6GkfU1QZx+Z9rUnwIZnjtlEDCI+fqNg
gzM/+i5LzO3eeg0ynzFKf7UbmgxfDz1i3tnQoVu4soti0j1VghXK1QJJg7AyYSA=
=trrL
-----END PGP SIGNATURE-----

--oSMU0HVueUMCAvn0--
