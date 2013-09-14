Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab3INSd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 14:33:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab3INSdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 14:33:24 -0400
Date: Sat, 14 Sep 2013 20:33:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: djbw@fb.com, vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, max.filippov@cogentembedded.com
Subject: Re: [PATCH v3] dma: add driver for R-Car HPB-DMAC
In-Reply-To: <201308250033.24936.sergei.shtylyov@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1309142017040.28905@axis700.grange>
References: <201308250033.24936.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Pxu+ssksArQf8j0ZLWOXKr1mfJehJEMd9RG/JOvQPql
 yOmBdEd2LxVUdbILeLB93zW72LzQ6GXxmDzGdo8HucOC1kYMUe
 g3du/PbT0iJKJll/XcdLrzSM4BkvL4ng5XEcD5W/ESbheTSDLX
 Jyj3krjj3NiefYb+6ECD2uKwM9PXiNyMhSxfatO/oOK0WF939g
 UnMvPx5Vmb652aRxqhkOPEakVGbK0f8SzcuqrDXzKk7iEPropI
 J2vR+NJBmSJcHHgbOqeZFgHpvChhfKEA7xALfvhZWFKagBO9h5
 PxGCuYSWtZIqYr43j9MOqGKyBvbXJXToNgnfXpAgs0mMkSxtyn
 7gFOkSySO9dvjGm5x3010hp2wiw7nBeFUw06occQVIrLyRdMWJ
 zI6wprVeoSrtA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Aug 2013, Sergei Shtylyov wrote:

> From: Max Filippov <max.filippov@cogentembedded.com>
> 
> Add support for HPB-DMAC found in Renesas R-Car SoCs, using 'shdma-base' DMA 
> driver framework.
> 
> Based on the original patch by Phil Edworthy <phil.edworthy@renesas.com>.
> 
> Signed-off-by: Max Filippov <max.filippov@cogentembedded.com>
> [Sergei: removed useless #include, sorted #include's, fixed HPB_DMA_TCR_MAX,
> fixed formats and removed line breaks in the dev_dbg() calls, rephrased and
> added IRQ # to the shdma_request_irq() failure message, added MODULE_AUTHOR(),
> removed '__init'/'__exit' annotations from the probe()/remove() methods, removed
> '__initdata' annotation from 'hpb_dmae_driver', fixed guard macro name in the
> header file, fixed #define ASYNCRSTR_ASRST20, added #define ASYNCRSTR_ASRST24,
> added the necessary runtime PM calls to the probe() and remove() methods,
> handled errors returned by dma_async_device_register(), beautified comments
> and #define's.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---

[snip]

> Index: slave-dma/drivers/dma/sh/rcar-hpbdma.c
> ===================================================================
> --- /dev/null
> +++ slave-dma/drivers/dma/sh/rcar-hpbdma.c
> @@ -0,0 +1,655 @@

[snip]

> +static int hpb_dmae_chan_probe(struct hpb_dmae_device *hpbdev, int id)
> +{
> +	struct shdma_dev *sdev = &hpbdev->shdma_dev;
> +	struct platform_device *pdev =
> +		to_platform_device(hpbdev->shdma_dev.dma_dev.dev);
> +	struct hpb_dmae_chan *new_hpb_chan;
> +	struct shdma_chan *schan;
> +
> +	/* Alloc channel */
> +	new_hpb_chan = devm_kzalloc(&pdev->dev,
> +				    sizeof(struct hpb_dmae_chan), GFP_KERNEL);
> +	if (!new_hpb_chan) {
> +		dev_err(hpbdev->shdma_dev.dma_dev.dev,
> +			"No free memory for allocating DMA channels!\n");
> +		return -ENOMEM;
> +	}
> +
> +	schan = &new_hpb_chan->shdma_chan;

A suggestion for an incremental patch - you might want to initialise the
max_xfer_len field like

	schan->max_xfer_len = 64 * 1024 * 1024 - 1;

because if it isn't initialised your max transfer length will be 4k,
which will hurt your performance. I think you should get a better
throughput after that

> +	shdma_chan_probe(sdev, schan, id);
> +
> +	if (pdev->id >= 0)
> +		snprintf(new_hpb_chan->dev_id, sizeof(new_hpb_chan->dev_id),
> +			 "hpb-dmae%d.%d", pdev->id, id);
> +	else
> +		snprintf(new_hpb_chan->dev_id, sizeof(new_hpb_chan->dev_id),
> +			 "hpb-dma.%d", id);
> +
> +	return 0;
> +}

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
