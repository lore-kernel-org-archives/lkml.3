Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaGJVwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:52:18 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:37956 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaGJVwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:52:15 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 22/83] drm/radeon: Add calls to suspend and resume of kfd driver
Date: Fri, 11 Jul 2014 00:50:22 +0300
Message-Id: <1405029027-6085-21-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The radeon driver can suspend and resume its device. For each device it
suspends/resumes, it should inform the kfd about it, so the kfd could
perform relevant actions per that device.

This patch adds the calls to kfd's suspend and resume functions. The
device is passed as an argument.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/cik.c        |  7 +++++++
 drivers/gpu/drm/radeon/radeon_kfd.c | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index e0c8052..b1c50f4 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -138,6 +138,8 @@ static void cik_fini_pg(struct radeon_device *rdev);
 static void cik_fini_cg(struct radeon_device *rdev);
 static void cik_enable_gui_idle_interrupt(struct radeon_device *rdev,
 					  bool enable);
+extern void radeon_kfd_suspend(struct radeon_device *rdev);
+extern int radeon_kfd_resume(struct radeon_device *rdev);
 
 /* get temperature in millidegrees */
 int ci_get_temp(struct radeon_device *rdev)
@@ -8429,6 +8431,10 @@ static int cik_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
+	r = radeon_kfd_resume(rdev);
+	if (r)
+		return r;
+
 	return 0;
 }
 
@@ -8477,6 +8483,7 @@ int cik_resume(struct radeon_device *rdev)
  */
 int cik_suspend(struct radeon_device *rdev)
 {
+	radeon_kfd_suspend(rdev);
 	radeon_pm_suspend(rdev);
 	dce6_audio_fini(rdev);
 	radeon_vm_manager_fini(rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index 594020e..e3af85b 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -124,6 +124,22 @@ void radeon_kfd_device_fini(struct radeon_device *rdev)
 	}
 }
 
+void radeon_kfd_suspend(struct radeon_device *rdev)
+{
+	if (rdev->kfd)
+		kgd2kfd->suspend(rdev->kfd);
+}
+
+int radeon_kfd_resume(struct radeon_device *rdev)
+{
+	int r = 0;
+
+	if (rdev->kfd)
+		r = kgd2kfd->resume(rdev->kfd);
+
+	return r;
+}
+
 static u32 pool_to_domain(enum kgd_memory_pool p)
 {
 	switch (p) {
-- 
1.9.1

