Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaI3Xtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:49:51 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:45839 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbaI3Xtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:49:49 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, davej@redhat.com,
        hmh@hmh.eng.br
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH] x86: Call identify_cpu() unconditionally once remove other callsites
Date: Wed,  1 Oct 2014 00:49:46 +0100
Message-Id: <1412120986-15138-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some bit-rot around cpu_detect_cache_sizes() in common.c
cpu_detect_cache_sizes() is valid for X86_32 and X86_64

AMD/Centaur/Cyrix/Transmeta currently call cpu_detect_cache_sizes()
as part of their respective initalisation routines.

cpu_detect_cache_sizes() is responsible for determining Cache/TLB size
and optionally calling into legacy_cache_size. Currently on Intel
processors this is broken.

This patch moves cpu_detect_cache_sizes() to one place in identify_cpu()
via default_init(). default_init() will therefore be called for every x86
processor unambiguously

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 arch/x86/kernel/cpu/amd.c       |  2 --
 arch/x86/kernel/cpu/centaur.c   |  2 --
 arch/x86/kernel/cpu/common.c    | 11 +++++++----
 arch/x86/kernel/cpu/cyrix.c     |  2 +-
 arch/x86/kernel/cpu/transmeta.c |  2 --
 5 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 60e5497..7406f6d 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -672,8 +672,6 @@ static void init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 >= 6)
 		set_cpu_bug(c, X86_BUG_FXSAVE_LEAK);
 
-	cpu_detect_cache_sizes(c);
-
 	/* Multi core CPU? */
 	if (c->extended_cpuid_level >= 0x80000008) {
 		amd_detect_cmp(c);
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index d8fba5c..cbbf492 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -62,8 +62,6 @@ static void init_c3(struct cpuinfo_x86 *c)
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	}
-
-	cpu_detect_cache_sizes(c);
 }
 
 enum {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b4..4770e7c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -67,9 +67,8 @@ void __init setup_cpu_local_masks(void)
 
 static void default_init(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_X86_64
 	cpu_detect_cache_sizes(c);
-#else
+
 	/* Not much we can do here... */
 	/* Check if at least it has cpuid */
 	if (c->cpuid_level == -1) {
@@ -79,11 +78,9 @@ static void default_init(struct cpuinfo_x86 *c)
 		else if (c->x86 == 3)
 			strcpy(c->x86_model_id, "386");
 	}
-#endif
 }
 
 static const struct cpu_dev default_cpu = {
-	.c_init		= default_init,
 	.c_vendor	= "Unknown",
 	.c_x86_vendor	= X86_VENDOR_UNKNOWN,
 };
@@ -874,6 +871,12 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 #endif
 
 	/*
+	 * Unconditionally call default_init to detect legacy
+	 * Cache/TLB sizes
+	 */
+	default_init(c);
+
+	/*
 	 * Vendor-specific initialization.  In this section we
 	 * canonicalize the feature flags, meaning if there are
 	 * features a certain CPU supports which CPUID doesn't
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index aaf152e..5cd1bba 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -373,7 +373,7 @@ static void init_nsc(struct cpuinfo_x86 *c)
 	/* Handle the GX (Formally known as the GX2) */
 
 	if (c->x86 == 5 && c->x86_model == 5)
-		cpu_detect_cache_sizes(c);
+		return;
 	else
 		init_cyrix(c);
 }
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 3fa0e5a..87f0835 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -25,8 +25,6 @@ static void init_transmeta(struct cpuinfo_x86 *c)
 
 	early_init_transmeta(c);
 
-	cpu_detect_cache_sizes(c);
-
 	/* Print CMS and CPU revision */
 	max = cpuid_eax(0x80860000);
 	cpu_rev = 0;
-- 
1.9.1

