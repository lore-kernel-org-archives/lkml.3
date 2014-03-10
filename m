Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaCJSbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:31:04 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34644 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaCJSbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:31:01 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY1y1sOozVU=iAsotWG-q3N=SogjHjZ=iF04CiXF89eeOg@mail.gmail.com>
References: <1394104717-3100-1-git-send-email-sthokal@xilinx.com>
	<1394104717-3100-3-git-send-email-sthokal@xilinx.com>
	<CABb+yY1y1sOozVU=iAsotWG-q3N=SogjHjZ=iF04CiXF89eeOg@mail.gmail.com>
Date: Tue, 11 Mar 2014 00:00:59 +0530
X-Google-Sender-Auth: wRJPXUT2X5TnO0eLpZq6D3UDfXQ
Message-ID: <CA+mB=1J6Lzy5fZ6+fU0xY5zLyeDtrjtUpJCYdM7eL-tsQ+jUVA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Levente Kurusa <levex@linux.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        dmaengine@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 9:30 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Thu, Mar 6, 2014 at 7:18 PM, Srikanth Thokala <sthokal@xilinx.com> wrote:
>
>> +static struct dma_async_tx_descriptor *
>> +xilinx_vdma_dma_prep_interleaved(struct dma_chan *dchan,
>> +                                struct dma_interleaved_template *xt,
>> +                                unsigned long flags)
>> +{
>> +       struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
>> +       struct xilinx_vdma_tx_descriptor *desc;
>> +       struct xilinx_vdma_tx_segment *segment;
>> +       struct xilinx_vdma_tx_segment *prev = NULL;
>> +       int i;
>> +
>> +       if ((xt->dir != DMA_MEM_TO_DEV) && (xt->dir != DMA_DEV_TO_MEM))
>> +               return NULL;
>> +
>> +       if (!xt->numf || !xt->sgl[0].size)
>> +               return NULL;
>> +
>> +       /* Allocate a transaction descriptor. */
>> +       desc = xilinx_vdma_alloc_tx_descriptor(chan);
>> +       if (!desc)
>> +               return NULL;
>> +
>> +       dma_async_tx_descriptor_init(&desc->async_tx, &chan->common);
>> +       desc->async_tx.tx_submit = xilinx_vdma_tx_submit;
>> +       desc->async_tx.cookie = 0;
>> +       async_tx_ack(&desc->async_tx);
>> +
>> +       /* Build the list of transaction segments. */
>> +       for (i = 0; i < xt->frame_size; i++) {
>> +               struct xilinx_vdma_desc_hw *hw;
>> +
>> +               /* Allocate the link descriptor from DMA pool */
>> +               segment = xilinx_vdma_alloc_tx_segment(chan);
>> +               if (!segment)
>> +                       goto error;
>> +
>> +               /* Fill in the hardware descriptor */
>> +               hw = &segment->hw;
>> +               hw->vsize = xt->numf;
>> +               hw->hsize = xt->sgl[0].size;
>> +               hw->stride = xt->sgl[0].icg <<
>> +                               XILINX_VDMA_FRMDLY_STRIDE_STRIDE_SHIFT;
>>
> It seems the xt->frame_size is (should be?) always going to be 1?
> If yes, the for-loop isn't needed.
> If no, you should probably use 'i' as the index to sgl[], and not always 0.

It can be either
'1':  User can queue each segment and submit all the segments at once as a
      single async tx descriptor.  I am using this for scatter-gather mode of
      operation where the src_start/dst_start is different for each segment.
'Number of frames':  In this case the driver gets contiguous frame buffer memory
      and it prepares segments with addresses as multiples of
src_start/dst_start.

Please let me know if you see any issues in this implementation.

Thanks
Srikanth

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
