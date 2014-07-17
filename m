Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbaGQNdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:33:15 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:48323
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932950AbaGQNdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:33:06 -0400
X-WSS-ID: 0N8UYZ0-07-C26-02
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
Subject: [PATCH v2 15/25] amdkfd: Add kernel queue module
Date: Thu, 17 Jul 2014 16:29:22 +0300
Message-ID: <1405603773-32688-16-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51234002)(199002)(189002)(44976005)(31966008)(85306003)(48376002)(64706001)(95666004)(81542001)(68736004)(77156001)(99396002)(47776003)(20776003)(92566001)(101416001)(77096002)(80022001)(36756003)(77982001)(50466002)(105586002)(4396001)(85852003)(92726001)(89996001)(74502001)(81342001)(76482001)(97736001)(19580395003)(74662001)(83322001)(19580405001)(104166001)(106466001)(87936001)(87286001)(229853001)(76176999)(21056001)(50986999)(83072002)(107046002)(50226001)(84676001)(33646002)(62966002)(46102001)(86362001)(102836001)(79102001)(93916002)(88136002)(579004)(473944003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

The kernel queue module enables the amdkfd to establish kernel queues, not exposed to user space.

The kernel queues are used for HIQ (HSA Interface Queue) and DIQ (Debug Interface Queue) operations

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/Makefile             |   3 +-
 .../drm/radeon/amdkfd/kfd_device_queue_manager.h   | 101 +++
 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c   | 305 +++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h   |  66 ++
 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h    | 682 +++++++++++++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h    | 107 ++++
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |  32 +
 7 files changed, 1295 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.h
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h

diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
index b5201f4..bead1be 100644
--- a/drivers/gpu/drm/radeon/amdkfd/Makefile
+++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
@@ -6,6 +6,7 @@ ccflags-y := -Iinclude/drm
 
 amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_vidmem.o kfd_aperture.o \
-		kfd_process.o kfd_queue.o kfd_mqd_manager.o
+		kfd_process.o kfd_queue.o kfd_mqd_manager.o \
+		kfd_kernel_queue.o
 
 obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.h b/drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.h
new file mode 100644
index 0000000..037eaf8
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.h
@@ -0,0 +1,101 @@
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
+#ifndef KFD_DEVICE_QUEUE_MANAGER_H_
+#define KFD_DEVICE_QUEUE_MANAGER_H_
+
+#include <linux/rwsem.h>
+#include <linux/list.h>
+#include "kfd_priv.h"
+#include "kfd_mqd_manager.h"
+
+#define QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS	(500)
+#define QUEUES_PER_PIPE				(8)
+#define PIPE_PER_ME_CP_SCHEDULING		(3)
+#define CIK_VMID_NUM				(8)
+#define KFD_VMID_START_OFFSET			(8)
+#define VMID_PER_DEVICE				CIK_VMID_NUM
+#define KFD_DQM_FIRST_PIPE			(0)
+
+struct device_process_node {
+	struct qcm_process_device *qpd;
+	struct list_head list;
+};
+
+struct device_queue_manager {
+	int	(*create_queue)(struct device_queue_manager *dqm,
+				struct queue *q,
+				struct qcm_process_device *qpd,
+				int *allocate_vmid);
+	int	(*destroy_queue)(struct device_queue_manager *dqm,
+				struct qcm_process_device *qpd,
+				struct queue *q);
+	int	(*update_queue)(struct device_queue_manager *dqm,
+				struct queue *q);
+	int	(*destroy_queues)(struct device_queue_manager *dqm);
+	struct mqd_manager * (*get_mqd_manager)(struct device_queue_manager *dqm,
+						enum KFD_MQD_TYPE type);
+	int	(*execute_queues)(struct device_queue_manager *dqm);
+	int	(*register_process)(struct device_queue_manager *dqm,
+					struct qcm_process_device *qpd);
+	int	(*unregister_process)(struct device_queue_manager *dqm,
+					struct qcm_process_device *qpd);
+	int	(*initialize)(struct device_queue_manager *dqm);
+	int	(*start)(struct device_queue_manager *dqm);
+	int	(*stop)(struct device_queue_manager *dqm);
+	void	(*uninitialize)(struct device_queue_manager *dqm);
+	int	(*create_kernel_queue)(struct device_queue_manager *dqm,
+					struct kernel_queue *kq,
+					struct qcm_process_device *qpd);
+	void	(*destroy_kernel_queue)(struct device_queue_manager *dqm,
+					struct kernel_queue *kq,
+					struct qcm_process_device *qpd);
+	bool	(*set_cache_memory_policy)(struct device_queue_manager *dqm,
+					   struct qcm_process_device *qpd,
+					   enum cache_policy default_policy,
+					   enum cache_policy alternate_policy,
+					   void __user *alternate_aperture_base,
+					   uint64_t alternate_aperture_size);
+
+
+	struct mqd_manager	*mqds[KFD_MQD_TYPE_MAX];
+	struct packet_manager	packets;
+	struct kfd_dev		*dev;
+	struct mutex		lock;
+	struct list_head	queues;
+	unsigned int		processes_count;
+	unsigned int		queue_count;
+	unsigned int		next_pipe_to_allocate;
+	unsigned int		*allocated_queues;
+	unsigned int		vmid_bitmap;
+	uint64_t		pipelines_addr;
+	kfd_mem_obj		pipeline_mem;
+	uint64_t		fence_gpu_addr;
+	unsigned int		*fence_addr;
+	kfd_mem_obj		fence_mem;
+	bool			active_runlist;
+};
+
+
+
+#endif /* KFD_DEVICE_QUEUE_MANAGER_H_ */
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c b/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c
new file mode 100644
index 0000000..b212524
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c
@@ -0,0 +1,305 @@
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
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/printk.h>
+#include "kfd_kernel_queue.h"
+#include "kfd_priv.h"
+#include "kfd_device_queue_manager.h"
+#include "kfd_pm4_headers.h"
+#include "kfd_pm4_opcodes.h"
+
+#define PM4_COUNT_ZERO (((1 << 15) - 1) << 16)
+
+static bool initialize(struct kernel_queue *kq, struct kfd_dev *dev,
+		enum kfd_queue_type type, unsigned int queue_size)
+{
+	struct queue_properties prop;
+	int retval;
+	union PM4_TYPE_3_HEADER nop;
+
+	BUG_ON(!kq || !dev);
+	BUG_ON(type != KFD_QUEUE_TYPE_DIQ && type != KFD_QUEUE_TYPE_HIQ);
+
+	pr_debug("kfd: In func %s initializing queue type %d size %d\n", __func__, KFD_QUEUE_TYPE_HIQ, queue_size);
+
+	nop.opcode = IT_NOP;
+	nop.type = PM4_TYPE_3;
+	nop.u32all |= PM4_COUNT_ZERO;
+
+	kq->dev = dev;
+	kq->nop_packet = nop.u32all;
+	switch (type) {
+	case KFD_QUEUE_TYPE_DIQ:
+	case KFD_QUEUE_TYPE_HIQ:
+		kq->mqd = dev->dqm->get_mqd_manager(dev->dqm, KFD_MQD_TYPE_CIK_HIQ);
+		break;
+	default:
+		BUG();
+		break;
+	}
+
+	if (kq->mqd == NULL)
+		return false;
+
+	prop.doorbell_ptr = (qptr_t *)kfd_get_kernel_doorbell(dev, &prop.doorbell_off);
+	if (prop.doorbell_ptr == NULL)
+		goto err_get_kernel_doorbell;
+
+	retval = kfd_vidmem_alloc_map(dev, &kq->pq, (void **)&kq->pq_kernel_addr, &kq->pq_gpu_addr, queue_size);
+	if (retval != 0)
+		goto err_pq_allocate_vidmem;
+
+	retval = kfd_vidmem_alloc_map(kq->dev, &kq->rptr_mem, (void **)&kq->rptr_kernel, &kq->rptr_gpu_addr,
+					     sizeof(*kq->rptr_kernel));
+	if (retval != 0)
+		goto err_rptr_allocate_vidmem;
+
+	retval = kfd_vidmem_alloc_map(kq->dev, &kq->wptr_mem, (void **)&kq->wptr_kernel, &kq->wptr_gpu_addr,
+					     sizeof(*kq->rptr_kernel));
+	if (retval != 0)
+		goto err_wptr_allocate_vidmem;
+
+	prop.queue_size = queue_size;
+	prop.is_interop = false;
+	prop.priority = 1;
+	prop.queue_percent = 100;
+	prop.type = type;
+	prop.vmid = 0;
+	prop.queue_address = kq->pq_gpu_addr;
+	prop.read_ptr = (qptr_t *) kq->rptr_gpu_addr;
+	prop.write_ptr = (qptr_t *) kq->wptr_gpu_addr;
+
+	if (init_queue(&kq->queue, prop) != 0)
+		goto err_init_queue;
+
+	kq->queue->device = dev;
+	kq->queue->process = kfd_get_process(current);
+
+	retval = kq->mqd->init_mqd(kq->mqd, &kq->queue->mqd, &kq->queue->mqd_mem_obj,
+				   &kq->queue->gart_mqd_addr, &kq->queue->properties);
+	if (retval != 0)
+		goto err_init_mqd;
+
+	/* assign HIQ to HQD */
+	if (type == KFD_QUEUE_TYPE_HIQ) {
+		pr_debug("assigning hiq to hqd\n");
+		kq->queue->pipe = KFD_CIK_HIQ_PIPE;
+		kq->queue->queue = KFD_CIK_HIQ_QUEUE;
+		kq->mqd->load_mqd(kq->mqd, kq->queue->mqd, kq->queue->pipe, kq->queue->queue, NULL);
+	} else {
+		/* allocate fence for DIQ */
+		retval = kfd_vidmem_alloc_map(
+				dev,
+				&kq->fence_mem_obj,
+				&kq->fence_kernel_address,
+				&kq->fence_gpu_addr,
+				sizeof(uint32_t));
+
+		if (retval != 0)
+			goto err_alloc_fence;
+	}
+
+	print_queue(kq->queue);
+
+	return true;
+err_alloc_fence:
+err_init_mqd:
+	uninit_queue(kq->queue);
+err_init_queue:
+	kfd_vidmem_free_unmap(kq->dev, kq->wptr_mem);
+err_wptr_allocate_vidmem:
+	kfd_vidmem_free_unmap(kq->dev, kq->rptr_mem);
+err_rptr_allocate_vidmem:
+	kfd_vidmem_free_unmap(kq->dev, kq->pq);
+err_pq_allocate_vidmem:
+	pr_err("kfd: error init pq\n");
+	kfd_release_kernel_doorbell(dev, (u32 *)prop.doorbell_ptr);
+err_get_kernel_doorbell:
+	pr_err("kfd: error init doorbell");
+	return false;
+
+}
+
+static void uninitialize(struct kernel_queue *kq)
+{
+	BUG_ON(!kq);
+
+	if (kq->queue->properties.type == KFD_QUEUE_TYPE_HIQ)
+		kq->mqd->destroy_mqd(kq->mqd,
+					false,
+					QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS,
+					kq->queue->pipe,
+					kq->queue->queue);
+
+	kfd_vidmem_free_unmap(kq->dev, kq->rptr_mem);
+	kfd_vidmem_free_unmap(kq->dev, kq->wptr_mem);
+	kfd_vidmem_free_unmap(kq->dev, kq->pq);
+	kfd_release_kernel_doorbell(kq->dev, (u32 *)kq->queue->properties.doorbell_ptr);
+	uninit_queue(kq->queue);
+}
+
+static int acquire_packet_buffer(struct kernel_queue *kq,
+		size_t packet_size_in_dwords, unsigned int **buffer_ptr)
+{
+	size_t available_size;
+	size_t queue_size_dwords;
+	qptr_t wptr, rptr;
+	unsigned int *queue_address;
+
+	BUG_ON(!kq || !buffer_ptr);
+
+	rptr = *kq->rptr_kernel;
+	wptr = *kq->wptr_kernel;
+	queue_address = (unsigned int *)kq->pq_kernel_addr;
+	queue_size_dwords = kq->queue->properties.queue_size / sizeof(uint32_t);
+
+	pr_debug("kfd: In func %s\nrptr: %d\nwptr: %d\nqueue_address 0x%p\n", __func__, rptr, wptr, queue_address);
+
+	available_size = (rptr - 1 - wptr + queue_size_dwords) % queue_size_dwords;
+
+	if (packet_size_in_dwords >= queue_size_dwords ||
+			packet_size_in_dwords >= available_size)
+		return -ENOMEM;
+
+	if (wptr + packet_size_in_dwords > queue_size_dwords) {
+		while (wptr > 0) {
+			queue_address[wptr] = kq->nop_packet;
+			wptr = (wptr + 1) % queue_size_dwords;
+		}
+	}
+
+	*buffer_ptr = &queue_address[wptr];
+	kq->pending_wptr = wptr + packet_size_in_dwords;
+
+	return 0;
+}
+
+static void submit_packet(struct kernel_queue *kq)
+{
+#ifdef DEBUG
+	int i;
+#endif
+
+	BUG_ON(!kq);
+
+#ifdef DEBUG
+	for (i = *kq->wptr_kernel; i < kq->pending_wptr; i++) {
+		pr_debug("0x%2X ", kq->pq_kernel_addr[i]);
+		if (i % 15 == 0)
+			pr_debug("\n");
+	}
+	pr_debug("\n");
+#endif
+
+	*kq->wptr_kernel = kq->pending_wptr;
+	write_kernel_doorbell((u32 *)kq->queue->properties.doorbell_ptr, kq->pending_wptr);
+}
+
+static int sync_with_hw(struct kernel_queue *kq, unsigned long timeout_ms)
+{
+	unsigned long org_timeout_ms;
+
+	BUG_ON(!kq);
+
+	org_timeout_ms = timeout_ms;
+	timeout_ms += jiffies * 1000 / HZ;
+	while (*kq->wptr_kernel != *kq->rptr_kernel) {
+		if (time_after(jiffies * 1000 / HZ, timeout_ms)) {
+			pr_err("kfd: kernel_queue %s timeout expired %lu\n",
+				__func__, org_timeout_ms);
+			pr_err("kfd: wptr: %d rptr: %d\n",
+				*kq->wptr_kernel, *kq->rptr_kernel);
+			return -ETIME;
+		}
+		cpu_relax();
+	}
+
+	return 0;
+}
+
+static void rollback_packet(struct kernel_queue *kq)
+{
+	BUG_ON(!kq);
+	kq->pending_wptr = *kq->queue->properties.write_ptr;
+}
+
+struct kernel_queue *kernel_queue_init(struct kfd_dev *dev, enum kfd_queue_type type)
+{
+	struct kernel_queue *kq;
+
+	BUG_ON(!dev);
+
+	kq = kzalloc(sizeof(struct kernel_queue), GFP_KERNEL);
+	if (!kq)
+		return NULL;
+
+	kq->initialize = initialize;
+	kq->uninitialize = uninitialize;
+	kq->acquire_packet_buffer = acquire_packet_buffer;
+	kq->submit_packet = submit_packet;
+	kq->sync_with_hw = sync_with_hw;
+	kq->rollback_packet = rollback_packet;
+
+	if (kq->initialize(kq, dev, type, 2048) == false) {
+		pr_err("kfd: failed to init kernel queue\n");
+		kfree(kq);
+		return NULL;
+	}
+	return kq;
+}
+
+void kernel_queue_uninit(struct kernel_queue *kq)
+{
+	BUG_ON(!kq);
+
+	kq->uninitialize(kq);
+	kfree(kq);
+}
+
+void test_kq(struct kfd_dev *dev)
+{
+	struct kernel_queue *kq;
+	uint32_t *buffer, i;
+	int retval;
+
+	BUG_ON(!dev);
+
+	pr_debug("kfd: starting kernel queue test\n");
+
+	kq = kernel_queue_init(dev, KFD_QUEUE_TYPE_HIQ);
+	BUG_ON(!kq);
+
+	retval = kq->acquire_packet_buffer(kq, 5, &buffer);
+	BUG_ON(retval != 0);
+	for (i = 0; i < 5; i++)
+		buffer[i] = kq->nop_packet;
+	kq->submit_packet(kq);
+	kq->sync_with_hw(kq, 1000);
+
+	pr_debug("kfd: ending kernel queue test\n");
+}
+
+
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h b/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h
new file mode 100644
index 0000000..abfb9c8
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h
@@ -0,0 +1,66 @@
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
+#ifndef KFD_KERNEL_QUEUE_H_
+#define KFD_KERNEL_QUEUE_H_
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include "kfd_priv.h"
+
+struct kernel_queue {
+	/* interface */
+	bool	(*initialize)(struct kernel_queue *kq, struct kfd_dev *dev,
+			enum kfd_queue_type type, unsigned int queue_size);
+	void	(*uninitialize)(struct kernel_queue *kq);
+	int	(*acquire_packet_buffer)(struct kernel_queue *kq,
+			size_t packet_size_in_dwords, unsigned int **buffer_ptr);
+	void	(*submit_packet)(struct kernel_queue *kq);
+	int	(*sync_with_hw)(struct kernel_queue *kq, unsigned long timeout_ms);
+	void	(*rollback_packet)(struct kernel_queue *kq);
+
+	/* data */
+	struct kfd_dev		*dev;
+	struct mqd_manager	*mqd;
+	struct queue		*queue;
+	qptr_t			pending_wptr;
+	unsigned int		nop_packet;
+
+	kfd_mem_obj		rptr_mem;
+	qptr_t			*rptr_kernel;
+	uint64_t		rptr_gpu_addr;
+	kfd_mem_obj		wptr_mem;
+	qptr_t			*wptr_kernel;
+	uint64_t		wptr_gpu_addr;
+	kfd_mem_obj		pq;
+	uint64_t		pq_gpu_addr;
+	qptr_t			*pq_kernel_addr;
+
+	kfd_mem_obj		fence_mem_obj;
+	uint64_t		fence_gpu_addr;
+	void			*fence_kernel_address;
+
+	struct list_head	list;
+};
+
+#endif /* KFD_KERNEL_QUEUE_H_ */
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h b/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h
new file mode 100644
index 0000000..95e46f8
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h
@@ -0,0 +1,682 @@
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
+#ifndef KFD_PM4_HEADERS_H_
+#define KFD_PM4_HEADERS_H_
+
+#ifndef PM4_HEADER_DEFINED
+#define PM4_HEADER_DEFINED
+
+union PM4_TYPE_3_HEADER {
+	struct {
+		unsigned int predicate:1;	/* < 0 for diq packets */
+		unsigned int shader_type:1;	/* < 0 for diq packets */
+		unsigned int reserved1:6;	/* < reserved */
+		unsigned int opcode:8;		/* < IT opcode */
+		unsigned int count:14;		/* < number of DWORDs - 1 in the information body. */
+		unsigned int type:2;		/* < packet identifier. It should be 3 for type 3 packets */
+	};
+	unsigned int u32all;
+};
+#endif
+
+/*
+ * --------------------_MAP_QUEUES--------------------
+ */
+
+#ifndef _PM4__MAP_QUEUES_DEFINED
+#define _PM4__MAP_QUEUES_DEFINED
+enum _map_queues_queue_sel_enum {
+	queue_sel___map_queues__map_to_specified_queue_slots = 0,
+	queue_sel___map_queues__map_to_hws_determined_queue_slots = 1,
+	queue_sel___map_queues__enable_process_queues = 2,
+	queue_sel___map_queues__reserved = 3 };
+
+enum _map_queues_vidmem_enum {
+	vidmem___map_queues__uses_no_video_memory = 0,
+	vidmem___map_queues__uses_video_memory = 1 };
+
+enum _map_queues_alloc_format_enum {
+	alloc_format___map_queues__one_per_pipe = 0,
+	alloc_format___map_queues__all_on_one_pipe = 1 };
+
+enum _map_queues_engine_sel_enum {
+	engine_sel___map_queues__compute = 0,
+	engine_sel___map_queues__sdma0_queue = 2,
+	engine_sel___map_queues__sdma1_queue = 3 };
+
+struct pm4_map_queues {
+	union {
+		union PM4_TYPE_3_HEADER header;
+		unsigned int ordinal1;
+	};
+
+	union {
+		struct {
+			unsigned int reserved1:4;
+			enum _map_queues_queue_sel_enum queue_sel:2;
+			unsigned int reserved2:2;
+			unsigned int vmid:4;
+			unsigned int reserved3:4;
+			enum _map_queues_vidmem_enum vidmem:2;
+			unsigned int reserved4:6;
+			enum _map_queues_alloc_format_enum alloc_format:2;
+			enum _map_queues_engine_sel_enum engine_sel:3;
+			unsigned int num_queues:3;
+		} bitfields2;
+		unsigned int ordinal2;
+	};
+
+	struct {
+		union {
+			struct {
+				unsigned int reserved5:2;
+				unsigned int doorbell_offset:21;
+				unsigned int reserved6:3;
+				unsigned int queue:6;
+			} bitfields3;
+			unsigned int ordinal3;
+		};
+
+		unsigned int mqd_addr_lo;
+		unsigned int mqd_addr_hi;
+		unsigned int wptr_addr_lo;
+		unsigned int wptr_addr_hi;
+
+	} _map_queues_ordinals[1];	/* 1..N of these ordinal groups */
+
+};
+#endif
+
+/*
+ * --------------------_QUERY_STATUS--------------------
+ */
+
+#ifndef _PM4__QUERY_STATUS_DEFINED
+#define _PM4__QUERY_STATUS_DEFINED
+enum _query_status_interrupt_sel_enum {
+	interrupt_sel___query_status__completion_status = 0,
+	interrupt_sel___query_status__process_status = 1,
+	interrupt_sel___query_status__queue_status = 2,
+	interrupt_sel___query_status__reserved = 3 };
+
+enum _query_status_command_enum {
+	command___query_status__interrupt_only = 0,
+	command___query_status__fence_only_immediate = 1,
+	command___query_status__fence_only_after_write_ack = 2,
+	command___query_status__fence_wait_for_write_ack_send_interrupt = 3 };
+
+enum _query_status_engine_sel_enum {
+	engine_sel___query_status__compute = 0,
+	engine_sel___query_status__sdma0 = 2,
+	engine_sel___query_status__sdma1 = 3 };
+
+struct pm4_query_status {
+	union {
+		union PM4_TYPE_3_HEADER header;
+		unsigned int ordinal1;
+	};
+
+	union {
+		struct {
+			unsigned int context_id:28;
+			enum _query_status_interrupt_sel_enum interrupt_sel:2;
+			enum _query_status_command_enum command:2;
+		} bitfields2;
+		unsigned int ordinal2;
+	};
+
+	union {
+		struct {
+			unsigned int pasid:16;
+			unsigned int reserved1:16;
+		} bitfields3;
+		struct {
+			unsigned int reserved2:2;
+			unsigned int doorbell_offset:21;
+			unsigned int reserved3:3;
+			enum _query_status_engine_sel_enum engine_sel:3;
+			unsigned int reserved4:3;
+		} bitfields4;
+		unsigned int ordinal3;
+	};
+
+	unsigned int addr_lo;
+	unsigned int addr_hi;
+	unsigned int data_lo;
+	unsigned int data_hi;
+
+};
+#endif
+
+/*
+ * --------------------_UNMAP_QUEUES--------------------
+ */
+
+#ifndef _PM4__UNMAP_QUEUES_DEFINED
+#define _PM4__UNMAP_QUEUES_DEFINED
+enum _unmap_queues_action_enum {
+	action___unmap_queues__preempt_queues = 0,
+	action___unmap_queues__reset_queues = 1,
+	action___unmap_queues__disable_process_queues = 2,
+	action___unmap_queues__reserved = 3 };
+
+enum _unmap_queues_queue_sel_enum {
+	queue_sel___unmap_queues__perform_request_on_specified_queues = 0,
+	queue_sel___unmap_queues__perform_request_on_pasid_queues = 1,
+	queue_sel___unmap_queues__perform_request_on_all_active_queues = 2,
+	queue_sel___unmap_queues__reserved = 3 };
+
+enum _unmap_queues_engine_sel_enum {
+	engine_sel___unmap_queues__compute = 0,
+	engine_sel___unmap_queues__sdma0 = 2,
+	engine_sel___unmap_queues__sdma1 = 3 };
+
+struct pm4_unmap_queues {
+	union {
+		union PM4_TYPE_3_HEADER header;
+		unsigned int ordinal1;
+	};
+
+	union {
+		struct {
+			enum _unmap_queues_action_enum action:2;
+			unsigned int reserved1:2;
+			enum _unmap_queues_queue_sel_enum queue_sel:2;
+			unsigned int reserved2:20;
+			enum _unmap_queues_engine_sel_enum engine_sel:3;
+			unsigned int num_queues:3;
+		} bitfields2;
+		unsigned int ordinal2;
+	};
+
+	union {
+		struct {
+			unsigned int pasid:16;
+			unsigned int reserved3:16;
+		} bitfields3;
+		struct {
+			unsigned int reserved4:2;
+			unsigned int doorbell_offset0:21;
+			unsigned int reserved5:9;
+		} bitfields4;
+		unsigned int ordinal3;
+	};
+
+	union {
+		struct {
+			unsigned int reserved6:2;
+			unsigned int doorbell_offset1:21;
+			unsigned int reserved7:9;
+		} bitfields5;
+		unsigned int ordinal4;
+	};
+
+	union {
+		struct {
+			unsigned int reserved8:2;
+			unsigned int doorbell_offset2:21;
+			unsigned int reserved9:9;
+		} bitfields6;
+		unsigned int ordinal5;
+	};
+
+	union {
+		struct {
+			unsigned int reserved10:2;
+			unsigned int doorbell_offset3:21;
+			unsigned int reserved11:9;
+		} bitfields7;
+		unsigned int ordinal6;
+	};
+
+};
+#endif
+
+/*
+ * --------------------_SET_RESOURCES--------------------
+ */
+
+#ifndef _PM4__SET_RESOURCES_DEFINED
+#define _PM4__SET_RESOURCES_DEFINED
+enum _set_resources_queue_type_enum {
+	queue_type___set_resources__hsa_interface_queue_hiq = 1,
+	queue_type___set_resources__hsa_debug_interface_queue = 4 };
+
+struct pm4_set_resources {
+	union {
+		union PM4_TYPE_3_HEADER header;
+		unsigned int ordinal1;
+	};
+
+	union {
+		struct {
+
+			unsigned int vmid_mask:16;
+			unsigned int unmap_latency:8;
+			unsigned int reserved1:5;
+			enum _set_resources_queue_type_enum queue_type:3;
+		} bitfields2;
+		unsigned int ordinal2;
+	};
+
+	unsigned int queue_mask_lo;
+	unsigned int queue_mask_hi;
+	unsigned int gws_mask_lo;
+	unsigned int gws_mask_hi;
+
+	union {
+		struct {
+			unsigned int oac_mask:16;
+			unsigned int reserved2:16;
+		} bitfields3;
+		unsigned int ordinal7;
+	};
+
+	union {
+		struct {
+			unsigned int gds_heap_base:6;
+			unsigned int reserved3:5;
+			unsigned int gds_heap_size:6;
+			unsigned int reserved4:15;
+		} bitfields4;
+		unsigned int ordinal8;
+	};
+
+};
+#endif
+
+/*
+ * --------------------_RUN_LIST--------------------
+ */
+
+#ifndef _PM4__RUN_LIST_DEFINED
+#define _PM4__RUN_LIST_DEFINED
+
+struct pm4_runlist {
+	union {
+		union PM4_TYPE_3_HEADER header;
+		unsigned int ordinal1;
+	};
+
+	union {
+		struct {
+			unsigned int reserved1:2;
+			unsigned int ib_base_lo:30;
+		} bitfields2;
+		unsigned int ordinal2;
+	};
+
+	union {
+		struct {
+			unsigned int ib_base_hi:16;
+			unsigned int reserved2:16;
+		} bitfields3;
+		unsigned int ordinal3;
+	};
+
+	union {
+		struct {
+			unsigned int ib_size:20;
+			unsigned int chain:1;
+			unsigned int offload_polling:1;
+			unsigned int reserved3:1;
+			unsigned int valid:1;
+			unsigned int vmid:4;
+			unsigned int reserved4:4;
+		} bitfields4;
+		unsigned int ordinal4;
+	};
+
+};
+#endif
+
+/*
+ * --------------------_MAP_PROCESS--------------------
+ */
+
+#ifndef _PM4__MAP_PROCESS_DEFINED
+#define _PM4__MAP_PROCESS_DEFINED
+
+struct pm4_map_process {
+	union {
+		union PM4_TYPE_3_HEADER header;
+		unsigned int ordinal1;
+	};
+
+	union {
+		struct {
+			unsigned int pasid:16;
+			unsigned int reserved1:8;
+			unsigned int diq_enable:1;
+			unsigned int reserved2:7;
+		} bitfields2;
+		unsigned int ordinal2;
+	};
+
+	union {
+		struct {
+			unsigned int page_table_base:28;
+			unsigned int reserved3:4;
+		} bitfields3;
+		unsigned int ordinal3;
+	};
+
+	unsigned int sh_mem_bases;
+	unsigned int sh_mem_ape1_base;
+	unsigned int sh_mem_ape1_limit;
+	unsigned int sh_mem_config;
+	unsigned int gds_addr_lo;
+	unsigned int gds_addr_hi;
+
+	union {
+		struct {
+			unsigned int num_gws:6;
+			unsigned int reserved4:2;
+			unsigned int num_oac:4;
+			unsigned int reserved5:4;
+			unsigned int gds_size:6;
+			unsigned int reserved6:10;
+		} bitfields4;
+		unsigned int ordinal10;
+	};
+
+};
+#endif
+
+/*--------------------_MAP_QUEUES--------------------*/
+
+#ifndef _PM4__MAP_QUEUES_DEFINED
+#define _PM4__MAP_QUEUES_DEFINED
+enum _MAP_QUEUES_queue_sel_enum {
+	 queue_sel___map_queues__map_to_specified_queue_slots = 0,
+	 queue_sel___map_queues__map_to_hws_determined_queue_slots = 1,
+	 queue_sel___map_queues__enable_process_queues = 2,
+	 queue_sel___map_queues__reserved = 3 };
+
+enum _MAP_QUEUES_vidmem_enum {
+	 vidmem___map_queues__uses_no_video_memory = 0,
+	 vidmem___map_queues__uses_video_memory = 1 };
+
+enum _MAP_QUEUES_alloc_format_enum {
+	 alloc_format___map_queues__one_per_pipe = 0,
+	 alloc_format___map_queues__all_on_one_pipe = 1 };
+
+enum _MAP_QUEUES_engine_sel_enum {
+	 engine_sel___map_queues__compute = 0,
+	 engine_sel___map_queues__sdma0_queue = 2,
+	 engine_sel___map_queues__sdma1_queue = 3 };
+
+
+struct _PM4__MAP_QUEUES {
+	union {
+		PM4_TYPE_3_HEADER header;
+		unsigned int ordinal1;
+	};
+
+	union {
+		struct {
+			unsigned int reserved1:4;
+			enum _MAP_QUEUES_queue_sel_enum queue_sel:2;
+			unsigned int reserved2:2;
+			unsigned int vmid:4;
+			unsigned int reserved3:4;
+			enum _MAP_QUEUES_vidmem_enum vidmem:2;
+			unsigned int reserved4:6;
+			enum _MAP_QUEUES_alloc_format_enum alloc_format:2;
+			enum _MAP_QUEUES_engine_sel_enum engine_sel:3;
+			unsigned int num_queues:3;
+		} bitfields2;
+		unsigned int ordinal2;
+	};
+
+	struct {
+		union {
+			struct {
+				unsigned int reserved5:2;
+				unsigned int doorbell_offset:21;
+				unsigned int reserved6:3;
+				unsigned int queue:6;
+			} bitfields3;
+			unsigned int ordinal3;
+		};
+
+		unsigned int mqd_addr_lo;
+
+		unsigned int mqd_addr_hi;
+
+		unsigned int wptr_addr_lo;
+
+		unsigned int wptr_addr_hi;
+
+	} _map_queues_ordinals[1];	/* 1..N of these ordinal groups */
+
+};
+#endif
+
+/*--------------------_QUERY_STATUS--------------------*/
+
+#ifndef _PM4__QUERY_STATUS_DEFINED
+#define _PM4__QUERY_STATUS_DEFINED
+enum _QUERY_STATUS_interrupt_sel_enum {
+	 interrupt_sel___query_status__completion_status = 0,
+	 interrupt_sel___query_status__process_status = 1,
+	 interrupt_sel___query_status__queue_status = 2,
+	 interrupt_sel___query_status__reserved = 3 };
+
+enum _QUERY_STATUS_command_enum {
+	 command___query_status__interrupt_only = 0,
+	 command___query_status__fence_only_immediate = 1,
+	 command___query_status__fence_only_after_write_ack = 2,
+	 command___query_status__fence_wait_for_write_ack_send_interrupt = 3 };
+
+enum _QUERY_STATUS_engine_sel_enum {
+	 engine_sel___query_status__compute = 0,
+	 engine_sel___query_status__sdma0 = 2,
+	 engine_sel___query_status__sdma1 = 3 };
+
+
+struct _PM4__QUERY_STATUS {
+	union {
+		PM4_TYPE_3_HEADER header;
+		unsigned int ordinal1;
+	};
+
+	union {
+		struct {
+			unsigned int context_id:28;
+			enum _QUERY_STATUS_interrupt_sel_enum interrupt_sel:2;
+			enum _QUERY_STATUS_command_enum command:2;
+		} bitfields2;
+		unsigned int ordinal2;
+	};
+
+	union {
+		struct {
+			unsigned int pasid:16;
+			unsigned int reserved1:16;
+		} bitfields3;
+		struct {
+			unsigned int reserved2:2;
+			unsigned int doorbell_offset:21;
+			unsigned int reserved3:3;
+			enum _QUERY_STATUS_engine_sel_enum engine_sel:3;
+			unsigned int reserved4:3;
+		} bitfields4;
+		unsigned int ordinal3;
+	};
+
+	unsigned int addr_lo;
+
+	unsigned int addr_hi;
+
+	unsigned int data_lo;
+
+	unsigned int data_hi;
+
+};
+#endif
+
+/*
+ *  --------------------UNMAP_QUEUES--------------------
+ */
+
+#ifndef _PM4__UNMAP_QUEUES_DEFINED
+#define _PM4__UNMAP_QUEUES_DEFINED
+enum _unmap_queues_action_enum {
+	 action___unmap_queues__preempt_queues = 0,
+	 action___unmap_queues__reset_queues = 1,
+	 action___unmap_queues__disable_process_queues = 2,
+	 action___unmap_queues__reserved = 3 };
+
+enum _unmap_queues_queue_sel_enum {
+	 queue_sel___unmap_queues__perform_request_on_specified_queues = 0,
+	 queue_sel___unmap_queues__perform_request_on_pasid_queues = 1,
+	 queue_sel___unmap_queues__perform_request_on_all_active_queues = 2,
+	 queue_sel___unmap_queues__reserved = 3 };
+
+enum _unmap_queues_engine_sel_enum {
+	 engine_sel___unmap_queues__compute = 0,
+	 engine_sel___unmap_queues__sdma0 = 2,
+	 engine_sel___unmap_queues__sdma1 = 3 };
+
+
+struct pm4_unmap_queues {
+	union {
+		PM4_TYPE_3_HEADER header;
+		unsigned int ordinal1;
+	};
+
+	union {
+		struct {
+			_unmap_queues_action_enum action:2;
+			unsigned int reserved1:2;
+
+			_unmap_queues_queue_sel_enum queue_sel:2;
+			unsigned int reserved2:20;
+
+			_unmap_queues_engine_sel_enum engine_sel:3;
+			unsigned int num_queues:3;
+		} bitfields2;
+		unsigned int ordinal2;
+	};
+
+	union {
+		struct {
+			unsigned int pasid:16;
+			unsigned int reserved3:16;
+		} bitfields3;
+		struct {
+			unsigned int reserved4:2;
+			unsigned int doorbell_offset0:21;
+			unsigned int reserved5:9;
+		} bitfields4;
+		unsigned int ordinal3;
+	};
+
+	union {
+		struct {
+			unsigned int reserved6:2;
+			unsigned int doorbell_offset1:21;
+			unsigned int reserved7:9;
+		} bitfields5;
+		unsigned int ordinal4;
+	};
+
+	union {
+		struct {
+			unsigned int reserved8:2;
+			unsigned int doorbell_offset2:21;
+			unsigned int reserved9:9;
+		} bitfields6;
+		unsigned int ordinal5;
+	};
+
+	union {
+		struct {
+			unsigned int reserved10:2;
+			unsigned int doorbell_offset3:21;
+			unsigned int reserved11:9;
+		} bitfields7;
+		unsigned int ordinal6;
+	};
+
+};
+#endif
+
+/* --------------------_SET_SH_REG--------------------*/
+
+#ifndef _PM4__SET_SH_REG_DEFINED
+#define _PM4__SET_SH_REG_DEFINED
+
+struct _PM4__SET_SH_REG {
+	union {
+		union PM4_TYPE_3_HEADER header;
+		unsigned int ordinal1;
+	};
+
+	union {
+		struct {
+			unsigned int reg_offset:16;
+			unsigned int reserved1:8;
+			unsigned int vmid_shift:5;
+			unsigned int insert_vmid:1;
+			unsigned int reserved2:1;
+			unsigned int non_incr_addr:1;
+		} bitfields2;
+		unsigned int ordinal2;
+	};
+
+	unsigned int reg_data[1];	/* 1..N of these fields */
+
+};
+#endif
+
+/*--------------------_SET_CONFIG_REG--------------------*/
+
+#ifndef _PM4__SET_CONFIG_REG_DEFINED
+#define _PM4__SET_CONFIG_REG_DEFINED
+
+struct pm4__set_config_reg {
+	union {
+		union PM4_TYPE_3_HEADER header;
+		unsigned int ordinal1;
+	};
+
+	union {
+		struct {
+			unsigned int reg_offset:16;
+			unsigned int reserved1:8;
+			unsigned int vmid_shift:5;
+			unsigned int insert_vmid:1;
+			unsigned int reserved2:2;
+		} bitfields2;
+		unsigned int ordinal2;
+	};
+
+	unsigned int reg_data[1];	/* 1..N of these fields */
+
+};
+#endif
+
+#endif /* KFD_PM4_HEADERS_H_ */
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h b/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h
new file mode 100644
index 0000000..b72fa3b
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h
@@ -0,0 +1,107 @@
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
+
+#ifndef KFD_PM4_OPCODES_H
+#define KFD_PM4_OPCODES_H
+
+enum it_opcode_type {
+	IT_NOP                               = 0x10,
+	IT_SET_BASE                          = 0x11,
+	IT_CLEAR_STATE                       = 0x12,
+	IT_INDEX_BUFFER_SIZE                 = 0x13,
+	IT_DISPATCH_DIRECT                   = 0x15,
+	IT_DISPATCH_INDIRECT                 = 0x16,
+	IT_ATOMIC_GDS                        = 0x1D,
+	IT_OCCLUSION_QUERY                   = 0x1F,
+	IT_SET_PREDICATION                   = 0x20,
+	IT_REG_RMW                           = 0x21,
+	IT_COND_EXEC                         = 0x22,
+	IT_PRED_EXEC                         = 0x23,
+	IT_DRAW_INDIRECT                     = 0x24,
+	IT_DRAW_INDEX_INDIRECT               = 0x25,
+	IT_INDEX_BASE                        = 0x26,
+	IT_DRAW_INDEX_2                      = 0x27,
+	IT_CONTEXT_CONTROL                   = 0x28,
+	IT_INDEX_TYPE                        = 0x2A,
+	IT_DRAW_INDIRECT_MULTI               = 0x2C,
+	IT_DRAW_INDEX_AUTO                   = 0x2D,
+	IT_NUM_INSTANCES                     = 0x2F,
+	IT_DRAW_INDEX_MULTI_AUTO             = 0x30,
+	IT_INDIRECT_BUFFER_CNST              = 0x33,
+	IT_STRMOUT_BUFFER_UPDATE             = 0x34,
+	IT_DRAW_INDEX_OFFSET_2               = 0x35,
+	IT_DRAW_PREAMBLE                     = 0x36,
+	IT_WRITE_DATA                        = 0x37,
+	IT_DRAW_INDEX_INDIRECT_MULTI         = 0x38,
+	IT_MEM_SEMAPHORE                     = 0x39,
+	IT_COPY_DW                           = 0x3B,
+	IT_WAIT_REG_MEM                      = 0x3C,
+	IT_INDIRECT_BUFFER                   = 0x3F,
+	IT_COPY_DATA                         = 0x40,
+	IT_PFP_SYNC_ME                       = 0x42,
+	IT_SURFACE_SYNC                      = 0x43,
+	IT_COND_WRITE                        = 0x45,
+	IT_EVENT_WRITE                       = 0x46,
+	IT_EVENT_WRITE_EOP                   = 0x47,
+	IT_EVENT_WRITE_EOS                   = 0x48,
+	IT_RELEASE_MEM                       = 0x49,
+	IT_PREAMBLE_CNTL                     = 0x4A,
+	IT_DMA_DATA                          = 0x50,
+	IT_ACQUIRE_MEM                       = 0x58,
+	IT_REWIND                            = 0x59,
+	IT_LOAD_UCONFIG_REG                  = 0x5E,
+	IT_LOAD_SH_REG                       = 0x5F,
+	IT_LOAD_CONFIG_REG                   = 0x60,
+	IT_LOAD_CONTEXT_REG                  = 0x61,
+	IT_SET_CONFIG_REG                    = 0x68,
+	IT_SET_CONTEXT_REG                   = 0x69,
+	IT_SET_CONTEXT_REG_INDIRECT          = 0x73,
+	IT_SET_SH_REG                        = 0x76,
+	IT_SET_SH_REG_OFFSET                 = 0x77,
+	IT_SET_QUEUE_REG                     = 0x78,
+	IT_SET_UCONFIG_REG                   = 0x79,
+	IT_SCRATCH_RAM_WRITE                 = 0x7D,
+	IT_SCRATCH_RAM_READ                  = 0x7E,
+	IT_LOAD_CONST_RAM                    = 0x80,
+	IT_WRITE_CONST_RAM                   = 0x81,
+	IT_DUMP_CONST_RAM                    = 0x83,
+	IT_INCREMENT_CE_COUNTER              = 0x84,
+	IT_INCREMENT_DE_COUNTER              = 0x85,
+	IT_WAIT_ON_CE_COUNTER                = 0x86,
+	IT_WAIT_ON_DE_COUNTER_DIFF           = 0x88,
+	IT_SWITCH_BUFFER                     = 0x8B,
+	IT_SET_RESOURCES                     = 0xA0,
+	IT_MAP_PROCESS                       = 0xA1,
+	IT_MAP_QUEUES                        = 0xA2,
+	IT_UNMAP_QUEUES                      = 0xA3,
+	IT_QUERY_STATUS                      = 0xA4,
+	IT_RUN_LIST                          = 0xA5,
+};
+
+#define PM4_TYPE_0 0
+#define PM4_TYPE_2 2
+#define PM4_TYPE_3 3
+
+#endif /* KFD_PM4_OPCODES_H */
+
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 76494757..25f23c5 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -49,6 +49,15 @@
 #define KFD_MMAP_DOORBELL_START	(((1ULL << 32)*1) >> PAGE_SHIFT)
 #define KFD_MMAP_DOORBELL_END	(((1ULL << 32)*2) >> PAGE_SHIFT)
 
+/*
+ * When working with cp scheduler we should assign the HIQ manually or via the radeon driver
+ * to a fixed hqd slot, here are the fixed HIQ hqd slot definitions for Kaveri.
+ * In Kaveri only the first ME queues participates in the cp scheduling taking that in mind
+ * we set the HIQ slot in the second ME.
+ */
+#define KFD_CIK_HIQ_PIPE 4
+#define KFD_CIK_HIQ_QUEUE 0
+
 /* GPU ID hash width in bits */
 #define KFD_GPU_ID_HASH_WIDTH 16
 
@@ -68,6 +77,11 @@ typedef u32 doorbell_t;
 /* Type that represents queue pointer */
 typedef u32 qptr_t;
 
+enum cache_policy {
+	cache_policy_coherent,
+	cache_policy_noncoherent
+};
+
 struct kfd_device_info {
 	const struct kfd_scheduler_class *scheduler_class;
 	unsigned int max_pasid_bits;
@@ -96,6 +110,9 @@ struct kfd_dev {
 	u32 __iomem *doorbell_kernel_ptr; /* this is a pointer for a doorbells page used by kernel queue */
 
 	struct kgd2kfd_shared_resources shared_resources;
+
+	/* QCM Device instance */
+	struct device_queue_manager *dqm;
 };
 
 /* KGD2KFD callbacks */
@@ -300,4 +317,19 @@ int kgd2kfd_resume(struct kfd_dev *dev);
 /* amdkfd Apertures */
 int kfd_init_apertures(struct kfd_process *process);
 
+/* Queue Context Management */
+int init_queue(struct queue **q, struct queue_properties properties);
+void uninit_queue(struct queue *q);
+void print_queue(struct queue *q);
+
+/* Packet Manager */
+
+struct packet_manager {
+	struct device_queue_manager *dqm;
+	struct kernel_queue *priv_queue;
+	struct mutex lock;
+	bool allocated;
+	kfd_mem_obj ib_buffer_obj;
+};
+
 #endif
-- 
1.9.1

