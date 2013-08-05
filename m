Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab3HEWnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:43:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46858 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab3HEWnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:43:01 -0400
Message-ID: <52002A6E.6010203@ti.com>
Date: Mon, 5 Aug 2013 15:42:54 -0700
From: Russ Dill <Russ.Dill@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Zubair Lutfullah: <zubair.lutfullah@gmail.com>, ;
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>, <jic23@cam.ac.uk>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] input: ti_tsc: Enable shared IRQ for TSC
References: <1374882674-18403-1-git-send-email-zubair.lutfullah@gmail.com> <1374882674-18403-2-git-send-email-zubair.lutfullah@gmail.com> <51FE361B.5030900@kernel.org> <20130805161256.GA8794@core.coreip.homeip.net> <20130805170201.GA4310@gmail.com>
In-Reply-To: <20130805170201.GA4310@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 10:02 AM, Zubair Lutfullah : wrote:
> On Mon, Aug 05, 2013 at 09:12:56AM -0700, Dmitry Torokhov wrote:
>>>> Touchscreen and ADC share the same IRQ line from parent MFD core.
>>>> Previously only Touchscreen was interrupt based.
>>>> With continuous mode support added in ADC driver, driver requires
>>>> interrupt to process the ADC samples, so enable shared IRQ flag bit for
>>>> touchscreen.
>>>>
>>>> @@ -260,8 +260,18 @@ static irqreturn_t titsc_irq(int irq, void *dev)
>>>>  	unsigned int fsm;
>>>>  
>>>> +	/*
>>>> +	 * ADC and touchscreen share the IRQ line.
>>>> +	 * FIFO1 threshold, FIFO1 Overrun and FIFO1 underflow
>>>> +	 * interrupts are used by ADC,
>>>> +	 * hence return from touchscreen IRQ handler if FIFO1
>>>> +	 * related interrupts occurred.
>>>> +	 */
>>>> +	if ((status & IRQENB_FIFO1THRES) ||
>>>> +			(status & IRQENB_FIFO1OVRRUN) ||
>>>> +			(status & IRQENB_FIFO1UNDRFLW))
>>>> +		return IRQ_NONE;
>>>> +	else if (status & IRQENB_FIFO0THRES) {
>>
>> What happens if both parts have data at the same time? Can both
>> IRQENB_FIFO1THRES and IRQENB_FIFO0THRES be signalled? What will happen
>> in this case?
> 
> If ADC is sampling and someone is touching the TSC, both interrupts
> can signal so closely that for the purpose of the kernel,
> they can be seen as signaled together.
> 
> FIFO 1 used only by ADC and FIFO1THRES handler is inside the iio/adc driver
> FIFO 0 used only by TSC and FIFO0THRES handler is inside the input/touchscreen
> 
> Note: These are level interrupts.
> 
> I would like some input on how to handle such a situation. 
> 
> Thanks
> Zubair Lutfullah
> 

As far as I know, if there are any bits you can handle and ack, do so
and return IRQ_HANDLED. Otherwise, return IRQ_NONE. If there are still
pending bits, the interrupt will fire again, your handler will be called
again, return IRQ_NONE, and the next handler will be called.
