Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaF0DwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:52:23 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57055 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaF0DwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:52:20 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>, rric@kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Charles.Garcia-Tobin@arm.com,
        lorenzo.pieralisi@arm.com, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v4 08/13] ARM64 / ACPI: Introduce arch_fix_phys_package_id() for cpu topology
Date: Fri, 27 Jun 2014 11:49:31 +0800
Message-Id: <1403840976-7456-9-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_fix_phys_package_id() will be called in ACPI core to use
the slot number provided by ACPI to update the physical package
id, then we can get the right value in the "physical id" field
of /proc/cpuinfo.

Reviewed-by: Grant Likely <grant.likely@linaro.org>
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

