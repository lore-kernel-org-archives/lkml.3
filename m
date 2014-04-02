Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbaDBUON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:14:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42905 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758957AbaDBUNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Artem Fetishev <artem_fetishev@epam.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 35/40] x86: fix boot on uniprocessor systems
Date: Wed,  2 Apr 2014 22:13:21 +0200
Message-Id: <1bcde16c665590f2277b7241f1a27b9ef66faec9.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Fetishev <artem_fetishev@epam.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/topology.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index d35f24e231cd..1306d117967d 100644
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
-- 
1.9.1

