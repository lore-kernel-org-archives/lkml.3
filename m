Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaKNIwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:52:23 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36630 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbaKNIun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:50:43 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-f9-5465c260c3ef
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v12 3/6] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
Date: Fri, 14 Nov 2014 09:50:30 +0100
Message-id: <1415955033-29093-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
References: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xy7oJh1JDDPY90LPYOGM9q8X0qRcY
	LVZP/ctq8fqFocXTzY+ZLM42vWG36Jy4hN1i1pS9TBaXd81hs/jce4TR4vZlXou1R+6yW9w9
	dZTN4szpS6wWE35fYLM4vjbc4mXffhYHQY+W5h42j9kdM1k9Fu95yeSxaVUnm8eda3vYPLZc
	bWfxmH33B6NH35ZVjB4rVn9n9/i8SS6AK4rLJiU1J7MstUjfLoErY+OTCewFh/kqjhzZy9jA
	+Im7i5GTQ0LARGLfxcXsELaYxIV769m6GLk4hASWMko0nJ7BDOH0MUls/biPEaSKTcBYYvPy
	JWBVIgLtzBJ966aygSSYBRYxSTRNVQSxhQXSJE6tWMkEYrMIqEpcm34ZrJlXwF3i8aKTrBDr
	5CROHpsMZnMKeEhM3riKBcQWAqr5fPkP8wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLz
	czcxQgL9yw7GxcesDjEKcDAq8fAaFKSGCLEmlhVX5h5ilOBgVhLhVdoNFOJNSaysSi3Kjy8q
	zUktPsTIxMEp1cBYnxNdN6dEc7Wyl2V00J31wfeF/6TaMZbPE5KbHyFsbXDt+4LPV1UuF9w6
	9fWQ85RZPPoZvd+Zv2mu1V+hwvoxWetpl37WqYv/nnm+mz/j0TGX1lyfcpsq/S+uPjxFMtnJ
	7/xfCR9sW/vLJb1NqmSXwevTHju6mj2WZHD9rQkwu6Yhwn6sylKJpTgj0VCLuag4EQA1jbkm
	UgIAAA==
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

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/amba/bus.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index a4ac490dd784..c2153a1d1981 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -95,8 +95,12 @@ static int amba_pm_runtime_suspend(struct device *dev)
 	struct amba_device *pcdev = to_amba_device(dev);
 	int ret = pm_generic_runtime_suspend(dev);
 
-	if (ret == 0 && dev->driver)
-		clk_disable_unprepare(pcdev->pclk);
+	if (ret == 0 && dev->driver) {
+		if (pm_runtime_is_irq_safe(dev))
+			clk_disable(pcdev->pclk);
+		else
+			clk_disable_unprepare(pcdev->pclk);
+	}
 
 	return ret;
 }
@@ -107,7 +111,10 @@ static int amba_pm_runtime_resume(struct device *dev)
 	int ret;
 
 	if (dev->driver) {
-		ret = clk_prepare_enable(pcdev->pclk);
+		if (pm_runtime_is_irq_safe(dev))
+			ret = clk_enable(pcdev->pclk);
+		else
+			ret = clk_prepare_enable(pcdev->pclk);
 		/* Failure is probably fatal to the system, but... */
 		if (ret)
 			return ret;
@@ -115,7 +122,7 @@ static int amba_pm_runtime_resume(struct device *dev)
 
 	return pm_generic_runtime_resume(dev);
 }
-#endif
+#endif /* CONFIG_PM */
 
 static const struct dev_pm_ops amba_pm = {
 	.suspend	= pm_generic_suspend,
-- 
1.9.1

