Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaEHEAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 00:00:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:64143 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaEHEAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 00:00:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1008,1389772800"; 
   d="scan'208";a="528259772"
Date: Thu, 8 May 2014 12:00:47 -0400
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        liping.zhou@intel.com, david.a.cohen@linux.intel.com
Subject: Re: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
Message-ID: <20140508160046.GJ19925@intel.com>
Reply-To: jin.can.zhuang@intel.com
References: <20140508043902.GI19925@intel.com>
 <Pine.LNX.4.44L0.1405071252550.1325-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1405071252550.1325-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 12:59:06PM -0400, Alan Stern wrote:
> On Thu, 8 May 2014, Zhuang Jin Can wrote:
> 
> > > A similar problem can occur in the opposite sense: The thread queuing
> > > the delayed status request might be delayed for so long that another
> > > SETUP packet arrives from the host first.  In that case, the delayed
> > > status request is a response for a stale transfer, so it must not be
> > > sent to the host.
> > > 
> > > Do dwc3 and composite.c handle this case correctly?
> > > 
> > So the situation you describe is that we get the STATUS XferNotReady
> > event, but gadget queues a status request when control transfer already
> > failed.
> 
> When the host already timed out the control transfer and started a new 
> one.  Here's what I'm talking about:
> 
> 	Host sends a Set-Configuration request.
> 
> 	The UDC driver calls the gadget driver's setup function.
> 
> 	The setup function returns DELAYED_STATUS.
> 
> 	After a few seconds, the host gets tired of waiting and
> 	sends a Get-Descriptor request
My understanding is dwc3 will return NYET to host for this
Get-Descriptor request transaction, as dwc3 is still in STATUS phase,
there's no buffer to receive anything in ep0-out. And your below
comments is not applicapable to dwc3.
> 
> 	The gadget driver finally submits the delayed request response
> 	to the Set-Configuration request.  But it is now too late,
> 	because the host expects a response to the Get-Descriptor 
> 	request.
> 
> >  dwc3 can't move to SETUP phase until the status request arrives,
> > so any SETUP transaction from host will fail. If status request
> > eventually arrives, it already missed the first control transfer, and
> > I don't know how the controller will behave. If we still can get a
> > STATUS XferComplete event without actually transfer anything on the
> > bus, then we can move back to SETUP PHASE which will remove the stale
> > delayed status request and start the new SETUP transaction. But I think
> > in this situation, the host should already lose it patience and start
> > to reset the bus.
> 
> My point is that the UDC driver can't handle this.  Therefore the
> gadget driver has to prevent this from happening.
> 
> That means composite.c has to avoid sending delayed status responses if 
> a new SETUP packet has been received already.
> 
> > Per my understanding, it's impossible for dwc3 to send a stale STATUS
> > request for a new SETUP transaction. 
> 
> dwc3 won't know that the status response is stale.  It will think the 
> response was meant for the new transfer, not the old one.
> 
> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
