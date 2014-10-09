Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbaJIQx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:53:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36236 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaJIQxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:53:47 -0400
Date: Thu, 9 Oct 2014 18:53:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: [patch 04/40] cpu: Restructure FROZEN state handling
Message-ID: <20141009165336.GA15050@pd.tnic>
References: <20130131120348.372374706@linutronix.de>
 <20130131120741.751984627@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130131120741.751984627@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:11:15PM -0000, Thomas Gleixner wrote:
> There are only a few callbacks which really care about FROZEN
> vs. !FROZEN. No need to have extra states for this. 
> 
> Publish the frozen state in an extra variable which is updated under
> the hotplug lock and let the users interested deal with it w/o
> imposing that extra state checks on everyone.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/cpu.c |   66 ++++++++++++++++++++++++-----------------------------------
>  1 file changed, 27 insertions(+), 39 deletions(-)

So, I'm looking through this and trying to apply the patches ontop of
current kernel. Here's this one quilt-refreshed ontop of 3.17.

---

>From linux-kernel-owner@vger.kernel.org Thu Jan 31 13:13:23 2013
Message-Id: <20130131120741.751984627@linutronix.de>
User-Agent: quilt/0.48-1
Date:	Thu, 31 Jan 2013 12:11:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Rusty Russell <rusty@rustcorp.com.au>, Paul McKenney
 <paulmck@linux.vnet.ibm.com>, "Srivatsa S. Bhat"
 <srivatsa.bhat@linux.vnet.ibm.com>, Arjan van de Veen <arjan@infradead.org>,
 Paul Turner <pjt@google.com>, Richard Weinberger <rw@linutronix.de>, Magnus
 Damm <magnus.damm@gmail.com>
Subject: [patch 04/40] cpu: Restructure FROZEN state handling
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Status: RO

There are only a few callbacks which really care about FROZEN
vs. !FROZEN. No need to have extra states for this. 

Publish the frozen state in an extra variable which is updated under
the hotplug lock and let the users interested deal with it w/o
imposing that extra state checks on everyone.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/cpu.c |   66 ++++++++++++++++++++++++-----------------------------------
 1 file changed, 27 insertions(+), 39 deletions(-)

Index: linux/kernel/cpu.c
===================================================================
--- linux.orig/kernel/cpu.c	2014-10-09 18:40:30.991799290 +0200
+++ linux/kernel/cpu.c	2014-10-09 18:42:46.823798395 +0200
@@ -27,6 +27,7 @@
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
 static DEFINE_MUTEX(cpu_add_remove_lock);
+static bool cpuhp_tasks_frozen;
 
 /*
  * The following two APIs (cpu_maps_update_begin/done) must be used when
@@ -194,27 +195,30 @@ int __ref __register_cpu_notifier(struct
 	return raw_notifier_chain_register(&cpu_chain, nb);
 }
 
-static int __cpu_notify(unsigned long val, void *v, int nr_to_call,
+static int __cpu_notify(unsigned long val, unsigned int cpu, int nr_to_call,
 			int *nr_calls)
 {
+	unsigned long mod = cpuhp_tasks_frozen ? CPU_TASKS_FROZEN : 0;
+	void *hcpu = (void *)(long)cpu;
+
 	int ret;
 
-	ret = __raw_notifier_call_chain(&cpu_chain, val, v, nr_to_call,
+	ret = __raw_notifier_call_chain(&cpu_chain, val | mod, hcpu, nr_to_call,
 					nr_calls);
 
 	return notifier_to_errno(ret);
 }
 
-static int cpu_notify(unsigned long val, void *v)
+static int cpu_notify(unsigned long val, unsigned int cpu)
 {
-	return __cpu_notify(val, v, -1, NULL);
+	return __cpu_notify(val, cpu, -1, NULL);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static void cpu_notify_nofail(unsigned long val, void *v)
+static void cpu_notify_nofail(unsigned long val, unsigned int cpu)
 {
-	BUG_ON(cpu_notify(val, v));
+	BUG_ON(cpu_notify(val, cpu));
 }
 EXPORT_SYMBOL(register_cpu_notifier);
 EXPORT_SYMBOL(__register_cpu_notifier);
@@ -298,23 +302,17 @@ static inline void check_for_tasks(int d
 	read_unlock_irq(&tasklist_lock);
 }
 
-struct take_cpu_down_param {
-	unsigned long mod;
-	void *hcpu;
-};
-
 /* Take this CPU down. */
 static int __ref take_cpu_down(void *_param)
 {
-	struct take_cpu_down_param *param = _param;
-	int err;
+	int err, cpu = smp_processor_id();
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0)
 		return err;
 
-	cpu_notify(CPU_DYING | param->mod, param->hcpu);
+	cpu_notify(CPU_DYING, cpu);
 	/* Park the stopper thread */
 	kthread_park(current);
 	return 0;
@@ -324,12 +322,6 @@ static int __ref take_cpu_down(void *_pa
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
-	void *hcpu = (void *)(long)cpu;
-	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
-	struct take_cpu_down_param tcd_param = {
-		.mod = mod,
-		.hcpu = hcpu,
-	};
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -339,10 +331,12 @@ static int __ref _cpu_down(unsigned int
 
 	cpu_hotplug_begin();
 
-	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
+	cpuhp_tasks_frozen = tasks_frozen;
+
+	err = __cpu_notify(CPU_DOWN_PREPARE, cpu, -1, &nr_calls);
 	if (err) {
 		nr_calls--;
-		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
+		__cpu_notify(CPU_DOWN_FAILED, cpu, nr_calls, NULL);
 		pr_warn("%s: attempt to take down CPU %u failed\n",
 			__func__, cpu);
 		goto out_release;
@@ -369,11 +363,11 @@ static int __ref _cpu_down(unsigned int
 	 * So now all preempt/rcu users must observe !cpu_active().
 	 */
 
-	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	err = __stop_machine(take_cpu_down, NULL, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		smpboot_unpark_threads(cpu);
-		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
+		cpu_notify_nofail(CPU_DOWN_FAILED, cpu);
 		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
@@ -392,14 +386,14 @@ static int __ref _cpu_down(unsigned int
 	__cpu_die(cpu);
 
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
-	cpu_notify_nofail(CPU_DEAD | mod, hcpu);
+	cpu_notify_nofail(CPU_DEAD, cpu);
 
 	check_for_tasks(cpu);
 
 out_release:
 	cpu_hotplug_done();
 	if (!err)
-		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
+		cpu_notify_nofail(CPU_POST_DEAD, cpu);
 	return err;
 }
 
@@ -426,10 +420,8 @@ EXPORT_SYMBOL(cpu_down);
 /* Requires cpu_add_remove_lock to be held */
 static int _cpu_up(unsigned int cpu, int tasks_frozen)
 {
-	int ret, nr_calls = 0;
-	void *hcpu = (void *)(long)cpu;
-	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct task_struct *idle;
+	int ret, nr_calls = 0;
 
 	cpu_hotplug_begin();
 
@@ -448,7 +440,9 @@ static int _cpu_up(unsigned int cpu, int
 	if (ret)
 		goto out;
 
-	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
+	cpuhp_tasks_frozen = tasks_frozen;
+
+	ret = __cpu_notify(CPU_UP_PREPARE, cpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
 		pr_warn("%s: attempt to bring up CPU %u failed\n",
@@ -466,11 +460,11 @@ static int _cpu_up(unsigned int cpu, int
 	smpboot_unpark_threads(cpu);
 
 	/* Now call notifier in preparation. */
-	cpu_notify(CPU_ONLINE | mod, hcpu);
+	cpu_notify(CPU_ONLINE, cpu);
 
 out_notify:
 	if (ret != 0)
-		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
+		__cpu_notify(CPU_UP_CANCELED, cpu, nr_calls, NULL);
 out:
 	cpu_hotplug_done();
 
@@ -657,13 +651,7 @@ core_initcall(cpu_hotplug_pm_sync_init);
  */
 void notify_cpu_starting(unsigned int cpu)
 {
-	unsigned long val = CPU_STARTING;
-
-#ifdef CONFIG_PM_SLEEP_SMP
-	if (frozen_cpus != NULL && cpumask_test_cpu(cpu, frozen_cpus))
-		val = CPU_STARTING_FROZEN;
-#endif /* CONFIG_PM_SLEEP_SMP */
-	cpu_notify(val, (void *)(long)cpu);
+	cpu_notify(CPU_STARTING, cpu);
 }
 
 #endif /* CONFIG_SMP */

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
