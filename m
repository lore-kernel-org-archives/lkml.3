Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaJTJFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:05:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9537 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbaJTJFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:05:24 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-54-5444d051bdb7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v8 3/5] amba: Don't unprepare the clocks if device driver wants
 IRQ safe runtime PM
Date: Mon, 20 Oct 2014 11:04:46 +0200
Message-id: <1413795888-18559-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xa7qBF1xCDJa/4LXYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLM6cvsRqMeH3BTaL42vDLV727WdxEPZoae5h81i85yWTx51re4Csvsms
	HkveHGL12HK1ncVj9t0fjB59W1YxeqxY/Z3d4/MmOY+9n3+zBHBHcdmkpOZklqUW6dslcGXc
	mHGOreC2aMXuE30sDYzHBbsYOTkkBEwkHiz4wAhhi0lcuLeeDcQWEljKKHHsSWUXIxeQ3cck
	sevmYlaQBJuAscTm5UvYQBIiAsdZJBb3XABzmAWmMEo0T1rKBFIlLJAq8XjfU2YQm0VAVWLV
	xVtgK3gF3CWmz9gNtU5O4uSxyWBTOQU8JKa3PGaEWO0u0b1wFdMERt4FjAyrGEVTS5MLipPS
	c430ihNzi0vz0vWS83M3MUKi4OsOxqXHrA4xCnAwKvHw7jBzCRFiTSwrrsw9xCjBwawkwst0
	FCjEm5JYWZValB9fVJqTWnyIkYmDU6qB8eZGjns8bScTos2j1vd+kn13SXbu8jPasmknV5gd
	OmGodNHtlbnGqr+H723c0C6jF7G8/I9j2Ps5mwtPnwvndY9zsAmUP3hN/n+GTla0QLEPn1CT
	sWbh9Xv1nnu33Zly8/O9149Ort6Yfr1v6ymr/INW62eGmzmxK52Ru75TqN0p5sOt33ceWimx
	FGckGmoxFxUnAgA+LO62YAIAAA==
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
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/amba/bus.c       | 29 +++++++++++++++++++++++++----
 include/linux/amba/bus.h |  1 +
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 47bbdc1b5be3..474434e1b1b9 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -95,8 +95,18 @@ static int amba_pm_runtime_suspend(struct device *dev)
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
@@ -107,7 +117,16 @@ static int amba_pm_runtime_resume(struct device *dev)
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
@@ -198,8 +217,10 @@ static int amba_probe(struct device *dev)
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

