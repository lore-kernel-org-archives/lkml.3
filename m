Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3H2OEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:04:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:10157 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab3H2OEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:04:37 -0400
From: Libin <huawei.libin@huawei.com>
To: <akpm@linux-foundation.org>, <tj@kernel.org>, <viro@zeniv.linux.org.uk>,
        <eparis@redhat.com>, <tglx@linutronix.de>, <rusty@rustcorp.com.au>,
        <ebiederm@xmission.com>, <paulmck@linux.vnet.ibm.com>,
        <john.stultz@linaro.org>, <mingo@redhat.com>, <peterz@infradead.org>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <jovi.zhangwei@huawei.com>, <guohanjun@huawei.com>,
        <zhangdianfang@huawei.com>, <wangyijing@huawei.com>,
        <huawei.libin@huawei.com>
Subject: [PATCH 00/14] Fix bug about invalid wake up problem
Date: Thu, 29 Aug 2013 21:57:35 +0800
Message-ID: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1)Problem Description:
The prototype of invalid wakeup problem is as follows:
========================================================================
----------------------------
Consumer Thread
----------------------------
...
if (list_empty(&list)){
	//location a 
	set_current_state(TASK_INTERRUPTIBLE);
	schedule();
}
...
----------------------------
Producer Thread
----------------------------
...
list_add_tail(&item, &list);
wake_up_process(A);
...
========================================================================

Invalid wakeup problem occurs in preemptable kernel environment. The list
is empty initially, if consumer is preempted after condition validated at
location a, and at this time producer is woken up, adding a node to the
list and calling wake_up_process to wake up consumer. After that when
consumer being scheduled by scheduler, it calls set_current_state to set
itself as state TASK_INTERRUPTIBLE, and calling schedule() to request
scheduled. After consumer being scheduled out, it has no condition to be
woken up, and causing invalid wakeup problem.

In most cases, the kernel codes use a form similar to the following:
--------------------------------------------
 ...
 //location a
 ...
 set_current_state(TASK_INTERRUPTIBLE);
 //location b
 while (list_empty(&product_list)){
	schedule();	//location c
	set_current_state(TASK_INTERRUPTIBLE);
	//location d
}
__set_current_state(TASK_RUNNING);
...
--------------------------------------------
At location a, consumer is preempted, and producer is scheduled,
adding item to product_list and waking up consumer. After consumer is
re-scheduled, calling set_current_state to set itself as state
TASK_INTERRUPTIBLE, if it is preempted again before __set_current_state(TASK_RUNNING),
also trigger the invalid wakeup problem that the consumer will not be scheduled
and the item be added by producer can't be consumed.

The following circumstance will also trigger this issue:
At location c, consumer is scheduled out, and be preempted after calling
set_current_state(TASK_INTERRUPTIBLE) when it be re-schdeuled.

2)Test:
I have written a test module to trigger the problem by adding some
synchronization condition. I will post it in the form of an attachment soon.

Test result as follows:
[103135.332683] wakeup_test: create two kernel threads - producer & consumer
[103135.332686] wakeup_test: module loaded successfully
[103135.332692] wakeup_test: kthread producer try to wake up the kthread consumer
[103165.299865] wakeup_test: kthread consumer have waited for 30s, indicating
trigger an invalid wakeup problem!

3)Solution:
Using preempt_disable() to bound the operaion that setting the task state
and the conditions(set by the wake thread) validation.

----------------------------------------------
...
preempt_disable();
set_current_state(TASK_INTERRUPTIBLE);
while (list_empty(&product_list)){
	preempt_enable();
	schedule();
	preempt_disable();
	set_current_state(TASK_INTERRUPTIBLE);
}
__set_current_state(TASK_RUNNING);
preempt_enable();
...
----------------------------------------------
And it also can be solved as follows:
----------------------------------------------
...
preempt_disable();
while (list_empty(&product_list)){
	set_current_state(TASK_INTERRUPTIBLE);
	preempt_enable();
	schedule();
	preempt_disable();	
}
preempt_enable();
...
----------------------------------------------

Libin (14):
  kthread: Fix invalid wakeup in kthreadd
  audit: Fix invalid wakeup in kauditd_thread
  audit: Fix invalid wakeup in wait_for_auditd
  exit: Fix invalid wakeup in do_wait
  hrtimer: Fix invalid wakeup in do_nanosleep
  irq: Fix invalid wakeup in irq_wait_for_interrupt
  module: Fix invalid wakeup in wait_for_zero_refcount
  namespace: Fix invalid wakeup in zap_pid_ns_processes
  rcutree: Fix invalid wakeup in rcu_wait
  time: Fix invalid wakeup in alarmtimer_do_nsleep
  trace: Fix invalid wakeup in wait_to_die
  trace: Fix invalid wakeup in ring_buffer_consumer_thread
  workqueue: Fix invalid wakeup in rescuer_thread
  klist: Fix invalid wakeup in klist_remove

 kernel/audit.c                       | 11 ++++-
 kernel/exit.c                        |  7 ++-
 kernel/hrtimer.c                     |  7 ++-
 kernel/irq/manage.c                  |  5 ++
 kernel/kthread.c                     |  7 ++-
 kernel/module.c                      |  6 ++-
 kernel/pid_namespace.c               |  4 ++
 kernel/rcutree.h                     |  4 ++
 kernel/time/alarmtimer.c             |  7 ++-
 kernel/trace/ring_buffer_benchmark.c | 14 ++++++
 kernel/workqueue.c                   | 92 +++++++++++++++++++-----------------
 lib/klist.c                          |  4 ++
 12 files changed, 118 insertions(+), 50 deletions(-)

-- 
1.8.2.1


