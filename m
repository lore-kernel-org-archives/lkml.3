Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaA2STB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:19:01 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64013 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaA2SS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:18:58 -0500
Subject: [PATCH 12/17] ia64 / sba_iommu: Use NUMA_NO_NODE, not MAX_NUMNODES,
 for unknown node
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 11:18:55 -0700
Message-ID: <20140129181855.15476.93329.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX_NUMNODES is typically used for sizing arrays.  NUMA_NO_NODE is the
usual value for "we don't know what node this is on," e.g., it is the
error return from acpi_get_node().

This changes the ioc->node value for unknown nodes from MAX_NUMNODES to
NUMA_NO_NODE.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/ia64/hp/common/sba_iommu.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 8e858b593e4f..a52d6b49b7ce 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -1140,11 +1140,13 @@ sba_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 
 #ifdef CONFIG_NUMA
 	{
+		int node = ioc->node;
 		struct page *page;
-		page = alloc_pages_exact_node(ioc->node == MAX_NUMNODES ?
-		                        numa_node_id() : ioc->node, flags,
-		                        get_order(size));
 
+		if (node == NUMA_NO_NODE)
+			node = numa_node_id();
+
+		page = alloc_pages_exact_node(node, flags, get_order(size));
 		if (unlikely(!page))
 			return NULL;
 
@@ -1914,7 +1916,7 @@ ioc_show(struct seq_file *s, void *v)
 	seq_printf(s, "Hewlett Packard %s IOC rev %d.%d\n",
 		ioc->name, ((ioc->rev >> 4) & 0xF), (ioc->rev & 0xF));
 #ifdef CONFIG_NUMA
-	if (ioc->node != MAX_NUMNODES)
+	if (ioc->node != NUMA_NO_NODE)
 		seq_printf(s, "NUMA node       : %d\n", ioc->node);
 #endif
 	seq_printf(s, "IOVA size       : %ld MB\n", ((ioc->pdir_size >> 3) * iovp_size)/(1024*1024));
@@ -2022,7 +2024,7 @@ sba_map_ioc_to_node(struct ioc *ioc, acpi_handle handle)
 	unsigned int node;
 	int pxm;
 
-	ioc->node = MAX_NUMNODES;
+	ioc->node = NUMA_NO_NODE;
 
 	pxm = acpi_get_pxm(handle);
 
@@ -2031,7 +2033,7 @@ sba_map_ioc_to_node(struct ioc *ioc, acpi_handle handle)
 
 	node = pxm_to_node(pxm);
 
-	if (node >= MAX_NUMNODES || !node_online(node))
+	if (node == NUMA_NO_NODE || !node_online(node))
 		return;
 
 	ioc->node = node;

