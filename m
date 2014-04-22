Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727AbaDVOJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:09:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8413 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbaDVOAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:00:40 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-14-535676040268
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] mfd: sec-core: Fix IRQ handling after resume if this is
 not a wakeup source
Date: Tue, 22 Apr 2014 16:00:25 +0200
Message-id: <1398175225-20396-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1398175162-20244-1-git-send-email-k.kozlowski@samsung.com>
References: <1398175162-20244-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t/xa7osZWHBBpMXaVlsnLGe1eL1C0OL
	s01v2C3ufz3KaHF51xw2i7VH7rJbnO5mtbi44guTA4fHnWt72DzmnQz06NuyitHj8ya5AJYo
	LpuU1JzMstQifbsErowrF+cwFXwWqpjbw97AOI+/i5GTQ0LARGLdjztsELaYxIV768FsIYGl
	jBKN5426GLmA7D4miS+7u8ESbALGEpuXL2EDSYgI9DFKLFs5D8xhFjjKKDG99y0TSJWwQJLE
	7e8vmUFsFgFVicUPpoPFeQXcJb4+n8sEsU5O4uSxyawgNqeAh8TuA/OZIVa7Sxy+/J99AiPv
	AkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghAfV1B+PSY1aHGAU4GJV4eCUMQoOFWBPL
	iitzDzFKcDArifDuTQ4LFuJNSaysSi3Kjy8qzUktPsTIxMEp1cB4TN4hzf1uUmce2+v5z8/p
	n16tE9P87qRRzUuvq7tfL3PuZOcLPXai83Jr1YXd8qumX2B6GJCs8zk69PTldNGSOy3r6vZ2
	3o0oau61OlfFmM5Q0WETHZh42in9ZsBv1o05HbeOKc0Ue7j78eXpFjafn03TvTDjydOJ+3tL
	GsQb07bcn79K4liVEktxRqKhFnNRcSIAbAmtZwYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend the IRQ should be disabled even if this is not a wakeup
source. This is a proper way of fixing the IRQ handling issue during
resume (IRQ handler fails because I2C bus did not resume yet).

When device is suspended and sec-core interrupt is signaled the irq chip
will try to handle it regardless of wakeup source. Device could be woken
up by different IRQ but still the IRQ handler will try to read the
registers over I2C bus and fail because I2C bus won't be ready yet.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 1cf27521fff4..d2fecb9b37d5 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -424,19 +424,18 @@ static int sec_pmic_suspend(struct device *dev)
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
 	struct sec_pmic_dev *sec_pmic = i2c_get_clientdata(i2c);
 
-	if (device_may_wakeup(dev)) {
+	if (device_may_wakeup(dev))
 		enable_irq_wake(sec_pmic->irq);
-		/*
-		 * PMIC IRQ must be disabled during suspend for RTC alarm
-		 * to work properly.
-		 * When device is woken up from suspend by RTC Alarm, an
-		 * interrupt occurs before resuming I2C bus controller.
-		 * The interrupt is handled by regmap_irq_thread which tries
-		 * to read RTC registers. This read fails (I2C is still
-		 * suspended) and RTC Alarm interrupt is disabled.
-		 */
-		disable_irq(sec_pmic->irq);
-	}
+	/*
+	 * PMIC IRQ must be disabled during suspend for RTC alarm
+	 * to work properly.
+	 * When device is woken up from suspend, an
+	 * interrupt occurs before resuming I2C bus controller.
+	 * The interrupt is handled by regmap_irq_thread which tries
+	 * to read RTC registers. This read fails (I2C is still
+	 * suspended) and RTC Alarm interrupt is disabled.
+	 */
+	disable_irq(sec_pmic->irq);
 
 	return 0;
 }
@@ -446,10 +445,9 @@ static int sec_pmic_resume(struct device *dev)
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
 	struct sec_pmic_dev *sec_pmic = i2c_get_clientdata(i2c);
 
-	if (device_may_wakeup(dev)) {
+	if (device_may_wakeup(dev))
 		disable_irq_wake(sec_pmic->irq);
-		enable_irq(sec_pmic->irq);
-	}
+	enable_irq(sec_pmic->irq);
 
 	return 0;
 }
-- 
1.9.1

