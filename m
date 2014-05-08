Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaEHKql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:46:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaEHKqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:46:38 -0400
Date: Thu, 8 May 2014 03:44:22 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-fb2aa85564f4de35d25db022ab93640f8bb51821@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, broonie@linaro.org, torvalds@linux-foundation.org,
        peterz@infradead.org, dietmar.eggemann@arm.com,
        sudeep.karkadanagesha@arm.com, arnd@arndb.de, linux@arm.linux.org.uk,
        robh+dt@kernel.org, nico@linaro.org, vincent.guittot@linaro.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, broonie@linaro.org,
        torvalds@linux-foundation.org, dietmar.eggemann@arm.com,
        peterz@infradead.org, sudeep.karkadanagesha@arm.com, arnd@arndb.de,
        robh+dt@kernel.org, linux@arm.linux.org.uk, vincent.guittot@linaro.org,
        nico@linaro.org, tglx@linutronix.de
In-Reply-To: <1397209481-28542-6-git-send-email-vincent.guittot@linaro.org>
References: <1397209481-28542-6-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, ARM:
  Create a dedicated scheduler topology table
Git-Commit-ID: fb2aa85564f4de35d25db022ab93640f8bb51821
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

Commit-ID:  fb2aa85564f4de35d25db022ab93640f8bb51821
Gitweb:     http://git.kernel.org/tip/fb2aa85564f4de35d25db022ab93640f8bb51821
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Fri, 11 Apr 2014 11:44:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:33:52 +0200

sched, ARM: Create a dedicated scheduler topology table

Create a dedicated topology table for ARM which will create new level to
differentiate CPUs that can or not powergate independantly from others.

The patch gives an example of how to add domain that will take advantage of
SD_SHARE_POWERDOMAIN.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@linaro.org>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: tony.luck@intel.com
Cc: fenghua.yu@intel.com
Cc: schwidefsky@de.ibm.com
Cc: cmetcalf@tilera.com
Cc: benh@kernel.crashing.org
Cc: preeti@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/1397209481-28542-6-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/kernel/topology.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 0bc94b1..71e1fec 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -185,6 +185,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	return &cpu_topology[cpu].core_sibling;
 }
 
+/*
+ * The current assumption is that we can power gate each core independently.
+ * This will be superseded by DT binding once available.
+ */
+const struct cpumask *cpu_corepower_mask(int cpu)
+{
+	return &cpu_topology[cpu].thread_sibling;
+}
+
 static void update_siblings_masks(unsigned int cpuid)
 {
 	struct cputopo_arm *cpu_topo, *cpuid_topo = &cpu_topology[cpuid];
@@ -266,6 +275,20 @@ void store_cpu_topology(unsigned int cpuid)
 		cpu_topology[cpuid].socket_id, mpidr);
 }
 
+static inline const int cpu_corepower_flags(void)
+{
+	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
+}
+
+static struct sched_domain_topology_level arm_topology[] = {
+#ifdef CONFIG_SCHED_MC
+	{ cpu_corepower_mask, cpu_corepower_flags, SD_INIT_NAME(GMC) },
+	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
+#endif
+	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ NULL, },
+};
+
 /*
  * init_cpu_topology is called at boot when only one cpu is running
  * which prevent simultaneous write access to cpu_topology array
@@ -289,4 +312,7 @@ void __init init_cpu_topology(void)
 	smp_wmb();
 
 	parse_dt_topology();
+
+	/* Set scheduler topology descriptor */
+	set_sched_topology(arm_topology);
 }
