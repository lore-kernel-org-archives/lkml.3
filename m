Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaIPNBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:01:05 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62377 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbaIPM7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 08:59:37 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ba-54183437312a
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
Subject: [PATCH v5 3/4] amba: Don't unprepare the clocks if device driver wants
 IRQ safe runtime PM
Date: Tue, 16 Sep 2014 14:59:19 +0200
Message-id: <1410872360-27029-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410872360-27029-1-git-send-email-k.kozlowski@samsung.com>
References: <1410872360-27029-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xK7rmJhIhBs8nKlhsnLGe1WL61AuM
	Fqun/mW1OPBnB6PF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLN7emc5iceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+YVWh6L97xk
	8rhzbQ+bx5I3h1g9tlxtZ/GYffcHo0ffllWMHitWf2f3+LxJzmPv598sAdxRXDYpqTmZZalF
	+nYJXBmH5/xiL1ghWnFoykHWBsaZgl2MHBwSAiYSs36YdzFyApliEhfurWfrYuTiEBJYyigx
	7949KKePSeLb5lXMIFVsAsYSm5cvAUuICBxhkXh27wmYwyxwlFFieu9bJpAqYYFUiX83N4N1
	sAioSmzqv8oKYvMKuEs8mXGeEWKfnMTJY5PB4pwCHhLX914DqxcCqrk5dQLzBEbeBYwMqxhF
	U0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCouHLDsbFx6wOMQpwMCrx8Gb8Ew8RYk0sK67MPcQo
	wcGsJMLroSkRIsSbklhZlVqUH19UmpNafIiRiYNTqoFxxpnfrJt3fX6e8eVG2lktiUcTJ/Ze
	+W9ypL7g7K2pHT8aN5xfl95UUmLEv+DiZUbHzSKiPS7xpVlHVXYIrKsWU10vuY757tFd2y22
	tng0cljvmfPK6uaHVqdLpjecazJnKc3h4Ty6ZM3Zm98UPfxCv6t5FHjI7ri1Onm3Istp2eRl
	JuZTGR9wKbEUZyQaajEXFScCAD/jsO5kAgAA
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

