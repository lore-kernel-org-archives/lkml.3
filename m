Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaGJVzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:55:51 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55527 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbaGJVzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:46 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Michael Varga <Michael.Varga@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 45/83] hsa/radeon: debugging print statements
Date: Fri, 11 Jul 2014 00:54:01 +0300
Message-Id: <1405029279-6894-17-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Varga <Michael.Varga@amd.com>

Added debug print statements so critical errors during init may be debugged more easily.

Signed-off-by: Michael Varga <Michael.Varga@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_device.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
index 2e7d50d..82febf4 100644
--- a/drivers/gpu/hsa/radeon/kfd_device.c
+++ b/drivers/gpu/hsa/radeon/kfd_device.c
@@ -107,20 +107,30 @@ device_iommu_pasid_init(struct kfd_dev *kfd)
 	int err;
 
 	err = amd_iommu_device_info(kfd->pdev, &iommu_info);
-	if (err < 0)
+	if (err < 0) {
+		dev_err(kfd_device, "error getting iommu info. is the iommu enabled?\n");
 		return false;
+	}
 
-	if ((iommu_info.flags & required_iommu_flags) != required_iommu_flags)
+	if ((iommu_info.flags & required_iommu_flags) != required_iommu_flags) {
+		dev_err(kfd_device, "error required iommu flags ats(%i), pri(%i), pasid(%i)\n",
+		       (iommu_info.flags & AMD_IOMMU_DEVICE_FLAG_ATS_SUP) != 0,
+		       (iommu_info.flags & AMD_IOMMU_DEVICE_FLAG_PRI_SUP) != 0,
+		       (iommu_info.flags & AMD_IOMMU_DEVICE_FLAG_PASID_SUP) != 0);
 		return false;
+	}
 
 	pasid_limit = min_t(pasid_t, (pasid_t)1 << kfd->device_info->max_pasid_bits, iommu_info.max_pasids);
 	pasid_limit = min_t(pasid_t, pasid_limit, kfd->doorbell_process_limit);
 
 	err = amd_iommu_init_device(kfd->pdev, pasid_limit);
-	if (err < 0)
+	if (err < 0) {
+		dev_err(kfd_device, "error initializing iommu device\n");
 		return false;
+	}
 
 	if (!radeon_kfd_set_pasid_limit(pasid_limit)) {
+		dev_err(kfd_device, "error setting pasid limit\n");
 		amd_iommu_free_device(kfd->pdev);
 		return false;
 	}
@@ -166,6 +176,8 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 	kfd->device_info->scheduler_class->start(kfd->scheduler);
 
 	kfd->init_complete = true;
+	dev_info(kfd_device, "added device (%x:%x)\n", kfd->pdev->vendor,
+		 kfd->pdev->device);
 
 	return true;
 }
-- 
1.9.1

