Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaICAuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 20:50:09 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:39300 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaICAuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 20:50:06 -0400
Message-ID: <540665BA.3080702@gmail.com>
Date: Tue, 02 Sep 2014 17:50:02 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
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
Subject: Re: [PATCH 03/12] of: Add binding document for MIPS GIC
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org> <1409350479-19108-4-git-send-email-abrestic@chromium.org> <5405FE07.4030400@gmail.com> <CAL1qeaHcV_4Z9n_THEN_aST3smgaW1vwn81SkmbU0AUJ_rdB1Q@mail.gmail.com>
In-Reply-To: <CAL1qeaHcV_4Z9n_THEN_aST3smgaW1vwn81SkmbU0AUJ_rdB1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 12:36 PM, Andrew Bresticker wrote:
> On Tue, Sep 2, 2014 at 10:27 AM, David Daney <ddaney.cavm@gmail.com> wrote:
>> On 08/29/2014 03:14 PM, Andrew Bresticker wrote:
>>>
>>> The Global Interrupt Controller (GIC) present on certain MIPS systems
>>> can be used to route external interrupts to individual VPEs and CPU
>>> interrupt vectors.  It also supports a timer and software-generated
>>> interrupts.
>>>
>>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>>> ---
>>>    Documentation/devicetree/bindings/mips/gic.txt | 50
>>> ++++++++++++++++++++++++++
>>>    1 file changed, 50 insertions(+)
>>>    create mode 100644 Documentation/devicetree/bindings/mips/gic.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/mips/gic.txt
>>> b/Documentation/devicetree/bindings/mips/gic.txt
>>> new file mode 100644
>>> index 0000000..725f1ef
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/mips/gic.txt
>>> @@ -0,0 +1,50 @@
>>> +MIPS Global Interrupt Controller (GIC)
>>> +
>>> +The MIPS GIC routes external interrupts to individual VPEs and IRQ pins.
>>> +It also supports a timer and software-generated interrupts which can be
>>> +used as IPIs.
>>> +
>>> +Required properties:
>>> +- compatible : Should be "mti,global-interrupt-controller"
>>> +- reg : Base address and length of the GIC registers.
>>> +- interrupts : Core interrupts to which the GIC may route external
>>> interrupts.
>>
>>
>> This doesn't make sense to me.  The GIC can, and does, route interrupts to
>> all CPU cores in a SMP system.  How can there be a concept of only
>> associating it with several interrupt lines on a single CPU in the system?
>> That is not what the GIC does, is it?  It is a Global interrupts controller,
>> not local.  So specifying device tree bindings that don't show its Global
>> nature seems wrong.
>
> While the GIC can route external interrupts to any HW interrupt vector
> it may not make sense to actually use all those vectors.  For example,
> the CP0 timer is usually hooked up to HW vector 5 (it could be treated
> as a GIC local interrupt, though it may still be fixed to HW vector
> 5).  BTW, the Malta example about the i8259 I gave before was wrong -
> it appears that it actually gets chained with the GIC.

Your comments don't really make sense to me in the context of my 
knowledge of the GIC.

Of course all the CP0 timer and performance counter interrupts are 
per-CPU and routed directly to the corresponding CP0_Cause[IP7..IP2] 
bits.  We are don't need to give them further consideration.


Here is the scenario you should consider:

   o 16 CPU cores.
   o 1 GIC routing interrupts from external sources to the 16 CPUs.
   o 2 network controllers each with an interrupt line routed to the GIC.

Q: What would the GIC "interrupts" property look like?

Note that the GIC doesn't have a single "interrupt-parent", as it can 
route interrupts to *all* 16 CPUs.

I propose that the GIC have neither an "interrupt-parent", nor 
"interrupts".  The fact that it is an "mti,global-interrupt-controller", 
means that the software drivers for the GIC already know how to route 
interrupts, and any information the device tree could contain is redundant.

 >
 > What would you suggest instead?  Route all GIC interrupts to a single
 > vector?

Yes.  The OCTEON interrupt controllers although architecturally 
distinct, have many of the same features as the GIC, and this is what we 
do there.  You could route the IPI interrupts to IP2, and device 
interrupts to IP3, or some similar arrangement.

But the main point is that the hardware is very flexible in how the 
interrupt signals are routed.  Somehow encoding a single simple and very 
restricted topology into the device-tree doesn't seem useful to me.

It may be the case that only certain of the CP0_Cause[IP7..IP2] bits 
should  be used by the GIC in a particular system (if they are used by 
timer or profiling hardware for example).  If that is the case, then we 
would have to have some way to specify that.  But it wouldn't be done 
via the "interrupts" property.


 >  Attempt to distribute them over all 6 vectors?

No.
