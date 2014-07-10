Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaGJVwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:52:08 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49401 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbaGJVwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:52:05 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 19/83] hsa/radeon: Enable/Disable KFD interrupt module
Date: Fri, 11 Jul 2014 00:50:19 +0300
Message-Id: <1405029027-6085-18-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add calls to initialize and finalize the KFD interrupt
module.

The calls are done per device initialize/finalize inside the kgd-->kfd
interface.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/cik_regs.h   |  1 +
 drivers/gpu/hsa/radeon/kfd_device.c | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/cik_regs.h b/drivers/gpu/hsa/radeon/cik_regs.h
index 9c3ce97..813cdc4 100644
--- a/drivers/gpu/hsa/radeon/cik_regs.h
+++ b/drivers/gpu/hsa/radeon/cik_regs.h
@@ -73,6 +73,7 @@
 #define CP_PQ_WPTR_POLL_CNTL				0xC20C
 #define	WPTR_POLL_EN					(1 << 31)
 
+#define CPC_INT_CNTL					0xC2D0
 #define CP_ME1_PIPE0_INT_CNTL				0xC214
 #define CP_ME1_PIPE1_INT_CNTL				0xC218
 #define CP_ME1_PIPE2_INT_CNTL				0xC21C
diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
index b2d2861..b627e57 100644
--- a/drivers/gpu/hsa/radeon/kfd_device.c
+++ b/drivers/gpu/hsa/radeon/kfd_device.c
@@ -127,6 +127,9 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 
 	radeon_kfd_doorbell_init(kfd);
 
+	if (radeon_kfd_interrupt_init(kfd))
+		return false;
+
 	if (!device_iommu_pasid_init(kfd))
 		return false;
 
@@ -155,10 +158,13 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd)
 
 	BUG_ON(err != 0);
 
-	if (kfd->init_complete) {
+	if (kfd->init_complete)
 		kfd->device_info->scheduler_class->stop(kfd->scheduler);
-		kfd->device_info->scheduler_class->destroy(kfd->scheduler);
 
+	radeon_kfd_interrupt_exit(kfd);
+
+	if (kfd->init_complete) {
+		kfd->device_info->scheduler_class->destroy(kfd->scheduler);
 		amd_iommu_free_device(kfd->pdev);
 	}
 
-- 
1.9.1

