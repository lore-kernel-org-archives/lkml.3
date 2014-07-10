Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaGJVwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:52:24 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55629 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaGJVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:52:21 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 24/83] drm/radeon/cik: Call kfd isr function
Date: Fri, 11 Jul 2014 00:50:24 +0300
Message-Id: <1405029027-6085-23-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When radeon handles interrupts for cik, propogate this interrupt to kfd.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/cik.c        | 4 ++++
 drivers/gpu/drm/radeon/radeon_kfd.c | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 803d0cb..6f4999a 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -140,6 +140,7 @@ static void cik_enable_gui_idle_interrupt(struct radeon_device *rdev,
 					  bool enable);
 extern void radeon_kfd_suspend(struct radeon_device *rdev);
 extern int radeon_kfd_resume(struct radeon_device *rdev);
+extern void radeon_kfd_interrupt(struct radeon_device *rdev, const void *ih_ring_entry);
 
 /* get temperature in millidegrees */
 int ci_get_temp(struct radeon_device *rdev)
@@ -7703,6 +7704,9 @@ restart_ih:
 	while (rptr != wptr) {
 		/* wptr/rptr are in bytes! */
 		ring_index = rptr / 4;
+
+		radeon_kfd_interrupt(rdev, (const void *) &rdev->ih.ring[ring_index]);
+
 		src_id =  le32_to_cpu(rdev->ih.ring[ring_index]) & 0xff;
 		src_data = le32_to_cpu(rdev->ih.ring[ring_index + 1]) & 0xfffffff;
 		ring_id = le32_to_cpu(rdev->ih.ring[ring_index + 2]) & 0xff;
diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index e3af85b..f4cc3c5 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -124,6 +124,12 @@ void radeon_kfd_device_fini(struct radeon_device *rdev)
 	}
 }
 
+void radeon_kfd_interrupt(struct radeon_device *rdev, const void *ih_ring_entry)
+{
+	if (rdev->kfd)
+		kgd2kfd->interrupt(rdev->kfd, ih_ring_entry);
+}
+
 void radeon_kfd_suspend(struct radeon_device *rdev)
 {
 	if (rdev->kfd)
-- 
1.9.1

