Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbaICRAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:00:46 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63620 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaICRAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:00:42 -0400
Message-ID: <5407490E.7060505@gmail.com>
Date: Wed, 03 Sep 2014 09:59:58 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] Documentation: bcm7120-l2: Add Broadcom BCM7120-style
 L2 binding
References: <1409265326-7579-1-git-send-email-f.fainelli@gmail.com> <1409265326-7579-3-git-send-email-f.fainelli@gmail.com> <alpine.DEB.2.10.1409031410580.3333@nanos> <20140903124317.GB3127@leverpostej>
In-Reply-To: <20140903124317.GB3127@leverpostej>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 05:43 AM, Mark Rutland wrote:
> On Wed, Sep 03, 2014 at 01:13:02PM +0100, Thomas Gleixner wrote:
>> You forgot to CC the device tree dudes. We want an ack on the bindings
>> before they materialize in Linus tree.
> 
> Thanks for the Cc.
> 
> Florian, in future could you please Cc for both the binding and driver?
> So long as it's obvious which patch introduces the binding other can
> choose to ignore the driver, but for me it's useful context.
> 
>>
>> Thanks,
>>
>> 	tglx
>>
>> On Thu, 28 Aug 2014, Florian Fainelli wrote:
>>
>>> This patch adds the Device Tree binding document for the Broadcom
>>> BCM7120-style Set-top-box Level 2 interrupt controller hardware.
>>>
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>>  .../interrupt-controller/brcm,bcm7120-l2-intc.txt  | 44 ++++++++++++++++++++++
>>>  1 file changed, 44 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
>>> new file mode 100644
>>> index 000000000000..3818ffed7347
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
>>> @@ -0,0 +1,44 @@
>>> +Broadcom BCM7120-style Level 2 interrupt controller
>>> +
>>> +Required properties:
>>> +
>>> +- compatible: should be "brcm,bcm7120-l2-intc"
> 
> Is this a custom block for the bcm7120?

This is a custom block that started being used with bcm7120 and that we
inherited, unmodified, in newer BCM7xxx designs since then, hence the
name we picked up.

> 
> Does the IP block not have a more specific name?

I wish there was one, I had to dig through the verilog sources to find
which chip this interrupt controller first started to appear, and the
filename was not too helpful either.

> 
>>> +- reg: specifies the base physical address and size of the registers
>>> +- interrupt-controller: identifies the node as an interrupt controller
>>> +- #interrupt-cells: specifies the number of cells needed to encode an interrupt
>>> +  source, should be 1.
> 
> ... and valid values are?

0 to 31, this is the interrupt number, will fix that.

> 
>>> +- interrupt-parent: specifies the phandle to the parent interrupt controller
>>> +  this one is cascaded from
>>> +- interrupts: specifies the interrupt line(s) in the interrupt-parent domain
>>> +  to be used for cascading
> 
> The domain is a software construct, so I don't think it needs to be
> mentuioned in the binding doc. All that this proeprty describes is the
> lines.

Will fix that.

> 
>>> +- brcm,int-map-mask: 32-bits bit mask describing how the interrupts
>>> at this level
>>> +  map to their respective parents. Should match exactly the number of interrupts
>>> +  specified in the 'interrupts' property.
> 
> I don't follow.
> 
> Surely this should be static, and we know the 1-1 mapping, or this is
> dynamic and should be SW-configured?

This is static for a given instance of this interrupt controller on a
particular brcmstb chip. BCM7445 will have something different here than
e.g: BCM7366 or BCM7439 which are also from the same family.

Not all 32 bits within this interrupt controller will map to wired
interrupts, so the point of this bitmask is to:

- tell how many valid interrupt sources there are
- tell how a given bitmask maps to its corresponding L1 interrupt line
number

So this is not much to know the 1:1, but to know the the 1:many mapping,
the example might make it a little clearer how this works

> 
>>> +Optional properties:
>>> +
>>> +- interrupt-names: if present, the litteral names for the parent interrupts
>>> +  specified in the 'interrupts' property.
> 
> If you use the interrupt-names property, it should contain the names of
> the interrupts from the POV of this device. Those names must be
> specified in the binding doc.

Since this also varies on a per-chip basis, I can certainly add each
valid names for each chips out there, but that does not sound useful,
maybe let's just drop that property, we don't use it anyway since we
perform lookups by indexes, and that is safe to do.

> 
> This is useless as-is.
> 
>>> +- brcm,irq-can-wake: if present, this means the L2 controller can be used as a
>>> +  wakeup source for system suspend/resume.
> 
> How variable is this?

There's two instances of this interrupt controller on most SoCs, one
that can wake up the system, one that cannot, see below.

> 
> I realise have properties like this elsewhere, but it seems to be
> hacking around the lack of a decent power domain interface for figuring
> this out.

Humm, I kind of see your point here with the power domains, I don't see
a big problem with specifying that property though, at most this becomes
redundant when we have a power domain representation (which will be very
simple: always-on and everything else).

> 
>>> +- brcm,int-fwd-mask: if present, a 32-bits bit mask describing the interrupts
>>> +  which need to be enabled in this controller to flow to the higher level
>>> +  interrupt controller. This is typically needed for the UARTs interrupts to
>>> +  flow through the top-level interrupt controller (e.g: ARM GIC on ARM-based
>>> +  platforms).
>>> +
> 
> I don't follow why this property is needed at all. Is this a mechanism
> to bypass this controller entirely? Why should this be described as a
> fixed HW property?

This interrupt controller has traditionally (not necessarily for good
reasons) been the placeholder for special bits that control whether our
UARTs level 1 interrupts (wired to the ARM GIC) will flow to the L1
interrupt.

We discussed initially with Arnd Bergman about how to best approach
this, and he was happy with a bitmask since:

a) that is a one-time initialization thing that can happen anywhere in
the kernel before UART interrupts get used (so before user-space gets
scheduled)

b) we need to save/restore that bitmask during suspend/resume

c) this is not a real interrupt bit, we need to set this bit, but we
will not get any interrupt at this particular interrupt controller level
for UARTs, so this is totally transparent for the UART driver

Once again, the bitmask values varies on a per-chip basis, though the
fundamentals are the same.

> 
> Thanks,
> Mark.
> 
>>> +Example:
>>> +
>>> +irq0_intc: interrupt-controller@f0406800 {
>>> +	compatible = "brcm,bcm7120-l2-intc";
>>> +	interrupt-parent = <&intc>;
>>> +	#interrupt-cells = <1>;
>>> +	reg = <0xf0406800 0x8>;
>>> +	interrupt-controller;
>>> +	interrupts = <0x0 0x42 0x0>, <0x0 0x40 0x0>;
>>> +	interrupt-names = "upg_main", "upg_bsc";
>>> +	brcm,int-map-mask = <0xeb8>, <0x140>;
>>> +	brcm,int-fwd-mask = <0x7>;
>>> +};
>>> -- 
>>> 1.9.1
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

