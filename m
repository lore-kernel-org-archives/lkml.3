Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaKKPye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:54:34 -0500
Received: from netrider.rowland.org ([192.131.102.5]:33519 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751086AbaKKPyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:54:32 -0500
Date: Tue, 11 Nov 2014 10:54:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
cc: linux-kernel@vger.kernel.org, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [V2 PATCH 01/10] added media agnostic (MA) USB HCD driver
In-Reply-To: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
Message-ID: <Pine.LNX.4.44L0.1411111042160.8671-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Stephanie Wallick wrote:

> +static struct mausb_hcd mhcd;

Only one statically-allocated structure?  What if somebody wants to 
have more than one of these things in their system?

> +/**
> + * @maurb:	Media agnostic structure with URB to release.
> + * @status:	Status for URB that is getting released.
> + *
> + * Removes an URB from the queue, deletes the media agnostic information in
> + * the urb, and gives the URB back to the HCD. Caller must be holding the
> + * driver's spinlock.
> + */
> +void mausb_unlink_giveback_urb(struct mausb_urb *maurb, int status)
> +{
> +	struct urb		*urb;
> +	struct usb_hcd		*hcd;
> +	struct api_context	*ctx = NULL;
> +	unsigned long		irq_flags;
> +
> +	hcd = mausb_hcd_to_usb_hcd(&mhcd);
> +
> +	spin_lock_irqsave(&mhcd.giveback_lock, irq_flags);

Why do you need multiple spinlocks?  Isn't one lock sufficient?

> +	if (!maurb) {
> +		mausb_err(&mhcd, "%s: no maurb\n", __func__);
> +		spin_unlock_irqrestore(&mhcd.giveback_lock, irq_flags);
> +		return;
> +	} else {
> +		urb = maurb->urb;
> +		ctx = urb->context;
> +	}
> +
> +	if (!urb) {
> +		mausb_err(&mhcd, "%s: no urb\n", __func__);
> +		mausb_internal_drop_maurb(maurb, &mhcd);
> +		spin_unlock_irqrestore(&mhcd.giveback_lock, irq_flags);
> +		return;
> +	}
> +
> +	mausb_dbg(&mhcd, "%s: returning urb with status %i\n", __func__, status);
> +
> +	usb_hcd_unlink_urb_from_ep(hcd, urb);
> +	usb_hcd_giveback_urb(hcd, urb, status);

You must not call this function while holding any spinlocks.  What happens
if the URB's completion routine tries to resubmit?

> +
> +	/* remove the mausb-specific data */
> +	mausb_internal_drop_maurb(maurb, &mhcd);
> +
> +	spin_unlock_irqrestore(&mhcd.giveback_lock, irq_flags);
> +}
> +
> +/**
> + * Adds an URB to the endpoint queue then calls the URB handler. URB is wrapped
> + * in media agnostic structure before being enqueued.
> + */
> +static int mausb_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
> +		gfp_t memflags)
> +{
> +	int			ret = 0;
> +	struct mausb_urb	*maurb;
> +	struct mausb_host_ep	*ep;
> +	unsigned long		irq_flags;
> +
> +	if (!hcd || !urb) {
> +		pr_err("%s: no %s\n", __func__, (hcd ? "urb" : "USB hcd"));
> +	}

This can never happen.  The USB core guarantees it; you don't need 
to check.

> +	ep   = usb_to_ma_endpoint(urb->ep);
> +
> +	if (!ep) {
> +		mausb_err(&mhcd, "%s: no endpoint\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	if (urb->status != -EINPROGRESS) {
> +		mausb_err(&mhcd, "%s: urb already unlinked, status is %i\n",
> +			__func__, urb->status);
> +		return urb->status;
> +	}

You also don't need to check this.

> +	/* If the endpoint isn't activated, we can't enqueue anything. */
> +	if (MAUSB_EP_HANDLE_UNASSIGNED == ep->ep_handle_state) {
> +		mausb_err(&mhcd, "%s: endpoint handle unassigned\n", __func__);
> +		return -EPIPE;
> +	}
> +
> +	if (USB_SPEED_FULL != urb->dev->speed) /* suppress checks */
> +		ep->max_pkt = usb_endpoint_maxp(&urb->ep->desc);

What happens to full-speed devices?  Don't they have maxpacket values?

> +
> +	/* initialize the maurb */
> +	maurb = mausb_alloc_maurb(ep, memflags);
> +	if (!maurb) {
> +		mausb_err(&mhcd, "could not allocate memory for MA USB urb\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* set maurb member values */
> +	maurb->urb = urb;
> +	urb->hcpriv = maurb;
> +
> +	/* submit urb to hcd and add to endpoint queue */
> +	ret = usb_hcd_link_urb_to_ep(hcd, urb);

Read the kerneldoc for this function.  You must hold your private
spinlock when you call it.

> +	if (ret < 0) {
> +		mausb_err(&mhcd, "urb enqueue failed: error %d\n", ret);
> +		usb_hcd_unlink_urb_from_ep(hcd, urb);
> +		return ret;
> +	}
> +
> +	/* get usb device and increment reference counter */
> +	if (!mhcd.udev) {
> +		mhcd.udev = urb->dev;
> +		usb_get_dev(mhcd.udev);
> +	}

What happens if more than one device is in use at a time?

> +
> +	/* add urb to queue list */
> +	spin_lock_irqsave(&ep->ep_lock, irq_flags);
> +	list_add_tail(&maurb->urb_list, &ep->urb_list);
> +	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);

Yet another class of spinlocks!

> +	/* add urb to ma hcd urb list */
> +	spin_lock_irqsave(&mhcd.urb_list_lock, irq_flags);

And another!  You really shouldn't need more than one lock.

> +	list_add_tail(&maurb->ma_hcd_urb_list, &mhcd.enqueue_urb_list);
> +	spin_unlock_irqrestore(&mhcd.urb_list_lock, irq_flags);
> +
> +	/* send to MA transfer process */
> +	wake_up(&mhcd.waitq);
> +
> +	return ret;
> +}
> +
> +/**
> + * Dequeues an URB.
> + */
> +static int mausb_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
> +{
> +	int			ret	= 0;
> +	struct mausb_host_ep	*ep = usb_to_ma_endpoint(urb->ep);
> +	struct mausb_urb	*maurb = usb_urb_to_mausb_urb(urb);
> +	unsigned long		irq_flags;
> +
> +	/* For debugging - we want to know who initiated URB dequeue. */
> +	dump_stack();

Debugging things like this should be removed before a patch is submitted.

That's enough for now.  Obviously there are a lot of issues in this 
driver which need to be fixed up.

Alan Stern


