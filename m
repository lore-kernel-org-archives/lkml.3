Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaKHSof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:44:35 -0500
Received: from mail-bl2on0111.outbound.protection.outlook.com ([65.55.169.111]:31758
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754087AbaKHSoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:44:32 -0500
X-WSS-ID: 0NEQHE3-07-RGF-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>, Jay Cornwall <jay.cornwall@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        "Alexey Skidanov" <Alexey.Skidanov@amd.com>
Subject: [PATCH v5 17/24] amdkfd: Add process queue manager module
Date: Sat, 8 Nov 2014 20:37:38 +0200
Message-ID: <1415471865-1893-18-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(51234002)(64706001)(86362001)(33646002)(92566001)(36756003)(50226001)(77096003)(76176999)(50986999)(46102003)(87286001)(87936001)(50466002)(48376002)(31966008)(102836001)(47776003)(44976005)(19580395003)(89996001)(99396003)(120916001)(21056001)(105586002)(88136002)(107046002)(229853001)(106466001)(53416004)(97736003)(95666004)(4396001)(19580405001)(68736004)(62966003)(77156002)(101416001)(93916002)(92726001)(84676001)(104166001)(20776003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0201MB1002;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0201MB1002;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0201MB1002;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0201MB1002;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

The queue scheduler divides into two sections, one section is process bounded
and the other section is device bounded.
The process bounded section is handled by this module. The PQM handles usermode
queue setup, updates and tear-down.

v3:

Used kernel parameter to limit queues per process instead of define
Added use of doorbell address from user

v4:

Modified pqm_create_queue so that only when creating usermode queues the
driver should return the queue properties to the userspace.

Added an info message print when no more queues can be opened because of the
queue per process limitation

v5:

Move amdkfd from drm/radeon/ to drm/amd/
Various fixes

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/Makefile                |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  26 ++
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  20 ++
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 342 +++++++++++++++++++++
 4 files changed, 390 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c

diff --git a/drivers/gpu/drm/amd/amdkfd/Makefile b/drivers/gpu/drm/amd/amdkfd/Makefile
index 1164a3a..104f279 100644
--- a/drivers/gpu/drm/amd/amdkfd/Makefile
+++ b/drivers/gpu/drm/amd/amdkfd/Makefile
@@ -7,6 +7,7 @@ ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/amd/include/
 amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_flat_memory.o \
 		kfd_process.o kfd_queue.o kfd_mqd_manager.o \
-		kfd_kernel_queue.o kfd_packet_manager.o
+		kfd_kernel_queue.o kfd_packet_manager.o \
+		kfd_process_queue_manager.o
 
 obj-$(CONFIG_HSA_AMD)	+= amdkfd.o
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 219c85a..72b2e27 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -387,6 +387,9 @@ struct kfd_process_device {
 	struct kfd_dev *dev;
 
 
+	/* per-process-per device QCM data structure */
+	struct qcm_process_device qpd;
+
 	/*Apertures*/
 	uint64_t lds_base;
 	uint64_t lds_limit;
@@ -432,6 +435,8 @@ struct kfd_process {
 	 */
 	struct list_head per_device_data;
 
+	struct process_queue_manager pqm;
+
 	/* The process's queues. */
 	size_t queue_array_size;
 
@@ -501,12 +506,33 @@ inline uint32_t upper_32(uint64_t x);
 
 int init_queue(struct queue **q, struct queue_properties properties);
 void uninit_queue(struct queue *q);
+void print_queue_properties(struct queue_properties *q);
 void print_queue(struct queue *q);
 
 struct kernel_queue *kernel_queue_init(struct kfd_dev *dev,
 					enum kfd_queue_type type);
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
+int pqm_create_queue(struct process_queue_manager *pqm,
+			    struct kfd_dev *dev,
+			    struct file *f,
+			    struct queue_properties *properties,
+			    unsigned int flags,
+			    enum kfd_queue_type type,
+			    unsigned int *qid);
+int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid);
+int pqm_update_queue(struct process_queue_manager *pqm, unsigned int qid,
+			struct queue_properties *p);
+
 /* Packet Manager */
 
 #define KFD_HIQ_TIMEOUT (500)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 5084794..a17e2dd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -222,6 +222,13 @@ static void kfd_process_notifier_release(struct mmu_notifier *mn,
 	mutex_unlock(&kfd_processes_mutex);
 	synchronize_srcu(&kfd_processes_srcu);
 
+	mutex_lock(&p->mutex);
+
+	/* In case our notifier is called before IOMMU notifier */
+	pqm_uninit(&p->pqm);
+
+	mutex_unlock(&p->mutex);
+
 	/*
 	 * Because we drop mm_count inside kfd_process_destroy_delayed
 	 * and because the mmu_notifier_unregister function also drop
@@ -274,8 +281,16 @@ static struct kfd_process *create_process(const struct task_struct *thread)
 
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
@@ -300,6 +315,9 @@ struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
 		pdd = kzalloc(sizeof(*pdd), GFP_KERNEL);
 		if (pdd != NULL) {
 			pdd->dev = dev;
+			INIT_LIST_HEAD(&pdd->qpd.queues_list);
+			INIT_LIST_HEAD(&pdd->qpd.priv_queue_list);
+			pdd->qpd.dqm = dev->dqm;
 			list_add(&pdd->per_device_list, &p->per_device_data);
 		}
 	}
@@ -360,6 +378,8 @@ void kfd_unbind_process_from_device(struct kfd_dev *dev, unsigned int pasid)
 
 	mutex_lock(&p->mutex);
 
+	pqm_uninit(&p->pqm);
+
 	pdd = kfd_get_process_device_data(dev, p, 0);
 
 	/*
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
new file mode 100644
index 0000000..c7859fc
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -0,0 +1,342 @@
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
+static inline struct process_queue_node *get_queue_by_qid(
+			struct process_queue_manager *pqm, unsigned int qid)
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
+static int find_available_queue_slot(struct process_queue_manager *pqm,
+					unsigned int *qid)
+{
+	unsigned long found;
+
+	BUG_ON(!pqm || !qid);
+
+	pr_debug("kfd: in %s\n", __func__);
+
+	found = find_first_zero_bit(pqm->queue_slot_bitmap,
+			max_num_of_queues_per_process);
+
+	pr_debug("kfd: the new slot id %lu\n", found);
+
+	if (found >= max_num_of_queues_per_process) {
+		pr_info("amdkfd: Can not open more queues for process with pasid %d\n",
+				pqm->process->pasid);
+		return -ENOMEM;
+	}
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
+	pqm->queue_slot_bitmap =
+			kzalloc(DIV_ROUND_UP(max_num_of_queues_per_process,
+					BITS_PER_BYTE), GFP_KERNEL);
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
+static int create_cp_queue(struct process_queue_manager *pqm,
+				struct kfd_dev *dev, struct queue **q,
+				struct queue_properties *q_properties,
+				struct file *f, unsigned int qid)
+{
+	int retval;
+
+	retval = 0;
+
+	/* Doorbell initialized in user space*/
+	q_properties->doorbell_ptr = NULL;
+
+	q_properties->doorbell_off =
+			kfd_queue_id_to_doorbell(dev, pqm->process, qid);
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
+	q = NULL;
+	kq = NULL;
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
+		retval = dev->dqm->create_queue(dev->dqm, q, &pdd->qpd,
+						&q->properties.vmid);
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
+	if (q) {
+		*properties = q->properties;
+		pr_debug("kfd: PQM done creating queue\n");
+		print_queue_properties(properties);
+	}
+
+	return retval;
+
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
+	if (pqn == NULL) {
+		pr_err("kfd: queue id does not match any known queue\n");
+		return -EINVAL;
+	}
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
+	return retval;
+}
+
+int pqm_update_queue(struct process_queue_manager *pqm, unsigned int qid,
+			struct queue_properties *p)
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
+	retval = pqn->q->device->dqm->update_queue(pqn->q->device->dqm, pqn->q);
+	if (retval != 0)
+		return retval;
+
+	return 0;
+}
+
+struct kernel_queue *pqm_get_kernel_queue(struct process_queue_manager *pqm,
+					unsigned int qid)
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
2.1.0

