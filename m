Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaILMPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:15:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43773 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbaILMO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:14:58 -0400
Message-ID: <5412E3BB.9030800@arm.com>
Date: Fri, 12 Sep 2014 13:14:51 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christopher Covington <cov@codeaurora.org>
CC: Doug Anderson <dianders@chromium.org>, Will Deacon <Will.Deacon@arm.com>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
References: <1410452204-7277-1-git-send-email-dianders@chromium.org> <20140911164710.GW6158@arm.com>	<5411D528.4050605@arm.com> <CAD=FV=XMmizxJFPj0FEhJ7Gk4ZcQaUJDxf_Qq5kGKSvxDFVmzg@mail.gmail.com> <5411DA67.2040402@arm.com> <CAD=FV=UQfo4J3P4wGjOhQZQ5KXKgYAdjPsi1ykKZxQw-FwJz8w@mail.gmail.com> <5411DF5D.8060906@arm.com> <5412DC48.7030708@codeaurora.org>
In-Reply-To: <5412DC48.7030708@codeaurora.org>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 12 Sep 2014 12:14:53.0259 (UTC) FILETIME=[2880A1B0:01CFCE83]
X-MC-Unique: 114091213145510101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

On 12/09/14 12:43, Christopher Covington wrote:
> Hi Marc,
> 
> On 09/11/2014 01:43 PM, Marc Zyngier wrote:
>> On 11/09/14 18:29, Doug Anderson wrote:
>>> Marc,
>>>
>>> On Thu, Sep 11, 2014 at 10:22 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>>> We would need to run this code potentially at processor bringup and
>>>>> after suspend/resume, but that seems possible too.
>>>>
>>>> Note that this would be an ARMv7 only thing (you can't do that on ARMv8,
>>>> at all).
>>>
>>> Yes, of course.
>>>
>>>
>>>>> Is the transition to monitor mode and back simple?  Where would you
>>>>> suggest putting this code?  It would definitely need to be pretty
>>>>> early.  We'd also need to be able to detect that we're in Secure SVC
>>>>> and not mess up anyone else who happened to boot in Non Secure SVC.
>>>>
>>>> This would have to live in some very early platform-specific code. The
>>>> ugly part is that you cannot find out what world you're in (accessing
>>>> SCR is going to send you to UNDEF-land if accessed from NS).
>>>
>>> Yup, so the question is: would such code be accepted upstream, or are
>>> we going to embark on a big job for someone to figure out how to do
>>> this only to get NAKed?
>>>
>>> If there was some indication that folks would take this, I think we
>>> might be able to get it coded up.  If someone else wanted to volunteer
>>> to code it that would make me even happier, but maybe that's pushing
>>> my luck.  ;)
>>
>> Writing the code is a 5 minute job. Getting it accepted is another
>> story, and I'm not sure everyone would agree on that.
>>
>>>> If I was suicidal, I'd suggest you could pass a parameter to the command
>>>> line, interpreted by the timer code... But I since I'm not, let's
>>>> pretend I haven't said anything... ;-)
>>>
>>> I did this in the past (again, see Sonny's thread), but didn't
>>> consider myself knowledgeable to know if that was truly a good test:
>>>
>>>        asm volatile("mrc p15, 0, %0, c1, c1, 0" : "=r" (val));
>>>        pr_info("DOUG: val is %#010x", val);
>>>        val |= (1 << 2);
>>>        asm volatile("mcr p15, 0, %0, c1, c1, 0" : : "r" (val));
>>>        val = 0xffffffff;
>>>        asm volatile("mrc p15, 0, %0, c1, c1, 0" : "=r" (val));
>>>        pr_info("DOUG: val is %#010x", val);
>>>
>>> The idea being that if you can make modifications to the SCR register
>>> (and see your changes take effect) then you must be in secure mode.
>>> In my case the first printout was 0x0 and the second was 0x4.
>>
>> The main issue is when you're *not* in secure mode. It is likely that
>> this will explode badly. This is why I suggested something that is set
>> by the bootloader (after all. it knows which mode it is booted in), and
>> that the timer driver can use when the CPU comes up.
> 
> What exactly does "exploding badly" look like? Causing and undefined
> instruction exception? That's just a branch with a mode switch. Any reason the
> code couldn't deal with that or even use that to its advantage?

We surely can handle the UNDEF and do something there. We just can't do
it the way Doug described it above.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

