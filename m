Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaKXVJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:09:42 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:45196 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKXVJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:09:36 -0500
Date: Mon, 24 Nov 2014 16:09:29 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH] x86: fix disabling XSAVE feature when CPUID level is capped
Message-ID: <20141124160929.153d6a0f@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the x86 XSAVE CPU feature is disabled because of capped CPUID level,
disable the dependent features the same way as the "noxsave" command line
option.

Without this fix, the raid6 code oopses in the speed test when it tries to
test the AVX functions with a capped CPUID level.

Signed-off-by: Chuck Ebbert <cebbert.lkml@gmail.com>

---

Compile tested only. I don't have an AVX-capable machine to test on.

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cfa9b5b..f668e09 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -144,15 +144,26 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
+/* CPU features that must be cleared when disabling XSAVE */
+static const u32 xsave_features[] = {
+	X86_FEATURE_XSAVE,
+	X86_FEATURE_XSAVEOPT,
+	X86_FEATURE_XSAVES,
+	X86_FEATURE_AVX,
+	X86_FEATURE_AVX2,
+	0
+};
+
 static int __init x86_xsave_setup(char *s)
 {
+	const u32 *feature;
+
 	if (strlen(s))
 		return 0;
-	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
-	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
-	setup_clear_cpu_cap(X86_FEATURE_XSAVES);
-	setup_clear_cpu_cap(X86_FEATURE_AVX);
-	setup_clear_cpu_cap(X86_FEATURE_AVX2);
+
+	for (feature = xsave_features; *feature; feature++)
+		setup_clear_cpu_cap(*feature);
+
 	return 1;
 }
 __setup("noxsave", x86_xsave_setup);
@@ -308,19 +319,39 @@ static __always_inline void setup_smap(struct cpuinfo_x86 *c)
 /*
  * Some CPU features depend on higher CPUID levels, which may not always
  * be available due to CPUID level capping or broken virtualization
- * software.  Add those features to this table to auto-disable them.
+ * software.  Add those to cpuid_dependent_features[] to auto-disable them.
+ *
+ * Disabling some features may require additional actions like disabling
+ * dependent features as well. Add functions below to do this and set
+ * clear_fn if needed.
  */
 struct cpuid_dependent_feature {
+	/* CPU feature dependent on cpuid level. */
 	u32 feature;
+
+	/* Above feature requires at least this cpuid level. */
 	u32 level;
+
+	/* Function to call instead of just disabling feature. */
+	void (*clear_fn)(struct cpuinfo_x86 *);
 };
 
+static void clear_xsave(struct cpuinfo_x86 *c)
+{
+	const u32 *feature;
+
+	for (feature = xsave_features; *feature; feature++) {
+		if (cpu_has(c, *feature))
+			clear_cpu_cap(c, *feature);
+	}
+}
+
 static const struct cpuid_dependent_feature
 cpuid_dependent_features[] = {
-	{ X86_FEATURE_MWAIT,		0x00000005 },
-	{ X86_FEATURE_DCA,		0x00000009 },
-	{ X86_FEATURE_XSAVE,		0x0000000d },
-	{ 0, 0 }
+	{ X86_FEATURE_MWAIT,		0x00000005, NULL },
+	{ X86_FEATURE_DCA,		0x00000009, NULL },
+	{ X86_FEATURE_XSAVE,		0x0000000d, clear_xsave },
+	{ 0, 0, NULL }
 };
 
 static void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
@@ -343,7 +374,11 @@ static void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
 		     (s32)df->level > (s32)c->cpuid_level))
 			continue;
 
-		clear_cpu_cap(c, df->feature);
+		if (df->clear_fn)
+			df->clear_fn(c);
+		else
+			clear_cpu_cap(c, df->feature);
+
 		if (!warn)
 			continue;
 
