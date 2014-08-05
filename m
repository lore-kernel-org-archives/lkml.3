Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaHEVdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:33:23 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:45703 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaHEVdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140805141049.GD5593@localhost>
References: <20140805141049.GD5593@localhost>
Date: Tue, 5 Aug 2014 17:33:20 -0400
Message-ID: <CAPDOMVgd0y66hFZBPMaQ2MX6pNQP5ZQ7g1uHBY0=VEXCwwRwXw@mail.gmail.com>
Subject: Re: [pktgen_thread_worker] WARNING: CPU: 0 PID: 89 at
 kernel/sched/core.c:7094 __might_sleep()
From: Nick Krause <xerofoify@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 10:10 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> Here is a pktgen error triggered by this debug check.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git sched/wait
> commit 64c2181bc433b17f04da8fe8592aa83cceac9606
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Mon Aug 4 11:14:16 2014 +0200
> Commit:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> CommitDate: Mon Aug 4 13:29:59 2014 +0200
>
>     sched: Debug nested sleeps
>
>     Validate we call might_sleep() with TASK_RUNNING, which catches places
>     where we nest blocking primitives, eg. mutex usage in a wait loop.
>
>     Since all blocking is arranged through task_struct::state, nesting
>     this is going to cause two distinct issues:
>
>      - the inner primitive will set TASK_RUNNING and the outer will not
>        block
>
>      - the outer sets !TASK_RUNNING and the inner expects to be called
>        with TASK_RUNNING and blocks forever (mutex_lock).
>
>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>     Link: http://lkml.kernel.org/n/tip-0hge361rozfbng4z2t64t217@git.kernel.org
>
> [    1.604869] gre: GRE over IPv4 demultiplexor driver
> [    1.606178] ip_gre: GRE over IPv4 tunneling driver
> [    1.608031] ------------[ cut here ]------------
> [    1.609370] WARNING: CPU: 0 PID: 89 at kernel/sched/core.c:7094 __might_sleep+0x6f/0x1f8()
> [    1.611875] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff8153f80c>] pktgen_thread_worker.part.36+0x5/0x769
> [    1.618496] tcp_probe: probe registered (port=0/fwmark=0) bufsize=4096
> [    1.620291] Modules linked in:
> [    1.621568] CPU: 0 PID: 89 Comm: kpktgend_0 Not tainted 3.16.0-00053-g64c2181 #1
> [    1.624084] TCP: bic registered
> [    1.625297] TCP: cubic registered
> [    1.626488] TCP: westwood registered
> [    1.627749] TCP: highspeed registered
> [    1.629117] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    1.630928]  0000000000000000 ffff880013b53d48 ffffffff8153cc4f ffff880013b53d80
> [    1.633938]  ffffffff8105fa45 ffffffff810856f3 0000000000000001 0000000000000000
> [    1.636942]  ffffffff81420801 00000000000000a9 ffff880013b53de0 ffffffff8105faaa
>
> This script may reproduce the error.
>
> ----------------------------------------------------------------------------
> #!/bin/bash
>
> kernel=$1
> initrd=quantal-core-x86_64.cgz
>
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
>
> kvm=(
>         qemu-system-x86_64
>         -enable-kvm
>         -cpu Haswell,+smep,+smap
>         -kernel $kernel
>         -initrd $initrd
>         -m 320
>         -smp 2
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -rtc base=localtime
>         -serial stdio
>         -display none
>         -monitor null
> )
>
> append=(
>         hung_task_panic=1
>         earlyprintk=ttyS0,115200
>         debug
>         apic=debug
>         sysrq_always_enabled
>         rcupdate.rcu_cpu_stall_timeout=100
>         panic=10
>         softlockup_panic=1
>         nmi_watchdog=panic
>         prompt_ramdisk=0
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw
>         drbd.minor_count=8
> )
>
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
>
> Thanks,
> Fengguang
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
>

Hey guys,
I don't expect you to trust me after what the other developers are
calling me a troll.
But I can trace this to a few lines.
1, pr_debug("starting pktgen/%d:  pid=%d\n", cpu, task_pid_nr(current));

 set_current_state(TASK_INTERRUPTIBLE);

 set_freezable();
this is in the function, pktgen_thread_worker and looks somewhat suspicious.
2. I hit this lines next
167 bool set_freezable(void)
168 {
169 might_sleep();
170
171 /*
172 * Modify flags while holding freezer_lock.  This ensures the
173 * freezer notices that we aren't frozen yet or the freezing
174 * condition is visible to try_to_freeze() below.
175 */
176 spin_lock_irq(&freezer_lock);
177 current->flags &= ~PF_NOFREEZE;
178 spin_unlock_irq(&freezer_lock);
179
180 return try_to_freeze();
181 }
182 EXPORT_SYMBOL(set_freezable);
3. After tracing the call we hit this ,

void __might_sleep(const char *file, int line, int preempt_offset)
7044 {
7045 static unsigned long prev_jiffy; /* ratelimiting */
7046
7047 rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
7048 if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
7049     !is_idle_task(current)) ||
7050    system_state != SYSTEM_RUNNING || oops_in_progress)
7051 return;
7052 if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
7053 return;
7054 prev_jiffy = jiffies;
7055
7056 printk(KERN_ERR
7057 "BUG: sleeping function called from invalid context at %s:%d\n",
7058 file, line);
7059 printk(KERN_ERR
7060 "in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
7061 in_atomic(), irqs_disabled(),
7062 current->pid, current->comm);
7063
7064 debug_show_held_locks(current);
7065 if (irqs_disabled())
7066 print_irqtrace_events(current);
7067 #ifdef CONFIG_DEBUG_PREEMPT
7068 if (!preempt_count_equals(preempt_offset)) {
7069 pr_err("Preemption disabled at:");
7070 print_ip_sym(current->preempt_disable_ip);
7071 pr_cont("\n");
7072 }
7073 #endif
7074 dump_stack();

I am new so unfortunately , this is probably wrong and bad.
Nick
