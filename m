Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaKKPsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:48:42 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56201 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaKKPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:48:37 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 09/15] irqchip: GICv3: ITS: tables allocators
Date: Tue, 11 Nov 2014 15:48:07 +0000
Message-Id: <1415720893-13371-10-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt translation is driven by a set of tables (device,
ITT, and collection) to be in the end delivered to a CPU. Also,
the redistributors rely on a couple of tables (configuration, and
pending) to deliver the interrupts to the CPUs.

This patch adds the required allocators for these tables.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 293 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 293 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index f57b6dc..92e0f49 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -90,6 +90,15 @@ struct its_device {
 	u32			device_id;
 };
 
+static LIST_HEAD(its_nodes);
+static DEFINE_SPINLOCK(its_lock);
+static struct irq_domain *lpi_domain;
+static struct device_node *gic_root_node;
+static struct rdists *gic_rdists;
+
+#define gic_data_rdist()		(raw_cpu_ptr(gic_rdists->rdist))
+#define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
+
 /*
  * ITS command descriptors - parameters to be encoded in a command
  * block.
@@ -688,3 +697,287 @@ static void its_lpi_free(unsigned long *bitmap, int base, int nr_ids)
 
 	kfree(bitmap);
 }
+
+/*
+ * We allocate 64kB for PROPBASE. That gives us at most 64K LPIs to
+ * deal with (one configuration byte per interrupt). PENDBASE has to
+ * be 64kB aligned (one bit per LPI, plus 8192 bits for SPI/PPI/SGI).
+ */
+#define LPI_PROPBASE_SZ		SZ_64K
+#define LPI_PENDBASE_SZ		(LPI_PROPBASE_SZ / 8 + SZ_1K)
+
+/*
+ * This is how many bits of ID we need, including the useless ones.
+ */
+#define LPI_NRBITS		ilog2(LPI_PROPBASE_SZ + SZ_8K)
+
+#define LPI_PROP_DEFAULT_PRIO	0xa0
+
+static int __init its_alloc_lpi_tables(void)
+{
+	phys_addr_t paddr;
+
+	gic_rdists->prop_page = alloc_pages(GFP_NOWAIT,
+					   get_order(LPI_PROPBASE_SZ));
+	if (!gic_rdists->prop_page) {
+		pr_err("Failed to allocate PROPBASE\n");
+		return -ENOMEM;
+	}
+
+	paddr = page_to_phys(gic_rdists->prop_page);
+	pr_info("GIC: using LPI property table @%pa\n", &paddr);
+
+	/* Priority 0xa0, Group-1, disabled */
+	memset(page_address(gic_rdists->prop_page),
+	       LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1,
+	       LPI_PROPBASE_SZ);
+
+	/* Make sure the GIC will observe the written configuration */
+	__flush_dcache_area(page_address(gic_rdists->prop_page), LPI_PROPBASE_SZ);
+
+	return 0;
+}
+
+static const char *its_base_type_string[] = {
+	[GITS_BASER_TYPE_DEVICE]	= "Devices",
+	[GITS_BASER_TYPE_VCPU]		= "Virtual CPUs",
+	[GITS_BASER_TYPE_CPU]		= "Physical CPUs",
+	[GITS_BASER_TYPE_COLLECTION]	= "Interrupt Collections",
+	[GITS_BASER_TYPE_RESERVED5] 	= "Reserved (5)",
+	[GITS_BASER_TYPE_RESERVED6] 	= "Reserved (6)",
+	[GITS_BASER_TYPE_RESERVED7] 	= "Reserved (7)",
+};
+
+static void its_free_tables(struct its_node *its)
+{
+	int i;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		if (its->tables[i]) {
+			free_page((unsigned long)its->tables[i]);
+			its->tables[i] = NULL;
+		}
+	}
+}
+
+static int its_alloc_tables(struct its_node *its)
+{
+	int err;
+	int i;
+	int psz = PAGE_SIZE;
+	u64 shr = GITS_BASER_InnerShareable;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		u64 val = readq_relaxed(its->base + GITS_BASER + i * 8);
+		u64 type = GITS_BASER_TYPE(val);
+		u64 entry_size = GITS_BASER_ENTRY_SIZE(val);
+		u64 tmp;
+		void *base;
+
+		if (type == GITS_BASER_TYPE_NONE)
+			continue;
+
+		/* We're lazy and only allocate a single page for now */
+		base = (void *)get_zeroed_page(GFP_KERNEL);
+		if (!base) {
+			err = -ENOMEM;
+			goto out_free;
+		}
+
+		its->tables[i] = base;
+
+retry_baser:
+		val = (virt_to_phys(base) 				 |
+		       (type << GITS_BASER_TYPE_SHIFT)			 |
+		       ((entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT) |
+		       GITS_BASER_WaWb					 |
+		       shr						 |
+		       GITS_BASER_VALID);
+
+		switch (psz) {
+		case SZ_4K:
+			val |= GITS_BASER_PAGE_SIZE_4K;
+			break;
+		case SZ_16K:
+			val |= GITS_BASER_PAGE_SIZE_16K;
+			break;
+		case SZ_64K:
+			val |= GITS_BASER_PAGE_SIZE_64K;
+			break;
+		}
+
+		val |= (PAGE_SIZE / psz) - 1;
+
+		writeq_relaxed(val, its->base + GITS_BASER + i * 8);
+		tmp = readq_relaxed(its->base + GITS_BASER + i * 8);
+
+		if ((val ^ tmp) & GITS_BASER_SHAREABILITY_MASK) {
+			/*
+			 * Shareability didn't stick. Just use
+			 * whatever the read reported, which is likely
+			 * to be the only thing this redistributor
+			 * supports.
+			 */
+			shr = tmp & GITS_BASER_SHAREABILITY_MASK;
+			goto retry_baser;
+		}
+
+		if ((val ^ tmp) & GITS_BASER_PAGE_SIZE_MASK) {
+			/*
+			 * Page size didn't stick. Let's try a smaller
+			 * size and retry. If we reach 4K, then
+			 * something is horribly wrong...
+			 */
+			switch (psz) {
+			case SZ_16K:
+				psz = SZ_4K;
+				goto retry_baser;
+			case SZ_64K:
+				psz = SZ_16K;
+				goto retry_baser;
+			}
+		}
+
+		if (val != tmp) {
+			pr_err("ITS: %s: GITS_BASER%d doesn't stick: %lx %lx\n",
+			       its->msi_chip.of_node->full_name, i,
+			       (unsigned long) val, (unsigned long) tmp);
+			err = -ENXIO;
+			goto out_free;
+		}
+
+		pr_info("ITS: allocated %d %s @%lx (psz %dK, shr %d)\n",
+			(int)(PAGE_SIZE / entry_size),
+			its_base_type_string[type],
+			(unsigned long)virt_to_phys(base),
+			psz / SZ_1K, (int)shr >> GITS_BASER_SHAREABILITY_SHIFT);
+	}
+
+	return 0;
+
+out_free:
+	its_free_tables(its);
+
+	return err;
+}
+
+static int its_alloc_collections(struct its_node *its)
+{
+	its->collections = kzalloc(nr_cpu_ids * sizeof(*its->collections),
+				   GFP_KERNEL);
+	if (!its->collections)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void its_cpu_init_lpis(void)
+{
+	void __iomem *rbase = gic_data_rdist_rd_base();
+	struct page *pend_page;
+	u64 val, tmp;
+
+	/* If we didn't allocate the pending table yet, do it now */
+	pend_page = gic_data_rdist()->pend_page;
+	if (!pend_page) {
+		phys_addr_t paddr;
+		/*
+		 * The pending pages have to be at least 64kB aligned,
+		 * hence the 'max(LPI_PENDBASE_SZ, SZ_64K)' below.
+		 */
+		pend_page = alloc_pages(GFP_NOWAIT | __GFP_ZERO,
+					get_order(max(LPI_PENDBASE_SZ, SZ_64K)));
+		if (!pend_page) {
+			pr_err("Failed to allocate PENDBASE for CPU%d\n",
+			       smp_processor_id());
+			return;
+		}
+
+		/* Make sure the GIC will observe the zero-ed page */
+		__flush_dcache_area(page_address(pend_page), LPI_PENDBASE_SZ);
+
+		paddr = page_to_phys(pend_page);
+		pr_info("CPU%d: using LPI pending table @%pa\n",
+			smp_processor_id(), &paddr);
+		gic_data_rdist()->pend_page = pend_page;
+	}
+
+	/* Disable LPIs */
+	val = readl_relaxed(rbase + GICR_CTLR);
+	val &= ~GICR_CTLR_ENABLE_LPIS;
+	writel_relaxed(val, rbase + GICR_CTLR);
+
+	/*
+	 * Make sure any change to the table is observable by the GIC.
+	 */
+	dsb(sy);
+
+	/* set PROPBASE */
+	val = (page_to_phys(gic_rdists->prop_page) |
+	       GICR_PROPBASER_InnerShareable |
+	       GICR_PROPBASER_WaWb |
+	       ((LPI_NRBITS - 1) & GICR_PROPBASER_IDBITS_MASK));
+
+	writeq_relaxed(val, rbase + GICR_PROPBASER);
+	tmp = readq_relaxed(rbase + GICR_PROPBASER);
+
+	if ((tmp ^ val) & GICR_PROPBASER_SHAREABILITY_MASK) {
+		pr_info_once("GIC: using cache flushing for LPI property table\n");
+		gic_rdists->flags |= RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING;
+	}
+
+	/* set PENDBASE */
+	val = (page_to_phys(pend_page) |
+	       GICR_PROPBASER_InnerShareable |
+	       GICR_PROPBASER_WaWb);
+
+	writeq_relaxed(val, rbase + GICR_PENDBASER);
+
+	/* Enable LPIs */
+	val = readl_relaxed(rbase + GICR_CTLR);
+	val |= GICR_CTLR_ENABLE_LPIS;
+	writel_relaxed(val, rbase + GICR_CTLR);
+
+	/* Make sure the GIC has seen the above */
+	dsb(sy);
+}
+
+static void its_cpu_init_collection(void)
+{
+	struct its_node *its;
+	int cpu;
+
+	spin_lock(&its_lock);
+	cpu = smp_processor_id();
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		u64 target;
+
+		/*
+		 * We now have to bind each collection to its target
+		 * redistributor.
+		 */
+		if (readq_relaxed(its->base + GITS_TYPER) & GITS_TYPER_PTA) {
+			/*
+			 * This ITS wants the physical address of the
+			 * redistributor.
+			 */
+			target = gic_data_rdist()->phys_base;
+		} else {
+			/*
+			 * This ITS wants a linear CPU number.
+			 */
+			target = readq_relaxed(gic_data_rdist_rd_base() + GICR_TYPER);
+			target = GICR_TYPER_CPU_NUMBER(target);
+		}
+
+		/* Perform collection mapping */
+		its->collections[cpu].target_address = target;
+		its->collections[cpu].col_id = cpu;
+
+		its_send_mapc(its, &its->collections[cpu], 1);
+		its_send_invall(its, &its->collections[cpu]);
+	}
+
+	spin_unlock(&its_lock);
+}
-- 
2.0.4

