Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3EaMuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:50:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57996 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3EaMur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:50:47 -0400
Date: Fri, 31 May 2013 05:50:12 -0700
From: tip-bot for Andrew Jones <tipbot@zytor.com>
Message-ID: <tip-b0bc225d0e5de887340d4d92a8c594ef0f60d412@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        drjones@redhat.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        drjones@redhat.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1369831695-11970-1-git-send-email-drjones@redhat.com>
References: <1369831695-11970-1-git-send-email-drjones@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/x86: Construct all sibling maps if smt
Git-Commit-ID: b0bc225d0e5de887340d4d92a8c594ef0f60d412
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

Commit-ID:  b0bc225d0e5de887340d4d92a8c594ef0f60d412
Gitweb:     http://git.kernel.org/tip/b0bc225d0e5de887340d4d92a8c594ef0f60d412
Author:     Andrew Jones <drjones@redhat.com>
AuthorDate: Wed, 29 May 2013 14:48:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 31 May 2013 13:10:38 +0200

sched/x86: Construct all sibling maps if smt

Commit 316ad248307fb ("sched/x86: Rewrite
set_cpu_sibling_map()") broke the construction of sibling maps,
which also broke the booted_cores accounting.

Before the rewrite, if smt was present, then each map was
updated for each smt sibling. After the rewrite only
cpu_sibling_mask gets updated, as the llc and core maps depend
on 'has_mc = x86_max_cores > 1' instead. This leads to problems
with topologies like the following

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

This patch restores the former construction by defining has_mc
as (has_smt || x86_max_cores > 1). This should be fine as there
were no (has_smt && !has_mc) conditions in the context.

Aso rename has_mc to has_mp now that it's not just for cores.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: a.p.zijlstra@chello.nl
Cc: fenghua.yu@intel.com
Link: http://lkml.kernel.org/r/1369831695-11970-1-git-send-email-drjones@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9c73b51..bfd348e 100644
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
