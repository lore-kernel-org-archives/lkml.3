Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbaGJWAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:00:37 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57695 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaGJV5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:19 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 72/83] hsa/radeon: Static analysis (smatch) fixes
Date: Fri, 11 Jul 2014 00:54:28 +0300
Message-Id: <1405029279-6894-44-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_device.c               |  3 +++
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.c |  2 +-
 drivers/gpu/hsa/radeon/kfd_mqd_manager.c          |  1 +
 drivers/gpu/hsa/radeon/kfd_packet_manager.c       |  3 ++-
 drivers/gpu/hsa/radeon/kfd_process.c              | 10 ++++++----
 5 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
index 9af812b..30558c9 100644
--- a/drivers/gpu/hsa/radeon/kfd_device.c
+++ b/drivers/gpu/hsa/radeon/kfd_device.c
@@ -88,6 +88,9 @@ struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev)
 		return NULL;
 
 	kfd = kzalloc(sizeof(*kfd), GFP_KERNEL);
+	if (!kfd)
+		return NULL;
+
 	kfd->kgd = kgd;
 	kfd->device_info = device_info;
 	kfd->pdev = pdev;
diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
index 56875f9..4931f8a 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
@@ -317,7 +317,7 @@ static struct mqd_manager *get_mqd_manager_nocpsch(struct device_queue_manager *
 {
 	struct mqd_manager *mqd;
 
-	BUG_ON(!dqm || type > KFD_MQD_TYPE_MAX);
+	BUG_ON(!dqm || type >= KFD_MQD_TYPE_MAX);
 
 	pr_debug("kfd: In func %s mqd type %d\n", __func__, type);
 
diff --git a/drivers/gpu/hsa/radeon/kfd_mqd_manager.c b/drivers/gpu/hsa/radeon/kfd_mqd_manager.c
index a3e9f7c..8c1192e 100644
--- a/drivers/gpu/hsa/radeon/kfd_mqd_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_mqd_manager.c
@@ -437,6 +437,7 @@ struct mqd_manager *mqd_manager_init(enum KFD_MQD_TYPE type, struct kfd_dev *dev
 		mqd->uninitialize = uninitialize;
 		break;
 	default:
+		kfree(mqd);
 		return NULL;
 		break;
 	}
diff --git a/drivers/gpu/hsa/radeon/kfd_packet_manager.c b/drivers/gpu/hsa/radeon/kfd_packet_manager.c
index 621a720..5cd23b0 100644
--- a/drivers/gpu/hsa/radeon/kfd_packet_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_packet_manager.c
@@ -85,9 +85,10 @@ static int pm_allocate_runlist_ib(struct packet_manager *pm, unsigned int **rl_b
 
 	BUG_ON(!pm);
 	BUG_ON(pm->allocated == true);
+	BUG_ON(is_over_subscription == NULL);
 
 	pm_calc_rlib_size(pm, rl_buffer_size, is_over_subscription);
-	if (is_over_subscription &&
+	if (*is_over_subscription &&
 			sched_policy == KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION)
 		return -EFAULT;
 
diff --git a/drivers/gpu/hsa/radeon/kfd_process.c b/drivers/gpu/hsa/radeon/kfd_process.c
index eb30cb3..aacc7ef 100644
--- a/drivers/gpu/hsa/radeon/kfd_process.c
+++ b/drivers/gpu/hsa/radeon/kfd_process.c
@@ -146,15 +146,15 @@ static struct kfd_process *create_process(const struct task_struct *thread)
 	process = kzalloc(sizeof(*process), GFP_KERNEL);
 
 	if (!process)
-		goto err_alloc;
+		goto err_alloc_process;
 
 	process->queues = kmalloc_array(INITIAL_QUEUE_ARRAY_SIZE, sizeof(process->queues[0]), GFP_KERNEL);
 	if (!process->queues)
-		goto err_alloc;
+		goto err_alloc_queues;
 
 	process->pasid = radeon_kfd_pasid_alloc();
 	if (process->pasid == 0)
-		goto err_alloc;
+		goto err_alloc_pasid;
 
 	mutex_init(&process->mutex);
 
@@ -178,9 +178,11 @@ err_process_pqm_init:
 	radeon_kfd_pasid_free(process->pasid);
 	list_del(&process->processes_list);
 	thread->mm->kfd_process = NULL;
-err_alloc:
+err_alloc_pasid:
 	kfree(process->queues);
+err_alloc_queues:
 	kfree(process);
+err_alloc_process:
 	return ERR_PTR(err);
 }
 
-- 
1.9.1

