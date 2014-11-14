Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbaKNIv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:51:59 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57110 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbaKNIuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:50:44 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-ff-5465c262d149
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
Subject: [PATCH v12 5/6] dmaengine: pl330: Add PM sleep support
Date: Fri, 14 Nov 2014 09:50:32 +0100
Message-id: <1415955033-29093-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
References: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xy7pJh1JDDA4+5bLYOGM9q8X0qRcY
	LVZP/ctq8fqFocXTzY+ZLM42vWG36Jy4hN1i1pS9TBaXd81hs/jce4TR4vZlXou1R+6yW9w9
	dZTN4szpS6wWE35fYLM4vjbc4mXffhYHQY+W5h42j9kdM1k9Fu95yeSxaVUnm8eda3vYPLZc
	bWfxmH33B6NH35ZVjB4rVn9n9/i8SS6AK4rLJiU1J7MstUjfLoEr4/v/FUwFc/kq2t8cY2lg
	PM3dxcjJISFgIvHn9E52CFtM4sK99WxdjFwcQgJLGSUWtb5mAkkICfQxSZzbVgRiswkYS2xe
	vgSsSESgnVmib91UNpAEs8AiJommqYogtrCAvcSL3l0sIDaLgKpE/5tjYBt4Bdwl1tz5ygqx
	TU7i5LHJYDangIfE5I2rWCCWuUt8vvyHeQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5
	uZsYIWH+ZQfj4mNWhxgFOBiVeHgNClJDhFgTy4orcw8xSnAwK4nwKu0GCvGmJFZWpRblxxeV
	5qQWH2Jk4uCUamD0LNvhaG1lpCch/j0l8/XpFUK7Py2P+CHcyq30Zb/Jpe/x4pf38Wl2MfSf
	eJx7uHWFkJxPp8bduNc582tP8+6fwSt45lyPUX78GkXhtQdkvuzUW/kv3efRhESZxqdzg7aU
	8/r6Tk05eKCwXVPmrpNGvKp9t9Ifjr3p7Z9fHfjZVa/JLHdP1UaJpTgj0VCLuag4EQBGF6/A
	UQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add system suspend/resume capabilities to the pl330 driver so the amba
bus clock could be also unprepared to conserve energy.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/dma/pl330.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index c3bd3584f261..e499bb118f0a 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2627,6 +2627,46 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
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
+	pm_runtime_disable(dev);
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
+	pm_runtime_enable(dev);
+
+	return ret;
+}
+
+static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
+
 static int
 pl330_probe(struct amba_device *adev, const struct amba_id *id)
 {
@@ -2853,6 +2893,7 @@ static struct amba_driver pl330_driver = {
 	.drv = {
 		.owner = THIS_MODULE,
 		.name = "dma-pl330",
+		.pm = &pl330_pm,
 	},
 	.id_table = pl330_ids,
 	.probe = pl330_probe,
-- 
1.9.1

