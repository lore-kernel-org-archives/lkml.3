Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaKLVkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:40:36 -0500
Received: from mga03.intel.com ([134.134.136.65]:34716 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbaKLVke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:40:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,371,1413270000"; 
   d="scan'208";a="636002786"
Date: Wed, 12 Nov 2014 13:40:21 -0800
From: "Sean O. Stalley" <sean.stalley@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephanie Wallick <stephanie.s.wallick@intel.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [V2 PATCH 01/10] added media agnostic (MA) USB HCD driver
Message-ID: <20141112214021.GA3531@sean.stalley.intel.com>
References: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
 <Pine.LNX.4.44L0.1411111042160.8671-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1411111042160.8671-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing. My responses are inline.

Greg has asked that we clean up this code internally before we
send out another patchset to the mailing list. I will address
the issues you pointed out, but it may be a while before you see
another patchset.

Thanks Again,
Sean

On Tue, Nov 11, 2014 at 10:54:30AM -0500, Alan Stern wrote:
> On Mon, 10 Nov 2014, Stephanie Wallick wrote:
> 
> > +static struct mausb_hcd mhcd;
> 
> Only one statically-allocated structure?  What if somebody wants to 
> have more than one of these things in their system?
> 

Our plan to support multiple MA devices is to have them all connected
to the same virtual host controller, so only 1 would be needed.

Would you prefer we have 1 host controller instance per MA device?
We are definitely open to suggestions on how this should be architected.

> > +/**
> > + * @maurb:	Media agnostic structure with URB to release.
> > + * @status:	Status for URB that is getting released.
> > + *
> > + * Removes an URB from the queue, deletes the media agnostic information in
> > + * the urb, and gives the URB back to the HCD. Caller must be holding the
> > + * driver's spinlock.
> > + */
> > +void mausb_unlink_giveback_urb(struct mausb_urb *maurb, int status)
> > +{
> > +	struct urb		*urb;
> > +	struct usb_hcd		*hcd;
> > +	struct api_context	*ctx = NULL;
> > +	unsigned long		irq_flags;
> > +
> > +	hcd = mausb_hcd_to_usb_hcd(&mhcd);
> > +
> > +	spin_lock_irqsave(&mhcd.giveback_lock, irq_flags);
> 
> Why do you need multiple spinlocks?  Isn't one lock sufficient?
> 
We will simplify the locking scheme before resubmitting.

I think it might be worthwhile to have a per-endpoint lock, see below.

> > +	if (!maurb) {
> > +		mausb_err(&mhcd, "%s: no maurb\n", __func__);
> > +		spin_unlock_irqrestore(&mhcd.giveback_lock, irq_flags);
> > +		return;
> > +	} else {
> > +		urb = maurb->urb;
> > +		ctx = urb->context;
> > +	}
> > +
> > +	if (!urb) {
> > +		mausb_err(&mhcd, "%s: no urb\n", __func__);
> > +		mausb_internal_drop_maurb(maurb, &mhcd);
> > +		spin_unlock_irqrestore(&mhcd.giveback_lock, irq_flags);
> > +		return;
> > +	}
> > +
> > +	mausb_dbg(&mhcd, "%s: returning urb with status %i\n", __func__, status);
> > +
> > +	usb_hcd_unlink_urb_from_ep(hcd, urb);
> > +	usb_hcd_giveback_urb(hcd, urb, status);
> 
> You must not call this function while holding any spinlocks.  What happens
> if the URB's completion routine tries to resubmit?
> 

This works with our multi-lock scheme, but I will fix when we move to 1 lock.

> > +
> > +	/* remove the mausb-specific data */
> > +	mausb_internal_drop_maurb(maurb, &mhcd);
> > +
> > +	spin_unlock_irqrestore(&mhcd.giveback_lock, irq_flags);
> > +}
> > +
> > +/**
> > + * Adds an URB to the endpoint queue then calls the URB handler. URB is wrapped
> > + * in media agnostic structure before being enqueued.
> > + */
> > +static int mausb_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
> > +		gfp_t memflags)
> > +{
> > +	int			ret = 0;
> > +	struct mausb_urb	*maurb;
> > +	struct mausb_host_ep	*ep;
> > +	unsigned long		irq_flags;
> > +
> > +	if (!hcd || !urb) {
> > +		pr_err("%s: no %s\n", __func__, (hcd ? "urb" : "USB hcd"));
> > +	}
> 
> This can never happen.  The USB core guarantees it; you don't need 
> to check.
> 

I will remove this check (along with any other unnecessary checks for things
guaranteed from usbcore).

> > +	ep   = usb_to_ma_endpoint(urb->ep);
> > +
> > +	if (!ep) {
> > +		mausb_err(&mhcd, "%s: no endpoint\n", __func__);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (urb->status != -EINPROGRESS) {
> > +		mausb_err(&mhcd, "%s: urb already unlinked, status is %i\n",
> > +			__func__, urb->status);
> > +		return urb->status;
> > +	}
> 
> You also don't need to check this.
> 
Will remove.

> > +	/* If the endpoint isn't activated, we can't enqueue anything. */
> > +	if (MAUSB_EP_HANDLE_UNASSIGNED == ep->ep_handle_state) {
> > +		mausb_err(&mhcd, "%s: endpoint handle unassigned\n", __func__);
> > +		return -EPIPE;
> > +	}
> > +
> > +	if (USB_SPEED_FULL != urb->dev->speed) /* suppress checks */
> > +		ep->max_pkt = usb_endpoint_maxp(&urb->ep->desc);
> 
> What happens to full-speed devices?  Don't they have maxpacket values?
> 
> > +
> > +	/* initialize the maurb */
> > +	maurb = mausb_alloc_maurb(ep, memflags);
> > +	if (!maurb) {
> > +		mausb_err(&mhcd, "could not allocate memory for MA USB urb\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* set maurb member values */
> > +	maurb->urb = urb;
> > +	urb->hcpriv = maurb;
> > +
> > +	/* submit urb to hcd and add to endpoint queue */
> > +	ret = usb_hcd_link_urb_to_ep(hcd, urb);
> 
> Read the kerneldoc for this function.  You must hold your private
> spinlock when you call it.
> 

Will fix this & make sure we hold our lock.

> > +	if (ret < 0) {
> > +		mausb_err(&mhcd, "urb enqueue failed: error %d\n", ret);
> > +		usb_hcd_unlink_urb_from_ep(hcd, urb);
> > +		return ret;
> > +	}
> > +
> > +	/* get usb device and increment reference counter */
> > +	if (!mhcd.udev) {
> > +		mhcd.udev = urb->dev;
> > +		usb_get_dev(mhcd.udev);
> > +	}
> 
> What happens if more than one device is in use at a time?
> 
> > +
> > +	/* add urb to queue list */
> > +	spin_lock_irqsave(&ep->ep_lock, irq_flags);
> > +	list_add_tail(&maurb->urb_list, &ep->urb_list);
> > +	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
> 
> Yet another class of spinlocks!
> 

If we get rid of these locks, endpoints can't run simultaneously.
MA USB IN endpoints have to copy data, which could take a while.

Couldn't this cause a bottleneck?

> > +	/* add urb to ma hcd urb list */
> > +	spin_lock_irqsave(&mhcd.urb_list_lock, irq_flags);
> 
> And another!  You really shouldn't need more than one lock.
> 

Will remove.

> > +	list_add_tail(&maurb->ma_hcd_urb_list, &mhcd.enqueue_urb_list);
> > +	spin_unlock_irqrestore(&mhcd.urb_list_lock, irq_flags);
> > +
> > +	/* send to MA transfer process */
> > +	wake_up(&mhcd.waitq);
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * Dequeues an URB.
> > + */
> > +static int mausb_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
> > +{
> > +	int			ret	= 0;
> > +	struct mausb_host_ep	*ep = usb_to_ma_endpoint(urb->ep);
> > +	struct mausb_urb	*maurb = usb_urb_to_mausb_urb(urb);
> > +	unsigned long		irq_flags;
> > +
> > +	/* For debugging - we want to know who initiated URB dequeue. */
> > +	dump_stack();
> 
> Debugging things like this should be removed before a patch is submitted.

Will grep & remove all debugging messages before we release the next patchset.

> 
> That's enough for now.  Obviously there are a lot of issues in this 
> driver which need to be fixed up.

We will try to address all the obvious issues before submitting again.

> 
> Alan Stern
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
