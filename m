Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbaGXNBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:01:35 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52566 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759057AbaGXNBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:01:30 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 04/19] ARM64 / ACPI: Introduce arch_fix_phys_package_id() for cpu topology
Date: Thu, 24 Jul 2014 21:00:10 +0800
Message-Id: <1406206825-15590-5-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_fix_phys_package_id() will be called in ACPI core to use
the slot number provided by ACPI to update the physical package
id, then we can get the right value in the "physical id" field
of /proc/cpuinfo.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/topology.h |    2 ++
 arch/arm64/kernel/topology.c      |   14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/topology.h b/arch/arm64/include/asm/topology.h
index 7ebcd31..2b216d4 100644
--- a/arch/arm64/include/asm/topology.h
+++ b/arch/arm64/include/asm/topology.h
@@ -23,11 +23,13 @@ extern struct cpu_topology cpu_topology[NR_CPUS];
 void init_cpu_topology(void);
 void store_cpu_topology(unsigned int cpuid);
 const struct cpumask *cpu_coregroup_mask(int cpu);
+void arch_fix_phys_package_id(int num, u32 slot);
 
 #else
 
 static inline void init_cpu_topology(void) { }
 static inline void store_cpu_topology(unsigned int cpuid) { }
+static inline void arch_fix_phys_package_id(int num, u32 slot) { }
 
 #endif
 
diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 43514f9..c547885 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -281,3 +281,17 @@ void __init init_cpu_topology(void)
 	if (parse_dt_topology())
 		reset_cpu_topology();
 }
+
+/*
+ * Use the CPU slot number provided by ACPI to update the physical
+ * package id when cpuid_topo->cluster_id is not available, then we
+ * can get the right value in the "physical id" field of /proc/cpuinfo.
+ */
+void arch_fix_phys_package_id(int num, u32 slot)
+{
+	struct cpu_topology *cpuid_topo = &cpu_topology[num];
+
+	if (cpuid_topo->cluster_id == -1)
+		cpuid_topo->cluster_id = slot;
+}
+EXPORT_SYMBOL_GPL(arch_fix_phys_package_id);
-- 
1.7.9.5

