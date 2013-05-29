Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549Ab3E2Msu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:48:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab3E2Mss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:48:48 -0400
From: Andrew Jones <drjones@redhat.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, fenghua.yu@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] sched/x86: construct all sibling maps if smt
Date: Wed, 29 May 2013 14:48:15 +0200
Message-Id: <1369831695-11970-1-git-send-email-drjones@redhat.com>
In-Reply-To: <1369674540-10601-1-git-send-email-drjones@redhat.com>
References: <1369674540-10601-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 316ad248307fb ("sched/x86: Rewrite set_cpu_sibling_map()") broke
the construction of sibling maps, which also broke the booted_cores
accounting.

Before the rewrite, if smt was present, then each map was updated for
each smt sibling. After the rewrite only cpu_sibling_mask gets updated,
as the llc and core maps depend on 'has_mc = x86_max_cores > 1' instead.
This leads to problems with topologies like the following

(qemu -smp sockets=2,cores=1,threads=2)

processor       : 0
physical id     : 0
siblings        : 1    <= should be 2
core id         : 0
cpu cores       : 1

processor       : 1
physical id     : 0
siblings        : 1    <= should be 2
core id         : 0
cpu cores       : 0    <= should be 1

processor       : 2
physical id     : 1
siblings        : 1    <= should be 2
core id         : 0
cpu cores       : 1

processor       : 3
physical id     : 1
siblings        : 1    <= should be 2
core id         : 0
cpu cores       : 0    <= should be 1

This patch restores the former construction by defining has_mc as
(has_smt || x86_max_cores > 1). This should be fine as there were no
(has_smt && !has_mc) conditions in the context.

v2:
 - rename has_mc to has_mp now that it's not just for cores

Signed-off-by: Andrew Jones <drjones@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/smpboot.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9c73b51817e47..bfd348e993692 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -372,15 +372,15 @@ static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 
 void __cpuinit set_cpu_sibling_map(int cpu)
 {
-	bool has_mc = boot_cpu_data.x86_max_cores > 1;
 	bool has_smt = smp_num_siblings > 1;
+	bool has_mp = has_smt || boot_cpu_data.x86_max_cores > 1;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct cpuinfo_x86 *o;
 	int i;
 
 	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
 
-	if (!has_smt && !has_mc) {
+	if (!has_mp) {
 		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
 		cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
 		cpumask_set_cpu(cpu, cpu_core_mask(cpu));
@@ -394,7 +394,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		if ((i == cpu) || (has_smt && match_smt(c, o)))
 			link_mask(sibling, cpu, i);
 
-		if ((i == cpu) || (has_mc && match_llc(c, o)))
+		if ((i == cpu) || (has_mp && match_llc(c, o)))
 			link_mask(llc_shared, cpu, i);
 
 	}
@@ -406,7 +406,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	for_each_cpu(i, cpu_sibling_setup_mask) {
 		o = &cpu_data(i);
 
-		if ((i == cpu) || (has_mc && match_mc(c, o))) {
+		if ((i == cpu) || (has_mp && match_mc(c, o))) {
 			link_mask(core, cpu, i);
 
 			/*
-- 
1.8.1.4

