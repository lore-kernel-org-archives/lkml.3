Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaKLG0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:26:01 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62904 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbaKLGZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:25:56 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <tglx@linutronix.de>, <jason@lakedaemon.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v2 1/3] irqchip: dw-apb-ictl: always use use {readl|writel}_relaxed
Date: Wed, 12 Nov 2014 14:22:52 +0800
Message-ID: <1415773374-4629-2-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415773374-4629-1-git-send-email-jszhang@marvell.com>
References: <1415773374-4629-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-12_04:2014-11-11,2014-11-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1411120057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no DMA at all, the device type memory attribute can ensure the
operations order and relaxed version imply compiler barrier, so we are safe
to use relaxed version to improve the performance a bit.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
 drivers/irqchip/irq-dw-apb-ictl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
index 31e231e..fcc3385 100644
--- a/drivers/irqchip/irq-dw-apb-ictl.c
+++ b/drivers/irqchip/irq-dw-apb-ictl.c
@@ -94,16 +94,16 @@ static int __init dw_apb_ictl_init(struct device_node *np,
 	 */
 
 	/* mask and enable all interrupts */
-	writel(~0, iobase + APB_INT_MASK_L);
-	writel(~0, iobase + APB_INT_MASK_H);
-	writel(~0, iobase + APB_INT_ENABLE_L);
-	writel(~0, iobase + APB_INT_ENABLE_H);
+	writel_relaxed(~0, iobase + APB_INT_MASK_L);
+	writel_relaxed(~0, iobase + APB_INT_MASK_H);
+	writel_relaxed(~0, iobase + APB_INT_ENABLE_L);
+	writel_relaxed(~0, iobase + APB_INT_ENABLE_H);
 
-	reg = readl(iobase + APB_INT_ENABLE_H);
+	reg = readl_relaxed(iobase + APB_INT_ENABLE_H);
 	if (reg)
 		nrirqs = 32 + fls(reg);
 	else
-		nrirqs = fls(readl(iobase + APB_INT_ENABLE_L));
+		nrirqs = fls(readl_relaxed(iobase + APB_INT_ENABLE_L));
 
 	domain = irq_domain_add_linear(np, nrirqs,
 				       &irq_generic_chip_ops, NULL);
-- 
2.1.3

