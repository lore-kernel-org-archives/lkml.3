Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaEIOIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:08:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42509 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755882AbaEIOI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:08:29 -0400
Date: Fri, 9 May 2014 10:08:28 -0400 (EDT)
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
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E03046D195FB1@US01WEMBX2.internal.synopsys.com>
Message-ID: <Pine.LNX.4.44L0.1405091000110.1239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Paul Zimmerman wrote:

> > That doesn't handle the problem I described above.  When the dwc3
> > driver gets the late delayed status response, it will think it is a
> > response to the new SETUP packet, and so it will carry out a bogus
> > transfer.  It won't know that the status request was meant to be a
> > response to a defunct control transfer.
> 
> I think you misunderstood me. What I meant was, once the DWC3
> controller sees the next SETUP packet, it will still accept the
> commands from the dwc3 driver to start the DATA and STATUS phases
> for the previous Control transfer, and will send back (fake) completion
> events for those commands to the driver. But it won't actually send
> anything on the wire.

I see.  The hardware keeps track of which transfer is being acted on.

> So it should be impossible for the dwc3 driver to carry out a bogus
> transfer. This is a feature of the DWC3 controller intended to
> simplify what the software needs to handle, and to automatically
> take care of the corner cases involved here.
> 
> > > For other controllers that can't do this, maybe it should be handled
> > > in the UDC driver rather than in the composite gadget?
> > 
> > The only place this can be handled properly is in the gadget driver:
> > composite.c for those gadgets using it, otherwise in the higher level
> > driver (if there are any remaining gadgets that don't use the composite
> > framework).
> 
> Why can't the UDC drivers handle this? AFAIK they all keep track of
> which phase of a Control transfer they are in. If they see another
> SETUP packet arrive, they could "fake" the DATA/STATUS stages of the
> previous transfer, before passing on the next SETUP packet to the
> gadget driver. Similar to what the DWC3 controller does in hardware.

That would be possible, yes.

> Although, I guess it would be simpler to do it once in composite.c,
> instead of in each individual UDC driver. But there would have to be
> a quirk or something, to disable the code if the dwc3 driver is in
> use. And that wouldn't fix the problem for gadgets that don't use
> composite.c.

Would the dwc3 driver really need such a quirk?  From what you said
before, I got the impression that if a new SETUP packet arrived before
the old transfer was complete, dwc3 wouldn't inform the gadget driver 
about it.  It would wait until the gadget driver submitted its 
status response for the old transfer and _then_ tell it about the new 
SETUP.

As for gadgets not using the composite framework, I don't think there
are very many of them left.  gadgetfs certainly, but hardly any others.  
Felipe should know for sure.

Alan Stern

