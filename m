Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaGaHhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:37:17 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:38447 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbaGaHhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:37:12 -0400
Message-ID: <1406792228.6348.22.camel@marge.simpson.net>
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com
Date: Thu, 31 Jul 2014 09:37:08 +0200
In-Reply-To: <20140730142311.GJ11241@linux.vnet.ibm.com>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
	 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20140729081416.GR20603@laptop.programming.kicks-ass.net>
	 <20140729172304.GA16073@linux.vnet.ibm.com> <20140729173332.GM3935@laptop>
	 <20140729180656.GY11241@linux.vnet.ibm.com>
	 <1406726619.5889.17.camel@marge.simpson.net>
	 <20140730142311.GJ11241@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 07:23 -0700, Paul E. McKenney wrote:

> So the delta accounting is much of the pain.  Hmmm...

(overhead picture was incomplete, just fixing that...) 

executive summary:
nohz_full=NA cpu=3      604.2 KHz  1.000
nohz_full=3, cpu=3      303.5 KHz   .502
nohz_full=3, cpu=2      460.4 KHz   .761

boring details:
    nohz_full=NA, pipe-test cpu=3           nohz_full=3, pipe-test cpu=3               nohz_full=3, pipe-test cpu=2
    10.45%   __schedule                     8.74%   native_sched_clock                 9.22%   __schedule
    10.03%   system_call                    5.63%   __schedule                         5.29%   system_call
     4.86%   _raw_spin_lock_irqsave         4.75%   _raw_spin_lock                     4.79%   context_tracking_user_exit
     4.51%   __switch_to                    4.35%   reschedule_interrupt               3.81%   _raw_spin_lock_irqsave
     4.31%   copy_user_generic_string       3.91%   _raw_spin_unlock_irqrestore        3.57%   __switch_to
     3.50%   pipe_read                      3.35%   system_call                        3.45%   copy_user_generic_string
     3.02%   pipe_write                     2.73%   context_tracking_user_exit         2.90%   context_tracking_user_enter
     2.76%   mutex_lock                     2.30%   _raw_spin_lock_irqsave             2.86%   pipe_read
     2.30%   native_sched_clock             2.08%   context_tracking_user_enter        2.33%   mutex_lock
     2.27%   copy_page_to_iter_iovec        1.94%   __switch_to                        2.14%   pipe_write
     2.16%   mutex_unlock                   1.88%   copy_user_generic_string           1.89%   copy_page_to_iter_iovec
     2.15%   _raw_spin_unlock_irqrestore    1.80%   account_system_time                1.88%   tracesys
     1.86%   copy_page_from_iter_iovec      1.77%   rcu_eqs_enter_common.isra.42       1.78%   native_sched_clock
     1.85%   vfs_write                      1.60%   pipe_read                          1.70%   mutex_unlock
     1.67%   new_sync_read                  1.58%   pipe_write                         1.68%   _raw_spin_unlock_irqrestore
     1.61%   new_sync_write                 1.39%   mutex_lock                         1.67%   int_check_syscall_exit_work
     1.49%   vfs_read                       1.37%   enqueue_task_fair                  1.54%   __context_tracking_task_switch
     1.47%   fsnotify                       1.25%   rcu_eqs_exit_common.isra.43        1.39%   copy_page_from_iter_iovec
     1.43%   __fget_light                   1.14%   get_vtime_delta                    1.38%   new_sync_read
     1.36%   enqueue_task_fair              1.11%   flat_send_IPI_mask                 1.38%   __tick_nohz_task_switch
     1.28%   finish_task_switch             1.07%   tracesys                           1.37%   syscall_trace_leave
     1.26%   dequeue_task_fair              1.03%   dequeue_task_fair                  1.35%   vfs_write
     1.25%   __sb_start_write               1.01%   copy_page_to_iter_iovec            1.34%   new_sync_write
     1.22%   _raw_spin_lock_irq             1.01%   int_check_syscall_exit_work        1.31%   int_ret_from_sys_call
     1.20%   try_to_wake_up                 0.97%   vfs_write                          1.30%   enqueue_task_fair
     1.16%   update_curr                    0.94%   __context_tracking_task_switch     1.23%   fsnotify
     1.05%   __fsnotify_parent              0.93%   mutex_unlock                       1.22%   finish_task_switch
     1.03%   pick_next_task_fair            0.88%   copy_page_from_iter_iovec          1.14%   vfs_read
     1.02%   sys_write                      0.87%   new_sync_write                     1.12%   _raw_spin_lock_irq
     1.01%   sys_read                       0.86%   __fget_light                       1.08%   dequeue_task_fair
     1.00%   __wake_up_sync_key             0.85%   __sb_start_write                   1.06%   sys_read
     0.93%   __wake_up_common               0.85%   int_ret_from_sys_call              1.04%   int_with_check
     0.92%   copy_page_to_iter              0.83%   syscall_trace_leave                1.02%   update_curr
     0.90%   check_preempt_wakeup           0.78%   new_sync_read                      0.99%   syscall_trace_enter
     0.90%   __srcu_read_lock               0.78%   account_user_time                  0.96%   __fget_light
     0.89%   put_prev_task_fair             0.76%   update_curr                        0.93%   __sb_start_write
     0.88%   copy_page_from_iter            0.74%   fsnotify                           0.89%   copy_page_to_iter
     0.82%   __sb_end_write                 0.73%   try_to_wake_up                     0.87%   try_to_wake_up
     0.76%   __percpu_counter_add           0.71%   finish_task_switch                 0.86%   check_preempt_wakeup
     0.74%   prepare_to_wait                0.70%   _raw_spin_lock_irq                 0.86%   sys_write
     0.72%   touch_atime                    0.69%   __wake_up_sync_key                 0.83%   __fsnotify_parent
     0.71%   pipe_wait                      0.69%   __tick_nohz_task_switch            0.81%   __wake_up_sync_key


