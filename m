Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab3F3H5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 03:57:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61727 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3F3H5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 03:57:40 -0400
Message-ID: <1372579056.6607.16.camel@marge.simpson.net>
Subject: sched: context tracking demolishes pipe-test
From: Mike Galbraith <bitbucket@online.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Date: Sun, 30 Jun 2013 09:57:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:+S3jt/+/4lAA502Mx3neYnYy7Zp2ZCtFNreRRwg7814
 JgkP+W4wEkZpqrZOOa7HEGh7D2/xrNYzrlQZHmE5ZWVqYzsC5a
 LG28OPpM2YMO7sdv8GixRZgs20SEQbyFQ853jSITiUQESSeZGj
 7VUVqsfvdHGjY1NcS8OhYrH76ZM3k8usmmCrcBsj9wflTj+k/R
 tgPjlj6VcXVjj0wrMh7G7c0S8V1rvAQHD3HpbGrZb26Hyc1rtK
 VgMcLKB6ox7bj1PhZYddyHsaMzry+RswmJg2dwHnyjllIsLUe5
 NhUOtQVV6PpUSbdjMdkblGk1ZOvaZ5zMfGD+QN0qDBhpyC96kx
 rCtaDQBH8ULUULLwvwbWi6cQuWL42PHXG963Db5pT8wLzpJxET
 3P9IkKfQRZsMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

taskset -c 3 pipe-test 1

                  switch-rate
3.10.0-master     426.4 KHz
3.10.0-masterx    591.8 Khz     1.387 (591=notgood, 426=omfg)

     3.10.0-master                                    3.10.0-masterx
     7.13%  [k] __schedule                            9.58%  [k] __schedule
!    6.02%  [.] __read_nocancel                       8.25%  [k] system_call
!    5.82%  [.] __write_nocancel                      5.34%  [k] _raw_spin_lock_irqsave
!    4.28%  [k] system_call                           4.26%  [k] pipe_read
!    4.13%  [k] user_exit                             3.53%  [k] copy_user_generic_string
     3.64%  [k] _raw_spin_lock_irqsave                3.52%  [k] native_sched_clock
     3.37%  [k] pipe_read                             3.43%  [k] __switch_to
     2.72%  [k] copy_user_generic_string              3.21%  [.] main
     2.60%  [.] main                                  2.96%  [k] mutex_lock
     2.59%  [k] native_sched_clock                    2.89%  [k] mutex_unlock
     2.47%  [k] __switch_to                           2.86%  [k] sched_clock_local
     2.10%  [k] mutex_unlock                          2.63%  [.] __read_nocancel
     2.08%  [k] sched_clock_local                     2.47%  [k] pipe_write
     2.05%  [k] mutex_lock                            2.37%  [k] _raw_spin_unlock_irqrestore
     1.91%  [k] pipe_write                            1.96%  [.] __write_nocancel
     1.89%  [k] user_enter                            1.62%  [k] vfs_write
     1.72%  [k] _raw_spin_unlock_irqrestore           1.54%  [k] do_sync_write
     1.51%  [k] rcu_eqs_enter_common.isra.47          1.52%  [k] fget_light
     1.41%  [k] rcu_eqs_exit_common.isra.45           1.48%  [k] fsnotify
     1.30%  [k] tracesys                              1.39%  [k] dequeue_task_fair
     1.23%  [k] fsnotify                              1.39%  [k] update_curr
     1.23%  [k] int_check_syscall_exit_worka          1.37%  [k] do_sync_read
     1.20%  [k] fget_light                            1.33%  [.] __GI___libc_write
     1.16%  [k] vfs_write                             1.29%  [k] try_to_wake_up
     1.05%  [k] syscall_trace_enter                   1.09%  [k] _raw_spin_lock_irq
     1.04%  [k] do_sync_write                         1.08%  [k] pipe_iov_copy_from_user
     1.03%  [k] context_tracking_task_switch          1.05%  [k] finish_task_switch
     0.99%  [k] update_curr                           1.04%  [k] prepare_to_wait

marge:/usr/local/src/kernel/linux-3.x.git # diff -up config.horrible config.not-as-bad
--- config.horrible     2013-06-30 08:38:47.785258079 +0200
+++ config.not-as-bad   2013-06-30 08:33:08.246761153 +0200
@@ -48,7 +48,7 @@ CONFIG_BUILDTIME_EXTABLE_SORT=y
 #
 CONFIG_INIT_ENV_ARG_LIMIT=32
 CONFIG_CROSS_COMPILE=""
-CONFIG_LOCALVERSION="-master"
+CONFIG_LOCALVERSION="-masterx"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_HAVE_KERNEL_GZIP=y
 CONFIG_HAVE_KERNEL_BZIP2=y
@@ -126,7 +126,7 @@ CONFIG_TREE_RCU=y
 CONFIG_RCU_STALL_COMMON=y
 CONFIG_CONTEXT_TRACKING=y
 CONFIG_RCU_USER_QS=y
-CONFIG_CONTEXT_TRACKING_FORCE=y
+# CONFIG_CONTEXT_TRACKING_FORCE is not set
 CONFIG_RCU_FANOUT=64
 CONFIG_RCU_FANOUT_LEAF=16
 # CONFIG_RCU_FANOUT_EXACT is not set

marge:/usr/local/src/kernel/linux-3.x.git # grep NO_HZ .config
CONFIG_NO_HZ_COMMON=y
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
# CONFIG_RCU_FAST_NO_HZ is not set


