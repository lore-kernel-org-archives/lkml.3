Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3HGC4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 22:56:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833Ab3HGC4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 22:56:36 -0400
Message-ID: <1375844191.3509.15.camel@ul30vt.home>
Subject: Re: [PATCH v4 8/9] pci: Tune secondary bus reset timing
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, ddutile@redhat.com,
        indou.takao@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Tue, 06 Aug 2013 20:56:31 -0600
In-Reply-To: <52018664.1080103@intel.com>
References: <20130805193200.9260.38729.stgit@bling.home>
	 <20130805193753.9260.35206.stgit@bling.home> <52018664.1080103@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 16:27 -0700, Alexander Duyck wrote:
> On 08/05/2013 12:37 PM, Alex Williamson wrote:
> > The PCI spec indicates that with stable power, reset needs to be
> > asserted for a minimum of 1ms (Trst).  Seems like we should be able
> > to assume power is stable for a runtime secondary bus reset.  The
> > current code has always used 100ms with no explanation where that
> > came from.  The aer_do_secondary_bus_reset() function uses 2ms, but
> > that seems to be a misinterpretation of the PCIe spec, where hot
> > reset is implemented by TS1 ordered sets containing the hot reset
> > command.  After a 2ms delay the state machine enters the detect state,
> > but to generate a link down, only two consecutive TS1 hot reset
> > ordered sets are requred.  1ms should be plenty for that.
> 
> The reason for doing a 2ms sleep is because the are supposed to be
> sending the Hot Reset TS1 Ordered-Sets continuously for 2ms per all of
> the documents I have read.

Could you point to one of those references?  In the PCIe v3 spec I'm
seeing things like 4.2.6.11 Hot Reset:

      * If two consecutive TS1 Ordered Sets are received on any Lane
        with the Hot Reset bit asserted and configured Link and Lane
        numbers, then:
              * LinkUp = 0b (False)
              * If no higher Layer is directing the Physical Layer to
                remain in Hot Reset, the next state is Detect
              * Otherwise, all Lanes in the configured Link continue to
                transmit TS1 Ordered Sets with the Hot Reset bit
                asserted and the configured Link and Lane numbers.
      * Otherwise, after a 2 ms timeout next state is Detect.

The next section has something similar for propagation of hot resets.

Nowhere there does it say TS1 Ordered Sets need to be sent continuously
for 2ms.  A hot reset is initiated only by two consecutive TS1 Ordered
Sets with the Hot Reset bit asserted.  The 2ms timeout seems to be the
delay before the link moves to the Detect state after we stop asserting
hot reset.  1ms seems like more than enough time for two TS1 Ordered
Sets to propagate down a multi-level hierarchy at 2.5GT/s. 

> The 1ms number you quote is the minimum time
> for a conventional PCI bus.  I'm not completely sure of that applies as
> well to PCIe, nor does it represent the maximum recommended value.

Correct, 1ms comes from conventional PCI.  PCIe is designed to be
software compatible with conventional PCI so it makes sense that PCIe
would do something within the timing boundaries of conventional PCI.  I
didn't see any reference to a maximum recommended value for this
parameter.

> If we stop early we risk not resetting the full device tree on the
> secondary bus which is the bug I was resolving by adding the 2ms delay. 
> Previously we saw that some devices were only getting their PCIe link
> retrained without performing a hot reset when the bit was not held for
> long enough.  I would prefer to keep this at 2 ms in order to account
> for the fact that PCIe has to go though link recovery states before it
> can perform the hot reset.

I'm not going to sweat over 1ms or 2ms but I do want to be able to
document why we're setting it to one or the other.  If it's warm
fuzzies, so be it, but I'd prefer if we could find actual spec or
hardware examples to back it up.  Thanks,

Alex

