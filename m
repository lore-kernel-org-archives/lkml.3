Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab3FMJym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:54:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7915 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628Ab3FMJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:54:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 13 Jun 2013 02:53:23 -0700
From: Mayuresh Kulkarni <mkulkarni@nvidia.com>
To: <tbergstrom@nvidia.com>, <amerilainen@nvidia.com>,
        <thierry.reding@avionic-design.de>, <airlied@redhat.com>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Mayuresh Kulkarni <mkulkarni@nvidia.com>
Subject: [PATCH v2 4/4] gpu: host1x: add runtime pm support for host1x
Date: Thu, 13 Jun 2013 15:23:38 +0530
Message-ID: <1371117218-2326-5-git-send-email-mkulkarni@nvidia.com>
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
 drivers/gpu/host1x/dev.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 28e28a2..b43eb29 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -23,6 +23,7 @@
 #include <linux/of_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/pm_runtime.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/host1x.h>
@@ -143,11 +144,16 @@ static int host1x_probe(struct platform_device *pdev)
 		return err;
 	}
 
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+#else
 	err = clk_prepare_enable(host->clk);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
 		return err;
 	}
+#endif
 
 	err = host1x_syncpt_init(host);
 	if (err) {
@@ -165,10 +171,17 @@ static int host1x_probe(struct platform_device *pdev)
 
 	host1x_drm_alloc(pdev);
 
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_put(&pdev->dev);
+#endif
+
 	return 0;
 
 fail_deinit_syncpt:
 	host1x_syncpt_deinit(host);
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_put(&pdev->dev);
+#endif
 	return err;
 }
 
@@ -179,10 +192,51 @@ static int __exit host1x_remove(struct platform_device *pdev)
 	host1x_intr_deinit(host);
 	host1x_syncpt_deinit(host);
 	clk_disable_unprepare(host->clk);
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_disable(&pdev->dev);
+#endif
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_RUNTIME
+static int host1x_runtime_suspend(struct device *dev)
+{
+	struct host1x *host;
+
+	host = dev_get_drvdata(dev);
+	if (!host)
+		return -EINVAL;
+
+	clk_disable_unprepare(host->clk);
 
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
+#endif /* CONFIG_PM_RUNTIME */
+
+#ifdef CONFIG_PM
+static const struct dev_pm_ops host1x_pm_ops = {
+	SET_RUNTIME_PM_OPS(host1x_runtime_suspend,
+		host1x_runtime_resume, NULL)
+};
+#endif
+
 static struct platform_driver tegra_host1x_driver = {
 	.probe = host1x_probe,
 	.remove = __exit_p(host1x_remove),
@@ -190,6 +244,9 @@ static struct platform_driver tegra_host1x_driver = {
 		.owner = THIS_MODULE,
 		.name = "tegra-host1x",
 		.of_match_table = host1x_of_match,
+#ifdef CONFIG_PM
+		.pm = &host1x_pm_ops,
+#endif
 	},
 };
 
-- 
1.8.1.5

