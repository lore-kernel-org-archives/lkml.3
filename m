Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaKDTmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:42:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37830 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaKDTmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:42:13 -0500
Date: Tue, 4 Nov 2014 19:40:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20141104194049.GU3815@sirena.org.uk>
References: <1410513064-2916-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SqO8Hf1xXlNBrDgg"
Content-Disposition: inline
In-Reply-To: <1410513064-2916-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6] ASoC: dapm: add code to configure dai link parameters
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SqO8Hf1xXlNBrDgg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 12, 2014 at 10:11:04AM +0100, Nikesh Oswal wrote:
> dai-link params for codec-codec links were fixed. The fixed
> link between codec and another chip which may be another codec,
> baseband, bluetooth codec etc may require run time configuaration
> changes. This change provides an optional alsa control to select
> one of the params from a list of params.

The shape of this looks OK, though there are some issues below.  I
intend to test this before applying but couldn't do that since it
doesn't apply against current code.

> +	/* Select the configuration set by alsa control */
> +	config += w->params_select;
> +

Do an array lookup, code legibility is important.

> +static int snd_soc_dapm_dai_link_put(struct snd_kcontrol *kcontrol,
> +			  struct snd_ctl_elem_value *ucontrol)
> +{
> +	struct snd_soc_dapm_widget *w = snd_kcontrol_chip(kcontrol);
> +
> +	if (ucontrol->value.integer.value[0] == w->params_select)
> +		return 0;
> +
> +	if (ucontrol->value.integer.value[0] >= w->num_params)
> +		return -EINVAL;
> +
> +	w->params_select = ucontrol->value.integer.value[0];
> +
> +	return 0;
> +}

This will just silently not immediately do anything if an attempt is
made to change the parameters while the link is active.  There needs to
at least be a log message, and probably it's better to return -EBUSY
as well otherwise userspace might be going on reconfiguring things
assuming that this succeeded.

It'd be even better to actually reconfigure the link but that's a more
involved operation which might need us to power things down and can be
punted for now.

>  	len = strlen(source->name) + strlen(sink->name) + 2;
>  	link_name = devm_kzalloc(card->dev, len, GFP_KERNEL);
> -	if (!link_name)
> -		return -ENOMEM;
> +	if (!link_name) {
> +		ret = -ENOMEM;
> +		goto  outfree_w_param;
> +	}

Random extra space here and in some other gotos.

> +	for (count = 0 ; count < num_params; count++) {
> +		if (!config->stream_name)
> +			dev_warn(card->dapm.dev,
> +				"ASoC: anonymous config %d for dai link %s\n",
> +				count, link_name);
> +		w_param_text[count] = kmemdup((void *)(config->stream_name),
> +			strlen(config->stream_name) + 1, GFP_KERNEL);

Why are you casting to void * here?  This looks like it's open coding
kstrdup() and we're mixing devm_ and non-devm_ allocations in this
function.

This is also dereferencing stream_name immediately after finding that
it's NULL which isn't good.

> +	template.num_kcontrols = 1;
> +	private_value =
> +	(unsigned long) kmemdup((void *)(kcontrol_dai_link[0].private_value),
> +		sizeof(struct soc_enum), GFP_KERNEL);
> +	if (!private_value) {
> +		dev_err(card->dev, "ASoC: Failed to create control for %s widget\n",

So, we need to kmemdup() this thing that we just allocated?  If this is
needed it should be clear to the reader why we're doing this, especially
given all the funky casts.

--SqO8Hf1xXlNBrDgg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWSvAAAoJECTWi3JdVIfQfK0H/AiMmKFOU36QQD+jbhWnvCPA
LjJA9FziSzOuuqniOWCfMNq34rXKM4a//nY85S7V9HAk4S05EYDgBUttDTwXZu2W
6TBqUf/zdmfb1pin9xgAm6iehWscjBJCvCZoHGmsaiFJ75hhtQP1j/r1UYghZBxx
L7ekwDlfB0N61WmH1R6dKguZmzaz3wiSvg6vsGZzIkEuUqFa39lHw8dkMw+oacBG
ceX/RXpdGyK/pI4/lrrvG3c3X/zxdRvmcr5yjrcuUolZLexpbkJ8RhIWE7CywoHr
P5+2qjfk22WYFlkmQDrk38tGr1lJiDW3IMLZtSBBbM9P6CBqGpt3gaXyCHikQvg=
=DA7/
-----END PGP SIGNATURE-----

--SqO8Hf1xXlNBrDgg--
