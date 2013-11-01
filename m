Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3KAJIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:08:42 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:55747
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485Ab3KAJIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:08:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zzbb2dI98dI1432I853kc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1155h)
Date: Fri, 1 Nov 2013 16:59:05 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: <r65073@freescale.com>, <timur@tabi.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <r64188@freescale.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <perex@perex.cz>, <tiwai@suse.de>, <grant.likely@linaro.org>,
        <fabio.estevam@freescale.com>, <LW@KARO-electronics.de>,
        <oskar@scara.com>, <shawn.guo@linaro.org>, <b18965@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCHv2 1/8] ALSA: Add SAI SoC Digital Audio Interface driver.
Message-ID: <20131101085904.GC28401@MrMyself>
References: <1383289495-24523-1-git-send-email-Li.Xiubo@freescale.com>
 <1383289495-24523-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1383289495-24523-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xiubo,

On Fri, Nov 01, 2013 at 03:04:48PM +0800, Xiubo Li wrote:
> This adds Freescale SAI ASoC Audio support.
> This implementation is only compatible with device tree definition.
> Features:
> o Supports playback/capture
> o Supports 16/20/24 bit PCM
> o Supports 8k - 96k sample rates
> o Supports slave mode only.
> 

Just for curiosity, I found there're quite a bit code actually support
I2S master mode such as set_sysclk() and register configuration to FMT
SND_SOC_DAIFMT_CBS_CFS.

Is that really "supports slave mode only"? Or just you haven't make
it properly work?

> diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
> index b7ab71f..9a8851e 100644
> --- a/sound/soc/fsl/Kconfig
> +++ b/sound/soc/fsl/Kconfig
> @@ -213,3 +213,19 @@ config SND_SOC_IMX_MC13783
>  	select SND_SOC_IMX_PCM_DMA
>  
>  endif # SND_IMX_SOC
> +
> +menuconfig SND_FSL_SOC
> +	tristate "SoC Audio for Freescale FSL CPUs"
> +	help
> +	  Say Y or M if you want to add support for codecs attached to
> +	  the FSL CPUs.
> +
> +	  This will enable Freeacale SAI, SGT15000 codec.
> +
> +if SND_FSL_SOC

Why check this here? SAI should be a regular IP module which can be used by
other SoC as well. We would never know if next i.MX SoC won't contain SAI.

> +
> +config SND_SOC_FSL_SAI
> +	tristate
> +	select SND_SOC_GENERIC_DMAENGINE_PCM

I think you should keep SAI beside SSI/SPDIF directly.

> +
> +endif # SND_FSL_SOC
> diff --git a/sound/soc/fsl/Makefile b/sound/soc/fsl/Makefile
> index 8db705b..e5acc03 100644
> --- a/sound/soc/fsl/Makefile
> +++ b/sound/soc/fsl/Makefile
> @@ -56,3 +56,8 @@ obj-$(CONFIG_SND_SOC_IMX_SGTL5000) += snd-soc-imx-sgtl5000.o
>  obj-$(CONFIG_SND_SOC_IMX_WM8962) += snd-soc-imx-wm8962.o
>  obj-$(CONFIG_SND_SOC_IMX_SPDIF) += snd-soc-imx-spdif.o
>  obj-$(CONFIG_SND_SOC_IMX_MC13783) += snd-soc-imx-mc13783.o
> +
> +# FSL ARM SAI/SGT15000 Platform Support

Should be SGTL5000, not SGT1. And SAI should not be used with SGTL5000 only,
it's a bit confusing to mention SGTL5000 here.

> +snd-soc-fsl-sai-objs := fsl-sai.o

And I think it should be better to put it along with fsl-ssi.o and fsl-spdif.o

> +
> +obj-$(CONFIG_SND_SOC_FSL_SAI) += snd-soc-fsl-sai.o

Ditto

> diff --git a/sound/soc/fsl/fsl-sai.c b/sound/soc/fsl/fsl-sai.c
> new file mode 100644
> index 0000000..bb57e67
> --- /dev/null
> +++ b/sound/soc/fsl/fsl-sai.c
> @@ -0,0 +1,472 @@
> +/*
> + * Freescale SAI ALSA SoC Digital Audio Interface driver.
> + *
> + * Copyright 2012-2013 Freescale Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.

There're too many double space inside. Could you pls revise it?

> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/of_address.h>
> +#include <sound/core.h>
> +#include <sound/pcm_params.h>
> +#include <linux/delay.h>
> +#include <linux/dmaengine.h>
> +#include <sound/dmaengine_pcm.h>

I think it's better to keep <sound/xxx.h> together. And basically
we can keep header files ordered by alphabet.

> +
> +#include "fsl-sai.h"
> +
> +static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
> +		int clk_id, unsigned int freq, int fsl_dir)
> +{
> +	u32 val_cr2, reg_cr2;
> +	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
> +
> +	if (fsl_dir == FSL_FMT_TRANSMITTER)
> +		reg_cr2 = FSL_SAI_TCR2;
> +	else
> +		reg_cr2 = FSL_SAI_RCR2;
> +
> +	val_cr2 = readl(sai->base + reg_cr2);
> +	switch (clk_id) {
> +	case FSL_SAI_CLK_BUS:
> +		val_cr2 &= ~FSL_SAI_CR2_MSEL_MASK;
> +		val_cr2 |= FSL_SAI_CR2_MSEL_BUS;
> +		break;
> +	case FSL_SAI_CLK_MAST1:
> +		val_cr2 &= ~FSL_SAI_CR2_MSEL_MASK;
> +		val_cr2 |= FSL_SAI_CR2_MSEL_MCLK1;
> +		break;
> +	case FSL_SAI_CLK_MAST2:
> +		val_cr2 &= ~FSL_SAI_CR2_MSEL_MASK;
> +		val_cr2 |= FSL_SAI_CR2_MSEL_MCLK2;
> +		break;
> +	case FSL_SAI_CLK_MAST3:
> +		val_cr2 &= ~FSL_SAI_CR2_MSEL_MASK;
> +		val_cr2 |= FSL_SAI_CR2_MSEL_MCLK3;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	writel(val_cr2, sai->base + reg_cr2);
> +
> +	return 0;
> +}
> +
> +static int fsl_sai_set_dai_sysclk(struct snd_soc_dai *cpu_dai,
> +		int clk_id, unsigned int freq, int dir)
> +{
> +	int ret;
> +
> +	if (dir == SND_SOC_CLOCK_IN)
> +		return 0;
> +
> +	ret = fsl_sai_set_dai_sysclk_tr(cpu_dai, clk_id, freq,
> +					FSL_FMT_TRANSMITTER);
> +	if (ret) {
> +		dev_err(cpu_dai->dev,
> +				"Cannot set sai's transmitter sysclk: %d\n",
> +				ret);
> +		return ret;
> +	}
> +
> +	ret = fsl_sai_set_dai_sysclk_tr(cpu_dai, clk_id, freq,
> +					FSL_FMT_RECEIVER);
> +	if (ret) {
> +		dev_err(cpu_dai->dev,
> +				"Cannot set sai's receiver sysclk: %d\n",
> +				ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int fsl_sai_set_dai_clkdiv(struct snd_soc_dai *cpu_dai,
> +		int div_id, int div)
> +{
> +	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
> +	u32 tcr2, rcr2;
> +
> +	if (div_id == FSL_SAI_TX_DIV) {
> +		tcr2 = readl(sai->base + FSL_SAI_TCR2);
> +		tcr2 &= ~FSL_SAI_CR2_DIV_MASK;
> +		tcr2 |= FSL_SAI_CR2_DIV(div);
> +		writel(tcr2, sai->base + FSL_SAI_TCR2);
> +
> +	} else if (div_id == FSL_SAI_RX_DIV) {
> +		rcr2 = readl(sai->base + FSL_SAI_RCR2);
> +		rcr2 &= ~FSL_SAI_CR2_DIV_MASK;
> +		rcr2 |= FSL_SAI_CR2_DIV(div);
> +		writel(rcr2, sai->base + FSL_SAI_RCR2);
> +
> +	} else
> +		return -EINVAL;

It would look better if using switch-case. And the last 'else'
could be 'default:'.

> +
> +	return 0;
> +}
> +
> +static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
> +				unsigned int fmt, int fsl_dir)
> +{
> +	u32 val_cr2, val_cr3, val_cr4, reg_cr2, reg_cr3, reg_cr4;
> +	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
> +
> +	if (fsl_dir == FSL_FMT_TRANSMITTER) {
> +		reg_cr2 = FSL_SAI_TCR2;
> +		reg_cr3 = FSL_SAI_TCR3;
> +		reg_cr4 = FSL_SAI_TCR4;
> +	} else {
> +		reg_cr2 = FSL_SAI_RCR2;
> +		reg_cr3 = FSL_SAI_RCR3;
> +		reg_cr4 = FSL_SAI_RCR4;
> +	}
> +
> +	val_cr2 = readl(sai->base + reg_cr2);
> +	val_cr3 = readl(sai->base + reg_cr3);
> +	val_cr4 = readl(sai->base + reg_cr4);
> +
> +	if (sai->fbt == FSL_SAI_FBT_MSB)
> +		val_cr4 |= FSL_SAI_CR4_MF;
> +	else if (sai->fbt == FSL_SAI_FBT_LSB)
> +		val_cr4 &= ~FSL_SAI_CR4_MF;
> +
> +	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
> +	case SND_SOC_DAIFMT_I2S:
> +		val_cr4 |= FSL_SAI_CR4_FSE;
> +		val_cr4 |= FSL_SAI_CR4_FSP;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
> +	case SND_SOC_DAIFMT_IB_IF:
> +		val_cr4 |= FSL_SAI_CR4_FSP;
> +		val_cr2 &= ~FSL_SAI_CR2_BCP;
> +		break;
> +	case SND_SOC_DAIFMT_IB_NF:
> +		val_cr4 &= ~FSL_SAI_CR4_FSP;
> +		val_cr2 &= ~FSL_SAI_CR2_BCP;
> +		break;
> +	case SND_SOC_DAIFMT_NB_IF:
> +		val_cr4 |= FSL_SAI_CR4_FSP;
> +		val_cr2 |= FSL_SAI_CR2_BCP;
> +		break;
> +	case SND_SOC_DAIFMT_NB_NF:
> +		val_cr4 &= ~FSL_SAI_CR4_FSP;
> +		val_cr2 |= FSL_SAI_CR2_BCP;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
> +	case SND_SOC_DAIFMT_CBS_CFS:
> +		val_cr2 |= FSL_SAI_CR2_BCD_MSTR;
> +		val_cr4 |= FSL_SAI_CR4_FSD_MSTR;
> +		break;
> +	case SND_SOC_DAIFMT_CBM_CFM:
> +		val_cr2 &= ~FSL_SAI_CR2_BCD_MSTR;
> +		val_cr4 &= ~FSL_SAI_CR4_FSD_MSTR;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	val_cr3 |= FSL_SAI_CR3_TRCE;
> +
> +	if (fsl_dir == FSL_FMT_RECEIVER)
> +		val_cr2 |= FSL_SAI_CR2_SYNC;
> +
> +	writel(val_cr2, sai->base + reg_cr2);
> +	writel(val_cr3, sai->base + reg_cr3);
> +	writel(val_cr4, sai->base + reg_cr4);
> +
> +	return 0;

> +

Pls drop this extra line.

> +}
> +
> +static int fsl_sai_set_dai_fmt(struct snd_soc_dai *cpu_dai, unsigned int fmt)
> +{
> +	int ret;
> +
> +	ret = fsl_sai_set_dai_fmt_tr(cpu_dai, fmt, FSL_FMT_TRANSMITTER);
> +	if (ret) {
> +		dev_err(cpu_dai->dev,
> +				"Cannot set sai's transmitter format: %d\n",
> +				ret);
> +		return ret;
> +	}
> +
> +	ret = fsl_sai_set_dai_fmt_tr(cpu_dai, fmt, FSL_FMT_RECEIVER);
> +	if (ret) {
> +		dev_err(cpu_dai->dev,
> +				"Cannot set sai's receiver format: %d\n",
> +				ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int fsl_sai_set_dai_tdm_slot(struct snd_soc_dai *cpu_dai,
> +		unsigned int tx_mask, unsigned int rx_mask,
> +		int slots, int slot_width)
> +{
> +	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
> +	u32 tcr4, rcr4;
> +
> +	tcr4 = readl(sai->base + FSL_SAI_TCR4);
> +	tcr4 &= ~FSL_SAI_CR4_FRSZ_MASK;
> +	tcr4 |= FSL_SAI_CR4_FRSZ(2);
> +	writel(tcr4, sai->base + FSL_SAI_TCR4);
> +	writel(tx_mask, sai->base + FSL_SAI_TMR);
> +
> +	rcr4 = readl(sai->base + FSL_SAI_RCR4);
> +	rcr4 &= ~FSL_SAI_CR4_FRSZ_MASK;
> +	rcr4 |= FSL_SAI_CR4_FRSZ(2);
> +	writel(rcr4, sai->base + FSL_SAI_RCR4);
> +	writel(rx_mask, sai->base + FSL_SAI_RMR);
> +
> +	return 0;
> +}
> +
> +static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
> +		struct snd_pcm_hw_params *params,
> +		struct snd_soc_dai *cpu_dai)
> +{
> +	u32 val_cr4, val_cr5, reg_cr4, reg_cr5, word_width;
> +	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
> +
> +	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
> +		reg_cr4 = FSL_SAI_TCR4;
> +		reg_cr5 = FSL_SAI_TCR5;
> +	} else {
> +		reg_cr4 = FSL_SAI_RCR4;
> +		reg_cr5 = FSL_SAI_RCR5;
> +	}
> +
> +	val_cr4 = readl(sai->base + reg_cr4);
> +	val_cr4 &= ~FSL_SAI_CR4_SYWD_MASK;
> +
> +	val_cr5 = readl(sai->base + reg_cr5);
> +	val_cr5 &= ~FSL_SAI_CR5_WNW_MASK;
> +	val_cr5 &= ~FSL_SAI_CR5_W0W_MASK;
> +	val_cr5 &= ~FSL_SAI_CR5_FBT_MASK;
> +
> +	switch (params_format(params)) {
> +	case SNDRV_PCM_FORMAT_S16_LE:
> +		word_width = 16;
> +		break;
> +	case SNDRV_PCM_FORMAT_S20_3LE:
> +		word_width = 20;
> +		break;
> +	case SNDRV_PCM_FORMAT_S24_LE:
> +		word_width = 24;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	val_cr4 |= FSL_SAI_CR4_SYWD(word_width);
> +	val_cr5 |= FSL_SAI_CR5_WNW(word_width);
> +	val_cr5 |= FSL_SAI_CR5_W0W(word_width);
> +
> +	if (sai->fbt == FSL_SAI_FBT_MSB)
> +		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
> +	else if (sai->fbt == FSL_SAI_FBT_LSB)
> +		val_cr5 |= FSL_SAI_CR5_FBT(0);
> +
> +	writel(val_cr4, sai->base + reg_cr4);
> +	writel(val_cr5, sai->base + reg_cr5);
> +
> +	return 0;
> +}
> +
> +static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
> +		struct snd_soc_dai *dai)
> +{
> +	struct fsl_sai *sai = snd_soc_dai_get_drvdata(dai);
> +	unsigned int tcsr, rcsr;
> +
> +	tcsr = readl(sai->base + FSL_SAI_TCSR);
> +	rcsr = readl(sai->base + FSL_SAI_RCSR);
> +
> +	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
> +		tcsr |= FSL_SAI_CSR_FRDE;
> +		rcsr &= ~FSL_SAI_CSR_FRDE;
> +	} else {
> +		rcsr |= FSL_SAI_CSR_FRDE;
> +		tcsr &= ~FSL_SAI_CSR_FRDE;
> +	}
> +
> +	switch (cmd) {
> +	case SNDRV_PCM_TRIGGER_START:
> +	case SNDRV_PCM_TRIGGER_RESUME:
> +	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> +		tcsr |= FSL_SAI_CSR_TERE;
> +		rcsr |= FSL_SAI_CSR_TERE;
> +		writel(rcsr, sai->base + FSL_SAI_RCSR);
> +		udelay(10);

Does SAI really needs this udelay() here? Required by IP's operation flow?
If so, I think it's better to add comments here to explain it.

> +		writel(tcsr, sai->base + FSL_SAI_TCSR);
> +		break;
> +
> +	case SNDRV_PCM_TRIGGER_STOP:
> +	case SNDRV_PCM_TRIGGER_SUSPEND:
> +	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> +		if (!(dai->playback_active || dai->capture_active)) {
> +			tcsr &= ~FSL_SAI_CSR_TERE;
> +			rcsr &= ~FSL_SAI_CSR_TERE;
> +		}
> +		writel(rcsr, sai->base + FSL_SAI_RCSR);
> +		udelay(10);
> +		writel(tcsr, sai->base + FSL_SAI_TCSR);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct snd_soc_dai_ops fsl_sai_pcm_dai_ops = {
> +	.set_sysclk	= fsl_sai_set_dai_sysclk,
> +	.set_clkdiv	= fsl_sai_set_dai_clkdiv,
> +	.set_fmt	= fsl_sai_set_dai_fmt,
> +	.set_tdm_slot	= fsl_sai_set_dai_tdm_slot,
> +	.hw_params	= fsl_sai_hw_params,
> +	.trigger	= fsl_sai_trigger,
> +};
> +
> +static int fsl_sai_dai_probe(struct snd_soc_dai *dai)
> +{
> +	int ret;
> +	struct fsl_sai *sai = dev_get_drvdata(dai->dev);
> +
> +	ret = clk_prepare_enable(sai->clk);
> +	if (ret)
> +		return ret;
> +
> +	writel(0x0, sai->base + FSL_SAI_RCSR);
> +	writel(0x0, sai->base + FSL_SAI_TCSR);
> +	writel(sai->dma_params_tx.maxburst, sai->base + FSL_SAI_TCR1);
> +	writel(sai->dma_params_rx.maxburst, sai->base + FSL_SAI_RCR1);
> +
> +	dai->playback_dma_data = &sai->dma_params_tx;
> +	dai->capture_dma_data = &sai->dma_params_rx;
> +
> +	snd_soc_dai_set_drvdata(dai, sai);
> +
> +	return 0;
> +}
> +
> +int fsl_sai_dai_remove(struct snd_soc_dai *dai)

static

> +{
> +	struct fsl_sai *sai = dev_get_drvdata(dai->dev);
> +
> +	clk_disable_unprepare(sai->clk);
> +
> +	return 0;
> +}
> +
> +static struct snd_soc_dai_driver fsl_sai_dai = {
> +	.probe = fsl_sai_dai_probe,
> +	.remove = fsl_sai_dai_remove,
> +	.playback = {
> +		.channels_min = 1,
> +		.channels_max = 2,
> +		.rates = SNDRV_PCM_RATE_8000_96000,
> +		.formats = FSL_SAI_FORMATS,
> +	},
> +	.capture = {
> +		.channels_min = 1,
> +		.channels_max = 2,
> +		.rates = SNDRV_PCM_RATE_8000_96000,
> +		.formats = FSL_SAI_FORMATS,
> +	},
> +	.ops = &fsl_sai_pcm_dai_ops,
> +};
> +
> +static const struct snd_soc_component_driver fsl_component = {
> +	.name           = "fsl-sai",
> +};
> +
> +static int fsl_sai_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	struct fsl_sai *sai;
> +	int ret = 0;
> +
> +	sai = devm_kzalloc(&pdev->dev, sizeof(*sai), GFP_KERNEL);
> +	if (!sai)
> +		return -ENOMEM;
> +
> +	sai->fbt = FSL_SAI_FBT_MSB;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	sai->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(sai->base))
> +		return PTR_ERR(sai->base);
> +
> +	sai->clk = devm_clk_get(&pdev->dev, "sai");
> +	if (IS_ERR(sai->clk)) {
> +		dev_err(&pdev->dev, "Cannot get sai's clock: %d\n", ret);
> +		return PTR_ERR(sai->clk);
> +	}
> +
> +	sai->dma_params_rx.addr = res->start + FSL_SAI_RDR;
> +	sai->dma_params_rx.maxburst = 6;
> +
> +	sai->dma_params_tx.addr = res->start + FSL_SAI_TDR;
> +	sai->dma_params_tx.maxburst = 6;
> +
> +	platform_set_drvdata(pdev, sai);
> +
> +	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_component,
> +			&fsl_sai_dai, 1);
> +	if (ret)
> +		return ret;
> +
> +	ret = snd_dmaengine_pcm_register(&pdev->dev, NULL,
> +			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int fsl_sai_remove(struct platform_device *pdev)
> +{
> +	snd_dmaengine_pcm_unregister(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id fsl_sai_ids[] = {
> +	{ .compatible = "fsl,vf610-sai", },

> +	{ /*sentinel*/ }

I think this could be left in blank without comments inside.
And if you really want to add it, pls add like: /* sentinel */
						  ^        ^
> +};
> +
> +static struct platform_driver fsl_sai_driver = {
> +	.probe = fsl_sai_probe,
> +	.remove = fsl_sai_remove,
> +
> +	.driver = {
> +		.name = "fsl-sai",
> +		.owner = THIS_MODULE,
> +		.of_match_table = fsl_sai_ids,
> +	},
> +};
> +module_platform_driver(fsl_sai_driver);
> +
> +MODULE_AUTHOR("Xiubo Li, <Li.Xiubo@freescale.com>");
> +MODULE_AUTHOR("Alison Wang, <b18965@freescale.com>");
> +MODULE_DESCRIPTION("Freescale Soc SAI Interface");
> +MODULE_LICENSE("GPL");

Should be better if added:
MODULE_ALIAS("platform:fsl-sai");

This would support module auto-load feature in some Linux-OS.

Best regards,
Nicolin Chen

> diff --git a/sound/soc/fsl/fsl-sai.h b/sound/soc/fsl/fsl-sai.h
> new file mode 100644
> index 0000000..1637679
> --- /dev/null
> +++ b/sound/soc/fsl/fsl-sai.h
> @@ -0,0 +1,120 @@
> +/*
> + * Copyright 2012-2013 Freescale Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __FSL_SAI_H
> +#define __FSL_SAI_H
> +
> +#include <sound/dmaengine_pcm.h>
> +
> +#define FSL_SAI_FORMATS (SNDRV_PCM_FMTBIT_S16_LE |\
> +			 SNDRV_PCM_FMTBIT_S20_3LE |\
> +			 SNDRV_PCM_FMTBIT_S24_LE)
> +
> +/* SAI Transmit/Recieve Control Register */
> +#define FSL_SAI_TCSR		0x00
> +#define FSL_SAI_RCSR		0x80
> +#define FSL_SAI_CSR_TERE	BIT(31)
> +#define FSL_SAI_CSR_FWF		BIT(17)
> +#define FSL_SAI_CSR_FRIE	BIT(8)
> +#define FSL_SAI_CSR_FRDE	BIT(0)
> +
> +/* SAI Transmit Data/FIFO/MASK Register */
> +#define FSL_SAI_TDR		0x20
> +#define FSL_SAI_TFR		0x40
> +#define FSL_SAI_TMR		0x60
> +
> +/* SAI Recieve Data/FIFO/MASK Register */
> +#define FSL_SAI_RDR		0xa0
> +#define FSL_SAI_RFR		0xc0
> +#define FSL_SAI_RMR		0xe0
> +
> +/* SAI Transmit and Recieve Configuration 1 Register */
> +#define FSL_SAI_TCR1		0x04
> +#define FSL_SAI_RCR1		0x84
> +
> +/* SAI Transmit and Recieve Configuration 2 Register */
> +#define FSL_SAI_TCR2		0x08
> +#define FSL_SAI_RCR2		0x88
> +#define FSL_SAI_CR2_SYNC	BIT(30)
> +#define FSL_SAI_CR2_MSEL_MASK	(0xff << 26)
> +#define FSL_SAI_CR2_MSEL_BUS	0
> +#define FSL_SAI_CR2_MSEL_MCLK1	BIT(26)
> +#define FSL_SAI_CR2_MSEL_MCLK2	BIT(27)
> +#define FSL_SAI_CR2_MSEL_MCLK3	(BIT(26) | BIT(27))
> +#define FSL_SAI_CR2_BCP		BIT(25)
> +#define FSL_SAI_CR2_BCD_MSTR	BIT(24)
> +#define FSL_SAI_CR2_DIV(x)	(x)
> +#define FSL_SAI_CR2_DIV_MASK	0xff
> +
> +/* SAI Transmit and Recieve Configuration 3 Register */
> +#define FSL_SAI_TCR3		0x0c
> +#define FSL_SAI_RCR3		0x8c
> +#define FSL_SAI_CR3_TRCE	BIT(16)
> +#define FSL_SAI_CR3_WDFL(x)	(x)
> +#define FSL_SAI_CR3_WDFL_MASK	0x1f
> +
> +/* SAI Transmit and Recieve Configuration 4 Register */
> +#define FSL_SAI_TCR4		0x10
> +#define FSL_SAI_RCR4		0x90
> +#define FSL_SAI_CR4_FRSZ(x)	(((x) - 1) << 16)
> +#define FSL_SAI_CR4_FRSZ_MASK	(0x1f << 16)
> +#define FSL_SAI_CR4_SYWD(x)	(((x) - 1) << 8)
> +#define FSL_SAI_CR4_SYWD_MASK	(0x1f << 8)
> +#define FSL_SAI_CR4_MF		BIT(4)
> +#define FSL_SAI_CR4_FSE		BIT(3)
> +#define FSL_SAI_CR4_FSP		BIT(1)
> +#define FSL_SAI_CR4_FSD_MSTR	BIT(0)
> +
> +/* SAI Transmit and Recieve Configuration 5 Register */
> +#define FSL_SAI_TCR5		0x14
> +#define FSL_SAI_RCR5		0x94
> +#define FSL_SAI_CR5_WNW(x)	(((x) - 1) << 24)
> +#define FSL_SAI_CR5_WNW_MASK	(0x1f << 24)
> +#define FSL_SAI_CR5_W0W(x)	(((x) - 1) << 16)
> +#define FSL_SAI_CR5_W0W_MASK	(0x1f << 16)
> +#define FSL_SAI_CR5_FBT(x)	((x) << 8)
> +#define FSL_SAI_CR5_FBT_MASK	(0x1f << 8)
> +
> +/* SAI audio dividers */
> +#define FSL_SAI_TX_DIV		0
> +#define FSL_SAI_RX_DIV		1
> +
> +/* SAI type */
> +#define FSL_SAI_DMA		BIT(0)
> +#define FSL_SAI_USE_AC97	BIT(1)
> +#define FSL_SAI_NET		BIT(2)
> +#define FSL_SAI_TRA_SYN		BIT(3)
> +#define FSL_SAI_REC_SYN		BIT(4)
> +#define FSL_SAI_USE_I2S_SLAVE	BIT(5)
> +
> +#define FSL_FMT_TRANSMITTER	0
> +#define FSL_FMT_RECEIVER	1
> +
> +/* SAI clock sources */
> +#define FSL_SAI_CLK_BUS		0
> +#define FSL_SAI_CLK_MAST1	1
> +#define FSL_SAI_CLK_MAST2	2
> +#define FSL_SAI_CLK_MAST3	3
> +
> +enum fsl_sai_fbt {
> +	FSL_SAI_FBT_MSB,
> +	FSL_SAI_FBT_LSB,
> +};
> +
> +struct fsl_sai {
> +	struct clk *clk;
> +
> +	void __iomem *base;
> +
> +	enum fsl_sai_fbt fbt;
> +
> +	struct snd_dmaengine_dai_dma_data dma_params_rx;
> +	struct snd_dmaengine_dai_dma_data dma_params_tx;
> +};
> +
> +#endif /* __FSL_SAI_H */
> -- 
> 1.8.4
> 


