Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaCZMAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:00:40 -0400
Received: from mx0.aculab.com ([213.249.233.131]:42584 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751674AbaCZMAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:00:38 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Nicolin Chen'" <Guangyu.Chen@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Topic: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Index: AQHPSOkyMNLV7/nE7kymG92arvGYT5rzQwIQ
Date: Wed, 26 Mar 2014 11:59:53 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6E958E@AcuExch.aculab.com>
References: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
In-Reply-To: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2QC0qWp029166

From: Nicolin Chen
> It's quite cricial to clear error flags because SAI might hang if getting
> FIFO underrun during playback (I haven't confirmed the same issue on Rx
> overflow though).
> 
> So this patch enables those irq and adds isr() to clear the flags so as to
> keep playback entirely safe.
> 
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> ---
>  sound/soc/fsl/fsl_sai.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++---
>  sound/soc/fsl/fsl_sai.h |  9 +++++++
>  2 files changed, 75 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> index c4a4231..5f91aff 100644
> --- a/sound/soc/fsl/fsl_sai.c
> +++ b/sound/soc/fsl/fsl_sai.c
> @@ -23,6 +23,55 @@
> 
>  #include "fsl_sai.h"
> 
> +#define FSL_SAI_FLAGS (FSL_SAI_CSR_SEIE |\
> +		       FSL_SAI_CSR_FEIE |\
> +		       FSL_SAI_CSR_FWIE)
> +
> +static irqreturn_t fsl_sai_isr(int irq, void *devid)
> +{
> +	struct fsl_sai *sai = (struct fsl_sai *)devid;
> +	struct device *dev = &sai->pdev->dev;
> +	u32 xcsr;
> +
> +	regmap_read(sai->regmap, FSL_SAI_TCSR, &xcsr);
> +	regmap_write(sai->regmap, FSL_SAI_TCSR, xcsr);

Assuming these are 'write to clear' bits, you might want
to make the write (above) and all the traces (below)
conditional on the value being non-zero.

> +	if (xcsr & FSL_SAI_CSR_WSF)
> +		dev_dbg(dev, "isr: Start of Tx word detected\n");
> +
> +	if (xcsr & FSL_SAI_CSR_SEF)
> +		dev_dbg(dev, "isr: Tx Frame sync error detected\n");
> +
> +	if (xcsr & FSL_SAI_CSR_FEF)
> +		dev_dbg(dev, "isr: Transmit underrun detected\n");
> +
> +	if (xcsr & FSL_SAI_CSR_FWF)
> +		dev_dbg(dev, "isr: Enabled transmit FIFO is empty\n");
> +
> +	if (xcsr & FSL_SAI_CSR_FRF)
> +		dev_dbg(dev, "isr: Transmit FIFO watermark has been reached\n");

Some of those look like 'normal' interrupts, others are clearly
abnormal conditions.
Maybe the tracing should reflect this.

> +
> +	regmap_read(sai->regmap, FSL_SAI_RCSR, &xcsr);
> +	regmap_write(sai->regmap, FSL_SAI_RCSR, xcsr);

Same comments apply...

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
