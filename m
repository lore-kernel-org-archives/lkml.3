Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaBMDL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:11:28 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38267 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaBMDL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:11:26 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-94-52fc37db0b13
From: Tarek Dakhran <t.dakhran@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tarek Dakhran <t.dakhran@gmail.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: [PATCH v1 0/2] exynos_mct driver: fix irq allocation and cleanup
Date: Thu, 13 Feb 2014 12:08:41 +0900
Message-id: <1392260923-31659-1-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t/xq7q3zf8EGXy4w2Ux77OsRe+Cq2wW
	mx5fY7W4vGsOm8WM8/uYLG5f5rU4+aeX0eJ3zydmi/XPTzFarJ/xmsVi86apzBZTZ/xgd+Dx
	aGnuYfPYOesuu8eda3vYPN6dO8fusXlJvUffllWMHp83yQWwR3HZpKTmZJalFunbJXBlfJgw
	m7lgslLF5K9nWRoY58t2MXJySAiYSGxovsgEYYtJXLi3nq2LkYtDSGApo8ThazegnF4mia9v
	3gA5HBxsAtoSW3Z4gTSICChIbO59xgpSwyywiVni8oJPYJOEBTwlujYcZAGxWQRUJdr7J4DF
	eQVcJZY964PapijR/WwC2wRG7gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQsLs6w7G
	pcesDjEKcDAq8fA+WPw7SIg1say4MvcQowQHs5IIr4zEnyAh3pTEyqrUovz4otKc1OJDjEwc
	nFINjJfn/X+2XG2Z8LW4mJ5Yy+8hr7R0Z0blHDh5P1nqdvmXFS+n7DHQ4WfWkFOaw7NSasqy
	SA1ppnbTDv0jwf7pCenPvurNurjo+OePVfxv39vu1ZZk/Rv2rPH1efYPaybIrHGXfnNahKm7
	38joxX7B8wu1Q+Pzr0kYLLj478f6vRlOieczX66bK63EUpyRaKjFXFScCADMCl6IEQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos4_local_timer_setup called on the secondary cpu before
irqs are enabled. request_irq can sleep, which produces next warning:

on boot:
[    0.370000] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.370000] Setting up static identity map for 0x403b5700 - 0x403b5758
[    0.395000] CPU1: Booted secondary processor
[    0.395000] ------------[ cut here ]------------
[    0.395000] WARNING: CPU: 1 PID: 0 at kernel/locking/lockdep.c:2742 lockdep_trace_alloc+0xe0/0xfc()
[    0.395000] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
[    0.395000] Modules linked in:
[    0.395000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc2-00004-g0db95f4 #128
[    0.395000] [<c0014308>] (unwind_backtrace) from [<c0011690>] (show_stack+0x10/0x14)
[    0.395000] [<c0011690>] (show_stack) from [<c03ae7d0>] (dump_stack+0x6c/0xb8)
[    0.395000] [<c03ae7d0>] (dump_stack) from [<c001d504>] (warn_slowpath_common+0x68/0x8c)
[    0.395000] [<c001d504>] (warn_slowpath_common) from [<c001d5bc>] (warn_slowpath_fmt+0x30/0x40)
[    0.395000] [<c001d5bc>] (warn_slowpath_fmt) from [<c0059824>] (lockdep_trace_alloc+0xe0/0xfc)
[    0.395000] [<c0059824>] (lockdep_trace_alloc) from [<c00bee24>] (kmem_cache_alloc+0x24/0x160)
[    0.395000] [<c00bee24>] (kmem_cache_alloc) from [<c0068174>] (request_threaded_irq+0x64/0x130)
[    0.395000] [<c0068174>] (request_threaded_irq) from [<c02efaf8>] (exynos4_local_timer_setup+0xd0/0x124)
[    0.395000] [<c02efaf8>] (exynos4_local_timer_setup) from [<c02efc34>] (exynos4_mct_cpu_notify+0x78/0xf0)
[    0.395000] [<c02efc34>] (exynos4_mct_cpu_notify) from [<c003d318>] (notifier_call_chain+0x44/0x84)
[    0.395000] [<c003d318>] (notifier_call_chain) from [<c001d61c>] (__cpu_notify+0x24/0x40)
[    0.395000] [<c001d61c>] (__cpu_notify) from [<c0013314>] (secondary_start_kernel+0xe4/0x134)
[    0.395000] [<c0013314>] (secondary_start_kernel) from [<40008624>] (0x40008624)
[    0.395000] ---[ end trace 347890460e745f50 ]---
[    0.420000] CPU1: update cpu_power 1024
[    0.420000] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001

on hotplug:
[  108.040000] CPU3: Booted secondary processor
[  108.040000] BUG: sleeping function called from invalid context at mm/slub.c:965
[  108.040000] in_atomic(): 1, irqs_disabled(): 128, pid: 0, name: swapper/3
[  108.040000] INFO: lockdep is turned off.
[  108.040000] irq event stamp: 0
[  108.040000] hardirqs last  enabled at (0): [<  (null)>]   (null)
[  108.040000] hardirqs last disabled at (0): [<c001b768>] copy_process.part.2+0x2a4/0x12f4
[  108.040000] softirqs last  enabled at (0): [<c001b768>] copy_process.part.2+0x2a4/0x12f4
[  108.040000] softirqs last disabled at (0): [<  (null)>]   (null)
[  108.040000] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.14.0-rc2-00004-g0db95f4 #128
[  108.040000] [<c0014308>] (unwind_backtrace) from [<c0011690>] (show_stack+0x10/0x14)
[  108.040000] [<c0011690>] (show_stack) from [<c03ae7d0>] (dump_stack+0x6c/0xb8)
[  108.040000] [<c03ae7d0>] (dump_stack) from [<c00beed4>] (kmem_cache_alloc+0xd4/0x160)
[  108.040000] [<c00beed4>] (kmem_cache_alloc) from [<c0068174>] (request_threaded_irq+0x64/0x130)
[  108.040000] [<c0068174>] (request_threaded_irq) from [<c02efaf8>] (exynos4_local_timer_setup+0xd0/0x124)
[  108.040000] [<c02efaf8>] (exynos4_local_timer_setup) from [<c02efc34>] (exynos4_mct_cpu_notify+0x78/0xf0)
[  108.040000] [<c02efc34>] (exynos4_mct_cpu_notify) from [<c003d318>] (notifier_call_chain+0x44/0x84)
[  108.040000] [<c003d318>] (notifier_call_chain) from [<c001d61c>] (__cpu_notify+0x24/0x40)
[  108.040000] [<c001d61c>] (__cpu_notify) from [<c0013314>] (secondary_start_kernel+0xe4/0x134)
[  108.040000] [<c0013314>] (secondary_start_kernel) from [<40008624>] (0x40008624)

First patch fixes this problem by removing request_irq from exynos4_local_timer_setup
Second removes non-dt stuff.

Tested on linux kernel v3.14-rc2.
Comments and additions would be appreciated.
Thank you.
	Tarek.

Tarek Dakhran (2):
  clocksource: mct: remove request_irq from exynos4_local_timer_setup
  clocksource: mct: cleanup, remove non-dt stuff from mct

 arch/arm/mach-exynos/common.h    |    2 --
 drivers/clocksource/exynos_mct.c |   55 +++++++++++++++++++++-----------------
 2 files changed, 31 insertions(+), 26 deletions(-)

-- 
1.7.10.4

