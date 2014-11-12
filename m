Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaKLOef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:34:35 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63658 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaKLOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:32:38 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-27-54636f8395ca
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
Subject: [PATCH v11 3/6] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
Date: Wed, 12 Nov 2014 15:32:25 +0100
Message-id: <1415802748-30530-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
References: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xq7rN+ckhBreXqVpsnLGe1WL61AuM
	Fqun/mW1eP3C0OLp5sdMFmeb3rBbdE5cwm4xa8peJovLu+awWXzuPcJocfsyr8XaI3fZLe6e
	Ospmceb0JVaLCb8vsFkcXxtu8bJvP4uDoEdLcw+bx+yOmawei/e8ZPLYtKqTzePOtT1sHluu
	trN4zL77g9Gjb8sqRo8Vq7+ze3zeJBfAFcVlk5Kak1mWWqRvl8CVsaS1uGACX8Wzs4vZGhiP
	cHcxcnJICJhINO7dygZhi0lcuLceyObiEBJYyigxs/ssO4TTxySxf2YHK0gVm4CxxOblS8Cq
	RATamSX61k0Fa2cWWMQk0TRVEcQWFkiTmDlpOiOIzSKgKvG+fzcTiM0r4C5x98U/Voh1chIn
	j00GszkFPCS+bPsLNkcIqObM5YMsExh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQI
	CfOvOxiXHrM6xCjAwajEw/tBKzlEiDWxrLgy9xCjBAezkgjvrhygEG9KYmVValF+fFFpTmrx
	IUYmDk6pBkaTw+eDZwfFfXLyqNjxKEjYrkf9Zvf21prPmVJ2qoKNk+UcO+ZxvNm8/nuqvYGu
	yI0PhttjOc5On3eANS+Sb8WWE2zXp06fes71UqiizNS2oNqCW6uP3k1cu+NUUcjX0mM9pwMu
	uagU3jr3PM77V+hrKwmjRudn5tGLmC9Mf2G+7J5ZWWa3ymolluKMREMt5qLiRAADusSuUQIA	AA==
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

