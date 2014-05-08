Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbaEGQmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:42:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:54673 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbaEGQmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:42:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1004,1389772800"; 
   d="scan'208";a="507780086"
Date: Thu, 8 May 2014 00:39:02 -0400
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        liping.zhou@intel.com, david.a.cohen@linux.intel.com
Subject: Re: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
Message-ID: <20140508043902.GI19925@intel.com>
Reply-To: jin.can.zhuang@intel.com
References: <20140507215344.GH19925@intel.com>
 <Pine.LNX.4.44L0.1405071050530.1325-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1405071050530.1325-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:03:42AM -0400, Alan Stern wrote:
> On Wed, 7 May 2014, Zhuang Jin Can wrote:
> 
> > A delayed status request may be queued before composite framework returns
> > USB_GADGET_DELAYED_STATUS, because the thread queueing the request can run
> > on a different core in parallel with the control request irq.
> > 
> > SETUP XferComplete IRQ        		fsg_main_thread
> > ----------------------        		---------------
> > 	|					|
> > spin_lock_irqsave(&dwc->lock)               sleeping
> > 	|					|
> > 	...					...
> > dwc3_ep0_inspect_setup()			|
> > 	|					|
> > dwc3_ep0_delegate_req() 			|
> > 	|					|
> > 	...					|
> > spin_unlock(&dwc->lock);			|
> > 	|					|
> > fsg_set_alt()   ======> Signal Wakeup ====>	|
> > 	| 					|
> > other gadgets->set_alt() 	       handle exception
> > 	|					|
> > 	|			usb_composite_setup_continue()
> > 	|					|
> > 	|			spin_lock_irqsave(&dwc->lock)
> >   	|			     __dwc3_gadget_ep0_queue()
> > 	|				 delay_status is false
> > 	|			spin_unlock_irqrestore(&dwc->lock)
> > 	|					|
> > 	|				     sleeping
> > spin_lock(&dwc->lock); 				|
> > 	|					|
> > delayed_status=true				|
> > 	|					|
> > 
> > 		STATUS XferNotReady IRQ
> > 		------------------------
> > 			|
> > 		dwc3_ep0_xfernotready()
> > 			|
> > 		   delayed_status is true, return;
> > 
> > The result is the status packet will never be transferred, and
> > delayed_status is not cleared.
> > 
> > Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> > Reported-by: Zhou Liping <liping.zhou@intel.com>
> 
> A similar problem can occur in the opposite sense: The thread queuing
> the delayed status request might be delayed for so long that another
> SETUP packet arrives from the host first.  In that case, the delayed
> status request is a response for a stale transfer, so it must not be
> sent to the host.
> 
> Do dwc3 and composite.c handle this case correctly?
> 
So the situation you describe is that we get the STATUS XferNotReady
event, but gadget queues a status request when control transfer already
failed. dwc3 can't move to SETUP phase until the status request arrives,
so any SETUP transaction from host will fail. If status request
eventually arrives, it already missed the first control transfer, and
I don't know how the controller will behave. If we still can get a
STATUS XferComplete event without actually transfer anything on the
bus, then we can move back to SETUP PHASE which will remove the stale
delayed status request and start the new SETUP transaction. But I think
in this situation, the host should already lose it patience and start
to reset the bus.

Per my understanding, it's impossible for dwc3 to send a stale STATUS
request for a new SETUP transaction. 

> Back in the old g_file_storage driver, I addressed this issue by
> keeping a counter of all the setup requests.  When it came time to send
> a delayed status response, the response would be sent only if the
> counter had not changed from when the original setup request was
> received.
> 
> As far as I can see, composite.c doesn't do anything like that.
> 
> Alan Stern
