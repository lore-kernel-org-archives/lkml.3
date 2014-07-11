Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaGKWyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:54:11 -0400
Received: from lhrrgout.huawei.com ([194.213.3.17]:56578 "EHLO
	lhrrgout.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaGKWyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:54:09 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2014 18:54:06 EDT
From: Liu Hua <sdu.liu@huawei.com>
To: <tglx@linutronix.de>, <jason@lakedaemon.net>, <nicolas.pitre@linaro.org>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <ebiederm@xmission.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>, <liuxueliu.liu@huawei.com>,
        <peifeiyue@huawei.com>, <liusdu@huawei.com>,
        Liu Hua <sdu.liu@huawei.com>
Subject: [RFC PATCH 2/2] irqchip: GIC: introduce method to deactive interupts
Date: Fri, 11 Jul 2014 14:46:17 +0800
Message-ID: <1405061177-43834-3-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1405061177-43834-1-git-send-email-sdu.liu@huawei.com>
References: <1405061177-43834-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using kdump on ARM platform, if kernel panics in interrupt handler
(maybe PPI or SPI), the capture kernel can not recive certain interrupt,
and fails to boot.

On this situation, We have read register GICC_IAR. But we have no chance
to write relative bit to register GICC_EOIR(kernel paniced before). So
the state of this type interrupt remains active. Ant that makes gic not
deliver this type interrupt to cpu interface.

So we should not assume that all interruts state of GIC is inactive when
kernel initailize the GIC. This patch identifies this type interrupts
and deactives them;

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 drivers/irqchip/irq-gic.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index ddee133..d8620cf 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -352,12 +352,68 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
 	return mask;
 }
 
+void gic_v1_eois(u32 active, void __iomem *cpu_base)
+{
+	int bit = -1;
+
+	while ((bit = find_next_bit((unsigned long *) &active,
+						32, bit + 1)) < 32) {
+		writel_relaxed(bit, cpu_base + GIC_CPU_EOI);
+	}
+}
+
+void gic_v1_clear_active(void __iomem *dist_base,
+			void __iomem *cpu_base, int gic_irqs)
+{
+	int irq, offset;
+	u32 active;
+
+	for (irq = 0; irq < gic_irqs; irq += 32) {
+		offset = GIC_DIST_ACTIVE_SET + irq * 4 / 32;
+		active = readl_relaxed(dist_base + offset);
+		if (!active)
+			continue;
+		gic_v1_eois(active, cpu_base);
+	}
+}
+
+void gic_v2_clear_active(void __iomem *dist_base, int gic_irqs)
+{
+	int irq, offset;
+	u32 active;
+
+	for (irq = 0; irq < gic_irqs; irq += 32) {
+		offset = irq * 4 / 32 + GIC_DIST_ACTIVE_SET;
+		active = readl_relaxed(dist_base + offset);
+		if (!active)
+			continue;
+		offset = irq * 4 / 32 + GIC_DIST_ACTIVE_CLEAR;
+		writel_relaxed(active, dist_base + offset);
+	}
+}
+
+void __init gic_dist_clear_active(void __iomem *dist_base,
+					void __iomem *cpu_base, int gic_irqs)
+{
+	u32 ArchRev;
+
+	ArchRev = readl_relaxed(dist_base + GIC_DIST_ICPIDR2);
+	ArchRev = (ArchRev >> 4) & 0xF;
+
+	if (ArchRev == 0x1) {
+		gic_v1_clear_active(dist_base, cpu_base, gic_irqs);
+	} else {
+		gic_v2_clear_active(dist_base, gic_irqs);
+	}
+}
+
 static void __init gic_dist_init(struct gic_chip_data *gic)
 {
 	unsigned int i;
 	u32 cpumask;
 	unsigned int gic_irqs = gic->gic_irqs;
 	void __iomem *base = gic_data_dist_base(gic);
+	void __iomem *cpu_base = gic_data_cpu_base(gic);
 
 	writel_relaxed(0, base + GIC_DIST_CTRL);
 
@@ -371,6 +427,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 		writel_relaxed(cpumask, base + GIC_DIST_TARGET + i * 4 / 4);
 
 	gic_dist_config(base, gic_irqs, NULL);
+	gic_dist_clear_active(base, cpu_base, gic_irqs);
 
 	writel_relaxed(1, base + GIC_DIST_CTRL);
 }
-- 
1.9.0

