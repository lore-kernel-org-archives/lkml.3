Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaIZJuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:50:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbaIZJqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 123/142] drm/tilcdc: panel: fix leak when unloading the module
Date: Fri, 26 Sep 2014 11:45:34 +0200
Message-Id: <565c526606aad527140f036004c258feed9bae44.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guido Martínez <guido@vanguardiasur.com.ar>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3a49012224ca9016658a831a327ff6a7fe5bb4f9 upstream.

The driver did not unregister the allocated framebuffer, which caused
memory leaks (and memory manager WARNs) when unloading. Also, the
framebuffer device under /dev still existed after unloading.

Add a call to drm_fbdev_cma_fini when unloading the module to prevent
both issues.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
Tested-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 116da199b942..247ab5d60df0 100644
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
2.1.0

