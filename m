Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaD2XgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:36:25 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:56920 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaD2XgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:36:22 -0400
X-IronPort-AV: E=Sophos;i="4.97,954,1389772800"; 
   d="scan'208";a="27289553"
From: Zi Shen Lim <zlim@broadcom.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Brown <broonie@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>
CC: Zi Shen Lim <zlim@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv3] arm64: topology: add MPIDR-based detection
Date: Tue, 29 Apr 2014 16:36:13 -0700
Message-ID: <1398814573-27389-1-git-send-email-zlim@broadcom.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create cpu topology based on MPIDR. When hardware sets MPIDR to sane
values, this method will always work. Therefore it should also work well
as the fallback method. [1]

When we have multiple processing elements in the system, we create
the cpu topology by mapping each affinity level (from lowest to highest)
to threads (if they exist), cores, and clusters.

We combine data from all higher affinity levels into cluster_id
so we don't lose any information from MPIDR. [2]

[1] http://www.spinics.net/lists/arm-kernel/msg317445.html
[2] https://lkml.org/lkml/2014/4/23/703

Signed-off-by: Zi Shen Lim <zlim@broadcom.com>
---
v1->v2: Addressed comments from Mark Brown.
 - Reduce noise. Use pr_debug instead of pr_info.
 - Don't ignore higher affinity levels.

v2->v3: Addressed comments from Lorenzo Pieralisi.
 - Rebased on top of Mark Brown's DT topology series.
 - Make MPIDR fallback option.
 - Fixed usage of mpidr_hash.shift_aff. Please review :)

Tested on my multi-core multi-thread model.

 arch/arm64/include/asm/cputype.h |  5 +++++
 arch/arm64/kernel/topology.c     | 44 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index c404fb0..b3b3287 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -18,6 +18,8 @@
 
 #define INVALID_HWID		ULONG_MAX
 
+#define MPIDR_UP_BITMASK	(0x1 << 30)
+#define MPIDR_MT_BITMASK	(0x1 << 24)
 #define MPIDR_HWID_BITMASK	0xff00ffffff
 
 #define MPIDR_LEVEL_BITS_SHIFT	3
@@ -30,6 +32,9 @@
 #define MPIDR_AFFINITY_LEVEL(mpidr, level) \
 	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK)
 
+#define MPIDR_AFF_MASK(level) \
+	((u64)MPIDR_LEVEL_MASK << MPIDR_LEVEL_SHIFT(level))
+
 #define read_cpuid(reg) ({						\
 	u64 __val;							\
 	asm("mrs	%0, " #reg : "=r" (__val));			\
diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index caf2a7c..cfaa2a3 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -21,6 +21,8 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
+#include <asm/cputype.h>
+#include <asm/smp_plat.h>
 #include <asm/topology.h>
 
 /*
@@ -362,9 +364,7 @@ static void update_siblings_masks(unsigned int cpuid)
 	int cpu;
 
 	if (cpuid_topo->cluster_id == -1) {
-		/*
-		 * DT does not contain topology information for this cpu.
-		 */
+		/* No topology information for this cpu ?! */
 		pr_debug("CPU%u: No topology information configured\n", cpuid);
 		return;
 	}
@@ -391,6 +391,44 @@ static void update_siblings_masks(unsigned int cpuid)
 
 void store_cpu_topology(unsigned int cpuid)
 {
+	struct cpu_topology *cpuid_topo = &cpu_topology[cpuid];
+	u64 mpidr;
+
+	if (cpuid_topo->cluster_id != -1)
+		goto topology_populated;
+
+	mpidr = read_cpuid_mpidr();
+
+	/* Create cpu topology mapping based on MPIDR. */
+	if (mpidr & MPIDR_UP_BITMASK) {
+		/* Uniprocessor system */
+		cpuid_topo->thread_id  = -1;
+		cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+		cpuid_topo->cluster_id = 0;
+	} else if (mpidr & MPIDR_MT_BITMASK) {
+		/* Multiprocessor system : Multi-threads per core */
+		cpuid_topo->thread_id  = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+		cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 1);
+		cpuid_topo->cluster_id =
+			((mpidr & MPIDR_AFF_MASK(2)) >> mpidr_hash.shift_aff[2] |
+			 (mpidr & MPIDR_AFF_MASK(3)) >> mpidr_hash.shift_aff[3])
+			>> mpidr_hash.shift_aff[1] >> mpidr_hash.shift_aff[0];
+	} else {
+		/* Multiprocessor system : Single-thread per core */
+		cpuid_topo->thread_id  = -1;
+		cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+		cpuid_topo->cluster_id =
+			((mpidr & MPIDR_AFF_MASK(1)) >> mpidr_hash.shift_aff[1] |
+			 (mpidr & MPIDR_AFF_MASK(2)) >> mpidr_hash.shift_aff[2] |
+			 (mpidr & MPIDR_AFF_MASK(3)) >> mpidr_hash.shift_aff[3])
+			>> mpidr_hash.shift_aff[0];
+	}
+
+	pr_debug("CPU%u: cluster %d core %d thread %d mpidr %llx\n",
+		 cpuid, cpuid_topo->cluster_id, cpuid_topo->core_id,
+		 cpuid_topo->thread_id, mpidr);
+
+topology_populated:
 	update_siblings_masks(cpuid);
 	update_cpu_power(cpuid);
 }
-- 
1.8.4.3

