Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbaHEPe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:34:56 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:52366
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755902AbaHEPdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:33:05 -0400
X-WSS-ID: 0N9UB6W-08-R4G-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@linux.ie>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>, <Andrew.Lewycky@amd.com>,
        <deathsimple@vodafone.de>, <michel.daenzer@amd.com>,
        Ben Goz <ben.goz@amd.com>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v3 17/23] amdkfd: Add process queue manager module
Date: Tue, 5 Aug 2014 18:30:45 +0300
Message-ID: <1407252651-3539-18-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(51234002)(84676001)(50466002)(87936001)(104166001)(62966002)(83072002)(86362001)(101416001)(92726001)(88136002)(92566001)(83322001)(19580405001)(95666004)(87286001)(79102001)(19580395003)(107046002)(77096002)(89996001)(4396001)(77156001)(85852003)(48376002)(50226001)(81342001)(31966008)(97736001)(21056001)(105586002)(36756003)(33646002)(99396002)(106466001)(68736004)(229853001)(77982001)(64706001)(46102001)(76176999)(74502001)(44976005)(20776003)(81542001)(74662001)(47776003)(76482001)(102836001)(80022001)(85306004)(50986999);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB040;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

The queue scheduler divides into two sections, one section is process bounded
and the other section is device bounded.
The process bounded section is handled by this module. The PQM handles usermode
queue setup, updates and tear-down.

v3: use kernel param to limit queues per process instead of define
v3: use doorbell address from user

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/Makefile             |   3 +-
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |  17 +
 drivers/gpu/drm/radeon/amdkfd/kfd_process.c        |  16 +
 .../drm/radeon/amdkfd/kfd_process_queue_manager.c  | 343 +++++++++++++++++++++
 4 files changed, 378 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c

diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
index b88e637..b18a2b5 100644
--- a/drivers/gpu/drm/radeon/amdkfd/Makefile
+++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
@@ -7,6 +7,7 @@ ccflags-y := -Iinclude/drm
 amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_aperture.o \
 		kfd_process.o kfd_queue.o kfd_mqd_manager.o \
-		kfd_kernel_queue.o kfd_packet_manager.o
+		kfd_kernel_queue.o kfd_packet_manager.o \
+		kfd_process_queue_manager.o
 
 obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 34028f8..600d671 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -365,6 +365,9 @@ struct kfd_process_device {
 	struct kfd_dev *dev;
 
 
+	/* per-process-per device QCM data structure */
+	struct qcm_process_device qpd;
+
 	/*Apertures*/
 	uint64_t lds_base;
 	uint64_t lds_limit;
@@ -410,6 +413,8 @@ struct kfd_process {
 	 */
 	struct list_head per_device_data;
 
+	struct process_queue_manager pqm;
+
 	/* The process's queues. */
 	size_t queue_array_size;
 
@@ -477,11 +482,23 @@ inline uint32_t upper_32(uint64_t x);
 
 int init_queue(struct queue **q, struct queue_properties properties);
 void uninit_queue(struct queue *q);
+void print_queue_properties(struct queue_properties *q);
 void print_queue(struct queue *q);
 
 struct kernel_queue *kernel_queue_init(struct kfd_dev *dev, enum kfd_queue_type type);
 void kernel_queue_uninit(struct kernel_queue *kq);
 
+/* Process Queue Manager */
+struct process_queue_node {
+	struct queue *q;
+	struct kernel_queue *kq;
+	struct list_head process_queue_list;
+};
+
+int pqm_init(struct process_queue_manager *pqm, struct kfd_process *p);
+void pqm_uninit(struct process_queue_manager *pqm);
+int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid);
+
 /* Packet Manager */
 
 #define KFD_HIQ_TIMEOUT (500)
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_process.c b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
index 98eba8e..b8bf15d 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
@@ -150,6 +150,9 @@ static void kfd_process_notifier_release(struct mmu_notifier *mn,
 
 	mutex_lock(&p->mutex);
 
+	/* In case our notifier is called before IOMMU notifier */
+	pqm_uninit(&p->pqm);
+
 	list_for_each_entry_safe(pdd, temp, &p->per_device_data, per_device_list) {
 		amd_iommu_unbind_pasid(pdd->dev->pdev, p->pasid);
 		list_del(&pdd->per_device_list);
@@ -214,8 +217,16 @@ static struct kfd_process *create_process(const struct task_struct *thread)
 
 	INIT_LIST_HEAD(&process->per_device_data);
 
+	err = pqm_init(&process->pqm, process);
+	if (err != 0)
+		goto err_process_pqm_init;
+
 	return process;
 
+err_process_pqm_init:
+	hash_del_rcu(&process->kfd_processes);
+	synchronize_rcu();
+	mmu_notifier_unregister_no_release(&process->mmu_notifier, process->mm);
 err_mmu_notifier:
 	kfd_pasid_free(process->pasid);
 err_alloc_pasid:
@@ -240,6 +251,9 @@ struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
 		pdd = kzalloc(sizeof(*pdd), GFP_KERNEL);
 		if (pdd != NULL) {
 			pdd->dev = dev;
+			INIT_LIST_HEAD(&pdd->qpd.queues_list);
+			INIT_LIST_HEAD(&pdd->qpd.priv_queue_list);
+			pdd->qpd.dqm = dev->dqm;
 			list_add(&pdd->per_device_list, &p->per_device_data);
 		}
 	}
@@ -299,6 +313,8 @@ void kfd_unbind_process_from_device(struct kfd_dev *dev, unsigned int pasid)
 
 	mutex_lock(&p->mutex);
 
+	pqm_uninit(&p->pqm);
+
 	pdd = kfd_get_process_device_data(dev, p, 0);
 
 	/*
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
new file mode 100644
index 0000000..7fc24b3
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
@@ -0,0 +1,343 @@
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
+#include "kfd_device_queue_manager.h"
+#include "kfd_priv.h"
+#include "kfd_kernel_queue.h"
+
+static inline struct process_queue_node *get_queue_by_qid(struct process_queue_manager *pqm, unsigned int qid)
+{
+	struct process_queue_node *pqn;
+
+	BUG_ON(!pqm);
+
+	list_for_each_entry(pqn, &pqm->queues, process_queue_list) {
+		if (pqn->q && pqn->q->properties.queue_id == qid)
+			return pqn;
+		if (pqn->kq && pqn->kq->queue->properties.queue_id == qid)
+			return pqn;
+	}
+
+	return NULL;
+}
+
+static int find_available_queue_slot(struct process_queue_manager *pqm, unsigned int *qid)
+{
+	unsigned long found;
+
+	BUG_ON(!pqm || !qid);
+
+	pr_debug("kfd: in %s\n", __func__);
+
+	found = find_first_zero_bit(pqm->queue_slot_bitmap, max_num_of_queues_per_process);
+
+	pr_debug("kfd: the new slot id %lu\n", found);
+
+	if (found >= max_num_of_queues_per_process)
+		return -ENOMEM;
+
+	set_bit(found, pqm->queue_slot_bitmap);
+	*qid = found;
+
+	return 0;
+}
+
+int pqm_init(struct process_queue_manager *pqm, struct kfd_process *p)
+{
+	BUG_ON(!pqm);
+
+	INIT_LIST_HEAD(&pqm->queues);
+	pqm->queue_slot_bitmap = kzalloc(DIV_ROUND_UP(max_num_of_queues_per_process, BITS_PER_BYTE), GFP_KERNEL);
+	if (pqm->queue_slot_bitmap == NULL)
+		return -ENOMEM;
+	pqm->process = p;
+
+	return 0;
+}
+
+void pqm_uninit(struct process_queue_manager *pqm)
+{
+	int retval;
+	struct process_queue_node *pqn, *next;
+
+	BUG_ON(!pqm);
+
+	pr_debug("In func %s\n", __func__);
+
+	list_for_each_entry_safe(pqn, next, &pqm->queues, process_queue_list) {
+		retval = pqm_destroy_queue(
+				pqm,
+				(pqn->q != NULL) ?
+					pqn->q->properties.queue_id :
+					pqn->kq->queue->properties.queue_id);
+
+		if (retval != 0) {
+			pr_err("kfd: failed to destroy queue\n");
+			return;
+		}
+	}
+	kfree(pqm->queue_slot_bitmap);
+	pqm->queue_slot_bitmap = NULL;
+}
+
+static int create_cp_queue(struct process_queue_manager *pqm, struct kfd_dev *dev, struct queue **q,
+		struct queue_properties *q_properties, struct file *f, unsigned int qid)
+{
+	int retval;
+
+	retval = 0;
+
+	/* Doorbell initialized in user space*/
+	q_properties->doorbell_ptr = NULL;
+
+	q_properties->doorbell_off = kfd_queue_id_to_doorbell(dev, pqm->process, qid);
+
+	/* let DQM handle it*/
+	q_properties->vmid = 0;
+	q_properties->queue_id = qid;
+	q_properties->type = KFD_QUEUE_TYPE_COMPUTE;
+
+	retval = init_queue(q, *q_properties);
+	if (retval != 0)
+		goto err_init_queue;
+
+	(*q)->device = dev;
+	(*q)->process = pqm->process;
+
+	pr_debug("kfd: PQM After init queue");
+
+	return retval;
+
+err_init_queue:
+	return retval;
+}
+
+int pqm_create_queue(struct process_queue_manager *pqm,
+			    struct kfd_dev *dev,
+			    struct file *f,
+			    struct queue_properties *properties,
+			    unsigned int flags,
+			    enum kfd_queue_type type,
+			    unsigned int *qid)
+{
+	int retval;
+	struct kfd_process_device *pdd;
+	struct queue_properties q_properties;
+	struct queue *q;
+	struct process_queue_node *pqn;
+	struct kernel_queue *kq;
+
+	BUG_ON(!pqm || !dev || !properties || !qid);
+
+	memset(&q_properties, 0, sizeof(struct queue_properties));
+	memcpy(&q_properties, properties, sizeof(struct queue_properties));
+
+	pdd = kfd_get_process_device_data(dev, pqm->process, 1);
+	BUG_ON(!pdd);
+
+	retval = find_available_queue_slot(pqm, qid);
+	if (retval != 0)
+		return retval;
+
+	if (list_empty(&pqm->queues)) {
+		pdd->qpd.pqm = pqm;
+		dev->dqm->register_process(dev->dqm, &pdd->qpd);
+	}
+
+	pqn = kzalloc(sizeof(struct process_queue_node), GFP_KERNEL);
+	if (!pqn) {
+		retval = -ENOMEM;
+		goto err_allocate_pqn;
+	}
+
+	switch (type) {
+	case KFD_QUEUE_TYPE_COMPUTE:
+		/* check if there is over subscription */
+		if ((sched_policy == KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION) &&
+		((dev->dqm->processes_count >= VMID_PER_DEVICE) ||
+		(dev->dqm->queue_count >= PIPE_PER_ME_CP_SCHEDULING * QUEUES_PER_PIPE))) {
+			pr_err("kfd: over-subscription is not allowed in radeon_kfd.sched_policy == 1\n");
+			retval = -EPERM;
+			goto err_create_queue;
+		}
+
+		retval = create_cp_queue(pqm, dev, &q, &q_properties, f, *qid);
+		if (retval != 0)
+			goto err_create_queue;
+		pqn->q = q;
+		pqn->kq = NULL;
+		retval = dev->dqm->create_queue(dev->dqm, q, &pdd->qpd, &q->properties.vmid);
+		print_queue(q);
+		break;
+	case KFD_QUEUE_TYPE_DIQ:
+		kq = kernel_queue_init(dev, KFD_QUEUE_TYPE_DIQ);
+		if (kq == NULL) {
+			kernel_queue_uninit(kq);
+			goto err_create_queue;
+		}
+		kq->queue->properties.queue_id = *qid;
+		pqn->kq = kq;
+		pqn->q = NULL;
+		retval = dev->dqm->create_kernel_queue(dev->dqm, kq, &pdd->qpd);
+		break;
+	default:
+		BUG();
+		break;
+	}
+
+	if (retval != 0) {
+		pr_err("kfd: error dqm create queue\n");
+		goto err_create_queue;
+	}
+
+	pr_debug("kfd: PQM After DQM create queue\n");
+
+	list_add(&pqn->process_queue_list, &pqm->queues);
+
+	retval = dev->dqm->execute_queues(dev->dqm);
+	if (retval != 0) {
+		if (pqn->kq)
+			dev->dqm->destroy_kernel_queue(dev->dqm, pqn->kq, &pdd->qpd);
+		if (pqn->q)
+			dev->dqm->destroy_queue(dev->dqm, &pdd->qpd, pqn->q);
+
+		goto err_execute_runlist;
+	}
+
+	*properties = q->properties;
+	pr_debug("kfd: PQM done creating queue\n");
+	print_queue_properties(properties);
+
+	return retval;
+
+err_execute_runlist:
+	list_del(&pqn->process_queue_list);
+err_create_queue:
+	kfree(pqn);
+err_allocate_pqn:
+	clear_bit(*qid, pqm->queue_slot_bitmap);
+	return retval;
+}
+
+int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
+{
+	struct process_queue_node *pqn;
+	struct kfd_process_device *pdd;
+	struct device_queue_manager *dqm;
+	struct kfd_dev *dev;
+	int retval;
+
+	dqm = NULL;
+
+	BUG_ON(!pqm);
+	retval = 0;
+
+	pr_debug("kfd: In Func %s\n", __func__);
+
+	pqn = get_queue_by_qid(pqm, qid);
+	BUG_ON(!pqn);
+
+	dev = NULL;
+	if (pqn->kq)
+		dev = pqn->kq->dev;
+	if (pqn->q)
+		dev = pqn->q->device;
+	BUG_ON(!dev);
+
+	pdd = kfd_get_process_device_data(dev, pqm->process, 1);
+	BUG_ON(!pdd);
+
+	if (pqn->kq) {
+		/* destroy kernel queue (DIQ) */
+		dqm = pqn->kq->dev->dqm;
+		dqm->destroy_kernel_queue(dqm, pqn->kq, &pdd->qpd);
+		kernel_queue_uninit(pqn->kq);
+	}
+
+	if (pqn->q) {
+		dqm = pqn->q->device->dqm;
+		retval = dqm->destroy_queue(dqm, &pdd->qpd, pqn->q);
+		if (retval != 0)
+			return retval;
+
+		uninit_queue(pqn->q);
+	}
+
+	list_del(&pqn->process_queue_list);
+	kfree(pqn);
+	clear_bit(qid, pqm->queue_slot_bitmap);
+
+	if (list_empty(&pqm->queues))
+		dqm->unregister_process(dqm, &pdd->qpd);
+
+	retval = dqm->execute_queues(dqm);
+
+	return retval;
+}
+
+int pqm_update_queue(struct process_queue_manager *pqm, unsigned int qid, struct queue_properties *p)
+{
+	int retval;
+	struct process_queue_node *pqn;
+
+	BUG_ON(!pqm);
+
+	pqn = get_queue_by_qid(pqm, qid);
+	BUG_ON(!pqn);
+
+	pqn->q->properties.queue_address = p->queue_address;
+	pqn->q->properties.queue_size = p->queue_size;
+	pqn->q->properties.queue_percent = p->queue_percent;
+	pqn->q->properties.priority = p->priority;
+
+	retval = pqn->q->device->dqm->destroy_queues(pqn->q->device->dqm);
+	if (retval != 0)
+		return retval;
+
+	retval = pqn->q->device->dqm->update_queue(pqn->q->device->dqm, pqn->q);
+	if (retval != 0)
+		return retval;
+
+	retval = pqn->q->device->dqm->execute_queues(pqn->q->device->dqm);
+	if (retval != 0)
+		return retval;
+
+	return 0;
+}
+
+struct kernel_queue *pqm_get_kernel_queue(struct process_queue_manager *pqm, unsigned int qid)
+{
+	struct process_queue_node *pqn;
+
+	BUG_ON(!pqm);
+
+	pqn = get_queue_by_qid(pqm, qid);
+	if (pqn && pqn->kq)
+		return pqn->kq;
+
+	return NULL;
+}
+
+
-- 
1.9.1

