Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaDWBkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:40:52 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:21916 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaDWBk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:40:29 -0400
X-IronPort-AV: E=Sophos;i="4.97,908,1389772800"; 
   d="scan'208";a="25836718"
From: Zi Shen Lim <zlim@broadcom.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Brown <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Zi Shen Lim <zlim@broadcom.com>
Subject: [PATCH 2/2] arm64: topology: add MPIDR-based detection
Date: Tue, 22 Apr 2014 18:40:14 -0700
Message-ID: <1398217214-12204-3-git-send-email-zlim@broadcom.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1398217214-12204-1-git-send-email-zlim@broadcom.com>
References: <1398217214-12204-1-git-send-email-zlim@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create cpu topology based on MPIDR. When hardware sets MPIDR to sane
values, this method will always work. Therefore it should also work well
as the fallback method. [1]

[1] http://www.spinics.net/lists/arm-kernel/msg317445.html

Signed-off-by: Zi Shen Lim <zlim@broadcom.com>
---
 arch/arm64/include/asm/cputype.h |  2 ++
 arch/arm64/kernel/topology.c     | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index c404fb0..7639e8b 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -18,6 +18,8 @@
 
 #define INVALID_HWID		ULONG_MAX
 
+#define MPIDR_UP_BITMASK	(0x1 << 30)
+#define MPIDR_MT_BITMASK	(0x1 << 24)
 #define MPIDR_HWID_BITMASK	0xff00ffffff
 
 #define MPIDR_LEVEL_BITS_SHIFT	3
diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 3e06b0b..ef3bb7e 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -19,6 +19,7 @@
 #include <linux/nodemask.h>
 #include <linux/sched.h>
 
+#include <asm/cputype.h>
 #include <asm/topology.h>
 
 /*
@@ -71,6 +72,36 @@ static void update_siblings_masks(unsigned int cpuid)
 
 void store_cpu_topology(unsigned int cpuid)
 {
+	struct cpu_topology *cpuid_topo = &cpu_topology[cpuid];
+	u64 mpidr;
+
+	mpidr = read_cpuid_mpidr();
+
+	/* Create cpu topology mapping based on MPIDR. */
+	if (mpidr & MPIDR_UP_BITMASK) {
+		/* Uniprocessor system */
+		cpuid_topo->thread_id  = -1;
+		cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+		cpuid_topo->cluster_id = -1;
+	} else {
+		/* Multiprocessor system */
+		if (mpidr & MPIDR_MT_BITMASK) {
+			/* Multi-threads per core */
+			cpuid_topo->thread_id  = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+			cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 1);
+			cpuid_topo->cluster_id = MPIDR_AFFINITY_LEVEL(mpidr, 2);
+		} else {
+			/* Single-thread per core */
+			cpuid_topo->thread_id  = -1;
+			cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+			cpuid_topo->cluster_id = MPIDR_AFFINITY_LEVEL(mpidr, 1);
+		}
+	}
+
+	pr_info("CPU%u: cluster %d core %d thread %d mpidr %llx\n",
+		cpuid, cpuid_topo->cluster_id, cpuid_topo->core_id,
+		cpuid_topo->thread_id, mpidr);
+
 	update_siblings_masks(cpuid);
 }
 
-- 
1.8.4.3

