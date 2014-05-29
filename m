Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbaE2Qgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:36:33 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:48442 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbaE2Qgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:36:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, djkurtz@chromium.org,
        seanpaul@chromium.org, inki.dae@samsung.com, irlied@linux.ie,
        jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/exynos: hdmi: remove the i2c drivers and use devtree - continued
Date: Thu, 29 May 2014 17:36:17 +0100
Message-Id: <1401381377-29973-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There appears to have been a merge error on commit:

  2b76813: drm/exynos: hdmi: remove the i2c drivers and use

The original submission can be found at:

  https://patchwork.kernel.org/patch/3559541/

It looks like the commit was only half applied.  This patch aims
to finish what was started by Daniel.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_ddc.c     | 63 --------------------------------
 drivers/gpu/drm/exynos/exynos_hdmi.h    | 23 ------------
 drivers/gpu/drm/exynos/exynos_hdmiphy.c | 65 ---------------------------------
 3 files changed, 151 deletions(-)
 delete mode 100644 drivers/gpu/drm/exynos/exynos_ddc.c
 delete mode 100644 drivers/gpu/drm/exynos/exynos_hdmi.h
 delete mode 100644 drivers/gpu/drm/exynos/exynos_hdmiphy.c

diff --git a/drivers/gpu/drm/exynos/exynos_ddc.c b/drivers/gpu/drm/exynos/exynos_ddc.c
deleted file mode 100644
index 6a8c84e..0000000
--- a/drivers/gpu/drm/exynos/exynos_ddc.c
+++ /dev/null
@@ -1,63 +0,0 @@
-/*
- * Copyright (C) 2011 Samsung Electronics Co.Ltd
- * Authors:
- *	Seung-Woo Kim <sw0312.kim@samsung.com>
- *	Inki Dae <inki.dae@samsung.com>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- *
- */
-
-#include <drm/drmP.h>
-
-#include <linux/kernel.h>
-#include <linux/i2c.h>
-#include <linux/of.h>
-
-#include "exynos_drm_drv.h"
-#include "exynos_hdmi.h"
-
-static int s5p_ddc_probe(struct i2c_client *client,
-			const struct i2c_device_id *dev_id)
-{
-	hdmi_attach_ddc_client(client);
-
-	dev_info(&client->adapter->dev,
-		"attached %s into i2c adapter successfully\n",
-		client->name);
-
-	return 0;
-}
-
-static int s5p_ddc_remove(struct i2c_client *client)
-{
-	dev_info(&client->adapter->dev,
-		"detached %s from i2c adapter successfully\n",
-		client->name);
-
-	return 0;
-}
-
-static struct of_device_id hdmiddc_match_types[] = {
-	{
-		.compatible = "samsung,exynos5-hdmiddc",
-	}, {
-		.compatible = "samsung,exynos4210-hdmiddc",
-	}, {
-		/* end node */
-	}
-};
-
-struct i2c_driver ddc_driver = {
-	.driver = {
-		.name = "exynos-hdmiddc",
-		.owner = THIS_MODULE,
-		.of_match_table = hdmiddc_match_types,
-	},
-	.probe		= s5p_ddc_probe,
-	.remove		= s5p_ddc_remove,
-	.command		= NULL,
-};
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.h b/drivers/gpu/drm/exynos/exynos_hdmi.h
deleted file mode 100644
index 0ddf395..0000000
--- a/drivers/gpu/drm/exynos/exynos_hdmi.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd.
- * Authors:
- *	Inki Dae <inki.dae@samsung.com>
- *	Seung-Woo Kim <sw0312.kim@samsung.com>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#ifndef _EXYNOS_HDMI_H_
-#define _EXYNOS_HDMI_H_
-
-void hdmi_attach_ddc_client(struct i2c_client *ddc);
-void hdmi_attach_hdmiphy_client(struct i2c_client *hdmiphy);
-
-extern struct i2c_driver hdmiphy_driver;
-extern struct i2c_driver ddc_driver;
-
-#endif
diff --git a/drivers/gpu/drm/exynos/exynos_hdmiphy.c b/drivers/gpu/drm/exynos/exynos_hdmiphy.c
deleted file mode 100644
index 59abb14..0000000
--- a/drivers/gpu/drm/exynos/exynos_hdmiphy.c
+++ /dev/null
@@ -1,65 +0,0 @@
-/*
- * Copyright (C) 2011 Samsung Electronics Co.Ltd
- * Authors:
- *	Seung-Woo Kim <sw0312.kim@samsung.com>
- *	Inki Dae <inki.dae@samsung.com>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- *
- */
-
-#include <drm/drmP.h>
-
-#include <linux/kernel.h>
-#include <linux/i2c.h>
-#include <linux/of.h>
-
-#include "exynos_drm_drv.h"
-#include "exynos_hdmi.h"
-
-
-static int hdmiphy_probe(struct i2c_client *client,
-	const struct i2c_device_id *id)
-{
-	hdmi_attach_hdmiphy_client(client);
-
-	dev_info(&client->adapter->dev, "attached s5p_hdmiphy "
-		"into i2c adapter successfully\n");
-
-	return 0;
-}
-
-static int hdmiphy_remove(struct i2c_client *client)
-{
-	dev_info(&client->adapter->dev, "detached s5p_hdmiphy "
-		"from i2c adapter successfully\n");
-
-	return 0;
-}
-
-static struct of_device_id hdmiphy_match_types[] = {
-	{
-		.compatible = "samsung,exynos5-hdmiphy",
-	}, {
-		.compatible = "samsung,exynos4210-hdmiphy",
-	}, {
-		.compatible = "samsung,exynos4212-hdmiphy",
-	}, {
-		/* end node */
-	}
-};
-
-struct i2c_driver hdmiphy_driver = {
-	.driver = {
-		.name	= "exynos-hdmiphy",
-		.owner	= THIS_MODULE,
-		.of_match_table = hdmiphy_match_types,
-	},
-	.probe		= hdmiphy_probe,
-	.remove		= hdmiphy_remove,
-	.command		= NULL,
-};
-EXPORT_SYMBOL(hdmiphy_driver);
-- 
1.8.3.2

