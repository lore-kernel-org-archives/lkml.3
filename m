Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab3ITUSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:18:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41744 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab3ITUPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:15:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arun Kumar K <arun.kk@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 67/93] [media] exynos-gsc: Register v4l2 device
Date: Fri, 20 Sep 2013 13:09:02 -0700
Message-Id: <1379707768-1804-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun Kumar K <arun.kk@samsung.com>

commit d0b1c31349969973204fad21a076aecf131cc5e4 upstream.

Gscaler video device registration was happening without reference to
a parent v4l2_dev causing probe to fail. The patch creates a parent
v4l2 device and uses it for the gsc m2m video device registration.
This fixes regression introduced with comit commit 1c1d86a1ea07506
[media] v4l2: always require v4l2_dev, rename parent to dev_parent

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 9 ++++++++-
 drivers/media/platform/exynos-gsc/gsc-core.h | 1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c  | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 2b1b9f3..661c563 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1121,10 +1121,14 @@ static int gsc_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	ret = gsc_register_m2m_device(gsc);
+	ret = v4l2_device_register(dev, &gsc->v4l2_dev);
 	if (ret)
 		goto err_clk;
 
+	ret = gsc_register_m2m_device(gsc);
+	if (ret)
+		goto err_v4l2;
+
 	platform_set_drvdata(pdev, gsc);
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(&pdev->dev);
@@ -1146,6 +1150,8 @@ err_pm:
 	pm_runtime_put(dev);
 err_m2m:
 	gsc_unregister_m2m_device(gsc);
+err_v4l2:
+	v4l2_device_unregister(&gsc->v4l2_dev);
 err_clk:
 	gsc_clk_put(gsc);
 	return ret;
@@ -1156,6 +1162,7 @@ static int gsc_remove(struct platform_device *pdev)
 	struct gsc_dev *gsc = platform_get_drvdata(pdev);
 
 	gsc_unregister_m2m_device(gsc);
+	v4l2_device_unregister(&gsc->v4l2_dev);
 
 	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 5f157ef..a1b4148 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -343,6 +343,7 @@ struct gsc_dev {
 	unsigned long			state;
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		vdev;
+	struct v4l2_device		v4l2_dev;
 };
 
 /**
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index c267c57..a11be54 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -732,6 +732,7 @@ int gsc_register_m2m_device(struct gsc_dev *gsc)
 	gsc->vdev.release	= video_device_release_empty;
 	gsc->vdev.lock		= &gsc->lock;
 	gsc->vdev.vfl_dir	= VFL_DIR_M2M;
+	gsc->vdev.v4l2_dev	= &gsc->v4l2_dev;
 	snprintf(gsc->vdev.name, sizeof(gsc->vdev.name), "%s.%d:m2m",
 					GSC_MODULE_NAME, gsc->id);
 
-- 
1.8.1.2

