Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaIWCAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:00:14 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:48369 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbaIWCAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:00:12 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] powerpc/iommu/ddw: Fix endianness
Date: Tue, 23 Sep 2014 11:58:49 +1000
Message-Id: <1411437529-6126-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092302-0013-0000-0000-00000041CF57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtas_call() accepts and returns values in CPU endianness.
The ddw_query_response and ddw_create_response structs members are
defined and treated as BE but as they are passed to rtas_call() as
(u32 *) and they get byteswapped automatically, the data is actually
CPU-endian. This fixes ddw_query_response and ddw_create_response
definitions and use.

of_read_number() is designed to work with device tree cells - it assumes
the input is big-endian and returns data in CPU-endian. However due
to the ddw_create_response struct fix, create.addr_hi/lo are already
CPU-endian so do not byteswap them.

ddw_avail is a pointer to the "ibm,ddw-applicable" property which contains
3 cells which are big-endian as it is a device tree. rtas_call() accepts
a RTAS token in CPU-endian. This converts RTAS tokens from big-endian to
CPU-endian. Since every token is used once till guest is rebooted, there is
no much sense in caching RTAS tokens in CPU-endian.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
Changes:
v2:
* updated commit log
* fixed definition of ddw_query_response and ddw_create_response
---
 arch/powerpc/platforms/pseries/iommu.c | 38 ++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 4642d6a..f052cc8 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -329,16 +329,16 @@ struct direct_window {
 
 /* Dynamic DMA Window support */
 struct ddw_query_response {
-	__be32 windows_available;
-	__be32 largest_available_block;
-	__be32 page_size;
-	__be32 migration_capable;
+	u32 windows_available;
+	u32 largest_available_block;
+	u32 page_size;
+	u32 migration_capable;
 };
 
 struct ddw_create_response {
-	__be32 liobn;
-	__be32 addr_hi;
-	__be32 addr_lo;
+	u32 liobn;
+	u32 addr_hi;
+	u32 addr_lo;
 };
 
 static LIST_HEAD(direct_window_list);
@@ -750,7 +750,7 @@ static void remove_ddw(struct device_node *np, bool remove_prop)
 		pr_debug("%s successfully cleared tces in window.\n",
 			 np->full_name);
 
-	ret = rtas_call(ddw_avail[2], 1, 1, NULL, liobn);
+	ret = rtas_call(be32_to_cpu(ddw_avail[2]), 1, 1, NULL, liobn);
 	if (ret)
 		pr_warning("%s: failed to remove direct window: rtas returned "
 			"%d to ibm,remove-pe-dma-window(%x) %llx\n",
@@ -841,7 +841,7 @@ static int query_ddw(struct pci_dev *dev, const u32 *ddw_avail,
 		cfg_addr = edev->pe_config_addr;
 	buid = edev->phb->buid;
 
-	ret = rtas_call(ddw_avail[0], 3, 5, (u32 *)query,
+	ret = rtas_call(be32_to_cpu(ddw_avail[0]), 3, 5, (u32 *)query,
 		  cfg_addr, BUID_HI(buid), BUID_LO(buid));
 	dev_info(&dev->dev, "ibm,query-pe-dma-windows(%x) %x %x %x"
 		" returned %d\n", ddw_avail[0], cfg_addr, BUID_HI(buid),
@@ -872,8 +872,9 @@ static int create_ddw(struct pci_dev *dev, const u32 *ddw_avail,
 
 	do {
 		/* extra outputs are LIOBN and dma-addr (hi, lo) */
-		ret = rtas_call(ddw_avail[1], 5, 4, (u32 *)create, cfg_addr,
-				BUID_HI(buid), BUID_LO(buid), page_shift, window_shift);
+		ret = rtas_call(be32_to_cpu(ddw_avail[1]), 5, 4, (u32 *)create,
+				cfg_addr, BUID_HI(buid), BUID_LO(buid),
+				page_shift, window_shift);
 	} while (rtas_busy_delay(ret));
 	dev_info(&dev->dev,
 		"ibm,create-pe-dma-window(%x) %x %x %x %x %x returned %d "
@@ -966,11 +967,11 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 		dev_dbg(&dev->dev, "no free dynamic windows");
 		goto out_failed;
 	}
-	if (be32_to_cpu(query.page_size) & 4) {
+	if (query.page_size & 4) {
 		page_shift = 24; /* 16MB */
-	} else if (be32_to_cpu(query.page_size) & 2) {
+	} else if (query.page_size & 2) {
 		page_shift = 16; /* 64kB */
-	} else if (be32_to_cpu(query.page_size) & 1) {
+	} else if (query.page_size & 1) {
 		page_shift = 12; /* 4kB */
 	} else {
 		dev_dbg(&dev->dev, "no supported direct page size in mask %x",
@@ -980,7 +981,7 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	/* verify the window * number of ptes will map the partition */
 	/* check largest block * page size > max memory hotplug addr */
 	max_addr = memory_hotplug_max();
-	if (be32_to_cpu(query.largest_available_block) < (max_addr >> page_shift)) {
+	if (query.largest_available_block < (max_addr >> page_shift)) {
 		dev_dbg(&dev->dev, "can't map partiton max 0x%llx with %u "
 			  "%llu-sized pages\n", max_addr,  query.largest_available_block,
 			  1ULL << page_shift);
@@ -1006,8 +1007,9 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	if (ret != 0)
 		goto out_free_prop;
 
-	ddwprop->liobn = create.liobn;
-	ddwprop->dma_base = cpu_to_be64(of_read_number(&create.addr_hi, 2));
+	ddwprop->liobn = cpu_to_be32(create.liobn);
+	ddwprop->dma_base = cpu_to_be64(((u64)create.addr_hi << 32) |
+			create.addr_lo);
 	ddwprop->tce_shift = cpu_to_be32(page_shift);
 	ddwprop->window_shift = cpu_to_be32(len);
 
@@ -1039,7 +1041,7 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	list_add(&window->list, &direct_window_list);
 	spin_unlock(&direct_window_list_lock);
 
-	dma_addr = of_read_number(&create.addr_hi, 2);
+	dma_addr = be64_to_cpu(ddwprop->dma_base);
 	goto out_unlock;
 
 out_free_window:
-- 
2.0.0

