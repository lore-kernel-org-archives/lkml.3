Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3JZNvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:51:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37259 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab3JZNvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:51:51 -0400
Date: Sat, 26 Oct 2013 06:51:34 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-09dc68d958c67c76cf672ec78b7391af453010f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <5265036802000078000FC4DB@nat28.tlf.novell.com>
References: <5265036802000078000FC4DB@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86/cpu:
  Track legacy CPU model data only on 32-bit kernels
Git-Commit-ID: 09dc68d958c67c76cf672ec78b7391af453010f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 26 Oct 2013 06:51:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09dc68d958c67c76cf672ec78b7391af453010f8
Gitweb:     http://git.kernel.org/tip/09dc68d958c67c76cf672ec78b7391af453010f8
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 21 Oct 2013 09:35:20 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 26 Oct 2013 13:34:39 +0200

x86/cpu: Track legacy CPU model data only on 32-bit kernels

struct cpu_dev's c_models is only ever set inside CONFIG_X86_32
conditionals (or code that's being built for 32-bit only), so
there's no use of reserving the (empty) space for the model
names in a 64-bit kernel.

Similarly, c_size_cache is only used in the #else of a
CONFIG_X86_64 conditional, so reserving space for (and in one
case even initializing) that field is pointless for 64-bit
kernels too.

While moving both fields to the end of the structure, I also
noticed that:

 - the c_models array size was one too small, potentially causing
   table_lookup_model() to return garbage on Intel CPUs (intel.c's
   instance was lacking the sentinel with family being zero), so the
   patch bumps that by one,

 - c_models' vendor sub-field was unused (and anyway redundant
   with the base structure's c_x86_vendor field), so the patch deletes it.

Also rename the legacy fields so that their legacy nature stands out
and comment their declarations.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/5265036802000078000FC4DB@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/amd.c     |  6 +++---
 arch/x86/kernel/cpu/centaur.c |  8 +++++---
 arch/x86/kernel/cpu/common.c  | 12 +++++++-----
 arch/x86/kernel/cpu/cpu.h     | 20 +++++++++++---------
 arch/x86/kernel/cpu/intel.c   | 12 ++++++------
 arch/x86/kernel/cpu/umc.c     |  4 ++--
 6 files changed, 34 insertions(+), 28 deletions(-)

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
