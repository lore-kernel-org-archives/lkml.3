Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab3BFUJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:09:40 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:51312 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758144Ab3BFUJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:09:36 -0500
Message-ID: <1360181366.5226.19.camel@thor.lan>
Subject: Re: [PATCH 3/4] pps: Use lookup list to reduce ldisc coupling
From: Peter Hurley <peter@hurleysoftware.com>
To: George Spelvin <linux@horizon.com>
Cc: giometti@enneenne.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Wed, 06 Feb 2013 15:09:26 -0500
In-Reply-To: <20130206193415.10769.qmail@science.horizon.com>
References: <20130206193415.10769.qmail@science.horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-06 at 14:34 -0500, George Spelvin wrote:
> > Now that N_TTY uses tty->disc_data for its private data,
> > 'subclass' ldiscs cannot use ->disc_data for their own private data.
> > 
> > Use a lookup list to associate the tty with the pps source.
> 
> Thanks for the cleanup.  I fully agree my patch was not a good one;
> I just wanted someone more experienced to make the call on rearchitecting.
> 
> In particular, I was nervous about getting flamed by Linus for something that
> was too ambitious.

No problem and I completely understand. That's why I jumped in -- it
looked like some help was needed, both now and maybe even in iterations
before this.

> One thing I'd prefer to do would be to change:
> 
> +static struct pps_device *lookup_pps_by_tty(struct tty_struct *tty,
> +					    struct pps_data **p)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pps_lock, flags);
> +	list_for_each_entry((*p), &pps_list, link) {
> +		if ((*p)->tty == tty) {
> +			spin_unlock_irqrestore(&pps_lock, flags);
> +			return (*p)->pps;
> +		}
> +	}
> +	spin_unlock_irqrestore(&pps_lock, flags);
> +	return NULL;
> +}
> 
> to:
> 
> static struct pps_data *lookup_pps_by_tty(struct tty_struct *tty)
> {
> 	unsigned long flags;
> 
> 	spin_lock_irqsave(&pps_lock, flags);
> 	list_for_each_entry(p, &pps_list, link) {
> 		if (p->tty == tty)
> 			break;
> 	}
> 	spin_unlock_irqrestore(&pps_lock, flags);
> 	return p;
> }
> 
> And do the data->pps dereferencing in the caller.

I did this first and it's a mess -- the patch basically ends up looking
like a rewrite. But feel free to use these patches as a base for a
version you do like and submit those instead for review. I just wanted
to show the way.

(Well, actually that was the second version. When I reviewed the
uart_handle_dcd_change() and saw the separate timestamp, I thought that
maybe the latency was going to be a problem. So the first version used
the same approach but with an rcu 'lockless' list instead -- then I went
back and audited the IRQ path and realized there were 5 bus locks and an
i/o port read already. So total overkill.)

Also, I figured maybe it would be best if it was something maintainable
with basic kernel knowledge.

> A more ambitious cleanup would use the existing pps_device list
> (maintained to allocate minor device numbers) and add an "owner" field
> that can be looked up on, without creating a new data structure and
> allocation.

Didn't see where that was (unless you mean the IDR allocation). Probably
best to keep it separate in the event that relative lifetimes change at
some point in the future.

> (It could either be a generic "void *", or a "struct device *" and
> compare it to tty->dev.)
> 
> After all, despite the implementation effort to scale, the total number
> of pps devices in a system is usually at most 1 (I have a computer where
> I run 2, and I doubt there are many others on the planet who do that.)

I thought that was probably the case which is why a lookup list is an
acceptable solution.

Please let us know if you plan to respin the patches, so these patches
don't get pushed.

Regards,
Peter Hurley

