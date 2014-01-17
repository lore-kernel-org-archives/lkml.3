Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaAQP13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:27:29 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:41176 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330AbaAQP1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:27:14 -0500
Message-Id: <20140117151837.083327854@linux.com>
Date: Fri, 17 Jan 2014 09:18:38 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, nicolas.pitre@linaro.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 26/41] irqchips: Replace __this_cpu_ptr uses
References: <20140117151812.770437629@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_irqchip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch depends on another patch in this series that introduces raw_cpu_ops]

These are generally replaced with raw_cpu_ptr. However, in
gic_get_percpu_base() we immediately dereference the pointer. This is
equivalent to a raw_cpu_read. So use that operation there.

Cc: nicolas.pitre@linaro.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/irqchip/irq-gic.c
===================================================================
--- linux.orig/drivers/irqchip/irq-gic.c	2013-12-02 16:07:55.564473217 -0600
+++ linux/drivers/irqchip/irq-gic.c	2013-12-02 16:07:55.554473493 -0600
@@ -102,7 +102,7 @@ static struct gic_chip_data gic_data[MAX
 #ifdef CONFIG_GIC_NON_BANKED
 static void __iomem *gic_get_percpu_base(union gic_base *base)
 {
-	return *__this_cpu_ptr(base->percpu_base);
+	return raw_cpu_read(base->percpu_base);
 }
 
 static void __iomem *gic_get_common_base(union gic_base *base)
@@ -552,11 +552,11 @@ static void gic_cpu_save(unsigned int gi
 	if (!dist_base || !cpu_base)
 		return;
 
-	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_enable);
+	ptr = raw_cpu_ptr(gic_data[gic_nr].saved_ppi_enable);
 	for (i = 0; i < DIV_ROUND_UP(32, 32); i++)
 		ptr[i] = readl_relaxed(dist_base + GIC_DIST_ENABLE_SET + i * 4);
 
-	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_conf);
+	ptr = raw_cpu_ptr(gic_data[gic_nr].saved_ppi_conf);
 	for (i = 0; i < DIV_ROUND_UP(32, 16); i++)
 		ptr[i] = readl_relaxed(dist_base + GIC_DIST_CONFIG + i * 4);
 
@@ -578,11 +578,11 @@ static void gic_cpu_restore(unsigned int
 	if (!dist_base || !cpu_base)
 		return;
 
-	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_enable);
+	ptr = raw_cpu_ptr(gic_data[gic_nr].saved_ppi_enable);
 	for (i = 0; i < DIV_ROUND_UP(32, 32); i++)
 		writel_relaxed(ptr[i], dist_base + GIC_DIST_ENABLE_SET + i * 4);
 
-	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_conf);
+	ptr = raw_cpu_ptr(gic_data[gic_nr].saved_ppi_conf);
 	for (i = 0; i < DIV_ROUND_UP(32, 16); i++)
 		writel_relaxed(ptr[i], dist_base + GIC_DIST_CONFIG + i * 4);
 
Index: linux/kernel/irq/chip.c
===================================================================
--- linux.orig/kernel/irq/chip.c	2013-12-02 16:07:55.564473217 -0600
+++ linux/kernel/irq/chip.c	2013-12-02 16:07:55.554473493 -0600
@@ -638,7 +638,7 @@ void handle_percpu_devid_irq(unsigned in
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct irqaction *action = desc->action;
-	void *dev_id = __this_cpu_ptr(action->percpu_dev_id);
+	void *dev_id = raw_cpu_ptr(action->percpu_dev_id);
 	irqreturn_t res;
 
 	kstat_incr_irqs_this_cpu(irq, desc);

