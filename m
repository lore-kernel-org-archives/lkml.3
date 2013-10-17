Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3JQJnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:43:18 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:54690 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3JQJnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:43:16 -0400
Date: Thu, 17 Oct 2013 11:42:08 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: <r65073@freescale.com>, <timur@tabi.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <r64188@freescale.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <perex@perex.cz>, <tiwai@suse.de>, <grant.likely@linaro.org>,
        <fabio.estevam@freescale.com>, <oskar@scara.com>,
        <shawn.guo@linaro.org>, <b42378@freescale.com>, <b18965@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCHv1 1/8] ALSA: Add SAI SoC Digital Audio Interface driver.
Message-ID: <20131017114208.595a4224@ipc1.ka-ro>
In-Reply-To: <1382000477-17304-2-git-send-email-Li.Xiubo@freescale.com>
References: <1382000477-17304-1-git-send-email-Li.Xiubo@freescale.com>
	<1382000477-17304-2-git-send-email-Li.Xiubo@freescale.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Xiubo Li <Li.Xiubo@freescale.com> wrote:
[...]
> diff --git a/sound/soc/fsl/fsl-pcm-dma.c b/sound/soc/fsl/fsl-pcm-dma.c
> new file mode 100644
> index 0000000..c4d925e
> --- /dev/null
> +++ b/sound/soc/fsl/fsl-pcm-dma.c
> @@ -0,0 +1,51 @@
[...]
> +
> +static int fsl_sai_probe(struct platform_device *pdev)
> +{
> +	struct of_phandle_args	dma_args;
> +	int index;
> +	struct resource *res;
> +	struct fsl_sai *sai;
> +	int ret = 0;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	sai = devm_kzalloc(&pdev->dev, sizeof(*sai), GFP_KERNEL);
> +	if (!sai)
> +		return -ENOMEM;
> +
> +	sai->fbt = FSL_SAI_FBT_MSB;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	sai->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(sai->base)) {
> +		ret = PTR_ERR(sai->base);
> +		return ret;
>
could be:
		return PTR_ERR(sai->base);

[...]
> +static const struct of_device_id fsl_sai_ids[] = {
> +	{ .compatible = "fsl,vf610-sai", },
> +	{ /*sentinel*/ },
>
The comma after the last entry in a struct initializer is there to make
patches that append another entry cleaner. Since this entry is and
always must be the last entry, the comma is useless here.

> diff --git a/sound/soc/fsl/fsl-sai.h b/sound/soc/fsl/fsl-sai.h
> new file mode 100644
> index 0000000..ab76a8e
> --- /dev/null
> +++ b/sound/soc/fsl/fsl-sai.h
> @@ -0,0 +1,127 @@
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
> +#define FSL_SAI_DMABUF_SIZE	(32 * 1024)
> +#define TCD_NUMBER		4
> +#define EDMA_PRIO_HIGH          6
> +
strange indentation with mixed spaces and tabs.

> +/* SAI Transmit and Recieve Configuration 2 Register */
> +#define SAI_TCR2		0x08
> +#define SAI_RCR2		0x88
> +#define SAI_CR2_SYNC		BIT(30)
> +#define SAI_CR2_MSEL_MASK	(0xff << 26)
> +#define SAI_CR2_MSEL_BUS	0
> +#define SAI_CR2_MSEL_MCLK1	BIT(26)
> +#define SAI_CR2_MSEL_MCLK2	BIT(27)
> +#define SAI_CR2_MSEL_MCLK3	(BIT(26)|BIT(27))
>
spaces around '|'?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
