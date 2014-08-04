Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaHDE2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:28:31 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:36505 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaHDE22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:28:28 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <Marc.Zyngier@arm.com>, <will.deacon@arm.com>
CC: <nicolas.pitre@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <peifeiyue@huawei.com>, <liusdu@126.com>, <wangnan0@huawei.com>,
        <ebiederm@xmission.com>, Liu Hua <sdu.liu@huawei.com>
Subject: [PATCH V2 1/1] GIC: introduce method to deactive interupts
Date: Mon, 4 Aug 2014 12:17:40 +0800
Message-ID: <1407125860-37718-2-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407125860-37718-1-git-send-email-sdu.liu@huawei.com>
References: <1407125860-37718-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using kdump on ARM platform, if kernel panics in interrupt handler
(maybe PPI), the capture kernel can not recive certain interrupt, and 
fails to boot.

On this situation, We have read register GICC_IAR. But we have no chance
to write relative bit to register GICC_EOIR (kernel paniced before). So
the state of this type interrupt remains active. And that makes gic not
deliver this type interrupt to cpu interface.

So we should not assume that all interrut states of GIC are inactive when
kernel inittailize the GIC. This patch will identify these type interrupts
and deactive them

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 drivers/irqchip/irq-gic.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index b2648fc..7708df1 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -351,12 +351,37 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
 	return mask;
 }
 
+void gic_eois(u32 active, int irq_off, void __iomem *cpu_base)
+{
+	int bit = -1;
+
+	for_each_set_bit(bit, (unsigned long *)&active, 32)
+		writel_relaxed(bit + irq_off, cpu_base + GIC_CPU_EOI);
+}
+
+void gic_dist_clear_active(void __iomem *dist_base,
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
+		gic_eois(active, irq, cpu_base);
+	}
+}
+
+
 static void __init gic_dist_init(struct gic_chip_data *gic)
 {
 	unsigned int i;
 	u32 cpumask;
 	unsigned int gic_irqs = gic->gic_irqs;
 	void __iomem *base = gic_data_dist_base(gic);
+	void __iomem *cpu_base = gic_data_cpu_base(gic);
 
 	writel_relaxed(0, base + GIC_DIST_CTRL);
 
@@ -371,6 +396,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 
 	gic_dist_config(base, gic_irqs, NULL);
 
+	gic_dist_clear_active(base, cpu_base, gic_irqs);
 	writel_relaxed(1, base + GIC_DIST_CTRL);
 }
 
-- 
1.9.0

