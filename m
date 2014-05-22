Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaEVRvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:51:15 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46808 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaEVRvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:51:12 -0400
From: Emil Goode <emilgoode@gmail.com>
To: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] ARM: imx: introduce function imx_free_mx3_camera
Date: Thu, 22 May 2014 19:51:19 +0200
Message-Id: <1400781080-6117-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We forgot to free pdev->dev.dma_mask on error after
having called the imx_alloc_mx3_camera function.
This patch introduces the imx_free_mx3_camera function
that adds the missing kfree call and is practical for
future usage with imx_alloc_mx3_camera().

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 arch/arm/mach-imx/devices-imx31.h             |    2 ++
 arch/arm/mach-imx/devices-imx35.h             |    2 ++
 arch/arm/mach-imx/devices/devices-common.h    |    1 +
 arch/arm/mach-imx/devices/platform-ipu-core.c |   11 +++++++++--
 arch/arm/mach-imx/mach-mx31_3ds.c             |    2 +-
 arch/arm/mach-imx/mach-mx31moboard.c          |    3 +--
 arch/arm/mach-imx/mach-mx35_3ds.c             |    2 +-
 arch/arm/mach-imx/mach-pcm037.c               |    2 +-
 8 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-imx/devices-imx31.h b/arch/arm/mach-imx/devices-imx31.h
index e8d1611..900d3b0 100644
--- a/arch/arm/mach-imx/devices-imx31.h
+++ b/arch/arm/mach-imx/devices-imx31.h
@@ -45,6 +45,8 @@ extern const struct imx_ipu_core_data imx31_ipu_core_data;
 	imx_add_ipu_core(&imx31_ipu_core_data)
 #define imx31_alloc_mx3_camera(pdata)	\
 	imx_alloc_mx3_camera(&imx31_ipu_core_data, pdata)
+#define imx31_free_mx3_camera(pdev)	\
+	imx_free_mx3_camera(pdev)
 #define imx31_add_mx3_sdc_fb(pdata)	\
 	imx_add_mx3_sdc_fb(&imx31_ipu_core_data, pdata)
 
diff --git a/arch/arm/mach-imx/devices-imx35.h b/arch/arm/mach-imx/devices-imx35.h
index 780d824..02d22e8 100644
--- a/arch/arm/mach-imx/devices-imx35.h
+++ b/arch/arm/mach-imx/devices-imx35.h
@@ -53,6 +53,8 @@ extern const struct imx_ipu_core_data imx35_ipu_core_data;
 	imx_add_ipu_core(&imx35_ipu_core_data)
 #define imx35_alloc_mx3_camera(pdata)	\
 	imx_alloc_mx3_camera(&imx35_ipu_core_data, pdata)
+#define imx35_free_mx3_camera(pdev)	\
+	imx_free_mx3_camera(pdev)
 #define imx35_add_mx3_sdc_fb(pdata)	\
 	imx_add_mx3_sdc_fb(&imx35_ipu_core_data, pdata)
 
diff --git a/arch/arm/mach-imx/devices/devices-common.h b/arch/arm/mach-imx/devices/devices-common.h
index 69bafc8..0b3ca11 100644
--- a/arch/arm/mach-imx/devices/devices-common.h
+++ b/arch/arm/mach-imx/devices/devices-common.h
@@ -185,6 +185,7 @@ struct imx_ipu_core_data {
 };
 struct platform_device *__init imx_add_ipu_core(
 		const struct imx_ipu_core_data *data);
+void imx_free_mx3_camera(struct platform_device *pdev);
 struct platform_device *__init imx_alloc_mx3_camera(
 		const struct imx_ipu_core_data *data,
 		const struct mx3_camera_pdata *pdata);
diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
index fc4dd7c..77424c4 100644
--- a/arch/arm/mach-imx/devices/platform-ipu-core.c
+++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
@@ -58,6 +58,14 @@ struct platform_device *__init imx_add_ipu_core(
 			res, ARRAY_SIZE(res), NULL, 0);
 }
 
+void imx_free_mx3_camera(struct platform_device *pdev)
+{
+	if (pdev)
+		kfree(pdev->dev.dma_mask);
+
+	platform_device_put(pdev);
+}
+
 struct platform_device *__init imx_alloc_mx3_camera(
 		const struct imx_ipu_core_data *data,
 		const struct mx3_camera_pdata *pdata)
@@ -96,8 +104,7 @@ struct platform_device *__init imx_alloc_mx3_camera(
 		ret = platform_device_add_data(pdev, pdata, sizeof(*pdata));
 		if (ret) {
 err:
-			kfree(pdev->dev.dma_mask);
-			platform_device_put(pdev);
+			imx_free_mx3_camera(pdev);
 			return ERR_PTR(-ENODEV);
 		}
 		copied_pdata = dev_get_platdata(&pdev->dev);
diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
index 453f41a..f8e6158 100644
--- a/arch/arm/mach-imx/mach-mx31_3ds.c
+++ b/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -203,7 +203,7 @@ static int __init mx31_3ds_init_camera(void)
 	ret = platform_device_add(pdev);
 	if (ret)
 err:
-		platform_device_put(pdev);
+		imx31_free_mx3_camera(pdev);
 
 	return ret;
 }
diff --git a/arch/arm/mach-imx/mach-mx31moboard.c b/arch/arm/mach-imx/mach-mx31moboard.c
index 6bed570..25228e3 100644
--- a/arch/arm/mach-imx/mach-mx31moboard.c
+++ b/arch/arm/mach-imx/mach-mx31moboard.c
@@ -496,10 +496,9 @@ static int __init mx31moboard_init_cam(void)
 	ret = platform_device_add(pdev);
 	if (ret)
 err:
-		platform_device_put(pdev);
+		imx31_free_mx3_camera(pdev);
 
 	return ret;
-
 }
 
 static void mx31moboard_poweroff(void)
diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index 72cd77d..77b230e 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -286,7 +286,7 @@ static int __init imx35_3ds_init_camera(void)
 	ret = platform_device_add(pdev);
 	if (ret)
 err:
-		platform_device_put(pdev);
+		imx35_free_mx3_camera(pdev);
 
 	return ret;
 }
diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index 8eb1570..a7ba7b9 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -429,7 +429,7 @@ static int __init pcm037_init_camera(void)
 	ret = platform_device_add(pdev);
 	if (ret)
 err:
-		platform_device_put(pdev);
+		imx31_free_mx3_camera(pdev);
 
 	return ret;
 }
-- 
1.7.10.4

