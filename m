Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaCaNXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:23:12 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:37481 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaCaNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:10 -0400
MIME-Version: 1.0
In-Reply-To: <1396258236.3376.21.camel@smile.fi.intel.com>
References: <1396106920-19015-1-git-send-email-sthokal@xilinx.com>
	<1396106920-19015-2-git-send-email-sthokal@xilinx.com>
	<1396258236.3376.21.camel@smile.fi.intel.com>
Date: Mon, 31 Mar 2014 18:53:08 +0530
X-Google-Sender-Auth: r8HZvSD8aOnuZwS1hGO12PKsngk
Message-ID: <CA+mB=1Lw5AT4LNXwKckmvs3=BFowVQOKHK0pJHvNLZs2_9LR_A@mail.gmail.com>
Subject: Re: [PATCH 2/2] dma: Add Xilinx AXI Direct Memory Access Engine
 driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        dmaengine@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 3:00 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Sat, 2014-03-29 at 20:58 +0530, Srikanth Thokala wrote:
>> This is the driver for the AXI Direct Memory Access (AXI DMA)
>> core, which is a soft Xilinx IP core that provides high-
>> bandwidth direct memory access between memory and AXI4-Stream
>> type target peripherals.
>>
>> This module works on Zynq (ARM Based SoC) and Microblaze platforms.
>
> Few nitpicks below.
>
>>
>> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
>> ---
>> - This driver patch is created on top of earlier series,
>>   1/2 - "dma: Add Xilinx Video DMA DT Binding Documentation"
>>   2/2 - "dma: Add Xilinx AXI Video Direct Memory Access Engine driver support"
>> - Rebased on v3.14.0-rc8

[...]

>> +
>> +     for (i = 0; i < XILINX_DMA_NUM_DESCS; i++) {
>> +             chan->seg_v[i].hw.next_desc =
>> +                             chan->seg_p + sizeof(*chan->seg_v) *
>> +                             ((i + 1) % XILINX_DMA_NUM_DESCS);
>> +             chan->seg_v[i].phys =
>> +                             chan->seg_p + sizeof(*chan->seg_v) *
>> +                             (i % XILINX_DMA_NUM_DESCS);
>
> i can't be higher than NUM_DESCS - 1, thus, i % XILINX_DMA_NUM_DESCS =
> i.

I will correct it, Thanks.

>
>> +             list_add_tail(&chan->seg_v[i].node, &chan->free_seg_list);
>> +     }
>> +
>> +     dma_cookie_init(dchan);
>> +     return 0;
>> +}
>> +

[...]

>> +
>> +/**
>> + * xilinx_dma_is_running - Check if DMA channel is running
>> + * @chan: Driver specific DMA channel
>> + *
>> + * Return: '1' if running, '0' if not.
>
> true, false.

Ok.

>
>> + */
>> +static bool xilinx_dma_is_running(struct xilinx_dma_chan *chan)
>> +{
>> +     return !(dma_ctrl_read(chan, XILINX_DMA_REG_STATUS) &
>> +              XILINX_DMA_SR_HALTED_MASK) &&
>> +             (dma_ctrl_read(chan, XILINX_DMA_REG_CONTROL) &
>> +              XILINX_DMA_CR_RUNSTOP_MASK);
>> +}
>> +
>> +/**
>> + * xilinx_dma_is_idle - Check if DMA channel is idle
>> + * @chan: Driver specific DMA channel
>> + *
>> + * Return: '1' if idle, '0' if not.
>
> Ditto.

Ok.

>
>> + */
>> +static bool xilinx_dma_is_idle(struct xilinx_dma_chan *chan)
>> +{
>> +     return dma_ctrl_read(chan, XILINX_DMA_REG_STATUS) &
>> +             XILINX_DMA_SR_IDLE_MASK;
>> +}
>> +
>> +/**
>> + * xilinx_dma_halt - Halt DMA channel

[...]

>> +                             goto error;
>> +
>> +                     /*
>> +                      * Calculate the maximum number of bytes to transfer,
>> +                      * making sure it is less than the hw limit
>> +                      */
>> +                     copy = min((size_t)(sg_dma_len(sg) - sg_used),
>> +                                     (size_t)XILINX_DMA_MAX_TRANS_LEN);
>
> min_t(size_t, ...)

Ok, I will correct it.

>
>
>> +                     hw = &(segment->hw);
>
> Seems useless parentheses.

Ok.

>
>> +
>> +                     /* Fill in the descriptor */
>> +                     hw->buf_addr = sg_dma_address(sg) + sg_used;
>> +
>> +                     hw->control = copy;
>> +
>> +                     if ((direction == DMA_MEM_TO_DEV) && app_w)
>> +                             memcpy(hw->app, app_w,
>> +                                     sizeof(u32) * XILINX_DMA_NUM_APP_WORDS);
>> +
>> +                     /* For the first DMA_MEM_TO_DEV transfer, set SOP */
>> +                     if (!i)
>> +                             if (direction == DMA_MEM_TO_DEV)
>> +                                     hw->control |= XILINX_DMA_BD_SOP;
>
> You may group previous conditions like
> if (direction = ...) {
>  if (app_w)
>  ...
>  if (!i)
>  ...
> }
>
> But it's up to you.

I will organize them, Thanks.

>
>> +
>> +                     sg_used += copy;
>> +
>> +                     /*
>> +                      * Insert the segment into the descriptor segments
>> +                      * list.
>> +                      */
>> +                     list_add_tail(&segment->node, &desc->segments);
>> +             }
>> +     }
>> +

[...]

>> +             return -EINVAL;
>> +     }
>> +
>> +     /* find the IRQ line, if it exists in the device tree */
>
> Maybe first letter should be capital across all comments in the code?

Ok, I will correct them in all places, if any.

Srikanth

[...]

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
