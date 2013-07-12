Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351Ab3GLUNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:13:22 -0400
Received: from www.sr71.net ([198.145.64.142]:48079 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965197Ab3GLUNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:13:21 -0400
Message-ID: <51E0635B.6010003@sr71.net>
Date: Fri, 12 Jul 2013 13:13:15 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Yet more softlockups.
References: <20130706072408.GA14865@gmail.com> <20130710151324.GA11309@redhat.com> <20130710152015.GA757@x4> <20130710154029.GB11309@redhat.com> <20130712103117.GA14862@gmail.com> <51E0230C.9010509@intel.com> <20130712154521.GD1020@redhat.com> <51E038ED.7050600@gmail.com> <20130712171808.GD1537@redhat.com> <51E03F76.3090607@gmail.com> <20130712175028.GA11036@redhat.com> <51E045E0.8020702@gmail.com>
In-Reply-To: <51E045E0.8020702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added the WARN_ONCE() the first time we enable a perf event:  The
watchdog code looks to use perf these days:

> [    1.003260] ------------[ cut here ]------------
> [    1.007943] WARNING: at /home/davehans/linux.git/arch/x86/kernel/cpu/perf_event.c:471 x86_pmu_event_init+0x249/0x430()
> [    1.018906] Modules linked in:
> [    1.021999] CPU: 0 PID: 11 Comm: watchdog/0 Not tainted 3.10.0-05973-gd2b4a64-dirty #190
> [    1.030313] Hardware name: FUJITSU-SV PRIMEQUEST 1800E2/SB, BIOS PRIMEQUEST 1000 Series BIOS Version 1.24 09/14/2011
> [    1.041093]  ffffffff819dc0b8 ffff881fd33e3c98 ffffffff816270c5 0000000000001a9d
> [    1.048601]  0000000000000009 ffff881fd33e3cd8 ffffffff81090f50 ffff881fd3248048
> [    1.056112]  ffff881fff26a800 ffff881fff26a800 0000000000000000 0000000000000000
> [    1.063621] Call Trace:
> [    1.066106]  [<ffffffff816270c5>] dump_stack+0x55/0x76
> [    1.071313]  [<ffffffff81090f50>] warn_slowpath_common+0x70/0xa0
> [    1.077410]  [<ffffffff81090f9a>] warn_slowpath_null+0x1a/0x20
> [    1.083330]  [<ffffffff81060cb9>] x86_pmu_event_init+0x249/0x430
> [    1.089427]  [<ffffffff81144f0f>] perf_init_event+0xef/0x130
> [    1.095170]  [<ffffffff811452a8>] perf_event_alloc+0x358/0x4a0
> [    1.101091]  [<ffffffff810ca27d>] ? set_next_entity+0x3d/0x80
> [    1.106924]  [<ffffffff811081a0>] ? touch_nmi_watchdog+0x80/0x80
> [    1.113018]  [<ffffffff8114570e>] perf_event_create_kernel_counter+0x2e/0xe0
> [    1.120176]  [<ffffffff8110835d>] watchdog_enable+0xfd/0x1e0
> [    1.125919]  [<ffffffff810bf8e3>] smpboot_thread_fn+0xe3/0x1f0
> [    1.131839]  [<ffffffff810bf800>] ? smpboot_unregister_percpu_thread+0x50/0x50
> [    1.139250]  [<ffffffff810b7d10>] kthread+0xc0/0xd0
> [    1.144200]  [<ffffffff810b7c50>] ? flush_kthread_worker+0xb0/0xb0
> [    1.150474]  [<ffffffff8163735c>] ret_from_fork+0x7c/0xb0
> [    1.155950]  [<ffffffff810b7c50>] ? flush_kthread_worker+0xb0/0xb0
> [    1.162227] ---[ end trace 32c04e859824e00d ]---

static int watchdog_nmi_enable(unsigned int cpu)
{
...
        /* Try to register using hardware perf events */
        event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, ...

That at least solves the boot-time mystery.
