Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbbA2LR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:17:27 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:17330 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbbA2LOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:14:35 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 4/9] irqchip: mips-gic: Add function for retrieving FDC IRQ
Date: Thu, 29 Jan 2015 11:14:09 +0000
Message-ID: <1422530054-7976-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422530054-7976-1-git-send-email-james.hogan@imgtec.com>
References: <1422530054-7976-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to the MIPS GIC driver for retrieving the Fast Debug
Channel (FDC) interrupt number, similar to the existing ones for the
timer and perf counter interrupts. This will be used by platform
implementations of get_c0_fdc_int() if a GIC is present.

A workaround exists for interAptiv and proAptiv which claim to be able
to route the FDC interrupt but don't seem to be able to in practice (at
least on Malta).

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Bresticker <abrestic@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-mips@linux-mips.org
---
 drivers/irqchip/irq-mips-gic.c   | 23 +++++++++++++++++++++++
 include/linux/irqchip/mips-gic.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index bcfead6e8ae6..00379550cd71 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -234,6 +234,29 @@ int gic_get_c0_perfcount_int(void)
 				  GIC_LOCAL_TO_HWIRQ(GIC_LOCAL_INT_PERFCTR));
 }
 
+int gic_get_c0_fdc_int(void)
+{
+	if (!gic_local_irq_is_routable(GIC_LOCAL_INT_FDC)) {
+		/* Is the FDC IRQ even present? */
+		if (cp0_fdc_irq < 0)
+			return -1;
+		return MIPS_CPU_IRQ_BASE + cp0_fdc_irq;
+	}
+
+	/*
+	 * Some cores claim the FDC is routable but it doesn't actually seem to
+	 * be connected.
+	 */
+	switch (current_cpu_type()) {
+	case CPU_INTERAPTIV:
+	case CPU_PROAPTIV:
+		return -1;
+	}
+
+	return irq_create_mapping(gic_irq_domain,
+				  GIC_LOCAL_TO_HWIRQ(GIC_LOCAL_INT_FDC));
+}
+
 static unsigned int gic_get_int(void)
 {
 	unsigned int i;
diff --git a/include/linux/irqchip/mips-gic.h b/include/linux/irqchip/mips-gic.h
index ff0e75f40ef5..8e9940040e6d 100644
--- a/include/linux/irqchip/mips-gic.h
+++ b/include/linux/irqchip/mips-gic.h
@@ -252,4 +252,5 @@ extern unsigned int plat_ipi_resched_int_xlate(unsigned int);
 extern unsigned int gic_get_timer_pending(void);
 extern int gic_get_c0_compare_int(void);
 extern int gic_get_c0_perfcount_int(void);
+extern int gic_get_c0_fdc_int(void);
 #endif /* __LINUX_IRQCHIP_MIPS_GIC_H */
-- 
2.0.5

