Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761855Ab3DBNln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:41:43 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42055 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761691Ab3DBNlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:41:42 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH v3] davinci: vpif: add pm_runtime support
Date: Tue,  2 Apr 2013 19:11:30 +0530
Message-Id: <1364910090-5501-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Add pm_runtime support to the TI Davinci VPIF driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sekhar Nori <nsekhar@ti.com>
---
 Changes for v3:
 1: Removed pm_runtime_resume() from probe as pm_runtime_get()
    calls it as pointed by Hans.

 Changes for v2:
 1: Removed use of clk API as pointed by Laurent and Sekhar.

 drivers/media/platform/davinci/vpif.c |   24 ++++++------------------
 1 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 3bc4db8..ea82a8b 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -23,8 +23,8 @@
 #include <linux/spinlock.h>
 #include <linux/kernel.h>
 #include <linux/io.h>
-#include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/pm_runtime.h>
 #include <linux/v4l2-dv-timings.h>
 
 #include <mach/hardware.h>
@@ -46,8 +46,6 @@ spinlock_t vpif_lock;
 void __iomem *vpif_base;
 EXPORT_SYMBOL_GPL(vpif_base);
 
-struct clk *vpif_clk;
-
 /**
  * vpif_ch_params: video standard configuration parameters for vpif
  * The table must include all presets from supported subdevices.
@@ -443,19 +441,13 @@ static int vpif_probe(struct platform_device *pdev)
 		goto fail;
 	}
 
-	vpif_clk = clk_get(&pdev->dev, "vpif");
-	if (IS_ERR(vpif_clk)) {
-		status = PTR_ERR(vpif_clk);
-		goto clk_fail;
-	}
-	clk_prepare_enable(vpif_clk);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get(&pdev->dev);
 
 	spin_lock_init(&vpif_lock);
 	dev_info(&pdev->dev, "vpif probe success\n");
 	return 0;
 
-clk_fail:
-	iounmap(vpif_base);
 fail:
 	release_mem_region(res->start, res_len);
 	return status;
@@ -463,11 +455,7 @@ fail:
 
 static int vpif_remove(struct platform_device *pdev)
 {
-	if (vpif_clk) {
-		clk_disable_unprepare(vpif_clk);
-		clk_put(vpif_clk);
-	}
-
+	pm_runtime_disable(&pdev->dev);
 	iounmap(vpif_base);
 	release_mem_region(res->start, res_len);
 	return 0;
@@ -476,13 +464,13 @@ static int vpif_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int vpif_suspend(struct device *dev)
 {
-	clk_disable_unprepare(vpif_clk);
+	pm_runtime_put(dev);
 	return 0;
 }
 
 static int vpif_resume(struct device *dev)
 {
-	clk_prepare_enable(vpif_clk);
+	pm_runtime_get(dev);
 	return 0;
 }
 
-- 
1.7.4.1

