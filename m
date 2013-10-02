Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab3JBIwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 04:52:38 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:33128 "EHLO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945Ab3JBIwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:52:35 -0400
Message-ID: <524BDEB6.8060404@gaisler.com>
Date: Wed, 02 Oct 2013 10:52:06 +0200
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
> Hi,
>
> On Tue, Oct 01, 2013 at 10:34:47AM +0200, Andreas Larsson wrote:
>>>> +/* #define VERBOSE_DEBUG */
>>>
>>> we don't want this, we want verbose debug to be selectable on Kconfig,
>>> which already is ;-)
>>
>> I was only aware of CONFIG_USB_GADGET_DEBUG leading to DEBUG being
>> defined, not that any Kconfig turned on VERBOSE_DEBUG. Where is this
>> happening?
>
> you're right there :-) My bad. Do you mind adding a patch which sets
> VERBOSE_DEBUG when building drivers/usb/gadget/ directory ?
> drivers/usb/dwc3/ has an example, if you need ;-)

Sure, I'll do that.

>
> Or I can patch that myself, if you prefer. works both ways.
>
>>>> +#include "gr_udc.h"
>>>> +
>>>> +#define	DRIVER_NAME	"gr_udc"
>>>> +#define	DRIVER_DESC	"Aeroflex Gaisler GRUSBDC USB Peripheral Controller"
>>>> +
>>>> +static const char driver_name[] = DRIVER_NAME;
>>>> +static const char driver_desc[] = DRIVER_DESC;
>>>> +
>>>> +#define gr_read32(x) (ioread32be((x)))
>>>> +#define gr_write32(x, v) (iowrite32be((v), (x)))
>>>> +
>>>> +/* USB speed and corresponding string calculated from status register value */
>>>> +#define GR_SPEED(status) \
>>>> +	((status & GR_STATUS_SP) ? USB_SPEED_FULL : USB_SPEED_HIGH)
>>>> +#define GR_SPEED_STR(status) usb_speed_string(GR_SPEED(status))
>>>> +
>>>> +/* Size of hardware buffer calculated from epctrl register value */
>>>> +#define GR_BUFFER_SIZE(epctrl)					      \
>>>> +	((((epctrl) & GR_EPCTRL_BUFSZ_MASK) >> GR_EPCTRL_BUFSZ_POS) * \
>>>> +	 GR_EPCTRL_BUFSZ_SCALER)
>>>> +
>>>> +/* ---------------------------------------------------------------------- */
>>>> +/* Debug printout functionality */
>>>> +
>>>> +static const char * const gr_modestring[] = {"control", "iso", "bulk", "int"};
>>>> +
>>>> +static const char *gr_ep0state_string(enum gr_ep0state state)
>>>> +{
>>>> +	static const char *const names[] = {
>>>> +		[GR_EP0_DISCONNECT] = "disconnect",
>>>> +		[GR_EP0_SETUP] = "setup",
>>>> +		[GR_EP0_IDATA] = "idata",
>>>> +		[GR_EP0_ODATA] = "odata",
>>>> +		[GR_EP0_ISTATUS] = "istatus",
>>>> +		[GR_EP0_OSTATUS] = "ostatus",
>>>> +		[GR_EP0_STALL] = "stall",
>>>> +		[GR_EP0_SUSPEND] = "suspend",
>>>> +	};
>>>> +
>>>> +	if (state < 0 || state >= ARRAY_SIZE(names))
>>>> +		return "UNKNOWN";
>>>> +
>>>> +	return names[state];
>>>> +}
>>>> +
>>>> +#ifdef VERBOSE_DEBUG
>>>> +
>>>> +#define BPRINTF(buf, left, fmt, args...)			\
>>>> +	do {							\
>>>> +		int ret = snprintf(buf, left, fmt, ## args);	\
>>>> +		buf += ret;					\
>>>> +		left -= ret;					\
>>>> +	} while (0)
>>>
>>> nack, use dev_vdbg() instead.
>>>
>>>> +static void gr_dbgprint_request(const char *str, struct gr_ep *ep,
>>>> +				struct gr_request *req)
>>>> +{
>>>> +	char buffer[100];
>>>
>>> NAK^10000000
>>>
>>> use kernel facilities instead. printk() and all its friends already
>>> print to a ring buffer.
>>
>> Alright. The concern was that repeatedly calling printk for multiple
>> parts of the same message could lead to intermixing with other unrelated
>> printouts.
>
> hmm, there are two ways to look at this.
>
> a) we have KERN_CONT to continue printing messages
> b) you might prefer using debugfs and seq_puts() for dumping large(-ish)
> amounts of debugging data ;-)

I just found print_hex_dump_debug that takes care of everything 
including dynamic debug support, so I'll use that.

>
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

I'll look into this.

>
>>>> +		spin_unlock(&dev->lock);
>>>> +
>>>> +		req->req.complete(&ep->ep, &req->req);
>>>> +
>>>> +		spin_lock(&dev->lock);
>>>> +		local_irq_restore(flags);
>>>> +	}
>>>> +	ep->callback = 0;
>>>> +
>>>> +	/* Catch up possible prevented ep handling during completion callback */
>>>> +	if (!ep->stopped)
>>>> +		schedule_work(&dev->work);
>>>
>>> this workqueue is awkward, what's up with that ?
>>
>> The reason for the scheduling here is that during the completion call
>> the handling of endpoint events needs to be stopped. This is
>> accomplished by the ep->callback flag. When that is done we might have
>> ep events that needs to be taken care of.
>>
>> The same situation arises after unhalting an endpoint further down. All
>> potential handling of that endpoint was on pause during halt, and thus
>> the work handler needs to be scheduled to catch up.
>
> not so sure. Other UDC drivers also support EP halt and they don't need
> the workqueue at all.
>
>>>> +/* Call with non-NULL dev to do a devm-allocation */
>>>> +static struct usb_request *__gr_alloc_request(struct device *dev,
>>>> +					      struct usb_ep *_ep,
>>>> +					      gfp_t gfp_flags)
>>>> +{
>>>> +	struct gr_request *req;
>>>> +
>>>> +	if (dev)
>>>> +		req = devm_kzalloc(dev, sizeof(*req), gfp_flags);
>>>> +	else
>>>> +		req = kzalloc(sizeof(*req), gfp_flags);
>>>
>>> why would "dev" ever be NULL ?
>>
>> When the gadget allocates a request it will free it explicitely later
>> on. Thus there is no need for any devm allocation. Therefore, the calls
>> from the gadget to gr_alloc_request then calls this function with a NULL
>> argument so that non-devm allocation is done in that case.
>
> then couldn't you just stick with direct kzalloc() instead of trying to
> use devm_kzalloc() for allocating requests ?

Alright.

>
> That's the righ way to handle usb_request lifetime anyway; leave it to
> the gadget driver. If that gadget driver doesn't free the usb_requests
> it allocated, we want the memory leak as an indication of a buggy
> gadget driver.
>
>>>> +	epctrl = gr_read32(&ep->regs->epctrl);
>>>> +	if (halt) {
>>>> +		/* Set HALT */
>>>> +		gr_write32(&ep->regs->epctrl, epctrl | GR_EPCTRL_EH);
>>>> +		ep->stopped = 1;
>>>> +		if (wedge)
>>>> +			ep->wedged = 1;
>>>> +	} else {
>>>> +		gr_write32(&ep->regs->epctrl, epctrl & ~GR_EPCTRL_EH);
>>>> +		ep->stopped = 0;
>>>> +		ep->wedged = 0;
>>>> +
>>>> +		/* Things might have been queued up in the meantime */
>>>> +		if (!ep->dma_start)
>>>> +			gr_start_dma(ep);
>>>> +
>>>> +		/* Ep handling might have been hindered during halt */
>>>> +		schedule_work(&ep->dev->work);
>>
>> Here is the second place where we need to schedule work as mentioned
>> above.
>
> that's fine, but we still have other gadget drivers which don't take the
> route of a workqueue after unhalting the endpoint.
>
> If the endpoint is halted, why do you even have anything to process at
> all for this endpoint ? nothing should have been queued, right ?
>
> And if you did queue requests while EP was halted, you could just
> restart your EP queue right here, instead of scheduling a work_struct to
> do that for you.
>
>>>> +	}
>>>> +
>>>> +	return retval;
>>>> +}
>>>> +
>>>> +/* Must be called with dev->lock held */
>>>> +static inline void gr_set_ep0state(struct gr_udc *dev, enum gr_ep0state value)
>>>> +{
>>>> +	if (dev->ep0state != value)
>>>> +		VDBG("STATE:  ep0state=%s\n",
>>>> +		     gr_ep0state_string(value));
>>>
>>> dev_vdbg()
>>>
>>>> +	dev->ep0state = value;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Should only be called when endpoints can not generate interrupts.
>>>> + *
>>>> + * Must be called with dev->lock held.
>>>> + */
>>>> +static void gr_disable_interrupts_and_pullup(struct gr_udc *dev)
>>>> +{
>>>> +	gr_write32(&dev->regs->control, 0);
>>>> +	wmb(); /* Make sure that we do not deny one of our interrupts */
>>>> +	dev->irq_enabled = 0;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Stop all device activity and disable data line pullup.
>>>> + *
>>>> + * Must be called with dev->lock held.
>>>> + */
>>>> +static void gr_stop_activity(struct gr_udc *dev)
>>>> +{
>>>> +	struct gr_ep *ep;
>>>> +
>>>> +	list_for_each_entry(ep, &dev->ep_list, ep_list)
>>>> +		gr_ep_nuke(ep);
>>>> +
>>>> +	gr_disable_interrupts_and_pullup(dev);
>>>> +
>>>> +	gr_set_ep0state(dev, GR_EP0_DISCONNECT);
>>>> +	usb_gadget_set_state(&dev->gadget, USB_STATE_ATTACHED);
>>>
>>> ATTACHED ??
>>
>> Maybe NOTATTACHED is clearer, even if it is the same state in all
>> respects.
>
> for the sake of being clear, yes :-)
>
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

OK, I'll look into this for v2.

Cheers,
Andreas

