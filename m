Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab3LKTgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:36:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:45035 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab3LKTgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:36:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,873,1378882800"; 
   d="scan'208";a="423111138"
Date: Wed, 11 Dec 2013 11:36:47 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Vikas Sajjan <sajjan.linux@gmail.com>,
        Vikas Sajjan <vikas.sajjan@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Lan Tianyu <tianyu.lan@intel.com>, burzalodowa@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Douglas Anderson <dianders@chromium.org>, Felipe Balbi <balbi@ti.com>,
        sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH] USB: core: Add warm reset while reset-resuming
 SuperSpeed HUBs
Message-ID: <20131211193647.GA25483@xanatos>
References: <CAGm_ybgC6Ca0qz6zJL0PkEUiyUi=Ct0L5t2GJOt9ZU-buP+wBQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1312111204220.1531-100000@iolanthe.rowland.org>
 <CAODwPW_ZUgHWymOF7Fzxh7sbhrvV0-g-pMXWQm=eSz2U8EBRtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAODwPW_ZUgHWymOF7Fzxh7sbhrvV0-g-pMXWQm=eSz2U8EBRtQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 11:00:13AM -0800, Julius Werner wrote:
> > I don't know what you mean by "fails".  The system goes to sleep and
> > then later on wakes up, doesn't it?
> >
> > Do you mean that the Jetflash device gets disconnected when the system
> > wakes up?  That's _supposed_ to happen under those circumstances.
> > When hub_activate() sees HUB_RESET_RESUME, all child devices get
> > disconnected except those where udev->persist_enabled is set.
> 
> This patch was written in response to the same bug as my "usb: hub:
> Use correct reset for wedged USB3 devices that are NOTATTACHED"
> submission. My patch only helps when the port gets stuck in Compliance
> Mode, but Vikas reports that he can sometimes see it stuck in Polling
> or Recovery states as well.
> 
> The underlying issue is a deadlock in the USB 3.0 link training state
> machine when the host controller is unilaterally reset on resume
> (without driving a reset on the bus).

The xHCI spec requires that when the xHCI host is reset, a USB reset is
driven down the USB 3.0 ports.  If hot reset fails, the port may migrate
to warm reset.  See table 32 in the xHCI spec, in the definition of
HCRST.  It sounds like this host doesn't drive a USB reset down USB 3.0
ports at all on host controller reset?

> The host port starts out back in
> Rx.Detect without remembering anything about its previous state, but
> the device is still in U3. The host detects Rx terminations, moves to
> Polling and starts sending LFPS link training packets, but the device
> doesn't expect those and interprets them as link problems (moving to
> Recovery). What happens next seems to be device specific, but
> apparently the device can end up in SS.Inactive while the host port
> gets stuck in Polling or Recovery (or some kind of livelock between
> those).
> 
> This patch tries to warm reset all USB 3.0 ports on reset-resume
> (after xhci_reset() was called) that had devices connected to them
> before suspend. This seems to be the only way to ensure the devices'
> state machines get back to a well-defined state that the host can work
> with. I don't think this is a specific hardware bug, it's just an
> unfortunate design flaw that the USB 3.0 spec doesn't account for a
> root hub port being reset independently of its connected device. I
> think Sarah is correct that it could be limited to root hubs, though.

Sarah Sharp
