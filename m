Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaIMPjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 11:39:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39135 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaIMPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 11:39:47 -0400
Date: Fri, 12 Sep 2014 14:52:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, heiko@sntech.de,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Message-ID: <20140912135247.GU7960@sirena.org.uk>
References: <1410506806-15327-1-git-send-email-jay.xu@rock-chips.com>
 <1410507588-15719-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qgEfXXHyyarqcYJd"
Content-Disposition: inline
In-Reply-To: <1410507588-15719-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: rockchip-max98090: add driver for rockchip board
 using a max98090
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qgEfXXHyyarqcYJd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 12, 2014 at 03:39:48PM +0800, Jianqun wrote:

> +#define RK_PLAT_CLK_12M      12000000

I'm not sure a define is adding anything here...  it's just a define
saying 12MHz that has the value 12MHz.

> +	struct snd_soc_dai *codec_dai = rtd->codec_dai;
> +
> +/* Set max98090 as master, i2s clock output 12MHz for max98090 */
> +	ret = snd_soc_dai_set_sysclk(cpu_dai, 0,

Coding style, comments aren't aligned with the code.

> +	ret = snd_soc_add_card_controls(card, rk_mc_controls,
> +					ARRAY_SIZE(rk_mc_controls));
> +	if (ret) {
> +		pr_err("unable to add card controls\n");
> +		return ret;
> +	}

Use card->controls.

> +	snd_soc_dapm_enable_pin(dapm, "Headset Mic");
> +	snd_soc_dapm_enable_pin(dapm, "Headphone");
> +	snd_soc_dapm_enable_pin(dapm, "Ext Spk");
> +	snd_soc_dapm_enable_pin(dapm, "Int Mic");
> +
> +	snd_soc_dapm_sync(dapm);

All pins are enabled by default and sync doesn't do anything during
init.

> +#ifdef CONFIG_PM_SLEEP
> +static int snd_rk_prepare(struct device *dev)
> +{
> +	struct snd_soc_card *card = dev_get_drvdata(dev);
> +	struct rk_mc_private *drv = snd_soc_card_get_drvdata(card);
> +
> +	snd_soc_jack_free_gpios(&drv->hp_jack, 1, &hp_jack_gpio);
> +	snd_soc_jack_free_gpios(&drv->mic_jack, 1, &mic_jack_gpio);
> +
> +	return snd_soc_suspend(dev);
> +}

Why are you freeing the GPIOs over suspend, that doesn't seem good?

> +	hp_jack_gpio.gpio = of_get_named_gpio(np, "rockchip,hp-det-gpios", 0);
> +	if (hp_jack_gpio.gpio == -EPROBE_DEFER)
> +		return -EPROBE_DEFER;
> +
> +	mic_jack_gpio.gpio = of_get_named_gpio(np, "rockchip,mic-det-gpios", 0);
> +	if (mic_jack_gpio.gpio == -EPROBE_DEFER)
> +		return -EPROBE_DEFER;

This ignores errors other than probe deferral but the init code assumed
that these would've succeeded.  Either the init code should handle
failure or all errors should be treated as fatal.

> +	platform_set_drvdata(pdev, &card);
> +
> +	ret = snd_soc_of_parse_card_name(card, "rockchip,model");
> +	if (ret)
> +		return ret;

These need to happen before we register the card since they could be
used as soon as we probe.

> +	snd_soc_card_set_drvdata(soc_card, NULL);

No need to clear driver data, the core will do it anyway and anything
relying on pre-set driver data is broken.

--qgEfXXHyyarqcYJd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEvquAAoJECTWi3JdVIfQ4rAH/Rw1cnCoG2a7KDyvfQq54G4p
cTfnQLNGLqDzp5FW0HjTL7ekZpX64wZa93LUp0utiPBn8kG5Gvq1sUL3i3ok6qwV
vrkF54cQjc4ZyTujuhzXnvxpAA+Ujr797wPyiJhtykxCraBSMTK9Q+zKjhEeExUl
N2iqeUfG3vf/LUesHLazL7+91h29a+RPZ8UVpyzUwYvjcOTaTl9FSjI8nlV2AxVs
+HcOmmyloGJK7ULrWP1mut+lGmgYo5vgfzuR7O26tKmtNhh28rMPKfUI05ocnn+R
alaNw1NrzR6kMdhwSkxvYlXYe1X0Z1ge8vugcaoppaCwVSCGIhaZlPzgNWDiGhY=
=dOK4
-----END PGP SIGNATURE-----

--qgEfXXHyyarqcYJd--
