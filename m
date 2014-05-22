Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaEVP1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:27:12 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52163 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaEVP1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:27:09 -0400
Message-ID: <537E1749.1030505@linaro.org>
Date: Thu, 22 May 2014 16:27:05 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, Vinod Koul <vinod.koul@intel.com>
CC: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom_bam_dma: Add descriptor flag APIs
References: <1397772242-4048-1-git-send-email-agross@codeaurora.org> <20140502162841.GZ32284@intel.com> <20140502180827.GA9476@qualcomm.com> <20140515173206.GA16858@qualcomm.com> <20140522061049.GW21128@intel.com> <20140522150906.GA22327@qualcomm.com>
In-Reply-To: <20140522150906.GA22327@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/05/14 16:09, Andy Gross wrote:
> On Thu, May 22, 2014 at 11:40:49AM +0530, Vinod Koul wrote:
>
> <snip>
>
>>>> I have 3 different IRQs that can be asserted based on the bit I set in the
>>>> hardware descriptor.  The normal IRQ is the INT bit.  However, in some cases the
>>>> peripheral protocol requires the use of the EOT or EOB interrupt instead.  The
>>>> DMA_PREP_INTERRUPT would only work if I had only 2 choices.
>>>
>>> Thinking about this more, I could use the DMA_PREP_INTERRUPT to cover the EOT
>>> flag.  However, I might get in a bind later if I need to support the EOB (end of
>>> block) interrupt.
>> Sorry for delay in this.
>>
>> I think it would make sense to use DMA_PREP_INTERRUPT for EOB interrupt. The EOT
>> should always be enabled for the cases where it is applicable instead of nomral
>> irq.
>>
>> That should genrically ocvery your cases, or did we miss anything here
>
> The EOT is not used for every transaction.  It is part of a handshaking
> protocol with the attached peripheral, much like the NWD (notify when done).  As
> near as I can tell today, no peripheral depends on the EOB, so we could drop it
> for now until it is needed and cross this bridge when we need to.

As EOT behaviour is totally dependent on the attached peripheral(or 
channel), Can't we make this specific to channel by passing additional 
flags in the DT dma channel descriptors? This will be better abstraction 
for drivers as well.

I know that EOT flag is part of descriptor but still some channels 
*must* have EOT to run there state-machine correctly. So making it 
optional for those channels might be wrong.

Are there any use cases for particular *channel* where EOT requirement 
changes dynamically?



--srini

>
>>>
>>>>
>>>>>
>>>>>>
>>>>>> The NWD flag requests that the peripheral wait until the data has been fully
>>>>>> processed before signaling an interrupt.
>>>>> interrupt for transaction complete or DMA request?
>>>>
>>>> This is a special signaling mechanism that holds off the DMA interrupt until the
>>>> peripheral actually acks that the data has been processed completely.  This is
>>>> required in many cases by the peripheral.  One example is the SPI controller.
>>>> At the end of a transaction you are supposed to set the NWD so that the chip
>>>> select is de-asserted.
>>>
>>> I'm not sure what flag I could map this to... maybe DMA_CTRL_ACK?  or maybe the
>>> DMA_PREP_FENCE?  I don't generally like overloading the flags and slightly
>>> twisting their intent.  Could we add a flag to denote device ACK?
>> Nope lets not override these...
>
> Then I need to add a flag.  Something like DMA_PREP_DEVICE_ACK that denotes that the
> attached device needs to ACK the transfer.
>
> Also, one thing I forgot.  For crypto and some of the other blocks, we have
> something called command descriptors that can be transferred to the blocks to
> provide programming or direction.  The DMA controller has a flag that tells the
> attached peripheral that the incoming DMA contains command descriptors.  The dma
> descriptors still point to a memory region to transfer, but the contents are
> interpreted differently.  This is yet another flag in the descriptor flag
> section.  I'd need another flag for this as well.  Something like DMA_PREP_CMD.
>
> We are actively working on upstreaming our crypto block and this will be
> required for that to work properly.
>
