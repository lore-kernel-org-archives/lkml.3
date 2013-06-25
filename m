Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3FYVFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:05:43 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34713 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3FYVFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:05:42 -0400
Message-ID: <51CA0622.8010105@gmail.com>
Date: Tue, 25 Jun 2013 15:05:38 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: deadlock in scheduler enabling HRTICK feature
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter/Ingo:

I can reliably cause a deadlock in the scheduler by enabling the HRTICK 
feature. I first hit the problem with 2.6.27 but have been able to 
reproduce it with newer kernels. I have not tried top of Linus' tree, so 
perhaps this has been fixed in 3.10. Exact backtrace differs by release, 
but the root cause is the same: the run queue is locked early in the 
schedule path and then wanted again servicing the softirq.

Using Fedora 18 and the 3.9.6-200.fc18.x86_64 kernel as an example,

[root@f18 ~]# cat /sys/kernel/debug/sched_features
GENTLE_FAIR_SLEEPERS START_DEBIT NO_NEXT_BUDDY LAST_BUDDY 
CACHE_HOT_BUDDY WAKEUP_PREEMPTION ARCH_POWER NO_HRTICK NO_DOUBLE_TICK 
LB_BIAS OWNER_SPIN NONTASK_POWER TTWU_QUEUE NO_FORCE_SD_OVERLAP 
RT_RUNTIME_SHARE NO_LB_MIN NO_NUMA NO_NUMA_FORCE

[root@f18 ~]# echo HRTICK > /sys/kernel/debug/sched_features

[root@f18 ~]# cat /sys/kernel/debug/sched_features
GENTLE_FAIR_SLEEPERS START_DEBIT NO_NEXT_BUDDY LAST_BUDDY 
CACHE_HOT_BUDDY WAKEUP_PREEMPTION ARCH_POWER HRTICK NO_DOUBLE_TICK 
LB_BIAS OWNER_SPIN NONTASK_POWER TTWU_QUEUE NO_FORCE_SD_OVERLAP 
RT_RUNTIME_SHARE NO_LB_MIN NO_NUMA NO_NUMA_FORCE

For a workload a simple kernel build suffices: 'make O=/tmp/kbuild -j 8' 
on a 4vcpu VM. Lockup occurs pretty quickly.

The relevant stack trace from the nmi watchdog:
...
[  219.467698]  <<EOE>>  [<ffffffff81093c61>] try_to_wake_up+0x1d1/0x2d0
[  219.467698]  [<ffffffff81043daf>] ? kvm_clock_read+0x1f/0x30
[  219.467698]  [<ffffffff81093dc7>] wake_up_process+0x27/0x50
[  219.467698]  [<ffffffff81066fc9>] wakeup_softirqd+0x29/0x30
[  219.467698]  [<ffffffff81067b95>] raise_softirq_irqoff+0x25/0x30
[  219.467698]  [<ffffffff810867c5>] __hrtimer_start_range_ns+0x3a5/0x400
[  219.467698]  [<ffffffff8109a089>] ? update_curr+0x99/0x170
[  219.467698]  [<ffffffff81086854>] hrtimer_start_range_ns+0x14/0x20
[  219.467698]  [<ffffffff81090bf0>] hrtick_start+0x90/0xa0
[  219.467698]  [<ffffffff810985f8>] hrtick_start_fair+0x88/0xd0
[  219.467698]  [<ffffffff81098f33>] hrtick_update+0x73/0x80
[  219.467698]  [<ffffffff8109c876>] enqueue_task_fair+0x346/0x550
[  219.467698]  [<ffffffff81090ab6>] enqueue_task+0x66/0x80
[  219.467698]  [<ffffffff81091443>] activate_task+0x23/0x30
[  219.467698]  [<ffffffff810917ac>] ttwu_do_activate.constprop.83+0x3c/0x70
[  219.467698]  [<ffffffff81093c6c>] try_to_wake_up+0x1dc/0x2d0
[  219.467698]  [<ffffffff81198898>] ? mem_cgroup_charge_common+0xa8/0x120
[  219.467698]  [<ffffffff81093d72>] default_wake_function+0x12/0x20
[  219.467698]  [<ffffffff810833fd>] autoremove_wake_function+0x1d/0x50
[  219.467698]  [<ffffffff8108b0e5>] __wake_up_common+0x55/0x90
[  219.467698]  [<ffffffff8108e973>] __wake_up_sync_key+0x53/0x80
...


You can see the nested calls to try_to_wake_up() which has called 
ttwu_queue() in both places. The trouble spot is here in ttwu_queue:
     ...
     raw_spin_lock(&rq->lock);     <---- dead lock here on second call
     ttwu_do_activate(rq, p, 0);
     raw_spin_unlock(&rq->lock);
     ...

David
