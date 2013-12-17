Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3LQWu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:50:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46932 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab3LQWu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:50:28 -0500
Date: Tue, 17 Dec 2013 22:50:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org, tiwai@suse.de,
        perex@perex.cz, linux-kernel@vger.kernel.org
Message-ID: <20131217225002.GR28455@sirena.org.uk>
References: <1386842368-19951-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y/XsGip80ttrIE8G"
Content-Disposition: inline
In-Reply-To: <1386842368-19951-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: Haste makes waste.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASoC: fsl: imx-wm8962: Grant hw_params/free()
 permission to control FLL
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y/XsGip80ttrIE8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 12, 2013 at 05:59:28PM +0800, Nicolin Chen wrote:

> +	mask = WM8962_MIXINL_TO_HPMIXL_MASK | WM8962_MIXINR_TO_HPMIXL_MASK |
> +		WM8962_IN4L_TO_HPMIXL_MASK | WM8962_IN4R_TO_HPMIXL_MASK;
> +	bypass |= snd_soc_read(codec, WM8962_HEADPHONE_MIXER_1) & mask;
> +	bypass |= snd_soc_read(codec, WM8962_HEADPHONE_MIXER_2) & mask;
> +	bypass |= snd_soc_read(codec, WM8962_SPEAKER_MIXER_1) & mask;
> +	bypass |= snd_soc_read(codec, WM8962_SPEAKER_MIXER_2) & mask;
> +
> +	/* Don't diable FLL if running multi-substreams or analogue bypass */
> +	if (codec_dai->active != 1 || bypass)
> +		return 0;

I don't think this works with the power down delay we do on playback -
the DAI will go inactive when closed but we'll still have the CODEC
active and using its clocks until the power down time has elapsed if
it's a playback DAI.  Trying to reclock the device while active is at
best risky, even if it's muted.

I do think refcounting from both here and the bias level changes is
going to be the most robust thing, that'd also avoid the need to peer
into the CODEC register map.

--y/XsGip80ttrIE8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsNUXAAoJELSic+t+oim9V88P/3rwuQnBlOpXwwt7LcF/1C/l
XKrfJCgaFntjyhyejM/J4WrWaZBIURiAFxDNN7SdOnyjMb9vE7j09YALASB364Af
DgdLQ7baElnnX4MAXjR0R2fDsu1PfOPSSSaepMh73yS2NzrD66KMlPY4y2HVmM+Y
XGzYXeyeytpBLr6QaaYYMTeX+b01EJ8VzmrN4JhE2Y7fHRlgZHrtusDj5catzSoz
QsJaZgTj/e0TIV9oGeTOJGFcpwbAyiv1ZlNyIaOvmSjIsDfmWSmtsyfqgK66ZdV7
cEDJi4/KGZwP7Hk3ZTOpbBmouFOzgW+WWf8oRCNUZbb8wcecd6u0Ix0QUCl3L4dr
tcD7f+l2iiR4U0wji8jX9PdDOQpI8J01puPZlLYpVoUE1WGhWTQREh5LyqG+Zo2W
s/OzdG2GAw3sEJ6FFtOr3/KgvnjYT7mT+l5ukBRKq20BI/JQ0SAAipnbbaS+lVGo
rtJfd76xN+4f3IYohxs3RWGn9f/3SIb2Pf/6HrhwcdfbpbN41CITLV18WBjivI54
IEQG+aVIvgYmNd5zz/Gz0y3TGNK7j5kPW13+z4qvrquFbXW+888PCiVfzJlF7Vf2
LWFn6tm8CA0W5je3MZdvRsIGGai55pKRaHcgHW3JQev7GUJxRZdB7MCjScI0mJ+W
KT7UcbYeU6jHSv3IclFJ
=er9B
-----END PGP SIGNATURE-----

--y/XsGip80ttrIE8G--
