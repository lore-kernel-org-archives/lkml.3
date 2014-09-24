Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaIXNuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:50:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59103 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaIXNuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:50:32 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c0-5422cc24f2d8
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v7 3/5] amba: Don't unprepare the clocks if device driver wants
 IRQ safe runtime PM
Date: Wed, 24 Sep 2014 15:50:10 +0200
Message-id: <1411566612-32277-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1411566612-32277-1-git-send-email-k.kozlowski@samsung.com>
References: <1411566612-32277-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xy7oqZ5RCDE6ssLbYOGM9q8X0qRcY
	LVZP/ctqceDPDkaL1y8MLc42vWG3WDJ5PqvFrCl7mSwWti1hsbi8aw6bxefeI4wWty/zWqw9
	cpfd4t3LCIu7p46yWby9M53F4szpS6wWE35fYLM4vjbc4mXffhYHEY+W5h42j80rtDwW73nJ
	5HHn2h42jyVvDrF6bLnazuIx++4PRo++LasYPVas/s7u8XmTnMfez79ZArijuGxSUnMyy1KL
	9O0SuDJ2HbzKWrBCtOJBywn2BsaZgl2MnBwSAiYS7S++MkHYYhIX7q1n62Lk4hASWMoocfjN
	cUYIp49JYlbnX2aQKjYBY4nNy5eAVYkIHGGReHbvCZjDLHCUUWJ671uwWcICqRKNV/8zgtgs
	AqoS27YeZQexeQXcJb49/8UGsU9O4uSxyaxdjBwcnAIeEm+3aoGEhYBK+nqfs01g5F3AyLCK
	UTS1NLmgOCk911CvODG3uDQvXS85P3cTIyQavuxgXHzM6hCjAAejEg/vBHGlECHWxLLiytxD
	jBIczEoivIdOAYV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwTrxTdz6i1lujr0rstsomrX8VC0zu
	eAe9fnlCeFL+6yMPhPL7BbtYpYO6bl03qtWbfWfl3w6Z8tSlHeI3Lm0SDNSouM2ouTJ6r4qI
	vYyN3vLmtVcmv5wkIR/4/kjpRj/Gm17z/+2LYYs/YbrRKNB2H4Po624mWwc7nWbraff/NXop
	5h5i/39PiaU4I9FQi7moOBEA35E0/WQCAAA=
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

Detect the device driver behavior after calling its probe function and
store it. During runtime suspend/resume deal with clocks according to
stored value.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/amba/bus.c       | 29 +++++++++++++++++++++++++----
 include/linux/amba/bus.h |  1 +
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 3cf61a127ee5..e8fd5706954f 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -94,8 +94,18 @@ static int amba_pm_runtime_suspend(struct device *dev)
 	struct amba_device *pcdev = to_amba_device(dev);
 	int ret = pm_generic_runtime_suspend(dev);
 
-	if (ret == 0 && dev->driver)
-		clk_disable_unprepare(pcdev->pclk);
+	if (ret == 0 && dev->driver) {
+		/*
+		 * Drivers should not change pm_runtime_irq_safe()
+		 * after probe.
+		 */
+		WARN_ON(pcdev->irq_safe != pm_runtime_is_irq_safe(dev));
+
+		if (pcdev->irq_safe)
+			clk_disable(pcdev->pclk);
+		else
+			clk_disable_unprepare(pcdev->pclk);
+	}
 
 	return ret;
 }
@@ -106,7 +116,16 @@ static int amba_pm_runtime_resume(struct device *dev)
 	int ret;
 
 	if (dev->driver) {
-		ret = clk_prepare_enable(pcdev->pclk);
+		/*
+		 * Drivers should not change pm_runtime_irq_safe()
+		 * after probe.
+		 */
+		WARN_ON(pcdev->irq_safe != pm_runtime_is_irq_safe(dev));
+
+		if (pcdev->irq_safe)
+			ret = clk_enable(pcdev->pclk);
+		else
+			ret = clk_prepare_enable(pcdev->pclk);
 		/* Failure is probably fatal to the system, but... */
 		if (ret)
 			return ret;
@@ -191,8 +210,10 @@ static int amba_probe(struct device *dev)
 		pm_runtime_enable(dev);
 
 		ret = pcdrv->probe(pcdev, id);
-		if (ret == 0)
+		if (ret == 0) {
+			pcdev->irq_safe = pm_runtime_is_irq_safe(dev);
 			break;
+		}
 
 		pm_runtime_disable(dev);
 		pm_runtime_set_suspended(dev);
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index bb352d0bd737..fd0c0bfa1d38 100644
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

