Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbaJ3CUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:20:08 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57949 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747AbaJ3CUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:20:02 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org, lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH V2 15/15] irqchip: bcm7120-l2: Enable big endian register accesses on BE kernels
Date: Wed, 29 Oct 2014 19:18:08 -0700
Message-Id: <1414635488-14137-16-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On all supported SoCs, the kernel will be built with CONFIG_CPU_BIG_ENDIAN
iff the CPU is running in BE mode.  Leverage this fact to autodetect
the MMIO byte ordering to use in generic-chip.c.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/irqchip/Kconfig          | 2 ++
 drivers/irqchip/irq-bcm7120-l2.c | 9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index afdc1f3..db44694 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -51,11 +51,13 @@ config ATMEL_AIC5_IRQ
 config BCM7120_L2_IRQ
 	bool
 	select GENERIC_IRQ_CHIP
+	select GENERIC_IRQ_CHIP_BE
 	select IRQ_DOMAIN
 
 config BRCMSTB_L2_IRQ
 	bool
 	select GENERIC_IRQ_CHIP
+	select GENERIC_IRQ_CHIP_BE
 	select IRQ_DOMAIN
 
 config DW_APB_ICTL
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index e53a3a6..5324249 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -132,7 +132,7 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 	const __be32 *map_mask;
 	int num_parent_irqs;
 	int ret = 0, len;
-	unsigned int idx, irq;
+	unsigned int idx, irq, flags;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -195,9 +195,12 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 		goto out_unmap;
 	}
 
+	flags = IRQ_GC_INIT_MASK_CACHE;
+	if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
+		flags |= IRQ_GC_BE_IO;
+
 	ret = irq_alloc_domain_generic_chips(data->domain, IRQS_PER_WORD, 1,
-				dn->full_name, handle_level_irq, clr, 0,
-				IRQ_GC_INIT_MASK_CACHE);
+				dn->full_name, handle_level_irq, clr, 0, flags);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
-- 
2.1.1

