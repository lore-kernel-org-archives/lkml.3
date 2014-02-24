Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaBXLad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:30:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50930 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBXLab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:30:31 -0500
Date: Mon, 24 Feb 2014 20:30:11 +0900
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: brian.austin@cirrus.com, Paul.Handrigan@cirrus.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        lgirdwood@gmail.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20140224113011.GE25940@sirena.org.uk>
References: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="myda8z5PGMklj5Rc"
Content-Disposition: inline
In-Reply-To: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: cs42888: Add codec driver support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--myda8z5PGMklj5Rc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2014 at 02:55:29PM +0800, Nicolin Chen wrote:
> This patch adds support for the Cirrus Logic CS42888 Audio CODEC that
> has four 24-bit A/D and eight 24-bit D/A converters.

Looks generally good, some fairly small nits below.

> [ CS42888 supports both I2C and SPI control ports. As initial patch,
>   this patch only adds the support for I2C. ]

>  5 files changed, 795 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/sound/cs42888.txt
>  create mode 100644 sound/soc/codecs/cs42888.c
>  create mode 100644 sound/soc/codecs/cs42888.h

Given that we're starting to split out separate bus drivers for the I2C
and SPI CODECs (look at the recent submissions from Lars-Peter) it'd be
good to start this off with a separate bus driver for I2C even if the
SPI one is still to be done - that way the Kconfig stuff for machine
drivers is all in place and doesn't need updating.

> +  - clocks : phandle to the clock source for MCLK
> +
> +  - clock-names : must contain "mclk".

These should really be lists though there's only one documented element
so it's purely a documentation update.

> +	/* Disable auto-mute */
> +	regmap_update_bits(cs42888->regmap, CS42888_TXCTL,
> +			   CS42888_TXCTL_AMUTE | CS42888_TXCTL_DAC_SZC_MASK,
> +			   CS42888_TXCTL_DAC_SZC_SR);

Does this interfere with the manual mute controls or is it a separate
thing?  If it plays nicely with the manual controls it's probably better
to leave it enabled since it improves performance in some benchmarks
(that's why hardware tends to have the feature).

> +	/*
> +	 * We haven't marked the chip revision as volatile due to
> +	 * sharing a register with the right input volume; explicitly
> +	 * bypass the cache to read it.
> +	 */
> +	regcache_cache_bypass(cs42888->regmap, true);

The other option here is to just not provide a default so that the first
time it's read it goes to hardware.  It doesn't make much difference
either way though.

> +static int cs42888_i2c_remove(struct i2c_client *i2c_client)
> +{
> +	snd_soc_unregister_codec(&i2c_client->dev);
> +	return 0;
> +}

The driver ought to disable runtime PM, the clock and the regulators here.

> +	/*
> +	 * In case the device was put to hard reset during sleep,
> +	 * we need to wait 500ns here before any I2C communication
> +	 */
> +	mdelay(5);

Do we need 500ns or 5ms? =20

> +	regcache_sync(cs42888->regmap);

Should really check the return value here.

> +	if (!IS_ERR(cs42888->clk))
> +		clk_disable_unprepare(cs42888->clk);

Does the device work without MCLK?

--myda8z5PGMklj5Rc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCy06AAoJELSic+t+oim9NacQAJVraT2HLnDfUAFCMZHgAWvo
oe2rWCWlkqDqn/tKbsTHCDv3vEJ1HOw8rDFy7CvnS8jrK/TwzwLAi6VrctROFnvw
coBs3ZHIWw0mFuu6qlNqVqL9ZKNeemESyKdkisJ3FDxaWt/W1nPYWdn8q0y4+6dW
7TwnXAfWG9r2KNSPp7u7CeRxc+MLe5Z8NyKUPOfz0RfI153E8MHt7lqI1cgM8S2e
UPM5xb0Tuvdv6bhcHd8sLwOkdVeSvyFdC1aGJfRWC6wPA6o8rdjsYpfKhBHATEwk
ot1jn7vSTlLJlvTEkkoaWWDy001Xv8GI1CQkLJkFIF+6jbsl+CUoL+xq8bi9+yui
T7sYceGbY6H5CYGg2OdFPM462FcYLN4PkUR4KfqjKIqCsT7dVuWUBqHKKMkiQQeg
mf0O40K/DDcGVPzOe+NmeYCj5JS5jbPAtD3pxiYpqFfmheTsaHoiaY/sVHGuK87p
liYFuk5Je13+krdYyfPg6jAKbqw03m3RO4hcsY4ioegP50fhzkMSU1FGLpmSQOW7
oOrwNAyAJs4Qm/vSpBJT7RacuOsW0L7hlFO71Q4wPa2JAL17KSQ5NhtAWryc9G+v
bZzPwzBm/AgBS36r2lkw/TXeZqtN761eK7P+rctPIpvbH2WOYuXOEr4dWd4I9F7+
LdQ4GWixLlzjIzRoZ0Xp
=VON1
-----END PGP SIGNATURE-----

--myda8z5PGMklj5Rc--
