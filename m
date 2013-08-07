Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3HGSbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:31:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:45017 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab3HGSbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:31:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,834,1367996400"; 
   d="scan'208";a="279033108"
Message-ID: <52029262.3060402@intel.com>
Date: Wed, 07 Aug 2013 11:30:58 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org, ddutile@redhat.com,
        indou.takao@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 8/9] pci: Tune secondary bus reset timing
References: <20130805193200.9260.38729.stgit@bling.home>  <20130805193753.9260.35206.stgit@bling.home> <52018664.1080103@intel.com> <1375844191.3509.15.camel@ul30vt.home>
In-Reply-To: <1375844191.3509.15.camel@ul30vt.home>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 07:56 PM, Alex Williamson wrote:
> On Tue, 2013-08-06 at 16:27 -0700, Alexander Duyck wrote:
>> On 08/05/2013 12:37 PM, Alex Williamson wrote:
>>> The PCI spec indicates that with stable power, reset needs to be
>>> asserted for a minimum of 1ms (Trst).  Seems like we should be able
>>> to assume power is stable for a runtime secondary bus reset.  The
>>> current code has always used 100ms with no explanation where that
>>> came from.  The aer_do_secondary_bus_reset() function uses 2ms, but
>>> that seems to be a misinterpretation of the PCIe spec, where hot
>>> reset is implemented by TS1 ordered sets containing the hot reset
>>> command.  After a 2ms delay the state machine enters the detect state,
>>> but to generate a link down, only two consecutive TS1 hot reset
>>> ordered sets are requred.  1ms should be plenty for that.
>> The reason for doing a 2ms sleep is because the are supposed to be
>> sending the Hot Reset TS1 Ordered-Sets continuously for 2ms per all of
>> the documents I have read.
> Could you point to one of those references?  In the PCIe v3 spec I'm
> seeing things like 4.2.6.11 Hot Reset:
>
>       * If two consecutive TS1 Ordered Sets are received on any Lane
>         with the Hot Reset bit asserted and configured Link and Lane
>         numbers, then:
>               * LinkUp = 0b (False)
>               * If no higher Layer is directing the Physical Layer to
>                 remain in Hot Reset, the next state is Detect
>               * Otherwise, all Lanes in the configured Link continue to
>                 transmit TS1 Ordered Sets with the Hot Reset bit
>                 asserted and the configured Link and Lane numbers.
>       * Otherwise, after a 2 ms timeout next state is Detect.
>
> The next section has something similar for propagation of hot resets.
>
> Nowhere there does it say TS1 Ordered Sets need to be sent continuously
> for 2ms.  A hot reset is initiated only by two consecutive TS1 Ordered
> Sets with the Hot Reset bit asserted.  The 2ms timeout seems to be the
> delay before the link moves to the Detect state after we stop asserting
> hot reset.  1ms seems like more than enough time for two TS1 Ordered
> Sets to propagate down a multi-level hierarchy at 2.5GT/s. 
>

My original implementation is actually based on page 536 of the "PCI
Express System Architecture".  However based on the PCIe spec itself I
think the point is that the port is supposed to stay in Hot Reset for
2ms after receiving the in-band message.  For a bridge port it means
that is supposed to be sending the Hot Reset message for those 2ms on
all downstream facing ports.  After the timer expires then it stops
sending the Hot Reset TS1 Ordered Sets and then will transition to the
Detect state.

My main concern here is that the previous code was not triggering a Hot
Reset on all ports previously.  What was happening was that some of the
ports would only get as far as Recovery as the upstream port was only
sending a couple of TS1 frames and not allowing the downstream ports
time to switch to Recovery themselves and discover the Hot Reset.

>> The 1ms number you quote is the minimum time
>> for a conventional PCI bus.  I'm not completely sure of that applies as
>> well to PCIe, nor does it represent the maximum recommended value.
> Correct, 1ms comes from conventional PCI.  PCIe is designed to be
> software compatible with conventional PCI so it makes sense that PCIe
> would do something within the timing boundaries of conventional PCI.  I
> didn't see any reference to a maximum recommended value for this
> parameter.

I don't want to implement things to minimum specification as there are
too many marginal parts where the minimum doesn't work.  I would rather
not have to add a ton of quirks for all of the parts out there that
didn't quite meet up to the specification.  By using a value of 2ms we
are matching what the PCIe bridge behavior is supposed to be by sending
the Hot Reset TS1 ordered sets for 2ms.

>> If we stop early we risk not resetting the full device tree on the
>> secondary bus which is the bug I was resolving by adding the 2ms delay. 
>> Previously we saw that some devices were only getting their PCIe link
>> retrained without performing a hot reset when the bit was not held for
>> long enough.  I would prefer to keep this at 2 ms in order to account
>> for the fact that PCIe has to go though link recovery states before it
>> can perform the hot reset.
> I'm not going to sweat over 1ms or 2ms but I do want to be able to
> document why we're setting it to one or the other.  If it's warm
> fuzzies, so be it, but I'd prefer if we could find actual spec or
> hardware examples to back it up.  Thanks,
>
> Alex

I think our difference is that I based my value on the in-band message
behavior and your value is based on the recommended minimum time for the
Secondary Bus Reset.  The downstream ports of a bridge that receives the
in-band Hot Reset notification are supposed to send a continuous stream
of TS1 Ordered sets with the Hot Reset bit set for 2ms.  Based on all of
the conditions in the spec the device should start a 2ms timer, and all
downstream ports should begin transmitting the TS1 Ordered sets with the
Hot Reset bit asserted, then after the 2ms timer expires it should
switch to the detect state.  I verified with a PCIe analyzer that this
was what the AER code was doing after I had changed it and added the sleep.

What I found is that most parts will stop transmitting the TS1 ordered
sets as soon as you clear the Secondary Bus Reset bit.  So if you set
the bit and clear it 1 ms later you might only get to send a few ordered
sets and that may not be enough depending on how fast the part can
transition between L0/L0s/L1, Recovery, and Hot Reset.

Thanks,

Alex

