Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3HEUmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:42:52 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50976 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3HEUmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:42:50 -0400
Message-ID: <e8189dce6211e996056d8c52e3e669ac5f49c486.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 07/20] tile PCI RC: support more MSI-X interrupt vectors
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support PCIe devices with higher number of MSI-X interrupt vectors,
e.g. 16 for the LSI RAID card, enhance the Gx RC stack to provide more
MSI-X vectors by using the TRIO Scatter Queues, which provide 8 more
vectors in addition to ~10 from the Map Mem regions.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/gxio/iorpc_trio.c         | 23 +++++++++++++++
 arch/tile/include/arch/trio.h       | 39 ++++++++++++++++++++++++
 arch/tile/include/gxio/iorpc_trio.h |  5 ++++
 arch/tile/kernel/pci_gx.c           | 59 ++++++++++++++++++++++++-------------
 4 files changed, 106 insertions(+), 20 deletions(-)

diff --git a/arch/tile/gxio/iorpc_trio.c b/arch/tile/gxio/iorpc_trio.c
index cef4b22..da6e18e 100644
--- a/arch/tile/gxio/iorpc_trio.c
+++ b/arch/tile/gxio/iorpc_trio.c
@@ -61,6 +61,29 @@ int gxio_trio_alloc_memory_maps(gxio_trio_context_t * context,
 
 EXPORT_SYMBOL(gxio_trio_alloc_memory_maps);
 
+struct alloc_scatter_queues_param {
+	unsigned int count;
+	unsigned int first;
+	unsigned int flags;
+};
+
+int gxio_trio_alloc_scatter_queues(gxio_trio_context_t * context,
+				   unsigned int count, unsigned int first,
+				   unsigned int flags)
+{
+	struct alloc_scatter_queues_param temp;
+	struct alloc_scatter_queues_param *params = &temp;
+
+	params->count = count;
+	params->first = first;
+	params->flags = flags;
+
+	return hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params,
+			     sizeof(*params),
+			     GXIO_TRIO_OP_ALLOC_SCATTER_QUEUES);
+}
+
+EXPORT_SYMBOL(gxio_trio_alloc_scatter_queues);
 
 struct alloc_pio_regions_param {
 	unsigned int count;
diff --git a/arch/tile/include/arch/trio.h b/arch/tile/include/arch/trio.h
index d3000a8..c0ddedc 100644
--- a/arch/tile/include/arch/trio.h
+++ b/arch/tile/include/arch/trio.h
@@ -23,6 +23,45 @@
 #ifndef __ASSEMBLER__
 
 /*
+ * Map SQ Doorbell Format.
+ * This describes the format of the write-only doorbell register that exists
+ * in the last 8-bytes of the MAP_SQ_BASE/LIM range.  This register is only
+ * writable from PCIe space.  Writes to this register will not be written to
+ * Tile memory space and thus no IO VA translation is required if the last
+ * page of the BASE/LIM range is not otherwise written.
+ */
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    /*
+     * When written with a 1, the associated MAP_SQ region's doorbell
+     * interrupt will be triggered once all previous writes are visible to
+     * Tile software.
+     */
+    uint_reg_t doorbell   : 1;
+    /*
+     * When written with a 1, the descriptor at the head of the associated
+     * MAP_SQ's FIFO will be dequeued.
+     */
+    uint_reg_t pop        : 1;
+    /* Reserved. */
+    uint_reg_t __reserved : 62;
+#else   /* __BIG_ENDIAN__ */
+    uint_reg_t __reserved : 62;
+    uint_reg_t pop        : 1;
+    uint_reg_t doorbell   : 1;
+#endif
+  };
+
+  uint_reg_t word;
+} TRIO_MAP_SQ_DOORBELL_FMT_t;
+
+
+/*
  * Tile PIO Region Configuration - CFG Address Format.
  * This register describes the address format for PIO accesses when the
  * associated region is setup with TYPE=CFG.
diff --git a/arch/tile/include/gxio/iorpc_trio.h b/arch/tile/include/gxio/iorpc_trio.h
index 58105c3..d95b96f 100644
--- a/arch/tile/include/gxio/iorpc_trio.h
+++ b/arch/tile/include/gxio/iorpc_trio.h
@@ -30,6 +30,7 @@
 
 #define GXIO_TRIO_OP_ALLOC_MEMORY_MAPS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1404)
 
+#define GXIO_TRIO_OP_ALLOC_SCATTER_QUEUES IORPC_OPCODE(IORPC_FORMAT_NONE, 0x140e)
 #define GXIO_TRIO_OP_ALLOC_PIO_REGIONS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1412)
 
 #define GXIO_TRIO_OP_INIT_PIO_REGION_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1414)
@@ -54,6 +55,10 @@ int gxio_trio_alloc_memory_maps(gxio_trio_context_t * context,
 				unsigned int flags);
 
 
+int gxio_trio_alloc_scatter_queues(gxio_trio_context_t * context,
+				   unsigned int count, unsigned int first,
+				   unsigned int flags);
+
 int gxio_trio_alloc_pio_regions(gxio_trio_context_t * context,
 				unsigned int count, unsigned int first,
 				unsigned int flags);
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index 2cc3e64..e0d6664 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -1474,32 +1474,55 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	trio_context = controller->trio;
 
 	/*
-	 * Allocate the Mem-Map that will accept the MSI write and
-	 * trigger the TILE-side interrupts.
+	 * Allocate a scatter-queue that will accept the MSI write and
+	 * trigger the TILE-side interrupts. We use the scatter-queue regions
+	 * before the mem map regions, because the latter are needed by more
+	 * applications.
 	 */
-	mem_map = gxio_trio_alloc_memory_maps(trio_context, 1, 0, 0);
-	if (mem_map < 0) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			"%s Mem-Map alloc failure. "
-			"Failed to initialize MSI interrupts. "
-			"Falling back to legacy interrupts.\n",
-			desc->msi_attrib.is_msix ? "MSI-X" : "MSI");
+	mem_map = gxio_trio_alloc_scatter_queues(trio_context, 1, 0, 0);
+	if (mem_map >= 0) {
+		TRIO_MAP_SQ_DOORBELL_FMT_t doorbell_template = {{
+			.pop = 0,
+			.doorbell = 1,
+		}};
+
+		mem_map += TRIO_NUM_MAP_MEM_REGIONS;
+		mem_map_base = MEM_MAP_INTR_REGIONS_BASE +
+			mem_map * MEM_MAP_INTR_REGION_SIZE;
+		mem_map_limit = mem_map_base + MEM_MAP_INTR_REGION_SIZE - 1;
+
+		msi_addr = mem_map_base + MEM_MAP_INTR_REGION_SIZE - 8;
+		msg.data = (unsigned int)doorbell_template.word;
+	} else {
+		/* SQ regions are out, allocate from map mem regions. */
+		mem_map = gxio_trio_alloc_memory_maps(trio_context, 1, 0, 0);
+		if (mem_map < 0) {
+			dev_printk(KERN_INFO, &pdev->dev,
+				"%s Mem-Map alloc failure. "
+				"Failed to initialize MSI interrupts. "
+				"Falling back to legacy interrupts.\n",
+				desc->msi_attrib.is_msix ? "MSI-X" : "MSI");
+			ret = -ENOMEM;
+			goto msi_mem_map_alloc_failure;
+		}
 
-		ret = -ENOMEM;
-		goto msi_mem_map_alloc_failure;
+		mem_map_base = MEM_MAP_INTR_REGIONS_BASE +
+			mem_map * MEM_MAP_INTR_REGION_SIZE;
+		mem_map_limit = mem_map_base + MEM_MAP_INTR_REGION_SIZE - 1;
+
+		msi_addr = mem_map_base + TRIO_MAP_MEM_REG_INT3 -
+			TRIO_MAP_MEM_REG_INT0;
+
+		msg.data = mem_map;
 	}
 
 	/* We try to distribute different IRQs to different tiles. */
 	cpu = tile_irq_cpu(irq);
 
 	/*
-	 * Now call up to the HV to configure the Mem-Map interrupt and
+	 * Now call up to the HV to configure the MSI interrupt and
 	 * set up the IPI binding.
 	 */
-	mem_map_base = MEM_MAP_INTR_REGIONS_BASE +
-		mem_map * MEM_MAP_INTR_REGION_SIZE;
-	mem_map_limit = mem_map_base + MEM_MAP_INTR_REGION_SIZE - 1;
-
 	ret = gxio_trio_config_msi_intr(trio_context, cpu_x(cpu), cpu_y(cpu),
 					KERNEL_PL, irq, controller->mac,
 					mem_map, mem_map_base, mem_map_limit,
@@ -1512,13 +1535,9 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 
 	irq_set_msi_desc(irq, desc);
 
-	msi_addr = mem_map_base + TRIO_MAP_MEM_REG_INT3 - TRIO_MAP_MEM_REG_INT0;
-
 	msg.address_hi = msi_addr >> 32;
 	msg.address_lo = msi_addr & 0xffffffff;
 
-	msg.data = mem_map;
-
 	write_msi_msg(irq, &msg);
 	irq_set_chip_and_handler(irq, &tilegx_msi_chip, handle_level_irq);
 	irq_set_handler_data(irq, controller);
-- 
1.8.3.1

