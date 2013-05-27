Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab3E0Ntr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:49:47 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14009 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab3E0Ntp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:49:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 27 May 2013 06:49:39 -0700
From: Mayuresh Kulkarni <mkulkarni@nvidia.com>
To: <tbergstrom@nvidia.com>, <amerilainen@nvidia.com>,
        <thierry.reding@avionic-design.de>, <airlied@redhat.com>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Mayuresh Kulkarni <mkulkarni@nvidia.com>
Subject: [PATCH] drm/tegra: add support for runtime pm
Date: Mon, 27 May 2013 19:19:28 +0530
Message-ID: <1369662568-22390-1-git-send-email-mkulkarni@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- as of now host1x and gr2d module's clocks are enabled
in their driver's .probe and never disabled
- this commit adds support for runtime pm in host1x and
gr2d drivers
- during boot-up clocks are enabled in .probe and disabled
on its exit
- when new work is submitted, clocks are enabled in submit
and disabled when submit completes
- parent->child relation between host1x and gr2d ensures
that host1x clock is also enabled before enabling gr2d clock
and it is turned off after gr2d clock is turned off

Signed-off-by: Mayuresh Kulkarni <mkulkarni@nvidia.com>
---
 drivers/gpu/host1x/channel.c  |  5 ++++
 drivers/gpu/host1x/dev.c      | 58 ++++++++++++++++++++++++++++++++++++++----
 drivers/gpu/host1x/drm/gr2d.c | 59 ++++++++++++++++++++++++++++++++++++++-----
 drivers/gpu/host1x/intr.c     |  9 +++++--
 4 files changed, 118 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/host1x/channel.c b/drivers/gpu/host1x/channel.c
index 83ea51b..b71caec 100644
--- a/drivers/gpu/host1x/channel.c
+++ b/drivers/gpu/host1x/channel.c
@@ -18,6 +18,7 @@
 
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/pm_runtime.h>
 
 #include "channel.h"
 #include "dev.h"
@@ -41,6 +42,10 @@ int host1x_job_submit(struct host1x_job *job)
 {
 	struct host1x *host = dev_get_drvdata(job->channel->dev->parent);
 
+	/* enable clocks
+	 * they will be disabled in action_submit_complete */
+	pm_runtime_get_sync(job->channel->dev);
+
 	return host1x_hw_channel_submit(host, job);
 }
 
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 28e28a2..93d9d72 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -23,6 +23,7 @@
 #include <linux/of_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/pm_runtime.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/host1x.h>
@@ -143,11 +144,11 @@ static int host1x_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	err = clk_prepare_enable(host->clk);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to enable clock\n");
-		return err;
-	}
+	/* enable runtime pm */
+	pm_runtime_enable(&pdev->dev);
+
+	/* enable clocks */
+	pm_runtime_get_sync(&pdev->dev);
 
 	err = host1x_syncpt_init(host);
 	if (err) {
@@ -165,6 +166,9 @@ static int host1x_probe(struct platform_device *pdev)
 
 	host1x_drm_alloc(pdev);
 
+	/* disable clocks */
+	pm_runtime_put(&pdev->dev);
+
 	return 0;
 
 fail_deinit_syncpt:
@@ -183,6 +187,47 @@ static int __exit host1x_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static int host1x_runtime_suspend(struct device *dev)
+{
+	struct host1x *host;
+
+	host = dev_get_drvdata(dev);
+	if (IS_ERR_OR_NULL(host))
+		return -EINVAL;
+
+	clk_disable_unprepare(host->clk);
+
+	return 0;
+}
+
+static int host1x_runtime_resume(struct device *dev)
+{
+	int err = 0;
+	struct host1x *host;
+
+	host = dev_get_drvdata(dev);
+	if (IS_ERR_OR_NULL(host))
+		return -EINVAL;
+
+	err = clk_prepare_enable(host->clk);
+	if (err < 0)
+		dev_err(dev, "failed to enable clock\n");
+
+	return err;
+}
+#endif /* CONFIG_PM_RUNTIME */
+
+#ifdef CONFIG_PM
+static const struct dev_pm_ops host1x_pm_ops = {
+#ifdef CONFIG_PM_RUNTIME
+	.runtime_suspend = host1x_runtime_suspend,
+	.runtime_resume = host1x_runtime_resume,
+#endif
+};
+
+#endif /* CONFIG_PM */
+
 static struct platform_driver tegra_host1x_driver = {
 	.probe = host1x_probe,
 	.remove = __exit_p(host1x_remove),
@@ -190,6 +235,9 @@ static struct platform_driver tegra_host1x_driver = {
 		.owner = THIS_MODULE,
 		.name = "tegra-host1x",
 		.of_match_table = host1x_of_match,
+#ifdef CONFIG_PM
+		.pm = &host1x_pm_ops,
+#endif
 	},
 };
 
diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
index 6a45ae0..172a654 100644
--- a/drivers/gpu/host1x/drm/gr2d.c
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -22,6 +22,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/clk.h>
+#include <linux/pm_runtime.h>
 
 #include "channel.h"
 #include "drm.h"
@@ -271,11 +272,13 @@ static int gr2d_probe(struct platform_device *pdev)
 		return PTR_ERR(gr2d->clk);
 	}
 
-	err = clk_prepare_enable(gr2d->clk);
-	if (err) {
-		dev_err(dev, "cannot turn on clock\n");
-		return err;
-	}
+	platform_set_drvdata(pdev, gr2d);
+
+	/* enable runtime pm */
+	pm_runtime_enable(&pdev->dev);
+
+	/* enable clocks */
+	pm_runtime_get_sync(&pdev->dev);
 
 	gr2d->channel = host1x_channel_request(dev);
 	if (!gr2d->channel)
@@ -301,7 +304,8 @@ static int gr2d_probe(struct platform_device *pdev)
 
 	gr2d_init_addr_reg_map(dev, gr2d);
 
-	platform_set_drvdata(pdev, gr2d);
+	/* disable clocks */
+	pm_runtime_put(&pdev->dev);
 
 	return 0;
 }
@@ -328,6 +332,46 @@ static int __exit gr2d_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static int gr2d_runtime_suspend(struct device *dev)
+{
+	struct gr2d *gr2d;
+
+	gr2d = dev_get_drvdata(dev);
+	if (IS_ERR_OR_NULL(gr2d))
+		return -EINVAL;
+
+	clk_disable_unprepare(gr2d->clk);
+
+	return 0;
+}
+
+static int gr2d_runtime_resume(struct device *dev)
+{
+	int err = 0;
+	struct gr2d *gr2d;
+
+	gr2d = dev_get_drvdata(dev);
+	if (IS_ERR_OR_NULL(gr2d))
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
+#ifdef CONFIG_PM_RUNTIME
+	.runtime_suspend = gr2d_runtime_suspend,
+	.runtime_resume = gr2d_runtime_resume,
+#endif
+};
+#endif /* CONFIG_PM */
+
 struct platform_driver tegra_gr2d_driver = {
 	.probe = gr2d_probe,
 	.remove = __exit_p(gr2d_remove),
@@ -335,5 +379,8 @@ struct platform_driver tegra_gr2d_driver = {
 		.owner = THIS_MODULE,
 		.name = "gr2d",
 		.of_match_table = gr2d_match,
+#ifdef CONFIG_PM
+		.pm = &gr2d_pm_ops,
+#endif
 	}
 };
diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
index 2491bf8..c23fb64 100644
--- a/drivers/gpu/host1x/intr.c
+++ b/drivers/gpu/host1x/intr.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
+#include <linux/pm_runtime.h>
 
 #include <trace/events/host1x.h>
 #include "channel.h"
@@ -109,14 +110,18 @@ static void reset_threshold_interrupt(struct host1x *host,
 
 static void action_submit_complete(struct host1x_waitlist *waiter)
 {
+	int completed = waiter->count;
 	struct host1x_channel *channel = waiter->data;
 
+	/* disable clocks for all the submits that got completed in this lot */
+	while (completed--)
+		pm_runtime_put(channel->dev);
+
 	host1x_cdma_update(&channel->cdma);
 
-	/*  Add nr_completed to trace */
+	/* Add nr_completed to trace */
 	trace_host1x_channel_submit_complete(dev_name(channel->dev),
 					     waiter->count, waiter->thresh);
-
 }
 
 static void action_wakeup(struct host1x_waitlist *waiter)
-- 
1.8.1.5

