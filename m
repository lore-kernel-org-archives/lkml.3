Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaKFIi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:38:28 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64723 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaKFIhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:37:04 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-8e-545b332dacea
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v10 3/5] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
Date: Thu, 06 Nov 2014 09:36:48 +0100
Message-id: <1415263010-7992-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415263010-7992-1-git-send-email-k.kozlowski@samsung.com>
References: <1415263010-7992-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xK7q6xtEhBv1zlS02zljPajF96gVG
	i9VT/7JavH5haPF082Mmi7NNb9gtlkyez2rROXEJu8WsKXuZLC7vmsNm8bn3CKPF7cu8FmuP
	3GW3ePcywuLuqaNsFmdOX2K1mPD7ApvF8bXhFi/79rM4CHu0NPeweczumMnqsXjPSyaPTas6
	2TzuXNvD5rHkzSFWjy1X21k8Zt/9wejRt2UVo8eK1d/ZPT5vkvPY+/k3SwBPFJdNSmpOZllq
	kb5dAldGV88l5oKtQhXnX55gbWBs5O9i5OSQEDCRuNn/igXCFpO4cG89WxcjF4eQwFJGiXlX
	TkM5fUwS697sYQWpYhMwlti8fAlYQkTgOrNE9+N+sHZmgUVMEk1TFUFsYYE0iZ5TF5lAbBYB
	VYn2py+BGjg4eAXcJG5fiYbYJidx8thksJmcAu4Sv5Z8ACsXAipp/zqbfQIj7wJGhlWMoqml
	yQXFSem5RnrFibnFpXnpesn5uZsYIdHwdQfj0mNWhxgFOBiVeHgj2KNDhFgTy4orcw8xSnAw
	K4nwRugBhXhTEiurUovy44tKc1KLDzEycXBKNTAuqHk5ZUYH0wa1a1rfZh/f6x3wzlhuNvvy
	jZE3OZwTyrVan5YrNAmVWDN/CL+99N6Szp3veM6uP7LebM3SeKlJ+0NtDujfefvudYq7gMj8
	p6ZFMssUv+pfy76cXsVSvJGr5twmrugV+97MbZhaUpoWVuUcd0b/1weJv7o/P+jdOXl3cUxN
	4P3/SizFGYmGWsxFxYkAEjnOUmQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMBA bus driver defines runtime Power Management functions which
disable and unprepare AMBA bus clock. This is problematic for runtime PM
because unpreparing a clock might sleep so it is not interrupt safe.

However some drivers may want to implement runtime PM functions in
interrupt-safe way (see pm_runtime_irq_safe()). In such case the AMBA
bus driver should only disable/enable the clock in runtime suspend and
resume callbacks.

Detect the device driver behavior during runtime suspend. During runtime
resume deal with clocks according to stored value.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/amba/bus.c       | 17 +++++++++++++----
 include/linux/amba/bus.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 47bbdc1b5be3..356f906c6966 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -95,8 +95,14 @@ static int amba_pm_runtime_suspend(struct device *dev)
 	struct amba_device *pcdev = to_amba_device(dev);
 	int ret = pm_generic_runtime_suspend(dev);
 
-	if (ret == 0 && dev->driver)
-		clk_disable_unprepare(pcdev->pclk);
+	if (ret == 0 && dev->driver) {
+		pcdev->irq_safe = dev->power.irq_safe;
+
+		if (pcdev->irq_safe)
+			clk_disable(pcdev->pclk);
+		else
+			clk_disable_unprepare(pcdev->pclk);
+	}
 
 	return ret;
 }
@@ -107,7 +113,10 @@ static int amba_pm_runtime_resume(struct device *dev)
 	int ret;
 
 	if (dev->driver) {
-		ret = clk_prepare_enable(pcdev->pclk);
+		if (pcdev->irq_safe)
+			ret = clk_enable(pcdev->pclk);
+		else
+			ret = clk_prepare_enable(pcdev->pclk);
 		/* Failure is probably fatal to the system, but... */
 		if (ret)
 			return ret;
@@ -115,7 +124,7 @@ static int amba_pm_runtime_resume(struct device *dev)
 
 	return pm_generic_runtime_resume(dev);
 }
-#endif
+#endif /* CONFIG_PM */
 
 static const struct dev_pm_ops amba_pm = {
 	.suspend	= pm_generic_suspend,
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index ac02f9bd63dc..c4bae79851fb 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -32,6 +32,7 @@ struct amba_device {
 	struct clk		*pclk;
 	unsigned int		periphid;
 	unsigned int		irq[AMBA_NR_IRQS];
+	unsigned int		irq_safe:1;
 };
 
 struct amba_driver {
-- 
1.9.1

