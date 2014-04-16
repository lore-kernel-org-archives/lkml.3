Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbaDPLbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:31:14 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39916 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbaDPLbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:31:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140416102657.GS32284@intel.com>
References: <1396008222-7058-1-git-send-email-sthokal@xilinx.com>
	<1396008222-7058-3-git-send-email-sthokal@xilinx.com>
	<20140416090605.GP32284@intel.com>
	<CA+mB=1LDGCY3sN5sL1giOwwqHjD8gG74Yy0dXRS8s+MtDOvxHw@mail.gmail.com>
	<20140416102657.GS32284@intel.com>
Date: Wed, 16 Apr 2014 17:01:10 +0530
X-Google-Sender-Auth: i8KHw6PzOcrwbdUArcGlDrQ-WIA
Message-ID: <CA+mB=1KJv=mZ8m6YU5q9KTv-LK59Dmb+p=aFJkvtCbrksojhaw@mail.gmail.com>
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

On Wed, Apr 16, 2014 at 3:56 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Wed, Apr 16, 2014 at 03:41:34PM +0530, Srikanth Thokala wrote:
>> On Wed, Apr 16, 2014 at 2:36 PM, Vinod Koul <vinod.koul@intel.com> wrote:
>> > On Fri, Mar 28, 2014 at 05:33:42PM +0530, Srikanth Thokala wrote:
>> >> This is the driver for the AXI Video Direct Memory Access (AXI
>> >> VDMA) core, which is a soft Xilinx IP core that provides high-
>> >> bandwidth direct memory access between memory and AXI4-Stream
>> >> type video target peripherals. The core provides efficient two
>> >> dimensional DMA operations with independent asynchronous read
>> >> and write channel operation.
>> >>
>> >> This module works on Zynq (ARM Based SoC) and Microblaze platforms.
>> >
>> > Okay the series is fine and was going to apply it BUT
>> > 1) need ack on DT patch..
>> > 2) issues below on managing the descriptor and resetting the cookie :(
>>
>> Ok.
>>
>> >
>> >> +
>> >> +/**
>> >> + * xilinx_vdma_tx_descriptor - Allocate transaction descriptor
>> >> + * @chan: Driver specific VDMA channel
>> >> + *
>> >> + * Return: The allocated descriptor on success and NULL on failure.
>> >> + */
>> >> +static struct xilinx_vdma_tx_descriptor *
>> >> +xilinx_vdma_alloc_tx_descriptor(struct xilinx_vdma_chan *chan)
>> >> +{
>> >> +     struct xilinx_vdma_tx_descriptor *desc;
>> >> +     unsigned long flags;
>> >> +
>> >> +     if (chan->allocated_desc)
>> >> +             return chan->allocated_desc;
>> > ??
>> >
>> >> +
>> >> +     desc = kzalloc(sizeof(*desc), GFP_KERNEL);
>> >> +     if (!desc)
>> >> +             return NULL;
>> >> +
>> >> +     spin_lock_irqsave(&chan->lock, flags);
>> >> +     chan->allocated_desc = desc;
>> > ah why do you need this?
>> >
>> > So this essentailly prevents you from preparing two trasactions at same time as
>> > you would overwrite??
>>
>> This will allow to queue up multiple segments on to a single
>> transaction descriptor.
>> User will submit this single desc and in the issue_pending() we decode multiple
>> segments and submit to SG HW engine.  We free up the allocated_desc when it is
>> submitted to the HW.  This is added after my discussion with Jaswinder, to best
>> utilize HW SG engine.
>
> I think best utilization of HW SG engine would happen if we collate the pending
> list when you start dma....

Is that ok if I revisit this code as an enhancement at a later time?

Srikanth

>
> --
> ~Vinod
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
