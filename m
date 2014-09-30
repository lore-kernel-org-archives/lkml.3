Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaI3DMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:12:41 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:60625 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755239AbaI3DL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:11:56 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: mingo@redhat.com, davej@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        hmh@hmh.eng.br, x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH 1/3] x86: Bugfix bit-rot in the calling of legacy_cache_size
Date: Tue, 30 Sep 2014 04:11:48 +0100
Message-Id: <1412046710-2686-2-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie>
References: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

legacy_cache_size is used by certain processors to report the
size of cache. Currently only X86_VENDOR_UNKNOWN could call
default_init() => cpu_detect_cache_sizes() => legacy_cache_size()

Make an update to identify_cpu to make an explicit call to default_init()
We want to do this since some processors that report vendor strings via
cpuid also want to run legacy_cache_size callbacks - which won't happen
since init_intel() init_amd() and friends take the place of default_init()
and don't themselves make explicit calls to legacy_cache_size.

Also current code has an
#ifdef CONFIG_X86_64
        cpu_detect_cache_sizes(c);
#endif

where cpu_detect_cache_sizes calls legacy_cache_size(); is typically
defined inside of a CONFIG_X86_32
#ifdef CONFIG_X86_32
        .legacy_cache_size = centaur_size_cache,
#endif
#ifdef CONFIG_X86_32
	.legacy_cache_size = intel_size_cache,
#endif
#ifdef CONFIG_X86_32
        .legacy_cache_size = amd_size_cache,
#endif

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 arch/x86/kernel/cpu/common.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b4..53a33fa 100644
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
@@ -79,7 +78,6 @@ static void default_init(struct cpuinfo_x86 *c)
 		else if (c->x86 == 3)
 			strcpy(c->x86_model_id, "386");
 	}
-#endif
 }
 
 static const struct cpu_dev default_cpu = {
@@ -874,6 +872,15 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 #endif
 
 	/*
+	 * If c_x86_vendor != X86_VENDOR_UNKNOWN i.e. a known vendor then
+	 * there's a vendor specific c_init()
+	 *
+	 * Even still Intel, AMD and VIA make use of legacy_cache_size which
+	 * is reachable only through default_init right now
+	 */
+	if (this_cpu->c_x86_vendor != X86_VENDOR_UNKNOWN)
+		default_init(c);
+	/*
 	 * Vendor-specific initialization.  In this section we
 	 * canonicalize the feature flags, meaning if there are
 	 * features a certain CPU supports which CPUID doesn't
-- 
1.9.1

