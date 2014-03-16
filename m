Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaCPOAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 10:00:50 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:65028 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaCPOAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 10:00:47 -0400
MIME-Version: 1.0
In-Reply-To: <1394822501.28803.280.camel@smile.fi.intel.com>
References: <1394819415-2511-1-git-send-email-sthokal@xilinx.com>
	<1394819415-2511-3-git-send-email-sthokal@xilinx.com>
	<1394822501.28803.280.camel@smile.fi.intel.com>
Date: Sun, 16 Mar 2014 19:30:45 +0530
X-Google-Sender-Auth: PdG0sA9T6Zd56sPij9dOynCMUtA
Message-ID: <CA+mB=1Li7_vezwa+fwqmtAwukoB2CpCcV6MQF2eYCLoHDjuvSg@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Levente Kurusa <levex@linux.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        dmaengine@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 12:11 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Fri, 2014-03-14 at 23:20 +0530, Srikanth Thokala wrote:
>> This is the driver for the AXI Video Direct Memory Access (AXI
>> VDMA) core, which is a soft Xilinx IP core that provides high-
>> bandwidth direct memory access between memory and AXI4-Stream
>> type video target peripherals. The core provides efficient two
>> dimensional DMA operations with independent asynchronous read
>> and write channel operation.
>>
>> This module works on Zynq (ARM Based SoC) and Microblaze platforms.
>
> Few comments below.
>

Sure.


> []
>
>> +++ b/drivers/dma/xilinx/xilinx_vdma.c
>
> []
>
>> +/**
>> + * xilinx_vdma_prep_slave_sg - prepare a descriptor for a DMA_SLAVE transaction
>> + * @dchan: DMA channel
>> + * @xt: Interleaved template pointer
>> + * @flags: transfer ack flags
>> + *
>> + * Return: Async transaction descriptor on success and NULL on failure
>> + */
>> +static struct dma_async_tx_descriptor *
>> +xilinx_vdma_dma_prep_interleaved(struct dma_chan *dchan,
>> +                              struct dma_interleaved_template *xt,
>> +                              unsigned long flags)
>> +{
>> +     struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
>> +     struct xilinx_vdma_tx_descriptor *desc;
>> +     struct xilinx_vdma_tx_segment *segment, *prev = NULL;
>> +     struct xilinx_vdma_desc_hw *hw;
>> +
>> +     if ((xt->dir != DMA_MEM_TO_DEV) && (xt->dir != DMA_DEV_TO_MEM))
>> +             return NULL;
>
> !is_slave_direction()

Ok. I will fix it, Thanks.


>
> []
>
>> +static int xilinx_vdma_chan_probe(struct xilinx_vdma_device *xdev,
>> +                               struct device_node *node)
>> +{
>> +     struct xilinx_vdma_chan *chan;
>> +     bool has_dre = false;
>> +     u32 value, width;
>> +     int err;
>
> []
>
>> +     width = value >> 3; /* Convert bits to bytes */
>> +
>> +     /* If data width is greater than 8 bytes, DRE is not in hw */
>> +     if (width > 8)
>> +             has_dre = false;
>> +
>> +     if (!has_dre)
>> +             xdev->common.copy_align = fls(width - 1);
>
> Is width power of two? For me looks like it should be fls(width) - 1;

Yes, the width is always power of two.

>
> So, device can't work with alignment less than defined in this case,
> correct?

Yes, if Data Realignment Engine (DRE) is not present it should be
stream data width aligned.

>
> []
>
>> +/**
>> + * xilinx_vdma_probe - Driver probe function
>> + * @pdev: Pointer to the platform_device structure
>> + *
>> + * Return: '0' on success and failure value on error
>> + */
>> +static int xilinx_vdma_probe(struct platform_device *pdev)
>> +{
>> +     struct device_node *node = pdev->dev.of_node;
>> +     struct xilinx_vdma_device *xdev;
>> +     struct device_node *child;
>> +     struct resource *io;
>> +     u32 num_frames;
>> +     int i, err;
>> +
>> +     dev_info(&pdev->dev, "Probing xilinx axi vdma engine\n");
>
> dev_dbg? Or move this to the end of function and change text to
> something like "Probed ..."

I will go with your second option and I will fix it in my v6.

Thanks
Srikanth

>
>
> --
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
