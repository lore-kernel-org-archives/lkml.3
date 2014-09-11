Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaIKRLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:11:08 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:55912 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaIKRLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:11:04 -0400
MIME-Version: 1.0
In-Reply-To: <5411D528.4050605@arm.com>
References: <1410452204-7277-1-git-send-email-dianders@chromium.org>
	<20140911164710.GW6158@arm.com>
	<5411D528.4050605@arm.com>
Date: Thu, 11 Sep 2014 10:11:02 -0700
X-Google-Sender-Auth: WsWp4tQHZER74EGH2LJjdvcoiAg
Message-ID: <CAD=FV=XMmizxJFPj0FEhJ7Gk4ZcQaUJDxf_Qq5kGKSvxDFVmzg@mail.gmail.com>
Subject: Re: [PATCH v2] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
From: Doug Anderson <dianders@chromium.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, "olof@lixom.net" <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 11, 2014 at 10:00 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 11/09/14 17:47, Will Deacon wrote:
>> On Thu, Sep 11, 2014 at 05:16:44PM +0100, Doug Anderson wrote:
>>> Some 32-bit (ARMv7) systems are architected like this:
>>>
>>> * The firmware doesn't know and doesn't care about hypervisor mode and
>>>   we don't want to add the complexity of hypervisor there.
>>>
>>> * The firmware isn't involved in SMP bringup or resume.
>>>
>>> * The ARCH timer come up with an uninitialized offset between the
>>>   virtual and physical counters.  Each core gets a different random
>>>   offset.
>>>
>>> On systems like the above, it doesn't make sense to use the virtual
>>> counter.  There's nobody managing the offset and each time a core goes
>>> down and comes back up it will get reinitialized to some other random
>>> value.
>>
>> You probably need to rephrase this slightly, as there *is* still a
>> requirement on the hypervisor/firmware (actually, two!). See below.
>>
>>> Let's add a property to the device tree to say that we shouldn't use
>>> the virtual timer.  Firmware could potentially remove this property
>>> before passing the device tree to the kernel if it really wants the
>>> kernel to use a virtual timer.
>>>
>>> Note that it's been said that ARM64 (ARMv8) systems the firmware and
>>> kernel really can't be architected as described above.  That means
>>> using the physical timer like this really only makes sense for ARMv7
>>> systems.
>>
>> I'd go further: this only makes sense if you're booting in secure SVC
>> mode.
>
> If that's the case, what's the problem? Enter monitor mode, set SCR.NS
> to one, nuke CNTVOFF, revert, job done.
>
> What am I missing?

Stuff like this was talked about in the thread about Sonny's patch at
<https://patchwork.kernel.org/patch/4790921/>

...in that case we were always talking about HYP mode, though.  I
don't think anyone has explicitly talked about just switching to
monitor mode and then leaving ourselves in Secure SVC after we're
done.  It would be nice (especially for the VDSO guys) if we could
just init the virtual offset...

We would need to run this code potentially at processor bringup and
after suspend/resume, but that seems possible too.

Is the transition to monitor mode and back simple?  Where would you
suggest putting this code?  It would definitely need to be pretty
early.  We'd also need to be able to detect that we're in Secure SVC
and not mess up anyone else who happened to boot in Non Secure SVC.

-Doug
