Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbaIOWNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:13:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50729 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaIOWNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 065/187] drm/tilcdc: panel: fix leak when unloading the module
Date: Mon, 15 Sep 2014 15:07:55 -0700
Message-Id: <1410818997-9432-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>

commit 3a49012224ca9016658a831a327ff6a7fe5bb4f9 upstream.

The driver did not unregister the allocated framebuffer, which caused
memory leaks (and memory manager WARNs) when unloading. Also, the
framebuffer device under /dev still existed after unloading.

Add a call to drm_fbdev_cma_fini when unloading the module to prevent
both issues.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
Tested-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 116da19..247ab5d 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -122,6 +122,7 @@ static int tilcdc_unload(struct drm_device *dev)
 	struct tilcdc_drm_private *priv = dev->dev_private;
 	struct tilcdc_module *mod, *cur;
 
+	drm_fbdev_cma_fini(priv->fbdev);
 	drm_kms_helper_poll_fini(dev);
 	drm_mode_config_cleanup(dev);
 	drm_vblank_cleanup(dev);
-- 
1.9.1

