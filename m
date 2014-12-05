Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaLEScl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:32:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49534 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaLESck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:32:40 -0500
Date: Fri, 5 Dec 2014 18:32:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20141205183213.GO11764@sirena.org.uk>
References: <1417194101-24938-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3snK74p7ddXn3Qrx"
Content-Disposition: inline
In-Reply-To: <1417194101-24938-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v7] ASoC: dapm: add code to configure dai link parameters
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3snK74p7ddXn3Qrx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2014 at 05:01:41PM +0000, Nikesh Oswal wrote:

This doesn't apply cleanly against current code, it appears to have been
generated against Linus' tree rather than latest ASoC.

> index 7ba7130..db60701 100644
> --- a/include/sound/soc.h
> +++ b/include/sound/soc.h
> @@ -942,6 +942,7 @@ struct snd_soc_dai_link {
>  	int be_id;	/* optional ID for machine driver BE identification */
> =20
>  	const struct snd_soc_pcm_stream *params;
> +	unsigned int num_params;
> =20
>  	unsigned int dai_fmt;           /* format to set on init */
> =20

Here we add num_params to the existing params; several existing drivers
use params but they've not been updated.

> +/* create new dapm dai link control */
> +static int dapm_new_dai_link(struct snd_soc_dapm_widget *w)
> +{
> +	int i, ret;
> +	struct snd_kcontrol *kcontrol;
> +	struct snd_soc_dapm_context *dapm =3D w->dapm;
> +	struct snd_card *card =3D dapm->card->snd_card;
> +
> +	/* skip control creation for links with 1 config */
> +	if (w->num_params =3D=3D 1)
> +		return 0;

Here we skip control creation if num_params is not 1.  This means we'll
try to create a control if num_params is zero which it will be for all
existing users.  This should actually work out fine due to the way loop
iteration works but this appears to be entirely by accident, it's not
obvious from the code.  Either num_params needs to become mandatory for
users and all existing users updated to provide it or the code should
explicitly cope with num_params being zero.

> @@ -3206,6 +3239,9 @@ static int snd_soc_dai_link_event(struct snd_soc_da=
pm_widget *w,
>  	source =3D source_p->source->priv;
>  	sink =3D sink_p->sink->priv;
> =20
> +	/* Select the configuration set by alsa control */
> +	config =3D &config[w->params_select];
> +

This is needlessly obscure.  We're first using config as shorthand for
the array of configuration options and then using it as the option we
selected.  It'd be better to change the initial dereference to also have
the array selection.

> +	private_value =3D
> +		(unsigned long) devm_kmemdup(card->dev,
> +		(void *)(kcontrol_dai_link[0].private_value),
> +		sizeof(struct soc_enum), GFP_KERNEL);

This doesn't resemble the Linux coding style very strongly; normally the
arguments of the function call would be indented with respect to the
line with the function name.

> +outfree_w:
> +	kfree(w);
> +outfree_kcontrol_news:
> +	kfree(template.kcontrol_news);
> +outfree_private_value:
> +	kfree((void *)private_value);
> +outfree_link_name:
> +	kfree(link_name);
> +outfree_w_param:
> +	for (count =3D 0 ; count < num_params; count++)
> +		kfree(w_param_text[count]);
> +	kfree(w_param_text);

You're paring devm_ allocations with kfree(), that's going to break.
Managed allocations need managed frees.

--3snK74p7ddXn3Qrx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgfosAAoJECTWi3JdVIfQ2bMH/i2DIkq/AmSi58ZStbiOw2Kb
t89wQSGumoV+M481iOluvSQB/wSGeDu+Q8+c/TgmNNnTWM0a5jXAx1jSTQZ7yuDQ
9AoieH94F9HSq+PIE4TCqM3H6dJLZNwIZ3VM7vHqRPZf7z1yykOAHjHPhMGQdrj2
JOwkwNc8OrF8wAFq2/l54FSSXr2EKcsuHdZLjFWr7HG5FImGiuuiAZ8J824iDUdi
bs6hkzfipVXbp6eM/UgWXNbhZMYnCy6iaPCy3wefxwE6QKuOTESI8XHOuExfYNhO
iNlBHhWXpeZquDK00Of9+SpKX0A/7CHRSjj8xNMkiV4sIa8XuBAHMFfWMvMNahc=
=y61P
-----END PGP SIGNATURE-----

--3snK74p7ddXn3Qrx--
