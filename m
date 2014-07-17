Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbaGQNsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:48:37 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:43506
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932179AbaGQNsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:48:35 -0400
X-WSS-ID: 0N8UYZS-07-C3O-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Subject: [PATCH v2 19/25] amdkfd: Add device queue manager module
Date: Thu, 17 Jul 2014 16:29:26 +0300
Message-ID: <1405603773-32688-20-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(101416001)(84676001)(92566001)(83072002)(20776003)(76176999)(575784001)(104166001)(102836001)(68736004)(31966008)(76482001)(46102001)(93916002)(33646002)(106466001)(95666004)(97736001)(50986999)(80022001)(92726001)(50226001)(47776003)(62966002)(81342001)(79102001)(21056001)(86362001)(85306003)(77096002)(87286001)(64706001)(74502001)(87936001)(229853001)(36756003)(77156001)(81542001)(77982001)(85852003)(4396001)(48376002)(50466002)(107046002)(19580405001)(83322001)(44976005)(89996001)(19580395003)(105586002)(74662001)(99396002)(88136002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB041;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

The queue scheduler divides into two sections, one section is process bounded and the other section is device bounded.
The device bounded section is handled by this module.
The DQM module handles queue setup, update and tear-down from the device side.
It also supports suspend/resume operation.

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/Makefile             |   2 +-
 drivers/gpu/drm/radeon/amdkfd/kfd_device.c         |  26 +-
 .../drm/radeon/amdkfd/kfd_device_queue_manager.c   | 985 +++++++++++++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |  13 +
 4 files changed, 1023 insertions(+), 3 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.c

diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
index eacef85..44639f2 100644
--- a/drivers/gpu/drm/radeon/amdkfd/Makefile
+++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
@@ -8,6 +8,6 @@ amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_vidmem.o kfd_aperture.o \
 		kfd_process.o kfd_queue.o kfd_mqd_manager.o \
 		kfd_kernel_queue.o kfd_packet_manager.o \
-		kfd_process_queue_manager.o
+		kfd_process_queue_manager.o kfd_device_queue_manager.o
 
 obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
index 7c4c836..f5e9f39 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include "kfd_priv.h"
+#include "kfd_device_queue_manager.h"
 
 static const struct kfd_device_info kaveri_device_info = {
 	.max_pasid_bits = 16,
@@ -165,10 +166,26 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 
 	amd_iommu_set_invalidate_ctx_cb(kfd->pdev, iommu_pasid_shutdown_callback);
 
+	kfd->dqm = device_queue_manager_init(kfd);
+	if (!kfd->dqm) {
+		kfd_topology_remove_device(kfd);
+		amd_iommu_free_device(kfd->pdev);
+		return false;
+	}
+
+	if (kfd->dqm->start(kfd->dqm) != 0) {
+		device_queue_manager_uninit(kfd->dqm);
+		kfd_topology_remove_device(kfd);
+		amd_iommu_free_device(kfd->pdev);
+		return false;
+	}
+
 	kfd->init_complete = true;
 	dev_info(kfd_device, "added device (%x:%x)\n", kfd->pdev->vendor,
 		 kfd->pdev->device);
 
+	pr_debug("kfd: Starting kfd with the following scheduling policy %d\n", sched_policy);
+
 	return true;
 }
 
@@ -178,8 +195,10 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd)
 
 	BUG_ON(err != 0);
 
-	if (kfd->init_complete)
+	if (kfd->init_complete) {
+		device_queue_manager_uninit(kfd->dqm);
 		amd_iommu_free_device(kfd->pdev);
+	}
 
 	kfree(kfd);
 }
@@ -188,8 +207,10 @@ void kgd2kfd_suspend(struct kfd_dev *kfd)
 {
 	BUG_ON(kfd == NULL);
 
-	if (kfd->init_complete)
+	if (kfd->init_complete) {
+		kfd->dqm->stop(kfd->dqm);
 		amd_iommu_free_device(kfd->pdev);
+	}
 }
 
 int kgd2kfd_resume(struct kfd_dev *kfd)
@@ -206,6 +227,7 @@ int kgd2kfd_resume(struct kfd_dev *kfd)
 		if (err < 0)
 			return -ENXIO;
 		amd_iommu_set_invalidate_ctx_cb(kfd->pdev, iommu_pasid_shutdown_callback);
+		kfd->dqm->start(kfd->dqm);
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.c
new file mode 100644
index 0000000..d875d00
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.c
@@ -0,0 +1,985 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/printk.h>
+#include <linux/bitops.h>
+#include "kfd_priv.h"
+#include "kfd_device_queue_manager.h"
+#include "kfd_mqd_manager.h"
+#include "cik_regs.h"
+#include "kfd_kernel_queue.h"
+
+#define CIK_HPD_SIZE_LOG2 11
+#define CIK_HPD_SIZE (1U << CIK_HPD_SIZE_LOG2)
+
+static bool is_mem_initialized;
+
+static int init_memory(struct device_queue_manager *dqm);
+static int
+set_pasid_vmid_mapping(struct device_queue_manager *dqm, unsigned int pasid, unsigned int vmid);
+
+static inline unsigned int get_pipes_num(struct device_queue_manager *dqm)
+{
+	BUG_ON(!dqm || !dqm->dev);
+	return dqm->dev->shared_resources.compute_pipe_count;
+}
+
+static inline unsigned int get_first_pipe(struct device_queue_manager *dqm)
+{
+	BUG_ON(!dqm);
+	return dqm->dev->shared_resources.first_compute_pipe;
+}
+
+static inline unsigned int get_pipes_num_cpsch(void)
+{
+	return PIPE_PER_ME_CP_SCHEDULING;
+}
+
+static unsigned int get_sh_mem_bases_nybble_64(struct kfd_process *process, struct kfd_dev *dev)
+{
+	struct kfd_process_device *pdd;
+	uint32_t nybble;
+
+	pdd = kfd_get_process_device_data(dev, process);
+	nybble = (pdd->lds_base >> 60) & 0x0E;
+
+	return nybble;
+
+}
+
+static unsigned int get_sh_mem_bases_32(struct kfd_process *process, struct kfd_dev *dev)
+{
+	struct kfd_process_device *pdd;
+	unsigned int shared_base;
+
+	pdd = kfd_get_process_device_data(dev, process);
+	shared_base = (pdd->lds_base >> 16) & 0xFF;
+
+	return shared_base;
+}
+
+static uint32_t compute_sh_mem_bases_64bit(unsigned int top_address_nybble);
+static void init_process_memory(struct device_queue_manager *dqm, struct qcm_process_device *qpd)
+{
+	unsigned int temp;
+
+	BUG_ON(!dqm || !qpd);
+
+	/* check if sh_mem_config register already configured */
+	if (qpd->sh_mem_config == 0) {
+		qpd->sh_mem_config =
+			ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED) |
+			DEFAULT_MTYPE(MTYPE_NONCACHED) |
+			APE1_MTYPE(MTYPE_NONCACHED);
+		qpd->sh_mem_ape1_limit = 0;
+		qpd->sh_mem_ape1_base = 0;
+	}
+
+	if (qpd->pqm->process->is_32bit_user_mode) {
+		temp = get_sh_mem_bases_32(qpd->pqm->process, dqm->dev);
+		qpd->sh_mem_bases = SHARED_BASE(temp);
+		qpd->sh_mem_config |= PTR32;
+	} else {
+		temp = get_sh_mem_bases_nybble_64(qpd->pqm->process, dqm->dev);
+		qpd->sh_mem_bases = compute_sh_mem_bases_64bit(temp);
+	}
+
+	pr_debug("kfd: is32bit process: %d sh_mem_bases nybble: 0x%X and register 0x%X\n",
+		qpd->pqm->process->is_32bit_user_mode, temp, qpd->sh_mem_bases);
+}
+
+static void program_sh_mem_settings(struct device_queue_manager *dqm, struct qcm_process_device *qpd)
+{
+	return kfd2kgd->program_sh_mem_settings(dqm->dev->kgd, qpd->vmid, qpd->sh_mem_config,
+			qpd->sh_mem_ape1_base, qpd->sh_mem_ape1_limit, qpd->sh_mem_bases);
+}
+
+static int create_queue_nocpsch(struct device_queue_manager *dqm, struct queue *q,
+			struct qcm_process_device *qpd, int *allocate_vmid)
+{
+	bool set, is_new_vmid;
+	int bit, retval, pipe, i;
+	struct mqd_manager *mqd;
+
+	BUG_ON(!dqm || !q || !qpd || !allocate_vmid);
+	retval = 0;
+
+	pr_debug("kfd: In func %s\n", __func__);
+	print_queue(q);
+
+	mutex_lock(&dqm->lock);
+
+	if (dqm->vmid_bitmap == 0 && qpd->vmid == 0) {
+		retval = -ENOMEM;
+		goto no_vmid;
+	}
+
+	is_new_vmid = false;
+	if (qpd->vmid == 0) {
+		bit = find_first_bit((unsigned long *)&dqm->vmid_bitmap, CIK_VMID_NUM);
+		clear_bit(bit, (unsigned long *)&dqm->vmid_bitmap);
+
+		/* Kaveri kfd vmid's strts from vmid 8 */
+		*allocate_vmid = qpd->vmid = bit + KFD_VMID_START_OFFSET;
+		q->properties.vmid = *allocate_vmid;
+
+
+		pr_debug("kfd: vmid allocation %d\n", *allocate_vmid);
+		set_pasid_vmid_mapping(dqm, q->process->pasid, q->properties.vmid);
+		qpd->vmid = *allocate_vmid;
+		is_new_vmid = true;
+
+		program_sh_mem_settings(dqm, qpd);
+	}
+	q->properties.vmid = qpd->vmid;
+
+	set = false;
+	for (i = 0, pipe = dqm->next_pipe_to_allocate; i < get_pipes_num(dqm);
+			pipe = (pipe + i++) % get_pipes_num(dqm)) {
+		if (dqm->allocated_queues[pipe] != 0) {
+			bit = find_first_bit((unsigned long *)&dqm->allocated_queues[pipe], QUEUES_PER_PIPE);
+			clear_bit(bit, (unsigned long *)&dqm->allocated_queues[pipe]);
+			q->pipe = pipe;
+			q->queue = bit;
+			set = true;
+			break;
+		}
+	}
+
+	if (set == false) {
+		retval = -EBUSY;
+		goto no_hqd;
+	}
+	pr_debug("kfd: DQM %s hqd slot - pipe (%d) queue(%d)\n",
+				__func__, q->pipe, q->queue);
+	dqm->next_pipe_to_allocate = (pipe + 1) % get_pipes_num(dqm);
+
+	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_COMPUTE);
+	if (mqd == NULL) {
+		retval = -ENOMEM;
+		goto fail_get_mqd_manager;
+	}
+
+	retval = mqd->init_mqd(mqd, &q->mqd, &q->mqd_mem_obj, &q->gart_mqd_addr, &q->properties);
+	if (retval != 0) {
+		set_bit(q->queue, (unsigned long *)&dqm->allocated_queues[q->pipe]);
+		goto init_mqd_failed;
+	}
+
+	list_add(&q->list, &qpd->queues_list);
+	dqm->queue_count++;
+
+	mutex_unlock(&dqm->lock);
+	return 0;
+
+init_mqd_failed:
+fail_get_mqd_manager:
+no_hqd:
+	if (is_new_vmid == true) {
+		set_bit(*allocate_vmid - KFD_VMID_START_OFFSET, (unsigned long *)&dqm->vmid_bitmap);
+		*allocate_vmid = qpd->vmid = q->properties.vmid = 0;
+	}
+no_vmid:
+	mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+static int destroy_queue_nocpsch(struct device_queue_manager *dqm, struct qcm_process_device *qpd, struct queue *q)
+{
+	int retval;
+	struct mqd_manager *mqd;
+
+	BUG_ON(!dqm || !q || !q->mqd || !qpd);
+
+	retval = 0;
+
+	pr_debug("kfd: In Func %s\n", __func__);
+
+	mutex_lock(&dqm->lock);
+	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_COMPUTE);
+	if (mqd == NULL) {
+		retval = -ENOMEM;
+		goto out;
+	}
+	retval = mqd->destroy_mqd(mqd, false, QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS, q->pipe, q->queue);
+	if (retval != 0)
+		goto out;
+
+	mqd->uninit_mqd(mqd, q->mqd, q->mqd_mem_obj);
+
+	set_bit(q->queue, (unsigned long *)&dqm->allocated_queues[q->pipe]);
+	q->queue = q->pipe = 0;
+	list_del(&q->list);
+	if (list_empty(&qpd->queues_list)) {
+		set_bit(qpd->vmid - 8, (unsigned long *)&dqm->vmid_bitmap);
+		qpd->vmid = 0;
+	}
+	dqm->queue_count--;
+out:
+	mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+static int update_queue_nocpsch(struct device_queue_manager *dqm, struct queue *q)
+{
+	int retval;
+	struct mqd_manager *mqd;
+
+	BUG_ON(!dqm || !q || !q->mqd);
+
+	mutex_lock(&dqm->lock);
+	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_COMPUTE);
+	if (mqd == NULL) {
+		mutex_unlock(&dqm->lock);
+		return -ENOMEM;
+	}
+	retval = mqd->update_mqd(mqd, q->mqd, &q->properties);
+	if (q->properties.is_active == true)
+		dqm->queue_count++;
+	else
+		dqm->queue_count--;
+
+	mutex_unlock(&dqm->lock);
+	return 0;
+}
+
+static int destroy_queues_nocpsch(struct device_queue_manager *dqm)
+{
+	struct device_process_node *cur;
+	struct mqd_manager *mqd;
+	struct queue *q;
+
+	BUG_ON(!dqm);
+
+	mutex_lock(&dqm->lock);
+	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_COMPUTE);
+	if (mqd == NULL) {
+		mutex_unlock(&dqm->lock);
+		return -ENOMEM;
+	}
+
+	list_for_each_entry(cur, &dqm->queues, list) {
+		list_for_each_entry(q, &cur->qpd->queues_list, list) {
+			mqd->destroy_mqd(mqd, false, QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS, q->pipe, q->queue);
+		}
+	}
+
+	mutex_unlock(&dqm->lock);
+
+	return 0;
+}
+
+static struct mqd_manager *get_mqd_manager_nocpsch(struct device_queue_manager *dqm, enum KFD_MQD_TYPE type)
+{
+	struct mqd_manager *mqd;
+
+	BUG_ON(!dqm || type >= KFD_MQD_TYPE_MAX);
+
+	pr_debug("kfd: In func %s mqd type %d\n", __func__, type);
+
+	mqd = dqm->mqds[type];
+	if (!mqd) {
+		mqd = mqd_manager_init(type, dqm->dev);
+		if (mqd == NULL)
+			pr_err("kfd: mqd manager is NULL");
+		dqm->mqds[type] = mqd;
+	}
+
+	return mqd;
+}
+
+static int execute_queues_nocpsch(struct device_queue_manager *dqm)
+{
+	struct qcm_process_device *qpd;
+	struct device_process_node *node;
+	struct queue *q;
+	struct mqd_manager *mqd;
+
+	BUG_ON(!dqm);
+
+	mutex_lock(&dqm->lock);
+	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_COMPUTE);
+	if (mqd == NULL) {
+		mutex_unlock(&dqm->lock);
+		return -ENOMEM;
+	}
+
+	list_for_each_entry(node, &dqm->queues, list) {
+		qpd = node->qpd;
+		list_for_each_entry(q, &qpd->queues_list, list) {
+			pr_debug("kfd: executing queue (%d, %d)\n", q->pipe, q->queue);
+			if (mqd->is_occupied(mqd, q->properties.queue_address, q->pipe, q->queue) == false &&
+					q->properties.is_active == true)
+				mqd->load_mqd(mqd, q->mqd, q->pipe, q->queue, q->properties.write_ptr);
+		}
+	}
+
+	mutex_unlock(&dqm->lock);
+
+	return 0;
+}
+
+static int register_process_nocpsch(struct device_queue_manager *dqm, struct qcm_process_device *qpd)
+{
+	struct device_process_node *n;
+
+	BUG_ON(!dqm || !qpd);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	n = kzalloc(sizeof(struct device_process_node), GFP_KERNEL);
+	if (!n)
+		return -ENOMEM;
+
+	n->qpd = qpd;
+
+	mutex_lock(&dqm->lock);
+	list_add(&n->list, &dqm->queues);
+
+	init_process_memory(dqm, qpd);
+	dqm->processes_count++;
+
+	mutex_unlock(&dqm->lock);
+
+	return 0;
+}
+
+static int unregister_process_nocpsch(struct device_queue_manager *dqm, struct qcm_process_device *qpd)
+{
+	int retval;
+	struct device_process_node *cur, *next;
+
+	BUG_ON(!dqm || !qpd);
+
+	BUG_ON(!list_empty(&qpd->queues_list));
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	retval = 0;
+	mutex_lock(&dqm->lock);
+
+	list_for_each_entry_safe(cur, next, &dqm->queues, list) {
+		if (qpd == cur->qpd) {
+			list_del(&cur->list);
+			dqm->processes_count--;
+			goto out;
+		}
+	}
+	/* qpd not found in dqm list */
+	retval = 1;
+out:
+	mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+static int
+set_pasid_vmid_mapping(struct device_queue_manager *dqm, unsigned int pasid, unsigned int vmid)
+{
+	uint32_t pasid_mapping;
+
+	pasid_mapping = (pasid == 0) ? 0 : (uint32_t)pasid | ATC_VMID_PASID_MAPPING_VALID;
+	return kfd2kgd->set_pasid_vmid_mapping(dqm->dev->kgd, pasid_mapping, vmid);
+}
+
+static uint32_t compute_sh_mem_bases_64bit(unsigned int top_address_nybble)
+{
+	/* In 64-bit mode, we can only control the top 3 bits of the LDS, scratch and GPUVM apertures.
+	 * The hardware fills in the remaining 59 bits according to the following pattern:
+	 * LDS:		X0000000'00000000 - X0000001'00000000 (4GB)
+	 * Scratch:	X0000001'00000000 - X0000002'00000000 (4GB)
+	 * GPUVM:	Y0010000'00000000 - Y0020000'00000000 (1TB)
+	 *
+	 * (where X/Y is the configurable nybble with the low-bit 0)
+	 *
+	 * LDS and scratch will have the same top nybble programmed in the top 3 bits of SH_MEM_BASES.PRIVATE_BASE.
+	 * GPUVM can have a different top nybble programmed in the top 3 bits of SH_MEM_BASES.SHARED_BASE.
+	 * We don't bother to support different top nybbles for LDS/Scratch and GPUVM.
+	 */
+
+	BUG_ON((top_address_nybble & 1) || top_address_nybble > 0xE || top_address_nybble == 0);
+
+	return PRIVATE_BASE(top_address_nybble << 12) | SHARED_BASE(top_address_nybble << 12);
+}
+
+static int init_memory(struct device_queue_manager *dqm)
+{
+	int i, retval;
+
+	for (i = 8; i < 16; i++)
+		set_pasid_vmid_mapping(dqm, 0, i);
+
+	retval = kfd2kgd->init_memory(dqm->dev->kgd);
+	if (retval == 0)
+		is_mem_initialized = true;
+	return retval;
+}
+
+
+static int init_pipelines(struct device_queue_manager *dqm, unsigned int pipes_num, unsigned int first_pipe)
+{
+	void *hpdptr;
+	struct mqd_manager *mqd;
+	unsigned int i, err, inx;
+	uint64_t pipe_hpd_addr;
+
+	BUG_ON(!dqm || !dqm->dev);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	/*
+	 * Allocate memory for the HPDs. This is hardware-owned per-pipe data.
+	 * The driver never accesses this memory after zeroing it. It doesn't even have
+	 * to be saved/restored on suspend/resume because it contains no data when there
+	 * are no active queues.
+	 */
+	err = kfd_vidmem_alloc(dqm->dev,
+				CIK_HPD_SIZE * pipes_num,
+				PAGE_SIZE,
+				KFD_MEMPOOL_SYSTEM_WRITECOMBINE,
+				&dqm->pipeline_mem);
+	if (err) {
+		pr_err("kfd: error allocate vidmem num pipes: %d\n", pipes_num);
+		return -ENOMEM;
+	}
+
+	err = kfd_vidmem_kmap(dqm->dev, dqm->pipeline_mem, &hpdptr);
+	if (err) {
+		pr_err("kfd: err kmap vidmem\n");
+		kfd_vidmem_free(dqm->dev, dqm->pipeline_mem);
+		return -ENOMEM;
+	}
+
+	memset(hpdptr, 0, CIK_HPD_SIZE * pipes_num);
+	kfd_vidmem_unkmap(dqm->dev, dqm->pipeline_mem);
+
+	kfd_vidmem_gpumap(dqm->dev, dqm->pipeline_mem, &dqm->pipelines_addr);
+
+	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_COMPUTE);
+	if (mqd == NULL) {
+		kfd_vidmem_free(dqm->dev, dqm->pipeline_mem);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < pipes_num; i++) {
+		inx = i + first_pipe;
+		pipe_hpd_addr = dqm->pipelines_addr + i * CIK_HPD_SIZE;
+		pr_debug("kfd: pipeline address %llX\n", pipe_hpd_addr);
+		kfd2kgd->init_pipeline(dqm->dev->kgd, i, CIK_HPD_SIZE_LOG2, pipe_hpd_addr);
+	}
+
+	return 0;
+}
+
+
+static int init_scheduler(struct device_queue_manager *dqm)
+{
+	int retval;
+
+	BUG_ON(!dqm);
+
+	pr_debug("kfd: In %s\n", __func__);
+
+	retval = init_pipelines(dqm, get_pipes_num(dqm), KFD_DQM_FIRST_PIPE);
+	if (retval != 0)
+		return retval;
+	/* should be later integrated with Evgeny/Alexey memory management code */
+	retval = init_memory(dqm);
+	return retval;
+}
+
+static int initialize_nocpsch(struct device_queue_manager *dqm)
+{
+	int i;
+
+	BUG_ON(!dqm);
+
+	pr_debug("kfd: In func %s num of pipes: %d\n", __func__, get_pipes_num(dqm));
+
+	mutex_init(&dqm->lock);
+	INIT_LIST_HEAD(&dqm->queues);
+	dqm->queue_count = dqm->next_pipe_to_allocate = 0;
+	dqm->allocated_queues = kcalloc(get_pipes_num(dqm), sizeof(unsigned int), GFP_KERNEL);
+	if (!dqm->allocated_queues) {
+		mutex_destroy(&dqm->lock);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < get_pipes_num(dqm); i++)
+		dqm->allocated_queues[i] = (1 << QUEUES_PER_PIPE) - 1;
+
+	dqm->vmid_bitmap = (1 << VMID_PER_DEVICE) - 1;
+
+	init_scheduler(dqm);
+	return 0;
+}
+
+static void uninitialize_nocpsch(struct device_queue_manager *dqm)
+{
+	BUG_ON(!dqm);
+
+	BUG_ON(dqm->queue_count > 0 || dqm->processes_count > 0);
+
+	kfree(dqm->allocated_queues);
+	mutex_destroy(&dqm->lock);
+	kfd_vidmem_free(dqm->dev, dqm->pipeline_mem);
+}
+
+static int start_nocpsch(struct device_queue_manager *dqm)
+{
+	return 0;
+}
+
+static int stop_nocpsch(struct device_queue_manager *dqm)
+{
+	return 0;
+}
+
+/*
+ * Device Queue Manager implementation for cp scheduler
+ */
+
+static int set_sched_resources(struct device_queue_manager *dqm)
+{
+	struct scheduling_resources res;
+	unsigned int queue_num, queue_mask;
+
+	BUG_ON(!dqm);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	queue_num = get_pipes_num_cpsch() * QUEUES_PER_PIPE;
+	queue_mask = (1 << queue_num) - 1;
+	res.vmid_mask = (1 << VMID_PER_DEVICE) - 1;
+	res.vmid_mask <<= KFD_VMID_START_OFFSET;
+	res.queue_mask = queue_mask << (get_first_pipe(dqm) * QUEUES_PER_PIPE);
+	res.gws_mask = res.oac_mask = res.gds_heap_base = res.gds_heap_size = 0;
+
+	pr_debug("kfd: scheduling resources:\n"
+			"      vmid mask: 0x%8X\n"
+			"      queue mask: 0x%8llX\n", res.vmid_mask, res.queue_mask);
+
+	return pm_send_set_resources(&dqm->packets, &res);
+}
+
+static int initialize_cpsch(struct device_queue_manager *dqm)
+{
+	int retval;
+
+	BUG_ON(!dqm);
+
+	pr_debug("kfd: In func %s num of pipes: %d\n", __func__, get_pipes_num_cpsch());
+
+	mutex_init(&dqm->lock);
+	INIT_LIST_HEAD(&dqm->queues);
+	dqm->queue_count = dqm->processes_count = 0;
+	dqm->active_runlist = false;
+	retval = init_pipelines(dqm, get_pipes_num(dqm), 0);
+	if (retval != 0)
+		goto fail_init_pipelines;
+
+	return 0;
+
+fail_init_pipelines:
+	mutex_destroy(&dqm->lock);
+	return retval;
+}
+
+static int start_cpsch(struct device_queue_manager *dqm)
+{
+	struct device_process_node *node;
+	int retval;
+
+	BUG_ON(!dqm);
+
+	retval = 0;
+
+	retval = pm_init(&dqm->packets, dqm);
+	if (retval != 0)
+		goto fail_packet_manager_init;
+
+	retval = set_sched_resources(dqm);
+	if (retval != 0)
+		goto fail_set_sched_resources;
+
+	pr_debug("kfd: allocating fence memory\n");
+	/* allocate fence memory on the gart */
+	retval = kfd_vidmem_alloc_map(dqm->dev, &dqm->fence_mem,
+					(void **)&dqm->fence_addr,
+					&dqm->fence_gpu_addr,
+					sizeof(*dqm->fence_addr));
+	if (retval != 0)
+		goto fail_allocate_vidmem;
+
+	list_for_each_entry(node, &dqm->queues, list) {
+	if (node->qpd->pqm->process && dqm->dev)
+		kfd_bind_process_to_device(dqm->dev, node->qpd->pqm->process);
+	}
+
+	dqm->execute_queues(dqm);
+
+	return 0;
+fail_allocate_vidmem:
+fail_set_sched_resources:
+	pm_uninit(&dqm->packets);
+fail_packet_manager_init:
+	return retval;
+}
+
+static int stop_cpsch(struct device_queue_manager *dqm)
+{
+	struct device_process_node *node;
+	struct kfd_process_device *pdd;
+
+	BUG_ON(!dqm);
+
+	dqm->destroy_queues(dqm);
+
+	list_for_each_entry(node, &dqm->queues, list) {
+		pdd = kfd_get_process_device_data(dqm->dev, node->qpd->pqm->process);
+		pdd->bound = false;
+	}
+	kfd_vidmem_free_unmap(dqm->dev, dqm->fence_mem);
+	pm_uninit(&dqm->packets);
+
+	return 0;
+}
+
+static int create_kernel_queue_cpsch(struct device_queue_manager *dqm,
+					struct kernel_queue *kq,
+					struct qcm_process_device *qpd)
+{
+	BUG_ON(!dqm || !kq || !qpd);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	mutex_lock(&dqm->lock);
+	list_add(&kq->list, &qpd->priv_queue_list);
+	dqm->queue_count++;
+	qpd->is_debug = true;
+	mutex_unlock(&dqm->lock);
+
+	return 0;
+}
+
+static void destroy_kernel_queue_cpsch(struct device_queue_manager *dqm,
+					struct kernel_queue *kq,
+					struct qcm_process_device *qpd)
+{
+	BUG_ON(!dqm || !kq);
+
+	pr_debug("kfd: In %s\n", __func__);
+
+	dqm->destroy_queues(dqm);
+
+	mutex_lock(&dqm->lock);
+	list_del(&kq->list);
+	dqm->queue_count--;
+	qpd->is_debug = false;
+	mutex_unlock(&dqm->lock);
+}
+
+static int create_queue_cpsch(struct device_queue_manager *dqm, struct queue *q,
+			struct qcm_process_device *qpd, int *allocate_vmid)
+{
+	int retval;
+	struct mqd_manager *mqd;
+
+	BUG_ON(!dqm || !q || !qpd);
+
+	retval = 0;
+
+	if (allocate_vmid)
+		*allocate_vmid = 0;
+
+	mutex_lock(&dqm->lock);
+
+	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_CP);
+	if (mqd == NULL) {
+		mutex_unlock(&dqm->lock);
+		return -ENOMEM;
+	}
+
+	retval = mqd->init_mqd(mqd, &q->mqd, &q->mqd_mem_obj, &q->gart_mqd_addr, &q->properties);
+	if (retval != 0)
+		goto out;
+
+	list_add(&q->list, &qpd->queues_list);
+	if (q->properties.is_active)
+		dqm->queue_count++;
+
+out:
+	mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+int fence_wait_timeout(unsigned int *fence_addr, unsigned int fence_value, unsigned long timeout)
+{
+	BUG_ON(!fence_addr);
+	timeout += jiffies;
+
+	while (*fence_addr != fence_value) {
+		if (time_after(jiffies, timeout)) {
+			pr_err("kfd: qcm fence wait loop timeout expired\n");
+			return -ETIME;
+		}
+		cpu_relax();
+	}
+
+	return 0;
+}
+
+static int destroy_queues_cpsch(struct device_queue_manager *dqm)
+{
+	int retval;
+
+	BUG_ON(!dqm);
+
+	retval = 0;
+
+	mutex_lock(&dqm->lock);
+	if (dqm->active_runlist == false)
+		goto out;
+	retval = pm_send_unmap_queue(&dqm->packets, KFD_QUEUE_TYPE_COMPUTE,
+			KFD_PRERMPT_TYPE_FILTER_ALL_QUEUES, 0, false);
+	if (retval != 0)
+		goto out;
+
+	*dqm->fence_addr = KFD_FENCE_INIT;
+	pm_send_query_status(&dqm->packets, dqm->fence_gpu_addr, KFD_FENCE_COMPLETED);
+	/* should be timed out */
+	fence_wait_timeout(dqm->fence_addr, KFD_FENCE_COMPLETED, QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS);
+	pm_release_ib(&dqm->packets);
+	dqm->active_runlist = false;
+
+out:
+	mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+static int execute_queues_cpsch(struct device_queue_manager *dqm)
+{
+	int retval;
+
+	BUG_ON(!dqm);
+
+	retval = dqm->destroy_queues(dqm);
+	if (retval != 0) {
+		pr_err("kfd: the cp might be in an unrecoverable state due to an unsuccesful queues premption");
+		return retval;
+	}
+
+	if (dqm->queue_count <= 0 || dqm->processes_count <= 0)
+		return 0;
+
+	mutex_lock(&dqm->lock);
+	if (dqm->active_runlist) {
+		retval = 0;
+		goto out;
+	}
+	retval = pm_send_runlist(&dqm->packets, &dqm->queues);
+	if (retval != 0) {
+		pr_err("kfd: failed to execute runlist");
+		goto out;
+	}
+	dqm->active_runlist = true;
+
+out:
+	mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+static int destroy_queue_cpsch(struct device_queue_manager *dqm, struct qcm_process_device *qpd, struct queue *q)
+{
+	int retval;
+	struct mqd_manager *mqd;
+
+	BUG_ON(!dqm || !qpd || !q);
+
+	retval = 0;
+
+	/* preempt queues before delete mqd */
+	dqm->destroy_queues(dqm);
+
+	mutex_lock(&dqm->lock);
+	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_CP);
+	if (!mqd) {
+		retval = -ENOMEM;
+		goto failed_get_mqd_manager;
+	}
+	list_del(&q->list);
+
+	mqd->uninit_mqd(mqd, q->mqd, q->mqd_mem_obj);
+	dqm->queue_count--;
+	mutex_unlock(&dqm->lock);
+
+	return 0;
+failed_get_mqd_manager:
+	mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+/* Low bits must be 0000/FFFF as required by HW, high bits must be 0 to stay in user mode. */
+#define APE1_FIXED_BITS_MASK 0xFFFF80000000FFFFULL
+#define APE1_LIMIT_ALIGNMENT 0xFFFF /* APE1 limit is inclusive and 64K aligned. */
+
+static bool set_cache_memory_policy(struct device_queue_manager *dqm,
+				   struct qcm_process_device *qpd,
+				   enum cache_policy default_policy,
+				   enum cache_policy alternate_policy,
+				   void __user *alternate_aperture_base,
+				   uint64_t alternate_aperture_size)
+{
+	uint32_t default_mtype;
+	uint32_t ape1_mtype;
+
+	pr_debug("kfd: In func %s\n", __func__);
+	mutex_lock(&dqm->lock);
+
+	if (alternate_aperture_size == 0) {
+		/* base > limit disables APE1 */
+		qpd->sh_mem_ape1_base = 1;
+		qpd->sh_mem_ape1_limit = 0;
+	} else {
+		/*
+		 * In FSA64, APE1_Base[63:0] = { 16{SH_MEM_APE1_BASE[31]}, SH_MEM_APE1_BASE[31:0], 0x0000 }
+		 * APE1_Limit[63:0] = { 16{SH_MEM_APE1_LIMIT[31]}, SH_MEM_APE1_LIMIT[31:0], 0xFFFF }
+		 * Verify that the base and size parameters can be represented in this format
+		 * and convert them. Additionally restrict APE1 to user-mode addresses.
+		 */
+
+		uint64_t base = (uintptr_t)alternate_aperture_base;
+		uint64_t limit = base + alternate_aperture_size - 1;
+
+		if (limit <= base)
+			goto out;
+
+		if ((base & APE1_FIXED_BITS_MASK) != 0)
+			goto out;
+
+		if ((limit & APE1_FIXED_BITS_MASK) != APE1_LIMIT_ALIGNMENT)
+			goto out;
+
+		qpd->sh_mem_ape1_base = base >> 16;
+		qpd->sh_mem_ape1_limit = limit >> 16;
+
+	}
+
+	default_mtype = (default_policy == cache_policy_coherent) ?
+			MTYPE_NONCACHED :
+			MTYPE_CACHED;
+
+	ape1_mtype = (alternate_policy == cache_policy_coherent) ?
+			MTYPE_NONCACHED :
+			MTYPE_CACHED;
+
+	qpd->sh_mem_config = (qpd->sh_mem_config & PTR32)
+			| ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED)
+			| DEFAULT_MTYPE(default_mtype)
+			| APE1_MTYPE(ape1_mtype);
+
+	if ((sched_policy == KFD_SCHED_POLICY_NO_HWS) && (qpd->vmid != 0))
+		program_sh_mem_settings(dqm, qpd);
+
+	pr_debug("kfd: sh_mem_config: 0x%x, ape1_base: 0x%x, ape1_limit: 0x%x\n",
+		qpd->sh_mem_config, qpd->sh_mem_ape1_base,
+		qpd->sh_mem_ape1_limit);
+
+	mutex_unlock(&dqm->lock);
+	return true;
+
+out:
+	mutex_unlock(&dqm->lock);
+	return false;
+}
+
+struct device_queue_manager *device_queue_manager_init(struct kfd_dev *dev)
+{
+	struct device_queue_manager *dqm;
+
+	BUG_ON(!dev);
+
+	dqm = kzalloc(sizeof(struct device_queue_manager), GFP_KERNEL);
+	if (!dqm)
+		return NULL;
+
+	dqm->dev = dev;
+	switch (sched_policy) {
+	case KFD_SCHED_POLICY_HWS:
+	case KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION:
+		/* initialize dqm for cp scheduling */
+		dqm->create_queue = create_queue_cpsch;
+		dqm->initialize = initialize_cpsch;
+		dqm->start = start_cpsch;
+		dqm->stop = stop_cpsch;
+		dqm->destroy_queues = destroy_queues_cpsch;
+		dqm->execute_queues = execute_queues_cpsch;
+		dqm->destroy_queue = destroy_queue_cpsch;
+		dqm->update_queue = update_queue_nocpsch;
+		dqm->get_mqd_manager = get_mqd_manager_nocpsch;
+		dqm->register_process = register_process_nocpsch;
+		dqm->unregister_process = unregister_process_nocpsch;
+		dqm->uninitialize = uninitialize_nocpsch;
+		dqm->create_kernel_queue = create_kernel_queue_cpsch;
+		dqm->destroy_kernel_queue = destroy_kernel_queue_cpsch;
+		dqm->set_cache_memory_policy = set_cache_memory_policy;
+		break;
+	case KFD_SCHED_POLICY_NO_HWS:
+		/* initialize dqm for no cp scheduling */
+		dqm->start = start_nocpsch;
+		dqm->stop = stop_nocpsch;
+		dqm->create_queue = create_queue_nocpsch;
+		dqm->destroy_queue = destroy_queue_nocpsch;
+		dqm->update_queue = update_queue_nocpsch;
+		dqm->destroy_queues = destroy_queues_nocpsch;
+		dqm->get_mqd_manager = get_mqd_manager_nocpsch;
+		dqm->execute_queues = execute_queues_nocpsch;
+		dqm->register_process = register_process_nocpsch;
+		dqm->unregister_process = unregister_process_nocpsch;
+		dqm->initialize = initialize_nocpsch;
+		dqm->uninitialize = uninitialize_nocpsch;
+		dqm->set_cache_memory_policy = set_cache_memory_policy;
+		break;
+	default:
+		BUG();
+		break;
+	}
+
+	if (dqm->initialize(dqm) != 0) {
+		kfree(dqm);
+		return NULL;
+	}
+
+	return dqm;
+}
+
+void device_queue_manager_uninit(struct device_queue_manager *dqm)
+{
+	BUG_ON(!dqm);
+
+	dqm->uninitialize(dqm);
+	kfree(dqm);
+}
+
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index c444b38..9815ead 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -332,6 +332,7 @@ struct kfd_process {
 struct kfd_process *kfd_create_process(const struct task_struct *);
 struct kfd_process *kfd_get_process(const struct task_struct *);
 
+struct kfd_process_device *kfd_bind_process_to_device(struct kfd_dev *dev, struct kfd_process *p);
 void kfd_unbind_process_from_device(struct kfd_dev *dev, pasid_t pasid);
 struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
 							struct kfd_process *p);
@@ -390,6 +391,9 @@ void uninit_queue(struct queue *q);
 void print_queue_properties(struct queue_properties *q);
 void print_queue(struct queue *q);
 
+struct mqd_manager *mqd_manager_init(enum KFD_MQD_TYPE type, struct kfd_dev *dev);
+struct device_queue_manager *device_queue_manager_init(struct kfd_dev *dev);
+void device_queue_manager_uninit(struct device_queue_manager *dqm);
 struct kernel_queue *kernel_queue_init(struct kfd_dev *dev, enum kfd_queue_type type);
 void kernel_queue_uninit(struct kernel_queue *kq);
 
@@ -408,6 +412,8 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid);
 
 #define KFD_HIQ_TIMEOUT (500)
 
+#define KFD_FENCE_COMPLETED (100)
+#define KFD_FENCE_INIT   (10)
 #define KFD_UNMAP_LATENCY (15)
 
 struct packet_manager {
@@ -418,6 +424,13 @@ struct packet_manager {
 	kfd_mem_obj ib_buffer_obj;
 };
 
+int pm_init(struct packet_manager *pm, struct device_queue_manager *dqm);
+void pm_uninit(struct packet_manager *pm);
+int pm_send_set_resources(struct packet_manager *pm, struct scheduling_resources *res);
+int pm_send_runlist(struct packet_manager *pm, struct list_head *dqm_queues);
+int pm_send_query_status(struct packet_manager *pm, uint64_t fence_address, uint32_t fence_value);
+int pm_send_unmap_queue(struct packet_manager *pm, enum kfd_queue_type type,
+			enum kfd_preempt_type_filter mode, uint32_t filter_param, bool reset);
 void pm_release_ib(struct packet_manager *pm);
 
 #endif
-- 
1.9.1

