Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaCKSco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:32:44 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:45833 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaCKScm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:32:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_Zhej0-i4uEPvXr3XH_8Qzd7SD-3yvJOp+MW4j+KJ8rt1PQ@mail.gmail.com>
References: <1394104717-3100-1-git-send-email-sthokal@xilinx.com>
	<1394104717-3100-3-git-send-email-sthokal@xilinx.com>
	<CABb+yY1y1sOozVU=iAsotWG-q3N=SogjHjZ=iF04CiXF89eeOg@mail.gmail.com>
	<CA+mB=1J6Lzy5fZ6+fU0xY5zLyeDtrjtUpJCYdM7eL-tsQ+jUVA@mail.gmail.com>
	<CAJe_Zhej0-i4uEPvXr3XH_8Qzd7SD-3yvJOp+MW4j+KJ8rt1PQ@mail.gmail.com>
Date: Wed, 12 Mar 2014 00:02:40 +0530
X-Google-Sender-Auth: AHce1kfeKbEPm4cEh_TwRj_-d8Q
Message-ID: <CA+mB=1JMsUojCE4+AtR2D5znNBv=YXGiFxLkJeJ77cZdTgCuZw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Levente Kurusa <levex@linux.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 7:14 PM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> On 11 March 2014 00:00, Srikanth Thokala <sthokal@xilinx.com> wrote:
>> On Mon, Mar 10, 2014 at 9:30 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>>> On Thu, Mar 6, 2014 at 7:18 PM, Srikanth Thokala <sthokal@xilinx.com> wrote:
>>>
>>>> +static struct dma_async_tx_descriptor *
>>>> +xilinx_vdma_dma_prep_interleaved(struct dma_chan *dchan,
>>>> +                                struct dma_interleaved_template *xt,
>>>> +                                unsigned long flags)
>>>> +{
>>>> +       struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
>>>> +       struct xilinx_vdma_tx_descriptor *desc;
>>>> +       struct xilinx_vdma_tx_segment *segment;
>>>> +       struct xilinx_vdma_tx_segment *prev = NULL;
>>>> +       int i;
>>>> +
>>>> +       if ((xt->dir != DMA_MEM_TO_DEV) && (xt->dir != DMA_DEV_TO_MEM))
>>>> +               return NULL;
>>>> +
>>>> +       if (!xt->numf || !xt->sgl[0].size)
>>>> +               return NULL;
>>>> +
>>>> +       /* Allocate a transaction descriptor. */
>>>> +       desc = xilinx_vdma_alloc_tx_descriptor(chan);
>>>> +       if (!desc)
>>>> +               return NULL;
>>>> +
>>>> +       dma_async_tx_descriptor_init(&desc->async_tx, &chan->common);
>>>> +       desc->async_tx.tx_submit = xilinx_vdma_tx_submit;
>>>> +       desc->async_tx.cookie = 0;
>>>> +       async_tx_ack(&desc->async_tx);
>>>> +
>>>> +       /* Build the list of transaction segments. */
>>>> +       for (i = 0; i < xt->frame_size; i++) {
>>>> +               struct xilinx_vdma_desc_hw *hw;
>>>> +
>>>> +               /* Allocate the link descriptor from DMA pool */
>>>> +               segment = xilinx_vdma_alloc_tx_segment(chan);
>>>> +               if (!segment)
>>>> +                       goto error;
>>>> +
>>>> +               /* Fill in the hardware descriptor */
>>>> +               hw = &segment->hw;
>>>> +               hw->vsize = xt->numf;
>>>> +               hw->hsize = xt->sgl[0].size;
>>>> +               hw->stride = xt->sgl[0].icg <<
>>>> +                               XILINX_VDMA_FRMDLY_STRIDE_STRIDE_SHIFT;
>>>>
>>> It seems the xt->frame_size is (should be?) always going to be 1?
>>> If yes, the for-loop isn't needed.
>>> If no, you should probably use 'i' as the index to sgl[], and not always 0.
>>
>> It can be either
>> '1':  User can queue each segment and submit all the segments at once as a
>>       single async tx descriptor.  I am using this for scatter-gather mode of
>>       operation where the src_start/dst_start is different for each segment.
>> 'Number of frames':  In this case the driver gets contiguous frame buffer memory
>>       and it prepares segments with addresses as multiples of
>> src_start/dst_start.
>>
> Quoting you from earlier thread ....
> " In video frame context,
> chunk.size -> hsize
> chunk.icg -> stride
> numf -> vsize
> and frame_size is always 1 as it will have only one chunk in a line. "
>  ... which makes sense.
>
> I hope you realize that, 'frame_size' denotes the number of chunks in
> a frame and 'numf' denotes the number of frames in the transfer
> request. It seems wrong when you assume  vsize:=numf  but
> frame_size>1 ... i.e, each horizontal video line has two or more
> dis-contiguous chunks?   This might work for client drivers written
> specifically for Xilinx AXI Video DMAC but will fail over any other
> controller driver.
>
>  IMO, xilinx_vdma.c should expect only 1 video frame per
> device_prep_interleaved_dma() call (i.e, vsize=numf and frame_size==1)
>   Let the client driver submit 1/2/.../16 requests before kick
> starting the DMA. Upon  dma_async_tx_descriptor.callback(), the client
> 'refills' the frame and re-queues it back. This should work because
> the video-frames' attributes and locations are not going to change
> within a session.
>
>> Please let me know if you see any issues in this implementation.
>>
> I am ok if you want the driver upstream now and want to 'fix' it when
> you actually start seeing problems :)

I agree with you and I have no issues in fixing this now.  I will fix
it in my v6
with the driver accepting only one frame/interleave_dma call.

But, I feel this information has to be documented to the description of
interleaved_dma API as it is leading to interpret the members of this
structure differently wrt video frame terminology.

Thanks
Srikanth

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
