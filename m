Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3G1AIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 20:08:21 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:63241 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3G1AIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 20:08:20 -0400
MIME-Version: 1.0
Date: Sun, 28 Jul 2013 08:08:18 +0800
Message-ID: <CAPgLHd8v7oSuXuRwiMRJZQhW1UNHXwD-UtxFNMVW8LcP465xKA@mail.gmail.com>
Subject: [PATCH] drm/cirrus: fix error handling in cirrus_device_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie, daniel.vetter@ffwll.ch, airlied@gmail.com,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, davej@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix the error handling in function cirrus_device_init() to avoid resources
leak in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/cirrus/cirrus_main.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_main.c b/drivers/gpu/drm/cirrus/cirrus_main.c
index 3a7a0ef..5f59bb0 100644
--- a/drivers/gpu/drm/cirrus/cirrus_main.c
+++ b/drivers/gpu/drm/cirrus/cirrus_main.c
@@ -138,17 +138,22 @@ int cirrus_device_init(struct cirrus_device *cdev,
 	}
 
 	cdev->rmmio = ioremap(cdev->rmmio_base, cdev->rmmio_size);
-
-	if (cdev->rmmio == NULL)
-		return -ENOMEM;
+	if (cdev->rmmio == NULL) {
+		ret = -ENOMEM;
+		goto err_ioremap;
+	}
 
 	ret = cirrus_vram_init(cdev);
-	if (ret) {
-		release_mem_region(cdev->rmmio_base, cdev->rmmio_size);
-		return ret;
-	}
+	if (ret)
+		goto err_init;
 
 	return 0;
+
+err_init:
+	iounmap(cdev->rmmio);
+err_ioremap:
+	release_mem_region(cdev->rmmio_base, cdev->rmmio_size);
+	return ret;
 }
 
 void cirrus_device_fini(struct cirrus_device *cdev)

