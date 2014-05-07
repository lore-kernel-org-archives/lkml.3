Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbaEGPDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:03:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42539 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752197AbaEGPDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:03:43 -0400
Date: Wed, 7 May 2014 11:03:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>, Zhuang Jin Can <jin.can.zhuang@intel.com>
cc: USB list <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <liping.zhou@intel.com>, <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
In-Reply-To: <20140507215344.GH19925@intel.com>
Message-ID: <Pine.LNX.4.44L0.1405071050530.1325-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Zhuang Jin Can wrote:

> A delayed status request may be queued before composite framework returns
> USB_GADGET_DELAYED_STATUS, because the thread queueing the request can run
> on a different core in parallel with the control request irq.
> 
> SETUP XferComplete IRQ        		fsg_main_thread
> ----------------------        		---------------
> 	|					|
> spin_lock_irqsave(&dwc->lock)               sleeping
> 	|					|
> 	...					...
> dwc3_ep0_inspect_setup()			|
> 	|					|
> dwc3_ep0_delegate_req() 			|
> 	|					|
> 	...					|
> spin_unlock(&dwc->lock);			|
> 	|					|
> fsg_set_alt()   ======> Signal Wakeup ====>	|
> 	| 					|
> other gadgets->set_alt() 	       handle exception
> 	|					|
> 	|			usb_composite_setup_continue()
> 	|					|
> 	|			spin_lock_irqsave(&dwc->lock)
>   	|			     __dwc3_gadget_ep0_queue()
> 	|				 delay_status is false
> 	|			spin_unlock_irqrestore(&dwc->lock)
> 	|					|
> 	|				     sleeping
> spin_lock(&dwc->lock); 				|
> 	|					|
> delayed_status=true				|
> 	|					|
> 
> 		STATUS XferNotReady IRQ
> 		------------------------
> 			|
> 		dwc3_ep0_xfernotready()
> 			|
> 		   delayed_status is true, return;
> 
> The result is the status packet will never be transferred, and
> delayed_status is not cleared.
> 
> Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> Reported-by: Zhou Liping <liping.zhou@intel.com>

A similar problem can occur in the opposite sense: The thread queuing
the delayed status request might be delayed for so long that another
SETUP packet arrives from the host first.  In that case, the delayed
status request is a response for a stale transfer, so it must not be
sent to the host.

Do dwc3 and composite.c handle this case correctly?

Back in the old g_file_storage driver, I addressed this issue by
keeping a counter of all the setup requests.  When it came time to send
a delayed status response, the response would be sent only if the
counter had not changed from when the original setup request was
received.

As far as I can see, composite.c doesn't do anything like that.

Alan Stern

