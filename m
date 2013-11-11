Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3KKRYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:24:36 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:34566 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3KKRY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:24:28 -0500
Date: Mon, 11 Nov 2013 18:24:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v3.13
Message-ID: <20131111172424.GA13355@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

   # HEAD: b53b5eda8194214928c8243d711a75dbf51809fc x86/cpu: Increase max CPU count to 8192

The biggest change that stands out is the increase of the CONFIG_NR_CPUS 
range from 4096 to 8192 - as real hardware out there already went beyond 
4k CPUs ...

We only allow more than 512 CPUs if offstack cpumasks are enabled.

CONFIG_MAXSMP=y remains to be the 'you are nuts!' extreme testcase, which 
now means a max of 8192 CPUs.


 Thanks,

	Ingo

------------------>
HATAYAMA Daisuke (1):
      x86/cpu: Always print SMP information in /proc/cpuinfo

Jan Beulich (1):
      x86/cpu: Track legacy CPU model data only on 32-bit kernels

Josh Boyer (2):
      x86/cpu: Allow higher NR_CPUS values
      x86/cpu: Increase max CPU count to 8192


 arch/x86/Kconfig              |  8 +++++---
 arch/x86/kernel/cpu/amd.c     |  6 +++---
 arch/x86/kernel/cpu/centaur.c |  8 +++++---
 arch/x86/kernel/cpu/common.c  | 12 +++++++-----
 arch/x86/kernel/cpu/cpu.h     | 20 +++++++++++---------
 arch/x86/kernel/cpu/intel.c   | 12 ++++++------
 arch/x86/kernel/cpu/proc.c    | 15 ++++++---------
 arch/x86/kernel/cpu/umc.c     |  4 ++--
 8 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f67e839..805469a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -825,14 +825,16 @@ config MAXSMP
 config NR_CPUS
 	int "Maximum number of CPUs" if SMP && !MAXSMP
 	range 2 8 if SMP && X86_32 && !X86_BIGSMP
-	range 2 512 if SMP && !MAXSMP
+	range 2 512 if SMP && !MAXSMP && !CPUMASK_OFFSTACK
+	range 2 8192 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
 	default "1" if !SMP
-	default "4096" if MAXSMP
+	default "8192" if MAXSMP
 	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
 	default "8" if SMP
 	---help---
 	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  The maximum supported value is 512 and the
+	  kernel will support.  If CPUMASK_OFFSTACK is enabled, the maximum
+	  supported value is 4096, otherwise the maximum value is 512.  The
 	  minimum value which makes sense is 2.
 
 	  This is purely to save memory - each supported CPU adds
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 903a264..3daece7 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -823,8 +823,8 @@ static const struct cpu_dev amd_cpu_dev = {
 	.c_vendor	= "AMD",
 	.c_ident	= { "AuthenticAMD" },
 #ifdef CONFIG_X86_32
-	.c_models = {
-		{ .vendor = X86_VENDOR_AMD, .family = 4, .model_names =
+	.legacy_models = {
+		{ .family = 4, .model_names =
 		  {
 			  [3] = "486 DX/2",
 			  [7] = "486 DX/2-WB",
@@ -835,7 +835,7 @@ static const struct cpu_dev amd_cpu_dev = {
 		  }
 		},
 	},
-	.c_size_cache	= amd_size_cache,
+	.legacy_cache_size = amd_size_cache,
 #endif
 	.c_early_init   = early_init_amd,
 	.c_detect_tlb	= cpu_detect_tlb_amd,
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index fbf6c3b..8d5652d 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -468,10 +468,10 @@ static void init_centaur(struct cpuinfo_x86 *c)
 #endif
 }
 
+#ifdef CONFIG_X86_32
 static unsigned int
 centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
-#ifdef CONFIG_X86_32
 	/* VIA C3 CPUs (670-68F) need further shifting. */
 	if ((c->x86 == 6) && ((c->x86_model == 7) || (c->x86_model == 8)))
 		size >>= 8;
@@ -484,16 +484,18 @@ centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 	if ((c->x86 == 6) && (c->x86_model == 9) &&
 				(c->x86_mask == 1) && (size == 65))
 		size -= 1;
-#endif
 	return size;
 }
+#endif
 
 static const struct cpu_dev centaur_cpu_dev = {
 	.c_vendor	= "Centaur",
 	.c_ident	= { "CentaurHauls" },
 	.c_early_init	= early_init_centaur,
 	.c_init		= init_centaur,
-	.c_size_cache	= centaur_size_cache,
+#ifdef CONFIG_X86_32
+	.legacy_cache_size = centaur_size_cache,
+#endif
 	.c_x86_vendor	= X86_VENDOR_CENTAUR,
 };
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2793d1f..9ada0b3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -346,7 +346,8 @@ static void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
 /* Look up CPU names by table lookup. */
 static const char *table_lookup_model(struct cpuinfo_x86 *c)
 {
-	const struct cpu_model_info *info;
+#ifdef CONFIG_X86_32
+	const struct legacy_cpu_model_info *info;
 
 	if (c->x86_model >= 16)
 		return NULL;	/* Range check */
@@ -354,13 +355,14 @@ static const char *table_lookup_model(struct cpuinfo_x86 *c)
 	if (!this_cpu)
 		return NULL;
 
-	info = this_cpu->c_models;
+	info = this_cpu->legacy_models;
 
-	while (info && info->family) {
+	while (info->family) {
 		if (info->family == c->x86)
 			return info->model_names[c->x86_model];
 		info++;
 	}
+#endif
 	return NULL;		/* Not found */
 }
 
@@ -450,8 +452,8 @@ void cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
 	c->x86_tlbsize += ((ebx >> 16) & 0xfff) + (ebx & 0xfff);
 #else
 	/* do processor-specific cache resizing */
-	if (this_cpu->c_size_cache)
-		l2size = this_cpu->c_size_cache(c, l2size);
+	if (this_cpu->legacy_cache_size)
+		l2size = this_cpu->legacy_cache_size(c, l2size);
 
 	/* Allow user to override all this if necessary. */
 	if (cachesize_override != -1)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 4041c24..c37dc37 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -1,12 +1,6 @@
 #ifndef ARCH_X86_CPU_H
 #define ARCH_X86_CPU_H
 
-struct cpu_model_info {
-	int		vendor;
-	int		family;
-	const char	*model_names[16];
-};
-
 /* attempt to consolidate cpu attributes */
 struct cpu_dev {
 	const char	*c_vendor;
@@ -14,15 +8,23 @@ struct cpu_dev {
 	/* some have two possibilities for cpuid string */
 	const char	*c_ident[2];
 
-	struct		cpu_model_info c_models[4];
-
 	void            (*c_early_init)(struct cpuinfo_x86 *);
 	void		(*c_bsp_init)(struct cpuinfo_x86 *);
 	void		(*c_init)(struct cpuinfo_x86 *);
 	void		(*c_identify)(struct cpuinfo_x86 *);
 	void		(*c_detect_tlb)(struct cpuinfo_x86 *);
-	unsigned int	(*c_size_cache)(struct cpuinfo_x86 *, unsigned int);
 	int		c_x86_vendor;
+#ifdef CONFIG_X86_32
+	/* Optional vendor specific routine to obtain the cache size. */
+	unsigned int	(*legacy_cache_size)(struct cpuinfo_x86 *,
+					     unsigned int);
+
+	/* Family/stepping-based lookup table for model names. */
+	struct legacy_cpu_model_info {
+		int		family;
+		const char	*model_names[16];
+	}		legacy_models[5];
+#endif
 };
 
 struct _tlb_table {
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ec72995..dc1ec0d 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -665,8 +665,8 @@ static const struct cpu_dev intel_cpu_dev = {
 	.c_vendor	= "Intel",
 	.c_ident	= { "GenuineIntel" },
 #ifdef CONFIG_X86_32
-	.c_models = {
-		{ .vendor = X86_VENDOR_INTEL, .family = 4, .model_names =
+	.legacy_models = {
+		{ .family = 4, .model_names =
 		  {
 			  [0] = "486 DX-25/33",
 			  [1] = "486 DX-50",
@@ -679,7 +679,7 @@ static const struct cpu_dev intel_cpu_dev = {
 			  [9] = "486 DX/4-WB"
 		  }
 		},
-		{ .vendor = X86_VENDOR_INTEL, .family = 5, .model_names =
+		{ .family = 5, .model_names =
 		  {
 			  [0] = "Pentium 60/66 A-step",
 			  [1] = "Pentium 60/66",
@@ -690,7 +690,7 @@ static const struct cpu_dev intel_cpu_dev = {
 			  [8] = "Mobile Pentium MMX"
 		  }
 		},
-		{ .vendor = X86_VENDOR_INTEL, .family = 6, .model_names =
+		{ .family = 6, .model_names =
 		  {
 			  [0] = "Pentium Pro A-step",
 			  [1] = "Pentium Pro",
@@ -704,7 +704,7 @@ static const struct cpu_dev intel_cpu_dev = {
 			  [11] = "Pentium III (Tualatin)",
 		  }
 		},
-		{ .vendor = X86_VENDOR_INTEL, .family = 15, .model_names =
+		{ .family = 15, .model_names =
 		  {
 			  [0] = "Pentium 4 (Unknown)",
 			  [1] = "Pentium 4 (Willamette)",
@@ -714,7 +714,7 @@ static const struct cpu_dev intel_cpu_dev = {
 		  }
 		},
 	},
-	.c_size_cache	= intel_size_cache,
+	.legacy_cache_size = intel_size_cache,
 #endif
 	.c_detect_tlb	= intel_detect_tlb,
 	.c_early_init   = early_init_intel,
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index aee6317..06fe3ed 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -11,15 +11,12 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 			      unsigned int cpu)
 {
 #ifdef CONFIG_SMP
-	if (c->x86_max_cores * smp_num_siblings > 1) {
-		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n",
-			   cpumask_weight(cpu_core_mask(cpu)));
-		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
-		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
-		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
-		seq_printf(m, "initial apicid\t: %d\n", c->initial_apicid);
-	}
+	seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
+	seq_printf(m, "siblings\t: %d\n", cpumask_weight(cpu_core_mask(cpu)));
+	seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
+	seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
+	seq_printf(m, "apicid\t\t: %d\n", c->apicid);
+	seq_printf(m, "initial apicid\t: %d\n", c->initial_apicid);
 #endif
 }
 
diff --git a/arch/x86/kernel/cpu/umc.c b/arch/x86/kernel/cpu/umc.c
index 202759a..75c5ad5 100644
--- a/arch/x86/kernel/cpu/umc.c
+++ b/arch/x86/kernel/cpu/umc.c
@@ -11,8 +11,8 @@
 static const struct cpu_dev umc_cpu_dev = {
 	.c_vendor	= "UMC",
 	.c_ident	= { "UMC UMC UMC" },
-	.c_models = {
-		{ .vendor = X86_VENDOR_UMC, .family = 4, .model_names =
+	.legacy_models	= {
+		{ .family = 4, .model_names =
 		  {
 			  [1] = "U5D",
 			  [2] = "U5S",
