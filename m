Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3GBRSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:18:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52596 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753089Ab3GBRR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:17:59 -0400
Date: Tue, 2 Jul 2013 13:17:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: Felipe Balbi <balbi@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
In-Reply-To: <51D28DB9.704@ti.com>
Message-ID: <Pine.LNX.4.44L0.1307021302430.1086-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013, Roger Quadros wrote:

> On 07/02/2013 12:01 AM, Alan Stern wrote:
> > On Mon, 1 Jul 2013, Felipe Balbi wrote:
> > 
> >>> I don't know what Pad wakeup is.  The wakeup signal has to originate 
> >>> from the EHCI controller, doesn't it?  If not, how does the Pad know 
> >>> when a wakeup is needed?
> >>
> >> That's really an OMAP thing, I guess. Pad wakeup sits in the PRCM (IIRC)
> >> inside and always on power domain. EHCI sits in another power domain
> >> which be turned off. When it's turned off (power gated and clock gated)
> >> the EHCI block has no means to wakeup whatsoever. That's when pad wakeup
> >> comes into play. It is generated when PRCM sees a change in the actual
> >> pad of the die. To check who should 'own' the wakeup, it checks the
> >> muxing settings to verify whose pad is that.
> > 
> > How does the PRCM know which changes should generate wakeup events?  
> 
> It doesn't know. It will always generate a wakeup on any change in the monitored pins.
> We can only configure which pins we want to monitor.
> So we can't choose which wakeup events we want to monitor. We just can
> enable or disable all events.
> 
> > In the EHCI controller, this is managed by the settings of the WKOC_E,
> > WKDSCNNT_E, and WKCNNT_E bits in the PORTSC registers.  But if EHCI is
> > powered off, those bits can't be used.
> 
> Is "powered off" same as ehci_suspend? If yes then how does it work on other systems
> for remote wakeup?

Above, Felipe wrote that on OMAP, EHCI sits in a power domain which is
turned off: power gated and clock gated.  ehci_suspend() doesn't do
those things, but they are what I was referring to.

A PCI-based EHCI controller has two power sources: the core well (which
is turned off during suspend) and the auxiliary well (which remains
powered).  That's how remote wakeup works; it uses the auxiliary well.

> > Also, once the wakeup signal has been turned on, how does it get turned 
> > off again?
> 
> That is taken care of by the OMAP pinctrl driver. It will always turn off the
> wakeup signal once the event is detected and forwarded as an IRQ.
> 
> I know that all this is a bit ugly :(.

I still a little confused.  The wakeup signal turns on.  Then the
pinctrl driver sees it, forwards it as an IRQ, and turns the wakeup
signal off.  But what if the IRQ is disabled (as it would be with your
patch)?  Does the IRQ line remain active until it causes an interrupt?  
What eventually turns off the IRQ line?

Alan Stern

