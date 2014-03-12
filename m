Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaCLPu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:50:57 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15664 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbaCLPuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:50:55 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-77-5320825c75c4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] mfd: tps65910: Fix possible invalid pointer dereference on
 regmap_add_irq_chip fail
Date: Wed, 12 Mar 2014 16:50:44 +0100
Message-id: <1394639445-7737-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t/xy7oxTQrBBlObLS1evzC0uP/1KKPF
	5V1z2CxOd7NaLNj4iNGB1ePOtT1sHvNOBnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxr4V
	q9kL5vJUXH/ygLGBcS5XFyMnh4SAicTixpfsELaYxIV769m6GLk4hASWMkrsntrEDuH0MUl8
	+LaFBaSKTcBYYvPyJWwgtohAlsSPaavB4swCnhLv/j4EmyQMFP/ePY8VxGYRUJV49fkiE4jN
	K+AmseveLSCbA2ibgsScSTYTGLkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJgK87
	GJceszrEKMDBqMTDO1NJPliINbGsuDL3EKMEB7OSCO/TQoVgId6UxMqq1KL8+KLSnNTiQ4xM
	HJxSDYy8J7WKyt9ZWy26qjpbqbrn9U/hCbb/+2wkJXiCfq3rNLe5wbfbtpNjeRPL/AV/thz6
	f6/+f6G/nVexgp/kzi3iO2VMxerCP3U+4Jfv2scp/StoY9Qb3bXLlk4on1HXGPS7syHs4cyP
	np8rva7NN849/YP/8N6k7KY9D7kt9xT0Z9773l5QH6DEUpyRaKjFXFScCABKxxUW3gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tps65910_irq_init() sets the 'tps65910->chip_irq' before calling
regmap_add_irq_chip(). If this regmap_add_irq_chip() call fails in
memory allocation of regmap_irq_chip_data members then:
1. The 'tps65910->chip_irq' will still hold some value;
2. 'tps65910->irq_data' will be pointing to already freed memory
   (because regmap_add_irq_chip() will free it on error);

This results in invalid memory access during driver remove because the
tps65910_irq_exit() tests whether 'tps65910->chip_irq' is not null.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: 4aab3fadad32 ("mfd: tps65910: Move interrupt implementation code to mfd file")
---
 drivers/mfd/tps65910.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 1f142d76cbbc..d6573318977f 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -251,16 +251,18 @@ static int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		break;
 	}
 
 	tps65910->chip_irq = irq;
 	ret = regmap_add_irq_chip(tps65910->regmap, tps65910->chip_irq,
 		IRQF_ONESHOT, pdata->irq_base,
 		tps6591x_irqs_chip, &tps65910->irq_data);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_warn(tps65910->dev, "Failed to add irq_chip %d\n", ret);
+		tps65910->chip_irq = 0;
+	}
 	return ret;
 }
 
 static int tps65910_irq_exit(struct tps65910 *tps65910)
 {
 	if (tps65910->chip_irq > 0)
 		regmap_del_irq_chip(tps65910->chip_irq, tps65910->irq_data);
-- 
1.7.9.5

