Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaG3OXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:23:22 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52807 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaG3OXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:23:20 -0400
Date: Wed, 30 Jul 2014 07:23:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140730142311.GJ11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140729081416.GR20603@laptop.programming.kicks-ass.net>
 <20140729172304.GA16073@linux.vnet.ibm.com>
 <20140729173332.GM3935@laptop>
 <20140729180656.GY11241@linux.vnet.ibm.com>
 <1406726619.5889.17.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406726619.5889.17.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073014-0928-0000-0000-000003C378C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 03:23:39PM +0200, Mike Galbraith wrote:
> On Tue, 2014-07-29 at 11:06 -0700, Paul E. McKenney wrote: 
> > On Tue, Jul 29, 2014 at 07:33:32PM +0200, Peter Zijlstra wrote:
> 
> > > FWIW its _the_ thing that makes nohz_full uninteresting for me. The
> > > required overhead is insane. But yes there are people willing to pay
> > > that etc..
> > 
> > It would indeed be good to reduce the overhead.  I could imagine all sorts
> > of insane approaches involving assuming that CPU write buffers flush in
> > bounded time, though CPU vendors seem unwilling to make guarantees in
> > this area.  ;-)
> > 
> > Or is something other than rcu_user_enter() and rcu_user_exit() causing
> > the pain here?
> 
> Border guards stamping visas.  Note native_sched_clock().

Thank you for running this!

So the delta accounting is much of the pain.  Hmmm...

							Thanx, Paul

> echo 0 > sched_wakeup_granularity_ns
> taskset -c 3 pipe-test 1
> 
>     CONFIG_NO_HZ_FULL=y 604.2 KHz           CONFIG_NO_HZ_FULL=y, nohz_full=3 303.5 KHz
>     10.45%   __schedule                     8.74%   native_sched_clock
>     10.03%   system_call                    5.63%   __schedule
>      4.86%   _raw_spin_lock_irqsave         4.75%   _raw_spin_lock
>      4.51%   __switch_to                    4.35%   reschedule_interrupt
>      4.31%   copy_user_generic_string       3.91%   _raw_spin_unlock_irqrestore
>      3.50%   pipe_read                      3.35%   system_call
>      3.02%   pipe_write                     2.73%   context_tracking_user_exit
>      2.76%   mutex_lock                     2.30%   _raw_spin_lock_irqsave
>      2.30%   native_sched_clock             2.08%   context_tracking_user_enter
>      2.27%   copy_page_to_iter_iovec        1.94%   __switch_to
>      2.16%   mutex_unlock                   1.88%   copy_user_generic_string
>      2.15%   _raw_spin_unlock_irqrestore    1.80%   account_system_time
>      1.86%   copy_page_from_iter_iovec      1.77%   rcu_eqs_enter_common.isra.42
>      1.85%   vfs_write                      1.60%   pipe_read
>      1.67%   new_sync_read                  1.58%   pipe_write
>      1.61%   new_sync_write                 1.39%   mutex_lock
>      1.49%   vfs_read                       1.37%   enqueue_task_fair
>      1.47%   fsnotify                       1.25%   rcu_eqs_exit_common.isra.43
>      1.43%   __fget_light                   1.14%   get_vtime_delta
>      1.36%   enqueue_task_fair              1.11%   flat_send_IPI_mask
>      1.28%   finish_task_switch             1.07%   tracesys
>      1.26%   dequeue_task_fair              1.03%   dequeue_task_fair
>      1.25%   __sb_start_write               1.01%   copy_page_to_iter_iovec
>      1.22%   _raw_spin_lock_irq             1.01%   int_check_syscall_exit_work
>      1.20%   try_to_wake_up                 0.97%   vfs_write
>      1.16%   update_curr                    0.94%   __context_tracking_task_switch
>      1.05%   __fsnotify_parent              0.93%   mutex_unlock
>      1.03%   pick_next_task_fair            0.88%   copy_page_from_iter_iovec
>      1.02%   sys_write                      0.87%   new_sync_write
>      1.01%   sys_read                       0.86%   __fget_light
>      1.00%   __wake_up_sync_key             0.85%   __sb_start_write
>      0.93%   __wake_up_common               0.85%   int_ret_from_sys_call
>      0.92%   copy_page_to_iter              0.83%   syscall_trace_leave
>      0.90%   check_preempt_wakeup           0.78%   new_sync_read
>      0.90%   __srcu_read_lock               0.78%   account_user_time
>      0.89%   put_prev_task_fair             0.76%   update_curr
>      0.88%   copy_page_from_iter            0.74%   fsnotify
>      0.82%   __sb_end_write                 0.73%   try_to_wake_up
>      0.76%   __percpu_counter_add           0.71%   finish_task_switch
>      0.74%   prepare_to_wait                0.70%   _raw_spin_lock_irq
>      0.72%   touch_atime                    0.69%   __wake_up_sync_key
>      0.71%   pipe_wait                      0.69%   __tick_nohz_task_switch
> 
> pinned endless stat("/", &buf)
> 
>     CONFIG_NO_HZ_FULL=y                     CONFIG_NO_HZ_FULL=y, nohz_full=3
>     17.13%   system_call                    8.78%   system_call
>     11.20%   kmem_cache_alloc               8.52%   native_sched_clock
>      7.14%   lockref_get_not_dead           6.02%   context_tracking_user_exit
>      7.10%   kmem_cache_free                4.53%   kmem_cache_alloc
>      6.42%   path_init                      4.46%   _raw_spin_lock
>      5.69%   copy_user_generic_string       4.13%   copy_user_generic_string
>      5.25%   lockref_put_or_lock            4.01%   kmem_cache_free
>      4.14%   strncpy_from_user              3.36%   context_tracking_user_enter
>      3.99%   path_lookupat                  3.25%   lockref_get_not_dead
>      3.12%   complete_walk                  3.25%   lockref_put_or_lock
>      2.91%   getname_flags                  2.86%   rcu_eqs_enter_common.isra.42
>      2.88%   cp_new_stat                    2.84%   path_init
>      2.79%   vfs_fstatat                    2.56%   rcu_eqs_exit_common.isra.43
>      2.59%   user_path_at_empty             2.52%   int_check_syscall_exit_work
>      1.93%   link_path_walk                 2.51%   tracesys
>      1.81%   generic_fillattr               2.08%   cp_new_stat
>      1.75%   dput                           2.00%   syscall_trace_leave
>      1.71%   filename_lookup.isra.50        1.75%   complete_walk
>      1.66%   mntput                         1.69%   path_lookupat
>      1.45%   vfs_getattr_nosec              1.58%   strncpy_from_user
>      1.04%   final_putname                  1.56%   get_vtime_delta
>      1.02%   SYSC_newstat                   1.34%   int_with_check
> 
>      CONFIG_NO_HZ_FULL=y, nohz_full=3
> -    8.53%  [kernel]         [k] native_sched_clock                                                                                                                                                                                        ▒
>    - native_sched_clock                                                                                                                                                                                                                    ▒
>       - 96.76% local_clock                                                                                                                                                                                                                 ▒
>          - get_vtime_delta                                                                                                                                                                                                                 ▒
>             - 51.95% vtime_account_user                                                                                                                                                                                                    ▒
>                  99.96% context_tracking_user_exit                                                                                                                                                                                         ▒
>                     syscall_trace_enter                                                                                                                                                                                                    ▒
>                     tracesys                                                                                                                                                                                                               ▒
>                     __xstat64                                                                                                                                                                                                              ▒
>                     __libc_start_main                                                                                                                                                                                                      ▒
>             - 48.05% __vtime_account_system                                                                                                                                                                                                ▒
>                  99.96% vtime_user_enter                                                                                                                                                                                                   ▒
>                     context_tracking_user_enter                                                                                                                                                                                            ▒
>                     syscall_trace_leave                                                                                                                                                                                                    ◆
>                     int_check_syscall_exit_work                                                                                                                                                                                            ▒
>                     __xstat64                                                                                                                                                                                                              ▒
>                     __libc_start_main                                                                                                                                                                                                      ▒
>       - 3.23% get_vtime_delta                                                                                                                                                                                                              ▒
>            52.96% vtime_account_user                                                                                                                                                                                                       ▒
>               context_tracking_user_exit                                                                                                                                                                                                   ▒
>               syscall_trace_enter                                                                                                                                                                                                          ▒
>               tracesys                                                                                                                                                                                                                     ▒
>               __xstat64                                                                                                                                                                                                                    ▒
>               __libc_start_main                                                                                                                                                                                                            ▒
>            47.04% __vtime_account_system                                                                                                                                                                                                   ▒
>               vtime_user_enter                                                                                                                                                                                                             ▒
>               context_tracking_user_enter                                                                                                                                                                                                  ▒
>               syscall_trace_leave                                                                                                                                                                                                          ▒
>               int_check_syscall_exit_work                                                                                                                                                                                                  ▒
>               __xstat64                                                                                                                                                                                                                    ▒
>               __libc_start_main
> 

