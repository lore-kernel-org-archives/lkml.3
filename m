Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967656Ab3DSAKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 20:10:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:9034 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967484Ab3DSAKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 20:10:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,505,1363158000"; 
   d="scan'208";a="297220948"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "eag0628@gmail.com" <eag0628@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: WARNING: at kernel/smp.c:385 smp_call_function_many
Thread-Topic: WARNING: at kernel/smp.c:385 smp_call_function_many
Thread-Index: AQHOPHilasbxK9YNfEakUewl3z8ciJjcqkvg
Date: Fri, 19 Apr 2013 00:10:31 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4AC1B56C@SHSMSX101.ccr.corp.intel.com>
References: <5170602E.3050206@oracle.com>
In-Reply-To: <5170602E.3050206@oracle.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

> -----Original Message-----
> From: Sasha Levin [mailto:sasha.levin@oracle.com]
> Sent: Friday, April 19, 2013 5:06 AM
> To: Liu, Chuansheng; Andrew Morton
> Cc: Ingo Molnar; Thomas Gleixner; Peter Zijlstra; Wu, Fengguang;
> eag0628@gmail.com; Dave Jones; linux-kernel@vger.kernel.org
> Subject: WARNING: at kernel/smp.c:385 smp_call_function_many
> 
> Hi guys,
> 
> It seems that with commit "smp: Give WARN()ing when calling
> smp_call_function_many()/single() in serving irq" I'm getting a bunch of these:
This patch gives the warning even when the smp_call_function_many() is called in softirq context,
because it will bring the possible deadlock cases, the example is below:
CPUA                            CPUB
                                spin_lock(&spinlock)
                                Any irq coming, call the irq handler
                                irq_exit()
spin_lock_irq(&spinlock)
<== Blocking here due to
CPUB hold it
                                  __do_softirq()
                                    run_timer_softirq()
                                      timer_cb()
                                        call smp_call_function_many()
                                          send IPI interrupt to CPUA
                                            wait_csd()

Then both CPUA and CPUB will be deadlocked here.
> 
> [  467.250851] WARNING: at kernel/smp.c:385
> smp_call_function_many+0xda/0x400()
> [  467.251990] Modules linked in:
> [  467.252496] CPU: 1 PID: 12638 Comm: trinity-child1 Tainted: G        W
> 3.9.0-rc7-next-20130418-sasha-00013-g333a5d2 #340
> [  467.259691]  0000000000000009 ffff8800bb603d98 ffffffff83deed7a
> ffff8800bb603dd8
> [  467.261157]  ffffffff81112ecb ffff88009d229fd8 ffffffff81148430
> 0000000000000001
> [  467.262478]  ffffffff861922e0 0000000000000008 ffffffff861922e0
> ffff8800bb603de8
> [  467.263758] Call Trace:
> [  467.266447]  <IRQ>  [<ffffffff83deed7a>] dump_stack+0x19/0x1b
> [  467.267437]  [<ffffffff81112ecb>] warn_slowpath_common+0x6b/0xa0
> [  467.268418]  [<ffffffff81148430>] ? hrtimer_wakeup+0x30/0x30
> [  467.269838]  [<ffffffff81112f15>] warn_slowpath_null+0x15/0x20
> [  467.270844]  [<ffffffff81197b8a>] smp_call_function_many+0xda/0x400
> [  467.272287]  [<ffffffff8115c055>] ? sched_clock_local+0x25/0xa0
> [  467.273259]  [<ffffffff81148430>] ? hrtimer_wakeup+0x30/0x30
> [  467.274590]  [<ffffffff81148430>] ? hrtimer_wakeup+0x30/0x30
> [  467.275519]  [<ffffffff81198001>] smp_call_function+0x41/0x80
> [  467.276801]  [<ffffffff81148430>] ? hrtimer_wakeup+0x30/0x30
> [  467.277756]  [<ffffffff81198099>] on_each_cpu+0x39/0x110
> [  467.278604]  [<ffffffff81149197>] clock_was_set+0x17/0x20
> [  467.280198]  [<ffffffff81149bb2>] run_hrtimer_softirq+0x32/0x40
> [  467.281530]  [<ffffffff8111cb07>] __do_softirq+0x1d7/0x460
> [  467.282434]  [<ffffffff8111cf26>] irq_exit+0x76/0xd0
> [  467.283243]  [<ffffffff8109287a>] smp_apic_timer_interrupt+0x8a/0xa0
> [  467.284707]  [<ffffffff83e369f2>] apic_timer_interrupt+0x72/0x80
> [  467.285674]  <EOI>  [<ffffffff81071ef5>] ? sched_clock+0x15/0x20
> [  467.287132]  [<ffffffff83e31dd6>] ? add_preempt_count+0xa6/0xc0
> [  467.288089]  [<ffffffff81a1db2c>] delay_tsc+0xac/0x120
> [  467.289342]  [<ffffffff8127cbd8>] ?
> __mem_cgroup_count_vm_event+0x178/0x1a0
> [  467.290522]  [<ffffffff81a1da19>] __const_udelay+0x29/0x30
> [  467.291425]  [<ffffffff8113ee14>] __rcu_read_unlock+0x44/0xb0
> [  467.292829]  [<ffffffff8127cbf5>]
> __mem_cgroup_count_vm_event+0x195/0x1a0
> [  467.293994]  [<ffffffff8127ca60>] ? mem_cgroup_from_task+0xd0/0xd0
> [  467.295456]  [<ffffffff81240e82>] handle_mm_fault+0x632/0x660
> [  467.296692]  [<ffffffff8118b40a>] ? __lock_is_held+0x5a/0x80
> [  467.297647]  [<ffffffff83e318f0>] __do_page_fault+0x570/0x5e0
> [  467.298622]  [<ffffffff811d3e2d>] ? rcu_try_advance_all_cbs+0x3d/0xb0
> [  467.300213]  [<ffffffff811d3f1d>] ? rcu_eqs_exit_common+0x7d/0x260
> [  467.301241]  [<ffffffff811d4e0e>] ? rcu_eqs_enter_common+0x33e/0x3b0
> [  467.302760]  [<ffffffff811d419c>] ? rcu_eqs_exit+0x9c/0xb0
> [  467.303649]  [<ffffffff83e31992>] do_page_fault+0x32/0x50
> [  467.304526]  [<ffffffff83e30f60>] do_async_page_fault+0x30/0xc0
> [  467.306556]  [<ffffffff83e2e228>] async_page_fault+0x28/0x30
> 
> So either the new commit is broken, or hrtimer is horribly broken?
> 
> 
> Thanks,
> Sasha
