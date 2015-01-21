Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbbAUGHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:07:12 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40749 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbbAUGHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:07:10 -0500
Date: Tue, 20 Jan 2015 22:07:03 -0800
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Zidan Wang <zidan.wang@freescale.com>
Cc: timur@tabi.org, Xiubo.Lee@gmail.com, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH 1/3] SoC: fsl_sai: add sai master mode support
Message-ID: <20150121060702.GB3275@Alpha>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-2-git-send-email-zidan.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421756480-7055-2-git-send-email-zidan.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 08:21:18PM +0800, Zidan Wang wrote:
> +static int fsl_sai_set_bclk(struct snd_soc_dai *dai, bool tx, u32 freq)

> +	if ((tx && sai->synchronous[TX]) || (!tx && !sai->synchronous[RX])) {
> +		regmap_update_bits(sai->regmap, FSL_SAI_RCR2,
> +			FSL_SAI_CR2_MSEL_MASK, FSL_SAI_CR2_MSEL(sai->mclk_id));
> +		regmap_update_bits(sai->regmap, FSL_SAI_RCR2,
> +			FSL_SAI_CR2_DIV_MASK, savediv - 1);

Hmm...the case should be a bit more complicated here IMO.

"tx && sai->synchronous[TX]" means the playback in synchronous
mode (TX following RX). What if the recording has been already
activated with an MSEL setting at this point? Then the playback
stream, as a secondary stream, will overwrite MSEL of the first
stream -- Record. Same would happen to the DIV configuration.

> @@ -297,6 +368,24 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
>  	unsigned int channels = params_channels(params);
>  	u32 word_width = snd_pcm_format_width(params_format(params));
>  	u32 val_cr4 = 0, val_cr5 = 0;
> +	int ret;
> +
> +	if (!sai->is_slave_mode) {
> +		ret = fsl_sai_set_bclk(cpu_dai, tx,
> +			2 * word_width * params_rate(params));
> +		if (ret)
> +			return ret;
> +
> +		/* Do not enable the clock if it is already enabled */

It actually doesn't matter to enable the clock again since it
purely increaes its count. But we do need a protection for MSEL
overwritten issue resulted from the fsl_sai_set_bclk() call.

> @@ -133,10 +135,13 @@ struct fsl_sai {
>  	struct clk *mclk_clk[FSL_SAI_MCLK_MAX];
>  
>  	bool is_lsb_first;
> +	bool is_slave_mode;
>  	bool is_dsp_mode;
>  	bool sai_on_imx;
>  	bool synchronous[2];
>  
> +	unsigned int mclk_id;
> +	unsigned int mclk_streams;

Besides, I doubt that only one property of mclk_id can content
Asynchronous Mode -- TX and RX can fetch their clocks from
different MCLK sources.

Nicolin
