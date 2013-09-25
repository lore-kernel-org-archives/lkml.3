Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3IYBBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:01:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab3IYAQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arun Kumar K <arun.kk@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [ 074/110] media: exynos-gsc: Register v4l2 device
Date: Tue, 24 Sep 2013 17:15:12 -0700
Message-Id: <20130925001331.441162201@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/exynos-gsc/gsc-core.c |    9 ++++++++-
 drivers/media/platform/exynos-gsc/gsc-core.h |    1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |    1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1122,10 +1122,14 @@ static int gsc_probe(struct platform_dev
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
@@ -1147,6 +1151,8 @@ err_pm:
 	pm_runtime_put(dev);
 err_m2m:
 	gsc_unregister_m2m_device(gsc);
+err_v4l2:
+	v4l2_device_unregister(&gsc->v4l2_dev);
 err_clk:
 	gsc_clk_put(gsc);
 	return ret;
@@ -1157,6 +1163,7 @@ static int gsc_remove(struct platform_de
 	struct gsc_dev *gsc = platform_get_drvdata(pdev);
 
 	gsc_unregister_m2m_device(gsc);
+	v4l2_device_unregister(&gsc->v4l2_dev);
 
 	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
 	pm_runtime_disable(&pdev->dev);
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -343,6 +343,7 @@ struct gsc_dev {
 	unsigned long			state;
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		vdev;
+	struct v4l2_device		v4l2_dev;
 };
 
 /**
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -751,6 +751,7 @@ int gsc_register_m2m_device(struct gsc_d
 	gsc->vdev.release	= video_device_release_empty;
 	gsc->vdev.lock		= &gsc->lock;
 	gsc->vdev.vfl_dir	= VFL_DIR_M2M;
+	gsc->vdev.v4l2_dev	= &gsc->v4l2_dev;
 	snprintf(gsc->vdev.name, sizeof(gsc->vdev.name), "%s.%d:m2m",
 					GSC_MODULE_NAME, gsc->id);
 


