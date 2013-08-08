Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965169Ab3HHLCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:02:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47056 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab3HHLCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:02:17 -0400
Date: Thu, 8 Aug 2013 12:01:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: khali@linux-fr.org, linux@roeck-us.net, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        MLongnecker@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130808110136.GA6427@sirena.org.uk>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <1375944991-29182-2-git-send-email-wni@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uT8OcDz013Sgpw/5"
Content-Disposition: inline
In-Reply-To: <1375944991-29182-2-git-send-email-wni@nvidia.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uT8OcDz013Sgpw/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 08, 2013 at 02:56:29PM +0800, Wei Ni wrote:

> +	mutex_lock(&data->update_lock);
> +
> +	if (is_enable)
> +		ret = regulator_enable(data->lm90_reg);
> +	else
> +		ret = regulator_disable(data->lm90_reg);
> +
> +	if (ret < 0)
> +		dev_err(&client->dev,
> +			"Error in %s rail vdd, error %d\n",
> +			(is_enable) ? "enabling" : "disabling", ret);
> +	else
> +		dev_info(&client->dev, "success in %s rail vdd\n",
> +			 (is_enable) ? "enabling" : "disabling");
> +
> +	mutex_unlock(&data->update_lock);

Two things here.  One is that it's not clear what this lokc is
protecting since the only thing in the locked region is the regulator
operation and that is thread safe.  The other thing is that I'm not
seeing anthing that ensures that enables and disables are matched -
regulators are reference counted so two enables need two disables.

> +	data->lm90_reg = regulator_get(&client->dev, "vdd");
> +	if (IS_ERR_OR_NULL(data->lm90_reg)) {

NULL is a valid regulator, use IS_ERR().

> +		if (PTR_ERR(data->lm90_reg) == -ENODEV)
> +			dev_info(&client->dev,
> +				 "No regulator found for vdd. Assuming vdd is always powered.");
> +		else
> +			dev_warn(&client->dev,
> +				 "Error [%ld] in getting the regulator handle for vdd.\n",
> +				 PTR_ERR(data->lm90_reg));

You shouldn't just be ignoring errors here, though there are deployment
difficulties with making sure a stub regulator is provided.  These
should be getting easier after the next merge window, the stubs will be
being tweaked slightly to have an "assume it's there" option even when
regulators are used.  Especially in cases with device tree you should be
paying attention to -EPROBE_DEFER, that will accurately reflect if a
regulator is present but not loaded yet.

That said if you *are* going to do this you should request the
regulator using devm_regulator_get_optional(), this is intended to
support things that don't need regulators (though that's not the case
here).

--uT8OcDz013Sgpw/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSA3qNAAoJELSic+t+oim9glQP/0z1b5xAw7AUj74owA9E/qHC
NSXv4/bK/EnkWOtBznNOTaW/HttDJWNkaUCQokY8ekRKreZw+GrvAUUnkh3jFMtN
079QSAhr8JiNdDdsGdj/uaOHnVDbfmFCqmg0qX+mYWzEJIGn9Ew9gjkDx3bv/jwU
SFQGHJ0BRkHyCUq/xwrODpKVwKzR512QzGazKzooMhKqxFpTQauHQvGQJlmGm512
DWZ9WbZKQfI47rx7McuwkGc4PFYx3uwAr2287/D/2lJT0r7CZBFahb0MjmoioRr3
j/zVxczE7WhiKWQDD5YQ4uphsMPYjYYruaouYrs0vtfInRRNuZ5hqIiRsUznhjAL
EQuunC1hG0DXJErFGVdjc3seGVTjQtXsJq+aC7uCghSW1T4SRoHx71BAL8NQzgpE
9Dz67JG/LJt4IxUdCqW8/zwMlb23gyXcKNFF+NRDQZ9lF9bi6n4gP5jMcEH2AfWE
6OS5VfV5kNuQFHUj3FN9DP9Vv5C5Tlx70HjWuUEmUFgtoK5BdglRvWhtY+u7Jo2P
lJcIo7krQs6/2ihKAKiEShIU5biIiE6sx7fOWZw0qVOV6EOIejL9urN2FCBfNAll
jAO44psuQDJB/b/yWlQG1cqynzh1jOOGDhaAREDFCZVZhlFnKdNzo7fgujpxeSCI
HQkHyyn5mBW0nAnWd0g2
=q1TX
-----END PGP SIGNATURE-----

--uT8OcDz013Sgpw/5--
