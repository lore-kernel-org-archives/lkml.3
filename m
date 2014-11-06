Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaKFWoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:44:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59098 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbaKFWoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:09 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 029/162] sparc64: Fix pcr_ops initialization and usage bugs.
Date: Thu,  6 Nov 2014 14:34:53 -0800
Message-Id: <1415313426-9622-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 8bccf5b313180faefce38e0d1140f76e0f327d28 ]

Christopher reports that perf_event_print_debug() can crash in uniprocessor
builds.  The crash is due to pcr_ops being NULL.

This happens because pcr_arch_init() is only invoked by smp_cpus_done() which
only executes in SMP builds.

init_hw_perf_events() is closely intertwined with pcr_ops being setup properly,
therefore:

1) Call pcr_arch_init() early on from init_hw_perf_events(), instead of
   from smp_cpus_done().

2) Do not hook up a PMU type if pcr_ops is NULL after pcr_arch_init().

3) Move init_hw_perf_events to a later initcall so that it we will be
   sure to invoke pcr_arch_init() after all cpus are brought up.

Finally, guard the one naked sequence of pcr_ops dereferences in
__global_pmu_self() with an appropriate NULL check.

Reported-by: Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/kernel/perf_event.c | 7 +++++--
 arch/sparc/kernel/process_64.c | 3 +++
 arch/sparc/kernel/smp_64.c     | 1 -
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index b5c38fa..857baca 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1671,9 +1671,12 @@ static bool __init supported_pmu(void)
 
 int __init init_hw_perf_events(void)
 {
+	int err;
+
 	pr_info("Performance events: ");
 
-	if (!supported_pmu()) {
+	err = pcr_arch_init();
+	if (err || !supported_pmu()) {
 		pr_cont("No support for PMU type '%s'\n", sparc_pmu_type);
 		return 0;
 	}
@@ -1685,7 +1688,7 @@ int __init init_hw_perf_events(void)
 
 	return 0;
 }
-early_initcall(init_hw_perf_events);
+pure_initcall(init_hw_perf_events);
 
 void perf_callchain_kernel(struct perf_callchain_entry *entry,
 			   struct pt_regs *regs)
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index d7b4967..c6f7113 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -306,6 +306,9 @@ static void __global_pmu_self(int this_cpu)
 	struct global_pmu_snapshot *pp;
 	int i, num;
 
+	if (!pcr_ops)
+		return;
+
 	pp = &global_cpu_snapshot[this_cpu].pmu;
 
 	num = 1;
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 8416d7f..8311f3d 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1395,7 +1395,6 @@ void __cpu_die(unsigned int cpu)
 
 void __init smp_cpus_done(unsigned int max_cpus)
 {
-	pcr_arch_init();
 }
 
 void smp_send_reschedule(int cpu)
-- 
1.9.1

