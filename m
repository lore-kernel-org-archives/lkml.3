Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaFCRek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:34:40 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:65324 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaFCRej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:34:39 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "larry.bassel\@linaro.org \"linux-kernel\@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel\@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v6 2/2] arm64: enable context tracking
References: <1401399904-24471-1-git-send-email-larry.bassel@linaro.org>
	<1401399904-24471-3-git-send-email-larry.bassel@linaro.org>
	<20140530182349.GI22895@arm.com> <7hioonythl.fsf@paris.lan>
	<20140603102646.GB23149@arm.com>
Date: Tue, 03 Jun 2014 10:34:35 -0700
In-Reply-To: <20140603102646.GB23149@arm.com> (Will Deacon's message of "Tue,
	3 Jun 2014 11:26:46 +0100")
Message-ID: <7hfvjlvqvo.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Deacon <will.deacon@arm.com> writes:

> Hi guys,
>
> On Fri, May 30, 2014 at 08:08:38PM +0100, Kevin Hilman wrote:
>> Will Deacon <will.deacon@arm.com> writes:
>> > I'd like to give these some stress testing before it gets merged, so I'm
>> > not sure if it'll make it for 3.16 given where we are at the moment.
>> 
>> FWIW, this feature is disabled by default.  I use the following kconfig
>> fragment to enable the various parts I use for testing:
>> 
>> CONFIG_NO_HZ=y
>> CONFIG_NO_HZ_FULL=y
>> CONFIG_NO_HZ_FULL_ALL=y
>> CONFIG_NO_HZ_FULL_SYSIDLE=y
>> 
>> # default to power-efficient workqueues (which are then set to unbound)
>> CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
>> 
>> # lockup detector sets a 4s timer on every CPU, which wakes CPUs
>> # from idle. (alternately, can be controlled via procfs,
>> # e.g: echo 0 > /proc/sys/kernel/watchdog)
>> #CONFIG_LOCKUP_DETECTOR=n
>
> I had a go with this, but I couldn't seem to trigger any context tracking
> without forcing CONFIG_CONTEXT_TRACKING_FORCE=y. Does that mean we're
> missing something else?

No, it just means that you never hit the conditions to trigger full
NOHZ.  Using _FORCE is a good way to do that since it forces the context
tracking paths whether or not it's actually needed by full NOHZ.

> Anyway, with that forced on, I see the following during boot:
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 0 at kernel/rcu/tree.c:418 rcu_eqs_enter+0x84/0xa4()
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.15.0-rc8+ #5
> Call trace:
> [<ffffffc000088048>] dump_backtrace+0x0/0x130
> [<ffffffc000088188>] show_stack+0x10/0x1c
> [<ffffffc0004891a0>] dump_stack+0x74/0xbc
> [<ffffffc0000a45e0>] warn_slowpath_common+0x8c/0xb4
> [<ffffffc0000a46cc>] warn_slowpath_null+0x14/0x20
> [<ffffffc0000efc14>] rcu_eqs_enter+0x80/0xa4
> [<ffffffc0000efc58>] rcu_idle_enter+0x20/0x50
> [<ffffffc0000dd314>] cpu_startup_entry+0x118/0x184
> [<ffffffc0004865ec>] rest_init+0x7c/0x88
> [<ffffffc000609800>] start_kernel+0x368/0x37c
> ---[ end trace c17313e162496e65 ]---

So this suggests that we've told RCU that we've entered userspace twice,
without having left (the context tracker is an extention of the RCU
extended quiscent state machinery.)

So after I was able to reproduce this (after some IRC discussion with
Will, and using full ubuntu rootfs and CONFIG_CONTEXT_TRACKING_FORCE=y)
I think I found the bug.

Basically, the problem is that we have a ct_user_exit in el1_irq
(interrupt in kernel space) when it should be in el0_irq (interrupt in
user space.)  

Moving the ct_user_exit into el0_irq, I'm not able to see the problem.  

Larry, could you sanity check that and respin a v8 with that change if
it works for you?

Thanks,

Kevin
