Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaDALTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:19:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42781 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaDALTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:19:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Artem Fetishev <artem_fetishev@epam.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 125/144] x86: fix boot on uniprocessor systems
Date: Tue,  1 Apr 2014 12:15:29 +0100
Message-Id: <1396350948-29910-126-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Fetishev <artem_fetishev@epam.com>

commit 825600c0f20e595daaa7a6dd8970f84fa2a2ee57 upstream.

On x86 uniprocessor systems topology_physical_package_id() returns -1
which causes rapl_cpu_prepare() to leave rapl_pmu variable uninitialized
which leads to GPF in rapl_pmu_init().

See arch/x86/kernel/cpu/perf_event_intel_rapl.c.

It turns out that physical_package_id and core_id can actually be
retreived for uniprocessor systems too.  Enabling them also fixes
rapl_pmu code.

Signed-off-by: Artem Fetishev <artem_fetishev@epam.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/include/asm/topology.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 095b215..60bd274 100644
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
 
-- 
1.9.1

