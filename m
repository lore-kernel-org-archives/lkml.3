Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3ITJ6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:58:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab3ITJ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:57:59 -0400
Date: Fri, 20 Sep 2013 02:57:30 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-73c4427c6ca3b32fa0441791e9c6eadceff7242f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1379400493-11505-1-git-send-email-zheng.z.yan@intel.com>
References: <1379400493-11505-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel/uncore: Don'
 t use smp_processor_id() in validate_group()
Git-Commit-ID: 73c4427c6ca3b32fa0441791e9c6eadceff7242f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 02:57:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73c4427c6ca3b32fa0441791e9c6eadceff7242f
Gitweb:     http://git.kernel.org/tip/73c4427c6ca3b32fa0441791e9c6eadceff7242f
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Tue, 17 Sep 2013 14:48:13 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 20 Sep 2013 06:54:36 +0200

perf/x86/intel/uncore: Don't use smp_processor_id() in validate_group()

uncore_validate_group() can't call smp_processor_id() because it is
in preemptible context. Pass NUMA_NO_NODE to the allocator instead.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1379400493-11505-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 8ed4458..4118f9f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2706,14 +2706,14 @@ static void uncore_pmu_init_hrtimer(struct intel_uncore_box *box)
 	box->hrtimer.function = uncore_pmu_hrtimer;
 }
 
-struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int cpu)
+static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int node)
 {
 	struct intel_uncore_box *box;
 	int i, size;
 
 	size = sizeof(*box) + type->num_shared_regs * sizeof(struct intel_uncore_extra_reg);
 
-	box = kzalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+	box = kzalloc_node(size, GFP_KERNEL, node);
 	if (!box)
 		return NULL;
 
@@ -3031,7 +3031,7 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
 	struct intel_uncore_box *fake_box;
 	int ret = -EINVAL, n;
 
-	fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
+	fake_box = uncore_alloc_box(pmu->type, NUMA_NO_NODE);
 	if (!fake_box)
 		return -ENOMEM;
 
@@ -3294,7 +3294,7 @@ static int uncore_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id
 	}
 
 	type = pci_uncores[UNCORE_PCI_DEV_TYPE(id->driver_data)];
-	box = uncore_alloc_box(type, 0);
+	box = uncore_alloc_box(type, NUMA_NO_NODE);
 	if (!box)
 		return -ENOMEM;
 
@@ -3499,7 +3499,7 @@ static int uncore_cpu_prepare(int cpu, int phys_id)
 			if (pmu->func_id < 0)
 				pmu->func_id = j;
 
-			box = uncore_alloc_box(type, cpu);
+			box = uncore_alloc_box(type, cpu_to_node(cpu));
 			if (!box)
 				return -ENOMEM;
 
