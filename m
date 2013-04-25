Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab3DYRZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:25:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59264 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759003Ab3DYRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:24:59 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org, corbet@lwn.net,
        l.majewski@samsung.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 05/14] ARM: sched: clear SD_SHARE_POWERDOMAIN
Date: Thu, 25 Apr 2013 19:23:21 +0200
Message-Id: <1366910611-20048-6-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM platforms take advantage of packing small tasks on few cores.
This is true even when the cores of a cluster can't be power gated
independantly. So we clear SD_SHARE_POWERDOMAIN at MC and CPU level.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 arch/arm/kernel/topology.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 79282eb..f89a4a2 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -201,6 +201,15 @@ static inline void update_cpu_power(unsigned int cpuid, unsigned int mpidr) {}
  */
 struct cputopo_arm cpu_topology[NR_CPUS];
 
+int arch_sd_local_flags(int level)
+{
+	/* Powergate at threading level doesn't make sense */
+	if (level & SD_SHARE_CPUPOWER)
+		return 1*SD_SHARE_POWERDOMAIN;
+
+	return 0*SD_SHARE_POWERDOMAIN;
+}
+
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
 	return &cpu_topology[cpu].core_sibling;
-- 
1.7.9.5

