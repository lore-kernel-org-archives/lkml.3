Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaKLOdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:33:49 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60986 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaKLOck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:32:40 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-2e-54636f859c3f
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
Subject: [PATCH v11 5/6] dmaengine: pl330: Add PM sleep support
Date: Wed, 12 Nov 2014 15:32:27 +0100
Message-id: <1415802748-30530-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
References: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xq7qt+ckhBmsXslhsnLGe1WL61AuM
	Fqun/mW1eP3C0OLp5sdMFmeb3rBbdE5cwm4xa8peJovLu+awWXzuPcJocfsyr8XaI3fZLe6e
	Ospmceb0JVaLCb8vsFkcXxtu8bJvP4uDoEdLcw+bx+yOmawei/e8ZPLYtKqTzePOtT1sHluu
	trN4zL77g9Gjb8sqRo8Vq7+ze3zeJBfAFcVlk5Kak1mWWqRvl8CV8WTHE8aCO7wVG9ddZW1g
	nMLdxcjJISFgIjF59Rp2CFtM4sK99WxdjFwcQgJLGSV2/3gMlhAS6GOS2PauCMRmEzCW2Lx8
	CViRiEA7s0TfuqlsIAlmgUVMEk1TFUFsYQF7idU3H7CA2CwCqhLTVrxn6mLk4OAVcJeY/1kK
	YpmcxMljk1lBbE4BD4kv2/6yQexylzhz+SDLBEbeBYwMqxhFU0uTC4qT0nON9IoTc4tL89L1
	kvNzNzFCgvzrDsalx6wOMQpwMCrx8H7QSg4RYk0sK67MPcQowcGsJMK7KwcoxJuSWFmVWpQf
	X1Sak1p8iJGJg1OqgTFJMLlmtojpdn5GveTlhQ097sIBd5f0nzqX2e75/ZfLMTsd0YxD8zee
	DizLnMPTX9xr9fFR16q/dxe6nMx45n2fX6hxeYHoIv0rTnHzunyeRq1qKj36ZcYr8ftrJl0p
	vzM55uG6r49edS6z/Z6ixaKot1VgTsQtE4fXV03a1pw3E3hefSP/eJkSS3FGoqEWc1FxIgB9
	zixpUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add system suspend/resume capabilities to the pl330 driver so the amba
bus clock could be also unprepared to conserve energy.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/dma/pl330.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index c3bd3584f261..fd71777fc565 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2627,6 +2627,42 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
 	return 0;
 }
 
+/*
+ * Runtime PM callbacks are provided by amba/bus.c driver.
+ *
+ * It is assumed here that IRQ safe runtime PM is chosen in probe and amba
+ * bus driver will only disable/enable the clock in runtime PM callbacks.
+ */
+static int __maybe_unused pl330_suspend(struct device *dev)
+{
+	struct amba_device *pcdev = to_amba_device(dev);
+
+	if (!pm_runtime_status_suspended(dev)) {
+		/* amba did not disable the clock */
+		amba_pclk_disable(pcdev);
+	}
+	amba_pclk_unprepare(pcdev);
+
+	return 0;
+}
+
+static int __maybe_unused pl330_resume(struct device *dev)
+{
+	struct amba_device *pcdev = to_amba_device(dev);
+	int ret;
+
+	ret = amba_pclk_prepare(pcdev);
+	if (ret)
+		return ret;
+
+	if (!pm_runtime_status_suspended(dev))
+		ret = amba_pclk_enable(pcdev);
+
+	return ret;
+}
+
+static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
+
 static int
 pl330_probe(struct amba_device *adev, const struct amba_id *id)
 {
@@ -2853,6 +2889,7 @@ static struct amba_driver pl330_driver = {
 	.drv = {
 		.owner = THIS_MODULE,
 		.name = "dma-pl330",
+		.pm = &pl330_pm,
 	},
 	.id_table = pl330_ids,
 	.probe = pl330_probe,
-- 
1.9.1

