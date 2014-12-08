Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbaLHPDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:03:23 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:46161 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755629AbaLHPDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:03:21 -0500
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Beniamino Galvani <b.galvani@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <marc.zyngier@arm.com>,
        <srv_heupstream@mediatek.com>, <hc.yen@mediatek.com>,
        <yh.chen@mediatek.com>, <linux-kernel@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <nathan.chung@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, <eddie.huang@mediatek.com>,
        <yingjoe.chen@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: [PATCH] irqchip: mediatek: Fix error return code detection
Date: Mon, 8 Dec 2014 23:03:09 +0800
Message-ID: <1418050989-21411-1-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix an error handling bug reported by Beniamino, this is based on
mtk intpol patches [1]

Joe.C

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305808.html

====================
of_io_request_and_map() return ERR_PTR wrapped error code instead of
NULL when fail, fix code in mtk_sysirq_of_init() to correctly handle
this.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
---
 drivers/irqchip/irq-mtk-sysirq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-mtk-sysirq.c b/drivers/irqchip/irq-mtk-sysirq.c
index 7e342df..0b0d2c0 100644
--- a/drivers/irqchip/irq-mtk-sysirq.c
+++ b/drivers/irqchip/irq-mtk-sysirq.c
@@ -137,9 +137,9 @@ static int __init mtk_sysirq_of_init(struct device_node *node,
 		return -ENOMEM;
 
 	chip_data->intpol_base = of_io_request_and_map(node, 0, "intpol");
-	if (!chip_data->intpol_base) {
+	if (IS_ERR(chip_data->intpol_base)) {
 		pr_err("mtk_sysirq: unable to map sysirq register\n");
-		ret = -ENOMEM;
+		ret = PTR_ERR(chip_data->intpol_base);
 		goto out_free;
 	}
 
-- 
1.8.1.1.dirty

