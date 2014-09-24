Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaIXVD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:03:29 -0400
Received: from mail-bn1on0139.outbound.protection.outlook.com ([157.56.110.139]:64268
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751301AbaIXVD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:03:27 -0400
X-WSS-ID: 0NCFB5S-07-T95-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 11/23] amdkfd: Add binding/unbinding calls to amd_iommu driver
Date: Wed, 24 Sep 2014 23:45:25 +0300
Message-ID: <1411591537-31636-12-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(95666004)(47776003)(229853001)(77096002)(92566001)(105586002)(92726001)(76482002)(106466001)(97736003)(120916001)(99396003)(107046002)(31966008)(36756003)(83072002)(64706001)(20776003)(104166001)(4396001)(77156001)(101416001)(19580395003)(81542003)(68736004)(48376002)(83322001)(90102001)(74502003)(77982003)(93916002)(89996001)(44976005)(33646002)(80022003)(50226001)(46102003)(102836001)(62966002)(85306004)(87936001)(21056001)(50466002)(79102003)(84676001)(76176999)(19580405001)(74662003)(88136002)(81342003)(85852003)(50986999)(86362001)(10300001)(87286001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB076;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the functions to bind and unbind pasid
from a device through the amd_iommu driver.

The unbind function is called when the mm_struct of the
process is released.

The bind function is not called here because it is called
only in the IOCTLs which are not yet implemented at this
stage of the patchset.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/kfd_device.c  | 86 ++++++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h    |  1 +
 drivers/gpu/drm/radeon/amdkfd/kfd_process.c | 12 ++++
 3 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
index 8e2b075..ce90592 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
@@ -98,6 +98,63 @@ struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev)
 	return kfd;
 }
 
+static bool device_iommu_pasid_init(struct kfd_dev *kfd)
+{
+	const u32 required_iommu_flags = AMD_IOMMU_DEVICE_FLAG_ATS_SUP | AMD_IOMMU_DEVICE_FLAG_PRI_SUP
+					| AMD_IOMMU_DEVICE_FLAG_PASID_SUP;
+
+	struct amd_iommu_device_info iommu_info;
+	unsigned int pasid_limit;
+	int err;
+
+	err = amd_iommu_device_info(kfd->pdev, &iommu_info);
+	if (err < 0) {
+		dev_err(kfd_device, "error getting iommu info. is the iommu enabled?\n");
+		return false;
+	}
+
+	if ((iommu_info.flags & required_iommu_flags) != required_iommu_flags) {
+		dev_err(kfd_device, "error required iommu flags ats(%i), pri(%i), pasid(%i)\n",
+		       (iommu_info.flags & AMD_IOMMU_DEVICE_FLAG_ATS_SUP) != 0,
+		       (iommu_info.flags & AMD_IOMMU_DEVICE_FLAG_PRI_SUP) != 0,
+		       (iommu_info.flags & AMD_IOMMU_DEVICE_FLAG_PASID_SUP) != 0);
+		return false;
+	}
+
+	pasid_limit = min_t(unsigned int,
+			(unsigned int)1 << kfd->device_info->max_pasid_bits,
+			iommu_info.max_pasids);
+	/*
+	 * last pasid is used for kernel queues doorbells
+	 * in the future the last pasid might be used for a kernel thread.
+	 */
+	pasid_limit = min_t(unsigned int,
+				pasid_limit,
+				kfd->doorbell_process_limit - 1);
+
+	err = amd_iommu_init_device(kfd->pdev, pasid_limit);
+	if (err < 0) {
+		dev_err(kfd_device, "error initializing iommu device\n");
+		return false;
+	}
+
+	if (!kfd_set_pasid_limit(pasid_limit)) {
+		dev_err(kfd_device, "error setting pasid limit\n");
+		amd_iommu_free_device(kfd->pdev);
+		return false;
+	}
+
+	return true;
+}
+
+static void iommu_pasid_shutdown_callback(struct pci_dev *pdev, int pasid)
+{
+	struct kfd_dev *dev = kfd_device_by_pci_dev(pdev);
+
+	if (dev)
+		kfd_unbind_process_from_device(dev, pasid);
+}
+
 bool kgd2kfd_device_init(struct kfd_dev *kfd,
 			 const struct kgd2kfd_shared_resources *gpu_resources)
 {
@@ -129,6 +186,13 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 		goto kfd_topology_add_device_error;
 	}
 
+	if (!device_iommu_pasid_init(kfd)) {
+		dev_err(kfd_device,
+			"Error initializing iommuv2 for device (%x:%x)\n",
+			kfd->pdev->vendor, kfd->pdev->device);
+		goto device_iommu_pasid_error;
+	}
+	amd_iommu_set_invalidate_ctx_cb(kfd->pdev, iommu_pasid_shutdown_callback);
 
 	kfd->init_complete = true;
 	dev_info(kfd_device, "added device (%x:%x)\n", kfd->pdev->vendor,
@@ -136,6 +200,8 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 
 	goto out;
 
+device_iommu_pasid_error:
+	kfd_topology_remove_device(kfd);
 kfd_topology_add_device_error:
 	kfd2kgd->fini_sa_manager(kfd->kgd);
 	dev_err(kfd_device,
@@ -147,7 +213,10 @@ out:
 
 void kgd2kfd_device_exit(struct kfd_dev *kfd)
 {
-	kfd_topology_remove_device(kfd);
+	if (kfd->init_complete) {
+		amd_iommu_free_device(kfd->pdev);
+		kfd_topology_remove_device(kfd);
+	}
 
 	kfree(kfd);
 }
@@ -155,12 +224,27 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd)
 void kgd2kfd_suspend(struct kfd_dev *kfd)
 {
 	BUG_ON(kfd == NULL);
+
+	if (kfd->init_complete)
+		amd_iommu_free_device(kfd->pdev);
 }
 
 int kgd2kfd_resume(struct kfd_dev *kfd)
 {
+	unsigned int pasid_limit;
+	int err;
+
 	BUG_ON(kfd == NULL);
 
+	pasid_limit = kfd_get_pasid_limit();
+
+	if (kfd->init_complete) {
+		err = amd_iommu_init_device(kfd->pdev, pasid_limit);
+		if (err < 0)
+			return -ENXIO;
+		amd_iommu_set_invalidate_ctx_cb(kfd->pdev, iommu_pasid_shutdown_callback);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 43f4bd4..b55b1cb 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -188,6 +188,7 @@ struct kfd_process {
 struct kfd_process *kfd_create_process(const struct task_struct *);
 struct kfd_process *kfd_get_process(const struct task_struct *);
 
+void kfd_unbind_process_from_device(struct kfd_dev *dev, unsigned int pasid);
 struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
 							struct kfd_process *p,
 							int create_pdd);
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_process.c b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
index c95fd93..66a91b9 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
@@ -24,6 +24,7 @@
 #include <linux/log2.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/amd-iommu.h>
 #include <linux/notifier.h>
 struct mm_struct;
 
@@ -153,6 +154,7 @@ static void kfd_process_notifier_release(struct mmu_notifier *mn,
 	mutex_lock(&p->mutex);
 
 	list_for_each_entry_safe(pdd, temp, &p->per_device_data, per_device_list) {
+		amd_iommu_unbind_pasid(pdd->dev->pdev, p->pasid);
 		list_del(&pdd->per_device_list);
 		kfree(pdd);
 	}
@@ -258,6 +260,7 @@ struct kfd_process_device *kfd_bind_process_to_device(struct kfd_dev *dev,
 							struct kfd_process *p)
 {
 	struct kfd_process_device *pdd = kfd_get_process_device_data(dev, p, 1);
+	int err;
 
 	if (pdd == NULL)
 		return ERR_PTR(-ENOMEM);
@@ -265,6 +268,15 @@ struct kfd_process_device *kfd_bind_process_to_device(struct kfd_dev *dev,
 	if (pdd->bound)
 		return pdd;
 
+	err = amd_iommu_bind_pasid(dev->pdev, p->pasid, p->lead_thread);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	if (err < 0) {
+		amd_iommu_unbind_pasid(dev->pdev, p->pasid);
+		return ERR_PTR(err);
+	}
+
 	pdd->bound = true;
 
 	return pdd;
-- 
1.9.1

