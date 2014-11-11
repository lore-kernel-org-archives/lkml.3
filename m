Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaKKPsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:48:43 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56200 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaKKPsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:48:40 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 08/15] irqchip: GICv3: ITS: LPI allocator
Date: Tue, 11 Nov 2014 15:48:06 +0000
Message-Id: <1415720893-13371-9-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LPIs are the type of interrupts that are used by the ITS. Given
the size of the namespace (anywhere between 16 and 32bit), interrupt
IDs are allocated in chunks of 32.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 103 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index c904769..f57b6dc 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -585,3 +585,106 @@ static struct irq_chip its_irq_chip = {
 	.irq_eoi		= its_eoi_irq,
 	.irq_set_affinity	= its_set_affinity,
 };
+
+/*
+ * How we allocate LPIs:
+ *
+ * The GIC has id_bits bits for interrupt identifiers. From there, we
+ * must subtract 8192 which are reserved for SGIs/PPIs/SPIs. Then, as
+ * we allocate LPIs by chunks of 32, we can shift the whole thing by 5
+ * bits to the right.
+ *
+ * This gives us (((1UL << id_bits) - 8192) >> 5) possible allocations.
+ */
+#define IRQS_PER_CHUNK_SHIFT	5
+#define IRQS_PER_CHUNK		(1 << IRQS_PER_CHUNK_SHIFT)
+
+static unsigned long *lpi_bitmap;
+static u32 lpi_chunks;
+static DEFINE_SPINLOCK(lpi_lock);
+
+static int its_lpi_to_chunk(int lpi)
+{
+	return (lpi - 8192) >> IRQS_PER_CHUNK_SHIFT;
+}
+
+static int its_chunk_to_lpi(int chunk)
+{
+	return (chunk << IRQS_PER_CHUNK_SHIFT) + 8192;
+}
+
+static int its_lpi_init(u32 id_bits)
+{
+	lpi_chunks = its_lpi_to_chunk(1UL << id_bits);
+
+	lpi_bitmap = kzalloc(BITS_TO_LONGS(lpi_chunks) * sizeof(long),
+			     GFP_KERNEL);
+	if (!lpi_bitmap) {
+		lpi_chunks = 0;
+		return -ENOMEM;
+	}
+
+	pr_info("ITS: Allocated %d chunks for LPIs\n", (int)lpi_chunks);
+	return 0;
+}
+
+static unsigned long *its_lpi_alloc_chunks(int nr_irqs, int *base, int *nr_ids)
+{
+	unsigned long *bitmap = NULL;
+	int chunk_id;
+	int nr_chunks;
+	int i;
+
+	nr_chunks = DIV_ROUND_UP(nr_irqs, IRQS_PER_CHUNK);
+
+	spin_lock(&lpi_lock);
+
+	do {
+		chunk_id = bitmap_find_next_zero_area(lpi_bitmap, lpi_chunks,
+						      0, nr_chunks, 0);
+		if (chunk_id < lpi_chunks)
+			break;
+
+		nr_chunks--;
+	} while (nr_chunks > 0);
+
+	if (!nr_chunks)
+		goto out;
+
+	bitmap = kzalloc(BITS_TO_LONGS(nr_chunks * IRQS_PER_CHUNK) * sizeof (long),
+			 GFP_ATOMIC);
+	if (!bitmap)
+		goto out;
+
+	for (i = 0; i < nr_chunks; i++)
+		set_bit(chunk_id + i, lpi_bitmap);
+
+	*base = its_chunk_to_lpi(chunk_id);
+	*nr_ids = nr_chunks * IRQS_PER_CHUNK;
+
+out:
+	spin_unlock(&lpi_lock);
+
+	return bitmap;
+}
+
+static void its_lpi_free(unsigned long *bitmap, int base, int nr_ids)
+{
+	int lpi;
+
+	spin_lock(&lpi_lock);
+
+	for (lpi = base; lpi < (base + nr_ids); lpi += IRQS_PER_CHUNK) {
+		int chunk = its_lpi_to_chunk(lpi);
+		BUG_ON(chunk > lpi_chunks);
+		if (test_bit(chunk, lpi_bitmap)) {
+			clear_bit(chunk, lpi_bitmap);
+		} else {
+			pr_err("Bad LPI chunk %d\n", chunk);
+		}
+	}
+
+	spin_unlock(&lpi_lock);
+
+	kfree(bitmap);
+}
-- 
2.0.4

