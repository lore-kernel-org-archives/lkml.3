Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaEVPJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:09:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57355 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaEVPJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:09:09 -0400
Date: Thu, 22 May 2014 10:09:06 -0500
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom_bam_dma: Add descriptor flag APIs
Message-ID: <20140522150906.GA22327@qualcomm.com>
References: <1397772242-4048-1-git-send-email-agross@codeaurora.org>
 <20140502162841.GZ32284@intel.com>
 <20140502180827.GA9476@qualcomm.com>
 <20140515173206.GA16858@qualcomm.com>
 <20140522061049.GW21128@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522061049.GW21128@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 11:40:49AM +0530, Vinod Koul wrote:

<snip>

> > > I have 3 different IRQs that can be asserted based on the bit I set in the
> > > hardware descriptor.  The normal IRQ is the INT bit.  However, in some cases the
> > > peripheral protocol requires the use of the EOT or EOB interrupt instead.  The
> > > DMA_PREP_INTERRUPT would only work if I had only 2 choices.
> > 
> > Thinking about this more, I could use the DMA_PREP_INTERRUPT to cover the EOT
> > flag.  However, I might get in a bind later if I need to support the EOB (end of
> > block) interrupt.
> Sorry for delay in this.
> 
> I think it would make sense to use DMA_PREP_INTERRUPT for EOB interrupt. The EOT
> should always be enabled for the cases where it is applicable instead of nomral
> irq.
> 
> That should genrically ocvery your cases, or did we miss anything here

The EOT is not used for every transaction.  It is part of a handshaking
protocol with the attached peripheral, much like the NWD (notify when done).  As
near as I can tell today, no peripheral depends on the EOB, so we could drop it
for now until it is needed and cross this bridge when we need to.

> > 
> > > 
> > > > 
> > > > > 
> > > > > The NWD flag requests that the peripheral wait until the data has been fully
> > > > > processed before signaling an interrupt.
> > > > interrupt for transaction complete or DMA request?
> > > 
> > > This is a special signaling mechanism that holds off the DMA interrupt until the
> > > peripheral actually acks that the data has been processed completely.  This is
> > > required in many cases by the peripheral.  One example is the SPI controller.
> > > At the end of a transaction you are supposed to set the NWD so that the chip
> > > select is de-asserted.
> > 
> > I'm not sure what flag I could map this to... maybe DMA_CTRL_ACK?  or maybe the
> > DMA_PREP_FENCE?  I don't generally like overloading the flags and slightly
> > twisting their intent.  Could we add a flag to denote device ACK?
> Nope lets not override these...

Then I need to add a flag.  Something like DMA_PREP_DEVICE_ACK that denotes that the
attached device needs to ACK the transfer.

Also, one thing I forgot.  For crypto and some of the other blocks, we have
something called command descriptors that can be transferred to the blocks to
provide programming or direction.  The DMA controller has a flag that tells the
attached peripheral that the incoming DMA contains command descriptors.  The dma
descriptors still point to a memory region to transfer, but the contents are
interpreted differently.  This is yet another flag in the descriptor flag
section.  I'd need another flag for this as well.  Something like DMA_PREP_CMD.

We are actively working on upstreaming our crypto block and this will be
required for that to work properly.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
