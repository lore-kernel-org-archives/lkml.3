Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161346AbaKNPzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:55:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46944 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161272AbaKNPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:55:49 -0500
Date: Fri, 14 Nov 2014 10:55:48 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Kever Yang <kever.yang@rock-chips.com>,
        Doug Anderson <dianders@chromium.org>,
        Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Romain Perier <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
In-Reply-To: <CAODwPW9Avc1RCdDoarGg2cZirn7ivu4JEdUTV485J=nLLmecTQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1411141038530.1043-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Julius Werner wrote:

> Another thing might be that the port connect interrupt does not
> correctly resume the root hub. I don't really know many details about
> how that works, and it seems pretty complicated. But I can see that
> all other HCDs seem to call usb_hcd_resume_root_hub() from their
> interrupt handlers, which we don't. There's also a

That's how a root hub sends a wakeup request to the kernel.  The
controller issues an interrupt, and when the HCD's interrupt handler
sees that the root hub is suspended, it calls usb_hcd_resume_root_hub()
instead of trying to query the hardware (because in general you _can't_
query the hardware while it's in a low-power state).

> usb_hcd_start_port_resume() in EHCI which I'm not familiar with, that
> seems to have been added recently.

usb_hcd_start_port_resume() and usb_hcd_end_port_resume() were added in 
order to fix a race.  We want to avoid suspending a root hub if a 
downstream suspended device is currently being resumed.

The HCD is supposed to call these two routines when it begins and ends
resume signalling on any of its ports.  This will prevent the core from
suspending the root hub while the port resume is in progress.

> And finally, it seems that all
> normal host controllers (UHCI/OHCI/EHCI/XHCI) now do the
> usb_hcd->uses_new_polling thing (where you're supposed to call
> hcd_poll_rh_status() from the HCD code)... the old polling code still
> seems to be in place, but without any relevant driver using I wouldn't
> be so sure if it's still functional.

It is functional.  The difference between the old and new polling
schemes isn't all that big.  In the old scheme, the core polls for root
hub status changes every 250 ms.  With the new scheme, the core doesn't
poll -- it relies on the HCD to call usb_hcd_poll_rh_status() whenever
there's a status-change interrupt.

There's also a flag the HCD can set to ask for polling even if it uses
the new scheme.  This helps in situations where the 
root-hub status-change interrupts aren't reliable (for example, if they 
are edge-triggered rather than level-triggered).

> +Alan who should know HCD/core interactions much better and might have
> some ideas what the DWC2 driver is still missing right now.

I know essentially zero about the DWC2 driver.  But I'm happy to help 
by explaining how the core mechanisms are intended to be used.

Alan Stern

