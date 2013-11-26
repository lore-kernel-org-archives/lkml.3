Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab3KZNvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:51:38 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62485 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab3KZNur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:50:47 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-a0-5294a7309b4c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/5] mfd: sec: Add PM ops and make it a wake up source
Date: Tue, 26 Nov 2013 14:50:27 +0100
Message-id: <1385473828-31078-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
References: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4FV2D5VOCDHYeVrRYcvEqu8WzW3uZ
	LF6/MLQ42/SG3eL+16OMFpd3zWGzWHvkLrvF/s4ORovT3awWF1d8YXLg8tgz8SSbx51re9g8
	Dh3uYPSYdzLQo2/LKkaP6fN+Mnl83iQXwB7FZZOSmpNZllqkb5fAldG7egdjwRbxitnLZ7I0
	MP4U6mLk5JAQMJG4dvwlK4QtJnHh3nq2LkYuDiGBpYwSvb9/sEA4fUwSvz/dZgOpYhMwlti8
	fAlYlYjAVUaJiUsWs4M4zAK7GCXe/tzFCFIlLOAm8fXTbKAEBweLgKrElU/GIGFeAXeJF9vO
	soKEJQQUJOZMsgEJcwp4SMzsWcYCYgsBlZw7uItpAiPvAkaGVYyiqaXJBcVJ6blGesWJucWl
	eel6yfm5mxghIfh1B+PSY1aHGAU4GJV4eCU6JwcJsSaWFVfmHmKU4GBWEuGNnT4lSIg3JbGy
	KrUoP76oNCe1+BAjEwenVAOj0abCsvPPPjdpn2E22D7XWPmlzkyRKdNNrWLaI+On+vbeXdHM
	EGD6YdN8K7GVKipTVoiznX9+ra9Ec0Jt2ZG3W9WsXzHOmBj9rHcjg1Z7MONlvRSxgn7XSF/l
	Pd8PBdpaz9890++VzZnXDpwKjXWqe6YG8e4P2Lqii+eITu3GEyyBh6fotVgpsRRnJBpqMRcV
	JwIAQ+8w9B8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PM suspend/resume ops to the sec MFD core driver and make it a wake
up source. This allows proper waking from suspend to RAM and also fixes
broken interrupts after resuming:
[   42.705703] sec_pmic 7-0066: Failed to read IRQ status: -5

Interrupts stop working after first resume initiated by them (e.g. by
RTC Alarm interrupt) because interrupt registers were not cleared properly.

When device is woken up from suspend by RTC Alarm, an interrupt occurs
before resuming I2C bus controller. The interrupt is handled by
regmap_irq_thread which tries to read RTC registers. This read fails
(I2C is still suspended) and RTC Alarm interrupt is disabled.

Disable the S5M8767 interrupts during suspend (disable_irq()) and enable
them during resume so the device will be still woken up but the interrupt
won't happen before resuming I2C bus.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/sec-core.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index a1a413a..8c86da4 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -323,6 +323,8 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	if (ret)
 		goto err;
 
+	device_init_wakeup(sec_pmic->dev, sec_pmic->wakeup);
+
 	return ret;
 
 err:
@@ -341,6 +343,43 @@ static int sec_pmic_remove(struct i2c_client *i2c)
 	return 0;
 }
 
+static int sec_pmic_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct sec_pmic_dev *sec_pmic = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev)) {
+		enable_irq_wake(sec_pmic->irq);
+		/*
+		 * PMIC IRQ must be disabled during suspend for RTC alarm
+		 * to work properly.
+		 * When device is woken up from suspend by RTC Alarm, an
+		 * interrupt occurs before resuming I2C bus controller.
+		 * The interrupt is handled by regmap_irq_thread which tries
+		 * to read RTC registers. This read fails (I2C is still
+		 * suspended) and RTC Alarm interrupt is disabled.
+		 */
+		disable_irq(sec_pmic->irq);
+	}
+
+	return 0;
+}
+
+static int sec_pmic_resume(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct sec_pmic_dev *sec_pmic = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev)) {
+		disable_irq_wake(sec_pmic->irq);
+		enable_irq(sec_pmic->irq);
+	}
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(sec_pmic_pm_ops, sec_pmic_suspend, sec_pmic_resume);
+
 static const struct i2c_device_id sec_pmic_id[] = {
 	{ "sec_pmic", 0 },
 	{ }
@@ -351,6 +390,7 @@ static struct i2c_driver sec_pmic_driver = {
 	.driver = {
 		   .name = "sec_pmic",
 		   .owner = THIS_MODULE,
+		   .pm = &sec_pmic_pm_ops,
 		   .of_match_table = of_match_ptr(sec_dt_match),
 	},
 	.probe = sec_pmic_probe,
-- 
1.7.9.5

