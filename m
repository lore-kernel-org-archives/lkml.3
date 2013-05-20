Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3ETRc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:32:28 -0400
Received: from smtp-out-242.synserver.de ([212.40.185.242]:1027 "EHLO
	smtp-out-240.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750887Ab3ETRc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:32:27 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25794
From: Lars-Peter Clausen <lars@metafoo.de>
To: Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] drm/exynos: exynos_hdmi: Pass correct pointer to free_irq()
Date: Mon, 20 May 2013 19:32:06 +0200
Message-Id: <1369071126-7020-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_irq() expects the same pointer that was passed to request_threaded_irq(),
otherwise the IRQ is not freed.

The issue was found using the following coccinelle script:

<smpl>
@r1@
type T;
T devid;
@@
request_threaded_irq(..., devid)

@r2@
type r1.T;
T devid;
position p;
@@
free_irq@p(..., devid)

@@
position p != r2.p;
@@
*free_irq@p(...)
</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index bbfc384..7e99853 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -2082,7 +2082,7 @@ static int hdmi_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(dev);
 
-	free_irq(hdata->irq, hdata);
+	free_irq(hdata->irq, ctx);
 
 
 	/* hdmiphy i2c driver */
-- 
1.8.0

