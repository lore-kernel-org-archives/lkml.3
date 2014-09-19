Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbaISQwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:52:40 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:44153 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbaISQwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:52:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140919133056.GE2295@e104818-lin.cambridge.arm.com>
References: <1410901756-20694-1-git-send-email-cov@codeaurora.org>
 <5418AA80.4090102@codeaurora.org> <54198BDE.8000509@codeaurora.org>
 <CAFEAcA-Z_KqCrBRKLxtEaca3jAH35Xx=CqOr36KgAGfFrE91nw@mail.gmail.com>
 <541C2E02.5000303@codeaurora.org> <20140919133056.GE2295@e104818-lin.cambridge.arm.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Fri, 19 Sep 2014 09:52:17 -0700
X-Google-Sender-Auth: ejZPr97ZzIiWYcFHHhEgkFcDbZY
Message-ID: <CAPz6YkU0rJBAniFidASQm8E15bo=jCrbo1QeWFtXELeuj33Lsw@mail.gmail.com>
Subject: Re: [RFC] arm: Handle starting up in secure mode
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Covington <cov@codeaurora.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        Doug Anderson <dianders@chromium.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 6:30 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Fri, Sep 19, 2014 at 02:22:10PM +0100, Christopher Covington wrote:
>> On 09/19/2014 01:56 AM, Peter Maydell wrote:
>> > On 17 September 2014 06:25, Christopher Covington <cov@codeaurora.org> wrote:
>> >> On 09/16/2014 05:24 PM, Christopher Covington wrote:
>> >>> On 09/16/2014 05:09 PM, Christopher Covington wrote:
>> >>>> ARM Linux currently has the most features available to it in hypervisor
>> >>>> (HYP) mode, so switch to it when possible. This can also ensure proper
>> >>>> reset of newer registers such as CNTVOFF.
>> >>>>
>> >>>> The permissions on the Non-Secure Access Control Register (NSACR) are
>> >>>> used to probe what the security setting currently is when in supervisor
>> >>>> (SVC) mode.
>> >>>
>> >>> Sorry, this doesn't work yet. I was misinterpreting my test results. For what
>> >>> it's worth, my testing and development methodology is to run it after hacked
>> >>> up versions of the semihosting bootwrapper on the simulator that corresponds
>> >>> to rtsm_ve-aemv8a.dtb (AEM VE FVP these days?) and examine the instruction traces.
>> >>
>> >> Looks like the real problem was that I was hacking up the bootwrapper
>> >> incorrectly--my start-in-secure-mode bootwrapper variant wasn't setting up the
>> >> GIC for non-secure access. With that changed, I've tested the following
>> >> variations using the Image file in a single core configuration.
>> >>
>> >> Start in non-secure SVC with non-secure access to GIC configured.
>> >>
>> >> Start in secure SVC with non-secure access to GIC configured.
>> >>
>> >> Start in secure SVC with non-secure access to GIC configured and hypervisor
>> >> support disabled in the model (-C cluster.has_el2=0). This required setting
>> >> the VBAR again in non-secure SVC but with that fix it seems to work. I'll
>> >> include this change in v2.
>> >
>> > If you're relying on the boot loader to set up the GIC to support
>> > non-secure access anyway, why not just have it boot the kernel in Hyp
>> > like the boot protocol document recommends? (The same thing as the GIC
>> > is going to apply for any other hardware that needs configuration to
>> > allow NS access; if we need the firmware to deal with this we might as
>> > well just have it boot us in the right mode too.)
>>
>> I'd like to get rid of as much of the bootwrapper as possible (having gotten
>> spoiled by using QEMU's built-in bootloader). I'm just taking it one step at a
>> time. Handling GIC initialization in the kernel is probably the next step.
>
> The problem is that the kernel doesn't know about GIC until much later.
> So I don't see an easy workaround, other than relying on the boot-loader
> to do the right thing (and then we go to the point Peter made about
> changing it to start Linux in Hyp mode directly).

Well, for us, the issue is that our boot-loader isn't involved in
secondary cpu startup, either at boot time nor suspend/resume or cpu
hotplug/power gating.
So we certainly could have the boot loader set up the GIC for
non-secure access and then this type of solution would work, though
I'm not sure what else might need to be set up for non-secure access.

>
> --
> Catalin
