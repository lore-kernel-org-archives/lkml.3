Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaBRQMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:12:25 -0500
Received: from smtp-out-137.synserver.de ([212.40.185.137]:1109 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751527AbaBRQMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:12:24 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13466
Message-ID: <53038676.1040205@metafoo.de>
Date: Tue, 18 Feb 2014 17:12:38 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: broonie@kernel.org, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        dmitry.torokhov@gmail.com, lgirdwood@gmail.com, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 05/17 v2] ASoC: adav80x: Update locking around use of
 DAPM pin API
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1392736948-26623-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-Reply-To: <1392736948-26623-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 04:22 PM, Charles Keepax wrote:
> The pin updates in this driver look like they are intended to be done
> atomically, update to do so.
>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

> ---
>   sound/soc/codecs/adav80x.c |   17 +++++++++++------
>   1 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/sound/soc/codecs/adav80x.c b/sound/soc/codecs/adav80x.c
> index 09d5609..9eb53c8 100644
> --- a/sound/soc/codecs/adav80x.c
> +++ b/sound/soc/codecs/adav80x.c
> @@ -539,6 +539,7 @@ static int adav80x_set_sysclk(struct snd_soc_codec *codec,
>   			      unsigned int freq, int dir)
>   {
>   	struct adav80x *adav80x = snd_soc_codec_get_drvdata(codec);
> +	struct snd_soc_dapm_context *dapm = &codec->dapm;
>
>   	if (dir == SND_SOC_CLOCK_IN) {
>   		switch (clk_id) {
> @@ -571,7 +572,7 @@ static int adav80x_set_sysclk(struct snd_soc_codec *codec,
>   			regmap_write(adav80x->regmap, ADAV80X_ICLK_CTRL2,
>   				iclk_ctrl2);
>
> -			snd_soc_dapm_sync(&codec->dapm);
> +			snd_soc_dapm_sync(dapm);
>   		}
>   	} else {
>   		unsigned int mask;
> @@ -598,17 +599,21 @@ static int adav80x_set_sysclk(struct snd_soc_codec *codec,
>   			adav80x->sysclk_pd[clk_id] = false;
>   		}
>
> +		snd_soc_dapm_mutex_lock(dapm);
> +
>   		if (adav80x->sysclk_pd[0])
> -			snd_soc_dapm_disable_pin(&codec->dapm, "PLL1");
> +			snd_soc_dapm_disable_pin_unlocked(dapm, "PLL1");
>   		else
> -			snd_soc_dapm_force_enable_pin(&codec->dapm, "PLL1");
> +			snd_soc_dapm_force_enable_pin_unlocked(dapm, "PLL1");
>
>   		if (adav80x->sysclk_pd[1] || adav80x->sysclk_pd[2])
> -			snd_soc_dapm_disable_pin(&codec->dapm, "PLL2");
> +			snd_soc_dapm_disable_pin_unlocked(dapm, "PLL2");
>   		else
> -			snd_soc_dapm_force_enable_pin(&codec->dapm, "PLL2");
> +			snd_soc_dapm_force_enable_pin_unlocked(dapm, "PLL2");
>
> -		snd_soc_dapm_sync(&codec->dapm);
> +		snd_soc_dapm_sync_unlocked(dapm);
> +
> +		snd_soc_dapm_mutex_unlock(dapm);
>   	}
>
>   	return 0;
>

