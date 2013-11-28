Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab3K1IKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:10:50 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21097 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3K1IJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:09:58 -0500
X-AuditID: cbfec7f4-b7fea6d0000026ac-68-5296fa565b8a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 4/5] rtc: s5m: Enable IRQ wake during suspend
Date: Thu, 28 Nov 2013 09:09:42 +0100
Message-id: <1385626183-22990-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t/xK7phv6YFGcxczGGx5OJVdoupD5+w
	WTy7tZfJ4vULQ4uzTW/YLe5/Pcpo8e1KB5PF5V1z2CzWHrnLbrG/s4PR4nQ3q8XFFV+YHHg8
	ds66y+6xZ+JJNo9NqzrZPO5c28PmcehwB6PHvJOBHn1bVjF6TJ/3k8nj8ya5AM4oLpuU1JzM
	stQifbsErozT686zFvzjruhadomtgfE5ZxcjJ4eEgInEp2fT2CFsMYkL99azdTFycQgJLGWU
	mPXxITuE08ckcWTVfTaQKjYBY4nNy5eAVYkIzGWSmP72LCOIwyywi1Hi7c9dQA4Hh7CAg8Tu
	mXogDSwCqhJtz/sZQWxeAXeJTWdWsoGUSAgoSMyZZAMS5hTwkNgzfx8riC0EVPLz8xy2CYy8
	CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEhOqXHYyLj1kdYhTgYFTi4T2gOS1IiDWx
	rLgy9xCjBAezkgivQjFQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2Pk20sODzkb+pPeMN9+f3Tv
	yQ/tt6bcOx/GsyCX539L/zKl1L3yXkK+88oqlxVd+XKkRkIt2HB3tkNj19LFZVJnFHsrZzC+
	s8rafpNZUtDVbGHINdbQEJ6w7OlCS0WbpvQcXjH7zLJPEyXC98xmOax7SlqEe9fsBTWlxszH
	LFtKnQ9HzJnv3KPEUpyRaKjFXFScCACYtTIRMwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PM suspend/resume ops to rtc-s5m driver and enable IRQ wake during
suspend so the RTC would act like a wake up source. This allows waking
up from suspend to RAM on RTC alarm interrupt.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/rtc-s5m.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 51471c1..ae8119d 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -639,6 +639,30 @@ static void s5m_rtc_shutdown(struct platform_device *pdev)
 	s5m_rtc_enable_smpl(info, false);
 }
 
+static int s5m_rtc_resume(struct device *dev)
+{
+	struct s5m_rtc_info *info = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (device_may_wakeup(dev))
+		ret = disable_irq_wake(info->irq);
+
+	return ret;
+}
+
+static int s5m_rtc_suspend(struct device *dev)
+{
+	struct s5m_rtc_info *info = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (device_may_wakeup(dev))
+		ret = enable_irq_wake(info->irq);
+
+	return ret;
+}
+
+static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
+
 static const struct platform_device_id s5m_rtc_id[] = {
 	{ "s5m-rtc", 0 },
 };
@@ -647,6 +671,7 @@ static struct platform_driver s5m_rtc_driver = {
 	.driver		= {
 		.name	= "s5m-rtc",
 		.owner	= THIS_MODULE,
+		.pm	= &s5m_rtc_pm_ops,
 	},
 	.probe		= s5m_rtc_probe,
 	.shutdown	= s5m_rtc_shutdown,
-- 
1.7.9.5

