Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaDPKLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:11:41 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:45238 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaDPKLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:11:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140416090605.GP32284@intel.com>
References: <1396008222-7058-1-git-send-email-sthokal@xilinx.com>
	<1396008222-7058-3-git-send-email-sthokal@xilinx.com>
	<20140416090605.GP32284@intel.com>
Date: Wed, 16 Apr 2014 15:41:34 +0530
X-Google-Sender-Auth: 0N0OF7xTG2afg7QynJkNn8Z4nW0
Message-ID: <CA+mB=1LDGCY3sN5sL1giOwwqHjD8gG74Yy0dXRS8s+MtDOvxHw@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Levente Kurusa <levex@linux.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        andriy.shevchenko@linux.jf.intel.com,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        dmaengine@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 2:36 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Fri, Mar 28, 2014 at 05:33:42PM +0530, Srikanth Thokala wrote:
>> This is the driver for the AXI Video Direct Memory Access (AXI
>> VDMA) core, which is a soft Xilinx IP core that provides high-
>> bandwidth direct memory access between memory and AXI4-Stream
>> type video target peripherals. The core provides efficient two
>> dimensional DMA operations with independent asynchronous read
>> and write channel operation.
>>
>> This module works on Zynq (ARM Based SoC) and Microblaze platforms.
>
> Okay the series is fine and was going to apply it BUT
> 1) need ack on DT patch..
> 2) issues below on managing the descriptor and resetting the cookie :(

Ok.

>
>> +
>> +/**
>> + * xilinx_vdma_tx_descriptor - Allocate transaction descriptor
>> + * @chan: Driver specific VDMA channel
>> + *
>> + * Return: The allocated descriptor on success and NULL on failure.
>> + */
>> +static struct xilinx_vdma_tx_descriptor *
>> +xilinx_vdma_alloc_tx_descriptor(struct xilinx_vdma_chan *chan)
>> +{
>> +     struct xilinx_vdma_tx_descriptor *desc;
>> +     unsigned long flags;
>> +
>> +     if (chan->allocated_desc)
>> +             return chan->allocated_desc;
> ??
>
>> +
>> +     desc = kzalloc(sizeof(*desc), GFP_KERNEL);
>> +     if (!desc)
>> +             return NULL;
>> +
>> +     spin_lock_irqsave(&chan->lock, flags);
>> +     chan->allocated_desc = desc;
> ah why do you need this?
>
> So this essentailly prevents you from preparing two trasactions at same time as
> you would overwrite??

This will allow to queue up multiple segments on to a single
transaction descriptor.
User will submit this single desc and in the issue_pending() we decode multiple
segments and submit to SG HW engine.  We free up the allocated_desc when it is
submitted to the HW.  This is added after my discussion with Jaswinder, to best
utilize HW SG engine.

>
> You should maintain a list for pending and submitted.

Yes, we maintain two lists pending_list and done_list.

>
>> +     spin_unlock_irqrestore(&chan->lock, flags);
>> +
>> +     INIT_LIST_HEAD(&desc->segments);
>> +
>> +     return desc;
>> +}
>> +
>
>> +/**
>> + * xilinx_vdma_tx_submit - Submit DMA transaction
>> + * @tx: Async transaction descriptor
>> + *
>> + * Return: cookie value on success and failure value on error
>> + */
>> +static dma_cookie_t xilinx_vdma_tx_submit(struct dma_async_tx_descriptor *tx)
>> +{
>> +     struct xilinx_vdma_tx_descriptor *desc = to_vdma_tx_descriptor(tx);
>> +     struct xilinx_vdma_chan *chan = to_xilinx_chan(tx->chan);
>> +     dma_cookie_t cookie;
>> +     unsigned long flags;
>> +     int err;
>> +
>> +     if (chan->err) {
>> +             /*
>> +              * If reset fails, need to hard reset the system.
>> +              * Channel is no longer functional
>> +              */
>> +             err = xilinx_vdma_chan_reset(chan);
>> +             if (err < 0)
>> +                     return err;
>> +     }
>> +
>> +     spin_lock_irqsave(&chan->lock, flags);
>> +
>> +     cookie = dma_cookie_assign(tx);
>> +
>> +     /* Append the transaction to the pending transactions queue. */
>> +     list_add_tail(&desc->node, &chan->pending_list);
>> +
>> +     /* Free the allocated desc */
>> +     chan->allocated_desc = NULL;
>> +
>> +     spin_unlock_irqrestore(&chan->lock, flags);
>> +
>> +     return cookie;
>> +}
>> +
>> +/**
>> + * xilinx_vdma_dma_prep_interleaved - prepare a descriptor for a
>> + *   DMA_SLAVE transaction
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
>> +     if (!is_slave_direction(xt->dir))
>> +             return NULL;
>> +
>> +     if (!xt->numf || !xt->sgl[0].size)
>> +             return NULL;
>> +
>> +     /* Allocate a transaction descriptor. */
>> +     desc = xilinx_vdma_alloc_tx_descriptor(chan);
>> +     if (!desc)
>> +             return NULL;
>> +
>> +     dma_async_tx_descriptor_init(&desc->async_tx, &chan->common);
>> +     desc->async_tx.tx_submit = xilinx_vdma_tx_submit;
>> +     desc->async_tx.cookie = 0;
> why this is initialized in submit.. when you call dma_cookie_assign()

This is while preparing the descs, but I see your point.  I will fix
it in my next version.

Srikanth

>
> --
> ~Vinod
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
