Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaDHQgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:36:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:11298 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932078AbaDHQgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:36:42 -0400
Date: Tue, 8 Apr 2014 12:36:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [for-next][PATCH 14/14] tracing: Get trace_array ref counts
 when accessing trace files
Message-ID: <20140408123638.7f340dd5@gandalf.local.home>
In-Reply-To: <53401A3E.2090302@oracle.com>
References: <20130702202216.623562799@goodmis.org>
	<20130702202427.455930200@goodmis.org>
	<53401A3E.2090302@oracle.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Apr 2014 10:59:10 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> On 07/02/2013 04:22 PM, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > When a trace file is opened that may access a trace array, it must
> > increment its ref count to prevent it from being deleted.
> > 
> > Cc: stable@vger.kernel.org # 3.10
> > Reported-by: Alexander Lam <azl@google.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Hi Steven,
> 
> This patch seems to cause the following lockdep warning:
> 
> [ 5644.288019] ======================================================
> [ 5644.288771] [ INFO: possible circular locking dependency detected ]
> [ 5644.289657] 3.14.0-next-20140403-sasha-00019-g7474aa9-dirty #376 Not tainted
> [ 5644.290568] -------------------------------------------------------
> [ 5644.290783] trinity-c17/19105 is trying to acquire lock:
> [ 5644.290783] (trace_types_lock){+.+.+.}, at: trace_array_get (kernel/trace/trace.c:225)
> [ 5644.290783]
> [ 5644.290783] but task is already holding lock:
> [ 5644.290783] (&sig->cred_guard_mutex){+.+.+.}, at: prepare_bprm_creds (fs/exec.c:1165)
> [ 5644.290783]
> [ 5644.290783] which lock already depends on the new lock.
> [ 5644.290783]
> [ 5644.290783]
> [ 5644.290783] the existing dependency chain (in reverse order) is:
> [ 5644.290783]
> -> #2 (&sig->cred_guard_mutex){+.+.+.}:
> [ 5644.290783] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
> [ 5644.290783] mutex_lock_interruptible_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:616)
> [ 5644.290783] proc_pid_attr_write (fs/proc/base.c:2250)
> [ 5644.290783] __kernel_write (fs/read_write.c:457)
> [ 5644.290783] write_pipe_buf (fs/splice.c:1072)
> [ 5644.290783] splice_from_pipe_feed (fs/splice.c:834)
> [ 5644.290783] __splice_from_pipe (fs/splice.c:955)
> [ 5644.290783] splice_from_pipe (fs/splice.c:990)
> [ 5644.290783] default_file_splice_write (fs/splice.c:1084)
> [ 5644.290783] SyS_splice (include/linux/fs.h:2333 fs/splice.c:1391 fs/splice.c:1764 fs/splice.c:1749)
> [ 5644.290783] tracesys (arch/x86/kernel/entry_64.S:749)
> [ 5644.290783]
> -> #1 (&pipe->mutex/1){+.+.+.}:
> [ 5644.290783] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
> [ 5644.290783] mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
> [ 5644.290783] pipe_lock_nested (fs/pipe.c:61)
> [ 5644.290783] pipe_lock (fs/pipe.c:69)
> [ 5644.290783] splice_to_pipe (include/linux/wait.h:103 fs/splice.c:247)
> [ 5644.290783] tracing_buffers_splice_read (kernel/trace/trace.c:5423)
> [ 5644.290783] do_splice_to (fs/splice.c:1151)
> [ 5644.290783] SyS_splice (fs/splice.c:1416 fs/splice.c:1764 fs/splice.c:1749)
> [ 5644.290783] ia32_sysret (arch/x86/ia32/ia32entry.S:430)
> [ 5644.290783]
> -> #0 (trace_types_lock){+.+.+.}:
> [ 5644.290783] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
> [ 5644.290783] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
> [ 5644.290783] mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
> [ 5644.290783] trace_array_get (kernel/trace/trace.c:225)
> [ 5644.290783] tracing_open_generic_tr (kernel/trace/trace.c:3053)
> [ 5644.290783] do_dentry_open (fs/open.c:753)
> [ 5644.290783] finish_open (fs/open.c:818)
> [ 5644.290783] do_last (fs/namei.c:3040)
> [ 5644.290783] path_openat (fs/namei.c:3182)
> [ 5644.290783] do_filp_open (fs/namei.c:3231)
> [ 5644.290783] do_open_exec (fs/exec.c:766)
> [ 5644.290783] do_execve_common.isra.19 (fs/exec.c:1491)
> [ 5644.290783] compat_SyS_execve (fs/exec.c:1627)
> [ 5644.290783] ia32_ptregs_common (arch/x86/ia32/ia32entry.S:495)
> [ 5644.290783]
> [ 5644.290783] other info that might help us debug this:
> [ 5644.290783]
> [ 5644.290783] Chain exists of:
> trace_types_lock --> &pipe->mutex/1 --> &sig->cred_guard_mutex
> 
> [ 5644.290783]  Possible unsafe locking scenario:
> [ 5644.290783]
> [ 5644.290783]        CPU0                    CPU1
> [ 5644.290783]        ----                    ----
> [ 5644.290783]   lock(&sig->cred_guard_mutex);
> [ 5644.290783]                                lock(&pipe->mutex/1);
> [ 5644.290783]                                lock(&sig->cred_guard_mutex);
> [ 5644.290783]   lock(trace_types_lock);
> [ 5644.290783]
> [ 5644.290783]  *** DEADLOCK ***
> [ 5644.290783]
> [ 5644.290783] 1 lock held by trinity-c17/19105:
> [ 5644.290783] #0: (&sig->cred_guard_mutex){+.+.+.}, at: prepare_bprm_creds (fs/exec.c:1165)
> [ 5644.290783]
> [ 5644.290783] stack backtrace:
> [ 5644.290783] CPU: 10 PID: 19105 Comm: trinity-c17 Not tainted 3.14.0-next-20140403-sasha-00019-g7474aa9-dirty #376
> [ 5644.290783]  ffffffffb4a1a1e0 ffff88071a7738f8 ffffffffb14bfb2f 0000000000000000
> [ 5644.290783]  ffffffffb49a9dd0 ffff88071a773948 ffffffffb14b2527 0000000000000001
> [ 5644.290783]  ffff88071a7739d8 ffff88071a773948 ffff8805d98cbcf0 ffff8805d98cbd28
> [ 5644.290783] Call Trace:
> [ 5644.290783] dump_stack (lib/dump_stack.c:52)
> [ 5644.290783] print_circular_bug (kernel/locking/lockdep.c:1214)
> [ 5644.290783] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
> [ 5644.290783] ? _raw_spin_unlock_irqrestore (arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
> [ 5644.290783] ? preempt_count_sub (kernel/sched/core.c:2527)
> [ 5644.290783] ? __slab_free (mm/slub.c:2598)
> [ 5644.290783] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
> [ 5644.290783] ? trace_array_get (kernel/trace/trace.c:225)
> [ 5644.290783] mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
> [ 5644.290783] ? trace_array_get (kernel/trace/trace.c:225)
> [ 5644.290783] ? locks_free_lock (fs/locks.c:244)
> [ 5644.290783] ? trace_array_get (kernel/trace/trace.c:225)
> [ 5644.290783] ? preempt_count_sub (kernel/sched/core.c:2527)
> [ 5644.290783] trace_array_get (kernel/trace/trace.c:225)
> [ 5644.290783] tracing_open_generic_tr (kernel/trace/trace.c:3053)
> [ 5644.290783] do_dentry_open (fs/open.c:753)
> [ 5644.290783] ? tracing_open_pipe (kernel/trace/trace.c:3047)
> [ 5644.290783] finish_open (fs/open.c:818)
> [ 5644.290783] do_last (fs/namei.c:3040)
> [ 5644.290783] ? link_path_walk (fs/namei.c:1473 fs/namei.c:1744)
> [ 5644.290783] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [ 5644.290783] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
> [ 5644.290783] path_openat (fs/namei.c:3182)
> [ 5644.290783] ? __lock_acquire (kernel/locking/lockdep.c:3189)
> [ 5644.290783] do_filp_open (fs/namei.c:3231)
> [ 5644.290783] ? put_lock_stats.isra.12 (arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
> [ 5644.290783] ? do_execve_common.isra.19 (fs/exec.c:1489)
> [ 5644.290783] ? get_parent_ip (kernel/sched/core.c:2472)
> [ 5644.290783] do_open_exec (fs/exec.c:766)
> [ 5644.290783] do_execve_common.isra.19 (fs/exec.c:1491)
> [ 5644.290783] ? do_execve_common.isra.19 (include/linux/spinlock.h:303 fs/exec.c:1258 fs/exec.c:1486)
> [ 5644.290783] compat_SyS_execve (fs/exec.c:1627)
> [ 5644.290783] ia32_ptregs_common (arch/x86/ia32/ia32entry.S:495)
> 

Wait a minute! The syscall is a compat_SyS_execve, which does an
do_execve_common, which does a do_open_exec, which ends up opening a
tracing file????

How the hell did that happen. Is your tool execing files in the tracing
directory? I wonder if that's even possible, and if so, how can we
prevent that? The trace_pipe file (which is what uses the
tracing_open_pipe) is set to rrr. No exec should be allowed.

-- Steve
