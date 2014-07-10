Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaGJVw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:52:59 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:50222 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaGJVw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:52:28 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 26/83] hsa/radeon: Make binding of process to device permanent
Date: Fri, 11 Jul 2014 00:50:26 +0300
Message-Id: <1405029027-6085-25-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lewycky <Andrew.Lewycky@amd.com>

Permanently bind the process to the device.
The binding survives even when all queues are destroyed.
Process exit and device removal terminate the binding.

Signed-off-by: Andrew Lewycky <Andrew.Lewycky@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_chardev.c | 27 +++------------------------
 drivers/gpu/hsa/radeon/kfd_priv.h    |  3 ---
 drivers/gpu/hsa/radeon/kfd_process.c | 21 ++++++++++-----------
 3 files changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index 4e7d5d0..e0b276d 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -141,20 +141,13 @@ kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *a
 	pdd = radeon_kfd_bind_process_to_device(dev, p);
 	if (IS_ERR(pdd) < 0) {
 		err = PTR_ERR(pdd);
-		goto err_bind_pasid;
+		goto err_bind_process;
 	}
 
-	pr_debug("kfd: creating queue number %d for PASID %d on GPU 0x%x\n",
-			pdd->queue_count,
+	pr_debug("kfd: creating queue for PASID %d on GPU 0x%x\n",
 			p->pasid,
 			dev->id);
 
-	if (pdd->queue_count++ == 0) {
-		err = dev->device_info->scheduler_class->register_process(dev->scheduler, p, &pdd->scheduler_process);
-		if (err < 0)
-			goto err_register_process;
-	}
-
 	if (!radeon_kfd_allocate_queue_id(p, &queue_id))
 		goto err_allocate_queue_id;
 
@@ -198,12 +191,7 @@ err_copy_args_out:
 err_create_queue:
 	radeon_kfd_remove_queue(p, queue_id);
 err_allocate_queue_id:
-	if (--pdd->queue_count == 0) {
-		dev->device_info->scheduler_class->deregister_process(dev->scheduler, pdd->scheduler_process);
-		pdd->scheduler_process = NULL;
-	}
-err_register_process:
-err_bind_pasid:
+err_bind_process:
 	kfree(queue);
 	mutex_unlock(&p->mutex);
 	return err;
@@ -215,7 +203,6 @@ kfd_ioctl_destroy_queue(struct file *filp, struct kfd_process *p, void __user *a
 	struct kfd_ioctl_destroy_queue_args args;
 	struct kfd_queue *queue;
 	struct kfd_dev *dev;
-	struct kfd_process_device *pdd;
 
 	if (copy_from_user(&args, arg, sizeof(args)))
 		return -EFAULT;
@@ -239,14 +226,6 @@ kfd_ioctl_destroy_queue(struct file *filp, struct kfd_process *p, void __user *a
 
 	kfree(queue);
 
-	pdd = radeon_kfd_get_process_device_data(dev, p);
-	BUG_ON(pdd == NULL); /* Because a queue exists. */
-
-	if (--pdd->queue_count == 0) {
-		dev->device_info->scheduler_class->deregister_process(dev->scheduler, pdd->scheduler_process);
-		pdd->scheduler_process = NULL;
-	}
-
 	mutex_unlock(&p->mutex);
 	return 0;
 }
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index 630d690..bca9cce 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -166,9 +166,6 @@ struct kfd_process_device {
 	/* The user-mode address of the doorbell mapping for this device. */
 	doorbell_t __user *doorbell_mapping;
 
-	/* The number of queues created by this process for this device. */
-	uint32_t queue_count;
-
 	/* Scheduler process data for this device. */
 	struct kfd_scheduler_process *scheduler_process;
 
diff --git a/drivers/gpu/hsa/radeon/kfd_process.c b/drivers/gpu/hsa/radeon/kfd_process.c
index 145ee38..f89f855 100644
--- a/drivers/gpu/hsa/radeon/kfd_process.c
+++ b/drivers/gpu/hsa/radeon/kfd_process.c
@@ -120,15 +120,6 @@ destroy_queues(struct kfd_process *p, struct kfd_dev *dev_filter)
 			dev->device_info->scheduler_class->destroy_queue(dev->scheduler, &queue->scheduler_queue);
 
 			kfree(queue);
-
-			BUG_ON(pdd->queue_count == 0);
-			BUG_ON(pdd->scheduler_process == NULL);
-
-			if (--pdd->queue_count == 0) {
-				dev->device_info->scheduler_class->deregister_process(dev->scheduler,
-							pdd->scheduler_process);
-				pdd->scheduler_process = NULL;
-			}
 		}
 	}
 }
@@ -144,6 +135,8 @@ static void free_process(struct kfd_process *p)
 	/* doorbell mappings: automatic */
 
 	list_for_each_entry_safe(pdd, temp, &p->per_device_data, per_device_list) {
+		pdd->dev->device_info->scheduler_class->deregister_process(pdd->dev->scheduler, pdd->scheduler_process);
+		pdd->scheduler_process = NULL;
 		amd_iommu_unbind_pasid(pdd->dev->pdev, p->pasid);
 		list_del(&pdd->per_device_list);
 		kfree(pdd);
@@ -255,6 +248,12 @@ struct kfd_process_device *radeon_kfd_bind_process_to_device(struct kfd_dev *dev
 	if (err < 0)
 		return ERR_PTR(err);
 
+	err = dev->device_info->scheduler_class->register_process(dev->scheduler, p, &pdd->scheduler_process);
+	if (err < 0) {
+		amd_iommu_unbind_pasid(dev->pdev, p->pasid);
+		return ERR_PTR(err);
+	}
+
 	pdd->bound = true;
 
 	return pdd;
@@ -285,8 +284,8 @@ void radeon_kfd_unbind_process_from_device(struct kfd_dev *dev, pasid_t pasid)
 
 	destroy_queues(p, dev);
 
-	/* All queues just got destroyed so this should be gone. */
-	BUG_ON(pdd->scheduler_process != NULL);
+	dev->device_info->scheduler_class->deregister_process(dev->scheduler, pdd->scheduler_process);
+	pdd->scheduler_process = NULL;
 
 	/*
 	 * Just mark pdd as unbound, because we still need it to call
-- 
1.9.1

