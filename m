Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3KNDly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 22:41:54 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:54167 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3KNDlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 22:41:20 -0500
From: Elena Ufimtseva <ufimtseva@gmail.com>
To: xen-devel@lists.xenproject.org
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        linux-kernel@vger.kernel.org, Elena Ufimtseva <ufimtseva@gmail.com>
Subject: [PATCH 1/2] xen: vnuma support for PV guests running as domU.
Date: Wed, 13 Nov 2013 22:36:18 -0500
Message-Id: <1384400179-24404-2-git-send-email-ufimtseva@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1384400179-24404-1-git-send-email-ufimtseva@gmail.com>
References: <1384400179-24404-1-git-send-email-ufimtseva@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issues Xen hypercall subop XENMEM_get_vnumainfo and sets the
NUMA topology, otherwise sets dummy NUMA node and prevents
numa_init from calling other numa initializators as they may
break other guests.

Signed-off-by: Elena Ufimtseva <ufimtseva@gmail.com>
---
 arch/x86/include/asm/xen/vnuma.h |   12 ++++
 arch/x86/mm/numa.c               |    5 ++
 arch/x86/xen/Makefile            |    2 +-
 arch/x86/xen/vnuma.c             |  119 ++++++++++++++++++++++++++++++++++++++
 include/xen/interface/memory.h   |   28 +++++++++
 5 files changed, 165 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/xen/vnuma.h
 create mode 100644 arch/x86/xen/vnuma.c

diff --git a/arch/x86/include/asm/xen/vnuma.h b/arch/x86/include/asm/xen/vnuma.h
new file mode 100644
index 0000000..1ba1e06
--- /dev/null
+++ b/arch/x86/include/asm/xen/vnuma.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_X86_VNUMA_H
+#define _ASM_X86_VNUMA_H
+
+#ifdef CONFIG_XEN
+int xen_vnuma_supported(void);
+int xen_numa_init(void);
+#else
+int xen_vnuma_supported(void) { return 0; };
+int xen_numa_init(void) { return -1; };
+#endif
+
+#endif /* _ASM_X86_VNUMA_H */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 8bf93ba..c8a61dc 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -19,6 +19,7 @@
 #include <asm/amd_nb.h>
 
 #include "numa_internal.h"
+#include "asm/xen/vnuma.h"
 
 int __initdata numa_off;
 nodemask_t numa_nodes_parsed __initdata;
@@ -621,6 +622,10 @@ static int __init dummy_numa_init(void)
 void __init x86_numa_init(void)
 {
 	if (!numa_off) {
+#ifdef CONFIG_XEN
+		if (xen_vnuma_supported() && !numa_init(xen_numa_init))
+			return;
+#endif
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
index 0000000..b4fc667
--- /dev/null
+++ b/arch/x86/xen/vnuma.c
@@ -0,0 +1,119 @@
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
+/* Checks if hypercall is suported */
+int xen_vnuma_supported()
+{
+	return HYPERVISOR_memory_op(XENMEM_get_vnuma_info, NULL) == -ENOSYS ? 0 : 1;
+}
+
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
+
+	/* For now only PV guests are supported */
+	if (!xen_pv_domain())
+		return rc;
+
+	pcpus = num_possible_cpus();
+
+	mem_size =  pcpus * sizeof(struct vmemrange);
+	dist_size = pcpus * pcpus * sizeof(*numa_topo.vdistance);
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
+		goto vnumaout;
+
+	set_xen_guest_handle(numa_topo.nr_nodes, &nr_nodes);
+	set_xen_guest_handle(numa_topo.vmemblks, vblock);
+	set_xen_guest_handle(numa_topo.vdistance, vdistance);
+	set_xen_guest_handle(numa_topo.cpu_to_node, cpu_to_node);
+
+	rc = HYPERVISOR_memory_op(XENMEM_get_vnuma_info, &numa_topo);
+
+	if (rc < 0)
+		goto vnumaout;
+	if (*numa_topo.nr_nodes == 0) {
+		/* will pass to dummy_numa_init */
+		goto vnumaout;
+	}
+	if (*numa_topo.nr_nodes > num_possible_cpus()) {
+		pr_debug("vNUMA: Node without cpu is not supported in this version.\n");
+		goto vnumaout;
+	}
+	/*
+	 * NUMA nodes memory ranges are in pfns, constructed and
+	 * aligned based on e820 ram domain map.
+	 */
+	for (i = 0; i < *numa_topo.nr_nodes; i++) {
+		if (numa_add_memblk(i, vblock[i].start, vblock[i].end))
+			/* pass to numa_dummy_init */
+			goto vnumaout;
+		node_set(i, numa_nodes_parsed);
+	}
+	setup_nr_node_ids();
+	/* Setting the cpu, apicid to node */
+	for_each_cpu(cpu, cpu_possible_mask) {
+		set_apicid_to_node(cpu, cpu_to_node[cpu]);
+		numa_set_node(cpu, cpu_to_node[cpu]);
+		cpumask_set_cpu(cpu, node_to_cpumask_map[cpu_to_node[cpu]]);
+	}
+	for (i = 0; i < *numa_topo.nr_nodes; i++) {
+		for (j = 0; j < *numa_topo.nr_nodes; j++) {
+			idx = (j * *numa_topo.nr_nodes) + i;
+			numa_set_distance(i, j, *(vdistance + idx));
+		}
+	}
+	rc = 0;
+vnumaout:
+	if (physm)
+		memblock_free(__pa(physm), mem_size);
+	if (physd)
+		memblock_free(__pa(physd), dist_size);
+	if (physc)
+		memblock_free(__pa(physc), cpu_to_node_size);
+	/*
+	 * Set the "dummy" node and exit without error so Linux
+	 * will not try any NUMA init functions which might break
+	 * guests in the future. This will discard all previous
+	 * settings.
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
index 2ecfe4f..3974e9a 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -263,4 +263,32 @@ struct xen_remove_from_physmap {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
 
+/* vNUMA structures */
+struct vmemrange {
+	uint64_t start, end;
+	struct vmemrange *next;
+};
+DEFINE_GUEST_HANDLE_STRUCT(vmemrange);
+
+struct vnuma_topology_info {
+	/* OUT */
+	domid_t domid;
+	uint32_t __pad;
+	/* IN */
+	GUEST_HANDLE(uint) nr_nodes; /* number of virtual numa nodes */
+	/* distance table */
+	GUEST_HANDLE(uint) vdistance;
+	/* cpu mapping to vnodes */
+	GUEST_HANDLE(uint) cpu_to_node;
+	/*
+	* array of numa memory areas constructed by Xen
+	* where start and end are pfn numbers of the area
+	* Xen takes into account domains e820 map
+	*/
+	GUEST_HANDLE(vmemrange) vmemblks;
+};
+DEFINE_GUEST_HANDLE_STRUCT(vnuma_topology_info);
+
+#define XENMEM_get_vnuma_info	25
+
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
-- 
1.7.10.4

