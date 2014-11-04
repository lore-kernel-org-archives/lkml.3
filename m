Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaKDMxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:53:18 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46565 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbaKDMxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:53:07 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-d7-5458cc30a004
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v9 2/4] amba: Don't unprepare the clocks if device driver wants
 IRQ safe runtime PM
Date: Tue, 04 Nov 2014 13:52:48 +0100
Message-id: <1415105570-7871-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
References: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xq7oGZyJCDP4/VbbYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF6xeGFk83P2ayONv0ht1iyeT5rBadE5ewW8yaspfJ4vKuOWwWn3uPMFrc
	vsxrsfbIXXaLdy8jLO6eOspmceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+yOmawei/e8
	ZPLYtKqTzePOtT1sHov7JrN6LHlziNVjy9V2Fo/Zd38wevRtWcXosWL1d3aPz5vkPPZ+/s0S
	wBvFZZOSmpNZllqkb5fAlbHuaxNTwQ3RitfL/zI3MN4Q7GLk4JAQMJHoX+rbxcgJZIpJXLi3
	nq2LkYtDSGApo0Rf7w9GCKePSeLgwlcsIFVsAsYSm5cvAasSEVjFIvFqz3Uwh1ngI6PEzdUb
	mUGqhAVSJb6fOgJmswioSrSc3s4IYvMKuEnsmPCDFWKfnMTJY5PBbE4Bd4mtG/exgdhCQDVv
	Hr1hm8DIu4CRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSIx83cG49JjVIUYBDkYlHt4V
	8REhQqyJZcWVuYcYJTiYlUR4t50GCvGmJFZWpRblxxeV5qQWH2Jk4uCUamBseKN+dyNXcN87
	n/bj4od+neG73alraPihz2TNmWeV8fJJ7nu46peFhVvu7Kt6PS/vbRbP4yuzzi7RubbYyF9l
	5ipZpYu7Qut52vUCNog8n/yURcu9ceO0iQu+q5TePHj1Ds+KDrPQEK7KhQJX2AKlGbwDXJe5
	Hs1x9GovDemfejYiS2jZsxQlluKMREMt5qLiRADDq2skbwIAAA==
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
 drivers/amba/bus.c       | 24 ++++++++++++++++++++----
 include/linux/amba/bus.h |  1 +
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 47bbdc1b5be3..27ec8882ec8e 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -85,6 +85,13 @@ static struct device_attribute amba_dev_attrs[] = {
 };
 
 #ifdef CONFIG_PM
+
+#ifdef CONFIG_PM_RUNTIME
+#define get_pm_runtime_irq_safe(dev)	((dev)->power.irq_safe)
+#else
+#define get_pm_runtime_irq_safe(dev)	1
+#endif
+
 /*
  * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
  * enable/disable the bus clock at runtime PM suspend/resume as this
@@ -95,8 +102,14 @@ static int amba_pm_runtime_suspend(struct device *dev)
 	struct amba_device *pcdev = to_amba_device(dev);
 	int ret = pm_generic_runtime_suspend(dev);
 
-	if (ret == 0 && dev->driver)
-		clk_disable_unprepare(pcdev->pclk);
+	if (ret == 0 && dev->driver) {
+		pcdev->irq_safe = get_pm_runtime_irq_safe(dev);
+
+		if (pcdev->irq_safe)
+			clk_disable(pcdev->pclk);
+		else
+			clk_disable_unprepare(pcdev->pclk);
+	}
 
 	return ret;
 }
@@ -107,7 +120,10 @@ static int amba_pm_runtime_resume(struct device *dev)
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
@@ -115,7 +131,7 @@ static int amba_pm_runtime_resume(struct device *dev)
 
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

