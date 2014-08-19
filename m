Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaHSAYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 20:24:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33930 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaHSAYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 20:24:11 -0400
Message-ID: <53F29925.6030303@oracle.com>
Date: Mon, 18 Aug 2014 20:24:05 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: fs: INFO: possible irq lock inversion dependency detected in kill_fasync
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:

[ 1132.334973] =========================================================
[ 1132.336095] [ INFO: possible irq lock inversion dependency detected ]
[ 1132.337056] 3.16.0-next-20140815-sasha-00034-g615561b #1071 Not tainted
[ 1132.337922] ---------------------------------------------------------
[ 1132.340751] trinity-main/8521 just changed the state of lock:
[ 1132.342015] (&(&new->fa_lock)->rlock){-.....}, at: kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] but this lock took another, HARDIRQ-unsafe lock in the past:
[ 1132.342761]  (&(&p->alloc_lock)->rlock){+.+...}

and interrupts could create inverse lock ordering between them.

[ 1132.342761]
[ 1132.342761] other info that might help us debug this:
[ 1132.342761] Chain exists of:
&(&new->fa_lock)->rlock --> &f->f_owner.lock --> &(&p->alloc_lock)->rlock
[ 1132.334973] =========================================================
[ 1132.336095] [ INFO: possible irq lock inversion dependency detected ]
[ 1132.337056] 3.16.0-next-20140815-sasha-00034-g615561b #1071 Not tainted
[ 1132.337922] ---------------------------------------------------------
[ 1132.340751] trinity-main/8521 just changed the state of lock:
[ 1132.342015] (&(&new->fa_lock)->rlock){-.....}, at: kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] but this lock took another, HARDIRQ-unsafe lock in the past:
[ 1132.342761]  (&(&p->alloc_lock)->rlock){+.+...}

and interrupts could create inverse lock ordering between them.

[ 1132.342761]
[ 1132.342761] other info that might help us debug this:
[ 1132.342761] Chain exists of:
&(&new->fa_lock)->rlock --> &f->f_owner.lock --> &(&p->alloc_lock)->rlock

[ 1132.342761]  Possible interrupt unsafe locking scenario:
[ 1132.342761]
[ 1132.342761]        CPU0                    CPU1
[ 1132.342761]        ----                    ----
[ 1132.342761]   lock(&(&p->alloc_lock)->rlock);
[ 1132.342761]                                local_irq_disable();
[ 1132.342761]                                lock(&(&new->fa_lock)->rlock);
[ 1132.342761]                                lock(&f->f_owner.lock);
[ 1132.342761]   <Interrupt>
[ 1132.342761]     lock(&(&new->fa_lock)->rlock);
[ 1132.342761]
[ 1132.342761]  *** DEADLOCK ***
[ 1132.342761]
[ 1132.342761] 1 lock held by trinity-main/8521:
[ 1132.342761] #0: (rcu_read_lock){......}, at: kill_fasync (fs/fcntl.c:731)
[ 1132.342761]
[ 1132.342761] the shortest dependencies between 2nd lock and 1st lock:
[ 1132.342761]    -> (&(&p->alloc_lock)->rlock){+.+...} ops: 737341 {
[ 1132.342761]       HARDIRQ-ON-W at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2802 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
[ 1132.342761] kthreadd (kernel/kthread.c:489)
[ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 1132.342761]       SOFTIRQ-ON-W at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
[ 1132.342761] kthreadd (kernel/kthread.c:489)
[ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 1132.342761]       INITIAL USE at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
[ 1132.342761] kthreadd (kernel/kthread.c:489)
[ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 1132.342761]     }
[ 1132.342761] ... key at: __key.51842 (??:?)
[ 1132.342761]     ... acquired at:
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1132.342761] do_prlimit (kernel/sys.c:1386)
[ 1132.342761] SyS_getrlimit (kernel/sys.c:1276 kernel/sys.c:1270)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]
[ 1132.342761]   -> (tasklist_lock){.+.+..} ops: 42693178 {
[ 1132.342761]      HARDIRQ-ON-R at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2794 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] do_wait (./arch/x86/include/asm/current.h:14 kernel/exit.c:1490)
[ 1132.342761] SyS_wait4 (kernel/exit.c:1620 kernel/exit.c:1588)
[ 1132.342761] wait_for_helper (kernel/kmod.c:310)
[ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 1132.342761]      SOFTIRQ-ON-R at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] do_wait (./arch/x86/include/asm/current.h:14 kernel/exit.c:1490)
[ 1132.342761] SyS_wait4 (kernel/exit.c:1620 kernel/exit.c:1588)
[ 1132.342761] wait_for_helper (kernel/kmod.c:310)
[ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 1132.342761]      INITIAL USE at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_write_lock_irq (include/linux/rwlock_api_smp.h:197 kernel/locking/spinlock.c:311)
[ 1132.342761] copy_process (./arch/x86/include/asm/current.h:14 kernel/fork.c:1465)
[ 1132.342761] do_fork (kernel/fork.c:1644)
[ 1132.342761] kernel_thread (kernel/fork.c:1693)
[ 1132.342761] rest_init (init/main.c:404)
[ 1132.342761] start_kernel (init/main.c:682)
[ 1132.342761] x86_64_start_reservations (arch/x86/kernel/head64.c:194)
[ 1132.342761] x86_64_start_kernel (arch/x86/kernel/head64.c:183)
[ 1132.342761]    }
[ 1132.342761] ... key at: tasklist_lock (??:?)
[ 1132.342761]    ... acquired at:
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] send_sigio (fs/fcntl.c:517)
[ 1132.342761] dnotify_handle_event (fs/notify/dnotify/dnotify.c:114)
[ 1132.342761] send_to_group (fs/notify/fsnotify.c:183)
[ 1132.342761] fsnotify (fs/notify/fsnotify.c:249)
[ 1132.342761] notify_change (fs/attr.c:272)
[ 1132.342761] chown_common (fs/open.c:581)
[ 1132.342761] SyS_fchown (fs/open.c:647 fs/open.c:634)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]
[ 1132.342761]  -> (&f->f_owner.lock){.+.+..} ops: 5967 {
[ 1132.342761]     HARDIRQ-ON-R at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2794 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]     SOFTIRQ-ON-R at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]     INITIAL USE at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]   }
[ 1132.342761] ... key at: __key.31497 (??:?)
[ 1132.342761]   ... acquired at:
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] send_sigio (fs/fcntl.c:506)
[ 1132.342761] kill_fasync (include/linux/spinlock.h:364 fs/fcntl.c:725 fs/fcntl.c:737)
[ 1132.342761] wakeup_pipe_writers (fs/splice.c:727)
[ 1132.342761] iter_file_splice_write (fs/splice.c:861 fs/splice.c:1054)
[ 1132.342761] SyS_splice (fs/splice.c:1128 fs/splice.c:1393 fs/splice.c:1701 fs/splice.c:1684)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]
[ 1132.342761] -> (&(&new->fa_lock)->rlock){-.....} ops: 4993 {
[ 1132.342761]    IN-HARDIRQ-W at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
[ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
[ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
[ 1132.342761] irq_work_run (kernel/irq_work.c:170)
[ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
[ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
[ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
[ 1132.342761] do_fork (kernel/fork.c:1671)
[ 1132.342761] SyS_clone (kernel/fork.c:1733)
[ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
[ 1132.342761]    INITIAL USE at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock_irq (include/linux/spinlock_api_smp.h:129 kernel/locking/spinlock.c:167)
[ 1132.342761] fasync_remove_entry (include/linux/spinlock.h:359 fs/fcntl.c:595)
[ 1132.342761] fasync_helper (fs/fcntl.c:698)
[ 1132.342761] sock_fasync (net/socket.c:1211 (discriminator 7))
[ 1132.342761] SyS_fcntl (fs/fcntl.c:70 fs/fcntl.c:274 fs/fcntl.c:378 fs/fcntl.c:363)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]  }
[ 1132.342761] ... key at: __key.37041 (??:?)
[ 1132.342761]  ... acquired at:
[ 1132.342761] check_usage_forwards (kernel/locking/lockdep.c:2364)
[ 1132.342761] mark_lock (kernel/locking/lockdep.c:2474 kernel/locking/lockdep.c:2922)
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
[ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
[ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
[ 1132.342761] irq_work_run (kernel/irq_work.c:170)
[ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
[ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
[ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
[ 1132.342761] do_fork (kernel/fork.c:1671)
[ 1132.342761] SyS_clone (kernel/fork.c:1733)
[ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
[ 1132.342761]
[ 1132.342761]
[ 1132.342761] stack backtrace:
[ 1132.342761] CPU: 10 PID: 8521 Comm: trinity-main Not tainted 3.16.0-next-20140815-sasha-00034-g615561b #1071
[ 1132.342761]  ffff88071c003cb0 ffff88071c003c48 ffffffffb24a9798 ffffffffb651ed80
[ 1132.342761]  ffff88071c003c90 ffffffffaf1cb19b ffff880714273d20 ffffffffb3740742
[ 1132.342761]  ffff880714273000 ffffffffb3740742 ffff880714273d20 0000000000000002
[ 1132.342761] Call Trace:
[ 1132.342761] <IRQ> dump_stack (lib/dump_stack.c:52)
[ 1132.342761] print_irq_inversion_bug (kernel/locking/lockdep.c:2339)
[ 1132.342761] check_usage_forwards (kernel/locking/lockdep.c:2364)
[ 1132.342761] mark_lock (kernel/locking/lockdep.c:2474 kernel/locking/lockdep.c:2922)
[ 1132.342761] ? print_irq_inversion_bug (kernel/locking/lockdep.c:2349)
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
[ 1132.342761] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[ 1132.342761] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.564837] FAULT_INJECTION: forcing a failure
[ 1132.342761] ? kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 1132.342761] ? kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] ? kill_fasync (fs/fcntl.c:731)
[ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
[ 1132.342761] ? perf_event_reset (kernel/events/core.c:4337)
[ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
[ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
[ 1132.342761] irq_work_run (kernel/irq_work.c:170)
[ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
[ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
[ 1132.342761] <EOI> ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
[ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
[ 1132.342761] do_fork (kernel/fork.c:1671)
[ 1132.342761] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:184 (discriminator 2))
[ 1132.342761] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 1132.342761] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
[ 1132.342761] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
[ 1132.342761] SyS_clone (kernel/fork.c:1733)
[ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
[ 1132.342761] ? tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]  Possible interrupt unsafe locking scenario:
[ 1132.342761]
[ 1132.342761]        CPU0                    CPU1
[ 1132.342761]        ----                    ----
[ 1132.342761]   lock(&(&p->alloc_lock)->rlock);
[ 1132.342761]                                local_irq_disable();
[ 1132.342761]                                lock(&(&new->fa_lock)->rlock);
[ 1132.342761]                                lock(&f->f_owner.lock);
[ 1132.342761]   <Interrupt>
[ 1132.342761]     lock(&(&new->fa_lock)->rlock);
[ 1132.342761]
[ 1132.342761]  *** DEADLOCK ***
[ 1132.342761]
[ 1132.342761] 1 lock held by trinity-main/8521:
[ 1132.342761] #0: (rcu_read_lock){......}, at: kill_fasync (fs/fcntl.c:731)
[ 1132.342761]
[ 1132.342761] the shortest dependencies between 2nd lock and 1st lock:
[ 1132.342761]    -> (&(&p->alloc_lock)->rlock){+.+...} ops: 737341 {
[ 1132.342761]       HARDIRQ-ON-W at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2802 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
[ 1132.342761] kthreadd (kernel/kthread.c:489)
[ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 1132.342761]       SOFTIRQ-ON-W at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
[ 1132.342761] kthreadd (kernel/kthread.c:489)
[ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 1132.342761]       INITIAL USE at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
[ 1132.342761] kthreadd (kernel/kthread.c:489)
[ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 1132.342761]     }
[ 1132.342761] ... key at: __key.51842 (??:?)
[ 1132.342761]     ... acquired at:
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1132.342761] do_prlimit (kernel/sys.c:1386)
[ 1132.342761] SyS_getrlimit (kernel/sys.c:1276 kernel/sys.c:1270)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]
[ 1132.342761]   -> (tasklist_lock){.+.+..} ops: 42693178 {
[ 1132.342761]      HARDIRQ-ON-R at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2794 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] do_wait (./arch/x86/include/asm/current.h:14 kernel/exit.c:1490)
[ 1132.342761] SyS_wait4 (kernel/exit.c:1620 kernel/exit.c:1588)
[ 1132.342761] wait_for_helper (kernel/kmod.c:310)
[ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 1132.342761]      SOFTIRQ-ON-R at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] do_wait (./arch/x86/include/asm/current.h:14 kernel/exit.c:1490)
[ 1132.342761] SyS_wait4 (kernel/exit.c:1620 kernel/exit.c:1588)
[ 1132.342761] wait_for_helper (kernel/kmod.c:310)
[ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 1132.342761]      INITIAL USE at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_write_lock_irq (include/linux/rwlock_api_smp.h:197 kernel/locking/spinlock.c:311)
[ 1132.342761] copy_process (./arch/x86/include/asm/current.h:14 kernel/fork.c:1465)
[ 1132.342761] do_fork (kernel/fork.c:1644)
[ 1132.342761] kernel_thread (kernel/fork.c:1693)
[ 1132.342761] rest_init (init/main.c:404)
[ 1132.342761] start_kernel (init/main.c:682)
[ 1132.342761] x86_64_start_reservations (arch/x86/kernel/head64.c:194)
[ 1132.342761] x86_64_start_kernel (arch/x86/kernel/head64.c:183)
[ 1132.342761]    }
[ 1132.342761] ... key at: tasklist_lock (??:?)
[ 1132.342761]    ... acquired at:
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] send_sigio (fs/fcntl.c:517)
[ 1132.342761] dnotify_handle_event (fs/notify/dnotify/dnotify.c:114)
[ 1132.342761] send_to_group (fs/notify/fsnotify.c:183)
[ 1132.342761] fsnotify (fs/notify/fsnotify.c:249)
[ 1132.342761] notify_change (fs/attr.c:272)
[ 1132.342761] chown_common (fs/open.c:581)
[ 1132.342761] SyS_fchown (fs/open.c:647 fs/open.c:634)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]
[ 1132.342761]  -> (&f->f_owner.lock){.+.+..} ops: 5967 {
[ 1132.342761]     HARDIRQ-ON-R at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2794 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]     SOFTIRQ-ON-R at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]     INITIAL USE at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]   }
[ 1132.342761] ... key at: __key.31497 (??:?)
[ 1132.342761]   ... acquired at:
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
[ 1132.342761] send_sigio (fs/fcntl.c:506)
[ 1132.342761] kill_fasync (include/linux/spinlock.h:364 fs/fcntl.c:725 fs/fcntl.c:737)
[ 1132.342761] wakeup_pipe_writers (fs/splice.c:727)
[ 1132.342761] iter_file_splice_write (fs/splice.c:861 fs/splice.c:1054)
[ 1132.342761] SyS_splice (fs/splice.c:1128 fs/splice.c:1393 fs/splice.c:1701 fs/splice.c:1684)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]
[ 1132.342761] -> (&(&new->fa_lock)->rlock){-.....} ops: 4993 {
[ 1132.342761]    IN-HARDIRQ-W at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
[ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
[ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
[ 1132.342761] irq_work_run (kernel/irq_work.c:170)
[ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
[ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
[ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
[ 1132.342761] do_fork (kernel/fork.c:1671)
[ 1132.342761] SyS_clone (kernel/fork.c:1733)
[ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
[ 1132.342761]    INITIAL USE at:
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock_irq (include/linux/spinlock_api_smp.h:129 kernel/locking/spinlock.c:167)
[ 1132.342761] fasync_remove_entry (include/linux/spinlock.h:359 fs/fcntl.c:595)
[ 1132.342761] fasync_helper (fs/fcntl.c:698)
[ 1132.342761] sock_fasync (net/socket.c:1211 (discriminator 7))
[ 1132.342761] SyS_fcntl (fs/fcntl.c:70 fs/fcntl.c:274 fs/fcntl.c:378 fs/fcntl.c:363)
[ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
[ 1132.342761]  }
[ 1132.342761] ... key at: __key.37041 (??:?)
[ 1132.342761]  ... acquired at:
[ 1132.342761] check_usage_forwards (kernel/locking/lockdep.c:2364)
[ 1132.342761] mark_lock (kernel/locking/lockdep.c:2474 kernel/locking/lockdep.c:2922)
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
[ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
[ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
[ 1132.342761] irq_work_run (kernel/irq_work.c:170)
[ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
[ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
[ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
[ 1132.342761] do_fork (kernel/fork.c:1671)
[ 1132.342761] SyS_clone (kernel/fork.c:1733)
[ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
[ 1132.342761]
[ 1132.342761]
[ 1132.342761] stack backtrace:
[ 1132.342761] CPU: 10 PID: 8521 Comm: trinity-main Not tainted 3.16.0-next-20140815-sasha-00034-g615561b #1071
[ 1132.342761]  ffff88071c003cb0 ffff88071c003c48 ffffffffb24a9798 ffffffffb651ed80
[ 1132.342761]  ffff88071c003c90 ffffffffaf1cb19b ffff880714273d20 ffffffffb3740742
[ 1132.342761]  ffff880714273000 ffffffffb3740742 ffff880714273d20 0000000000000002
[ 1132.342761] Call Trace:
[ 1132.342761] <IRQ> dump_stack (lib/dump_stack.c:52)
[ 1132.342761] print_irq_inversion_bug (kernel/locking/lockdep.c:2339)
[ 1132.342761] check_usage_forwards (kernel/locking/lockdep.c:2364)
[ 1132.342761] mark_lock (kernel/locking/lockdep.c:2474 kernel/locking/lockdep.c:2922)
[ 1132.342761] ? print_irq_inversion_bug (kernel/locking/lockdep.c:2349)
[ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
[ 1132.342761] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[ 1132.342761] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
[ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
[ 1132.564837] FAULT_INJECTION: forcing a failure
[ 1132.342761] ? kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 1132.342761] ? kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
[ 1132.342761] ? kill_fasync (fs/fcntl.c:731)
[ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
[ 1132.342761] ? perf_event_reset (kernel/events/core.c:4337)
[ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
[ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
[ 1132.342761] irq_work_run (kernel/irq_work.c:170)
[ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
[ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
[ 1132.342761] <EOI> ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
[ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
[ 1132.342761] do_fork (kernel/fork.c:1671)
[ 1132.342761] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:184 (discriminator 2))
[ 1132.342761] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 1132.342761] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
[ 1132.342761] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
[ 1132.342761] SyS_clone (kernel/fork.c:1733)
[ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
[ 1132.342761] ? tracesys (arch/x86/kernel/entry_64.S:541)


Thanks,
Sash
