Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3JBSO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:14:28 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:45608 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3JBSO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:14:27 -0400
MIME-Version: 1.0
In-Reply-To: <524C5B10.20006@codeaurora.org>
References: <1380732928-13897-1-git-send-email-santosh.shilimkar@ti.com>
	<20131002170917.GB30298@mudshark.cambridge.arm.com>
	<524C5484.5000601@ti.com>
	<524C565C.8010709@codeaurora.org>
	<524C5786.2090008@ti.com>
	<524C5B10.20006@codeaurora.org>
Date: Wed, 2 Oct 2013 13:14:26 -0500
Message-ID: <CAL_JsqLYArFsA2aX2fqTepXOenLzwM5HFfmYCDosBVWSaCmC1A@mail.gmail.com>
Subject: Re: [PATCH] sched_clock: fix postinit no sched_clock function check
From: Rob Herring <robherring2@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "arm@kernel.org" <arm@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 12:42 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 10/02/13 10:27, Santosh Shilimkar wrote:
>> On Wednesday 02 October 2013 01:22 PM, Stephen Boyd wrote:
>>> On 10/02/13 10:14, Santosh Shilimkar wrote:
>>>> On Wednesday 02 October 2013 01:09 PM, Will Deacon wrote:
>>>>> On Wed, Oct 02, 2013 at 05:55:28PM +0100, Santosh Shilimkar wrote:
>>>>>> The sched_clock code uses 2 levels of function pointers, sched_clock_func()
>>>>>> and read_sched_clock() but the no sched_clock check in postinit() just
>>>>>> checks read_sched_clock().
>>>>>>
>>>>>> This leads to kernel falling back to jiffy based sched clock even in
>>>>>> presence of sched_clock_func() which is not desirable.
>>>>>>
>>>>>> Fix the postinit() check to avoid the issue. Probably the issue is hidden
>>>>>> so far on most of the arm SOCs because of already existing sched_clock
>>>>>> registrations apart from arch_timer sched_clock. One can reproduce the
>>>>>> issue by just have arch_timer as sched_clock
>>>>> Isn't this just an issue with the arch timer driver not calling
>>>>> setup_sched_clock? Instead, we munge around with sched_clock_func directly,
>>>>> which doesn't appear to be the way anybody else deals with this.
>>>>>
>>>> I thought about that option as well but was not sure since even in that case
>>>> the check is not complete. We just ensure that function is popullated.
>>> Yes, nothing is actually broken because sched_clock_func() won't try to
>>> use the jiffy based read_sched_clock() function. I'm not sure we
>>> actually need this patch besides to remove a useless timer that updates
>>> the jiffy epoch. Can we wait until my 64-bit sched_clock patch series
>>> lands in 3.13? It looks like I still need an ack from Will or Catalin on
>>> the architected timer patch before the clocksource folks pick it up.
>>>
>> Really... I have not created patch out of fun.
>> Its broken on my keystone machine at least where the sched_clock is
>> falling back on jiffy based sched_clock even in presence of arch_timer
>> sched_clock.
>
> How is that possible? sched_clock_func is only assigned by
> arch/arm/kernel/arch_timer.c when the architected timer is detected and
> sched_clock() in kernel/time/sched_clock.c calls that function pointer
> unconditionally. The only way I see this happening is if the architected
> timer rate is zero. I agree we will get two lines in the dmesg about
> sched_clock and its not very clear which one is being used.

It does setup a timer to run to handle wrapping which should be
harmless, but isn't needed.

Rob
