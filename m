Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaDAEG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:06:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaDAEGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:06:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Artem Fetishev <artem_fetishev@epam.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.4 5/6] x86: fix boot on uniprocessor systems
Date: Mon, 31 Mar 2014 21:07:55 -0700
Message-Id: <20140401032816.580867620@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401032815.814334997@linuxfoundation.org>
References: <20140401032815.814334997@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/topology.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -157,9 +157,10 @@ static inline void setup_node_to_cpumask
 
 extern const struct cpumask *cpu_coregroup_mask(int cpu);
 
-#ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
+
+#ifdef ENABLE_TOPO_DEFINES
 #define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
 


