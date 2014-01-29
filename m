Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaA2SSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:18:33 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:49096 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaA2SS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:18:29 -0500
Subject: [PATCH 08/17] x86/PCI: Remove mp_bus_to_node[], set_mp_bus_to_node(),
 get_mp_bus_to_node()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 11:18:26 -0700
Message-ID: <20140129181826.15476.85192.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no callers of get_mp_bus_to_node(), so we no longer need
mp_bus_to_node[], get_mp_bus_to_node(), or set_mp_bus_to_node().
This removes them.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/include/asm/topology.h |   13 -------
 arch/x86/pci/acpi.c             |    4 +-
 arch/x86/pci/amd_bus.c          |   10 ------
 arch/x86/pci/common.c           |   69 ---------------------------------------
 4 files changed, 1 insertion(+), 95 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 09046a1a6c35..c840571afa4e 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -140,17 +140,4 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources);
 #define smt_capable()			(smp_num_siblings > 1)
 #endif
 
-#ifdef CONFIG_NUMA
-extern int get_mp_bus_to_node(int busnum);
-extern void set_mp_bus_to_node(int busnum, int node);
-#else
-static inline int get_mp_bus_to_node(int busnum)
-{
-	return 0;
-}
-static inline void set_mp_bus_to_node(int busnum, int node)
-{
-}
-#endif
-
 #endif /* _ASM_X86_TOPOLOGY_H */
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 3f42c5c05bf6..78f27efa11e1 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -499,10 +499,8 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	pxm = acpi_get_pxm(device->handle);
 	if (pxm >= 0)
 		node = pxm_to_node(pxm);
-	if (node != -1)
-		set_mp_bus_to_node(busnum, node);
-	else
 #endif
+	if (node == -1)
 		node = x86_pci_root_bus_node(busnum);
 
 	if (node != -1 && !node_online(node))
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index a48be98e9ded..a313a7fb6b86 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -44,15 +44,6 @@ static struct pci_root_info __init *find_pci_root_info(int node, int link)
 	return NULL;
 }
 
-static void __init set_mp_bus_range_to_node(int min_bus, int max_bus, int node)
-{
-#ifdef CONFIG_NUMA
-	int j;
-
-	for (j = min_bus; j <= max_bus; j++)
-		set_mp_bus_to_node(j, node);
-#endif
-}
 /**
  * early_fill_mp_bus_to_node()
  * called before pcibios_scan_root and pci_scan_bus
@@ -117,7 +108,6 @@ static int __init early_fill_mp_bus_info(void)
 		min_bus = (reg >> 16) & 0xff;
 		max_bus = (reg >> 24) & 0xff;
 		node = (reg >> 4) & 0x07;
-		set_mp_bus_range_to_node(min_bus, max_bus, node);
 		link = (reg >> 8) & 0x03;
 
 		info = alloc_pci_root_info(min_bus, max_bus, node, link);
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index f7d6800f10d1..d491deddebae 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -683,72 +683,3 @@ int pci_ext_cfg_avail(void)
 	else
 		return 0;
 }
-
-/*
- * NUMA info for PCI busses
- *
- * Early arch code is responsible for filling in reasonable values here.
- * A node id of "-1" means "use current node".  In other words, if a bus
- * has a -1 node id, it's not tightly coupled to any particular chunk
- * of memory (as is the case on some Nehalem systems).
- */
-#ifdef CONFIG_NUMA
-
-#define BUS_NR 256
-
-#ifdef CONFIG_X86_64
-
-static int mp_bus_to_node[BUS_NR] = {
-	[0 ... BUS_NR - 1] = -1
-};
-
-void set_mp_bus_to_node(int busnum, int node)
-{
-	if (busnum >= 0 &&  busnum < BUS_NR)
-		mp_bus_to_node[busnum] = node;
-}
-
-int get_mp_bus_to_node(int busnum)
-{
-	int node = -1;
-
-	if (busnum < 0 || busnum > (BUS_NR - 1))
-		return node;
-
-	node = mp_bus_to_node[busnum];
-
-	/*
-	 * let numa_node_id to decide it later in dma_alloc_pages
-	 * if there is no ram on that node
-	 */
-	if (node != -1 && !node_online(node))
-		node = -1;
-
-	return node;
-}
-
-#else /* CONFIG_X86_32 */
-
-static int mp_bus_to_node[BUS_NR] = {
-	[0 ... BUS_NR - 1] = -1
-};
-
-void set_mp_bus_to_node(int busnum, int node)
-{
-	if (busnum >= 0 &&  busnum < BUS_NR)
-	mp_bus_to_node[busnum] = (unsigned char) node;
-}
-
-int get_mp_bus_to_node(int busnum)
-{
-	int node;
-
-	if (busnum < 0 || busnum > (BUS_NR - 1))
-		return 0;
-	node = mp_bus_to_node[busnum];
-	return node;
-}
-
-#endif /* CONFIG_X86_32 */
-
-#endif /* CONFIG_NUMA */

