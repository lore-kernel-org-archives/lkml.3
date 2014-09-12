Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaILIVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:21:10 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36844 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaILIR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:17:59 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH RESEND v9 3/5] rtc: max77686: Fail to probe if no RTC regmap irqchip is set
Date: Fri, 12 Sep 2014 10:17:41 +0200
Message-Id: <1410509864-10019-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410509864-10019-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1410509864-10019-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max77686 mfd driver adds a regmap IRQ chip which creates an
IRQ domain that is used to map the virtual RTC alarm1 interrupt.

The RTC driver assumes that this will always be true since the
PMIC IRQ is a required property according to the max77686 DT
binding doc. If an "interrupts" property is not defined for a
max77686 PMIC, then the mfd probe function will fail and the
RTC platform driver will never be probed. But even when it is
not possible to probe the rtc-max77686 driver without a regmap
IRQ chip, it's better to explicitly check if the IRQ chip data
is not NULL and gracefully fail instead of getting an OOPS.

Reported-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Fixes the issue reported by Krzystof in: https://lkml.org/lkml/2014/8/8/121
---
 drivers/rtc/rtc-max77686.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 7bb5433..55396bb 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -466,6 +466,12 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 		goto err_rtc;
 	}
 
+	if (!max77686->rtc_irq_data) {
+		ret = -EINVAL;
+		dev_err(&pdev->dev, "%s: no RTC regmap IRQ chip\n", __func__);
+		goto err_rtc;
+	}
+
 	info->virq = regmap_irq_get_virq(max77686->rtc_irq_data,
 					 MAX77686_RTCIRQ_RTCA1);
 	if (!info->virq) {
-- 
2.0.0.rc2

