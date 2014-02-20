Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaBTXbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:31:45 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47773 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaBTXbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:31:43 -0500
Date: Fri, 21 Feb 2014 08:30:58 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140220233058.GC12197@sirena.org.uk>
References: <1392913608-23479-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Content-Disposition: inline
In-Reply-To: <1392913608-23479-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.141.82
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: wm5102: Remove cache_bypass from manual register
 patching
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 04:26:48PM +0000, Charles Keepax wrote:

> As the cache_bypass is not strictly necessary for applying the patches
> (the device is always powered on whilst it is applied) remove the calls
> to regcache_cache_bypass to avoid this situation.

That's not why the cache bypass is there, the cache bypass is there to
make sure we don't cache the writes and hence reapply them while
restoring the cache.  This would cause breakage with writes which change
register defaults (where it would overwrite previously cached writes) or
need to be done in that specific sequence.  A bypassed write goes
straight to the hardware so it can't work if the device is powered off.

Given that this is happening on resume I expect you can achieve
sufficient exclusion by making sure that everything that writes to the
device holds a runtim PM reference which you ought to be doing anyway,
the PM infrastructure makes sure that only one resume can run at once.
However I expect that's going to be annoying with ASoC where you don't
really want to boot the device just to change controls (but perhaps with
autosuspend it's not too bad, most likely the device will be getting
powered up shortly anyway if userspace is fiddling with the controls).

Being able to use the regular patch infrastructure would of course be
nicer but you're going to need to add a callback to allow you to run the
hardware patch in that case.

You probably also want to be applying the patch using async writes to
improve performance but that's separate and just an optimisation.

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBpAqAAoJELSic+t+oim9bFEP+wUM3kM/KlJ6qUSFWUT8w0fF
4PqkNXP6ncvA6u7hWUfi4XVB6zVJHOLr+/PD2a4nwJ+Y4yV0JpPfXGHe/+H5S8HX
uwkjzWu87xFTca8qsHIro3BzzvwFai1+QpQ5N9YLIx84EYTAnqBnEtqH8nrKlNMq
K4KUChWa7POOTIOFLvsMwlBXteHwrekAqMe5hdBTTCOIzG89zntyJVtE1k5tfXlZ
OZIY6zLrEp7sMy9qPYILXnHtDPP4DtRYyQ2Cv8jFaxVUNI2pqi3EdB545MghXSx7
mcqIDR/XIN1eHUvHvT+hR4tYJQ61OYyLsvaS/KyXm1A2uWuuA6Zl05lyayvFMl5s
AxaL07ESFpM0UHm0upvy9cD7Lz3Q4qGWmu4qmHf+3SIbP4xg1Uxj7LDvCSoUEkfl
tul/KM31KnftTe10bhmdtw9gqVtMO6jTqt+Dj25lGN3t2Qx9PpzyGdnXG92K9Zgr
NvLKiEdzH7ZiGpAIp1xgbNDOQDdMHnnnlpiJ6ZUj3M/hkberVvxxTgTmVGJINJyz
8vP+ReZFAAojFM/uq4oUjX10YV7YlO6mdx++Tw2wFNpY3ZS4kiWaQc8RwA3JXV0k
ezdrDuBLV5WDOW7vdPPB9rqzQ1ayJ+DJrXC+BgrBDa8vUublJ6nXVrAMyclu6Dx1
Id86dUkR/ll17/gC9aeU
=8gns
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
