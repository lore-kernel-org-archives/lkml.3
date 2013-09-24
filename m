Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3IXMJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:09:42 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15355 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3IXMJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:09:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Sep 2013 05:09:37 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <treding@nvidia.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        <mkulkarni@nvidia.com>
Subject: [PATCHv3 4/4] gpu: host1x: Add runtime pm support for host1x
Date: Tue, 24 Sep 2013 15:05:25 +0300
Message-ID: <1380024325-18280-5-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380024325-18280-1-git-send-email-amerilainen@nvidia.com>
References: <1380024325-18280-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mayuresh Kulkarni <mkulkarni@nvidia.com>

This patch adds runtime pm support for host1x hardware unit. This
allows host1x clock to be turned off when it is idle. If pm runtime
is not configured, we enable host1x clock in device probe and disable
it in remove.

Signed-off-by: Mayuresh Kulkarni <mkulkarni@nvidia.com>
Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/dev.c | 57 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 4716302..5f0b91e 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -23,6 +23,7 @@
 #include <linux/of_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/pm_runtime.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/host1x.h>
@@ -34,6 +35,9 @@
 #include "hw/host1x01.h"
 #include "host1x_client.h"
 
+static int host1x_runtime_suspend(struct device *dev);
+static int host1x_runtime_resume(struct device *dev);
+
 void host1x_set_drm_data(struct device *dev, void *data)
 {
 	struct host1x *host1x = dev_get_drvdata(dev);
@@ -143,12 +147,15 @@ static int host1x_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	err = clk_prepare_enable(host->clk);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to enable clock\n");
-		return err;
+	pm_runtime_enable(&pdev->dev);
+	if (!pm_runtime_enabled(&pdev->dev)) {
+		err = host1x_runtime_resume(&pdev->dev);
+		if (err < 0)
+			return err;
 	}
 
+	pm_runtime_get_sync(&pdev->dev);
+
 	err = host1x_syncpt_init(host);
 	if (err) {
 		dev_err(&pdev->dev, "failed to initialize syncpts\n");
@@ -165,10 +172,14 @@ static int host1x_probe(struct platform_device *pdev)
 
 	host1x_drm_alloc(pdev);
 
+	pm_runtime_put(&pdev->dev);
+
 	return 0;
 
 fail_deinit_syncpt:
 	host1x_syncpt_deinit(host);
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	return err;
 }
 
@@ -178,11 +189,48 @@ static int __exit host1x_remove(struct platform_device *pdev)
 
 	host1x_intr_deinit(host);
 	host1x_syncpt_deinit(host);
+
+	if (pm_runtime_enabled(&pdev->dev))
+		pm_runtime_disable(&pdev->dev);
+	else
+		host1x_runtime_suspend(&pdev->dev);
+
+	return 0;
+}
+
+static int host1x_runtime_suspend(struct device *dev)
+{
+	struct host1x *host;
+
+	host = dev_get_drvdata(dev);
+	if (!host)
+		return -EINVAL;
+
 	clk_disable_unprepare(host->clk);
 
 	return 0;
 }
 
+static int host1x_runtime_resume(struct device *dev)
+{
+	int err = 0;
+	struct host1x *host;
+
+	host = dev_get_drvdata(dev);
+	if (!host)
+		return -EINVAL;
+
+	err = clk_prepare_enable(host->clk);
+	if (err < 0)
+		dev_err(dev, "failed to enable clock\n");
+
+	return err;
+}
+
+static const struct dev_pm_ops host1x_pm_ops = {
+	SET_RUNTIME_PM_OPS(host1x_runtime_suspend, host1x_runtime_resume, NULL)
+};
+
 static struct platform_driver tegra_host1x_driver = {
 	.probe = host1x_probe,
 	.remove = __exit_p(host1x_remove),
@@ -190,6 +238,7 @@ static struct platform_driver tegra_host1x_driver = {
 		.owner = THIS_MODULE,
 		.name = "tegra-host1x",
 		.of_match_table = host1x_of_match,
+		.pm = &host1x_pm_ops,
 	},
 };
 
-- 
1.8.1.5

