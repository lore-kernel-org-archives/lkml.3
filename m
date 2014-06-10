Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaFJSwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:52:08 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:52297 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaFJSwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:52:06 -0400
MIME-Version: 1.0
Date: Tue, 10 Jun 2014 11:52:05 -0700
Message-ID: <CAHQ1cqGy5gwEUFLS79y3=5_KmUEO+Q3ygDB-jXBZj5yN5xVqUg@mail.gmail.com>
Subject: i.MX6, PREEMPT-RT and interactive cpufreq governor
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, asmirnov@kymetacorp.com,
        panos@kymetacorp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I am working on integrating PREEMPT-RT patches into 3.10.17 kernel BSP
release from Freescale which can be found at:

http://git.freescale.com/git/cgit.cgi/imx/linux-2.6-imx.git (tag
imx_3.10.17_1.0.0_ga)

and what I am finding is that if I select "interactive" cpufreq
governor I get a kernel the kernel that occasionally spouts this

BUG: scheduling while atomic: swapper/3/0/0x00000002
Modules linked in:
Preemption disabled at:[<  (null)>]   (null)

CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.10.17-rt12-80705-g232293e-dirty #3
[<800139c4>] (unwind_backtrace+0x0/0xf8) from [<80011420>]
(show_stack+0x10/0x14)
[<80011420>] (show_stack+0x10/0x14) from [<805bfbbc>] (__schedule_bug+0x78/0x9c)
[<805bfbbc>] (__schedule_bug+0x78/0x9c) from [<805c431c>]
(__schedule+0x398/0x49c)
[<805c431c>] (__schedule+0x398/0x49c) from [<805c44d0>] (schedule+0x34/0xa0)
[<805c44d0>] (schedule+0x34/0xa0) from [<805c5250>]
(rt_spin_lock_slowlock+0xc0/0x258)
[<805c5250>] (rt_spin_lock_slowlock+0xc0/0x258) from [<80031d44>]
(lock_timer_base+0x2c/0x4c)
[<80031d44>] (lock_timer_base+0x2c/0x4c) from [<80032024>]
(mod_timer+0x60/0x1c0)
[<80032024>] (mod_timer+0x60/0x1c0) from [<803fe860>]
(cpufreq_interactive_idle_notifier+0xa4/0x13c)
[<803fe860>] (cpufreq_interactive_idle_notifier+0xa4/0x13c) from
[<80048444>] (notifier_call_chain+0)
[<80048444>] (notifier_call_chain+0x44/0x84) from [<80048754>]
(__atomic_notifier_call_chain+0x38/0x)
[<80048754>] (__atomic_notifier_call_chain+0x38/0x4c) from
[<80048780>] (atomic_notifier_call_chain+)
[<80048780>] (atomic_notifier_call_chain+0x18/0x20) from [<80058df8>]
(cpu_startup_entry+0x68/0x1a4)
[....] [<80058df8>] (cpu_startup_entry+0x68/0x1a4) from [<105bc204>]
(0x105bc204)


and eventually crashes. After doing some digging I believe the
sequence of events leading to this is following:

secondary_start_kernel() calls preempt_disable(), then
cpu_startup_entry(CPUHP_ONLINE), which results in a call to
cpufreq_interactive_idle_notifier() which in turn tries to use
mod_timer(). Mod_timer() internally tries to acquire a spinlock, but
with RT
patches applied it unfolds into a rt_mutex, the attempt of acquisition
of which results in the call to schedule() and that's when we
see that backtrace.

Eventually I am hoping to disable any sorts of frequency scaling or
power management on our system, but I am still curious to know if that
is a known issue patches for which exist. Does anyone has any leads/suggestions?

Thank you,
Andrey Smirnov
