Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3KRUbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:31:53 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:53442 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3KRUbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:31:24 -0500
From: Elena Ufimtseva <ufimtseva@gmail.com>
To: xen-devel@lists.xenproject.org
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        linux-kernel@vger.kernel.org, Elena Ufimtseva <ufimtseva@gmail.com>
Subject: [PATCH v2 1/2] xen: vnuma support for PV guests running as domU
Date: Mon, 18 Nov 2013 15:25:49 -0500
Message-Id: <1384806350-12651-2-git-send-email-ufimtseva@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issues Xen hypercall subop XENMEM_get_vnumainfo and sets the
NUMA topology, otherwise sets dummy NUMA node and prevents
numa_init from calling other numa initializators as they dont
work with pv guests.

Signed-off-by: Elena Ufimtseva <ufimtseva@gmail.com>
---
 arch/x86/include/asm/xen/vnuma.h |   12 ++++
 arch/x86/mm/numa.c               |    3 +
 arch/x86/xen/Makefile            |    2 +-
 arch/x86/xen/vnuma.c             |  127 ++++++++++++++++++++++++++++++++++++++
 include/xen/interface/memory.h   |   44 +++++++++++++
 5 files changed, 187 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/xen/vnuma.h
 create mode 100644 arch/x86/xen/vnuma.c

diff --git a/arch/x86/include/asm/xen/vnuma.h b/arch/x86/include/asm/xen/vnuma.h
new file mode 100644
index 0000000..aee4e92
--- /dev/null
+++ b/arch/x86/include/asm/xen/vnuma.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_X86_VNUMA_H
+#define _ASM_X86_VNUMA_H
+
+#ifdef CONFIG_XEN
+bool xen_vnuma_supported(void);
+int xen_numa_init(void);
+#else
+static inline bool xen_vnuma_supported(void) { return false; };
+static inline int xen_numa_init(void) { return -1; };
+#endif
+
+#endif /* _ASM_X86_VNUMA_H */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 24aec58..99efa1b 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -17,6 +17,7 @@
 #include <asm/dma.h>
 #include <asm/acpi.h>
 #include <asm/amd_nb.h>
+#include "asm/xen/vnuma.h"
 
 #include "numa_internal.h"
 
@@ -632,6 +633,8 @@ static int __init dummy_numa_init(void)
 void __init x86_numa_init(void)
 {
 	if (!numa_off) {
+		if (!numa_init(xen_numa_init))
+			return;
 #ifdef CONFIG_X86_NUMAQ
 		if (!numa_init(numaq_numa_init))
 			return;
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 96ab2c0..de9deab 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -13,7 +13,7 @@ CFLAGS_mmu.o			:= $(nostackp)
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm.o xen-asm_$(BITS).o \
 			grant-table.o suspend.o platform-pci-unplug.o \
-			p2m.o
+			p2m.o vnuma.o
 
 obj-$(CONFIG_EVENT_TRACING) += trace.o
 
diff --git a/arch/x86/xen/vnuma.c b/arch/x86/xen/vnuma.c
new file mode 100644
index 0000000..bce4523
--- /dev/null
+++ b/arch/x86/xen/vnuma.c
@@ -0,0 +1,127 @@
+#include <linux/err.h>
+#include <linux/memblock.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/memory.h>
+#include <asm/xen/interface.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/vnuma.h>
+
+#ifdef CONFIG_NUMA
+
+/* Checks if hypercall is supported */
+bool xen_vnuma_supported()
+{
+	return HYPERVISOR_memory_op(XENMEM_get_vnuma_info, NULL) == -ENOSYS ? false : true;
+}
+
+/* 
+ * Called from numa_init if numa_off = 0;
+ * we set numa_off = 0 if xen_vnuma_supported()
+ * returns true and its a domU;
+ */
+int __init xen_numa_init(void)
+{
+	int rc;
+	unsigned int i, j, nr_nodes, cpu, idx, pcpus;
+	u64 physm, physd, physc;
+	unsigned int *vdistance, *cpu_to_node;
+	unsigned long mem_size, dist_size, cpu_to_node_size;
+	struct vmemrange *vblock;
+
+	struct vnuma_topology_info numa_topo = {
+		.domid = DOMID_SELF,
+		.__pad = 0
+	};
+	rc = -EINVAL;
+	physm = physd = physc = 0;
+
+	/* For now only PV guests are supported */
+	if (!xen_pv_domain())
+		return rc;
+
+	pcpus = num_possible_cpus();
+
+	mem_size =  pcpus * sizeof(struct vmemrange);
+	dist_size = pcpus * pcpus * sizeof(*numa_topo.distance);
+	cpu_to_node_size = pcpus * sizeof(*numa_topo.cpu_to_node);
+
+	physm = memblock_alloc(mem_size, PAGE_SIZE);
+	vblock = __va(physm);
+
+	physd = memblock_alloc(dist_size, PAGE_SIZE);
+	vdistance  = __va(physd);
+
+	physc = memblock_alloc(cpu_to_node_size, PAGE_SIZE);
+	cpu_to_node  = __va(physc);
+
+	if (!physm || !physc || !physd)
+		goto out;
+
+	set_xen_guest_handle(numa_topo.nr_nodes, &nr_nodes);
+	set_xen_guest_handle(numa_topo.memrange, vblock);
+	set_xen_guest_handle(numa_topo.distance, vdistance);
+	set_xen_guest_handle(numa_topo.cpu_to_node, cpu_to_node);
+
+	rc = HYPERVISOR_memory_op(XENMEM_get_vnuma_info, &numa_topo);
+
+	if (rc < 0)
+		goto out;
+	nr_nodes = *numa_topo.nr_nodes; 
+	if (nr_nodes == 0) {
+		goto out;
+	}
+	if (nr_nodes > num_possible_cpus()) {
+		pr_debug("vNUMA: Node without cpu is not supported in this version.\n");
+		goto out;
+	}
+
+	/*
+	 * NUMA nodes memory ranges are in pfns, constructed and
+	 * aligned based on e820 ram domain map.
+	 */
+	for (i = 0; i < nr_nodes; i++) {
+		if (numa_add_memblk(i, vblock[i].start, vblock[i].end))
+			goto out;
+		node_set(i, numa_nodes_parsed);
+	}
+
+	setup_nr_node_ids();
+	/* Setting the cpu, apicid to node */
+	for_each_cpu(cpu, cpu_possible_mask) {
+		set_apicid_to_node(cpu, cpu_to_node[cpu]);
+		numa_set_node(cpu, cpu_to_node[cpu]);
+		cpumask_set_cpu(cpu, node_to_cpumask_map[cpu_to_node[cpu]]);
+	}
+
+	for (i = 0; i < nr_nodes; i++) {
+		for (j = 0; j < *numa_topo.nr_nodes; j++) {
+			idx = (j * nr_nodes) + i;
+			numa_set_distance(i, j, *(vdistance + idx));
+		}
+	}
+
+	rc = 0;
+out:
+	if (physm)
+		memblock_free(__pa(physm), mem_size);
+	if (physd)
+		memblock_free(__pa(physd), dist_size);
+	if (physc)
+		memblock_free(__pa(physc), cpu_to_node_size);
+	/*
+	 * Set a dummy node and return success.  This prevents calling any
+	 * hardware-specific initializers which do not work in a PV guest.
+	 * Taken from dummy_numa_init code.
+	 */
+	if (rc != 0) {
+		for (i = 0; i < MAX_LOCAL_APIC; i++)
+			set_apicid_to_node(i, NUMA_NO_NODE);
+		nodes_clear(numa_nodes_parsed);
+		nodes_clear(node_possible_map);
+		nodes_clear(node_online_map);
+		node_set(0, numa_nodes_parsed);
+		numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
+	}
+	return 0;
+}
+#endif
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index 2ecfe4f..b61482c 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -263,4 +263,48 @@ struct xen_remove_from_physmap {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
 
+/* vNUMA structures */
+struct vmemrange {
+	uint64_t start, end;
+	/* reserved */
+	uint64_t _padm;
+};
+DEFINE_GUEST_HANDLE_STRUCT(vmemrange);
+
+struct vnuma_topology_info {
+	/* OUT */
+	domid_t domid;
+	uint32_t __pad;
+	/* IN */
+	/* number of virtual numa nodes */
+	union {
+		GUEST_HANDLE(uint) nr_nodes;
+		uint64_t    _padn;
+	};
+	/* distance table */
+	union {
+		GUEST_HANDLE(uint) distance;
+		uint64_t    _padd;
+	};
+	/* cpu mapping to vnodes */
+	union {
+		GUEST_HANDLE(uint) cpu_to_node;
+		uint64_t    _padc;
+	};
+	/*
+	* memory areas constructed by Xen, start and end
+	* of the ranges are specific to domain e820 map.
+	* Xen toolstack constructs these ranges for domain
+	* when building it.
+	*/
+	union {
+		GUEST_HANDLE(vmemrange) memrange;
+		uint64_t    _padm;
+	};
+};
+typedef struct vnuma_topology_info vnuma_topology_info_t;
+DEFINE_GUEST_HANDLE_STRUCT(vnuma_topology_info);
+
+#define XENMEM_get_vnuma_info	25
+
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
-- 
1.7.10.4

