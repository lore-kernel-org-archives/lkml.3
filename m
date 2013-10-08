Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3JHGch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:32:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2447 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3JHGcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:32:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 Oct 2013 23:32:03 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <treding@nvidia.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        <mkulkarni@nvidia.com>
Subject: [PATCHv4 5/5] gpu: host1x: Add runtime pm support for host1x
Date: Tue, 8 Oct 2013 09:27:28 +0300
Message-ID: <1381213648-5931-6-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1381213648-5931-1-git-send-email-amerilainen@nvidia.com>
References: <1381213648-5931-1-git-send-email-amerilainen@nvidia.com>
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
 drivers/gpu/host1x/dev.c | 56 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 4716302..1179b78 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -23,6 +23,7 @@
 #include <linux/of_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/pm_runtime.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/host1x.h>
@@ -34,6 +35,27 @@
 #include "hw/host1x01.h"
 #include "host1x_client.h"
 
+static int host1x_runtime_suspend(struct device *dev)
+{
+	struct host1x *host = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(host->clk);
+
+	return 0;
+}
+
+static int host1x_runtime_resume(struct device *dev)
+{
+	int err = 0;
+	struct host1x *host = dev_get_drvdata(dev);
+
+	err = clk_prepare_enable(host->clk);
+	if (err < 0)
+		dev_err(dev, "failed to enable clock\n");
+
+	return err;
+}
+
 void host1x_set_drm_data(struct device *dev, void *data)
 {
 	struct host1x *host1x = dev_get_drvdata(dev);
@@ -143,32 +165,42 @@ static int host1x_probe(struct platform_device *pdev)
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
-		return err;
+		goto err_syncpt_init;
 	}
 
 	err = host1x_intr_init(host, syncpt_irq);
 	if (err) {
 		dev_err(&pdev->dev, "failed to initialize interrupts\n");
-		goto fail_deinit_syncpt;
+		goto err_intr_init;
 	}
 
 	host1x_debug_init(host);
 
 	host1x_drm_alloc(pdev);
 
+	pm_runtime_put(&pdev->dev);
+
 	return 0;
 
-fail_deinit_syncpt:
+err_intr_init:
 	host1x_syncpt_deinit(host);
+err_syncpt_init:
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		pm_runtime_disable(&pdev->dev);
+
 	return err;
 }
 
@@ -178,11 +210,18 @@ static int __exit host1x_remove(struct platform_device *pdev)
 
 	host1x_intr_deinit(host);
 	host1x_syncpt_deinit(host);
-	clk_disable_unprepare(host->clk);
+
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		host1x_runtime_suspend(&pdev->dev);
 
 	return 0;
 }
 
+static const struct dev_pm_ops host1x_pm_ops = {
+	SET_RUNTIME_PM_OPS(host1x_runtime_suspend, host1x_runtime_resume, NULL)
+};
+
 static struct platform_driver tegra_host1x_driver = {
 	.probe = host1x_probe,
 	.remove = __exit_p(host1x_remove),
@@ -190,6 +229,7 @@ static struct platform_driver tegra_host1x_driver = {
 		.owner = THIS_MODULE,
 		.name = "tegra-host1x",
 		.of_match_table = host1x_of_match,
+		.pm = &host1x_pm_ops,
 	},
 };
 
-- 
1.8.1.5

