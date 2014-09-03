Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936451AbaICXxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:53:48 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:57647 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215AbaICXxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:53:43 -0400
MIME-Version: 1.0
In-Reply-To: <540665BA.3080702@gmail.com>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
	<1409350479-19108-4-git-send-email-abrestic@chromium.org>
	<5405FE07.4030400@gmail.com>
	<CAL1qeaHcV_4Z9n_THEN_aST3smgaW1vwn81SkmbU0AUJ_rdB1Q@mail.gmail.com>
	<540665BA.3080702@gmail.com>
Date: Wed, 3 Sep 2014 16:53:42 -0700
X-Google-Sender-Auth: H5sZMU-U74C7XVRXa7ycJC-tg58
Message-ID: <CAL1qeaG_vSiBToi9ZU2=+Guj98gWE_AgmrR7=Z6-PxSNfdH9sA@mail.gmail.com>
Subject: Re: [PATCH 03/12] of: Add binding document for MIPS GIC
From: Andrew Bresticker <abrestic@chromium.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 5:50 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> On 09/02/2014 12:36 PM, Andrew Bresticker wrote:
>>
>> On Tue, Sep 2, 2014 at 10:27 AM, David Daney <ddaney.cavm@gmail.com>
>> wrote:
>>>
>>> On 08/29/2014 03:14 PM, Andrew Bresticker wrote:
>>>>
>>>>
>>>> The Global Interrupt Controller (GIC) present on certain MIPS systems
>>>> can be used to route external interrupts to individual VPEs and CPU
>>>> interrupt vectors.  It also supports a timer and software-generated
>>>> interrupts.
>>>>
>>>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>>>> ---
>>>>    Documentation/devicetree/bindings/mips/gic.txt | 50
>>>> ++++++++++++++++++++++++++
>>>>    1 file changed, 50 insertions(+)
>>>>    create mode 100644 Documentation/devicetree/bindings/mips/gic.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/mips/gic.txt
>>>> b/Documentation/devicetree/bindings/mips/gic.txt
>>>> new file mode 100644
>>>> index 0000000..725f1ef
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/mips/gic.txt
>>>> @@ -0,0 +1,50 @@
>>>> +MIPS Global Interrupt Controller (GIC)
>>>> +
>>>> +The MIPS GIC routes external interrupts to individual VPEs and IRQ
>>>> pins.
>>>> +It also supports a timer and software-generated interrupts which can be
>>>> +used as IPIs.
>>>> +
>>>> +Required properties:
>>>> +- compatible : Should be "mti,global-interrupt-controller"
>>>> +- reg : Base address and length of the GIC registers.
>>>> +- interrupts : Core interrupts to which the GIC may route external
>>>> interrupts.
>>>
>>>
>>>
>>> This doesn't make sense to me.  The GIC can, and does, route interrupts
>>> to
>>> all CPU cores in a SMP system.  How can there be a concept of only
>>> associating it with several interrupt lines on a single CPU in the
>>> system?
>>> That is not what the GIC does, is it?  It is a Global interrupts
>>> controller,
>>> not local.  So specifying device tree bindings that don't show its Global
>>> nature seems wrong.
>>
>>
>> While the GIC can route external interrupts to any HW interrupt vector
>> it may not make sense to actually use all those vectors.  For example,
>> the CP0 timer is usually hooked up to HW vector 5 (it could be treated
>> as a GIC local interrupt, though it may still be fixed to HW vector
>> 5).  BTW, the Malta example about the i8259 I gave before was wrong -
>> it appears that it actually gets chained with the GIC.
>
>
> Your comments don't really make sense to me in the context of my knowledge
> of the GIC.
>
> Of course all the CP0 timer and performance counter interrupts are per-CPU
> and routed directly to the corresponding CP0_Cause[IP7..IP2] bits.  We are
> don't need to give them further consideration.
>
>
> Here is the scenario you should consider:
>
>   o 16 CPU cores.
>   o 1 GIC routing interrupts from external sources to the 16 CPUs.
>   o 2 network controllers each with an interrupt line routed to the GIC.
>
> Q: What would the GIC "interrupts" property look like?
>
> Note that the GIC doesn't have a single "interrupt-parent", as it can route
> interrupts to *all* 16 CPUs.
>
> I propose that the GIC have neither an "interrupt-parent", nor "interrupts".
> The fact that it is an "mti,global-interrupt-controller", means that the
> software drivers for the GIC already know how to route interrupts, and any
> information the device tree could contain is redundant.

Ok, I misunderstood your opposition to the binding.

My intention for the "interrupt-parent" and "interrupts" property of
the GIC was to express that GIC interrupts are routed to the CPU
interrupt vectors and that a certain set of these vectors are
available for use by the GIC.  I would agree that these are mostly
redundant (obviously the GIC routes interrupts to CPU interrupt
vecotrs) and that it is not the most accurate description of the
GIC-CPU relationship (the CPU interrupt controller are per-CPU, not
global, and the GIC can route interrupts to any of them), though I'm
not sure that there's a better way of describing it in DT.

So that leaves us with something like this:

interrupt-controller@1bdc0000 {
        compatible = "mti,global-interrupt-controller";

        interrupt-controller;
        #interrupt-cells = <2>;

        available-cpu-vectors = <2>, <3>, ...
};

DT folks, thoughts?
