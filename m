Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3H2RmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:42:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:40799 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab3H2RmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:42:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,984,1367996400"; 
   d="scan'208";a="395503909"
Date: Thu, 29 Aug 2013 10:42:15 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
Message-ID: <20130829174215.GC5538@xanatos>
References: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
 <20130821184042.GC3577@xanatos>
 <CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
 <20130822004514.GB19747@xanatos>
 <CAODwPW99gLBtNQD=UyPq9DqY0TtNubR_7e+FymkfO5u2+et++Q@mail.gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DEC6BC@US01WEMBX2.internal.synopsys.com>
 <20130826191411.GG5112@xanatos>
 <A2CA0424C0A6F04399FB9E1CD98E030458DED818@US01WEMBX2.internal.synopsys.com>
 <20130828215142.GJ26483@xanatos>
 <A2CA0424C0A6F04399FB9E1CD98E030458DEE7A3@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458DEE7A3@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 10:15:34PM +0000, Paul Zimmerman wrote:
> > From: Sarah Sharp [mailto:sarah.a.sharp@linux.intel.com]
> > Sent: Wednesday, August 28, 2013 2:52 PM
> > 
> > On Mon, Aug 26, 2013 at 07:37:56PM +0000, Paul Zimmerman wrote:
> > > > From: Sarah Sharp [mailto:sarah.a.sharp@linux.intel.com]
> > > > Sent: Monday, August 26, 2013 12:14 PM
> > > >
> > > > On Thu, Aug 22, 2013 at 05:11:49AM +0000, Paul Zimmerman wrote:
> > > > > Just to set the record straight :)
> > > > >
> > > > > The PORTHLPMC registers do exist on DWC3, starting with the 1.90a version
> > > > > of the core or thereabouts. They only supported the HIRD flavor of LPM,
> > > > > though. Only fairly recently has support for BESL been added, around
> > > > > version 2.41a or so.
> > > >
> > > > And the 2.41a version that supports BESL properly sets the BLC flag in
> > > > the USB 2.0 Protocol extended capabilities for all the USB 2.0 ports?
> > > > Has this functionality been well-tested?
> > >
> > > In 2.41a it is described as an "early adopter" feature in the databook,
> > > and no mention is made of the BLC flag. So the answer there is "maybe".
> > > Starting with 2.50a it is a full-fledged feature and the databook does
> > > describe the BLC flag.
> > 
> > So the 2.41a has BESL support, but may not set the BLC flag.  What
> > happens if we use the HIRD encoding instead?  Will things break?  It
> > seems like we would need to disable USB 2.0 LPM on that host all
> > together, if it expects BESL encoding, but advertises HIRD encoding.
> 
> I imagine things would break, but I don't know for sure. I don't have a
> 2.41a version of the core to test this with.
> 
> Maybe the LPM support should be disabled by default, and enabled with a
> quirk? That seems safer to me.

I don't think that's a sustainable option.

I expect that the majority of hosts that support USB 2.0 Link PM in the
future will have BESL support.  It makes no sense to maintain an
ever-growing list of hosts that support BESL.

We did something similar for the Intel EHCI to xHCI port switchover.
Every time someone added a new skew with a different PCI device ID, we
had to add that to the list of hosts that had the port switchover.  The
list grew and grew, and backporting and notifying distros of new list
entries was a pain.  It just wasn't sustainable, and we ended up ripping
out the list and dynamically looking for the Intel EHCI companion host
instead.

So, no, I don't want to go there.  I would rather have an xHCI quirk
that disables USB 2.0 LPM instead.

> > > So it may be safer to say that the feature is present starting with 2.50a.
> > 
> > Is there a way we can tell the difference between a 2.41a xHCI host and
> > a 2.50a host?  If so, we can add a quirk to disable LPM on the 2.41a
> > host.
> 
> Once you know it is a Synopsys core, there is a vendor-specific register
> that shows the version. But that register is at offset 0xC120, which is
> above the normal xHCI register space I believe, so we may not be able to
> depend on it being accessible. And you have the problem of how to
> determine if it is a Synopsys core to begin with.
> 
> So IMHO, having LPM disabled by default, and enabled with a quirk based
> on the PCI Vendor/Product ID, or a DT attribute for platform devices,
> would be the way to go.

I think DT attributes would be the best way to go.  I think the patch
should be changed to set those USB 2.0 LPM function pointers for the
platform devices, but add a new xHCI host quirk, XHCI_DISABLE_USB2_LPM.
Make the LPM functions return immediately if that quirk is set.  Then
set the quirk based on DT attributes for the Synopsis 2.41a host.

> > > In 2.51a it has been well-tested in simulation. In actual hardware, it
> > > has only been briefly tested in an ad-hoc sort of way, since none of the
> > > standard drivers in the market support the feature yet, as far as we know.
> > >
> > > Once the support is fully working in the Linux driver we can try testing
> > > it there.
> > 
> > Can you please test Julius' patch on the 2.41a, 2.50a, and 2.51a hosts?
> > Please test against usb-next, since that includes a fix for the BESL
> > patches.
> 
> As I said, I don't have the 2.41a version available to test. I do have
> 2.50a and 2.60a available, so I can try those.

Ok, let me know if those work.  In the meantime, can you help Julius
create a patch to add DT attributes to distinguish between the different
versions?

Sarah Sharp
