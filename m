Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbaEHVSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:18:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42643 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755589AbaEHVSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:18:14 -0400
Date: Thu, 8 May 2014 17:18:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
cc: Zhuang Jin Can <jin.can.zhuang@intel.com>, Felipe Balbi <balbi@ti.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "liping.zhou@intel.com" <liping.zhou@intel.com>,
        "david.a.cohen@linux.intel.com" <david.a.cohen@linux.intel.com>
Subject: RE: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E03046D195F08@US01WEMBX2.internal.synopsys.com>
Message-ID: <Pine.LNX.4.44L0.1405081712420.995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Paul Zimmerman wrote:

> > When the host already timed out the control transfer and started a new
> > one.  Here's what I'm talking about:
> > 
> > 	Host sends a Set-Configuration request.
> > 
> > 	The UDC driver calls the gadget driver's setup function.
> > 
> > 	The setup function returns DELAYED_STATUS.
> > 
> > 	After a few seconds, the host gets tired of waiting and
> > 	sends a Get-Descriptor request
> > 
> > 	The gadget driver finally submits the delayed request response
> > 	to the Set-Configuration request.  But it is now too late,
> > 	because the host expects a response to the Get-Descriptor
> > 	request.
> > 
> > >  dwc3 can't move to SETUP phase until the status request arrives,
> > > so any SETUP transaction from host will fail. If status request
> > > eventually arrives, it already missed the first control transfer, and
> > > I don't know how the controller will behave. If we still can get a
> > > STATUS XferComplete event without actually transfer anything on the
> > > bus, then we can move back to SETUP PHASE which will remove the stale
> > > delayed status request and start the new SETUP transaction. But I think
> > > in this situation, the host should already lose it patience and start
> > > to reset the bus.
> > 
> > My point is that the UDC driver can't handle this.  Therefore the
> > gadget driver has to prevent this from happening.
> > 
> > That means composite.c has to avoid sending delayed status responses if
> > a new SETUP packet has been received already.
> > 
> > > Per my understanding, it's impossible for dwc3 to send a stale STATUS
> > > request for a new SETUP transaction.
> > 
> > dwc3 won't know that the status response is stale.  It will think the
> > response was meant for the new transfer, not the old one.
> 
> The DWC3 controller will actually handle this case on its own. If
> it sees another SETUP packet come in before the previous Control
> transfer has completed, it will not send any DATA or STATUS phase
> packets for the previous Control transfer to the host. But it will
> "fake" the correct responses to the software, so the dwc3 driver will
> think that the DATA/STATUS stages completed successfully, even though
> nothing actually went out on the bus.

That doesn't handle the problem I described above.  When the dwc3 
driver gets the late delayed status response, it will think it is a 
response to the new SETUP packet, and so it will carry out a bogus 
transfer.  It won't know that the status request was meant to be a 
response to a defunct control transfer.

> For other controllers that can't do this, maybe it should be handled
> in the UDC driver rather than in the composite gadget?

The only place this can be handled properly is in the gadget driver:
composite.c for those gadgets using it, otherwise in the higher level 
driver (if there are any remaining gadgets that don't use the composite 
framework).

Alan Stern

