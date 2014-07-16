Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbaGPLSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:18:37 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:57755 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759323AbaGPLSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:18:34 -0400
Date: Wed, 16 Jul 2014 13:18:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20140716111825.GA8879@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   # HEAD: b6220ad66bcd4a50737eb3c08e9466aa44f3bc98 sched: Fix compiler warnings

A cpufreq lockup fix and a compiler warning fix.

 Thanks,

	Ingo

------------------>
Guenter Roeck (1):
      sched: Fix compiler warnings

Peter Zijlstra (1):
      x86, tsc: Fix cpufreq lockup


 arch/arm/kernel/topology.c | 2 +-
 arch/powerpc/kernel/smp.c  | 2 +-
 arch/x86/kernel/tsc.c      | 4 ++--
 include/linux/sched.h      | 8 ++++----
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 9d85318..e35d880 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -275,7 +275,7 @@ void store_cpu_topology(unsigned int cpuid)
 		cpu_topology[cpuid].socket_id, mpidr);
 }
 
-static inline const int cpu_corepower_flags(void)
+static inline int cpu_corepower_flags(void)
 {
 	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
 }
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 51a3ff7..1007fb8 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -747,7 +747,7 @@ int setup_profiling_timer(unsigned int multiplier)
 
 #ifdef CONFIG_SCHED_SMT
 /* cpumask of CPUs with asymetric SMT dependancy */
-static const int powerpc_smt_flags(void)
+static int powerpc_smt_flags(void)
 {
 	int flags = SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 57e5ce1..ea03031 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -920,9 +920,9 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
 			mark_tsc_unstable("cpufreq changes");
-	}
 
-	set_cyc2ns_scale(tsc_khz, freq->cpu);
+		set_cyc2ns_scale(tsc_khz, freq->cpu);
+	}
 
 	return 0;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0..0376b05 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -872,21 +872,21 @@ enum cpu_idle_type {
 #define SD_NUMA			0x4000	/* cross-node balancing */
 
 #ifdef CONFIG_SCHED_SMT
-static inline const int cpu_smt_flags(void)
+static inline int cpu_smt_flags(void)
 {
 	return SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
 }
 #endif
 
 #ifdef CONFIG_SCHED_MC
-static inline const int cpu_core_flags(void)
+static inline int cpu_core_flags(void)
 {
 	return SD_SHARE_PKG_RESOURCES;
 }
 #endif
 
 #ifdef CONFIG_NUMA
-static inline const int cpu_numa_flags(void)
+static inline int cpu_numa_flags(void)
 {
 	return SD_NUMA;
 }
@@ -999,7 +999,7 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
 bool cpus_share_cache(int this_cpu, int that_cpu);
 
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
-typedef const int (*sched_domain_flags_f)(void);
+typedef int (*sched_domain_flags_f)(void);
 
 #define SDTL_OVERLAP	0x01
 
