Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab3LMRsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:48:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:27928 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab3LMRsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:48:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,480,1384329600"; 
   d="scan'208";a="451959743"
Date: Fri, 13 Dec 2013 09:48:15 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Julius Werner <jwerner@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vikas Sajjan <sajjan.linux@gmail.com>,
        Vikas Sajjan <vikas.sajjan@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Douglas Anderson <dianders@chromium.org>, Felipe Balbi <balbi@ti.com>,
        sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH] USB: core: Add warm reset while reset-resuming
 SuperSpeed HUBs
Message-ID: <20131213174815.GA10727@xanatos>
References: <CAODwPW8GqOcUadYD_jXdyFxJ0cdeLLRi6hs9jFODkQ1KuUr5FQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1312121103580.929-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1312121103580.929-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 11:05:04AM -0500, Alan Stern wrote:
> On Wed, 11 Dec 2013, Julius Werner wrote:
> 
> > >> ...although, the spec says that it does not wait for the port resets
> > >> to complete.  As far as I can see re-issuing a warm reset and waiting
> > >> is the only way to guarantee the core times the recovery.  Presumably
> > >> the portstatus debounce in hub_activate() mitigates this, but that
> > >> 100ms is less than a full reset timeout.
> > 
> > It's definitely not just a timing issue for us. I can't reproduce all
> > the same cases as Vikas, but when I attach a USB analyzer to the ones
> > I do see the host controller doesn't even start sending a reset.
> > 
> > >>> The xHCI spec requires that when the xHCI host is reset, a USB reset is
> > >>> driven down the USB 3.0 ports.  If hot reset fails, the port may migrate
> > >>> to warm reset.  See table 32 in the xHCI spec, in the definition of
> > >>> HCRST.  It sounds like this host doesn't drive a USB reset down USB 3.0
> > >>> ports at all on host controller reset?
> > 
> > Oh, interesting, I hadn't seen that yet. So I guess the spec itself is
> > fine if it were followed to the letter.
> > 
> > I did some more tests about this on my Exynos machine: when I put a
> > device to autosuspend (U3) and manually poke the xHC reset bit, I do
> > see an automatic warm reset on the analyzer and the ports manage to
> > retrain to U0. But after a system suspend/resume which calls
> > xhci_reset() in the process, there is no reset on the wire. I also
> > noticed that it doesn't drive a reset (even after manual poking) when
> > there is no device connected on the other end of the analyzer.
> > 
> > So this might be our problem: maybe these host controllers (Synopsys
> > DesignWare) issue the spec-mandated warm reset only on ports where
> > they think there is a device attached. But after a system
> > suspend/resume (where the whole IP block on the SoC was powered down),
> > the host controller cannot know that there is still a device with an
> > active power session attached, and therefore doesn't drive the reset
> > on its own.

Ok, that makes some sense.  I could see why host controllers wouldn't
want to drive reset on an unconnected port.

> > Even though this is a host controller bug, we still have to deal with
> > it somehow. I guess we could move the code into xhci_plat_resume() and
> > hide it behind a quirk to lessen the impact. But since reset_resume is
> > not a common case for most host controllers, it's hard to say if this
> > is DesignWare specific or a more widespread implementation mistake.
> 
> I was going to suggest something along these lines too.  This seems to 
> be a bug in xHCI.  Therefore the fix belongs in xhci-hcd, not in the 
> hub driver.

I agree.  Is there a chance that the Synopsys DesignWare will be a PCI
device instead of a platform device?  If so, it would be better to put
the code into xhci_resume instead of xhci_plat_resume.  That also allows
you to only issue the warm reset when the register restore state command
fails, after the xhci_reset call.

Also, I assume that other systems with the Synopsys DesignWare IP will
experience this issue?  I know of at least two other chipsets that will
include that IP, and it would be good to find a way to trigger on the
Synopsys IP, rather than off xHCI PCI vendor and device ID.  Otherwise
we'll be adding PCI IDs to the xHCI driver quirks for many many kernels
to come.

I'm actually leaning towards enabling the check for warm reset broadly.
It seems like it wouldn't hurt to issue a warm reset on the USB 3.0
ports if they're in compliance, poll, or rx.detect.  So, let's enable
this broadly in xhci_resume, mark the patch for stable, but ask for the
backport to be delayed until 3.13.3 is out, to allow for more testing.
If anyone complains of xHCI behavior changes, we'll change the code to
add a quirk.

Sarah Sharp
