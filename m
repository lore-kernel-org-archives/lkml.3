Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3JAIfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:35:20 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:56685 "EHLO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364Ab3JAIfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:35:12 -0400
Message-ID: <524A8927.6090500@gaisler.com>
Date: Tue, 01 Oct 2013 10:34:47 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH] usb: gadget: Add UDC driver for Aeroflex Gaisler GRUSBDC
References: <1376316310-27989-1-git-send-email-andreas@gaisler.com> <20130918171506.GQ21559@radagast>
In-Reply-To: <20130918171506.GQ21559@radagast>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

Thank you for the feedback! Sorry for the delayed response back.

Responses inline.


On 2013-09-18 19:15, Felipe Balbi wrote:
> Hi,
>
> On Mon, Aug 12, 2013 at 04:05:10PM +0200, Andreas Larsson wrote:
>> diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
>> new file mode 100644
>> index 0000000..37a6c08
>> --- /dev/null
>> +++ b/drivers/usb/gadget/gr_udc.c
>> @@ -0,0 +1,2268 @@
>> +/*
>> + * USB Peripheral Controller driver for Aeroflex Gaisler GRUSBDC.
>> + *
>> + * 2013 (c) Aeroflex Gaisler AB
>> + *
>> + * This driver supports GRUSBDC USB Device Controller cores available in the
>> + * GRLIB VHDL IP core library.
>> + *
>> + * Full documentation of the GRUSBDC core can be found here:
>> + * http://www.gaisler.com/products/grlib/grip.pdf
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License as published by the
>> + * Free Software Foundation; either version 2 of the License, or (at your
>> + * option) any later version.
>> + *
>> + * Contributors:
>> + * - Andreas Larsson <andreas@gaisler.com>
>> + * - Marko Isomaki
>> + */
>> +
>> +/*
>> + * A GRUSBDC core can have up to 16 IN endpoints and 16 OUT endpoints each
>> + * individually configurable to any of the four USB transfer types. This driver
>> + * only supports cores in DMA mode.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/errno.h>
>> +#include <linux/init.h>
>> +#include <linux/list.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/device.h>
>> +#include <linux/usb/ch9.h>
>> +#include <linux/usb/gadget.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/dmapool.h>
>> +#include <linux/debugfs.h>
>> +#include <linux/seq_file.h>
>> +
>> +#include <asm/byteorder.h>
>> +#include <asm/irq.h>
>
> <linux/irq.h>
>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/of_address.h>
>> +
>> +/* #define VERBOSE_DEBUG */
>
> we don't want this, we want verbose debug to be selectable on Kconfig,
> which already is ;-)

I was only aware of CONFIG_USB_GADGET_DEBUG leading to DEBUG being
defined, not that any Kconfig turned on VERBOSE_DEBUG. Where is this
happening?


>> +#include "gr_udc.h"
>> +
>> +#define	DRIVER_NAME	"gr_udc"
>> +#define	DRIVER_DESC	"Aeroflex Gaisler GRUSBDC USB Peripheral Controller"
>> +
>> +static const char driver_name[] = DRIVER_NAME;
>> +static const char driver_desc[] = DRIVER_DESC;
>> +
>> +#define gr_read32(x) (ioread32be((x)))
>> +#define gr_write32(x, v) (iowrite32be((v), (x)))
>> +
>> +/* USB speed and corresponding string calculated from status register value */
>> +#define GR_SPEED(status) \
>> +	((status & GR_STATUS_SP) ? USB_SPEED_FULL : USB_SPEED_HIGH)
>> +#define GR_SPEED_STR(status) usb_speed_string(GR_SPEED(status))
>> +
>> +/* Size of hardware buffer calculated from epctrl register value */
>> +#define GR_BUFFER_SIZE(epctrl)					      \
>> +	((((epctrl) & GR_EPCTRL_BUFSZ_MASK) >> GR_EPCTRL_BUFSZ_POS) * \
>> +	 GR_EPCTRL_BUFSZ_SCALER)
>> +
>> +/* ---------------------------------------------------------------------- */
>> +/* Debug printout functionality */
>> +
>> +static const char * const gr_modestring[] = {"control", "iso", "bulk", "int"};
>> +
>> +static const char *gr_ep0state_string(enum gr_ep0state state)
>> +{
>> +	static const char *const names[] = {
>> +		[GR_EP0_DISCONNECT] = "disconnect",
>> +		[GR_EP0_SETUP] = "setup",
>> +		[GR_EP0_IDATA] = "idata",
>> +		[GR_EP0_ODATA] = "odata",
>> +		[GR_EP0_ISTATUS] = "istatus",
>> +		[GR_EP0_OSTATUS] = "ostatus",
>> +		[GR_EP0_STALL] = "stall",
>> +		[GR_EP0_SUSPEND] = "suspend",
>> +	};
>> +
>> +	if (state < 0 || state >= ARRAY_SIZE(names))
>> +		return "UNKNOWN";
>> +
>> +	return names[state];
>> +}
>> +
>> +#ifdef VERBOSE_DEBUG
>> +
>> +#define BPRINTF(buf, left, fmt, args...)			\
>> +	do {							\
>> +		int ret = snprintf(buf, left, fmt, ## args);	\
>> +		buf += ret;					\
>> +		left -= ret;					\
>> +	} while (0)
>
> nack, use dev_vdbg() instead.
>
>> +static void gr_dbgprint_request(const char *str, struct gr_ep *ep,
>> +				struct gr_request *req)
>> +{
>> +	char buffer[100];
>
> NAK^10000000
>
> use kernel facilities instead. printk() and all its friends already
> print to a ring buffer.

Alright. The concern was that repeatedly calling printk for multiple
parts of the same message could lead to intermixing with other unrelated
printouts.


>> +	u8 *data = (u8 *)req->req.buf;
>
> you don't need to cast void pointers

Indeed


>> +static void gr_finish_request(struct gr_ep *ep, struct gr_request *req,
>> +			      int status)
>> +{
>> +	struct gr_udc *dev;
>> +
>> +	list_del_init(&req->queue);
>> +
>> +	if (likely(req->req.status == -EINPROGRESS))
>> +		req->req.status = status;
>> +	else
>> +		status = req->req.status;
>> +
>> +	dev = ep->dev;
>> +	usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);
>> +	gr_free_dma_desc_chain(dev, req);
>> +
>> +	if (ep->is_in) /* For OUT, actual gets updated by the work handler */
>> +		req->req.actual = req->req.length;
>> +
>> +	if (!status) {
>> +		if (ep->is_in)
>> +			gr_dbgprint_request("SENT", ep, req);
>> +		else
>> +			gr_dbgprint_request("RECV", ep, req);
>> +	}
>> +
>> +	/* Prevent changes to ep->queue during callback */
>> +	ep->callback = 1;
>> +	if (req == dev->ep0reqo && !status) {
>> +		if (req->setup)
>> +			gr_ep0_setup(dev, req);
>> +		else
>> +			dev_err(dev->dev,
>> +				"Unexpected non setup packet on ep0in\n");
>> +	} else if (req->req.complete) {
>> +		unsigned long flags;
>> +
>> +		/* Complete should be called with irqs disabled */
>> +		local_irq_save(flags);
>
> I guess it'd be better if you called this with spin_lock_irqsave()
> called before, then you can remove local_irq_save from here.

That would increase the amount of time interrupts are disabled quite a
lot, so I would prefer not to.


>> +		spin_unlock(&dev->lock);
>> +
>> +		req->req.complete(&ep->ep, &req->req);
>> +
>> +		spin_lock(&dev->lock);
>> +		local_irq_restore(flags);
>> +	}
>> +	ep->callback = 0;
>> +
>> +	/* Catch up possible prevented ep handling during completion callback */
>> +	if (!ep->stopped)
>> +		schedule_work(&dev->work);
>
> this workqueue is awkward, what's up with that ?

The reason for the scheduling here is that during the completion call
the handling of endpoint events needs to be stopped. This is
accomplished by the ep->callback flag. When that is done we might have
ep events that needs to be taken care of.

The same situation arises after unhalting an endpoint further down. All
potential handling of that endpoint was on pause during halt, and thus
the work handler needs to be scheduled to catch up.


>> +/* Call with non-NULL dev to do a devm-allocation */
>> +static struct usb_request *__gr_alloc_request(struct device *dev,
>> +					      struct usb_ep *_ep,
>> +					      gfp_t gfp_flags)
>> +{
>> +	struct gr_request *req;
>> +
>> +	if (dev)
>> +		req = devm_kzalloc(dev, sizeof(*req), gfp_flags);
>> +	else
>> +		req = kzalloc(sizeof(*req), gfp_flags);
>
> why would "dev" ever be NULL ?

When the gadget allocates a request it will free it explicitely later
on. Thus there is no need for any devm allocation. Therefore, the calls
from the gadget to gr_alloc_request then calls this function with a NULL
argument so that non-devm allocation is done in that case.


>> +	if (!req)
>> +		return NULL;
>> +
>> +	INIT_LIST_HEAD(&req->queue);
>> +
>> +	return &req->req;
>> +}
>> +
>> +#define gr_devm_alloc_request __gr_alloc_request
>> +
>> +/*
>> + * Starts DMA for endpoint ep if there are requests in the queue.
>> + *
>> + * Must be called with dev->lock held and with !ep->stopped.
>> + */
>> +static void gr_start_dma(struct gr_ep *ep)
>> +{
>> +	struct gr_request *req;
>> +	u32 dmactrl;
>> +
>> +	if (list_empty(&ep->queue)) {
>> +		ep->dma_start = 0;
>> +		return;
>> +	}
>> +
>> +	req = list_first_entry(&ep->queue, struct gr_request, queue);
>> +
>> +	/* A descriptor should already have been allocated */
>> +	BUG_ON(!req->curr_desc);
>> +
>> +	wmb(); /* Make sure all is settled before handing it over to DMA */
>> +
>> +	/* Set the descriptor pointer in the hardware */
>> +	gr_write32(&ep->regs->dmaaddr, req->curr_desc->paddr);
>> +
>> +	/* Announce available descriptors */
>> +	dmactrl = gr_read32(&ep->regs->dmactrl);
>> +	gr_write32(&ep->regs->dmactrl, dmactrl | GR_DMACTRL_DA);
>> +
>> +	ep->dma_start = 1;
>> +}
>> +
>> +/*
>> + * Finishes the first request in the ep's queue and, if available, starts the
>> + * next request in queue.
>> + *
>> + * Must be called with dev->lock held and with !ep->stopped.
>> + */
>> +static void gr_dma_advance(struct gr_ep *ep, int status)
>> +{
>> +	struct gr_request *req;
>> +
>> +	req = list_first_entry(&ep->queue, struct gr_request, queue);
>> +	gr_finish_request(ep, req, status);
>> +	gr_start_dma(ep); /* Regardless of ep->dma_start */
>> +}
>> +
>> +/*
>> + * Abort DMA for an endpoint. Sets the abort DMA bit which causes an ongoing DMA
>> + * transfer to be canceled and clears GR_DMACTRL_DA.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static void gr_abort_dma(struct gr_ep *ep)
>> +{
>> +	u32 dmactrl;
>> +
>> +	dmactrl = gr_read32(&ep->regs->dmactrl);
>> +	gr_write32(&ep->regs->dmactrl, dmactrl | GR_DMACTRL_AD);
>> +}
>> +
>> +/*
>> + * Allocates and sets up a struct gr_dma_desc and putting it on the descriptor
>> + * chain.
>> + *
>> + * Size is not used for OUT endpoints. Hardware can not be instructed to handle
>> + * smaller buffer than MAXPL in the OUT direction.
>> + */
>> +static int gr_add_dma_desc(struct gr_ep *ep, struct gr_request *req,
>> +			   dma_addr_t data, unsigned size, gfp_t gfp_flags)
>> +{
>> +	struct gr_dma_desc *desc;
>> +
>> +	desc = gr_alloc_dma_desc(ep, gfp_flags);
>> +	if (!desc)
>> +		return -ENOMEM;
>> +
>> +	desc->data = data;
>> +	if (ep->is_in)
>> +		desc->ctrl =
>> +			(GR_DESC_IN_CTRL_LEN_MASK & size) | GR_DESC_IN_CTRL_EN;
>> +	else
>> +		desc->ctrl = GR_DESC_OUT_CTRL_IE;
>> +
>> +	if (!req->first_desc) {
>> +		req->first_desc = desc;
>> +		req->curr_desc = desc;
>> +	} else {
>> +		req->last_desc->next_desc = desc;
>> +		req->last_desc->next = desc->paddr;
>> +		req->last_desc->ctrl |= GR_DESC_OUT_CTRL_NX;
>> +	}
>> +	req->last_desc = desc;
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Sets up a chain of struct gr_dma_descriptors pointing to buffers that
>> + * together covers req->req.length bytes of the buffer at DMA address
>> + * req->req.dma for the OUT direction.
>> + *
>> + * The first descriptor in the chain is enabled, the rest disabled. The work
>> + * handler will later enable them one by one when needed so we can find out when
>> + * the transfer is finished. For OUT endpoints, all descriptors therefore
>> + * generate interrutps.
>> + */
>> +static int gr_setup_out_desc_list(struct gr_ep *ep, struct gr_request *req,
>> +				  gfp_t gfp_flags)
>> +{
>> +	u16 bytes_left; /* Bytes left to provide descriptors for */
>> +	u16 bytes_used; /* Bytes accommodated for */
>> +	int ret = 0;
>> +
>> +	req->first_desc = NULL; /* Signals that no allocation is done yet */
>> +	bytes_left = req->req.length;
>> +	bytes_used = 0;
>> +	while (bytes_left > 0) {
>> +		dma_addr_t start = req->req.dma + bytes_used;
>> +		u16 size = min(bytes_left, ep->bytes_per_buffer);
>> +
>> +		/* Should not happen however - gr_queue stops such lengths */
>> +		if (size < ep->bytes_per_buffer)
>> +			dev_warn(ep->dev->dev,
>> +				 "Buffer overrun risk: %u < %u bytes/buffer\n",
>> +				 size, ep->bytes_per_buffer);
>> +
>> +		ret = gr_add_dma_desc(ep, req, start, size, gfp_flags);
>> +		if (ret)
>> +			goto alloc_err;
>> +
>> +		bytes_left -= size;
>> +		bytes_used += size;
>> +	}
>> +
>> +	req->first_desc->ctrl |= GR_DESC_OUT_CTRL_EN;
>> +
>> +	return 0;
>> +
>> +alloc_err:
>> +	gr_free_dma_desc_chain(ep->dev, req);
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * Sets up a chain of struct gr_dma_descriptors pointing to buffers that
>> + * together covers req->req.length bytes of the buffer at DMA address
>> + * req->req.dma for the IN direction.
>> + *
>> + * When more data is provided than the maximum payload size, the hardware splits
>> + * this up into several payloads automatically. Moreover, ep->bytes_per_buffer
>> + * is always set to a multiple of the maximum payload (restricted to the valid
>> + * number of maximum payloads during high bandwidth isochronous or interrupt
>> + * transfers)
>> + *
>> + * All descriptors are enabled from the beginning and we only generate an
>> + * interrupt for the last one indicating that the entire request has been pushed
>> + * to hardware.
>> + */
>> +static int gr_setup_in_desc_list(struct gr_ep *ep, struct gr_request *req,
>> +				 gfp_t gfp_flags)
>> +{
>> +	u16 bytes_left; /* Bytes left in req to provide descriptors for */
>> +	u16 bytes_used; /* Bytes in req accommodated for */
>> +	int ret = 0;
>> +
>> +	req->first_desc = NULL; /* Signals that no allocation is done yet */
>> +	bytes_left = req->req.length;
>> +	bytes_used = 0;
>> +	do { /* Allow for zero length packets */
>> +		dma_addr_t start = req->req.dma + bytes_used;
>> +		u16 size = min(bytes_left, ep->bytes_per_buffer);
>> +
>> +		ret = gr_add_dma_desc(ep, req, start, size, gfp_flags);
>> +		if (ret)
>> +			goto alloc_err;
>> +
>> +		bytes_left -= size;
>> +		bytes_used += size;
>> +	} while (bytes_left > 0);
>> +
>> +	/*
>> +	 * Send an extra zero length packet to indicate that no more data is
>> +	 * available when req->req.zero is set and the data length is even
>> +	 * multiples of ep->ep.maxpacket.
>> +	 */
>> +	if (req->req.zero && (req->req.length % ep->ep.maxpacket == 0)) {
>> +		ret = gr_add_dma_desc(ep, req, 0, 0, gfp_flags);
>> +		if (ret)
>> +			goto alloc_err;
>> +	}
>> +
>> +	/*
>> +	 * For IN packets we only want to know when the last packet has been
>> +	 * transmitted (not just put into internal buffers).
>> +	 */
>> +	req->last_desc->ctrl |= GR_DESC_IN_CTRL_PI;
>> +
>> +	return 0;
>> +
>> +alloc_err:
>> +	gr_free_dma_desc_chain(ep->dev, req);
>> +
>> +	return ret;
>> +}
>> +
>> +/* Must be called with dev->lock held */
>> +static int gr_queue(struct gr_ep *ep, struct gr_request *req, gfp_t gfp_flags)
>> +{
>> +	struct gr_udc *dev = ep->dev;
>> +	int ret;
>> +
>> +	if (unlikely(!ep->ep.desc && ep->num != 0)) {
>> +		dev_err(dev->dev, "No ep descriptor for %s\n", ep->ep.name);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (unlikely(!req->req.buf || !list_empty(&req->queue))) {
>> +		dev_err(dev->dev,
>> +			"Invalid request for %s: buf=%p list_empty=%d\n",
>> +			ep->ep.name, req->req.buf, list_empty(&req->queue));
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * The DMA controller can not handle smaller OUT buffers than
>> +	 * maxpacket. It could lead to buffer overruns if unexpectedly long
>> +	 * packet are received.
>> +	 */
>> +	if (!ep->is_in && (req->req.length % ep->ep.maxpacket) != 0) {
>> +		dev_err(dev->dev,
>> +			"OUT request length %d is not multiple of maxpacket\n",
>> +			req->req.length);
>> +		return -EMSGSIZE;
>> +	}
>> +
>> +	if (unlikely(!dev->driver || dev->gadget.speed == USB_SPEED_UNKNOWN)) {
>> +		dev_err(dev->dev, "-ESHUTDOWN");
>> +		return -ESHUTDOWN;
>> +	}
>> +
>> +	/* Can't touch registers when suspended */
>> +	if (dev->ep0state == GR_EP0_SUSPEND) {
>> +		dev_err(dev->dev, "-EBUSY");
>> +		return -EBUSY;
>> +	}
>> +
>> +	/* Set up DMA mapping in case the caller didn't */
>> +	ret = usb_gadget_map_request(&dev->gadget, &req->req, ep->is_in);
>> +	if (ret) {
>> +		dev_err(dev->dev, "usb_gadget_map_request");
>> +		return ret;
>> +	}
>> +
>> +	if (ep->is_in)
>> +		ret = gr_setup_in_desc_list(ep, req, gfp_flags);
>> +	else
>> +		ret = gr_setup_out_desc_list(ep, req, gfp_flags);
>> +	if (ret)
>> +		return ret;
>> +
>> +	req->req.status = -EINPROGRESS;
>> +	req->req.actual = 0;
>> +	list_add_tail(&req->queue, &ep->queue);
>> +
>> +	/* Start DMA if not started, otherwise work handler handles it */
>> +	if (!ep->dma_start && likely(!ep->stopped))
>> +		gr_start_dma(ep);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Queue a request from within the driver.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static inline int gr_queue_int(struct gr_ep *ep, struct gr_request *req,
>> +			       gfp_t gfp_flags)
>> +{
>> +	if (ep->is_in)
>> +		gr_dbgprint_request("RESP", ep, req);
>> +
>> +	return gr_queue(ep, req, gfp_flags);
>> +}
>> +
>> +/* ---------------------------------------------------------------------- */
>> +/* General helper functions */
>> +
>> +/*
>> + * Dequeue ALL requests.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static void gr_ep_nuke(struct gr_ep *ep)
>> +{
>> +	struct gr_request *req;
>> +	struct gr_udc *dev;
>> +
>> +	dev = ep->dev;
>> +
>> +	ep->stopped = 1;
>> +	ep->dma_start = 0;
>> +	gr_abort_dma(ep);
>> +
>> +	while (!list_empty(&ep->queue)) {
>> +		req = list_first_entry(&ep->queue, struct gr_request, queue);
>> +		gr_finish_request(ep, req, -ESHUTDOWN);
>> +	}
>> +}
>> +
>> +/*
>> + * Reset the hardware state of this endpoint.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static void gr_ep_reset(struct gr_ep *ep)
>> +{
>> +	gr_write32(&ep->regs->epctrl, 0);
>> +	gr_write32(&ep->regs->dmactrl, 0);
>> +
>> +	ep->ep.maxpacket = MAX_CTRL_PL_SIZE;
>> +	ep->ep.desc = NULL;
>> +	ep->stopped = 1;
>> +	ep->dma_start = 0;
>> +}
>> +
>> +/*
>> + * Generate STALL on ep0in/out.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static void gr_control_stall(struct gr_udc *dev)
>> +{
>> +	u32 epctrl;
>> +
>> +	epctrl = gr_read32(&dev->epo[0].regs->epctrl);
>> +	gr_write32(&dev->epo[0].regs->epctrl, epctrl | GR_EPCTRL_CS);
>> +	epctrl = gr_read32(&dev->epi[0].regs->epctrl);
>> +	gr_write32(&dev->epi[0].regs->epctrl, epctrl | GR_EPCTRL_CS);
>> +
>> +	dev->ep0state = GR_EP0_STALL;
>> +}
>> +
>> +/*
>> + * Halts, halts and wedges, or clears halt for an endpoint.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static int gr_ep_halt_wedge(struct gr_ep *ep, int halt, int wedge, int fromhost)
>> +{
>> +	u32 epctrl;
>> +	int retval = 0;
>> +
>> +	if (ep->num && !ep->ep.desc)
>> +		return -EINVAL;
>> +
>> +	if (ep->num && ep->ep.desc->bmAttributes == USB_ENDPOINT_XFER_ISOC)
>> +		return -EOPNOTSUPP;
>> +
>> +	/* Never actually halt ep0, and therefore never clear halt for ep0 */
>> +	if (!ep->num) {
>> +		if (halt && !fromhost) {
>> +			/* ep0 halt from gadget - generate protocol stall */
>> +			gr_control_stall(ep->dev);
>> +			DBG("EP: stall ep0\n");
>> +			return 0;
>> +		}
>> +		return -EINVAL;
>> +	}
>> +
>> +	DBG("EP: %s halt %s\n", (halt ? (wedge ? "wedge" : "set") : "clear"),
>> +	    ep->ep.name);
>
> dev_dbg()

Sure, I'll convert all the DBG, VDBG and INFO to the dev_ counterparts.


>> +	epctrl = gr_read32(&ep->regs->epctrl);
>> +	if (halt) {
>> +		/* Set HALT */
>> +		gr_write32(&ep->regs->epctrl, epctrl | GR_EPCTRL_EH);
>> +		ep->stopped = 1;
>> +		if (wedge)
>> +			ep->wedged = 1;
>> +	} else {
>> +		gr_write32(&ep->regs->epctrl, epctrl & ~GR_EPCTRL_EH);
>> +		ep->stopped = 0;
>> +		ep->wedged = 0;
>> +
>> +		/* Things might have been queued up in the meantime */
>> +		if (!ep->dma_start)
>> +			gr_start_dma(ep);
>> +
>> +		/* Ep handling might have been hindered during halt */
>> +		schedule_work(&ep->dev->work);

Here is the second place where we need to schedule work as mentioned above.


>> +	}
>> +
>> +	return retval;
>> +}
>> +
>> +/* Must be called with dev->lock held */
>> +static inline void gr_set_ep0state(struct gr_udc *dev, enum gr_ep0state value)
>> +{
>> +	if (dev->ep0state != value)
>> +		VDBG("STATE:  ep0state=%s\n",
>> +		     gr_ep0state_string(value));
>
> dev_vdbg()
>
>> +	dev->ep0state = value;
>> +}
>> +
>> +/*
>> + * Should only be called when endpoints can not generate interrupts.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static void gr_disable_interrupts_and_pullup(struct gr_udc *dev)
>> +{
>> +	gr_write32(&dev->regs->control, 0);
>> +	wmb(); /* Make sure that we do not deny one of our interrupts */
>> +	dev->irq_enabled = 0;
>> +}
>> +
>> +/*
>> + * Stop all device activity and disable data line pullup.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static void gr_stop_activity(struct gr_udc *dev)
>> +{
>> +	struct gr_ep *ep;
>> +
>> +	list_for_each_entry(ep, &dev->ep_list, ep_list)
>> +		gr_ep_nuke(ep);
>> +
>> +	gr_disable_interrupts_and_pullup(dev);
>> +
>> +	gr_set_ep0state(dev, GR_EP0_DISCONNECT);
>> +	usb_gadget_set_state(&dev->gadget, USB_STATE_ATTACHED);
>
> ATTACHED ??

Maybe NOTATTACHED is clearer, even if it is the same state in all respects.


>> +}
>> +
>> +/* ---------------------------------------------------------------------- */
>> +/* ep0 setup packet handling */
>> +
>> +static void gr_ep0_testmode_complete(struct usb_ep *_ep,
>> +				     struct usb_request *_req)
>> +{
>> +	struct gr_ep *ep;
>> +	struct gr_udc *dev;
>> +	u32 control;
>> +
>> +	ep = container_of(_ep, struct gr_ep, ep);
>> +	dev = ep->dev;
>> +
>> +	spin_lock(&dev->lock);
>> +
>> +	control = gr_read32(&dev->regs->control);
>> +	control |= GR_CONTROL_TM | (dev->test_mode << GR_CONTROL_TS_POS);
>> +	gr_write32(&dev->regs->control, control);
>> +
>> +	spin_unlock(&dev->lock);
>> +}
>> +
>> +static void gr_ep0_dummy_complete(struct usb_ep *_ep, struct usb_request *_req)
>> +{
>> +	/* Nothing needs to be done here */
>> +}
>> +
>> +/*
>> + * Queue a response on ep0in.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static int gr_ep0_respond(struct gr_udc *dev, u8 *buf, int length,
>> +			  void (*complete)(struct usb_ep *ep,
>> +					   struct usb_request *req))
>> +{
>> +	u8 *reqbuf = dev->ep0reqi->req.buf;
>> +	int status;
>> +	int i;
>> +
>> +	for (i = 0; i < length; i++)
>> +		reqbuf[i] = buf[i];
>> +	dev->ep0reqi->req.length = length;
>> +	dev->ep0reqi->req.complete = complete;
>> +
>> +	status = gr_queue_int(&dev->epi[0], dev->ep0reqi, GFP_ATOMIC);
>> +	if (status < 0)
>> +		dev_err(dev->dev,
>> +			"Could not queue ep0in setup response: %d\n", status);
>> +
>> +	return status;
>> +}
>> +
>> +/*
>> + * Queue a 2 byte response on ep0in.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static inline int gr_ep0_respond_u16(struct gr_udc *dev, u16 response)
>> +{
>> +	__le16 le_response = cpu_to_le16(response);
>> +
>> +	return gr_ep0_respond(dev, (u8 *)&le_response, 2,
>> +			      gr_ep0_dummy_complete);
>> +}
>> +
>> +/*
>> + * Queue a ZLP response on ep0in.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static inline int gr_ep0_respond_empty(struct gr_udc *dev)
>> +{
>> +	return gr_ep0_respond(dev, NULL, 0, gr_ep0_dummy_complete);
>> +}
>> +
>> +/*
>> + * This is run when a SET_ADDRESS request is received. First writes
>> + * the new address to the control register which is updated internally
>> + * when the next IN packet is ACKED.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static void gr_set_address(struct gr_udc *dev, u8 address)
>> +{
>> +	u32 control;
>> +
>> +	control = gr_read32(&dev->regs->control) & ~GR_CONTROL_UA_MASK;
>> +	control |= (address << GR_CONTROL_UA_POS) & GR_CONTROL_UA_MASK;
>> +	control |= GR_CONTROL_SU;
>> +	gr_write32(&dev->regs->control, control);
>> +}
>> +
>> +/*
>> + * Returns negative for STALL, 0 for successful handling and positive for
>> + * delegation.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static int gr_device_request(struct gr_udc *dev, u8 type, u8 request,
>> +			     u16 value, u16 index)
>> +{
>> +	u16 response;
>> +	u8 test;
>> +
>> +	switch (request) {
>> +	case USB_REQ_SET_ADDRESS:
>> +		DBG("STATUS: address %d\n", value & 0xff);
>> +		gr_set_address(dev, value & 0xff);
>> +		if (value)
>> +			usb_gadget_set_state(&dev->gadget, USB_STATE_ADDRESS);
>> +		else
>> +			usb_gadget_set_state(&dev->gadget, USB_STATE_DEFAULT);
>> +		return gr_ep0_respond_empty(dev);
>> +
>> +	case USB_REQ_GET_STATUS:
>> +		/* Self powered | remote wakeup */
>> +		response = 0x0001 | (dev->remote_wakeup ? 0x0002 : 0);
>> +		return gr_ep0_respond_u16(dev, response);
>> +
>> +	case USB_REQ_SET_FEATURE:
>> +		switch (value) {
>> +		case USB_DEVICE_REMOTE_WAKEUP:
>> +			/* Allow remote wakeup */
>> +			dev->remote_wakeup = 1;
>> +			return gr_ep0_respond_empty(dev);
>> +
>> +		case USB_DEVICE_TEST_MODE:
>> +			/* The hardware does not support TEST_FORCE_EN */
>> +			test = index >> 8;
>> +			if (test >= TEST_J && test <= TEST_PACKET) {
>> +				dev->test_mode = test;
>> +				return gr_ep0_respond(dev, NULL, 0,
>> +						      gr_ep0_testmode_complete);
>> +			}
>> +		}
>> +		break;
>> +
>> +	case USB_REQ_CLEAR_FEATURE:
>> +		switch (value) {
>> +		case USB_DEVICE_REMOTE_WAKEUP:
>> +			/* Disallow remote wakeup */
>> +			dev->remote_wakeup = 0;
>> +			return gr_ep0_respond_empty(dev);
>> +		}
>> +		break;
>> +	}
>> +
>> +	return 1; /* Delegate the rest */
>> +}
>> +
>> +/*
>> + * Returns negative for STALL, 0 for successful handling and positive for
>> + * delegation.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static int gr_interface_request(struct gr_udc *dev, u8 type, u8 request,
>> +				u16 value, u16 index)
>> +{
>> +	if (dev->gadget.state != USB_STATE_CONFIGURED)
>> +		return -1;
>> +
>> +	/*
>> +	 * Should return STALL for invalid interfaces, but udc driver does not
>> +	 * know anything about that. However, many gadget drivers do not handle
>> +	 * GET_STATUS so we need to take care of that.
>> +	 */
>> +
>> +	switch (request) {
>> +	case USB_REQ_GET_STATUS:
>> +		return gr_ep0_respond_u16(dev, 0x0000);
>> +
>> +	case USB_REQ_SET_FEATURE:
>> +	case USB_REQ_CLEAR_FEATURE:
>> +		/*
>> +		 * No possible valid standard requests. Still let gadget drivers
>> +		 * have a go at it.
>> +		 */
>> +		break;
>> +	}
>> +
>> +	return 1; /* Delegate the rest */
>> +}
>> +
>> +/*
>> + * Returns negative for STALL, 0 for successful handling and positive for
>> + * delegation.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static int gr_endpoint_request(struct gr_udc *dev, u8 type, u8 request,
>> +			       u16 value, u16 index)
>> +{
>> +	struct gr_ep *ep;
>> +	int status;
>> +	int halted;
>> +	u8 epnum = index & USB_ENDPOINT_NUMBER_MASK;
>> +	u8 is_in = index & USB_ENDPOINT_DIR_MASK;
>> +
>> +	if ((is_in && epnum >= dev->nepi) || (!is_in && epnum >= dev->nepo))
>> +		return -1;
>> +
>> +	if (dev->gadget.state != USB_STATE_CONFIGURED && epnum != 0)
>> +		return -1;
>> +
>> +	ep = (is_in ? &dev->epi[epnum] : &dev->epo[epnum]);
>> +
>> +	switch (request) {
>> +	case USB_REQ_GET_STATUS:
>> +		halted = gr_read32(&ep->regs->epctrl) & GR_EPCTRL_EH;
>> +		return gr_ep0_respond_u16(dev, halted ? 0x0001 : 0);
>> +
>> +	case USB_REQ_SET_FEATURE:
>> +		switch (value) {
>> +		case USB_ENDPOINT_HALT:
>> +			status = gr_ep_halt_wedge(ep, 1, 0, 1);
>> +			if (status >= 0)
>> +				status = gr_ep0_respond_empty(dev);
>> +			return status;
>> +		}
>> +		break;
>> +
>> +	case USB_REQ_CLEAR_FEATURE:
>> +		switch (value) {
>> +		case USB_ENDPOINT_HALT:
>> +			if (ep->wedged)
>> +				return -1;
>> +			status = gr_ep_halt_wedge(ep, 0, 0, 1);
>> +			if (status >= 0)
>> +				status = gr_ep0_respond_empty(dev);
>> +			return status;
>> +		}
>> +		break;
>> +	}
>> +
>> +	return 1; /* Delegate the rest */
>> +}
>> +
>> +/* Must be called with dev->lock held */
>> +static void gr_ep0out_requeue(struct gr_udc *dev)
>> +{
>> +	int ret = gr_queue_int(&dev->epo[0], dev->ep0reqo, GFP_ATOMIC);
>> +
>> +	if (ret)
>> +		dev_err(dev->dev, "Could not queue ep0out setup request: %d\n",
>> +			ret);
>> +}
>> +
>> +/*
>> + * The main function dealing with setup requests on ep0.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static void gr_ep0_setup(struct gr_udc *dev, struct gr_request *req)
>> +{
>> +	union {
>> +		struct usb_ctrlrequest ctrl;
>> +		u8 raw[8];
>> +		u32 word[2];
>> +	} u;
>> +	u8 type;
>> +	u8 request;
>> +	u16 value;
>> +	u16 index;
>> +	u16 length;
>> +	int i;
>> +	int status;
>> +
>> +	/* Restore from ep0 halt */
>> +	if (dev->ep0state == GR_EP0_STALL) {
>> +		gr_set_ep0state(dev, GR_EP0_SETUP);
>> +		if (!req->req.actual)
>> +			goto out;
>> +	}
>> +
>> +	if (dev->ep0state == GR_EP0_ISTATUS) {
>> +		gr_set_ep0state(dev, GR_EP0_SETUP);
>> +		if (req->req.actual > 0)
>> +			DBG("Unexpected setup packet at state %s\n",
>> +			    gr_ep0state_string(GR_EP0_ISTATUS));
>> +		else
>> +			goto out; /* Got expected ZLP */
>> +	} else if (dev->ep0state != GR_EP0_SETUP) {
>> +		INFO("Unexpected ep0out request at state %s - stalling\n",
>> +		     gr_ep0state_string(dev->ep0state));
>
> dev_info
>
>> +		gr_control_stall(dev);
>> +		gr_set_ep0state(dev, GR_EP0_SETUP);
>> +		goto out;
>> +	} else if (!req->req.actual) {
>> +		DBG("Unexpected ZLP at state %s\n",
>> +		    gr_ep0state_string(dev->ep0state));
>
> dev_dbg()
>
>> +		goto out;
>> +	}
>> +
>> +	/* Handle SETUP packet */
>> +	for (i = 0; i < req->req.actual; i++)
>> +		u.raw[i] = ((u8 *)req->req.buf)[i];
>> +
>> +	type = u.ctrl.bRequestType;
>> +	request = u.ctrl.bRequest;
>> +	value = le16_to_cpu(u.ctrl.wValue);
>> +	index = le16_to_cpu(u.ctrl.wIndex);
>> +	length = le16_to_cpu(u.ctrl.wLength);
>> +
>> +	gr_dbgprint_devreq(type, request, value, index, length);
>> +
>> +	/* Check for data stage */
>> +	if (length) {
>> +		if (type & USB_DIR_IN)
>> +			gr_set_ep0state(dev, GR_EP0_IDATA);
>> +		else
>> +			gr_set_ep0state(dev, GR_EP0_ODATA);
>> +	}
>> +
>> +	status = 1; /* Positive status flags delegation */
>> +	if ((type & USB_TYPE_MASK) == USB_TYPE_STANDARD) {
>> +		switch (type & USB_RECIP_MASK) {
>> +		case USB_RECIP_DEVICE:
>> +			status = gr_device_request(dev, type, request,
>> +						   value, index);
>> +			break;
>> +		case USB_RECIP_ENDPOINT:
>> +			status =  gr_endpoint_request(dev, type, request,
>> +						      value, index);
>> +			break;
>> +		case USB_RECIP_INTERFACE:
>> +			status = gr_interface_request(dev, type, request,
>> +						      value, index);
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (status > 0) {
>> +		/* Delegate the rest to the gadget driver */
>> +		spin_unlock(&dev->lock);
>> +
>> +		VDBG("DELEGATE\n");
>> +		status = dev->driver->setup(&dev->gadget, &u.ctrl);
>> +
>> +		spin_lock(&dev->lock);
>> +	}
>> +
>> +	/* Generate STALL on both ep0out and ep0in if requested */
>> +	if (unlikely(status < 0)) {
>> +		VDBG("STALL\n");
>> +		gr_control_stall(dev);
>> +	}
>> +
>> +	if ((type & USB_TYPE_MASK) == USB_TYPE_STANDARD &&
>> +	    request == USB_REQ_SET_CONFIGURATION) {
>> +		if (!value) {
>> +			DBG("STATUS: deconfigured\n");
>> +			usb_gadget_set_state(&dev->gadget, USB_STATE_ADDRESS);
>> +		} else if (status >= 0) {
>> +			/* Not configured unless gadget OK:s it */
>> +			DBG("STATUS: configured: %d\n", value);
>> +			usb_gadget_set_state(&dev->gadget,
>> +					     USB_STATE_CONFIGURED);
>> +		}
>> +	}
>> +
>> +	/* Get ready for next stage */
>> +	if (dev->ep0state == GR_EP0_ODATA)
>> +		gr_set_ep0state(dev, GR_EP0_OSTATUS);
>> +	else if (dev->ep0state == GR_EP0_IDATA)
>> +		gr_set_ep0state(dev, GR_EP0_ISTATUS);
>> +	else
>> +		gr_set_ep0state(dev, GR_EP0_SETUP);
>> +
>> +out:
>> +	gr_ep0out_requeue(dev);
>> +}
>> +
>> +/* ---------------------------------------------------------------------- */
>> +/* VBUS and USB reset handling */
>> +
>> +/* Must be called with dev->lock held */
>> +static void gr_vbus_connected(struct gr_udc *dev, u32 status)
>> +{
>> +	u32 control;
>> +
>> +	dev->gadget.speed = GR_SPEED(status);
>> +	usb_gadget_set_state(&dev->gadget, USB_STATE_POWERED);
>> +
>> +	/* Turn on full interrupts and pullup */
>> +	control = (GR_CONTROL_SI | GR_CONTROL_UI | GR_CONTROL_VI |
>> +		   GR_CONTROL_SP | GR_CONTROL_EP);
>> +	gr_write32(&dev->regs->control, control);
>> +}
>> +
>> +/* Must be called with dev->lock held */
>> +static void gr_enable_vbus_detect(struct gr_udc *dev)
>> +{
>> +	u32 status;
>> +
>> +	dev->irq_enabled = 1;
>> +	wmb(); /* Make sure we do not ignore an interrupt */
>> +	gr_write32(&dev->regs->control, GR_CONTROL_VI);
>> +
>> +	/* Take care of the case we are already plugged in at this point */
>> +	status = gr_read32(&dev->regs->status);
>> +	if (status & GR_STATUS_VB)
>> +		gr_vbus_connected(dev, status);
>> +}
>> +
>> +/* Must be called with dev->lock held */
>> +static void gr_vbus_disconnected(struct gr_udc *dev)
>> +{
>> +	gr_stop_activity(dev);
>> +
>> +	/* Report disconnect */
>> +	if (dev->driver && dev->driver->disconnect) {
>> +		spin_unlock(&dev->lock);
>> +
>> +		dev->driver->disconnect(&dev->gadget);
>> +
>> +		spin_lock(&dev->lock);
>> +	}
>> +
>> +	gr_enable_vbus_detect(dev);
>> +}
>> +
>> +/* Must be called with dev->lock held */
>> +static void gr_udc_usbreset(struct gr_udc *dev, u32 status)
>> +{
>> +	gr_set_address(dev, 0);
>> +	gr_set_ep0state(dev, GR_EP0_SETUP);
>> +	usb_gadget_set_state(&dev->gadget, USB_STATE_DEFAULT);
>> +	dev->gadget.speed = GR_SPEED(status);
>> +
>> +	gr_ep_nuke(&dev->epo[0]);
>> +	gr_ep_nuke(&dev->epi[0]);
>> +	dev->epo[0].stopped = 0;
>> +	dev->epi[0].stopped = 0;
>> +	gr_ep0out_requeue(dev);
>> +}
>> +
>> +/* ---------------------------------------------------------------------- */
>> +/* Irq and work handling */
>> +
>> +/*
>> + * Handles wq work for in endpoints. Returns whether work was handled.
>> + *
>> + * Must be called with dev->lock held and with !ep->stopped.
>> + */
>> +static int gr_handle_in_ep_work(struct gr_ep *ep)
>> +{
>> +	struct gr_request *req;
>> +
>> +	req = list_first_entry(&ep->queue, struct gr_request, queue);
>> +	if (!req->last_desc)
>> +		return 0;
>> +
>> +	if (gr_read32(&req->last_desc->ctrl) & GR_DESC_IN_CTRL_EN)
>> +		return 0; /* Not put in hardware buffers yet */
>> +
>> +	if (gr_read32(&ep->regs->epstat) & (GR_EPSTAT_B1 | GR_EPSTAT_B0))
>> +		return 0; /* Not transmitted yet, still in hardware buffers */
>> +
>> +	/* Write complete */
>> +	gr_dma_advance(ep, 0);
>> +
>> +	return 1;
>> +}
>> +
>> +/*
>> + * Handles wq work for out endpoints. Returns whether work was handled.
>> + *
>> + * Must be called with dev->lock held and with !ep->stopped.
>> + */
>> +static int gr_handle_out_ep_work(struct gr_ep *ep)
>> +{
>> +	u32 ep_dmactrl;
>> +	u32 ctrl;
>> +	u16 len;
>> +	struct gr_request *req;
>> +	struct gr_udc *dev = ep->dev;
>> +
>> +	req = list_first_entry(&ep->queue, struct gr_request, queue);
>> +	if (!req->curr_desc)
>> +		return 0;
>> +
>> +	ctrl = gr_read32(&req->curr_desc->ctrl);
>> +	if (ctrl & GR_DESC_OUT_CTRL_EN)
>> +		return 0; /* Not received yet */
>> +
>> +	/* Read complete */
>> +	len = ctrl & GR_DESC_OUT_CTRL_LEN_MASK;
>> +	req->req.actual += len;
>> +	if (ctrl & GR_DESC_OUT_CTRL_SE)
>> +		req->setup = 1;
>> +
>> +	if (len < ep->ep.maxpacket || req->req.actual == req->req.length) {
>> +		/* Short packet or the expected size - we are done */
>> +
>> +		if ((ep == &dev->epo[0]) && (dev->ep0state == GR_EP0_OSTATUS)) {
>> +			/*
>> +			 * Send a status stage ZLP to ack the DATA stage in the
>> +			 * OUT direction. This needs to be done before
>> +			 * gr_dma_advance as that can lead to a call to
>> +			 * ep0_setup that can change dev->ep0state.
>> +			 */
>> +			gr_ep0_respond_empty(dev);
>> +			gr_set_ep0state(dev, GR_EP0_SETUP);
>> +		}
>> +
>> +		gr_dma_advance(ep, 0);
>> +	} else {
>> +		/* Not done yet. Enable the next descriptor to receive more. */
>> +		req->curr_desc = req->curr_desc->next_desc;
>> +		req->curr_desc->ctrl |= GR_DESC_OUT_CTRL_EN;
>> +
>> +		ep_dmactrl = gr_read32(&ep->regs->dmactrl);
>> +		gr_write32(&ep->regs->dmactrl, ep_dmactrl | GR_DMACTRL_DA);
>> +	}
>> +
>> +	return 1;
>> +}
>> +
>> +/*
>> + * Handle state changes. Returns whether work was handled.
>> + *
>> + * Must be called with dev->lock held.
>> + */
>> +static int gr_handle_state_work(struct gr_udc *dev)
>> +{
>> +	u32 status = gr_read32(&dev->regs->status);
>> +	int handled = 0;
>> +	int powstate = !(dev->gadget.state == USB_STATE_NOTATTACHED ||
>> +			 dev->gadget.state == USB_STATE_ATTACHED);
>> +
>> +	/* VBUS valid detected */
>> +	if (!powstate && (status & GR_STATUS_VB)) {
>> +		DBG("STATUS: vbus valid detected\n");
>> +		gr_vbus_connected(dev, status);
>> +		handled = 1;
>> +	}
>> +
>> +	/* Disconnect */
>> +	if (powstate && !(status & GR_STATUS_VB)) {
>> +		DBG("STATUS: vbus invalid detected\n");
>> +		gr_vbus_disconnected(dev);
>> +		handled = 1;
>> +	}
>> +
>> +	/* USB reset detected */
>> +	if (status & GR_STATUS_UR) {
>> +		DBG("STATUS: USB reset - speed is %s\n", GR_SPEED_STR(status));
>> +		gr_write32(&dev->regs->status, GR_STATUS_UR);
>> +		gr_udc_usbreset(dev, status);
>> +		handled = 1;
>> +	}
>> +
>> +	/* Speed change */
>> +	if (dev->gadget.speed != GR_SPEED(status)) {
>> +		DBG("STATUS: USB Speed change to %s\n", GR_SPEED_STR(status));
>> +		dev->gadget.speed = GR_SPEED(status);
>> +		handled = 1;
>> +	}
>> +
>> +	/* Going into suspend */
>> +	if ((dev->ep0state != GR_EP0_SUSPEND) && !(status & GR_STATUS_SU)) {
>> +		DBG("STATUS: USB suspend\n");
>> +		gr_set_ep0state(dev, GR_EP0_SUSPEND);
>> +		dev->suspended_from = dev->gadget.state;
>> +		usb_gadget_set_state(&dev->gadget, USB_STATE_SUSPENDED);
>> +
>> +		if ((dev->gadget.speed != USB_SPEED_UNKNOWN) &&
>> +		    dev->driver && dev->driver->suspend) {
>> +			spin_unlock(&dev->lock);
>> +
>> +			dev->driver->suspend(&dev->gadget);
>> +
>> +			spin_lock(&dev->lock);
>> +		}
>> +		handled = 1;
>> +	}
>> +
>> +	/* Coming out of suspend */
>> +	if ((dev->ep0state == GR_EP0_SUSPEND) && (status & GR_STATUS_SU)) {
>> +		DBG("STATUS: USB resume\n");
>> +		if (dev->suspended_from == USB_STATE_POWERED)
>> +			gr_set_ep0state(dev, GR_EP0_DISCONNECT);
>> +		else
>> +			gr_set_ep0state(dev, GR_EP0_SETUP);
>> +		usb_gadget_set_state(&dev->gadget, dev->suspended_from);
>> +
>> +		if ((dev->gadget.speed != USB_SPEED_UNKNOWN) &&
>> +		    dev->driver && dev->driver->resume) {
>> +			spin_unlock(&dev->lock);
>> +
>> +			dev->driver->resume(&dev->gadget);
>> +
>> +			spin_lock(&dev->lock);
>> +		}
>> +		handled = 1;
>> +	}
>> +
>> +	return handled;
>> +}
>> +
>> +static void gr_work(struct work_struct *work)
>> +{
>> +	struct gr_udc *dev = container_of(work, struct gr_udc, work);
>> +	struct gr_ep *ep;
>> +	int handled = 0;
>> +	int i;
>> +
>> +	spin_lock(&dev->lock);
>> +
>> +	if (!dev->irq_enabled)
>> +		goto out;
>> +
>> +	/*
>> +	 * Check IN ep interrupts. We check these before the OUT eps because
>> +	 * some gadgets reuse the request that might already be currently
>> +	 * outstanding and needs to be completed (mainly setup requests).
>> +	 */
>> +	for (i = 0; i < dev->nepi; i++) {
>> +		ep = &dev->epi[i];
>> +		if (!ep->stopped && !ep->callback && !list_empty(&ep->queue))
>> +			handled = gr_handle_in_ep_work(ep) || handled;
>> +	}
>> +
>> +	/* Check OUT ep interrupts */
>> +	for (i = 0; i < dev->nepo; i++) {
>> +		ep = &dev->epo[i];
>> +		if (!ep->stopped && !ep->callback && !list_empty(&ep->queue))
>> +			handled = gr_handle_out_ep_work(ep) || handled;
>> +	}
>> +
>> +	/* Check status interrupts */
>> +	handled = gr_handle_state_work(dev) || handled;
>> +
>> +
>> +	/*
>> +	 * Check AMBA DMA errors. Only check if we didn't find anything else to
>> +	 * handle because this shouldn't happen if we did everything right.
>> +	 */
>> +	if (!handled) {
>> +		list_for_each_entry(ep, &dev->ep_list, ep_list) {
>> +			if (gr_read32(&ep->regs->dmactrl) & GR_DMACTRL_AE) {
>> +				dev_err(dev->dev, "AMBA Error occurred for %s\n",
>> +					ep->ep.name);
>> +				handled = 1;
>> +			}
>> +		}
>> +	}
>> +
>> +out:
>> +	spin_unlock(&dev->lock);
>> +}
>> +
>> +/* The interrupt handler just triggers the work handler */
>> +static irqreturn_t gr_irq(int irq, void *_dev)
>> +{
>> +	struct gr_udc *dev = _dev;
>> +
>> +	if (!dev->irq_enabled)
>> +		return IRQ_NONE;
>> +
>> +	schedule_work(&dev->work);
>
> why do you need this ? We have threaded IRQ handlers. Why a workqueue ?

As mentioned above, to to be able to schedule work after pausing
endpoint handling during a completion callback call or during an
endpoint halt.

Thank you for the feedback!

Best regards,
Andreas Larsson

