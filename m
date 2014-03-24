Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaCXLAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:00:55 -0400
Received: from owamsq.epam.com ([217.21.63.36]:14938 "EHLO
	EVBYMINSA0101.epam.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaCXLAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:00:54 -0400
Date: Tue, 25 Mar 2014 01:59:10 +0300
From: Artem Fetishev <artem_fetishev@epam.com>
To: <akpm@linux-foundation.org>, <eranian@google.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Fix boot on uniprocessor systems
Message-ID: <20140324225910.GB4937@owamsq.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.6.161.188]
X-ClientProxiedBy: EVBYMINSA0102.epam.com (10.6.110.11) To
 EPBYMINSA0001.epam.com (10.6.110.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 uniprocessor systems topology_physical_package_id() returns -1 which
causes rapl_cpu_prepare() to leave rapl_pmu variable uninitialized which leads
to GPF in rapl_pmu_init(). See arch/x86/kernel/cpu/perf_event_intel_rapl.c.

It turns out that physical_package_id and core_id can actually be retreived for
uniprocessor systems too. Enabling them also fixes rapl_pmu code.

Signed-off-by: Artem Fetishev <artem_fetishev@epam.com>
---
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index d35f24e..1306d11 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -119,9 +119,10 @@ static inline void setup_node_to_cpumask_map(void) { }
 
 extern const struct cpumask *cpu_coregroup_mask(int cpu);
 
-#ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
+
+#ifdef ENABLE_TOPO_DEFINES
 #define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #endif
