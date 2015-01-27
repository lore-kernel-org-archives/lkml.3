Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbbA0OLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:11:31 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:47994 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbA0OLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:11:12 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH] ASoC: rx51: do not fail if could not get jack detection gpio
Date: Tue, 27 Jan 2015 15:11:08 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1422305507-10533-1-git-send-email-pali.rohar@gmail.com> <20150127133227.GA25306@amd> <54C79597.40105@ti.com>
In-Reply-To: <54C79597.40105@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart45888121.xkTpboom37";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501271511.08933@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart45888121.xkTpboom37
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 27 January 2015 14:41:43 Peter Ujfalusi wrote:
> On 01/27/2015 03:32 PM, Pavel Machek wrote:
> > On Tue 2015-01-27 15:27:58, Peter Ujfalusi wrote:
> >> Hi,
> >>=20
> >> On 01/26/2015 10:51 PM, Pali Roh=C3=A1r wrote:
> >>> qemu does not emulate it
> >>=20
> >> Not sure about this... How does qemu emulate tlv320aic3106,
> >> tpa6130a2a, McBSP, sDMA for audio to work? What about the
> >> other three GPIOs in this machine driver?
> >>=20

No idea, but with my patch rx51-audio loads without any problem.

> >> The "nokia,n900-audio" compatible mandates that the
> >> jack-detection GPIO must be provided
> >> (Documentation/devicetree/bindings/sound/nokia,rx51.txt)
> >> since it means that the driver is running on the Nokia
> >> n900 HW.
> >=20
> > Fix the documentation, then :-).
>=20
> You mean document a workaround for qemu, right? AFAIK the
> documentation is fine ;)
>=20
> > [Actually, GPIO is provided, it just can't be requested,
> > AFAICT.]
>=20
> So what about the other GPIOs in the machine driver? Why is
> this jack-detection GPIO is special for qemu?
>=20

Qemu does not detect it and cause rx51-audio driver to fail.

> > It is quite important to keep qemu working, really.
> > Debugging early boot on hardware is very hard, for example.
>=20
> I understand, but looking at the history of the driver, if it
> fails now with the jack-detection GPIO, it should have been
> failing in the past as well. What triggered this sudden qemu
> does not like jack-detection GPIO? Before the
> devm_gpiod_get() conversion the driver should have failed in
> snd_soc_jack_add_gpios() phase.
>=20

With 3.12 kernel rx51-audio driver loads without any problem. So=20
there is some regression. Here is dmesg log from 3.12 kernel:

[    1.123779] rx51-audio rx51-audio:  tlv320aic3x-hifi <-> omap-
mcbsp.2 mapping ok
[    1.130737] tlv320aic3x-codec 2-0019: ASoC: mux b Right Line1L=20
Mux has no paths
[    1.131347] tlv320aic3x-codec 2-0019: ASoC: mux b Left Line1R=20
Mux has no paths
[    1.133697] tlv320aic3x-codec 2-0018: ASoC: mux Right Line1L=20
Mux has no paths
[    1.134307] tlv320aic3x-codec 2-0018: ASoC: mux Left Line1R=20
Mux has no paths
[    1.137451] input: RX-51 AV Jack as /devices/platform/rx51-
audio/sound/card0/input2

I will try to investigate where is problem...

> > And yes, some day we may need different dts for n900-qemu
> > (vs. n900-hw), but lets not do it just yet.
> >=20
> > 							Pavel
> >>>=20
> >>> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >>> ---
> >>>=20
> >>>  sound/soc/omap/rx51.c |   45
> >>>  +++++++++++++++++++++++++-------------------- 1 file
> >>>  changed, 25 insertions(+), 20 deletions(-)
> >>>=20
> >>> diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
> >>> index 04896d6..a689021 100644
> >>> --- a/sound/soc/omap/rx51.c
> >>> +++ b/sound/soc/omap/rx51.c
> >>> @@ -310,25 +310,27 @@ static int rx51_aic34_init(struct
> >>> snd_soc_pcm_runtime *rtd)
> >>>=20
> >>>  		return err;
> >>>  =09
> >>>  	}
> >>>=20
> >>> -	/* AV jack detection */
> >>> -	err =3D snd_soc_jack_new(codec, "AV Jack",
> >>> -			       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
> >>> -			       &rx51_av_jack);
> >>> -	if (err) {
> >>> -		dev_err(card->dev, "Failed to add AV Jack\n");
> >>> -		return err;
> >>> -	}
> >>> +	if (!IS_ERR(pdata->jack_detection_gpio)) {
> >>> +		/* AV jack detection */
> >>> +		err =3D snd_soc_jack_new(codec, "AV Jack",
> >>> +				       SND_JACK_HEADSET |=20
SND_JACK_VIDEOOUT,
> >>> +				       &rx51_av_jack);
> >>> +		if (err) {
> >>> +			dev_err(card->dev, "Failed to add AV Jack\n");
> >>> +			return err;
> >>> +		}
> >>>=20
> >>> -	/* prepare gpio for snd_soc_jack_add_gpios */
> >>> -	rx51_av_jack_gpios[0].gpio =3D
> >>> desc_to_gpio(pdata->jack_detection_gpio);
> >>> -	devm_gpiod_put(card->dev, pdata->jack_detection_gpio);
> >>> +		/* prepare gpio for snd_soc_jack_add_gpios */
> >>> +		rx51_av_jack_gpios[0].gpio =3D
> >>> desc_to_gpio(pdata->jack_detection_gpio);
> >>> +		devm_gpiod_put(card->dev, pdata-
>jack_detection_gpio);
> >>>=20
> >>> -	err =3D snd_soc_jack_add_gpios(&rx51_av_jack,
> >>> -				     ARRAY_SIZE(rx51_av_jack_gpios),
> >>> -				     rx51_av_jack_gpios);
> >>> -	if (err) {
> >>> -		dev_err(card->dev, "Failed to add GPIOs\n");
> >>> -		return err;
> >>> +		err =3D snd_soc_jack_add_gpios(&rx51_av_jack,
> >>> +					     ARRAY_SIZE(rx51_av_jack_gpios),
> >>> +					     rx51_av_jack_gpios);
> >>> +		if (err) {
> >>> +			dev_err(card->dev, "Failed to add GPIOs\n");
> >>> +			return err;
> >>> +		}
> >>>=20
> >>>  	}
> >>>  =09
> >>>  	return err;
> >>>=20
> >>> @@ -336,8 +338,11 @@ static int rx51_aic34_init(struct
> >>> snd_soc_pcm_runtime *rtd)
> >>>=20
> >>>  static int rx51_card_remove(struct snd_soc_card *card)
> >>>  {
> >>>=20
> >>> -	snd_soc_jack_free_gpios(&rx51_av_jack,
> >>> ARRAY_SIZE(rx51_av_jack_gpios), -			=09
rx51_av_jack_gpios);
> >>> +	struct rx51_audio_pdata *pdata =3D
> >>> snd_soc_card_get_drvdata(card); +
> >>> +	if (!IS_ERR(pdata->jack_detection_gpio))
> >>> +		snd_soc_jack_free_gpios(&rx51_av_jack,
> >>> ARRAY_SIZE(rx51_av_jack_gpios),
> >>> +					rx51_av_jack_gpios);
> >>>=20
> >>>  	return 0;
> >>> =20
> >>>  }
> >>>=20
> >>> @@ -470,8 +475,8 @@ static int rx51_soc_probe(struct
> >>> platform_device *pdev)
> >>>=20
> >>>  	pdata->jack_detection_gpio =3D devm_gpiod_get(card->dev,
> >>>  =09
> >>>  						    "jack-detection");
> >>>  =09
> >>>  	if (IS_ERR(pdata->jack_detection_gpio)) {
> >>>=20
> >>> +		/* Do not fail, qemu does not emulate jack=20
detection
> >>> gpio */
> >>>=20
> >>>  		dev_err(card->dev, "could not get jack detection
> >>>  		gpio\n");
> >>>=20
> >>> -		return PTR_ERR(pdata->jack_detection_gpio);
> >>>=20
> >>>  	}
> >>>  =09
> >>>  	pdata->eci_sw_gpio =3D devm_gpiod_get(card->dev,
> >>>  	"eci-switch");

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart45888121.xkTpboom37
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTHnHwACgkQi/DJPQPkQ1JtCwCgk1/FFqcGzgc3yP2ggkVtP7Cw
PX4AoJ7rkEmZjxO8SODcoculYO46Ih+1
=aJwa
-----END PGP SIGNATURE-----

--nextPart45888121.xkTpboom37--
