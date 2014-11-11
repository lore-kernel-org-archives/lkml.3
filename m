Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaKKEjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:39:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaKKEjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:39:39 -0500
Date: Tue, 11 Nov 2014 13:38:21 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [V2 PATCH 03/10] added media agnostic (MA) data structures and
 handling
Message-ID: <20141111043821.GD22068@kroah.com>
References: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415671781-11351-3-git-send-email-stephanie.s.wallick@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415671781-11351-3-git-send-email-stephanie.s.wallick@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 06:09:34PM -0800, Stephanie Wallick wrote:
> +/**
> + * Returns the number of urbs currently in the MA USB HCD. Will return 0 if the
> + * MA USB HCD is empty or a negative errno if an error occurs.

How can this function return a negative number?  I don't see that
codepath here, can you show it to me?

> + */
> +int mausb_hcd_urb_count(struct mausb_hcd *mhcd)
> +{
> +	int			count = 0;
> +	struct mausb_host_ep	*ma_ep;
> +	struct mausb_dev	*mausb_dev;
> +	struct mausb_urb	*maurb;
> +	unsigned long		irq_flags;
> +
> +	/* for every device */
> +	spin_lock_irqsave(&mhcd->hcd_lock, irq_flags);
> +	list_for_each_entry(mausb_dev, &mhcd->ma_dev.dev_list, dev_list) {
> +		spin_unlock_irqrestore(&mhcd->hcd_lock, irq_flags);
> +
> +		/* for every endpoint */
> +		spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
> +		list_for_each_entry(ma_ep, &mausb_dev->ep_list, ep_list) {
> +			spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
> +
> +			/* for every urb */
> +			spin_lock_irqsave(&ma_ep->ep_lock, irq_flags);
> +			list_for_each_entry(maurb, &ma_ep->urb_list, urb_list) {
> +				++count;
> +			}
> +
> +			spin_unlock_irqrestore(&ma_ep->ep_lock, irq_flags);
> +			spin_lock_irqsave(&mausb_dev->dev_lock, irq_flags);
> +		}
> +
> +		spin_unlock_irqrestore(&mausb_dev->dev_lock, irq_flags);
> +		spin_lock_irqsave(&mhcd->hcd_lock, irq_flags);
> +	}
> +
> +	spin_unlock_irqrestore(&mhcd->hcd_lock, irq_flags);
> +
> +	return count;
> +}

There honestly is too many things wrong with this function to even know
where to start.  So how about I just ask why you would ever want to know
this number, and what good it would do to even care about it?  You do
realize that this number is almost always guaranteed to be wrong once
the function returns, so you better not be doing something with it that
matters.

Intel has a whole group of very experienced Linux kernel developers who
will review code before you sent it out publicly.  Please take advantage
of them and run this all through them before resending this out again.

If you did run this code through that group, please let me know who it
was specifically that allowed this stuff to get through, and why they
didn't want their name on this code submission.  I need to have a strong
word with them...

Yes, I am holding you to a higher standard than staging code normally
is, and yes, it is purely because of the company you work for.  But I
only do that because your company knows how to do this stuff right, and
you have access to the resources and talent to help make this code
right.  Other people and companies do not have the kind of advantage
that you do.

Wasting community member's time (i.e. mine) by forcing _them_ to review
stuff like this, is something that your company knows better than to do,
as should you as well.

I want to see some more senior Intel kernel developer's signed-off-by
lines on this code before I will ever consider accepting it for the
kernel.  Please do not resend this code until that happens.

greg k-h
