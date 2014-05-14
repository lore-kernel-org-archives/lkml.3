Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaENJmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:42:44 -0400
Received: from forward5m.mail.yandex.net ([37.140.138.5]:35975 "EHLO
	forward5m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaENJmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:42:38 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Sasha Levin <sasha.levin@oracle.com>,
        Michael wang <wangyun@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "ktkhai@parallels.com" <ktkhai@parallels.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <53711785.5010504@oracle.com>
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com> <53080122.609@linux.vnet.ibm.com> <530ABB44.5000601@oracle.com> <530AD653.3000808@linux.vnet.ibm.com> <20140224071028.GW9987@twins.programming.kicks-ass.net> <530B1B80.4000307@linux.vnet.ibm.com> <20140224121218.GR15586@twins.programming.kicks-ass.net> <534610A4.5000302@oracle.com> <53464164.5030701@linux.vnet.ibm.com> <336561397137116@web27h.yandex.ru> <5347FCED.8040706@oracle.com> <1442521397229373@web20m.yandex.ru> <53711785.5010504@oracle.com>
Subject: Re: sched: hang in migrate_swap
MIME-Version: 1.0
Message-Id: <2614131400060552@web30m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 14 May 2014 13:42:32 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12.05.2014, 22:49, "Sasha Levin" <sasha.levin@oracle.com>:
> On 04/11/2014 11:16 AM, Kirill Tkhai wrote:
>
>> š11.04.2014, 18:33, "Sasha Levin" <sasha.levin@oracle.com>:
>>>> šOn 04/10/2014 09:38 AM, Kirill Tkhai wrote:
>>>>>> šš10.04.2014, 11:00, "Michael wang" <wangyun@linux.vnet.ibm.com>:
>>>>>>>>>> ššOn 04/10/2014 11:31 AM, Sasha Levin wrote:
>>>>>>>>>> šš[snip]
>>>>>>>>>>>>>> šššI'd like to re-open this issue. It seems that something broke and I'm
>>>>>>>>>>>>>> šššnow seeing the same issues that have gone away 2 months with this patch
>>>>>>>>>>>>>> šššagain.
>>>>>>>>>> ššA new mechanism has been designed to move the priority checking inside
>>>>>>>>>> ššidle_balance(), including Kirill who is the designer ;-)
>>>>>> ššNot sure, it's connected with my patch. But looks like, we forgot
>>>>>> ššexactly stop class. Maybe this will help?
>>>>>>
>>>>>> šš[PATCH] sched: Checking for stop task appearance when balancing happens
>>>>>>
>>>>>> ššJust do it, like we do for other higher priority classes...
>>>>>>
>>>>>> ššSigned-off-by: Kirill Tkhai <tkhai@yandex.ru>
>>>> šI've been running with this patch for the last two days and the hang
>>>> šseems to be gone.
>>>>
>>>> šI'll leave it running on the weekend and will update again on Monday.
>> šThanks for testing.
>>
>> šSorry for I killed your linuxes by this lost need_resched().
>
> So I'm going to revive this thread again:

Sadly, kernel parameter "softlockup_panic" prevents stack dumping on other cpus..

Just as an idea.

Peter, do we have to queue stop works orderly?

Is there is not a possibility, when two pair of works queued different on
different cpus?


 kernel/stop_machine.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index b6b67ec..29e221b 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -250,8 +250,14 @@ struct irq_cpu_stop_queue_work_info {
 static void irq_cpu_stop_queue_work(void *arg)
 {
 	struct irq_cpu_stop_queue_work_info *info = arg;
-	cpu_stop_queue_work(info->cpu1, info->work1);
-	cpu_stop_queue_work(info->cpu2, info->work2);
+
+	if (info->cpu1 < info->cpu2) {
+		cpu_stop_queue_work(info->cpu1, info->work1);
+		cpu_stop_queue_work(info->cpu2, info->work2);
+	} else {
+		cpu_stop_queue_work(info->cpu2, info->work2);
+		cpu_stop_queue_work(info->cpu1, info->work1);
+	}
 }
 
 /**


> [ 3912.086567] NMI watchdog: BUG: soft lockup - CPU#4 stuck for 22s! [migration/4:194]
> [ 3912.089060] Modules linked in:
> [ 3912.090438] irq event stamp: 585772
> [ 3912.090605] hardirqs last enabled at (585771): restore_args (arch/x86/kernel/entry_64.S:1033)
> [ 3912.090605] hardirqs last disabled at (585772): trace_apic_timer_interrupt (arch/x86/kernel/entry_64.S:1225)
> [ 3912.090605] softirqs last enabled at (585770): __do_softirq (arch/x86/include/asm/preempt.h:22 kernel/softirq.c:296)
> [ 3912.090605] softirqs last disabled at (585763): irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
> [ 3912.090605] CPU: 4 PID: 194 Comm: migration/4 Tainted: G šššššššW šššš3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
> [ 3912.090605] task: ffff8801445a8000 ti: ffff880144596000 task.ti: ffff880144596000
> [ 3912.090605] RIP: multi_cpu_stop (kernel/stop_machine.c:210)
> [ 3912.090605] RSP: 0000:ffff880144597cc8 šEFLAGS: 00000293
> [ 3912.090605] RAX: 0000000000000001 RBX: ffffffffa458d3fb RCX: 0000000000000034
> [ 3912.090605] RDX: ffff8801445a8000 RSI: 0000000000000034 RDI: 0000000020000000
> [ 3912.090605] RBP: ffff880144597d08 R08: 0000000000000001 R09: 0000000000000000
> [ 3912.090605] R10: ffffffffa4638060 R11: 0000000000000001 R12: ffff880144597c38
> [ 3912.090605] R13: 0000000000000001 R14: ffff880144596000 R15: ffff8801445a8000
> [ 3912.090605] FS: š0000000000000000(0000) GS:ffff880144c00000(0000) knlGS:0000000000000000
> [ 3912.090605] CS: š0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 3912.090605] CR2: 000000000258aff8 CR3: 000000002602c000 CR4: 00000000000006a0
> [ 3912.090605] DR0: 00000000006df000 DR1: 00000000006df000 DR2: 0000000000000000
> [ 3912.090605] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [ 3912.090605] Stack:
> [ 3912.090605] šffff880144597ce8 0000000000000286 ffff880144597ce8 ffff88015666fa40
> [ 3912.090605] šffff880144dd0a00 ffff88015666fa18 ffffffffa1227180 ffff880144dd0a50
> [ 3912.090605] šffff880144597dd8 ffffffffa1226e42 ffff880144597d28 ffffffffa11c4aae
> [ 3912.090605] Call Trace:
> [ 3912.090605] ? queue_stop_cpus_work (kernel/stop_machine.c:171)
> [ 3912.090605] cpu_stopper_thread (kernel/stop_machine.c:498)
> [ 3912.090605] ? put_lock_stats.isra.12 (arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
> [ 3912.090605] ? _raw_spin_unlock_irqrestore (arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
> [ 3912.090605] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [ 3912.090605] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
> [ 3912.090605] smpboot_thread_fn (kernel/smpboot.c:160)
> [ 3912.090605] ? __smpboot_create_thread (kernel/smpboot.c:105)
> [ 3912.090605] kthread (kernel/kthread.c:210)
> [ 3912.090605] ? complete (kernel/sched/completion.c:35)
> [ 3912.090605] ? kthread_create_on_node (kernel/kthread.c:176)
> [ 3912.090605] ret_from_fork (arch/x86/kernel/entry_64.S:553)
> [ 3912.090605] ? kthread_create_on_node (kernel/kthread.c:176)
> [ 3912.090605] Code: 09 06 0f 1f 80 00 00 00 00 4d 0f a3 65 00 45 19 e4 45 85 e4 41 0f 95 c6 e8 bc 10 90 00 41 89 c4 45 31 ed 31 c0 0f 1f 40 00 f3 90 <45> 84 f6 75 11 44 8b 7b 20 41 39 c7 75 20 eb 67 66 0f 1f 44 00
> [ 3912.090605] Kernel panic - not syncing: softlockup: hung tasks
> [ 3912.090605] CPU: 4 PID: 194 Comm: migration/4 Tainted: G šššššššW šššš3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
> [ 3912.090605] šffff8801445a8000 ffff880144c03dd8 ffffffffa453e1ec 0000000000000001
> [ 3912.090605] šffffffffa56e9ed0 ffff880144c03e58 ffffffffa452fd6a 0000000000000001
> [ 3912.090605] š0000000000000008 ffff880144c03e68 ffff880144c03e08 0000000000000001
> [ 3912.090605] Call Trace:
> [ 3912.090605] <IRQ> dump_stack (lib/dump_stack.c:52)
> [ 3912.090605] panic (kernel/panic.c:119)
> [ 3912.090605] ? _raw_spin_unlock_irqrestore (include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
> [ 3912.090605] watchdog_timer_fn (kernel/watchdog.c:372)
> [ 3912.090605] __run_hrtimer (kernel/hrtimer.c:1268 (discriminator 2))
> [ 3912.090605] ? queue_stop_cpus_work (include/linux/cpumask.h:108 include/linux/cpumask.h:174 kernel/stop_machine.c:375)
> [ 3912.090605] ? watchdog (kernel/hung_task.c:191 kernel/hung_task.c:232)
> [ 3912.090605] hrtimer_interrupt (kernel/hrtimer.c:1915)
> [ 3912.090605] ? queue_stop_cpus_work (include/linux/cpumask.h:108 include/linux/cpumask.h:174 kernel/stop_machine.c:375)
> [ 3912.090605] ? queue_stop_cpus_work (include/linux/cpumask.h:108 include/linux/cpumask.h:174 kernel/stop_machine.c:375)
> [ 3912.090605] local_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:921)
> [ 3912.090605] smp_trace_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:964 include/linux/jump_label.h:105 arch/x86/include/asm/trace/irq_vectors.h:45 arch/x86/kernel/apic/apic.c:965)
> [ 3912.090605] trace_apic_timer_interrupt (arch/x86/kernel/entry_64.S:1225)
> [ 3912.090605] <EOI> ? retint_restore_args (arch/x86/kernel/entry_64.S:1033)
> [ 3912.090605] ? multi_cpu_stop (kernel/stop_machine.c:210)
> [ 3912.090605] ? multi_cpu_stop (include/linux/bitmap.h:280 include/linux/cpumask.h:461 kernel/stop_machine.c:189)
> [ 3912.090605] ? queue_stop_cpus_work (kernel/stop_machine.c:171)
> [ 3912.090605] cpu_stopper_thread (kernel/stop_machine.c:498)
> [ 3912.090605] ? put_lock_stats.isra.12 (arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
> [ 3912.090605] ? _raw_spin_unlock_irqrestore (arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
> [ 3912.090605] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [ 3912.090605] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
> [ 3912.090605] smpboot_thread_fn (kernel/smpboot.c:160)
> [ 3912.090605] ? __smpboot_create_thread (kernel/smpboot.c:105)
> [ 3912.090605] kthread (kernel/kthread.c:210)
> [ 3912.090605] ? complete (kernel/sched/completion.c:35)
> [ 3912.090605] ? kthread_create_on_node (kernel/kthread.c:176)
> [ 3912.090605] ret_from_fork (arch/x86/kernel/entry_64.S:553)
> [ 3912.090605] ? kthread_create_on_node (kernel/kthread.c:176)
> [ 3912.090605] Dumping ftrace buffer:
> [ 3912.090605] ššš(ftrace buffer empty)
>
> Nothing else is printed past this point.
>
> Thanks,
> Sasha
