Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaEOTDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:03:52 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:46919 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaEOTDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:03:49 -0400
Message-ID: <53750F92.8070403@linaro.org>
Date: Thu, 15 May 2014 20:03:46 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, Vinod Koul <vinod.koul@intel.com>
CC: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom_bam_dma: Add descriptor flag APIs
References: <1397772242-4048-1-git-send-email-agross@codeaurora.org> <20140502162841.GZ32284@intel.com> <20140502180827.GA9476@qualcomm.com> <20140515173206.GA16858@qualcomm.com>
In-Reply-To: <20140515173206.GA16858@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 15/05/14 18:32, Andy Gross wrote:
> On Fri, May 02, 2014 at 01:08:27PM -0500, Andy Gross wrote:
>> On Fri, May 02, 2014 at 09:58:41PM +0530, Vinod Koul wrote:
>>> On Thu, Apr 17, 2014 at 05:04:02PM -0500, Andy Gross wrote:
>>>> This patch adds APIs that allow for BAM hardware flags to be set per
>>>> descriptor.  Each one of the new flags informs the attached peripheral of a
>>>> special behavior that is required.
>>>>
>>>> The EOT flag requests that the peripheral assert an end of transaction interrupt
>>>> when that descriptor is complete.  It also results in special signaling protocol
>>>> that is used between the attached peripheral and the core using the DMA
>>>> controller.
>>> DMA_PREP_INTERRUPT ??
>>
>> I have 3 different IRQs that can be asserted based on the bit I set in the
>> hardware descriptor.  The normal IRQ is the INT bit.  However, in some cases the
>> peripheral protocol requires the use of the EOT or EOB interrupt instead.  The
>> DMA_PREP_INTERRUPT would only work if I had only 2 choices.
>
> Thinking about this more, I could use the DMA_PREP_INTERRUPT to cover the EOT
> flag.  However, I might get in a bind later if I need to support the EOB (end of
> block) interrupt.

This is good start, mapping EOT to DMA_PREP_INTERRUPT seems to be much 
appropriate. This will also provide mmci driver with much more generic 
interface than the bam specific function calls.

Only way forward is to tie up this descriptor specific flags to more 
generic flags. Having specific callbacks would introduce limitations in 
using generic device drivers.

Not really sure how we can map EOB/NWD flags without really defining new 
flags. Mapping to other generic flags might be totally confusing to 
people using/interpreting those flags. Needs more discussion on this.



--srini
>
>>
>>>
>>>>
>>>> The NWD flag requests that the peripheral wait until the data has been fully
>>>> processed before signaling an interrupt.
>>> interrupt for transaction complete or DMA request?
>>
>> This is a special signaling mechanism that holds off the DMA interrupt until the
>> peripheral actually acks that the data has been processed completely.  This is
>> required in many cases by the peripheral.  One example is the SPI controller.
>> At the end of a transaction you are supposed to set the NWD so that the chip
>> select is de-asserted.
>
> I'm not sure what flag I could map this to... maybe DMA_CTRL_ACK?  or maybe the
> DMA_PREP_FENCE?  I don't generally like overloading the flags and slightly
> twisting their intent.  Could we add a flag to denote device ACK?
>
