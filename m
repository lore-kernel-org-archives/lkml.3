Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaIJTuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:50:20 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:51398 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaIJTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:50:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140910184652.GP1710@arm.com>
References: <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
	<53FE7E3B.1010500@codeaurora.org>
	<CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
	<CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com>
	<20140828093505.GC14650@leverpostej>
	<CAD=FV=UwfP0x-bswbtV_eUvpKeOSNnsVVLTE3VHguyhm_jiSug@mail.gmail.com>
	<20140908135436.GC22717@arm.com>
	<CAD=FV=Up=+zNneY-behnkFbhupi50_f5R=ECgJQeqGV5kz5d2g@mail.gmail.com>
	<20140910173401.GG1710@arm.com>
	<CAD=FV=WJpP1aAo-r9bnUQg5xarGQYo8pROvyh0a5dt+m1OOn4g@mail.gmail.com>
	<20140910184652.GP1710@arm.com>
Date: Wed, 10 Sep 2014 12:50:16 -0700
X-Google-Sender-Auth: XUdWTGZKyVF0vX_zd8trAbiRyPo
Message-ID: <CAD=FV=W_d=S-N-hguLsH+pf3kT1XqQNMMqGZ4o2wnpWZB9T70g@mail.gmail.com>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
From: Doug Anderson <dianders@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Sonny Rao <sonnyrao@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On Wed, Sep 10, 2014 at 11:46 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Sep 10, 2014 at 07:09:59PM +0100, Doug Anderson wrote:
>> On Wed, Sep 10, 2014 at 10:34 AM, Will Deacon <will.deacon@arm.com> wrote:
>> > Setting aside the security model, booting in secure mode can also have a
>> > significant impact on the programming model of system IP, not just the CPU.
>> > For example, the SMMU register file suddenly looks different and the way in
>> > which it is programmed also changes. The GIC (v3+) is similar. Linux doesn't
>> > have drivers that know about this so, whilst not impossible, there's a
>> > non-trivial amount of work (and then maintenance overhead) if you want to
>> > support booting Linux on the secure side.
>>
>> Hrm.  I could have sworn someone told me that exynos5250-snow is
>> booted in Secure SVC mode and has been that way forever.  I could
>> certainly be wrong.  Stupid question, but should any of your
>> statements apply to an A15 or an A12?  Maybe things change with newer
>> CPUs?
>
> Snow does boot secure, which is why you don't get KVM without hacking the
> bootloader. However, snow also doesn't use:

Well, you could get KVM if the kernel knew to switch from "secure SVC"
to "nonsecure HYP", right?  ...so one bonus of implementing this (for
32-bit ARM only, of course) is that legacy systems (like snow) would
magically get KVM without replacing the bootloader...


> Again, this isn't the kind of platform I was referring to. Until recently,
> (32-bit) Linux has booted in secure svc just fine and there's no reason to
> break platforms relying on that.

Yup, exactly.  I'm definitely not on the cutting edge here.  Just
working on plain old boring 32-bit systems.  ;)  I have even less
knowledge about 64-bit systems than 32 bit if that can be believed.
;)


> Just to reiterate, you're talking ARMv7 and I'm talking ARMv8. For ARMv7,
> there is a separate argument about whether we should make bootloaders
> simple and the OS more complex, which has been had on the mailing list
> before (I don't think there was a good conclusion though -- Nico and Catalin
> were discussing about MCPM and PSCI, which is very much related to this
> topic).

Yup.  I'm super happy that folks are figuring this out. :)  I think my
viewpoint / position is adequately clear at this point, so I'll step
back and let the experts work something out and focus my attention on
kitchens that have fewer chefs.  If things need to be different on
ARMv8 then the folks working on those system will need to solve these
problems.  ...but it would be nice if we weren't forced to solve them
on 32-bit.



>> > The secure world may be more permissive in some regards, but it's actually
>> > a burden in others. It's not a simple superset of non-secure, and this is
>> > more evident than ever in ARMv8.
>> >
>> > As I understand it, this conversation started because we're booting at
>> > non-secure EL1 with a badly configured EL2. That sounds like something
>> > we may have to fix/work around in Linux (Olof points out that it used to
>> > work), but we shouldn't conflate that with booting on the secure side to
>> > get away from broken firmware.
>>
>> See above and also my summary to Mark Rutland.  I don't think your
>> statement above is quite where we're at, but hopefully we're on the
>> same page now.  :)
>
> If `where we're at' is trying to boot an ARMv7 product, then you can boot in
> secure svc and lose virtualisation support. Looking forward to ARMv8, this
> isn't going to work, so I'd encourage you to start thinking about getting
> a working bootloader as a requirement.

Yup, definitely on the same page now.  With everyone working on this
I'd imagine that there will be some nice standards worked out by the
time real ARMv8 is ready to ship?

...so would you say that you're in support of landing the patch to
allow physical counters?  I know Olof has Acked the patch above, but
it's nice if there's general agreement that it's OK.


-Doug
