Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaGJVvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:51:10 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53618 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaGJVvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:51:05 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 08/83] drm/radeon: Add calls to initialize and finalize kfd from radeon
Date: Fri, 11 Jul 2014 00:50:08 +0300
Message-Id: <1405029027-6085-7-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KFD driver should be loaded when the radeon driver is loaded and
should be finalized when the radeon driver is removed.

This patch adds a function call to initialize kfd from radeon_init
and a function call to finalize kfd from radeon_exit.

If the KFD driver is not present in the system, the initialize call
fails and the radeon driver continues normally.

This patch also adds calls to probe, initialize and finalize a kfd device
per radeon device using the kgd-->kfd interface.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon_drv.c | 6 ++++++
 drivers/gpu/drm/radeon/radeon_kms.c | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index cb14213..88a45a0 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -151,6 +151,9 @@ static inline void radeon_register_atpx_handler(void) {}
 static inline void radeon_unregister_atpx_handler(void) {}
 #endif
 
+extern bool radeon_kfd_init(void);
+extern void radeon_kfd_fini(void);
+
 int radeon_no_wb;
 int radeon_modeset = -1;
 int radeon_dynclks = -1;
@@ -630,12 +633,15 @@ static int __init radeon_init(void)
 #endif
 	}
 
+	radeon_kfd_init();
+
 	/* let modprobe override vga console setting */
 	return drm_pci_init(driver, pdriver);
 }
 
 static void __exit radeon_exit(void)
 {
+	radeon_kfd_fini();
 	drm_pci_exit(driver, pdriver);
 	radeon_unregister_atpx_handler();
 }
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 35d9318..0748284 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -34,6 +34,10 @@
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 
+extern void radeon_kfd_device_probe(struct radeon_device *rdev);
+extern void radeon_kfd_device_init(struct radeon_device *rdev);
+extern void radeon_kfd_device_fini(struct radeon_device *rdev);
+
 #if defined(CONFIG_VGA_SWITCHEROO)
 bool radeon_has_atpx(void);
 #else
@@ -63,6 +67,8 @@ int radeon_driver_unload_kms(struct drm_device *dev)
 
 	pm_runtime_get_sync(dev->dev);
 
+	radeon_kfd_device_fini(rdev);
+
 	radeon_acpi_fini(rdev);
 	
 	radeon_modeset_fini(rdev);
@@ -142,6 +148,9 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
 				"Error during ACPI methods call\n");
 	}
 
+	radeon_kfd_device_probe(rdev);
+	radeon_kfd_device_init(rdev);
+
 	if (radeon_is_px(dev)) {
 		pm_runtime_use_autosuspend(dev->dev);
 		pm_runtime_set_autosuspend_delay(dev->dev, 5000);
-- 
1.9.1

