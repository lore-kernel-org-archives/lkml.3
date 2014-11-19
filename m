Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbaKSQAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:00:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45473 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756437AbaKSQAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:00:07 -0500
Date: Wed, 19 Nov 2014 11:00:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Felipe Balbi <balbi@ti.com>, Mathias Nyman <mathias.nyman@linux.intel.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Paul Zimmerman <paulz@synopsys.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Romain Perier <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Douglas Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>, addy ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Roy Li <roy.li@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc2: resume root hub when device detect with
 suspend state
In-Reply-To: <CAODwPW8hQdxv_ecaVHYjS4rHjZVB_G5zURDPCHzaPsEXVgs=fA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1411191051110.1345-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Julius Werner wrote:

> >> You should be aware that it's not safe to use hcd->state for anything
> >> in a host controller driver.  That field is owned by usbcore, not by
> >> the HCD, and it is not protected by any locks.
> >>
> >> Thus, for example, hcd->state does not get set to HC_STATE_SUSPENDED
> >> until some time after the bus_suspend routine has returned.  A
> >> port-change interrupt might occur during that time interval.
> 
> Looks like there is explicit code in hcd_bus_suspend() to check for
> that race condition right after setting hcd->state, or do I
> misinterpret that (the "Did we race with a root-hub wakeup event?"
> part)?

That code doesn't quite do what you think.  For example:

	CPU 1				CPU 2
	-----				-----
	hcd_bus_suspend():
	call hcd->bus_suspend():
	    root hub gets suspended

					Wakeup IRQ arrives and is
					  ignored because hcd->state
					  is still HC_STATE_QUIESCING

	set hcd->state to HC_STATE_SUSPENDED
	Did we race with a wakeup event?
	  No because usb_hcd_resume_root_hub()
	  wasn't called.

Result: the wakeup event is lost.

> Also, it seems xhci_bus_suspend() explicitly sets 'hcd->state =
> HC_STATE_SUSPENDED' before giving up the spinlock for some
> undocumented reason, maybe to avoid exactly this problem. We could
> just copy that trick if the hcd.c solution isn't enough (although the
> DWC2 bus_suspend/bus_resume in the other patch don't grab that
> spinlock right now, where I'm also not so sure if that's a good
> idea...).

It's better for HCDs to avoid testing hcd->state at all.  They should 
set it to appropriate values at the right times, because usbcore checks 
it, but they should not test it.  This is why ehci-hcd, ohci-hcd, and 
uhci-hcd all have a private rh_state variable, and they use it while 
holding their respective private spinlocks.

Alan Stern

