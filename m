Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaBQRGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:06:00 -0500
Received: from smtp-out-028.synserver.de ([212.40.185.28]:1107 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751516AbaBQRF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:05:59 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32064
Message-ID: <5302417B.3070408@metafoo.de>
Date: Mon, 17 Feb 2014 18:06:03 +0100
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
Subject: Re: [PATCH 02/15] ASoC: dapm: Add locked version of snd_soc_dapm_xxxx_pin
 functions
References: <1392655903-24537-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1392655903-24537-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-Reply-To: <1392655903-24537-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> +int snd_soc_dapm_enable_pin_locked(struct snd_soc_dapm_context *dapm,
> +				   const char *pin)
> +{
> +	return snd_soc_dapm_set_pin(dapm, pin, 1);
> +}
> +EXPORT_SYMBOL_GPL(snd_soc_dapm_enable_pin_locked);
> +
> +/**
>    * snd_soc_dapm_enable_pin - enable pin.
>    * @dapm: DAPM context
>    * @pin: pin name
>    *
>    * Enables input/output pin and its parents or children widgets iff there is
>    * a valid audio route and active audio stream.
> + *
>    * NOTE: snd_soc_dapm_sync() needs to be called after this for DAPM to
>    * do any widget power switching.
>    */
>   int snd_soc_dapm_enable_pin(struct snd_soc_dapm_context *dapm, const char *pin)
>   {
> -	return snd_soc_dapm_set_pin(dapm, pin, 1);
> +	int ret;
> +
> +	mutex_lock_nested(&dapm->card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
> +
> +	ret = snd_soc_dapm_set_pin(dapm, pin, 1);
> +
> +	mutex_unlock(&dapm->card->dapm_mutex);
> +
> +	return ret;
>   }

Hm, this is a bit confusing. For other functions in ASoC when we have a pair 
of functions with the _locked suffix and without the one with _locked takes 
the lock, the other one doesn't. E.g. snd_soc_update_bits_locked. Here we do 
it the other way around.

- Lars

