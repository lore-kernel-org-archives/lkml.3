Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3KLMjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:39:46 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:46506 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3KLMjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:39:41 -0500
Date: Tue, 12 Nov 2013 13:39:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86/smpboot: Make the code more consistent
Message-ID: <20131112123937.GA13057@gmail.com>
References: <20131111170558.GA12741@gmail.com>
 <CAE9FiQWrzZB+wpSXGeQTPKi2o7MKvONFkk0_POe-E+wco07Erw@mail.gmail.com>
 <20131112103422.GA12849@pd.tnic>
 <20131112112338.GA12801@gmail.com>
 <20131112113208.GC12849@pd.tnic>
 <20131112113710.GA12998@gmail.com>
 <20131112115230.GD12849@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112115230.GD12849@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Tue, Nov 12, 2013 at 12:37:10PM +0100, Ingo Molnar wrote:
> > Hm, I think it's actually a bonus that we see the individual CPUs
> > printed as they boot up. That way if there's a hang, the place where
> > it hangs is apparent, etc.
> 
> Ok, good point.
> 
> We can do something like that then:
> 
> [    0.068574] x86: Booting SMP configuration:
> [    0.069006] .... node  #1, CPUs:      #1
> [    0.147005] .... node  #0, CPUs:   #2 #3
> [    0.147005] .... node  #1, CPUs:   #4 #5
> [    0.445273] x86: Booted up 2 nodes, 6 CPUs
> 
> and report (node, core) in the order they appear.

Btw., while looking at the code I found various pieces of hard to read 
code, with inconsistent coding principles all across the spectrum.

Mind applying the attached cleanup patch first, before doing fixes to the 
printout? No change in functionality. Mildly tested.

Thanks,

	Ingo

================>
>From 844f1ed31746c27d7476602b56342c12131016cc Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Tue, 12 Nov 2013 13:36:38 +0100
Subject: [PATCH] x86/smpboot: Make the code more consistent

Over the last decade the smpboot.c code has become a disjunct set of
often conflicting, inconsistent style elements, making it harder to
read.

Unify the variable namings, simplify code, clean up comments, to
make it all more hackable.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c | 402 +++++++++++++++++++++-------------------------
 1 file changed, 179 insertions(+), 223 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2a16558..12863e1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1,4 +1,4 @@
- /*
+/*
  *	x86 SMP booting functions
  *
  *	(c) 1995 Alan Cox, Building #3 <alan@lxorguk.ukuu.org.uk>
@@ -31,11 +31,11 @@
  *		Tigran Aivazian	:	fixed "0.00 in /proc/uptime on SMP" bug.
  *	Maciej W. Rozycki	:	Bits for genuine 82489DX APICs
  *	Andi Kleen		:	Changed for SMP boot into long mode.
- *		Martin J. Bligh	: 	Added support for multi-quad systems
+ *		Martin J. Bligh	:	Added support for multi-quad systems
  *		Dave Jones	:	Report invalid combinations of Athlon CPUs.
  *		Rusty Russell	:	Hacked into shape for new "hotplug" boot process.
  *      Andi Kleen              :       Converted to new state machine.
- *	Ashok Raj		: 	CPU hotplug support
+ *	Ashok Raj		:	CPU hotplug support
  *	Glauber Costa		:	i386 and x86_64 integration
  */
 
@@ -78,8 +78,8 @@
 #include <asm/realmode.h>
 #include <asm/misc.h>
 
-/* State of each CPU */
-DEFINE_PER_CPU(int, cpu_state) = { 0 };
+/* State of each CPU: */
+DEFINE_PER_CPU(int, cpu_state);
 
 #ifdef CONFIG_HOTPLUG_CPU
 /*
@@ -125,6 +125,9 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
+static int cpu0_logical_apicid;
+static int enable_start_cpu0;
+
 /*
  * Report back to the Boot Processor during boot time or to the caller processor
  * during CPU online.
@@ -150,10 +153,9 @@ static void smp_callin(void)
 	 * (This works even if the APIC is not enabled.)
 	 */
 	phys_id = read_apic_id();
-	if (cpumask_test_cpu(cpuid, cpu_callin_mask)) {
-		panic("%s: phys CPU#%d, CPU#%d already present??\n", __func__,
-					phys_id, cpuid);
-	}
+	if (cpumask_test_cpu(cpuid, cpu_callin_mask))
+		panic("%s: phys CPU#%d, CPU#%d already present??\n", __func__, phys_id, cpuid);
+
 	pr_debug("CPU#%d (phys ID: %d) waiting for CALLOUT\n", cpuid, phys_id);
 
 	/*
@@ -177,13 +179,11 @@ static void smp_callin(void)
 		cpu_relax();
 	}
 
-	if (!time_before(jiffies, timeout)) {
-		panic("%s: CPU%d started up but did not get a callout!\n",
-		      __func__, cpuid);
-	}
+	if (!time_before(jiffies, timeout))
+		panic("%s: CPU%d started up but did not get a callout!\n", __func__, cpuid);
 
 	/*
-	 * the boot CPU has finished the init stage and is spinning
+	 * The boot CPU has finished the init stage and is spinning
 	 * on callin_map until we finish. We are free to set up this
 	 * CPU, first the APIC. (this is probably redundant on most
 	 * boards)
@@ -195,9 +195,7 @@ static void smp_callin(void)
 	setup_local_APIC();
 	end_local_APIC_setup();
 
-	/*
-	 * Need to setup vector mappings before we enable interrupts.
-	 */
+	/* Need to setup vector mappings before we enable interrupts. */
 	setup_vector_irq(smp_processor_id());
 
 	/*
@@ -225,14 +223,10 @@ static void smp_callin(void)
 
 	notify_cpu_starting(cpuid);
 
-	/*
-	 * Allow the master to continue.
-	 */
+	/* Allow the boot CPU to continue: */
 	cpumask_set_cpu(cpuid, cpu_callin_mask);
 }
 
-static int cpu0_logical_apicid;
-static int enable_start_cpu0;
 /*
  * Activate a secondary processor.
  */
@@ -274,10 +268,10 @@ static void notrace start_secondary(void *unused)
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	x86_platform.nmi_init();
 
-	/* enable local interrupts */
+	/* Enable local interrupts */
 	local_irq_enable();
 
-	/* to prevent fake stack check failure in clock setup */
+	/* Prevent fake stack check failure in clock setup */
 	boot_init_stack_canary();
 
 	x86_cpuinit.setup_percpu_clockev();
@@ -289,10 +283,10 @@ static void notrace start_secondary(void *unused)
 void __init smp_store_boot_cpu_info(void)
 {
 	int id = 0; /* CPU 0 */
-	struct cpuinfo_x86 *c = &cpu_data(id);
+	struct cpuinfo_x86 *c_this = &cpu_data(id);
 
-	*c = boot_cpu_data;
-	c->cpu_index = id;
+	*c_this = boot_cpu_data;
+	c_this->cpu_index = id;
 }
 
 /*
@@ -301,100 +295,106 @@ void __init smp_store_boot_cpu_info(void)
  */
 void smp_store_cpu_info(int id)
 {
-	struct cpuinfo_x86 *c = &cpu_data(id);
+	struct cpuinfo_x86 *c_this = &cpu_data(id);
 
-	*c = boot_cpu_data;
-	c->cpu_index = id;
+	*c_this = boot_cpu_data;
+	c_this->cpu_index = id;
 	/*
 	 * During boot time, CPU0 has this setup already. Save the info when
 	 * bringing up AP or offlined CPU0.
 	 */
-	identify_secondary_cpu(c);
+	identify_secondary_cpu(c_this);
 }
 
 static bool
-topology_sane(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o, const char *name)
+topology_sane(struct cpuinfo_x86 *c_this, struct cpuinfo_x86 *c_sibling, const char *name)
 {
-	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
+	int cpu_this = c_this->cpu_index, cpu_sibling = c_sibling->cpu_index;
 
-	return !WARN_ONCE(cpu_to_node(cpu1) != cpu_to_node(cpu2),
-		"sched: CPU #%d's %s-sibling CPU #%d is not on the same node! "
-		"[node: %d != %d]. Ignoring dependency.\n",
-		cpu1, name, cpu2, cpu_to_node(cpu1), cpu_to_node(cpu2));
+	return !WARN_ONCE(cpu_to_node(cpu_this) != cpu_to_node(cpu_sibling),
+		"sched: CPU #%d's %s-sibling CPU #%d is not on the same node! [node: %d != %d]. Ignoring dependency.\n",
+		cpu_this, name, cpu_sibling, cpu_to_node(cpu_this), cpu_to_node(cpu_sibling));
 }
 
-#define link_mask(_m, c1, c2)						\
-do {									\
-	cpumask_set_cpu((c1), cpu_##_m##_mask(c2));			\
-	cpumask_set_cpu((c2), cpu_##_m##_mask(c1));			\
-} while (0)
-
-static bool match_smt(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+static bool match_smt(struct cpuinfo_x86 *c_this, struct cpuinfo_x86 *c_sibling)
 {
 	if (cpu_has_topoext) {
-		int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
+		int cpu_this = c_this->cpu_index, cpu_sibling = c_sibling->cpu_index;
 
-		if (c->phys_proc_id == o->phys_proc_id &&
-		    per_cpu(cpu_llc_id, cpu1) == per_cpu(cpu_llc_id, cpu2) &&
-		    c->compute_unit_id == o->compute_unit_id)
-			return topology_sane(c, o, "smt");
+		if (c_this->phys_proc_id == c_sibling->phys_proc_id &&
+		    per_cpu(cpu_llc_id, cpu_this) == per_cpu(cpu_llc_id, cpu_sibling) &&
+		    c_this->compute_unit_id == c_sibling->compute_unit_id)
+			return topology_sane(c_this, c_sibling, "smt");
 
-	} else if (c->phys_proc_id == o->phys_proc_id &&
-		   c->cpu_core_id == o->cpu_core_id) {
-		return topology_sane(c, o, "smt");
+	} else {
+		if (c_this->phys_proc_id == c_sibling->phys_proc_id &&
+		    c_this->cpu_core_id == c_sibling->cpu_core_id)
+			return topology_sane(c_this, c_sibling, "smt");
 	}
 
 	return false;
 }
 
-static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+static bool match_llc(struct cpuinfo_x86 *c_this, struct cpuinfo_x86 *c_sibling)
 {
-	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
+	int cpu_this = c_this->cpu_index, cpu_sibling = c_sibling->cpu_index;
 
-	if (per_cpu(cpu_llc_id, cpu1) != BAD_APICID &&
-	    per_cpu(cpu_llc_id, cpu1) == per_cpu(cpu_llc_id, cpu2))
-		return topology_sane(c, o, "llc");
+	if (per_cpu(cpu_llc_id, cpu_this) != BAD_APICID &&
+	    per_cpu(cpu_llc_id, cpu_this) == per_cpu(cpu_llc_id, cpu_sibling))
+		return topology_sane(c_this, c_sibling, "llc");
 
 	return false;
 }
 
-static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+static bool match_mc(struct cpuinfo_x86 *c_this, struct cpuinfo_x86 *c_sibling)
 {
-	if (c->phys_proc_id == o->phys_proc_id) {
-		if (cpu_has(c, X86_FEATURE_AMD_DCM))
+	if (c_this->phys_proc_id == c_sibling->phys_proc_id) {
+		if (cpu_has(c_this, X86_FEATURE_AMD_DCM))
 			return true;
 
-		return topology_sane(c, o, "mc");
+		return topology_sane(c_this, c_sibling, "mc");
 	}
 	return false;
 }
 
-void set_cpu_sibling_map(int cpu)
+/* Set both CPUs in a topology cpumask array: */
+#define link_cpus(mask_fn, cpu_this, cpu_sibling)			\
+do {									\
+	cpumask_set_cpu((cpu_this), mask_fn(cpu_sibling));		\
+	cpumask_set_cpu((cpu_sibling), mask_fn(cpu_this));		\
+} while (0)
+
+/*
+ * Add a CPU to the various CPU topology data structures,
+ * after it has booted up successfully:
+ */
+void set_cpu_sibling_map(int cpu_this)
 {
 	bool has_smt = smp_num_siblings > 1;
 	bool has_mp = has_smt || boot_cpu_data.x86_max_cores > 1;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	struct cpuinfo_x86 *o;
-	int i;
+	struct cpuinfo_x86 *c_this = &cpu_data(cpu_this);
+	struct cpuinfo_x86 *c_sibling;
+	int cpu_sibling;
 
-	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
+	cpumask_set_cpu(cpu_this, cpu_sibling_setup_mask);
 
 	if (!has_mp) {
-		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
-		cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
-		cpumask_set_cpu(cpu, cpu_core_mask(cpu));
-		c->booted_cores = 1;
+		cpumask_set_cpu(cpu_this, cpu_sibling_mask(cpu_this));
+		cpumask_set_cpu(cpu_this, cpu_llc_shared_mask(cpu_this));
+		cpumask_set_cpu(cpu_this, cpu_core_mask(cpu_this));
+		c_this->booted_cores = 1;
+
 		return;
 	}
 
-	for_each_cpu(i, cpu_sibling_setup_mask) {
-		o = &cpu_data(i);
+	for_each_cpu(cpu_sibling, cpu_sibling_setup_mask) {
+		c_sibling = &cpu_data(cpu_sibling);
 
-		if ((i == cpu) || (has_smt && match_smt(c, o)))
-			link_mask(sibling, cpu, i);
+		if ((cpu_sibling == cpu_this) || (has_smt && match_smt(c_this, c_sibling)))
+			link_cpus(cpu_sibling_mask, cpu_this, cpu_sibling);
 
-		if ((i == cpu) || (has_mp && match_llc(c, o)))
-			link_mask(llc_shared, cpu, i);
+		if ((cpu_sibling == cpu_this) || (has_mp && match_llc(c_this, c_sibling)))
+			link_cpus(cpu_llc_shared_mask, cpu_this, cpu_sibling);
 
 	}
 
@@ -402,35 +402,35 @@ void set_cpu_sibling_map(int cpu)
 	 * This needs a separate iteration over the cpus because we rely on all
 	 * cpu_sibling_mask links to be set-up.
 	 */
-	for_each_cpu(i, cpu_sibling_setup_mask) {
-		o = &cpu_data(i);
+	for_each_cpu(cpu_sibling, cpu_sibling_setup_mask) {
+		c_sibling = &cpu_data(cpu_sibling);
 
-		if ((i == cpu) || (has_mp && match_mc(c, o))) {
-			link_mask(core, cpu, i);
+		if ((cpu_sibling == cpu_this) || (has_mp && match_mc(c_this, c_sibling))) {
+			link_cpus(cpu_core_mask, cpu_this, cpu_sibling);
 
-			/*
-			 *  Does this new cpu bringup a new core?
-			 */
-			if (cpumask_weight(cpu_sibling_mask(cpu)) == 1) {
+			/* Does this new cpu bring up a new core? */
+			if (cpumask_weight(cpu_sibling_mask(cpu_this)) == 1) {
 				/*
-				 * for each core in package, increment
-				 * the booted_cores for this new cpu
+				 * For each core in package, increment
+				 * the booted_cores for this new cpu_this
 				 */
-				if (cpumask_first(cpu_sibling_mask(i)) == i)
-					c->booted_cores++;
+				if (cpumask_first(cpu_sibling_mask(cpu_sibling)) == cpu_sibling)
+					c_this->booted_cores++;
 				/*
-				 * increment the core count for all
+				 * Increment the core count for all
 				 * the other cpus in this package
 				 */
-				if (i != cpu)
-					cpu_data(i).booted_cores++;
-			} else if (i != cpu && !c->booted_cores)
-				c->booted_cores = cpu_data(i).booted_cores;
+				if (cpu_sibling != cpu_this)
+					cpu_data(cpu_sibling).booted_cores++;
+			} else {
+				if (cpu_sibling != cpu_this && !c_this->booted_cores)
+					c_this->booted_cores = cpu_data(cpu_sibling).booted_cores;
+			}
 		}
 	}
 }
 
-/* maps the cpu to the sched domain representing multi-core */
+/* Maps the cpu to the sched domain representing multi-core */
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
 	return cpu_llc_shared_mask(cpu);
@@ -438,21 +438,21 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 
 static void impress_friends(void)
 {
-	int cpu;
 	unsigned long bogosum = 0;
+	int cpu;
+
 	/*
 	 * Allow the user to impress friends.
 	 */
-	pr_debug("Before bogomips\n");
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
 		if (cpumask_test_cpu(cpu, cpu_callout_mask))
 			bogosum += cpu_data(cpu).loops_per_jiffy;
+	}
+
 	pr_info("Total of %d processors activated (%lu.%02lu BogoMIPS)\n",
 		num_online_cpus(),
 		bogosum/(500000/HZ),
 		(bogosum/(5000/HZ))%100);
-
-	pr_debug("Before bogocount - setting activated=1\n");
 }
 
 void __inquire_remote_apic(int apicid)
@@ -467,9 +467,7 @@ void __inquire_remote_apic(int apicid)
 	for (i = 0; i < ARRAY_SIZE(regs); i++) {
 		pr_info("... APIC 0x%x %s: ", apicid, names[i]);
 
-		/*
-		 * Wait for idle.
-		 */
+		/* Wait for idle. */
 		status = safe_apic_wait_icr_idle();
 		if (status)
 			pr_cont("a previous APIC delivery may have failed\n");
@@ -498,8 +496,7 @@ void __inquire_remote_apic(int apicid)
  * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
  * won't ... remember to clear down the APIC, etc later.
  */
-int
-wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip)
+int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
 	int maxlvt;
@@ -529,36 +526,27 @@ wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip)
 	if (accept_status)
 		pr_err("APIC delivery error (%lx)\n", accept_status);
 
-	return (send_status | accept_status);
+	return send_status | accept_status;
 }
 
-static int
-wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
+static int wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
 	int maxlvt, num_starts, j;
 
 	maxlvt = lapic_get_maxlvt();
 
-	/*
-	 * Be paranoid about clearing APIC errors.
-	 */
+	/* Be paranoid about clearing APIC errors. */
 	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
-		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP.  */
+		if (maxlvt > 3) /* Due to the Pentium erratum 3AP.  */
 			apic_write(APIC_ESR, 0);
 		apic_read(APIC_ESR);
 	}
 
 	pr_debug("Asserting INIT\n");
 
-	/*
-	 * Turn INIT on target chip
-	 */
-	/*
-	 * Send IPI
-	 */
-	apic_icr_write(APIC_INT_LEVELTRIG | APIC_INT_ASSERT | APIC_DM_INIT,
-		       phys_apicid);
+	/* Send INIT IPI */
+	apic_icr_write(APIC_INT_LEVELTRIG | APIC_INT_ASSERT | APIC_DM_INIT, phys_apicid);
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -567,8 +555,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 
 	pr_debug("Deasserting INIT\n");
 
-	/* Target chip */
-	/* Send IPI */
+	/* Send deassert INIT IPI: */
 	apic_icr_write(APIC_INT_LEVELTRIG | APIC_DM_INIT, phys_apicid);
 
 	pr_debug("Waiting for send to finish...\n");
@@ -578,7 +565,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	atomic_set(&init_deasserted, 1);
 
 	/*
-	 * Should we send STARTUP IPIs ?
+	 * Should we send STARTUP IPIs?
 	 *
 	 * Determine this based on the APIC version.
 	 * If we don't have an integrated APIC, don't send the STARTUP IPIs.
@@ -592,34 +579,22 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	 * Paravirt / VMI wants a startup IPI hook here to set up the
 	 * target processor state.
 	 */
-	startup_ipi_hook(phys_apicid, (unsigned long) start_secondary,
-			 stack_start);
+	startup_ipi_hook(phys_apicid, (unsigned long)start_secondary, stack_start);
 
-	/*
-	 * Run STARTUP IPI loop.
-	 */
+	/* Run STARTUP IPI loop. */
 	pr_debug("#startup loops: %d\n", num_starts);
 
 	for (j = 1; j <= num_starts; j++) {
 		pr_debug("Sending STARTUP #%d\n", j);
-		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP.  */
+		if (maxlvt > 3) /* Due to the Pentium erratum 3AP.  */
 			apic_write(APIC_ESR, 0);
 		apic_read(APIC_ESR);
 		pr_debug("After apic_write\n");
 
-		/*
-		 * STARTUP IPI
-		 */
-
-		/* Target chip */
-		/* Boot on the stack */
-		/* Kick the second */
-		apic_icr_write(APIC_DM_STARTUP | (start_eip >> 12),
-			       phys_apicid);
+		/* Send STARTUP IPI to the secondary CPU: */
+		apic_icr_write(APIC_DM_STARTUP | (start_eip >> 12), phys_apicid);
 
-		/*
-		 * Give the other CPU some time to accept the IPI.
-		 */
+		/* Give the other CPU some time to accept the IPI. */
 		udelay(300);
 
 		pr_debug("Startup point 1\n");
@@ -627,11 +602,9 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 		pr_debug("Waiting for send to finish...\n");
 		send_status = safe_apic_wait_icr_idle();
 
-		/*
-		 * Give the other CPU some time to accept the IPI.
-		 */
+		/* Give the other CPU more time to accept the IPI. */
 		udelay(200);
-		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP.  */
+		if (maxlvt > 3)	/* Due to the Pentium erratum 3AP.  */
 			apic_write(APIC_ESR, 0);
 		accept_status = (apic_read(APIC_ESR) & 0xEF);
 		if (send_status || accept_status)
@@ -644,7 +617,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	if (accept_status)
 		pr_err("APIC delivery error (%lx)\n", accept_status);
 
-	return (send_status | accept_status);
+	return send_status | accept_status;
 }
 
 void smp_announce(void)
@@ -655,7 +628,13 @@ void smp_announce(void)
 	       num_nodes, (num_nodes > 1 ? "s" : ""), num_online_cpus());
 }
 
-/* reduce the number of lines printed when booting a large cpu count system */
+/*
+ * Print a successful bootup of a secondary CPU.
+ *
+ * ( The field width magic is due to the tabulated per node output we print,
+ *   which we do to reduce the number of lines printed when booting a large
+ *   cpu count system and also because it's prettier. )
+ */
 static void announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
@@ -673,7 +652,7 @@ static void announce_cpu(int cpu, int apicid)
 
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
-			if (current_node > (-1))
+			if (current_node > -1)
 				pr_cont("\n");
 			current_node = node;
 
@@ -687,17 +666,17 @@ static void announce_cpu(int cpu, int apicid)
 
 		pr_cont("%*s#%d", width - num_digits(cpu), " ", cpu);
 
-	} else
+	} else {
 		pr_info("Booting Node %d Processor %d APIC 0x%x\n",
 			node, cpu, apicid);
+	}
 }
 
 static int wakeup_cpu0_nmi(unsigned int cmd, struct pt_regs *regs)
 {
-	int cpu;
+	int this_cpu = smp_processor_id();
 
-	cpu = smp_processor_id();
-	if (cpu == 0 && !cpu_online(cpu) && enable_start_cpu0)
+	if (this_cpu == 0 && !cpu_online(this_cpu) && enable_start_cpu0)
 		return NMI_HANDLED;
 
 	return NMI_DONE;
@@ -716,8 +695,7 @@ static int wakeup_cpu0_nmi(unsigned int cmd, struct pt_regs *regs)
  * real platform and request are available.
  */
 static int
-wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
-	       int *cpu0_nmi_registered)
+wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid, int *cpu0_nmi_registered)
 {
 	int id;
 	int boot_error;
@@ -733,8 +711,7 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
 	 *
 	 * Register a NMI handler to help wake up CPU0.
 	 */
-	boot_error = register_nmi_handler(NMI_LOCAL,
-					  wakeup_cpu0_nmi, 0, "wake_cpu0");
+	boot_error = register_nmi_handler(NMI_LOCAL, wakeup_cpu0_nmi, 0, "wake_cpu0");
 
 	if (!boot_error) {
 		enable_start_cpu0 = 1;
@@ -794,7 +771,6 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	 * This grunge runs the startup process for
 	 * the targeted processor.
 	 */
-
 	atomic_set(&init_deasserted, 0);
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
@@ -831,9 +807,7 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 		cpumask_set_cpu(cpu, cpu_callout_mask);
 		pr_debug("After Callout %d\n", cpu);
 
-		/*
-		 * Wait 5s total for a response
-		 */
+		/* Wait 5s total for a response: */
 		for (timeout = 0; timeout < 50000; timeout++) {
 			if (cpumask_test_cpu(cpu, cpu_callin_mask))
 				break;	/* It has booted */
@@ -853,10 +827,10 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 		} else {
 			boot_error = 1;
 			if (*trampoline_status == 0xA5A5A5A5)
-				/* trampoline started but...? */
+				/* Trampoline started but...? */
 				pr_err("CPU%d: Stuck ??\n", cpu);
 			else
-				/* trampoline code not run */
+				/* Trampoline code not run */
 				pr_err("CPU%d: Not responding\n", cpu);
 			if (apic->inquire_remote_apic)
 				apic->inquire_remote_apic(apicid);
@@ -867,23 +841,21 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 		/* Try to put things back the way they were before ... */
 		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
 
-		/* was set by do_boot_cpu() */
+		/* Was set by do_boot_cpu() */
 		cpumask_clear_cpu(cpu, cpu_callout_mask);
 
-		/* was set by cpu_init() */
+		/* Was set by cpu_init() */
 		cpumask_clear_cpu(cpu, cpu_initialized_mask);
 
 		set_cpu_present(cpu, false);
 		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	}
 
-	/* mark "stuck" area as not stuck */
+	/* Mark "stuck" area as not stuck */
 	*trampoline_status = 0;
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
-		/*
-		 * Cleanup possible dangling ends...
-		 */
+		/* Clean up possible dangling ends... */
 		smpboot_restore_warm_reset_vector();
 	}
 	/*
@@ -913,9 +885,7 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 		return -EINVAL;
 	}
 
-	/*
-	 * Already booted CPU?
-	 */
+	/* Already booted CPU? */
 	if (cpumask_test_cpu(cpu, cpu_callin_mask)) {
 		pr_debug("do_boot_cpu %d Already started\n", cpu);
 		return -ENOSYS;
@@ -929,7 +899,7 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
-	/* the FPU context is blank, nobody can own it */
+	/* The FPU context is blank, nobody can own it */
 	__cpu_disable_lazy_restore(cpu);
 
 	err = do_boot_cpu(apicid, cpu, tidle);
@@ -993,8 +963,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 		unsigned int cpu;
 		unsigned nr;
 
-		pr_warn("More than 8 CPUs detected - skipping them\n"
-			"Use CONFIG_X86_BIGSMP\n");
+		pr_warn("More than 8 CPUs detected - skipping them, use CONFIG_X86_BIGSMP.\n");
 
 		nr = 0;
 		for_each_present_cpu(cpu) {
@@ -1015,8 +984,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 #endif
 
 	if (!physid_isset(hard_smp_processor_id(), phys_cpu_present_map)) {
-		pr_warn("weird, boot CPU (#%d) not listed by the BIOS\n",
-			hard_smp_processor_id());
+		pr_warn("weird, boot CPU (#%d) not listed by the BIOS\n", hard_smp_processor_id());
 
 		physid_set(hard_smp_processor_id(), phys_cpu_present_map);
 	}
@@ -1045,9 +1013,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	}
 	preempt_enable();
 
-	/*
-	 * If we couldn't find a local APIC, then get out of here now!
-	 */
+	/* If we couldn't find a local APIC, then get out of here now! */
 	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
 	    !cpu_has_apic) {
 		if (!disable_apic) {
@@ -1062,9 +1028,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 
 	verify_local_APIC();
 
-	/*
-	 * If SMP should be disabled, then really disable it!
-	 */
+	/* If SMP should be disabled, then really disable it! */
 	if (!max_cpus) {
 		pr_info("SMP mode deactivated\n");
 		smpboot_clear_io_apic();
@@ -1081,12 +1045,12 @@ static int __init smp_sanity_check(unsigned max_cpus)
 static void __init smp_cpu_index_default(void)
 {
 	int i;
-	struct cpuinfo_x86 *c;
+	struct cpuinfo_x86 *c_this;
 
 	for_each_possible_cpu(i) {
-		c = &cpu_data(i);
-		/* mark all to hotplug */
-		c->cpu_index = nr_cpu_ids;
+		c_this = &cpu_data(i);
+		/* Mark all to hotplug */
+		c_this->cpu_index = nr_cpu_ids;
 	}
 }
 
@@ -1101,9 +1065,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	preempt_disable();
 	smp_cpu_index_default();
 
-	/*
-	 * Setup boot CPU information
-	 */
+	/* Setup boot CPU information */
 	smp_store_boot_cpu_info(); /* Final full version of the data */
 	cpumask_copy(cpu_callin_mask, cpumask_of(0));
 	mb();
@@ -1135,9 +1097,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	connect_bsp_APIC();
 
-	/*
-	 * Switch from PIC to APIC mode.
-	 */
+	/* Switch from PIC to APIC mode. */
 	setup_local_APIC();
 
 	if (x2apic_mode)
@@ -1145,9 +1105,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	else
 		cpu0_logical_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
 
-	/*
-	 * Enable IO APIC before setting up error vector
-	 */
+	/* Enable IO APIC before setting up error vector */
 	if (!skip_ioapic_setup && nr_ioapics)
 		enable_IO_APIC();
 
@@ -1157,12 +1115,10 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		apic->setup_portio_remap();
 
 	smpboot_setup_io_apic();
-	/*
-	 * Set up local APIC timer on boot CPU.
-	 */
-
 	pr_info("CPU%d: ", 0);
 	print_cpu_info(&cpu_data(0));
+
+	/* Set up local APIC timer on boot CPU.  */
 	x86_init.timers.setup_percpu_clockev();
 
 	if (is_uv_system())
@@ -1189,8 +1145,9 @@ void arch_enable_nonboot_cpus_end(void)
 void __init native_smp_prepare_boot_cpu(void)
 {
 	int me = smp_processor_id();
+
 	switch_to_new_gdt(me);
-	/* already set me in cpu_online_mask in boot_cpu_init() */
+	/* Already set me in cpu_online_mask in boot_cpu_init() */
 	cpumask_set_cpu(me, cpu_callout_mask);
 	per_cpu(cpu_state, me) = CPU_ONLINE;
 }
@@ -1237,7 +1194,7 @@ __init void prefill_possible_map(void)
 {
 	int i, possible;
 
-	/* no processor from mptable or madt */
+	/* No processor from mptable or madt */
 	if (!num_processors)
 		num_processors = 1;
 
@@ -1251,8 +1208,9 @@ __init void prefill_possible_map(void)
 		if (possible > i)
 			possible = i;
 #endif
-	} else
+	} else {
 		possible = setup_possible_cpus;
+	}
 
 	total_cpus = max_t(int, possible, num_processors + disabled_cpus);
 
@@ -1277,6 +1235,7 @@ __init void prefill_possible_map(void)
 
 	for (i = 0; i < possible; i++)
 		set_cpu_possible(i, true);
+
 	for (; i < NR_CPUS; i++)
 		set_cpu_possible(i, false);
 
@@ -1287,24 +1246,24 @@ __init void prefill_possible_map(void)
 
 static void remove_siblinginfo(int cpu)
 {
-	int sibling;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	int cpu_sibling;
+	struct cpuinfo_x86 *c_this = &cpu_data(cpu);
 
-	for_each_cpu(sibling, cpu_core_mask(cpu)) {
-		cpumask_clear_cpu(cpu, cpu_core_mask(sibling));
-		/*/
-		 * last thread sibling in this cpu core going down
-		 */
+	for_each_cpu(cpu_sibling, cpu_core_mask(cpu)) {
+		cpumask_clear_cpu(cpu, cpu_core_mask(cpu_sibling));
+
+		/* last thread cpu_sibling in this cpu core going down */
 		if (cpumask_weight(cpu_sibling_mask(cpu)) == 1)
-			cpu_data(sibling).booted_cores--;
+			cpu_data(cpu_sibling).booted_cores--;
 	}
 
-	for_each_cpu(sibling, cpu_sibling_mask(cpu))
-		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
+	for_each_cpu(cpu_sibling, cpu_sibling_mask(cpu))
+		cpumask_clear_cpu(cpu, cpu_sibling_mask(cpu_sibling));
+
 	cpumask_clear(cpu_sibling_mask(cpu));
 	cpumask_clear(cpu_core_mask(cpu));
-	c->phys_proc_id = 0;
-	c->cpu_core_id = 0;
+	c_this->phys_proc_id = 0;
+	c_this->cpu_core_id = 0;
 	cpumask_clear_cpu(cpu, cpu_sibling_setup_mask);
 }
 
@@ -1334,8 +1293,8 @@ void cpu_disable_common(void)
 int native_cpu_disable(void)
 {
 	clear_local_APIC();
-
 	cpu_disable_common();
+
 	return 0;
 }
 
@@ -1366,9 +1325,7 @@ void play_dead_common(void)
 	/* Ack it */
 	__this_cpu_write(cpu_state, CPU_DEAD);
 
-	/*
-	 * With physical CPU hotplug, we should halt the cpu
-	 */
+	/* With physical CPU hotplug, we should halt the cpu */
 	local_irq_disable();
 }
 
@@ -1442,9 +1399,8 @@ static inline void mwait_play_dead(void)
 		__monitor(mwait_ptr, 0, 0);
 		mb();
 		__mwait(eax, 0);
-		/*
-		 * If NMI wants to wake up CPU0, start CPU0.
-		 */
+
+		/* If NMI wants to wake up CPU0, start CPU0.  */
 		if (wakeup_cpu0())
 			start_cpu0();
 	}
@@ -1457,9 +1413,8 @@ static inline void hlt_play_dead(void)
 
 	while (1) {
 		native_halt();
-		/*
-		 * If NMI wants to wake up CPU0, start CPU0.
-		 */
+
+		/* If NMI wants to wake up CPU0, start CPU0. */
 		if (wakeup_cpu0())
 			start_cpu0();
 	}
@@ -1476,6 +1431,7 @@ void native_play_dead(void)
 }
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
+
 int native_cpu_disable(void)
 {
 	return -ENOSYS;
