Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab3KFO0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:26:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45703 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3KFO0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:26:03 -0500
Date: Wed, 6 Nov 2013 15:25:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [RFC 3/4] ASoC: Allow Aux Codecs to be specified using DT
Message-ID: <20131106142559.GC15551@amd.pavel.ucw.cz>
References: <1382909086-10493-1-git-send-email-sre@debian.org>
 <1382909086-10493-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382909086-10493-4-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch adds support for specifying auxiliary codecs and
> codec configuration via device tree phandles.
> 
> This change adds new fields to snd_soc_aux_dev and snd_soc_codec_conf
> and adds support for the changes to SoC core methods.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  include/sound/soc.h  | 13 +++++++++-
>  sound/soc/soc-core.c | 68 ++++++++++++++++++++++++++++++++++++----------------
>  2 files changed, 59 insertions(+), 22 deletions(-)

> @@ -1527,15 +1529,23 @@ static void soc_unregister_ac97_dai_link(struct snd_soc_codec *codec)
>  static int soc_check_aux_dev(struct snd_soc_card *card, int num)
>  {
>  	struct snd_soc_aux_dev *aux_dev = &card->aux_dev[num];
> +	const char *codecname = aux_dev->codec_name;
>  	struct snd_soc_codec *codec;
>  
>  	/* find CODEC from registered CODECs*/
>  	list_for_each_entry(codec, &codec_list, list) {
> -		if (!strcmp(codec->name, aux_dev->codec_name))
> +		if (aux_dev->codec_of_node &&
> +				codec->dev->of_node == aux_dev->codec_of_node)
> +			return 0;
> +		if (aux_dev->codec_name &&
> +				!strcmp(codec->name, aux_dev->codec_name))
>  			return 0;

You can use codecname here.

> -		if (!strcmp(codec->name, aux_dev->codec_name)) {
> -			if (codec->probed) {
> -				dev_err(codec->dev,
> -					"ASoC: codec already probed");
> -				ret = -EBUSY;
> -				goto out;
> -			}
> -			goto found;
> +		if (aux_dev->codec_of_node &&
> +				codec->dev->of_node != aux_dev->codec_of_node)
> +			continue;
> +		if (aux_dev->codec_name &&
> +				strcmp(codec->name, aux_dev->codec_name))
> +			continue;

So in (error) case of ! aux_dev->codec_of_node && ! aux_dev->codec_name 
we match first possible codec?

Given code similarity between this and the one above, should there be
helper function that does the comparison (or even walks the list)?

> @@ -1644,12 +1663,19 @@ static int snd_soc_instantiate_card(struct snd_soc_card *card)
>  		/* check to see if we need to override the compress_type */
>  		for (i = 0; i < card->num_configs; ++i) {
>  			codec_conf = &card->codec_conf[i];
> -			if (!strcmp(codec->name, codec_conf->dev_name)) {
> -				compress_type = codec_conf->compress_type;
> -				if (compress_type && compress_type
> -				    != codec->compress_type)
> -					break;
> -			}
> +
> +			if (codec_conf->of_node &&
> +				codec->dev->of_node != codec_conf->of_node)
> +				continue;
> +
> +			if (codec_conf->dev_name &&
> +				strcmp(codec->name, codec_conf->dev_name))
> +				continue;
> +

..third copy of codec matching.

Thanks for doing all the good work,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
