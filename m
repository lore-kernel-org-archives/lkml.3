Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbaKTJyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:54:43 -0500
Received: from s250.sam-solutions.net ([217.21.49.219]:51589 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbaKTJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:54:40 -0500
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <support.opensource@diasemi.com>, <a.zummo@towertech.it>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
CC: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Subject: [PATCH] rtc: da9063: Fix ALARM interrupt registration.
Date: Thu, 20 Nov 2014 12:54:33 +0300
Message-ID: <1416477273-975-1-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call platform_get_irq_byname() returns local IRQ number. Use
regmap_irq_get_virq() to get VIRQ instead.
This fixes rtc initialization error:
da9063-rtc da9063-rtc: Failed to request ALARM IRQ 1: -22

Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
---
 drivers/rtc/rtc-da9063.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-da9063.c b/drivers/rtc/rtc-da9063.c
index 731ed1a..04743a6 100644
--- a/drivers/rtc/rtc-da9063.c
+++ b/drivers/rtc/rtc-da9063.c
@@ -315,6 +315,7 @@ static int da9063_rtc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, rtc);
 
 	irq_alarm = platform_get_irq_byname(pdev, "ALARM");
+	irq_alarm = regmap_irq_get_virq(da9063->regmap_irq, irq_alarm);
 	ret = devm_request_threaded_irq(&pdev->dev, irq_alarm, NULL,
 					da9063_alarm_event,
 					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-- 
2.1.3

