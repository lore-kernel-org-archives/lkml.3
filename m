Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaIKX4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:56:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51502 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaIKX4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:56:10 -0400
Message-ID: <54123697.4070804@codeaurora.org>
Date: Thu, 11 Sep 2014 16:56:07 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Doug Anderson <dianders@chromium.org>
CC: Will Deacon <Will.Deacon@arm.com>, "olof@lixom.net" <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
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
Subject: Re: [PATCH v2] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
References: <1410452204-7277-1-git-send-email-dianders@chromium.org> <20140911164710.GW6158@arm.com>	<5411D528.4050605@arm.com> <CAD=FV=XMmizxJFPj0FEhJ7Gk4ZcQaUJDxf_Qq5kGKSvxDFVmzg@mail.gmail.com> <5411DA67.2040402@arm.com> <CAD=FV=UQfo4J3P4wGjOhQZQ5KXKgYAdjPsi1ykKZxQw-FwJz8w@mail.gmail.com> <5411DF5D.8060906@arm.com>
In-Reply-To: <5411DF5D.8060906@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/14 10:43, Marc Zyngier wrote:
>>> If I was suicidal, I'd suggest you could pass a parameter to the command
>>> line, interpreted by the timer code... But I since I'm not, let's
>>> pretend I haven't said anything... ;-)
>> I did this in the past (again, see Sonny's thread), but didn't
>> consider myself knowledgeable to know if that was truly a good test:
>>
>>        asm volatile("mrc p15, 0, %0, c1, c1, 0" : "=r" (val));
>>        pr_info("DOUG: val is %#010x", val);
>>        val |= (1 << 2);
>>        asm volatile("mcr p15, 0, %0, c1, c1, 0" : : "r" (val));
>>        val = 0xffffffff;
>>        asm volatile("mrc p15, 0, %0, c1, c1, 0" : "=r" (val));
>>        pr_info("DOUG: val is %#010x", val);
>>
>> The idea being that if you can make modifications to the SCR register
>> (and see your changes take effect) then you must be in secure mode.
>> In my case the first printout was 0x0 and the second was 0x4.
> The main issue is when you're *not* in secure mode. It is likely that
> this will explode badly. This is why I suggested something that is set
> by the bootloader (after all. it knows which mode it is booted in), and
> that the timer driver can use when the CPU comes up.

Where does this platform jump to when a CPU comes up? Is it
rockchip_secondary_startup()? I wonder if that path could have this
little bit of assembly to poke the cntvoff in monitor mode and then jump
to secondary_startup()? Before we boot any secondary CPUs we could also
read the cntvoff for CPU0 in the platform specific layer (where we know
we're running in secure mode) and then use that value as the "reset"
value for the secondaries. Or does this platform boot up in secure mode
some times and non-secure mode other times?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

