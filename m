Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaEHXBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 19:01:39 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:35949 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbaEHXBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 19:01:37 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Zhuang Jin Can <jin.can.zhuang@intel.com>, Felipe Balbi <balbi@ti.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "liping.zhou@intel.com" <liping.zhou@intel.com>,
        "david.a.cohen@linux.intel.com" <david.a.cohen@linux.intel.com>
Subject: RE: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
Thread-Topic: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
Thread-Index: AQHPadpVnVt9YxFaw0ycZBcOSk/9DZs1rLUAgADjzQD//zxxAIABSmVggACQVoD//54qcA==
Date: Thu, 8 May 2014 23:01:36 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E03046D195FB1@US01WEMBX2.internal.synopsys.com>
References: <A2CA0424C0A6F04399FB9E1CD98E03046D195F08@US01WEMBX2.internal.synopsys.com>
 <Pine.LNX.4.44L0.1405081712420.995-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1405081712420.995-100000@iolanthe.rowland.org>
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

> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Thursday, May 08, 2014 2:18 PM
> 
> On Thu, 8 May 2014, Paul Zimmerman wrote:
> 
> > > When the host already timed out the control transfer and started a new
> > > one.  Here's what I'm talking about:
> > >
> > > 	Host sends a Set-Configuration request.
> > >
> > > 	The UDC driver calls the gadget driver's setup function.
> > >
> > > 	The setup function returns DELAYED_STATUS.
> > >
> > > 	After a few seconds, the host gets tired of waiting and
> > > 	sends a Get-Descriptor request
> > >
> > > 	The gadget driver finally submits the delayed request response
> > > 	to the Set-Configuration request.  But it is now too late,
> > > 	because the host expects a response to the Get-Descriptor
> > > 	request.
> > >
> > > >  dwc3 can't move to SETUP phase until the status request arrives,
> > > > so any SETUP transaction from host will fail. If status request
> > > > eventually arrives, it already missed the first control transfer, and
> > > > I don't know how the controller will behave. If we still can get a
> > > > STATUS XferComplete event without actually transfer anything on the
> > > > bus, then we can move back to SETUP PHASE which will remove the stale
> > > > delayed status request and start the new SETUP transaction. But I think
> > > > in this situation, the host should already lose it patience and start
> > > > to reset the bus.
> > >
> > > My point is that the UDC driver can't handle this.  Therefore the
> > > gadget driver has to prevent this from happening.
> > >
> > > That means composite.c has to avoid sending delayed status responses if
> > > a new SETUP packet has been received already.
> > >
> > > > Per my understanding, it's impossible for dwc3 to send a stale STATUS
> > > > request for a new SETUP transaction.
> > >
> > > dwc3 won't know that the status response is stale.  It will think the
> > > response was meant for the new transfer, not the old one.
> >
> > The DWC3 controller will actually handle this case on its own. If
> > it sees another SETUP packet come in before the previous Control
> > transfer has completed, it will not send any DATA or STATUS phase
> > packets for the previous Control transfer to the host. But it will
> > "fake" the correct responses to the software, so the dwc3 driver will
> > think that the DATA/STATUS stages completed successfully, even though
> > nothing actually went out on the bus.
> 
> That doesn't handle the problem I described above.  When the dwc3
> driver gets the late delayed status response, it will think it is a
> response to the new SETUP packet, and so it will carry out a bogus
> transfer.  It won't know that the status request was meant to be a
> response to a defunct control transfer.

I think you misunderstood me. What I meant was, once the DWC3
controller sees the next SETUP packet, it will still accept the
commands from the dwc3 driver to start the DATA and STATUS phases
for the previous Control transfer, and will send back (fake) completion
events for those commands to the driver. But it won't actually send
anything on the wire.

So it should be impossible for the dwc3 driver to carry out a bogus
transfer. This is a feature of the DWC3 controller intended to
simplify what the software needs to handle, and to automatically
take care of the corner cases involved here.

> > For other controllers that can't do this, maybe it should be handled
> > in the UDC driver rather than in the composite gadget?
> 
> The only place this can be handled properly is in the gadget driver:
> composite.c for those gadgets using it, otherwise in the higher level
> driver (if there are any remaining gadgets that don't use the composite
> framework).

Why can't the UDC drivers handle this? AFAIK they all keep track of
which phase of a Control transfer they are in. If they see another
SETUP packet arrive, they could "fake" the DATA/STATUS stages of the
previous transfer, before passing on the next SETUP packet to the
gadget driver. Similar to what the DWC3 controller does in hardware.

Although, I guess it would be simpler to do it once in composite.c,
instead of in each individual UDC driver. But there would have to be
a quirk or something, to disable the code if the dwc3 driver is in
use. And that wouldn't fix the problem for gadgets that don't use
composite.c.

-- 
Paul

