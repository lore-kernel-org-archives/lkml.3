Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaA2SST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:18:19 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:64852 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaA2SSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:18:14 -0500
Subject: [PATCH 06/17] x86/PCI: Add x86_pci_root_bus_node() to look up NUMA
 node from PCI bus
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 11:18:11 -0700
Message-ID: <20140129181811.15476.19897.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD early_fill_mp_bus_info() already allocates a struct pci_root_info
for each PCI host bridge it finds, and that structure contains the NUMA
node number.  We don't need to keep the same information in the
mp_bus_to_node[] table.

This adds x86_pci_root_bus_node(), which returns the NUMA node number, or
NUMA_NO_NODE if the node is unknown.

Note that unlike get_mp_bus_to_node(), x86_pci_root_bus_node() only works
for root buses.  For example, if amd_bus.c finds a host bridge on node 1 to
[bus 00-0f], get_mp_bus_to_node() returns 1 for any bus between 00 and 0f,
but x86_pci_root_bus_node() returns 1 for bus 00 and NUMA_NO_NODE for buses
01-0f.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/include/asm/topology.h |    1 +
 arch/x86/pci/bus_numa.c         |   10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index d35f24e231cd..09046a1a6c35 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -131,6 +131,7 @@ static inline void arch_fix_phys_package_id(int num, u32 slot)
 }
 
 struct pci_bus;
+int x86_pci_root_bus_node(int bus);
 void x86_pci_root_bus_resources(int bus, struct list_head *resources);
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index c2735feb2508..2e36a4469549 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -20,6 +20,16 @@ static struct pci_root_info *x86_find_pci_root_info(int bus)
 	return NULL;
 }
 
+int x86_pci_root_bus_node(int bus)
+{
+	struct pci_root_info *info = x86_find_pci_root_info(bus);
+
+	if (!info)
+		return NUMA_NO_NODE;
+
+	return info->node;
+}
+
 void x86_pci_root_bus_resources(int bus, struct list_head *resources)
 {
 	struct pci_root_info *info = x86_find_pci_root_info(bus);

