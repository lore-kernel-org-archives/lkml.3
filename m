Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaEHTzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:55:08 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:33556 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaEHTzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:55:05 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Zhuang Jin Can <jin.can.zhuang@intel.com>
CC: Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Kernel development list" <linux-kernel@vger.kernel.org>,
        "liping.zhou@intel.com" <liping.zhou@intel.com>,
        "david.a.cohen@linux.intel.com" <david.a.cohen@linux.intel.com>
Subject: RE: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
Thread-Topic: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
Thread-Index: AQHPadpVnVt9YxFaw0ycZBcOSk/9DZs1rLUAgADjzQD//zxxAIABSmVg
Date: Thu, 8 May 2014 19:55:03 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E03046D195F08@US01WEMBX2.internal.synopsys.com>
References: <20140508043902.GI19925@intel.com>
 <Pine.LNX.4.44L0.1405071252550.1325-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1405071252550.1325-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Alan Stern
> Sent: Wednesday, May 07, 2014 9:59 AM
> 
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

The DWC3 controller will actually handle this case on its own. If
it sees another SETUP packet come in before the previous Control
transfer has completed, it will not send any DATA or STATUS phase
packets for the previous Control transfer to the host. But it will
"fake" the correct responses to the software, so the dwc3 driver will
think that the DATA/STATUS stages completed successfully, even though
nothing actually went out on the bus.

For other controllers that can't do this, maybe it should be handled
in the UDC driver rather than in the composite gadget?

-- 
Paul

