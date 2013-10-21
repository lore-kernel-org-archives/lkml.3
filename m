Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab3JUIf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:35:27 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41083 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3JUIf0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 21 Oct 2013 04:35:26 -0400
Message-Id: <5265036802000078000FC4DB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 21 Oct 2013 09:35:20 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@kernel.org>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] x86-64: don't track CPU model data that is used by
 32-bit code only
References: <525E989602000078000FB740@nat28.tlf.novell.com>
 <20131018062452.GB14264@gmail.com>
In-Reply-To: <20131018062452.GB14264@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct cpu_dev's c_models is only ever set inside CONFIG_X86_32
conditionals (or code that's being built for 32-bit only), so there's
no use of reserving the (empty) space for the model names in a 64-bit
kernel.

Similarly, c_size_cache is only used in the #else of a CONFIG_X86_64
conditional, so reserving space for (and in one case even initializing)
that field is pointless for 64-bit kernels too.

While moving both fields to the end of the structure, I also noticed
that
- the c_models array size was one too small, potentially causing
  table_lookup_model() to return garbage on Intel CPUs (intel.c's
  instance was lacking the sentinel with family being zero), so the
  patch bumps that by one,
- c_models' vendor sub-field was unused (and anyway redundant with
  the base structure's c_x86_vendor field), so the patch deletes it.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
v2: Rename the legacy fields so that their legacy nature stands out.
    Comment their declarations. (Both requested by Ingo.)
---
 arch/x86/kernel/cpu/amd.c     |    6 +++---
 arch/x86/kernel/cpu/centaur.c |    8 +++++---
 arch/x86/kernel/cpu/common.c  |   12 +++++++-----
 arch/x86/kernel/cpu/cpu.h     |   20 +++++++++++---------
 arch/x86/kernel/cpu/intel.c   |   12 ++++++------
 arch/x86/kernel/cpu/umc.c     |    4 ++--
 6 files changed, 34 insertions(+), 28 deletions(-)

--- 3.12-rc6/arch/x86/kernel/cpu/amd.c
+++ 3.12-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/amd.c
@@ -823,8 +823,8 @@ static const struct cpu_dev amd_cpu_dev 
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
@@ -835,7 +835,7 @@ static const struct cpu_dev amd_cpu_dev 
 		  }
 		},
 	},
-	.c_size_cache	= amd_size_cache,
+	.legacy_cache_size = amd_size_cache,
 #endif
 	.c_early_init   = early_init_amd,
 	.c_detect_tlb	= cpu_detect_tlb_amd,
--- 3.12-rc6/arch/x86/kernel/cpu/centaur.c
+++ 3.12-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/centaur.c
@@ -468,10 +468,10 @@ static void init_centaur(struct cpuinfo_
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
@@ -484,16 +484,18 @@ centaur_size_cache(struct cpuinfo_x86 *c
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
 
--- 3.12-rc6/arch/x86/kernel/cpu/common.c
+++ 3.12-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/common.c
@@ -346,7 +346,8 @@ static void filter_cpuid_features(struct
 /* Look up CPU names by table lookup. */
 static const char *table_lookup_model(struct cpuinfo_x86 *c)
 {
-	const struct cpu_model_info *info;
+#ifdef CONFIG_X86_32
+	const struct legacy_cpu_model_info *info;
 
 	if (c->x86_model >= 16)
 		return NULL;	/* Range check */
@@ -354,13 +355,14 @@ static const char *table_lookup_model(st
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
 
@@ -450,8 +452,8 @@ void cpu_detect_cache_sizes(struct cpuin
 	c->x86_tlbsize += ((ebx >> 16) & 0xfff) + (ebx & 0xfff);
 #else
 	/* do processor-specific cache resizing */
-	if (this_cpu->c_size_cache)
-		l2size = this_cpu->c_size_cache(c, l2size);
+	if (this_cpu->legacy_cache_size)
+		l2size = this_cpu->legacy_cache_size(c, l2size);
 
 	/* Allow user to override all this if necessary. */
 	if (cachesize_override != -1)
--- 3.12-rc6/arch/x86/kernel/cpu/cpu.h
+++ 3.12-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/cpu.h
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
--- 3.12-rc6/arch/x86/kernel/cpu/intel.c
+++ 3.12-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/intel.c
@@ -665,8 +665,8 @@ static const struct cpu_dev intel_cpu_de
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
@@ -679,7 +679,7 @@ static const struct cpu_dev intel_cpu_de
 			  [9] = "486 DX/4-WB"
 		  }
 		},
-		{ .vendor = X86_VENDOR_INTEL, .family = 5, .model_names =
+		{ .family = 5, .model_names =
 		  {
 			  [0] = "Pentium 60/66 A-step",
 			  [1] = "Pentium 60/66",
@@ -690,7 +690,7 @@ static const struct cpu_dev intel_cpu_de
 			  [8] = "Mobile Pentium MMX"
 		  }
 		},
-		{ .vendor = X86_VENDOR_INTEL, .family = 6, .model_names =
+		{ .family = 6, .model_names =
 		  {
 			  [0] = "Pentium Pro A-step",
 			  [1] = "Pentium Pro",
@@ -704,7 +704,7 @@ static const struct cpu_dev intel_cpu_de
 			  [11] = "Pentium III (Tualatin)",
 		  }
 		},
-		{ .vendor = X86_VENDOR_INTEL, .family = 15, .model_names =
+		{ .family = 15, .model_names =
 		  {
 			  [0] = "Pentium 4 (Unknown)",
 			  [1] = "Pentium 4 (Willamette)",
@@ -714,7 +714,7 @@ static const struct cpu_dev intel_cpu_de
 		  }
 		},
 	},
-	.c_size_cache	= intel_size_cache,
+	.legacy_cache_size = intel_size_cache,
 #endif
 	.c_detect_tlb	= intel_detect_tlb,
 	.c_early_init   = early_init_intel,
--- 3.12-rc6/arch/x86/kernel/cpu/umc.c
+++ 3.12-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/umc.c
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


