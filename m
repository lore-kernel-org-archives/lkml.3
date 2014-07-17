Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbaGQNtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:49:17 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:39111
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932660AbaGQNtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:49:13 -0400
X-WSS-ID: 0N8UYZK-08-700-02
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
Subject: [PATCH v2 18/25] amdkfd: Add process queue manager module
Date: Thu, 17 Jul 2014 16:29:25 +0300
Message-ID: <1405603773-32688-19-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(51234002)(189002)(95666004)(88136002)(77982001)(48376002)(62966002)(83322001)(97736001)(80022001)(76482001)(89996001)(87286001)(85306003)(85852003)(74502001)(36756003)(74662001)(77096002)(50226001)(4396001)(101416001)(93916002)(21056001)(20776003)(19580395003)(92566001)(92726001)(31966008)(46102001)(107046002)(79102001)(44976005)(229853001)(106466001)(68736004)(50466002)(81542001)(102836001)(84676001)(81342001)(19580405001)(99396002)(50986999)(105586002)(47776003)(76176999)(64706001)(104166001)(83072002)(33646002)(77156001)(86362001)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB035;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

The queue scheduler divides into two sections, one section is process bounded and the other section is device bounded.
The process bounded section is handled by this module. The PQM handles usermode queue setup, updates and tear-down.

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/Makefile             |   3 +-
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |  17 +
 drivers/gpu/drm/radeon/amdkfd/kfd_process.c        |  13 +
 .../drm/radeon/amdkfd/kfd_process_queue_manager.c  | 343 +++++++++++++++++++++
 4 files changed, 375 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c

diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
index 4083f28..eacef85 100644
--- a/drivers/gpu/drm/radeon/amdkfd/Makefile
+++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
@@ -7,6 +7,7 @@ ccflags-y := -Iinclude/drm
 amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_vidmem.o kfd_aperture.o \
 		kfd_process.o kfd_queue.o kfd_mqd_manager.o \
-		kfd_kernel_queue.o kfd_packet_manager.o
+		kfd_kernel_queue.o kfd_packet_manager.o \
+		kfd_process_queue_manager.o
 
 obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 63e492a..c444b38 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -277,6 +277,9 @@ struct kfd_process_device {
 	/* The user-mode address of the doorbell mapping for this device. */
 	doorbell_t __user *doorbell_mapping;
 
+	/* per-process-per device QCM data structure */
+	struct qcm_process_device qpd;
+
 	/* Is this process/pasid bound to this device? (amd_iommu_bind_pasid) */
 	bool bound;
 
@@ -312,6 +315,8 @@ struct kfd_process {
 	 */
 	struct list_head per_device_data;
 
+	struct process_queue_manager pqm;
+
 	/* The process's queues. */
 	size_t queue_array_size;
 
@@ -382,11 +387,23 @@ inline uint32_t upper_32(uint64_t x);
 
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
index 908b3b7..bcc004f 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
@@ -163,8 +163,16 @@ static struct kfd_process *create_process(const struct task_struct *thread)
 
 	INIT_LIST_HEAD(&process->per_device_data);
 
+	err = pqm_init(&process->pqm, process);
+	if (err != 0)
+		goto err_process_pqm_init;
+
 	return process;
 
+err_process_pqm_init:
+	kfd_pasid_free(process->pasid);
+	list_del(&process->processes_list);
+	thread->mm->kfd_process = NULL;
 err_alloc_pasid:
 	kfree(process->queues);
 err_alloc_queues:
@@ -185,6 +193,9 @@ struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
 	pdd = kzalloc(sizeof(*pdd), GFP_KERNEL);
 	if (pdd != NULL) {
 		pdd->dev = dev;
+		INIT_LIST_HEAD(&pdd->qpd.queues_list);
+		INIT_LIST_HEAD(&pdd->qpd.priv_queue_list);
+		pdd->qpd.dqm = dev->dqm;
 		list_add(&pdd->per_device_list, &p->per_device_data);
 	}
 
@@ -246,6 +257,8 @@ void kfd_unbind_process_from_device(struct kfd_dev *dev, pasid_t pasid)
 
 	mutex_lock(&p->mutex);
 
+	pqm_uninit(&p->pqm);
+
 	/*
 	 * Just mark pdd as unbound, because we still need it to call
 	 * amd_iommu_unbind_pasid() in when the process exits.
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
new file mode 100644
index 0000000..f54df3c
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
+	found = find_first_zero_bit(pqm->queue_slot_bitmap, MAX_PROCESS_QUEUES);
+
+	pr_debug("kfd: the new slot id %lu\n", found);
+
+	if (found >= MAX_PROCESS_QUEUES)
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
+	pqm->queue_slot_bitmap = kzalloc(DIV_ROUND_UP(MAX_PROCESS_QUEUES, BITS_PER_BYTE), GFP_KERNEL);
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
+}
+
+static int create_cp_queue(struct process_queue_manager *pqm, struct kfd_dev *dev, struct queue **q,
+		struct queue_properties *q_properties, struct file *f, unsigned int qid)
+{
+	int retval;
+
+	retval = 0;
+
+	q_properties->doorbell_ptr = kfd_get_doorbell(f, pqm->process, dev, qid);
+		if (!q_properties->doorbell_ptr)
+			return -ENOMEM;
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
+	pdd = kfd_get_process_device_data(dev, pqm->process);
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
+	pdd = kfd_get_process_device_data(dev, pqm->process);
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

