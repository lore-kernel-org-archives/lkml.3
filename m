Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaIVJrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:47:05 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34911 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaIVJq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:46:57 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-24-541ff00f03c2
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
Subject: [PATCH v6 3/4] amba: Don't unprepare the clocks if device driver wants
 IRQ safe runtime PM
Date: Mon, 22 Sep 2014 11:46:28 +0200
Message-id: <1411379189-3017-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1411379189-3017-1-git-send-email-k.kozlowski@samsung.com>
References: <1411379189-3017-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xq7r8H+RDDF42mFtsnLGe1WL61AuM
	Fqun/mW1OPBnB6PF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLN7emc5iceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+YVWh6L97xk
	8rhzbQ+bx5I3h1g9tlxtZ/GYffcHo0ffllWMHitWf2f3+LxJzmPv598sAdxRXDYpqTmZZalF
	+nYJXBmH5/xiL1ghWnFoykHWBsaZgl2MnBwSAiYSfXu/skDYYhIX7q1n62Lk4hASWMooMX/H
	GUYIp49J4v6TRcwgVWwCxhKbly8BqxIROMIi8ezeEzCHWeAoo8T03rdMIFXCAqkSt15vA+rg
	4GARUJVoWJ4MEuYVcJP4smo+O8Q6OYmTxyazgticAu4S+5+1gMWFgGqOHJrNNIGRdwEjwypG
	0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkGj4soNx8TGrQ4wCHIxKPLwLmuRDhFgTy4orcw8x
	SnAwK4nwPn0OFOJNSaysSi3Kjy8qzUktPsTIxMEp1cDo1ddzUPZN/YTVM8wYX4WvjLz4RFky
	7eMlCx6+nZHhMef6F2nqaYbd/2eoneO92UJb4snNldsbgj+mP1St0xA4cs/mwYrfG9+HbXu6
	lXv9z++5672Wf1Ls/jXrSOG3J0nZyb9nmW7YdFs65/XqP08mlR+/MLPs5K/Kddkubpvvqce2
	f1m4Y+sSVSWW4oxEQy3mouJEAFJIypVkAgAA
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
index ad52027a9cbf..ce101e4497d6 100644
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

