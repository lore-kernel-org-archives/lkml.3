Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab3H2RSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:18:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:51223 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab3H2RSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:18:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,984,1367996400"; 
   d="scan'208";a="370531606"
Date: Thu, 29 Aug 2013 10:18:52 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>,
        Josh Triplett <josh.triplett@intel.com>
Subject: Re: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
Message-ID: <20130829171852.GB5538@xanatos>
References: <20130821184042.GC3577@xanatos>
 <CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
 <20130822004514.GB19747@xanatos>
 <CAODwPW99gLBtNQD=UyPq9DqY0TtNubR_7e+FymkfO5u2+et++Q@mail.gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DEC6BC@US01WEMBX2.internal.synopsys.com>
 <20130826191411.GG5112@xanatos>
 <A2CA0424C0A6F04399FB9E1CD98E030458DED818@US01WEMBX2.internal.synopsys.com>
 <20130828215142.GJ26483@xanatos>
 <A2CA0424C0A6F04399FB9E1CD98E030458DEE7A3@US01WEMBX2.internal.synopsys.com>
 <CAODwPW_nPvS3Y9J2J9nU49uuDSB0kVirnKTF7HejfcYJEhgsUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAODwPW_nPvS3Y9J2J9nU49uuDSB0kVirnKTF7HejfcYJEhgsUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 04:08:12PM -0700, Julius Werner wrote:
> > So the 2.41a has BESL support, but may not set the BLC flag.  What
> > happens if we use the HIRD encoding instead?  Will things break?  It
> > seems like we would need to disable USB 2.0 LPM on that host all
> > together, if it expects BESL encoding, but advertises HIRD encoding.
> 
> Wait a second, just for clarity: are you saying that BESL-capable
> controllers do not support the old HIRD mechanism and thus just break
> on non-BESL aware OSes?

Yes.

> I would've assumed that they somehow notice if software doesn't write
> to the new register and automatically fall back to HIRD... it seems
> like a weird decision to break hardware backwards compatibility like
> that (after all, it would mean that Linux 3.10 and older would also
> break on LynxPoint systems right now).

Let me dig this older state out of my brain.  ISTR yelling at the xHCI
spec architect for breaking hosts for this very reason (originally the
BLC flag was not in the spec at all)...

If a host supports the HIRD encoding, it sets Hardware LMP Capability
(HLC), bit 19, in the USB 2.0 port protocol register.  That bit is set
whether the host supports HIRD or BESL encoding.  Bit 20 (BLC) is set if
the host supports BESL.

When the driver goes to write a value in the USB2 Port Hardware LPM
Control Register, if the driver is only aware of the HIRD
specifications, it will use the HIRD encodings in bits 13:10, regardless
of whether the host has BESL support instead of HIRD support.  If the
driver has support for BESL and the host has BESL support, it will use
the BESL encodings in those bits instead.  If you take a look at Table
13: BESL/HIRD Encoding from the xHCI spec version including errata to
08/14/2012, you'll see the numbers written into bits 13:10 mean
different timeouts, based on whether the host supports HIRD or BESL.

So, basically, if the xHCI driver only supports HIRD and is loaded on a
host that supports BESL, then the driver will write a timeout value in
bits 13:10 that means something different than what the driver thinks it
means.  This could lead to issues with USB 2.0 devices that support Link
PM.

Yes, this is broken.  Distros that want to run on hosts that have BESL
support need to have the BESL patches from Mathias.

Sarah Sharp
