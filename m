Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936957Ab3DJW3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:29:16 -0400
Received: from relay3.sgi.com ([192.48.152.1]:51375 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933050Ab3DJW3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:29:14 -0400
Date: Wed, 10 Apr 2013 17:29:11 -0500
From: Russ Anderson <rja@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Robin Holt <holt@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130410222910.GA8112@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130403193743.GB29151@sgi.com>
 <20130408155701.GB19974@gmail.com>
 <5162EC1A.4050204@zytor.com>
 <20130408165916.GA3672@sgi.com>
 <20130410111620.GB29752@gmail.com>
 <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
 <20130410152911.GA3011@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410152911.GA3011@sgi.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:29:12AM -0500, Russ Anderson wrote:
> On Wed, Apr 10, 2013 at 08:10:05AM -0700, Linus Torvalds wrote:
> > 
> > Yeah, we've had issues with ACPI in the past, so I do think we should
> > always reboot using the BP. Even if it almost certainly works on 99+%
> > of all machines on any random CPU.
> > 
> > The optimal solution would be to just speed up the
> > disable_nonboot_cpus() code so much that it isn't an issue. That would
> > be good for suspending too, although I guess suspend isn't a big issue
> > if you have a thousand CPU's.
> > 
> > Has anybody checked whether we could do the cpu_down() on non-boot
> > CPU's in parallel? Right now we serialize the thing completely, with
> > one single
> > 
> >     for_each_online_cpu(cpu) {
> >         ...
> > 
> > loop that does a synchrinous _cpu_down() for each CPU. No wonder it
> > takes forever. We do __stop_machine() over and over and over again:
> > the whole thing is basically O(n**2) in CPU's.
> 
> Yes, I have a test patch that replaces for_each_online_cpu(cpu)
> with a cpu bitmask in disable_nonboot_cpus().  The lower level
> routines already take a bitmask.  It allows __stop_machine() to
> be called just once.  That change reduces shutdown time on a
> 1024 cpu machine from 16 minutes 4 minutes.  Significant improvement,
> but not good enough.
> 
> The next significant bottleneck is __cpu_notify().  Tried creating
> worker threads to parallelize the shutdown, but the problem is
> __cpu_notify() is not thread safe.  Putting a lock around it
> caused all the worker threads to fight over the lock.
> 
> Note that __cpu_notify() has to be called for all cpus being
> shut down because the cpu_chain notifier call chain has cpu as a
> parameter.  The delema is that cpu_chain notifiers need to be called on
> all cpus, but cannot be done in parallel due to __cpu_notify() not being
> thread safe.  Spinning through the notifier chain sequentially for all
> cpus just takes a long time.
> 
> The real fix would be to make the &cpu_chain notifier per cpu, or at
> least thread safe, so that all the cpus being shut down could do so
> in parallel.  That is a significant change with ramifications on
> other code.
> 
> I will post a patch shortly with the cpu bitmask change.  Changing
> __cpu_notify() will take more discussion.

Here is the test patch with the cpu bitmask change.  It results
in calling __stop_machine() just once.

After making feedback changes I'll formally submit the patch.

---
 kernel/cpu.c |   94 +++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 38 deletions(-)

Index: linux/kernel/cpu.c
===================================================================
--- linux.orig/kernel/cpu.c	2013-04-10 17:16:40.084960495 -0500
+++ linux/kernel/cpu.c	2013-04-10 17:17:27.988245160 -0500
@@ -262,10 +262,11 @@ static int __ref take_cpu_down(void *_pa
 }
 
 /* Requires cpu_add_remove_lock to be held */
-static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
+static int __ref _cpu_down(const cpumask_t *cpus_to_offline, int tasks_frozen)
 {
-	int err, nr_calls = 0;
+	int cpu = 0, err = 0, nr_calls = 0;
 	void *hcpu = (void *)(long)cpu;
+	cpumask_var_t cpus_offlined;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
 		.mod = mod,
@@ -278,46 +279,65 @@ static int __ref _cpu_down(unsigned int
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
+	if (!alloc_cpumask_var(&cpus_offlined, GFP_KERNEL))
+		return -ENOMEM;
+
 	cpu_hotplug_begin();
+	cpumask_clear(cpus_offlined);
+	cpumask_copy(cpus_offlined, cpus_to_offline);
 
-	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
-	if (err) {
-		nr_calls--;
-		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
-		printk("%s: attempt to take down CPU %u failed\n",
+	for_each_cpu_mask(cpu, *cpus_to_offline) {
+		hcpu = (void *)(long)cpu;
+		if (!cpu_online(cpu))
+			continue;
+		tcd_param.hcpu = hcpu;
+		err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
+		if (err) {
+			nr_calls--;
+			__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
+			pr_err("%s: attempt to take down CPU %u failed\n",
 				__func__, cpu);
-		goto out_release;
+			goto out_release;
+		}
+		smpboot_park_threads(cpu);
 	}
-	smpboot_park_threads(cpu);
 
-	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	err = __stop_machine(take_cpu_down, &tcd_param, cpus_to_offline);
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
-		smpboot_unpark_threads(cpu);
-		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
+		for_each_cpu_mask(cpu, *cpus_to_offline) {
+			hcpu = (void *)(long)cpu;
+			smpboot_unpark_threads(cpu);
+			cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
+		}
 		goto out_release;
 	}
-	BUG_ON(cpu_online(cpu));
 
 	/*
 	 * The migration_call() CPU_DYING callback will have removed all
 	 * runnable tasks from the cpu, there's only the idle task left now
 	 * that the migration thread is done doing the stop_machine thing.
-	 *
-	 * Wait for the stop thread to go away.
 	 */
-	while (!idle_cpu(cpu))
-		cpu_relax();
+	for_each_cpu_mask(cpu, *cpus_offlined) {
+		BUG_ON(cpu_online(cpu));
 
-	/* This actually kills the CPU. */
-	__cpu_die(cpu);
-
-	/* CPU is completely dead: tell everyone.  Too late to complain. */
-	cpu_notify_nofail(CPU_DEAD | mod, hcpu);
-
-	check_for_tasks(cpu);
+		/*
+		 * Wait for the stop thread to go away.
+		 */
+		while (!idle_cpu(cpu))
+			cpu_relax();
+
+		/* This actually kills the CPU. */
+		__cpu_die(cpu);
+
+		/* CPU is completely dead: tell everyone.  Too late to complain. */
+		hcpu = (void *)(long)cpu;
+		cpu_notify_nofail(CPU_DEAD | mod, hcpu);
+		check_for_tasks(cpu);
+	}
 
 out_release:
+	free_cpumask_var(cpus_offlined);
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
@@ -327,6 +347,7 @@ out_release:
 int __ref cpu_down(unsigned int cpu)
 {
 	int err;
+	cpumask_var_t cpumask;
 
 	cpu_maps_update_begin();
 
@@ -335,7 +356,11 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	err = _cpu_down(cpu, 0);
+	if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
+		return -ENOMEM;
+	cpumask_set_cpu(cpu, cpumask);
+	err = _cpu_down(cpumask, 0);
+	free_cpumask_var(cpumask);
 
 out:
 	cpu_maps_update_done();
@@ -459,7 +484,7 @@ static cpumask_var_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, first_cpu, error = 0;
+	int first_cpu, error = 0;
 
 	cpu_maps_update_begin();
 	first_cpu = cpumask_first(cpu_online_mask);
@@ -470,18 +495,11 @@ int disable_nonboot_cpus(void)
 	cpumask_clear(frozen_cpus);
 
 	printk("Disabling non-boot CPUs ...\n");
-	for_each_online_cpu(cpu) {
-		if (cpu == first_cpu)
-			continue;
-		error = _cpu_down(cpu, 1);
-		if (!error)
-			cpumask_set_cpu(cpu, frozen_cpus);
-		else {
-			printk(KERN_ERR "Error taking CPU%d down: %d\n",
-				cpu, error);
-			break;
-		}
-	}
+	cpumask_copy(frozen_cpus, cpu_online_mask);
+	cpumask_clear_cpu(first_cpu, frozen_cpus);	/* all but one cpu*/
+	error = _cpu_down(frozen_cpus, 1);
+	if (error)
+		pr_err("Error %d stopping cpus\n", error);
 
 	if (!error) {
 		BUG_ON(num_online_cpus() > 1);
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
