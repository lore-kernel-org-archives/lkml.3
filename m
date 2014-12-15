Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaLOQRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:17:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57033 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751150AbaLOQP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:15:58 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 2/5] clk: at91: implement suspend/resume for the PMC irqchip
Date: Mon, 15 Dec 2014 17:15:49 +0100
Message-Id: <1418660152-17185-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq line used by the PMC block is shared with several peripherals
including the init timer which is registering the irq with IRQF_NO_SUSPEND.

To prevent the PMC irq handler from being called while suspended request
the irq with the IRQF_SUSPEND_NOACTION flag and implement proper suspend
resume functions to save and restore the active PMC IRQs.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/clk/at91/pmc.c | 20 +++++++++++++++++++-
 drivers/clk/at91/pmc.h |  1 +
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 386999b..59753e7 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -80,12 +80,29 @@ static int pmc_irq_set_type(struct irq_data *d, unsigned type)
 	return 0;
 }
 
+static void pmc_irq_suspend(struct irq_data *d)
+{
+	struct at91_pmc *pmc = irq_data_get_irq_chip_data(d);
+
+	pmc->imr = pmc_read(pmc, AT91_PMC_IMR);
+	pmc_write(pmc, AT91_PMC_IDR, pmc->imr);
+}
+
+static void pmc_irq_resume(struct irq_data *d)
+{
+	struct at91_pmc *pmc = irq_data_get_irq_chip_data(d);
+
+	pmc_write(pmc, AT91_PMC_IER, pmc->imr);
+}
+
 static struct irq_chip pmc_irq = {
 	.name = "PMC",
 	.irq_disable = pmc_irq_mask,
 	.irq_mask = pmc_irq_mask,
 	.irq_unmask = pmc_irq_unmask,
 	.irq_set_type = pmc_irq_set_type,
+	.irq_suspend = pmc_irq_suspend,
+	.irq_resume = pmc_irq_resume,
 };
 
 static struct lock_class_key pmc_lock_class;
@@ -215,7 +232,8 @@ static struct at91_pmc *__init at91_pmc_init(struct device_node *np,
 		goto out_free_pmc;
 
 	pmc_write(pmc, AT91_PMC_IDR, 0xffffffff);
-	if (request_irq(pmc->virq, pmc_irq_handler, IRQF_SHARED, "pmc", pmc))
+	if (request_irq(pmc->virq, pmc_irq_handler,
+			IRQF_SHARED | IRQF_SUSPEND_NOACTION, "pmc", pmc))
 		goto out_remove_irqdomain;
 
 	return pmc;
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 52d2041..69abb08 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -33,6 +33,7 @@ struct at91_pmc {
 	spinlock_t lock;
 	const struct at91_pmc_caps *caps;
 	struct irq_domain *irqdomain;
+	u32 imr;
 };
 
 static inline void pmc_lock(struct at91_pmc *pmc)
-- 
1.9.1

