Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3A3Hk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 02:40:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58760 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3A3HkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 02:40:25 -0500
Date: Wed, 30 Jan 2013 08:40:20 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, gnurou@gmail.com
Subject: Re: [RFC 0/4] Use the Common Display Framework in tegra-drm
Message-ID: <20130130074020.GA17547@avionic-0098.mockup.avionic-design.de>
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:TvWNhG7YhXFwOh0opLJlAEcgFX7UibT9H1RJHRfIJhC
 nYvxWRjxD5fgGjzJilT3+bVX9ANiRku9aCM4GDiQGa8RCXnumc
 +bHbodEDcSfvf00o+B6MeHv9xkSqBBlbUjWsZoCbiUETnM6ZrF
 tU6430dq1fFOgJ6eqJX4ASfzArDdan2O2zIkhR2Zucj2Xlv39J
 gMxu7Hv5kBY+8x+Zk4GotraCquv2EmzhC76cIEcAOdXShY+KfU
 ZsSR6jnV8HfleKa1Z+Cw5OMOcncO35X1euyRqg/wbDTSp+Kpgx
 t1wTTGgdR6VYwqW7EnKNwzax923ZVRjx9GqoyVsQi1FPgchzkP
 3FoT2VbiMYj3CiCGVjjxFMCgXa6cwM1CL9LiM49tj/JQ9VLA4+
 LllNGf7J9v9DK2t0fvt7S3JTls4cSCjTdA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 30, 2013 at 12:02:15PM +0900, Alexandre Courbot wrote:
> This series leverages the (still work-in-progress) Common Display Framewo=
rk to
> add panel support to the tegra-drm driver. It also adds a driver for the
> CLAA101WA01A panel used on the Ventana board.
>=20
> The CDF is a moving target but Tegra needs some sort of display framework=
 and
> even in its current state the CDF seems to be the best candidate. Besides=
, by
> using the CDF from now on we hope to provide useful feedback to Laurent a=
nd the
> other CDF designers.
>=20
> The changes to tegra-drm are rather minimal. Panels are referenced from T=
egra DC
> output nodes through the "nvidia,panel" property. This property is looked=
 up
> when a display connect notification is received in order to see if it poi=
nts to
> the connected display entity. If it does, the entity is then used for out=
put.
>=20
> The DPMS states are then propagated to the output entity, which is then s=
upposed
> to call back into the set_stream() hook in order to enable/disable the ou=
tput
> stream as needed.

Thanks *a lot* for taking care of this Alexandre! From a quick look at
the patches they seem generally fine. I'll go over them in a bit more
detail though.

> Although the overall design seems to work ok, a few specific issues need =
to be
> addressed:
>=20
> 1) The CDF has a get_modes() hook, but this is already implemented by
> tegra_connector_get_modes(). Ideally everything should be moved to the CD=
F hook,
> but Tegra's implementation uses DRM functions to retrieve the EDID and CDF
> should, AFAIK, remain DRM-agnostic.

Maybe a good option would be to just not implement get_modes() if the
same information can be retrieved via EDID. That is, the DRM driver
could just go and fetch EDID when the nvidia,ddc-i2c-bus is available
(or parse the nvidia,edid blob) and only rely on CDF otherwise.

So for Ventana the only reason why we need CDF is basically the power
sequencing, right?

> 2) There is currently no panel/backlight interaction, e.g. backlight stat=
us is
> controlled through FB events, independantly from the panel state. It coul=
d make
> sense to have the panel DT node reference the backlight and control it as=
 part
> of its own power on/off sequence. Right now however, a backlight device c=
annot
> ignore FB events.

I definitely think that we should aim for correct panel and backlight
interaction. Perhaps this could work by looking up the real backlight
via it's phandle and have the CDF driver use the backlight API to
disable or enable the backlight as part of the power sequencing.

I'm not sure what you mean by "cannot ignore FB events"? Can you provide
a concrete problematic use-case?

> 3) Probably related to 2), now the backlight's power controls are part of=
 the
> panel driver, because the pwm-backlight driver cannot control the power
> regulator and enable GPIO. This means that the backlight power is not tur=
ned off
> when its brightness is set to 0 through sysfs. Once again this speaks in =
favor
> of having stronger panel/backlight interaction: for instance, the panel d=
river
> could reference the backlight and hijack its update_status() op to replac=
e it by
> one that does the correct power sequencing before calling the original fu=
nction.
> This would require some extra infrastructure though. Another possibility =
would
> be to have a dedicated backlight driver for each panel, with its own
> "compatible" string.

Hijacking .update_status() sounds a bit risky. But perhaps you could
wrap the real backlight in a CDF backlight to receive notifications.
Obviously you'd get two backlight devices in sysfs, but that turn out
not to be a problem.

Thierry

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRCM5kAAoJEN0jrNd/PrOhuJgP/R2V+SnteE1iaXV7AhLyiFpW
tqcu6IPC7fqwrgQWISoCJecdJ/0ycB2ZLIJeDwdw0VHnhejt+NJmvS+J25Th5M5q
tmq8ZNEjUyNybQIHaUpASZDuTocfefuM9LJDKb5RlpiortyrhvVyySqrBxX/PFwn
8NRKh+y0DRNj1wOyhTnnBID8Xh5UrAx9oWMQklGKS9npGW9IFrZKr0WU457bOG/7
Fp3M9eauQ1NsiHsfXZcRXz7QNRn08AOksfLiS3/eIONEx2bVzQrCcN6Bq/nr7zLz
/zFAql6X6hKf0rURogA5hN2A8jiPoW8LAs63YdeaCC8PtcF35tHjmOcWTweFs7bp
ZIvTmFPVHp4L46T7Q2toGOgm9s0wD/HEgvIAVCc+eBQkvnbP6bbfkpAmeH7cpTh/
ENsDPririsVHZHoAZXynn9R0Jf4rb/hQGdw42p8fODu6K/tiaQJ4UgnZpAbmD6sS
gPTbWZBra8L0YQ7/7a1WBcgjJ9Mv0r4btlucQ4yyPnW5HKqtmabyYn95bkhLLlGj
wsE5TYUXUq4GFCqrLXT6+uQxA1ir5eHWGtcW+DsvB1aOrilY8bNlqeIF/4M0HSSX
cDv5vaHeU4FWDgsIOs5cvxfD87GLmsEKWWBrt6xgiaWG2YEYCowfpEoxnSpZXinY
MXtGbG4XKz9GkhXHGgDp
=pq9a
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
