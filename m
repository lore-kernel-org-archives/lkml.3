Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaFWTtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:49:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56112 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaFWTtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:49:51 -0400
Message-ID: <53A884DE.8090008@codeaurora.org>
Date: Mon, 23 Jun 2014 12:49:50 -0700
From: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: kernel BUG at kernel/smpboot.c:134
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
While stressing the CPU hotplug path, sometimes we hit the problem as shown below. Kernel is based off 3.10 and has the commit "f2530dc71cf082" already.

[57056.416774] ------------[ cut here ]------------
[57056.489232] ksoftirqd/1 (14): undefined instruction: pc=c01931e8
[57056.489245] Code: e594a000 eb085236 e15a0000 0a000000 (e7f001f2)
[57056.489259] ------------[ cut here ]------------
[57056.492840] kernel BUG at kernel/smpboot.c:134!
[57056.513236] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
[57056.519055] Modules linked in: wlan(O) mhi(O)
[57056.523394] CPU: 0 PID: 14 Comm: ksoftirqd/1 Tainted: G        W  O
3.10.0-g3677c61-00008-g180c060 #1
[57056.532595] task: f0c8b000 ti: f0e78000 task.ti: f0e78000
[57056.537991] PC is at smpboot_thread_fn+0x124/0x218
[57056.542750] LR is at smpboot_thread_fn+0x11c/0x218
[57056.547528] pc : [<c01931e8>]    lr : [<c01931e0>]    psr: 200f0013
[57056.547528] sp : f0e79f30  ip : 00000000  fp : 00000000
[57056.558983] r10: 00000001  r9 : 00000000  r8 : f0e78000
[57056.564192] r7 : 00000001  r6 : c1195758  r5 : f0e78000  r4 : f0e5fd00
[57056.570701] r3 : 00000001  r2 : f0e79f20  r1 : 00000000  r0 : 00000000

Flow of events looks like below.

ksoftirqd/2                   migration/2                 cpu_up task
----------                   --------------               ----------------

smpboot_thread_fn()
  kthread_parkme()
   complete(&self->parked)
    spin_unlock_irq()
     preempt_schedule()
     __schedule()
                              migrate_tasks(2)
  <migrate to CPU 0>
                                                           __kthread_unpark(ksoftirqd/2)
                                                            test_and_clear_bit(KTHREAD_IS_PARKED,&kthread->flags)
                                                            __kthread_bind(k,kthread->cpu,TASK_PARKED);
   schedule()
                                                            wake_up_state(k,TASK_PARKED);
   __set_current_state(TASK_PARKED);
   clear_bit(KTHREAD_IS_PARKED, &self->flags);
   __set_current_state(TASK_RUNNING);
  ...
  set_current_state(TASK_INTERRUPTIBLE);
  preempt_disable();
  ...
  BUG_ON(td->cpu != smp_processor_id())

While debugging with adding a BUG_ON() in remote_cpu_softirq_notify (for CPU_DEAD action), at a particular instance,I could confirm that the "ksoftirqd" (for the CPU which is bought down) is not in parked state (512) but in running state (0).

If the thread is not in parked state when the CPU is bought up again, then __kthread_bind() can fail making the kthread to run on a wrong CPU. Is it possible that this can happen because of the following potential race condition?

In __kthread_parkme, just after completing the parked completion, before the ksoftirqd task has been scheduled again, it can go into running state because it got woken up by the wake_up_process() from kthread_park().

Thanks,
Subbaraman

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

