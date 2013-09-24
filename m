Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3IXMMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:12:45 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15350 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3IXMJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:09:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Sep 2013 05:05:55 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <treding@nvidia.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        <mkulkarni@nvidia.com>
Subject: [PATCHv3 2/4] drm/tegra: Add runtime pm support for gr2d
Date: Tue, 24 Sep 2013 15:05:23 +0300
Message-ID: <1380024325-18280-3-git-send-email-amerilainen@nvidia.com>
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

This far we have enabled gr2d clock on device probe and disabled
it on device deinitialisation. This patch adds runtime pm support
for the hardware unit allowing dynamic power management. If pm
runtime is not enabled, gr2d clock is enabled in device probe and
disabled in remove.

Signed-off-by: Mayuresh Kulkarni <mkulkarni@nvidia.com>
Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/drm/gr2d.c | 57 +++++++++++++++++++++++++++++++++++++++----
 drivers/gpu/host1x/job.c      |  5 ++--
 2 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
index 27ffcf1..8d92925 100644
--- a/drivers/gpu/host1x/drm/gr2d.c
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -22,6 +22,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/clk.h>
+#include <linux/pm_runtime.h>
 
 #include "channel.h"
 #include "drm.h"
@@ -45,6 +46,8 @@ static inline struct gr2d *to_gr2d(struct host1x_client *client)
 }
 
 static int gr2d_is_addr_reg(struct device *dev, u32 class, u32 reg);
+static int gr2d_runtime_suspend(struct device *dev);
+static int gr2d_runtime_resume(struct device *dev);
 
 static int gr2d_client_init(struct host1x_client *client,
 			    struct drm_device *drm)
@@ -275,12 +278,18 @@ static int gr2d_probe(struct platform_device *pdev)
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
 	if (!gr2d->channel)
 		return -ENOMEM;
@@ -305,7 +314,7 @@ static int gr2d_probe(struct platform_device *pdev)
 
 	gr2d_init_addr_reg_map(dev, gr2d);
 
-	platform_set_drvdata(pdev, gr2d);
+	pm_runtime_put(&pdev->dev);
 
 	return 0;
 }
@@ -327,11 +336,48 @@ static int __exit gr2d_remove(struct platform_device *pdev)
 		host1x_syncpt_free(gr2d->client.syncpts[i]);
 
 	host1x_channel_free(gr2d->channel);
+
+	if (pm_runtime_enabled(&pdev->dev))
+		pm_runtime_disable(&pdev->dev);
+	else
+		gr2d_runtime_suspend(&pdev->dev);
+
+	return 0;
+}
+
+static int gr2d_runtime_suspend(struct device *dev)
+{
+	struct gr2d *gr2d;
+
+	gr2d = dev_get_drvdata(dev);
+	if (!gr2d)
+		return -EINVAL;
+
 	clk_disable_unprepare(gr2d->clk);
 
 	return 0;
 }
 
+static int gr2d_runtime_resume(struct device *dev)
+{
+	int err = 0;
+	struct gr2d *gr2d;
+
+	gr2d = dev_get_drvdata(dev);
+	if (!gr2d)
+		return -EINVAL;
+
+	err = clk_prepare_enable(gr2d->clk);
+	if (err < 0)
+		dev_err(dev, "failed to enable clock\n");
+
+	return err;
+}
+
+static const struct dev_pm_ops gr2d_pm_ops = {
+	SET_RUNTIME_PM_OPS(gr2d_runtime_suspend, gr2d_runtime_resume, NULL)
+};
+
 struct platform_driver tegra_gr2d_driver = {
 	.probe = gr2d_probe,
 	.remove = __exit_p(gr2d_remove),
@@ -339,5 +385,6 @@ struct platform_driver tegra_gr2d_driver = {
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

