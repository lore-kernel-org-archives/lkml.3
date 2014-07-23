Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbaGWPkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:40:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023AbaGWPky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:40:54 -0400
Date: Wed, 23 Jul 2014 08:39:24 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-2a2261553dd1472ca574acadbd93e12f44c4e6d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dietmar.eggemann@arm.com, peterz@infradead.org, jwboyer@redhat.com,
        bruno@wolff.to, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, dietmar.eggemann@arm.com, jwboyer@redhat.com,
        bruno@wolff.to, tglx@linutronix.de
In-Reply-To: <20140722133514.GM12054@laptop.lan>
References: <20140722133514.GM12054@laptop.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, cpu: Fix cache topology for early P4-SMT
Git-Commit-ID: 2a2261553dd1472ca574acadbd93e12f44c4e6d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a2261553dd1472ca574acadbd93e12f44c4e6d5
Gitweb:     http://git.kernel.org/tip/2a2261553dd1472ca574acadbd93e12f44c4e6d5
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 22 Jul 2014 15:35:14 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 23 Jul 2014 08:16:17 -0700

x86, cpu: Fix cache topology for early P4-SMT

P4 systems with cpuid level < 4 can have SMT, but the cache topology
description available (cpuid2) does not include SMP information.

Now we know that SMT shares all cache levels, and therefore we can
mark all available cache levels as shared.

We do this by setting cpu_llc_id to ->phys_proc_id, since that's
the same for each SMT thread. We can do this unconditional since if
there's no SMT its still true, the one CPU shares cache with only
itself.

This fixes a problem where such CPUs report an incorrect LLC CPU mask.

This in turn fixes a crash in the scheduler where the topology was
build wrong, it assumes the LLC mask to include at least the SMT CPUs.

Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Bruno Wolff III <bruno@wolff.to>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140722133514.GM12054@laptop.lan
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/intel.c           | 22 +++++++++++-----------
 arch/x86/kernel/cpu/intel_cacheinfo.c | 12 ++++++++++++
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index a800290..f9e4fdd 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -370,6 +370,17 @@ static void init_intel(struct cpuinfo_x86 *c)
 	 */
 	detect_extended_topology(c);
 
+	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
+		/*
+		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
+		 * detection.
+		 */
+		c->x86_max_cores = intel_num_cpu_cores(c);
+#ifdef CONFIG_X86_32
+		detect_ht(c);
+#endif
+	}
+
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9) {
 		unsigned eax = cpuid_eax(10);
@@ -438,17 +449,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_P3);
 #endif
 
-	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
-		/*
-		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
-		 * detection.
-		 */
-		c->x86_max_cores = intel_num_cpu_cores(c);
-#ifdef CONFIG_X86_32
-		detect_ht(c);
-#endif
-	}
-
 	/* Work around errata */
 	srat_detect_node(c);
 
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index a952e9c..9c8f739 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -730,6 +730,18 @@ unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c)
 #endif
 	}
 
+#ifdef CONFIG_X86_HT
+	/*
+	 * If cpu_llc_id is not yet set, this means cpuid_level < 4 which in
+	 * turns means that the only possibility is SMT (as indicated in
+	 * cpuid1). Since cpuid2 doesn't specify shared caches, and we know
+	 * that SMT shares all caches, we can unconditionally set cpu_llc_id to
+	 * c->phys_proc_id.
+	 */
+	if (per_cpu(cpu_llc_id, cpu) == BAD_APICID)
+		per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
+#endif
+
 	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
 
 	return l2;
