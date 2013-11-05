Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3KEPib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:38:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43123 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751217Ab3KEPia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:38:30 -0500
Date: Tue, 5 Nov 2013 10:38:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Cohen <david.a.cohen@linux.intel.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/4] usb: ffs: check quirk to pad epout buf size when
 not aligned to maxpacketsize
In-Reply-To: <52790925.7040306@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1311051026390.1360-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013, David Cohen wrote:

> >> +		/*
> >> +		 * Controller requires buffer size to be aligned to
> >> +		 * maxpacketsize of an out endpoint.
> >> +		 */
> >> +		if (gadget->quirk_ep_out_aligned_size && read) {
> >> +			/*
> >> +			 * We pass 'orig_len' to usp_ep_align_maxpacketsize()
> >> +			 * due to we're in a loop and 'len' may have been
> >> +			 * changed.
> >> +			 */
> >> +			len = usb_ep_align_maxpacketsize(ep->ep, orig_len);
> >> +			if (data && len > data_len) {
> >> +				kfree(data);
> >> +				data = NULL;
> >> +				data_len = 0;
> >> +			}
> >> +		}
> > 
> > Since the value of orig_len never changes, there's no point calling 
> > usb_ep_align_maxpacketsize() inside the loop.  You should call it only 
> > once, before the loop starts.  Once you do that, you won't need 
> > orig_len at all.
> 
> orig_len doesn't change but ep->ep does. If USB specs say max packet
> size won't change even if ep does, than we can call it from outside the
> loop.

I'm not too familiar with this driver.  It looks like the only way 
ep->ep can change is if the endpoint gets enabled while you're sitting 
inside the wait_event_interruptible() call.

In fact, the whole structure of that loop looks peculiar.  Why not
acquire the mutex first and then do everything else?

Does it even make sense for ep to change?  Would this change be visible
to the host?  What if the host changes the alternate setting while this
loop is running -- does it make sense for the userspace program to
start a read or write under one altsetting but then have the read/write
take place under a different altsetting?

Alan Stern

