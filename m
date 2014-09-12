Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaILDZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:25:50 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35353 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaILDZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <541249B8.301@codeaurora.org>
References: <1410452204-7277-1-git-send-email-dianders@chromium.org>
 <20140911164710.GW6158@arm.com> <5411D528.4050605@arm.com>
 <CAD=FV=XMmizxJFPj0FEhJ7Gk4ZcQaUJDxf_Qq5kGKSvxDFVmzg@mail.gmail.com>
 <5411DA67.2040402@arm.com> <CAD=FV=UQfo4J3P4wGjOhQZQ5KXKgYAdjPsi1ykKZxQw-FwJz8w@mail.gmail.com>
 <5411DF5D.8060906@arm.com> <54123697.4070804@codeaurora.org>
 <CAPz6YkUTXU9_b2BU5QghKTHVTJ3ngVX9EOzsMWnjigtV9TioHw@mail.gmail.com> <541249B8.301@codeaurora.org>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Thu, 11 Sep 2014 20:25:27 -0700
X-Google-Sender-Auth: Xm_cmrEXpG9Rgq4EmCSkR7K_ujc
Message-ID: <CAPz6YkUOR-+CEx__FGZkR42RRcn7hjdR_B95MBBe2zfR-70fqQ@mail.gmail.com>
Subject: Re: [PATCH v2] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Doug Anderson <dianders@chromium.org>,
        Will Deacon <Will.Deacon@arm.com>, "olof@lixom.net" <olof@lixom.net>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 6:17 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 09/11/14 17:14, Sonny Rao wrote:
>
> On Thu, Sep 11, 2014 at 4:56 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>
>>
>> Where does this platform jump to when a CPU comes up? Is it
>> rockchip_secondary_startup()? I wonder if that path could have this
>> little bit of assembly to poke the cntvoff in monitor mode and then jump
>> to secondary_startup()? Before we boot any secondary CPUs we could also
>> read the cntvoff for CPU0 in the platform specific layer (where we know
>> we're running in secure mode) and then use that value as the "reset"
>> value for the secondaries. Or does this platform boot up in secure mode
>> some times and non-secure mode other times?
>
>
> Yes, In our case, with our firmware, we will go through some internal Rom
> code and then jump to rockchip_secondary_startup, but I don't think it's
> correct to force all users of this SoC to do it that way.
>
>
> What's being forced? The way internal rom jumps to sram? Is there any other
> way that secondary CPUs come out of reset on this SoC? From looking at the
> code it seems like the only path is internal rom jumps to sram (where
> rockchip_secondary_trampoline lives) which jumps to
> rockchip_secondary_startup() which then does an invalidate and jump to
> secondary_startup(). Linux controls everything besides the internal rom. Is
> something different in your case?


There are other ways it can be done, and I don't know all of the
possibilities, but there seems to be some protocol with the iROM that
tells it where to go, which the current SMP patches are using by
putting a magic number and an address in SRAM.  I think it's true that
in our case, it really is pretty simple and we have secure SVC mode
and not much else runs (besides the iROM).

Since I don't know all of the possibilities, I didn't want to preclude
the possibility that someone else handled things differently and
entered the kernel in non-secure mode, and have some code there that
broke in that instance, that's all I meant by "forced".

>
>  If there were a reasonable way to determine for sure that we are in secure
> mode, then yes we could do what you're suggesting, and I'd be happy to code
> that up.
>
>
> I think the problem is that there isn't a great way to determine whether
> we're in secure mode or not, and this is maybe by design?  I don't
> particularly understand that design choice.  It would be nice to hear some
> rationale from ARM folks.
>
>
> I'm thinking we would have a different boot-method for secure vs. non-secure
> and then we would know to configure cntvoff or not based on the boot method.
> Isn't that a reasonable way of knowing what should be done? It seems like we
> can at least modify the DT for this SoC.

Putting something into the device-tree is in fact the point of this
patch, so it is sort of doing what you're suggesting, although this
patch is about being able use to physical counters and doesn't
indicate anything about secure vs non-secure.  What else do you think
could be used to differentiate between the two cases, besides putting
it into the DT?

>
> I still wonder if there is such a bootloader/hypervisor/rom that's putting
> this SoC into non-secure mode and not configuring cntvoff. Doug's comments
> seem to suggest that the whole world would be different if this were true.
> Maybe Heiko knows?

As far as I'm aware, there's no bootloader/firmware that's ever
putting the CPU into non-secure mode for our case.

> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
