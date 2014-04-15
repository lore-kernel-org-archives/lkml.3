Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaDOMfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:35:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33939 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaDOMfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:35:18 -0400
Date: Tue, 15 Apr 2014 13:34:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140415123449.GC12304@sirena.org.uk>
References: <1396733753-9820-1-git-send-email-sre@kernel.org>
 <1396733753-9820-4-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ro1PRY3Rtw8g7IwX"
Content-Disposition: inline
In-Reply-To: <1396733753-9820-4-git-send-email-sre@kernel.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] ASoC: RX-51: Add DT support to sound driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ro1PRY3Rtw8g7IwX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 05, 2014 at 11:35:51PM +0200, Sebastian Reichel wrote:
> This patch adds device tree support to the Nokia N900 audio driver.
> It also removes GPIO defines and gets them from platform data /
> device tree, since some GPIO numbers may be different with DT boot.

This binding looks mostly fine, a few code things though which may
influence the binding.  The main thing is that you're doing a lot of
changes here which aren't really related to adding the binding which
aren't mentioned and make it harder to review - as well as making the
change larger one of the things that's done in review is to check that
the change did what it was described as doing.  At least some of the
time there isn't even any code overlap.

> @@ -290,6 +286,9 @@ static const struct snd_kcontrol_new aic34_rx51_contr=
olsb[] =3D {
>  static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
>  {
>  	struct snd_soc_codec *codec =3D rtd->codec;
> +	struct snd_soc_card *card =3D codec->card;
> +	struct rx51_audio_pdata *pdata =3D snd_soc_card_get_drvdata(card);
> +
>  	struct snd_soc_dapm_context *dapm =3D &codec->dapm;
>  	int err;
> =20

Random blank line added here.

> @@ -301,8 +300,10 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtim=
e *rtd)
>  	/* Add RX-51 specific controls */
>  	err =3D snd_soc_add_card_controls(rtd->card, aic34_rx51_controls,
>  				   ARRAY_SIZE(aic34_rx51_controls));
> -	if (err < 0)
> +	if (err < 0) {
> +		dev_err(card->dev, "Failed to add RX-51 specific controls\n");
>  		return err;
> +	}
> =20
>  	/* Add RX-51 specific widgets */
>  	snd_soc_dapm_new_controls(dapm, aic34_dapm_widgets,

This is nothing to do with DT support, separate patch please.  There's
quite a few other things like this.  You're also not printing any error
codes in the messages.

> @@ -312,25 +313,39 @@ static int rx51_aic34_init(struct snd_soc_pcm_runti=
me *rtd)
>  	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
> =20
>  	err =3D tpa6130a2_add_controls(codec);
> -	if (err < 0)
> +	if (err < 0) {
> +		dev_err(card->dev, "Failed to add TPA6130A2 controls\n");
>  		return err;
> +	}

If this is converted to DT and you've added aux CODEC support as part of
that then why are we still manually adding the controls for the
headphone amp?  I would have expected this to be registered as an aux
CODEC.  This seems likely to feed through into the binding for
referencing the components.

> +	err =3D omap_mcbsp_st_add_controls(rtd, 2);
> +	if (err < 0) {
> +		dev_err(card->dev, "Failed to add MCBSP controls\n");
>  		return err;
> +	}

Refactoring this as a separate patch would also help.

> -	err =3D gpio_request_one(RX51_ECI_SW_GPIO,
> +	if (err) {
> +		dev_err(card->dev, "could not setup tvout_sel\n");
> +		goto error;
> +	}
> +	err =3D devm_gpio_request_one(card->dev, pdata->eci_sw_gpio,
>  			       GPIOF_DIR_OUT | GPIOF_INIT_HIGH, "eci_sw");

Again, moving this refactoring into a separate patch will help a lot
with review.

--Ro1PRY3Rtw8g7IwX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTSdmAAoJELSic+t+oim9ygMP/jeBngPHxkTdywK18SH8GwWq
N4SG2enx7HaSyHL0FG+Wftk9/FIadSm4uPIQeer+fYg+zx4CzEFeY/YSbgAz1/QL
7e5Dnl8Tnf8uEU75/PreQ8N5tM7oMlta5MhT3sFzm+6Yub+PZhPxN8Ie0eKXT0wE
9fD342eKTNVjGoDUlH3hmQ33x7rtun2v65RO0qvQlCKZ+TPKKx9Cylq6e/OVSd5H
K8Qc2WbhHzbC6bjBqgElgWg0L7QPDZbOzKb0qSvDFmEimcjf5GHysl8zHDp6UKXx
CuAogz1qMonmNgONcAxjvW+ie812dXVn73+vB+TNcKmPRx6d30AaFVzR4fhdvy5r
n/8RNkkrbKCKfWHvqbmBmKkDJktBk6u6nZTZSDbNNqXOQlU8En8wFjro6eJD0Oxr
4xk+3L1Muvd8S/g/QlycFiP0kCYIqOLyaUpaeBAOS7j/+Aj5lgEkB81HFIdGHgxj
9IMFHhFqNPW8kpD4QwYmUJzw1uSlgmmrBBZAB/ImY80jIU+GvDLBc6WlhK0oG5CZ
a/w1wNS8NGW64zRBMP711OEn/tugv5Vm6jUexSPH1SL/qvC/TyLO1dniJVI8tkjP
lg8m41iUftCnrKxL3UNW5qHReo7iAJXEnpBDpFZFfCBQZnG9aI6NDC8SFhnTd8iF
k11dAM8TXoS9+rIQ63N/
=hwAL
-----END PGP SIGNATURE-----

--Ro1PRY3Rtw8g7IwX--
