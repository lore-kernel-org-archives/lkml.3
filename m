Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472Ab3ECXCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 19:02:03 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:32875 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934289Ab3ECXBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 19:01:03 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 4/7] drm: Use drm_mtrr_add_wc for the AGP aperture
Date: Fri,  3 May 2013 16:00:32 -0700
Message-Id: <d39eb3baa01479e37638b25135d7f95c3e096858.1367621039.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1367621038.git.luto@amacapital.net>
References: <cover.1367621038.git.luto@amacapital.net>
In-Reply-To: <cover.1367621038.git.luto@amacapital.net>
References: <cover.1367621038.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/gpu/drm/drm_pci.c  |  8 ++++----
 drivers/gpu/drm/drm_stub.c | 10 ++--------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index bd719e9..3628683 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -278,10 +278,10 @@ int drm_pci_agp_init(struct drm_device *dev)
 		}
 		if (drm_core_has_MTRR(dev)) {
 			if (dev->agp)
-				dev->agp->agp_mtrr =
-					mtrr_add(dev->agp->agp_info.aper_base,
-						 dev->agp->agp_info.aper_size *
-						 1024 * 1024, MTRR_TYPE_WRCOMB, 1);
+				dev->agp->agp_mtrr = drm_mtrr_add_wc(
+					dev->agp->agp_info.aper_base,
+					dev->agp->agp_info.aper_size *
+					1024 * 1024);
 		}
 	}
 	return 0;
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 7d30802..96e21bd 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -451,14 +451,8 @@ void drm_put_dev(struct drm_device *dev)
 
 	drm_lastclose(dev);
 
-	if (drm_core_has_MTRR(dev) && drm_core_has_AGP(dev) &&
-	    dev->agp && dev->agp->agp_mtrr >= 0) {
-		int retval;
-		retval = mtrr_del(dev->agp->agp_mtrr,
-				  dev->agp->agp_info.aper_base,
-				  dev->agp->agp_info.aper_size * 1024 * 1024);
-		DRM_DEBUG("mtrr_del=%d\n", retval);
-	}
+	if (drm_core_has_MTRR(dev) && drm_core_has_AGP(dev) && dev->agp)
+		drm_mtrr_del_wc(dev->agp->agp_mtrr);
 
 	if (dev->driver->unload)
 		dev->driver->unload(dev);
-- 
1.8.1.4

