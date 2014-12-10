Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaLJJzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:55:22 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:53478 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751520AbaLJJzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:55:16 -0500
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Marc Zyngier <marc.zyngier@arm.com>, <srv_heupstream@mediatek.com>,
        <hc.yen@mediatek.com>, <yh.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <nathan.chung@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, <eddie.huang@mediatek.com>,
        <yingjoe.chen@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: [PATCH v2] irqchip: mediatek: Use IS_ERR() instead of NULL pointer check
Date: Wed, 10 Dec 2014 17:55:02 +0800
Message-ID: <1418205302-22531-1-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1418050989-21411-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1418050989-21411-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beniamino reported a kernel oops caused by an invalid DT file for the
mediatek interrupt polarity extension.

The reason is that the interrupt polarity support for mediatek chips
merely checks for NULL pointer instead of a casted error return
value in mtk_sysirq_of_init() so any other casted error value passes
the NULL pointer check and causes a kernel panic when dereferenced.

Use IS_ERR() and return the error value via PTR_ERR().

Reported-and-tested-by: Beniamino Galvani <b.galvani@gmail.com>
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

