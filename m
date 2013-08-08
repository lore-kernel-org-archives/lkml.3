Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab3HHQqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:46:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:34428 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab3HHQqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:46:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,840,1367996400"; 
   d="scan'208";a="383963170"
Message-ID: <5203CB59.7020806@intel.com>
Date: Thu, 08 Aug 2013 09:46:17 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org, ddutile@redhat.com,
        indou.takao@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 8/9] pci: Tune secondary bus reset timing
References: <20130805193200.9260.38729.stgit@bling.home>   <20130805193753.9260.35206.stgit@bling.home> <52018664.1080103@intel.com>  <1375844191.3509.15.camel@ul30vt.home> <52029262.3060402@intel.com> <1375939416.3509.120.camel@ul30vt.home>
In-Reply-To: <1375939416.3509.120.camel@ul30vt.home>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 10:23 PM, Alex Williamson wrote:
> On Wed, 2013-08-07 at 11:30 -0700, Alexander Duyck wrote:
>> On 08/06/2013 07:56 PM, Alex Williamson wrote:
>>> On Tue, 2013-08-06 at 16:27 -0700, Alexander Duyck wrote:
>>>> On 08/05/2013 12:37 PM, Alex Williamson wrote:
>>>>> The PCI spec indicates that with stable power, reset needs to be
>>>>> asserted for a minimum of 1ms (Trst).  Seems like we should be able
>>>>> to assume power is stable for a runtime secondary bus reset.  The
>>>>> current code has always used 100ms with no explanation where that
>>>>> came from.  The aer_do_secondary_bus_reset() function uses 2ms, but
>>>>> that seems to be a misinterpretation of the PCIe spec, where hot
>>>>> reset is implemented by TS1 ordered sets containing the hot reset
>>>>> command.  After a 2ms delay the state machine enters the detect state,
>>>>> but to generate a link down, only two consecutive TS1 hot reset
>>>>> ordered sets are requred.  1ms should be plenty for that.
>>>> The reason for doing a 2ms sleep is because the are supposed to be
>>>> sending the Hot Reset TS1 Ordered-Sets continuously for 2ms per all of
>>>> the documents I have read.
>>> Could you point to one of those references?  In the PCIe v3 spec I'm
>>> seeing things like 4.2.6.11 Hot Reset:
>>>
>>>       * If two consecutive TS1 Ordered Sets are received on any Lane
>>>         with the Hot Reset bit asserted and configured Link and Lane
>>>         numbers, then:
>>>               * LinkUp = 0b (False)
>>>               * If no higher Layer is directing the Physical Layer to
>>>                 remain in Hot Reset, the next state is Detect
>>>               * Otherwise, all Lanes in the configured Link continue to
>>>                 transmit TS1 Ordered Sets with the Hot Reset bit
>>>                 asserted and the configured Link and Lane numbers.
>>>       * Otherwise, after a 2 ms timeout next state is Detect.
>>>
>>> The next section has something similar for propagation of hot resets.
>>>
>>> Nowhere there does it say TS1 Ordered Sets need to be sent continuously
>>> for 2ms.  A hot reset is initiated only by two consecutive TS1 Ordered
>>> Sets with the Hot Reset bit asserted.  The 2ms timeout seems to be the
>>> delay before the link moves to the Detect state after we stop asserting
>>> hot reset.  1ms seems like more than enough time for two TS1 Ordered
>>> Sets to propagate down a multi-level hierarchy at 2.5GT/s. 
>>>
>> My original implementation is actually based on page 536 of the "PCI
>> Express System Architecture".  However based on the PCIe spec itself I
>> think the point is that the port is supposed to stay in Hot Reset for
>> 2ms after receiving the in-band message.  For a bridge port it means
>> that is supposed to be sending the Hot Reset message for those 2ms on
>> all downstream facing ports.  After the timer expires then it stops
>> sending the Hot Reset TS1 Ordered Sets and then will transition to the
>> Detect state.
> Conveniently page 536 is available for preview on google :)  What that
> suggests to me is that the minimum "nobody home", unconnected link
> timeout is 2ms.  Downstream ports may exit to the Detect state after
> either a 2ms timeout expires or after two hot-reset-TS1s are received
> from the downstream device.  The other 2ms case is that an upstream port
> in the Hot Reset state will always wait for the 2ms timeout to expire
> after the last pair of hot-reset-TS1s is received before entering the
> Detect state.
>
>> My main concern here is that the previous code was not triggering a Hot
>> Reset on all ports previously.  What was happening was that some of the
>> ports would only get as far as Recovery as the upstream port was only
>> sending a couple of TS1 frames and not allowing the downstream ports
>> time to switch to Recovery themselves and discover the Hot Reset.
> Was that the original code that had no delay between set and clear of
> the bridge control register?  1ms is pretty long time vs no delay.
>
>>>> The 1ms number you quote is the minimum time
>>>> for a conventional PCI bus.  I'm not completely sure of that applies as
>>>> well to PCIe, nor does it represent the maximum recommended value.
>>> Correct, 1ms comes from conventional PCI.  PCIe is designed to be
>>> software compatible with conventional PCI so it makes sense that PCIe
>>> would do something within the timing boundaries of conventional PCI.  I
>>> didn't see any reference to a maximum recommended value for this
>>> parameter.
>> I don't want to implement things to minimum specification as there are
>> too many marginal parts where the minimum doesn't work.  I would rather
>> not have to add a ton of quirks for all of the parts out there that
>> didn't quite meet up to the specification.  By using a value of 2ms we
>> are matching what the PCIe bridge behavior is supposed to be by sending
>> the Hot Reset TS1 ordered sets for 2ms.
> The minimum requirement is 2 hot-reset-TS1.  We're sending ~2.5 million
> (if we can assume 1 per transfer cycle).

Yes, but there are multiple states that must be transitioned through in
order to get to the hot-reset state.

>>>> If we stop early we risk not resetting the full device tree on the
>>>> secondary bus which is the bug I was resolving by adding the 2ms delay. 
>>>> Previously we saw that some devices were only getting their PCIe link
>>>> retrained without performing a hot reset when the bit was not held for
>>>> long enough.  I would prefer to keep this at 2 ms in order to account
>>>> for the fact that PCIe has to go though link recovery states before it
>>>> can perform the hot reset.
>>> I'm not going to sweat over 1ms or 2ms but I do want to be able to
>>> document why we're setting it to one or the other.  If it's warm
>>> fuzzies, so be it, but I'd prefer if we could find actual spec or
>>> hardware examples to back it up.  Thanks,
>>>
>>> Alex
>> I think our difference is that I based my value on the in-band message
>> behavior and your value is based on the recommended minimum time for the
>> Secondary Bus Reset.  The downstream ports of a bridge that receives the
>> in-band Hot Reset notification are supposed to send a continuous stream
>> of TS1 Ordered sets with the Hot Reset bit set for 2ms.  Based on all of
>> the conditions in the spec the device should start a 2ms timer, and all
>> downstream ports should begin transmitting the TS1 Ordered sets with the
>> Hot Reset bit asserted, then after the 2ms timer expires it should
>> switch to the detect state.  I verified with a PCIe analyzer that this
>> was what the AER code was doing after I had changed it and added the sleep.
>>
>> What I found is that most parts will stop transmitting the TS1 ordered
>> sets as soon as you clear the Secondary Bus Reset bit.
> If what I state above is correct, then the downstream port of the Bridge
> is able to immediately move to Detect after it receives two
> hot-reset-TS1s from the downstream device.  I suspect this is what you
> were seeing.
>
>> So if you set
>> the bit and clear it 1 ms later you might only get to send a few ordered
>> sets and that may not be enough depending on how fast the part can
>> transition between L0/L0s/L1, Recovery, and Hot Reset.
> I would guess what you were seeing previously with a back-to-back
> set/clear of the bridge control register was that the bridge never
> really entered Hot Reset.  Perhaps it wasn't even set long enough to be
> latched into the hardware.  As long as we get the bridge to enter Hot
> Reset, I think the protocol takes care of itself.  For example:
>
> root port        switch           endpoint
> +-----+          +-----+          +-----+
> |  X  |<---A'----|  Y  |<---B'----|  Z  |
> |     |----A---->|     |----B---->|     |
> +-----+          +-----+          +-----+
>
> Say root port X makes it into the Hot Reset state and we have some way
> to immediately detect this and clear the bridge control register.  X
> will still continue to send hot-reset-TS1 until either a) the 2ms timer
> expires or b) it receives two hot-reset-TS1s on link A'.  If link A is
> up, switch Y will certainly receive two host-reset-TS1s within that 2ms
> and enters the Hot Reset state on it's upstream port.  Switch Y then
> begins sending hot-reset-TS1s on link A'.  At the same time, Y directs
> it's downstream ports to enter Hot Reset "as soon as possible", and
> begins sending hot-reset-TS1s on link B.  Once X receives two
> hot-reset-TS1s on link A', X enters the Detect state.  hot-reset-TS1s on
> link A cease.  2ms after the upstream port of Y receives the last two
> hot-reset-TS1s, those ports also enter the detect phase.

Are you sure about the flow of Hot Reset TS1 ordered sets along the A'
and B' paths?  My understanding was that the flowed downstream, not
upstream.  It's been so long ago that I don't have the trace with me
from when I was working on this so I don't remember the exact behavior
though so I could be wrong.

The issue is that the secondary reset bit doesn't quite work like you
have described.  From what I have seen in the past setting the bit will
hold the root port in the Hot Reset state with it pumping out the
hot-reset TS1 ordered sets until we clear the bit.  When we clear the
bit then all of the ports will cascade from the Hot Reset state to detect.

> The downstream port of Y behaves the same.  We left off with Y's
> downsteam port in Hot Reset sending hot-reset-TS1s down link B.  It
> continues to do this for 2ms or until two hot-reset-TS1s are received on
> link B'.  The protocol takes care of propagating the Hot Reset to
> subordinate devices regardless of whether we're still directing the
> original bridge to stay in Hot Reset.

This is where I derived my 2ms value from.  The simple thought is if the
downstream ports wait 2ms before giving up why shouldn't we do the same
for the Secondary Bus Reset bit.

> If the above is a correct interpretation, the the only requirement on
> how long we assert the secondary bus reset bit is how long it takes the
> bridge to enter the Hot Reset state.  Intuitively, 1ms seems like more
> than enough time and is software compatible with conventional PCI which
> is generally a design goal for PCIe.  If we factor in link recovery
> time, the maximum L1 latency is 64us, which is a pretty small fraction
> of 1ms.

1ms should be more than enough for most parts, however if that is the
case why do the downstream ports on most bridges have a 2ms timeout on
Hot Reset?

> Did you experiment at all with 1ms?  I'm trying to come up with a reason
> to make it 2ms, but the spec isn't supporting it.  Maybe the comment
> should be "This could probably be 1ms, but we're more comfortable with
> 2ms.".  Thanks,
>
> Alex

I recall I did experiment with 1ms.  It did reset the part I was working
with.  My concern as I recall was the fact that as soon as I cleared the
secondary bus reset the root port stopped transmitting the hot reset
ordered sets.

The key thing that I think is the point of contention here between you
and I is the line that "Software must ensure a minimum reset duration
(Trst) as defined in the PCI Local Bus Specification".  To me that is
the lower bounds of acceptable values, and it seems like you are
assuming that to be the recommended value.

My preference is the 2ms value with a comment stating that the value can
be no less than 1ms.  This way it gives us a bit of wiggle room for any
bus delays and such and we are more or less guaranteed to have at least
1ms with the bit set.  If you go the 1ms route we really need a comment
that we are running tight on the tolerance for the msleep since the spec
says we must have at least 1ms.

Thanks,

Alex
