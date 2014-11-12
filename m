Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaKLNnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:43:02 -0500
Received: from www.linutronix.de ([62.245.132.108]:41630 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbaKLNm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:42:59 -0500
Message-Id: <20141112134120.218401386@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:42:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [patch 05/16] genirq: Add IRQ_SET_MASK_OK_DONE to support stacked
 irqchip
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=genirq-add-irq_set_mask_ok_done-to-support-stacked-irqchip.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

Add IRQ_SET_MASK_OK_DONE in addition to IRQ_SET_MASK_OK and
IRQ_SET_MASK_OK_NOCOPY to support stacked irqchip. IRQ_SET_MASK_OK_DONE
is the same as IRQ_SET_MASK_OK to irq core. To stacked irqchip, it means
that ascendant irqchips have done all the work and no more handling
needed in descendant irqchips.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    4 ++++
 kernel/irq/manage.c |    2 ++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 536b7fc6c8f4..041edd6dc409 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -114,10 +114,14 @@ enum {
  *
  * IRQ_SET_MASK_OK	- OK, core updates irq_data.affinity
  * IRQ_SET_MASK_NOCPY	- OK, chip did update irq_data.affinity
+ * IRQ_SET_MASK_OK_DONE	- Same as IRQ_SET_MASK_OK for core. Special code to
+ *			  support stacked irqchips, which indicates skipping
+ *			  all descendent irqchips.
  */
 enum {
 	IRQ_SET_MASK_OK = 0,
 	IRQ_SET_MASK_OK_NOCOPY,
+	IRQ_SET_MASK_OK_DONE,
 };
 
 struct msi_desc;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a9104b4608b..80692373abd6 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -183,6 +183,7 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	ret = chip->irq_set_affinity(data, mask, force);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
+	case IRQ_SET_MASK_OK_DONE:
 		cpumask_copy(data->affinity, mask);
 	case IRQ_SET_MASK_OK_NOCOPY:
 		irq_set_thread_affinity(desc);
@@ -600,6 +601,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
+	case IRQ_SET_MASK_OK_DONE:
 		irqd_clear(&desc->irq_data, IRQD_TRIGGER_MASK);
 		irqd_set(&desc->irq_data, flags);
 
-- 
1.7.10.4





