Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbaFJUe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:34:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34917 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaFJTrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:47:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 067/160] irqchip: Gic: Support forced affinity setting
Date: Tue, 10 Jun 2014 12:45:07 -0700
Message-Id: <1402429600-20477-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit ffde1de64012c406dfdda8690918248b472f24e4 upstream.

To support the affinity setting of per cpu timers in the early startup
of a not yet online cpu, implement the force logic, which disables the
cpu online check.

Tagged for stable to allow a simple fix of the affected SoC clock
event drivers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
Link: http://lkml.kernel.org/r/20140416143315.916984416@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/irqchip/irq-gic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 341c601..ac2d41b 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -246,10 +246,14 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 			    bool force)
 {
 	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
-	unsigned int shift = (gic_irq(d) % 4) * 8;
-	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	unsigned int cpu, shift = (gic_irq(d) % 4) * 8;
 	u32 val, mask, bit;
 
+	if (!force)
+		cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	else
+		cpu = cpumask_first(mask_val);
+
 	if (cpu >= NR_GIC_CPU_IF || cpu >= nr_cpu_ids)
 		return -EINVAL;
 
-- 
1.9.1

