Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaHOHcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 03:32:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39507 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbaHOHce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 03:32:34 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] arm: irq: fix the affinity when migrate a irq
Date: Fri, 15 Aug 2014 15:31:57 +0800
Message-ID: <1408087917-22603-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-15_02:2014-08-14,2014-08-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408150091
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ffde1de64012 ("irqchip: Gic: Support forced affinity setting")
has enable the forcing cpu affinity of interrupts for gic.

The current code of migrate_one_irq will pass the current affinity mask
to irq_set_affinity with force is true, it may select the cpu being
offlined as the target CPU again, then the interrupt won't be migrated
correctly.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 arch/arm/kernel/irq.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 2c42576..6f5a878 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -167,11 +167,10 @@ static bool migrate_one_irq(struct irq_desc *desc)
 	if (irqd_is_per_cpu(d) || !cpumask_test_cpu(smp_processor_id(), affinity))
 		return false;
 
-	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
-		affinity = cpu_online_mask;
+	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids)
 		ret = true;
-	}
 
+	affinity = cpu_online_mask;
 	c = irq_data_get_irq_chip(d);
 	if (!c->irq_set_affinity)
 		pr_debug("IRQ%u: unable to set affinity\n", d->irq);
-- 
1.7.9.5

