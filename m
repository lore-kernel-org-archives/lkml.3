Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab3J1M7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:59:15 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:27770 "EHLO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756573Ab3J1M7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:59:10 -0400
Message-ID: <526E5F96.9090904@gaisler.com>
Date: Mon, 28 Oct 2013 13:59:02 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH] usb: gadget: Add UDC driver for Aeroflex Gaisler GRUSBDC
References: <1376316310-27989-1-git-send-email-andreas@gaisler.com> <20130918171506.GQ21559@radagast> <524A8927.6090500@gaisler.com> <20131001141958.GQ1476@radagast>
In-Reply-To: <20131001141958.GQ1476@radagast>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-01 16:19, Felipe Balbi wrote:
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
>>>> +	if (ep->is_in) /* For OUT, actual gets updated by the work handler */
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
>>>> +		/* Complete should be called with irqs disabled */
>>>> +		local_irq_save(flags);
>>>
>>> I guess it'd be better if you called this with spin_lock_irqsave()
>>> called before, then you can remove local_irq_save from here.
>>
>> That would increase the amount of time interrupts are disabled quite a
>> lot, so I would prefer not to.
>
> that's what every other UDC driver is doing. I don't think you need to
> worry about that. Can you run some benchmarks with both constructs just
> so I can have peace of mind ?

Hi!

My benchmark shows 20%+ performance loss both for mass storage running
on this driver and for concurrent ethernet traffic and cpu bound tasks
running with this change. In addition the code becomes messier as some
spin locks disables interrupts and some do not depending on wich paths
might lead to a call to complete. So I'll stick to not disabling
interrupts until disabled interrupts are actually needed.

>>>> +static irqreturn_t gr_irq(int irq, void *_dev)
>>>> +{
>>>> +	struct gr_udc *dev = _dev;
>>>> +
>>>> +	if (!dev->irq_enabled)
>>>> +		return IRQ_NONE;
>>>> +
>>>> +	schedule_work(&dev->work);
>>>
>>> why do you need this ? We have threaded IRQ handlers. Why a workqueue ?
>>
>> As mentioned above, to to be able to schedule work after pausing
>> endpoint handling during a completion callback call or during an
>> endpoint halt.
>
> doesn't look like you need that work_struct at all. Handle your IRQ
> directly and for the pieces you need to do after ClearHalt, re-factor
> that to a separate function which you call conditionally on
> ->set_halt().

For some reason, the performance suffers massively when switching to
using threaded interrupts instead of the current solution using the work
queue. The times to complete large file transfers to the mass_storage
gadget running on top of the udc are regularly around seven times longer
using threaded interrupts complared to using the work queue
solution. Unless you have any ideas here, I hope you can let the driver
keep the work queue solution.

Best regards,
Andreas Larsson
