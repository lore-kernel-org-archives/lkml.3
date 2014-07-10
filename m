Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaGJKR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:17:57 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:65218 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaGJKRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:17:55 -0400
MIME-Version: 1.0
Date: Thu, 10 Jul 2014 15:47:54 +0530
Message-ID: <CAKohpomaE3DDrHT8NBYh9TBt_MN6vTDtBFX_R9kEsZuA3ipEmw@mail.gmail.com>
Subject: [Bug] Spurious hrtimer-interrupts
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kevin Hilman <khilman@linaro.org>,
        Santosh Shukla <santosh.shukla@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas/Daniel et al,

This isn't about the problem I reported earlier, where you advised
to add ONESHOT_STOPPED mode: https://lkml.org/lkml/2014/5/9/508.
Above problem was about stopping the clock-event device when
its not used anymore.

This ($subject) problem was initially spotted on Ivybrdge V2, 12 core
X86 server by Santosh. And then I reproduced it on Dual core ARM
Exynos (isn't that frequent as it was on x86 though).

Problem: Getting spurious ticks where hrtimer_interrupt() returns
without servicing any hrtimers.

Kernel hack to catch this: http://pastebin.com/bTM7nqDc (Over 3.16-rc3)
X86 boot logs: http://pastebin.com/E6axDnsa (search: hrtimer_interrupt)
/proc/cpuinfo: http://pastebin.com/uQx9TmsA

The last I could debug it to is:

- Clockevent device is programmed for time 'x' seconds (Verified this
  by storing next-event from within lapic_next_event()).
- Tick fires ~300 us before 'x'
- Traversing through the list of hrtimers doesn't result in any pending
hrtimer and we simply return. And so *spurious* interrupt.

- Happens when ticks are active or stopped (search for "tick-stopped"
in logs)

Driver monitored for x86: arch/x86/kernel/apic/apic.c
Similar behavior observed on exynos with arm_arch_timer.c

I couldn't get any deeper into it to see what's going on. From the behavior
It looks lik the calculations we are doing with dev->mult/shift gives
timeout <= next-event, whereas it should be >= ? Not at all sure though.

Reported-by: Santosh Shukla <santosh.shukla@linaro.org>

Note: Even the Hacky patchset that tried to to disable clockevent device
when not used anymore, isn't able to fix it:
https://lkml.org/lkml/2014/5/9/99..

--
viresh
