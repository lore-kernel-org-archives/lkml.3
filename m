Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbbAELso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:48:44 -0500
Received: from smtp-out-200.synserver.de ([212.40.185.200]:1109 "EHLO
	smtp-out-200.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbbAELsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:48:42 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14545
Message-ID: <54AA7A0B.2070004@metafoo.de>
Date: Mon, 05 Jan 2015 12:48:27 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Inha Song <ideal.song@samsung.com>, alsa-devel@alsa-project.org
CC: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, sbkim73@samsung.com,
        linux-kernel@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        tiwai@suse.de, robh+dt@kernel.org, kgene@kernel.org,
        s.nawrocki@samsung.com, galak@codeaurora.org, grant.likely@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: samsung: Add machine driver for
 Trats2
References: <1420457117-11030-1-git-send-email-ideal.song@samsung.com> <1420457117-11030-2-git-send-email-ideal.song@samsung.com>
In-Reply-To: <1420457117-11030-2-git-send-email-ideal.song@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A few small comments inline.

On 01/05/2015 12:25 PM, Inha Song wrote:
> --- /dev/null
> +++ b/sound/soc/samsung/trats2_wm1811.c
> @@ -0,0 +1,216 @@
>[...]
> +#include <linux/of.h>
> +#include <linux/module.h>
> +#include <linux/clk.h>
> +#include <sound/soc.h>
> +#include <sound/pcm_params.h>
> +#include "i2s.h"
> +#include "i2s-regs.h"

You probably don't need i2s-regs.h

> +#include "../codecs/wm8994.h"
> +
> +struct trats2_machine_priv {
> +	struct clk *clk_mclk;
> +};
> +
> +static struct trats2_machine_priv trats2_wm1811_priv;
> +
> +static const struct snd_kcontrol_new trats2_controls[] = {
> +	SOC_DAPM_PIN_SWITCH("SPK"),
> +};
> +
> +const struct snd_soc_dapm_widget trats2_dapm_widgets[] = {

static

> +	SND_SOC_DAPM_SPK("SPK", NULL),
> +};
> +
> +static int trats2_aif1_hw_params(struct snd_pcm_substream *substream,
> +				 struct snd_pcm_hw_params *params)
> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
> +	struct snd_soc_dai *codec_dai = rtd->codec_dai;
> +	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(rtd->card);
> +	unsigned int sysclk_rate;
> +	unsigned int mclk_rate =
> +			(unsigned int)clk_get_rate(priv->clk_mclk);
> +	int ret;
> +
> +	/* Set the codec DAI configuration to Master*/
> +	ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S
> +					| SND_SOC_DAIFMT_NB_NF
> +					| SND_SOC_DAIFMT_CBM_CFM);
> +	if (ret < 0) {
> +		dev_err(codec_dai->dev,
> +			"Failed to set codec dai format: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Set the cpu DAI configuration to Slave */
> +	ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S
> +					| SND_SOC_DAIFMT_NB_NF
> +					| SND_SOC_DAIFMT_CBM_CFM);
> +	if (ret < 0) {
> +		dev_err(cpu_dai->dev,
> +			"Failed to set cpu dai format: %d\n", ret);
> +		return ret;
> +	}


Use the dai_fmt field in the dai_link struct to setup the DAI link format. 
This will configure both the CPU and the CODEC DAI with the specified 
format, no need to do it manually.

>[...]
> +static struct snd_soc_ops trats2_aif1_ops = {

const

> +	.hw_params = trats2_aif1_hw_params,
> +};
> +
> +static int trats2_init_paiftx(struct snd_soc_pcm_runtime *rtd)
> +{
> +	struct snd_soc_codec *codec = rtd->codec;
> +	struct snd_soc_card *card = rtd->card;
> +	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(card);
> +	int ret;
> +
> +	ret = clk_prepare_enable(priv->clk_mclk);

Maybe just do this in the platform device probe handler and you should have 
a matching disable call somewhere.

> +	if (ret) {
> +		dev_err(codec->dev, "Failed to enable mclk: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
>[...]
