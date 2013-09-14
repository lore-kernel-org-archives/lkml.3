Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab3INTEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 15:04:23 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:53964 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab3INTEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:04:21 -0400
Message-ID: <5234B33A.8040409@cogentembedded.com>
Date: Sat, 14 Sep 2013 23:04:26 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: djbw@fb.com, vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, max.filippov@cogentembedded.com
Subject: Re: [PATCH v3] dma: add driver for R-Car HPB-DMAC
References: <201308250033.24936.sergei.shtylyov@cogentembedded.com> <Pine.LNX.4.64.1309142017040.28905@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1309142017040.28905@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/14/2013 10:33 PM, Guennadi Liakhovetski wrote:

>> From: Max Filippov <max.filippov@cogentembedded.com>

>> Add support for HPB-DMAC found in Renesas R-Car SoCs, using 'shdma-base' DMA
>> driver framework.

>> Based on the original patch by Phil Edworthy <phil.edworthy@renesas.com>.

>> Signed-off-by: Max Filippov <max.filippov@cogentembedded.com>
>> [Sergei: removed useless #include, sorted #include's, fixed HPB_DMA_TCR_MAX,
>> fixed formats and removed line breaks in the dev_dbg() calls, rephrased and
>> added IRQ # to the shdma_request_irq() failure message, added MODULE_AUTHOR(),
>> removed '__init'/'__exit' annotations from the probe()/remove() methods, removed
>> '__initdata' annotation from 'hpb_dmae_driver', fixed guard macro name in the
>> header file, fixed #define ASYNCRSTR_ASRST20, added #define ASYNCRSTR_ASRST24,
>> added the necessary runtime PM calls to the probe() and remove() methods,
>> handled errors returned by dma_async_device_register(), beautified comments
>> and #define's.]
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

>> ---

> [snip]

>> Index: slave-dma/drivers/dma/sh/rcar-hpbdma.c
>> ===================================================================
>> --- /dev/null
>> +++ slave-dma/drivers/dma/sh/rcar-hpbdma.c
>> @@ -0,0 +1,655 @@

> [snip]

>> +static int hpb_dmae_chan_probe(struct hpb_dmae_device *hpbdev, int id)
>> +{
>> +	struct shdma_dev *sdev = &hpbdev->shdma_dev;
>> +	struct platform_device *pdev =
>> +		to_platform_device(hpbdev->shdma_dev.dma_dev.dev);
>> +	struct hpb_dmae_chan *new_hpb_chan;
>> +	struct shdma_chan *schan;
>> +
>> +	/* Alloc channel */
>> +	new_hpb_chan = devm_kzalloc(&pdev->dev,
>> +				    sizeof(struct hpb_dmae_chan), GFP_KERNEL);
>> +	if (!new_hpb_chan) {
>> +		dev_err(hpbdev->shdma_dev.dma_dev.dev,
>> +			"No free memory for allocating DMA channels!\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	schan = &new_hpb_chan->shdma_chan;

> A suggestion for an incremental patch - you might want to initialise the
> max_xfer_len field like

> 	schan->max_xfer_len = 64 * 1024 * 1024 - 1;

    IIRC, the HPB-DMAC's maximum transfer length is 16 MiB, without -1. You 
probably mixed it with LBSC-DMAC which is indeed capable of 64 MiB.

> because if it isn't initialised your max transfer length will be 4k,
> which will hurt your performance. I think you should get a better
> throughput after that

    OK, note taken. We'll look into it.

WBR, Sergei

