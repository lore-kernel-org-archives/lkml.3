Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbaJGTgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:36:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39227 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266AbaJGTf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:35:59 -0400
Date: Tue, 7 Oct 2014 20:35:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Ben Zhang <benzh@chromium.org>
Cc: alsa-devel@alsa-project.org, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>, linux-kernel@vger.kernel.org
Message-ID: <20141007193542.GG4609@sirena.org.uk>
References: <1412372246-10489-1-git-send-email-benzh@chromium.org>
 <1412372246-10489-3-git-send-email-benzh@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gA19+fZe+9B2YWyg"
Content-Disposition: inline
In-Reply-To: <1412372246-10489-3-git-send-email-benzh@chromium.org>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] ASoC: rt5677: Add jack detection support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gA19+fZe+9B2YWyg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 03, 2014 at 02:37:26PM -0700, Ben Zhang wrote:

> This patch adds support for jack detection using GPIOs on the codec.
> Plug detect signal and mic present signal can be routed from the physical
> audio jack to GPIOs on the codec. The codec is configured so that upon
> signal change, an IRQ(GPIO1) is fired. The codec interrupt handler reads

This then assumes that GPIO1 was configured as the IRQ - what happens if
it was connected with some other function on the board and some other
GPIO was assigned as IRQ?

> +	desc = devm_gpiod_get_index(&i2c->dev, "RT5677_GPIO",
> +			RT5677_GPIO_PLUG_DET);
> +	if (!IS_ERR(desc) && !gpiod_direction_input(desc))
> +		rt5677->gpio_plug_det = desc_to_gpio(desc)
> +				- rt5677->gpio_chip.base + 1;

I'm having trouble reading this, I think other reasonable users would
too.  It's not entirely clear to me what it's supposed to be doing or
why we are mixing the descriptor and number based GPIO APIs.

> +       /*
> +        * Loop to handle interrupts until the last i2c read shows no pending
> +        * irqs with a safeguard of 20 loops
> +        */
> +       for (i = 0; i < 20; i++) {

Eh?  Why are we doing this and why are we so sure that 20 is a good
value?

>  static int rt5677_probe(struct snd_soc_codec *codec)
>  {

> +       rt5677_setup_jack_detect(codec, rt5677);
>         return 0;

This sets up GPIO1 as an interrupt without verifying that we have an
interrupt assigned for it successfully and only in the ASoC level probe,
not in the chip level probe.  This means we might not have an interrupt
at all if the board configuration was buggy and means that we'll start
paying attention to the interrupt (which is requested in the i2c level
probe as it should be) without configuring the chip to be in the
appropriate state which means that it might start falsely flagging
interrupts.  I'd expect the configuration to be closer together, and
to have the CODEC set up ready to generate interrupts prior to starting
to listen to them.

--gA19+fZe+9B2YWyg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNECNAAoJECTWi3JdVIfQyFwH/RIacYxm0bJJbNcaS1zlc81K
UuWl+iSMDvMKkY5PLvXu+nDvpwtffjzKMvRG1VMhR5QdmnmKut2lAepeJieCECes
JbIFVE9O+/vXtT+iVomM4ZBvrpqfah8woQy0Kv0aaR+1qxG62C8Wojjufj3eyJPr
DNauwNU28VGmXTZY/aXa6/xBoH1N3hi27E6i1npMbBT/AYV8pBBHh9b33wuCMojy
f7k5zn8QnQeurW2U1Ue2zpjfumcM0YZFpUtEZoZ92Y7Mwf9OqJr+bQsIbqrcEJYW
v1jXAbrUBzAR+0JpQ4KtHK9VCeWjniWlK/bCvxSWo03/hKcHtm9qndjKU+kgZUY=
=9JXa
-----END PGP SIGNATURE-----

--gA19+fZe+9B2YWyg--
