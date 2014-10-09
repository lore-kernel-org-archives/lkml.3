Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693AbaJIVKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:10:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59458 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672AbaJIVKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 108/163] drm/radeon/px: fix module unload
Date: Thu,  9 Oct 2014 14:02:13 -0700
Message-Id: <1412888588-26755-109-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2e97140dd58cab8772bf77d73eabda213e45202d upstream.

Use the new vga_switcheroo_fini_domain_pm_ops function
to unregister the pm ops.

Based on a patch from:
Pali Rohár <pali.rohar@gmail.com>

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=84431

Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_device.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 716293c..974f710 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1309,7 +1309,7 @@ int radeon_device_init(struct radeon_device *rdev,
 
 	r = radeon_init(rdev);
 	if (r)
-		return r;
+		goto failed;
 
 	r = radeon_ib_ring_tests(rdev);
 	if (r)
@@ -1329,7 +1329,7 @@ int radeon_device_init(struct radeon_device *rdev,
 		radeon_agp_disable(rdev);
 		r = radeon_init(rdev);
 		if (r)
-			return r;
+			goto failed;
 	}
 	if ((radeon_testing & 1)) {
 		if (rdev->accel_working)
@@ -1350,6 +1350,11 @@ int radeon_device_init(struct radeon_device *rdev,
 			DRM_INFO("radeon: acceleration disabled, skipping benchmarks\n");
 	}
 	return 0;
+
+failed:
+	if (runtime)
+		vga_switcheroo_fini_domain_pm_ops(rdev->dev);
+	return r;
 }
 
 static void radeon_debugfs_remove_files(struct radeon_device *rdev);
@@ -1370,6 +1375,8 @@ void radeon_device_fini(struct radeon_device *rdev)
 	radeon_bo_evict_vram(rdev);
 	radeon_fini(rdev);
 	vga_switcheroo_unregister_client(rdev->pdev);
+	if (rdev->flags & RADEON_IS_PX)
+		vga_switcheroo_fini_domain_pm_ops(rdev->dev);
 	vga_client_register(rdev->pdev, NULL, NULL, NULL);
 	if (rdev->rio_mem)
 		pci_iounmap(rdev->pdev, rdev->rio_mem);
-- 
1.9.1

