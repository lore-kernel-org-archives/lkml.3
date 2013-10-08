Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3JHGcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:32:06 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2445 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3JHGb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:31:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 Oct 2013 23:27:50 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <treding@nvidia.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        <mkulkarni@nvidia.com>
Subject: [PATCHv4 3/5] drm/tegra: Add runtime pm support for gr2d
Date: Tue, 8 Oct 2013 09:27:26 +0300
Message-ID: <1381213648-5931-4-git-send-email-amerilainen@nvidia.com>
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

This far we have enabled gr2d clock on device probe and disabled
it on device deinitialisation. This patch adds runtime pm support
for the hardware unit allowing dynamic power management. If pm
runtime is not enabled, gr2d clock is enabled in device probe and
disabled in remove.

Signed-off-by: Mayuresh Kulkarni <mkulkarni@nvidia.com>
Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/drm/gr2d.c | 52 +++++++++++++++++++++++++++++++++++++------
 drivers/gpu/host1x/job.c      |  5 +++--
 2 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
index 60150ad..ba2928e 100644
--- a/drivers/gpu/host1x/drm/gr2d.c
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -22,6 +22,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/clk.h>
+#include <linux/pm_runtime.h>
 
 #include "channel.h"
 #include "drm.h"
@@ -46,6 +47,27 @@ static inline struct gr2d *to_gr2d(struct host1x_client *client)
 
 static int gr2d_is_addr_reg(struct device *dev, u32 class, u32 reg);
 
+static int gr2d_runtime_suspend(struct device *dev)
+{
+	struct gr2d *gr2d = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(gr2d->clk);
+
+	return 0;
+}
+
+static int gr2d_runtime_resume(struct device *dev)
+{
+	int err = 0;
+	struct gr2d *gr2d = dev_get_drvdata(dev);
+
+	err = clk_prepare_enable(gr2d->clk);
+	if (err < 0)
+		dev_err(dev, "failed to enable clock\n");
+
+	return err;
+}
+
 static int gr2d_client_init(struct host1x_client *client,
 			    struct drm_device *drm)
 {
@@ -275,12 +297,18 @@ static int gr2d_probe(struct platform_device *pdev)
 		return PTR_ERR(gr2d->clk);
 	}
 
-	err = clk_prepare_enable(gr2d->clk);
-	if (err) {
-		dev_err(dev, "cannot turn on clock\n");
-		return err;
+	/* pm runtime accesses the clock through driver data */
+	platform_set_drvdata(pdev, gr2d);
+
+	pm_runtime_enable(&pdev->dev);
+	if (!pm_runtime_enabled(&pdev->dev)) {
+		err = gr2d_runtime_resume(&pdev->dev);
+		if (err < 0)
+			return err;
 	}
 
+	pm_runtime_get_sync(&pdev->dev);
+
 	gr2d->channel = host1x_channel_request(dev);
 	if (!gr2d->channel) {
 		err = -ENOMEM;
@@ -307,7 +335,7 @@ static int gr2d_probe(struct platform_device *pdev)
 
 	gr2d_init_addr_reg_map(dev, gr2d);
 
-	platform_set_drvdata(pdev, gr2d);
+	pm_runtime_put(&pdev->dev);
 
 	return 0;
 
@@ -316,7 +344,9 @@ err_register_client:
 err_syncpt_request:
 	host1x_channel_free(gr2d->channel);
 err_channel_request:
-	clk_disable_unprepare(gr2d->clk);
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		gr2d_runtime_suspend(&pdev->dev);
 
 	return err;
 }
@@ -338,11 +368,18 @@ static int __exit gr2d_remove(struct platform_device *pdev)
 		host1x_syncpt_free(gr2d->client.syncpts[i]);
 
 	host1x_channel_free(gr2d->channel);
-	clk_disable_unprepare(gr2d->clk);
+
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		gr2d_runtime_suspend(&pdev->dev);
 
 	return 0;
 }
 
+static const struct dev_pm_ops gr2d_pm_ops = {
+	SET_RUNTIME_PM_OPS(gr2d_runtime_suspend, gr2d_runtime_resume, NULL)
+};
+
 struct platform_driver tegra_gr2d_driver = {
 	.probe = gr2d_probe,
 	.remove = __exit_p(gr2d_remove),
@@ -350,5 +387,6 @@ struct platform_driver tegra_gr2d_driver = {
 		.owner = THIS_MODULE,
 		.name = "gr2d",
 		.of_match_table = gr2d_match,
+		.pm = &gr2d_pm_ops,
 	}
 };
diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index 3928b4e..e4148e0 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -23,6 +23,7 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/pm_runtime.h>
 #include <trace/events/host1x.h>
 
 #include "channel.h"
@@ -589,11 +590,11 @@ void host1x_job_dump(struct device *dev, struct host1x_job *job)
 int host1x_job_submit(struct host1x_job *job)
 {
 	struct host1x *host = dev_get_drvdata(job->channel->dev->parent);
-
+	pm_runtime_get_sync(job->channel->dev);
 	return host1x_hw_channel_submit(host, job);
 }
 
 int host1x_job_complete(struct host1x_job *job)
 {
-	return 0;
+	return pm_runtime_put(job->channel->dev);
 }
-- 
1.8.1.5

