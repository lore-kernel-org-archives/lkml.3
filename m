Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaFRSoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:44:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47710 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaFRSov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:44:51 -0400
Date: Wed, 18 Jun 2014 19:44:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Dan Murphy <dmurphy@ti.com>
Cc: linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140618184440.GK5099@sirena.org.uk>
References: <1403113547-15120-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qWVgpdk27f0K4V9B"
Content-Disposition: inline
In-Reply-To: <1403113547-15120-1-git-send-email-dmurphy@ti.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] ASoC: tas2552: Support TI TAS2552 Amplifier
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qWVgpdk27f0K4V9B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 18, 2014 at 12:45:46PM -0500, Dan Murphy wrote:

> +static int tas2552_i2c_read(struct tas2552_data *tas_data, int reg)
> +{
> +	int val;
> +
> +	if (WARN_ON(!tas_data->tas2552_client))
> +		return -EINVAL;
> +
> +	/* If powered off, return the cached value */
> +	mutex_lock(&tas_data->mutex);
> +	if (tas_data->power_state) {
> +		val = i2c_smbus_read_byte_data(tas_data->tas2552_client, reg);

Don't open code your I/O, use regmap like any other CODEC driver.  This
will remove a very large proportion of the code in the driver which
replicates features of the regmap framework.

> +static int tas2552_startup(struct snd_pcm_substream *substream,
> +			   struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
> +
> +	tas2552_sw_shutdown(tas2552, 1);
> +	tas2552_power(tas2552, 1);
> +	/* Turn on Class D amplifier */
> +	tas2552_i2c_write(tas2552, TAS2552_CFG_2, 0x80);
> +	tas2552_sw_shutdown(tas2552, 0);

I'd expect this to be done using DAPM.

> +static const struct regmap_config tas2552_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +
> +	.max_register = TAS2552_MAX_REG,
> +	.reg_defaults = NULL,
> +	.num_reg_defaults = 0,

No need to set things to zero or NULL in static variables, that's the
default.

> +	dev = &client->dev;
> +	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
> +	if (data == NULL) {
> +		dev_err(dev, "Can not allocate memory\n");

No need to print an error, OOM messages are already quite noisy.

--qWVgpdk27f0K4V9B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTod4VAAoJELSic+t+oim9cSMP/2PTa8SqAQLUTJ7p6oHwmeCq
8dkPuPEp+nFY20Bu0xb2kR88PvAFMNsq+878r9cFNu5EtZeVh+tKlEW1Y0PP7KWu
rRCYWMdZ1fYM2kYtryY9ccC9LI2yMuLxY1yrIfdzN81noqmaAs7LG6k4DzY6sBJU
3DHllmmnDwGYvh35V4xwn+Ti0s+TTPZRlePTGP21sVtAs1BeNa80kzu2tCgzbCNe
OXOg5R4NGSdyspmD0CxV1HB1+IcFaJa5U3o64ZYVUy0MBGbwK5cm+F8ekqqyNgte
uo9o+PmSWhnx0qF2z2ktN3wEDunYaAJx8WuL6fgIJvXrVGTwgVeLYlPFBzZqDRKB
jTfwqVrsE8tpDed+2iIPIPFAiDH8yD9RnkTdTDeTYSGJ+ZwUopT4y5oXnHesJw61
L8rplvzYQ7+hll6LxWFkmwaIwbjouNxRWFedZh6iFd3Xh5TyRB3+U/7RSg7Fke9c
FFavxw8u3YPUnteX+AjCYaP7x4AxqC/LyH2LofKVJ7oMEz9gEPbHcm0tLDoa+uje
2Itbynylju7V7Ot5cSk9byAEUYvgurG4Z9lgh72xlfO9/y1JF6WL1v4O5a0hHQ3B
SwsBrvX/uBODQ0uNMt1Jf/PvzTVo8nPHWQ2Mg2y6Eb0xL9OVIIXnB6T3H9oyNvWB
BJjed8n/oBoFtWhzzi40
=b66X
-----END PGP SIGNATURE-----

--qWVgpdk27f0K4V9B--
