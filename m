Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbaKUP33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:29:29 -0500
Received: from s250.sam-solutions.net ([217.21.49.219]:47976 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbaKUP3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:29:23 -0500
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <support.opensource@diasemi.com>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Subject: [PATCH v2 2/2] regulator: da9063: Do not transform local IRQ to virtual
Date: Fri, 21 Nov 2014 18:29:08 +0300
Message-ID: <1416583748-6622-3-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1416583748-6622-1-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1416583748-6622-1-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call platform_get_irq_byname() already returns VIRQ instead of local
IRQ. Passing this value to regmap_irq_get_virq() causes error which
results in IRQ registration failure. This patch fixes such behaviour.

Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
---
 drivers/regulator/da9063-regulator.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 7c9461d..37dd427 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -867,17 +867,14 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 		return irq;
 	}
 
-	regulators->irq_ldo_lim = regmap_irq_get_virq(da9063->regmap_irq, irq);
-	if (regulators->irq_ldo_lim >= 0) {
-		ret = request_threaded_irq(regulators->irq_ldo_lim,
-					   NULL, da9063_ldo_lim_event,
-					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-					   "LDO_LIM", regulators);
-		if (ret) {
-			dev_err(&pdev->dev,
-					"Failed to request LDO_LIM IRQ.\n");
-			regulators->irq_ldo_lim = -ENXIO;
-		}
+	ret = request_threaded_irq(irq,
+				NULL, da9063_ldo_lim_event,
+				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				"LDO_LIM", regulators);
+	if (ret) {
+		dev_err(&pdev->dev,
+				"Failed to request LDO_LIM IRQ.\n");
+		regulators->irq_ldo_lim = -ENXIO;
 	}
 
 	return 0;
-- 
2.1.3

