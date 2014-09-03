Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaICVHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:07:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:55266 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaICVHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:07:10 -0400
Message-ID: <540782F7.7030603@windriver.com>
Date: Wed, 3 Sep 2014 15:07:03 -0600
From: Chris Friesen <chris.friesen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [tracing]  trying to make sense of trace output, can't figure out
 where time is going
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.117.28]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running a 3.4 kernel on both a host and a guest running in kvm.
Within the guest cyclictest reported a 500usec outage.

On the host during that time I see the following trace:

     kvm-23696   4.N..2.. 507584568us : rcu_utilization: Start context switch
     kvm-23696   4.N..2.. 507584568us : rcu_utilization: End context switch
     kvm-23696   4dN..3.. 507584569us : sched_stat_runtime: comm=kvm pid=23696 runtime=2080 [ns] vruntime=87039278696560 [ns]
     kvm-23696   4d...3.. 507584569us : kvm_fpu: unload
     kvm-23696   4d...3.. 507584570us : sched_switch: prev_comm=kvm prev_pid=23696 prev_prio=120 prev_state=R+ ==> next_comm=ksoftirqd/4 next_pid=80 next_prio=98
ksoftirq-80      4....111 507584570us!: softirq_entry: vec=1 [action=TIMER]
ksoftirq-80      4d...411 507585038us : sched_stat_runtime: comm=crond pid=29655 runtime=1153132 [ns] vruntime=2146330791534 [ns]
ksoftirq-80      4d...411 507585038us : sched_stat_sleep: comm=rcu_preempt pid=12 delay=1458586 [ns]
ksoftirq-80      4d...411 507585039us : sched_wakeup: comm=rcu_preempt pid=12 prio=120 success=1 target_cpu=000
ksoftirq-80      4....111 507585040us : softirq_exit: vec=1 [action=TIMER]
ksoftirq-80      4....111 507585040us : softirq_entry: vec=9 [action=RCU]
ksoftirq-80      4....111 507585040us : rcu_utilization: Start RCU core
ksoftirq-80      4....111 507585041us : rcu_utilization: End RCU core
ksoftirq-80      4....111 507585041us : softirq_exit: vec=9 [action=RCU]
ksoftirq-80      4....2.. 507585041us : rcu_utilization: Start context switch
ksoftirq-80      4....2.. 507585041us : rcu_utilization: End context switch
ksoftirq-80      4....2.. 507585042us : rcu_utilization: Start context switch
ksoftirq-80      4....2.. 507585042us : rcu_utilization: End context switch
ksoftirq-80      4d...3.. 507585042us : sched_stat_wait: comm=kvm pid=23696 delay=474437 [ns]
ksoftirq-80      4d...3.. 507585043us+: sched_switch: prev_comm=ksoftirqd/4 prev_pid=80 prev_prio=98 prev_state=S ==> next_comm=kvm next_pid=23696 next_prio=120
     kvm-23696   4d...2.. 507585044us : rcu_utilization: Start context switch
     kvm-23696   4d...2.. 507585044us : rcu_utilization: End context switch
     kvm-23696   4d...2.. 507585044us : kvm_entry: vcpu 1
     kvm-23696   4d...2.. 507585045us : kvm_exit: vcpu 1 reason MSR_WRITE rip 0xffffffff81026e08 info 0 0


I'm trying to figure out what would cause that jump between the first
two ksoftirqd logs.

Some stuff in /proc/cmdline that might be relevent (it's a bit of a mishmash,
I know):

intel_iommu=off isolcpus=1-15 rcu_nocbs=1-15 irqaffinity=0
intel_idle.max_cstate=0 processor.max_cstate=1 idle=poll


In the BIOS we've disabled speedstep, CPU C states, and NMI on
error.

Is there a different tracer that would give more insight?  The irqs-off or
preemption-off tracers perhaps?

Please CC me as I'm not subscribed to the list.

Thanks,
Chris Friesen
