Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab3LOWYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 17:24:39 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:50945 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752016Ab3LOWYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 17:24:37 -0500
Message-ID: <52AE2C0C.80401@gaisler.com>
Date: Sun, 15 Dec 2013 23:24:12 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v3] usb: gadget: Add UDC driver for Aeroflex Gaisler GRUSBDC
References: <1386144838-16403-1-git-send-email-andreas@gaisler.com> <20131212180106.GF1939@saruman.home> <52AABBCE.8000709@gaisler.com> <20131213195234.GE5292@saruman.home>
In-Reply-To: <20131213195234.GE5292@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 08:52 PM, Felipe Balbi wrote:
> Hi,
>
> On Fri, Dec 13, 2013 at 08:48:30AM +0100, Andreas Larsson wrote:
>>> On Wed, Dec 04, 2013 at 09:13:58AM +0100, Andreas Larsson wrote:
>>>> +static void gr_finish_request(struct gr_ep *ep, struct gr_request *req,
>>>> +			      int status)
>>>> +{
>>>> +	struct gr_udc *dev;
>>>> +
>>>> +	list_del_init(&req->queue);
>>>> +
>>>> +	if (likely(req->req.status == -EINPROGRESS))
>>>> +		req->req.status = status;
>>>> +	else
>>>> +		status = req->req.status;
>>>> +
>>>> +	dev = ep->dev;
>>>> +	usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);
>>>> +	gr_free_dma_desc_chain(dev, req);
>>>> +
>>>> +	if (ep->is_in) /* For OUT, actual gets updated bit by bit */
>>>> +		req->req.actual = req->req.length;
>>>> +
>>>> +	if (!status) {
>>>> +		if (ep->is_in)
>>>> +			gr_dbgprint_request("SENT", ep, req);
>>>> +		else
>>>> +			gr_dbgprint_request("RECV", ep, req);
>>>> +	}
>>>> +
>>>> +	/* Prevent changes to ep->queue during callback */
>>>> +	ep->callback = 1;
>>>> +	if (req == dev->ep0reqo && !status) {
>>>> +		if (req->setup)
>>>> +			gr_ep0_setup(dev, req);
>>>> +		else
>>>> +			dev_err(dev->dev,
>>>> +				"Unexpected non setup packet on ep0in\n");
>>>> +	} else if (req->req.complete) {
>>>> +		unsigned long flags;
>>>> +
>>>> +		/*
>>>> +		 * Complete should be called with interrupts disabled according
>>>> +		 * to the contract of struct usb_request
>>>> +		 */
>>>> +		local_irq_save(flags);
>>>
>>> sorry but this driver isn't ready for inclusion. local_irq_save() is a
>>> pretty good hint that there's something wrong in the driver. Consider
>>> the fact that local_irq_save() will disable preemption even when
>>> CONFIG_PREEMPT_FULL is enabled and you have a bit a problem.
>>
>> This connection between local_irq_save and CONFIG_PREEMPT_RT_FULL was
>> unknown to me. Sure, I can disable interrupts right at spin lock
>> time.
>
> that's better.

Alright, I'll put this in v4.


>>> Also, the way you're using thread IRQs is quite wrong. I can't let that
>>> pass and get merged upstream, sorry.
>>
>> What is quite wrong? What is it that I need to fix?
>
> Ideally the hardirq handler should be usually to actually check if
> $this_device generated the IRQ, that should involve reading a IRQSTATUS
> register of some sort.
>
> Sure, check that IRQs are actually enabled, but you also need to read
> STATUS register before waking the thread up.

I agree that that would be preferable. Unfortunately, the hardware lacks 
status register bits that indicates whether interrupts has been 
generated or not. That is why the only check is if interrupts are 
disabled, because that is the only sure way to know that the softirq 
handler does not need to go through everything.

Best regards,
Andreas Larsson

