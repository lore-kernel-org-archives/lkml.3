Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaCGRFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:05:12 -0500
Received: from mx0.aculab.com ([213.249.233.131]:37382 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753013AbaCGRFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:05:10 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
CC: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH 2/2] Revert "USBNET: ax88179_178a: enable tso if usb
 host supports sg dma"
Thread-Topic: [PATCH 2/2] Revert "USBNET: ax88179_178a: enable tso if usb
 host supports sg dma"
Thread-Index: AQHPOhW/7Dk26KmSaUac+4xvwJwpV5rVuasQgAADFYCAAAo1cIAAD1CAgAACZJA=
Date: Fri, 7 Mar 2014 17:04:31 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6D7A17@AcuExch.aculab.com>
References: <063D6719AE5E284EB5DD2968C1650D6D0F6D78EA@AcuExch.aculab.com>
 <Pine.LNX.4.44L0.1403071139320.1246-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1403071139320.1246-100000@iolanthe.rowland.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: 
> On Fri, 7 Mar 2014, David Laight wrote:
> 
> > From: Alan Stern
> > > On Fri, 7 Mar 2014, David Laight wrote:
> > >
> > > > From: Mathias Nyman
> > > > > This reverts commit 3804fad45411b48233b48003e33a78f290d227c8.
> > > > >
> > > > > This commit, together with commit 247bf557273dd775505fb9240d2d152f4f20d304
> > > > > "xhci 1.0: Limit arbitrarily-aligned scatter gather." were
> > > > > origially added to get xHCI 1.0 hosts and usb ethernet ax88179_178a devices
> > > > > working together with scatter gather. xHCI 1.0 hosts pose some requirement on how transfer
> > > > > buffers are aligned, setting this requirement for 1.0 hosts caused USB 3.0 mass
> > > > > storage devices to fail more frequently.
> > > >
> > > > This patch doesn't need to be reverted.
> > >
> > > Yes, it does.
> > >
> > > > Provided the xhci driver doesn't set the flag to say that arbitrary scatter
> > > > gather is supported (ie usb_device_no_sg_constraint(dev->udev)) is false)
> > > > the ax88179_178a driver won't request transmits that need fragmenting.
> > >
> > > True.  But xhci-hcd _will_ set the flag, because of patch 1 in this
> > > series.  In other words, patch 1 makes patch 2 necessary.
> >
> > I was reading patch 2 first.
> > It would seem to be better to modify patch 1 - so it doesn't set the flag.
> > Then the changes are limited to the usb tree, and the change to net wouldn't
> > need to be reapplied in order to test scatter-gather when it is properly fixed.
> 
> > The point is that the no_sg_constraint was added in order to allow
> > the ax88179_178a driver to send arbitrarily aligned transfers.
> > Nothing else looks at it (well didn't when I scanned the tree a while back).
> >
> > In effect all the other transfer requests were assumed to be suitably
> > aligned.
> >
> > The check that caused things to fail was the one added to xhci relatively
> > recently that verified the alignment of the fragments.
> 
> (Actually the check was added to usbcore, not to xhci-hcd.)
> 
> The _real_ problem here seems to be that "no_sg_constraint" is
> ambiguous.  Originally it was meant to refer to the constraint that all
> SG elements except the last must be a multiple of the maxpacket size.
> For that purpose, the check added to usbcore was entirely appropriate,
> as was setting the flag in xhci-hcd.

Probably true - but the only code that looked at it was in usbnet.
The check in usbcore is very recent.

> But now it turns out that the ax88179 driver is violating a _different_
> constraint: that Link TRBs must occur only at 1-KB boundaries.  The
> "no_sg_constraint" flag was never meant to describe this.  In other
> words, the flag issue is separate from the problem facing ax88179.

Really that means that the xhci controller couldn't actually support the
alignments it said it could - rather than the ax88179 driver sending
packets that didn't meet that the rules.

> The appropriate way to address this new problem for the future is to
> remove the second constraint by adding correct support for TD
> fragments into xhci-hcd.

Indeed.

> The appropriate way to address the problem
> right now in the -stable kernels is to prevent ax88179 from using SG --
> and not by abusing the "no_sg_constraint" flag, which is not directly
> related to the TD fragment problem.

I'd say that if the no_sg_constraint flag is set the ax88179 driver
could reasonably expect to send its fragment lists.

So it is best not to set the no_sg_constraint flag, and then remove
the checks against it that are needed to allow the transfers from
the disk system not be rejected - even though we know that some
of them might not actually work.

Otherwise you'll need to add yet another flag when the sg support
is fixed.

	David



