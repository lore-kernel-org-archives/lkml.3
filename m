Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab3FMJyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:54:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8141 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376Ab3FMJyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:54:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 13 Jun 2013 02:53:17 -0700
From: Mayuresh Kulkarni <mkulkarni@nvidia.com>
To: <tbergstrom@nvidia.com>, <amerilainen@nvidia.com>,
        <thierry.reding@avionic-design.de>, <airlied@redhat.com>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Mayuresh Kulkarni <mkulkarni@nvidia.com>
Subject: [PATCH v2 2/4] gpu: host1x: add runtime pm support for gr2d
Date: Thu, 13 Jun 2013 15:23:36 +0530
Message-ID: <1371117218-2326-3-git-send-email-mkulkarni@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1371117218-2326-1-git-send-email-mkulkarni@nvidia.com>
References: <1371117218-2326-1-git-send-email-mkulkarni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mayuresh Kulkarni <mkulkarni@nvidia.com>
---
 drivers/gpu/host1x/drm/gr2d.c | 56 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/gpu/host1x/job.c      |  9 +++++++
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
index 27ffcf1..eb506cd 100644
--- a/drivers/gpu/host1x/drm/gr2d.c
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -22,6 +22,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/clk.h>
+#include <linux/pm_runtime.h>
 
 #include "channel.h"
 #include "drm.h"
@@ -275,11 +276,18 @@ static int gr2d_probe(struct platform_device *pdev)
 		return PTR_ERR(gr2d->clk);
 	}
 
+	platform_set_drvdata(pdev, gr2d);
+
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+#else
 	err = clk_prepare_enable(gr2d->clk);
 	if (err) {
 		dev_err(dev, "cannot turn on clock\n");
 		return err;
 	}
+#endif
 
 	gr2d->channel = host1x_channel_request(dev);
 	if (!gr2d->channel)
@@ -305,7 +313,9 @@ static int gr2d_probe(struct platform_device *pdev)
 
 	gr2d_init_addr_reg_map(dev, gr2d);
 
-	platform_set_drvdata(pdev, gr2d);
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_put(&pdev->dev);
+#endif
 
 	return 0;
 }
@@ -328,10 +338,51 @@ static int __exit gr2d_remove(struct platform_device *pdev)
 
 	host1x_channel_free(gr2d->channel);
 	clk_disable_unprepare(gr2d->clk);
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_disable(&pdev->dev);
+#endif
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_RUNTIME
+static int gr2d_runtime_suspend(struct device *dev)
+{
+	struct gr2d *gr2d;
+
+	gr2d = dev_get_drvdata(dev);
+	if (!gr2d)
+		return -EINVAL;
+
+	clk_disable_unprepare(gr2d->clk);
 
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
+#endif /* CONFIG_PM_RUNTIME */
+
+#ifdef CONFIG_PM
+static const struct dev_pm_ops gr2d_pm_ops = {
+	SET_RUNTIME_PM_OPS(gr2d_runtime_suspend,
+		gr2d_runtime_resume, NULL)
+};
+#endif
+
 struct platform_driver tegra_gr2d_driver = {
 	.probe = gr2d_probe,
 	.remove = __exit_p(gr2d_remove),
@@ -339,5 +390,8 @@ struct platform_driver tegra_gr2d_driver = {
 		.owner = THIS_MODULE,
 		.name = "gr2d",
 		.of_match_table = gr2d_match,
+#ifdef CONFIG_PM
+		.pm = &gr2d_pm_ops,
+#endif
 	}
 };
diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index 05bafa4..a1b05f0 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -23,6 +23,7 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/pm_runtime.h>
 #include <trace/events/host1x.h>
 
 #include "channel.h"
@@ -591,10 +592,18 @@ int host1x_job_submit(struct host1x_job *job)
 {
 	struct host1x *host = dev_get_drvdata(job->channel->dev->parent);
 
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_get_sync(job->channel->dev);
+#endif
+
 	return host1x_hw_channel_submit(host, job);
 }
 
 int host1x_job_complete(struct host1x_job *job)
 {
+#ifdef CONFIG_PM_RUNTIME
+	return pm_runtime_put(job->channel->dev);
+#else
 	return 0;
+#endif
 }
-- 
1.8.1.5

