Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaDQVkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:40:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaDQVkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:40:16 -0400
Date: Thu, 17 Apr 2014 14:39:56 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-ffde1de64012c406dfdda8690918248b472f24e4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        k.kozlowski@samsung.com, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, tglx@linutronix.de
In-Reply-To: <20140416143315.916984416@linutronix.de>
References: <20140416143315.916984416@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irqchip: Gic: Support forced affinity setting
Git-Commit-ID: ffde1de64012c406dfdda8690918248b472f24e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffde1de64012c406dfdda8690918248b472f24e4
Gitweb:     http://git.kernel.org/tip/ffde1de64012c406dfdda8690918248b472f24e4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 16 Apr 2014 14:36:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 17 Apr 2014 23:36:28 +0200

irqchip: Gic: Support forced affinity setting

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20140416143315.916984416@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-gic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4300b66..57d165e 100644
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
 
