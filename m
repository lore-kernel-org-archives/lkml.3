Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3E0RJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:09:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab3E0RJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:09:19 -0400
From: Andrew Jones <drjones@redhat.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, fenghua.yu@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched/x86: construct all sibling maps if smt
Date: Mon, 27 May 2013 19:09:00 +0200
Message-Id: <1369674540-10601-1-git-send-email-drjones@redhat.com>
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

processor	: 0
physical id	: 0
siblings	: 1    <= should be 2
core id		: 0
cpu cores	: 1

processor	: 1
physical id	: 0
siblings	: 1    <= should be 2
core id		: 0
cpu cores	: 0    <= should be 1

processor	: 2
physical id	: 1
siblings	: 1    <= should be 2
core id		: 0
cpu cores	: 1

processor	: 3
physical id	: 1
siblings	: 1    <= should be 2
core id		: 0
cpu cores	: 0    <= should be 1

This patch restores the former construction by defining has_mc as
(has_smt || x86_max_cores > 1). This should be fine as there were no
(has_smt && !has_mc) conditions in the context.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/x86/kernel/smpboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9c73b51817e47..886a3234eaff3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -372,15 +372,15 @@ static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 
 void __cpuinit set_cpu_sibling_map(int cpu)
 {
-	bool has_mc = boot_cpu_data.x86_max_cores > 1;
 	bool has_smt = smp_num_siblings > 1;
+	bool has_mc = has_smt || boot_cpu_data.x86_max_cores > 1;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct cpuinfo_x86 *o;
 	int i;
 
 	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
 
-	if (!has_smt && !has_mc) {
+	if (!has_mc) {
 		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
 		cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
 		cpumask_set_cpu(cpu, cpu_core_mask(cpu));
-- 
1.8.1.4

