Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaDVN7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:59:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17588 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaDVN7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:59:35 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-73-535675c400c7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] mfd: max14577: Fix IRQ handling after resume if this is
 not a wakeup source
Date: Tue, 22 Apr 2014 15:59:22 +0200
Message-id: <1398175162-20244-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t/xq7pHSsOCDdb+N7HYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFmuP3GW3ON3NanFxxRcmBw6PO9f2sHnMOxno0bdlFaPH501yASxR
	XDYpqTmZZalF+nYJXBndt5ILFgpXPDh/lrmBcRd/FyMHh4SAicSFBzVdjJxAppjEhXvr2boY
	uTiEBJYySpyespQZwuljklj7aDcbSBWbgLHE5uVLwKpEBPoYJZatnAfmMAscZZSY3vuWCaRK
	WCBJ4kHHOXYQm0VAVWLl3idgNq+Au8SU5kmMEPvkJE4em8w6gZF7ASPDKkbR1NLkguKk9FxD
	veLE3OLSvHS95PzcTYyQAPmyg3HxMatDjAIcjEo8vBIGocFCrIllxZW5hxglOJiVRHj3JocF
	C/GmJFZWpRblxxeV5qQWH2Jk4uCUamBM9N9df0czem68h/D+KTNi5hfVzvPQ+5EYkvgzkGed
	zOfuf8LWut9mvvAon19fdtqYnanhgfPlS2x+W5c1aL2uPjZ/W3pKfblF06pst+O5Pt9dO7c/
	Zsli6yid4ytVaPL5xaFuo/qcFaLJZorMW9JPmHeUzFrRydbIdi5E27rgjenjiydtwpVYijMS
	DbWYi4oTAWylSRvuAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend the IRQ should be disabled even if this is not a wakeup
source. This is a proper way of fixing the IRQ handling issue during
resume (IRQ handler fails because I2C bus did not resume yet).

When device is suspended and max14577 interrupt is signaled the irq chip
will try to handle it regardless of wakeup source. Device could be woken
up by different IRQ but still the IRQ handler will try to read the
registers over I2C bus and fail because I2C bus won't be ready yet:
	max14577 2-0025: Failed to read IRQ status: -5

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max14577.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 5f13cefe8def..a24c0ba24cdb 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -183,20 +183,18 @@ static int max14577_suspend(struct device *dev)
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
 	struct max14577 *max14577 = i2c_get_clientdata(i2c);
 
-	if (device_may_wakeup(dev)) {
+	if (device_may_wakeup(dev))
 		enable_irq_wake(max14577->irq);
-		/*
-		 * MUIC IRQ must be disabled during suspend if this is
-		 * a wake up source because it will be handled before
-		 * resuming I2C.
-		 *
-		 * When device is woken up from suspend (e.g. by ADC change),
-		 * an interrupt occurs before resuming I2C bus controller.
-		 * Interrupt handler tries to read registers but this read
-		 * will fail because I2C is still suspended.
-		 */
-		disable_irq(max14577->irq);
-	}
+	/*
+	 * MUIC IRQ must be disabled during suspend because if it happens
+	 * while suspended it will be handled before resuming I2C.
+	 *
+	 * When device is woken up from suspend (e.g. by ADC change),
+	 * an interrupt occurs before resuming I2C bus controller.
+	 * Interrupt handler tries to read registers but this read
+	 * will fail because I2C is still suspended.
+	 */
+	disable_irq(max14577->irq);
 
 	return 0;
 }
@@ -206,10 +204,9 @@ static int max14577_resume(struct device *dev)
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
 	struct max14577 *max14577 = i2c_get_clientdata(i2c);
 
-	if (device_may_wakeup(dev)) {
+	if (device_may_wakeup(dev))
 		disable_irq_wake(max14577->irq);
-		enable_irq(max14577->irq);
-	}
+	enable_irq(max14577->irq);
 
 	return 0;
 }
-- 
1.9.1

