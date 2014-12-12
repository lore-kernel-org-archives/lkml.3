Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934935AbaLLPQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:16:08 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:33983 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933263AbaLLPQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:16:06 -0500
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Beniamino Galvani <b.galvani@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: <yingjoe.chen@gmail.com>, <srv_heupstream@mediatek.com>,
        Marc Zyngier <marc.zyngier@arm.com>, <hc.yen@mediatek.com>,
        <yh.chen@mediatek.com>, <linux-kernel@vger.kernel.org>,
        <nathan.chung@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>, <eddie.huang@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3] irqchip: mtk-sysirq: Use IS_ERR() instead of NULL pointer check
Date: Fri, 12 Dec 2014 23:15:56 +0800
Message-ID: <1418397356-29634-1-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1418205302-22531-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1418205302-22531-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Small fix to the commit message and the reported by tag, the code stay
the same.

Thanks

Joe.C

=============================================
Beniamino noticed a bug that an invalid DT file for the mediatek
interrupt polarity extension will cause kernel oops.

The reason is that the interrupt polarity support for mediatek chips
merely checks for NULL pointer instead of a casted error return
value in mtk_sysirq_of_init() so any other casted error value passes
the NULL pointer check and causes a kernel panic when dereferenced.

Use IS_ERR() and return the error value via PTR_ERR().

Reported-by: Beniamino Galvani <b.galvani@gmail.com>
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

