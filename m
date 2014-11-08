Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaKHSo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:44:59 -0500
Received: from mail-bn1on0117.outbound.protection.outlook.com ([157.56.110.117]:25899
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754077AbaKHSo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:44:57 -0500
X-WSS-ID: 0NEQHEO-08-GF2-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>, Ben Goz <ben.goz@amd.com>,
        Jay Cornwall <jay.cornwall@amd.com>, Oded Gabbay <oded.gabbay@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        "Alexey Skidanov" <Alexey.Skidanov@amd.com>
Subject: [PATCH v5 18/24] amdkfd: Add device queue manager module
Date: Sat, 8 Nov 2014 20:37:39 +0200
Message-ID: <1415471865-1893-19-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(51234002)(19580395003)(19580405001)(89996001)(64706001)(107046002)(102836001)(87286001)(50226001)(101416001)(53416004)(44976005)(104166001)(84676001)(4396001)(97736003)(76176999)(68736004)(95666004)(106466001)(33646002)(88136002)(20776003)(47776003)(77096003)(50986999)(229853001)(105586002)(77156002)(62966003)(120916001)(36756003)(92566001)(48376002)(575784001)(86362001)(50466002)(93916002)(92726001)(21056001)(31966008)(46102003)(99396003)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(1)(2);SRVR:BY2PR02MB204;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

The queue scheduler divides into two sections, one section is process bounded
and the other section is device bounded.
The device bounded section is handled by this module.
The DQM module handles queue setup, update and tear-down from the device side.
It also supports suspend/resume operation.

v3: Changed device_init, added the use of the new gart allocation functions an
Added documentation.

v4:

Fixed a race in DQM queue scheduler where dqm->lock must be held when accessing
dqm->queue_count and dqm->processes_count. This fixes runlist IB allocation
failures when DQM is under load.

Fixed race in DQM queue destruction where queues being destroyed must be
removed from qpd->queues_list prior to preemption, or concurrent queue
creation activity may reschedule them while their MQD is destroyed.

Fixed EOP queue size setting in CP_HPD_EOP_CONTROL, because the size is
specified as (log2(size_dwords)-1). The previous calculation assumed the
size was specified in bytes, which caused interference between EOP queues
when multiple MEC pipelines were active.

v5:

Move amdkfd from drm/radeon/ to drm/amd/
Change format of mqd structure to match latest KV firmware
Add support for AQL queues creation to enable working with open-source HSA
runtime
Remove unused unmap_queue function
Various fixes (Style, typos)

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/Makefile                |    2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   29 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  | 1059 ++++++++++++++++++++
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |   49 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   21 +
 5 files changed, 1156 insertions(+), 4 deletions(-)
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c

diff --git a/drivers/gpu/drm/amd/amdkfd/Makefile b/drivers/gpu/drm/amd/amdkfd/Makefile
index 104f279..307a309 100644
--- a/drivers/gpu/drm/amd/amdkfd/Makefile
+++ b/drivers/gpu/drm/amd/amdkfd/Makefile
@@ -8,6 +8,6 @@ amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_flat_memory.o \
 		kfd_process.o kfd_queue.o kfd_mqd_manager.o \
 		kfd_kernel_queue.o kfd_packet_manager.o \
-		kfd_process_queue_manager.o
+		kfd_process_queue_manager.o kfd_device_queue_manager.o
 
 obj-$(CONFIG_HSA_AMD)	+= amdkfd.o
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 4b1cced..bdf3e94 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include "kfd_priv.h"
+#include "kfd_device_queue_manager.h"
 
 #define MQD_SIZE_ALIGNED 768
 
@@ -199,12 +200,34 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 	amd_iommu_set_invalidate_ctx_cb(kfd->pdev,
 						iommu_pasid_shutdown_callback);
 
+	kfd->dqm = device_queue_manager_init(kfd);
+	if (!kfd->dqm) {
+		dev_err(kfd_device,
+			"Error initializing queue manager for device (%x:%x)\n",
+			kfd->pdev->vendor, kfd->pdev->device);
+		goto device_queue_manager_error;
+	}
+
+	if (kfd->dqm->start(kfd->dqm) != 0) {
+		dev_err(kfd_device,
+			"Error starting queuen manager for device (%x:%x)\n",
+			kfd->pdev->vendor, kfd->pdev->device);
+		goto dqm_start_error;
+	}
+
 	kfd->init_complete = true;
 	dev_info(kfd_device, "added device (%x:%x)\n", kfd->pdev->vendor,
 		 kfd->pdev->device);
 
+	pr_debug("kfd: Starting kfd with the following scheduling policy %d\n",
+		sched_policy);
+
 	goto out;
 
+dqm_start_error:
+	device_queue_manager_uninit(kfd->dqm);
+device_queue_manager_error:
+	amd_iommu_free_device(kfd->pdev);
 device_iommu_pasid_error:
 	kfd_topology_remove_device(kfd);
 kfd_topology_add_device_error:
@@ -219,6 +242,7 @@ out:
 void kgd2kfd_device_exit(struct kfd_dev *kfd)
 {
 	if (kfd->init_complete) {
+		device_queue_manager_uninit(kfd->dqm);
 		amd_iommu_free_device(kfd->pdev);
 		kfd_topology_remove_device(kfd);
 	}
@@ -230,8 +254,10 @@ void kgd2kfd_suspend(struct kfd_dev *kfd)
 {
 	BUG_ON(kfd == NULL);
 
-	if (kfd->init_complete)
+	if (kfd->init_complete) {
+		kfd->dqm->stop(kfd->dqm);
 		amd_iommu_free_device(kfd->pdev);
+	}
 }
 
 int kgd2kfd_resume(struct kfd_dev *kfd)
@@ -249,6 +275,7 @@ int kgd2kfd_resume(struct kfd_dev *kfd)
 			return -ENXIO;
 		amd_iommu_set_invalidate_ctx_cb(kfd->pdev,
 						iommu_pasid_shutdown_callback);
+		kfd->dqm->start(kfd->dqm);
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
new file mode 100644
index 0000000..8c40d04
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -0,0 +1,1059 @@
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
+#include "../../radeon/cik_reg.h"
+
+/* Size of the per-pipe EOP queue */
+#define CIK_HPD_EOP_BYTES_LOG2 11
+#define CIK_HPD_EOP_BYTES (1U << CIK_HPD_EOP_BYTES_LOG2)
+
+static bool is_mem_initialized;
+
+static int init_memory(struct device_queue_manager *dqm);
+static int set_pasid_vmid_mapping(struct device_queue_manager *dqm,
+					unsigned int pasid, unsigned int vmid);
+
+static int create_compute_queue_nocpsch(struct device_queue_manager *dqm,
+					struct queue *q,
+					struct qcm_process_device *qpd);
+static int execute_queues_cpsch(struct device_queue_manager *dqm, bool lock);
+static int destroy_queues_cpsch(struct device_queue_manager *dqm, bool lock);
+
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
+static unsigned int get_sh_mem_bases_nybble_64(struct kfd_process *process,
+						struct kfd_dev *dev)
+{
+	struct kfd_process_device *pdd;
+	uint32_t nybble;
+
+	pdd = kfd_get_process_device_data(dev, process, 1);
+	nybble = (pdd->lds_base >> 60) & 0x0E;
+
+	return nybble;
+
+}
+
+static unsigned int get_sh_mem_bases_32(struct kfd_process *process,
+					struct kfd_dev *dev)
+{
+	struct kfd_process_device *pdd;
+	unsigned int shared_base;
+
+	pdd = kfd_get_process_device_data(dev, process, 1);
+	shared_base = (pdd->lds_base >> 16) & 0xFF;
+
+	return shared_base;
+}
+
+static uint32_t compute_sh_mem_bases_64bit(unsigned int top_address_nybble);
+static void init_process_memory(struct device_queue_manager *dqm,
+				struct qcm_process_device *qpd)
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
+static void program_sh_mem_settings(struct device_queue_manager *dqm,
+					struct qcm_process_device *qpd)
+{
+	return kfd2kgd->program_sh_mem_settings(dqm->dev->kgd, qpd->vmid,
+						qpd->sh_mem_config,
+						qpd->sh_mem_ape1_base,
+						qpd->sh_mem_ape1_limit,
+						qpd->sh_mem_bases);
+}
+
+static int allocate_vmid(struct device_queue_manager *dqm,
+			struct qcm_process_device *qpd,
+			struct queue *q)
+{
+	int bit, allocated_vmid;
+
+	if (dqm->vmid_bitmap == 0)
+		return -ENOMEM;
+
+	bit = find_first_bit((unsigned long *)&dqm->vmid_bitmap, CIK_VMID_NUM);
+	clear_bit(bit, (unsigned long *)&dqm->vmid_bitmap);
+
+	/* Kaveri kfd vmid's starts from vmid 8 */
+	allocated_vmid = bit + KFD_VMID_START_OFFSET;
+	pr_debug("kfd: vmid allocation %d\n", allocated_vmid);
+	qpd->vmid = allocated_vmid;
+	q->properties.vmid = allocated_vmid;
+
+	set_pasid_vmid_mapping(dqm, q->process->pasid, q->properties.vmid);
+	program_sh_mem_settings(dqm, qpd);
+
+	return 0;
+}
+
+static void deallocate_vmid(struct device_queue_manager *dqm,
+				struct qcm_process_device *qpd,
+				struct queue *q)
+{
+	int bit = qpd->vmid - KFD_VMID_START_OFFSET;
+
+	set_bit(bit, (unsigned long *)&dqm->vmid_bitmap);
+	qpd->vmid = 0;
+	q->properties.vmid = 0;
+}
+
+static int create_queue_nocpsch(struct device_queue_manager *dqm,
+				struct queue *q,
+				struct qcm_process_device *qpd,
+				int *allocated_vmid)
+{
+	int retval;
+
+	BUG_ON(!dqm || !q || !qpd || !allocated_vmid);
+
+	pr_debug("kfd: In func %s\n", __func__);
+	print_queue(q);
+
+	mutex_lock(&dqm->lock);
+
+	if (list_empty(&qpd->queues_list)) {
+		retval = allocate_vmid(dqm, qpd, q);
+		if (retval != 0) {
+			mutex_unlock(&dqm->lock);
+			return retval;
+		}
+	}
+	*allocated_vmid = qpd->vmid;
+	q->properties.vmid = qpd->vmid;
+
+	retval = create_compute_queue_nocpsch(dqm, q, qpd);
+
+	if (retval != 0) {
+		if (list_empty(&qpd->queues_list)) {
+			deallocate_vmid(dqm, qpd, q);
+			*allocated_vmid = 0;
+		}
+		mutex_unlock(&dqm->lock);
+		return retval;
+	}
+
+	list_add(&q->list, &qpd->queues_list);
+	dqm->queue_count++;
+
+	mutex_unlock(&dqm->lock);
+	return 0;
+}
+
+static int allocate_hqd(struct device_queue_manager *dqm, struct queue *q)
+{
+	bool set;
+	int pipe, bit;
+
+	set = false;
+
+	for (pipe = dqm->next_pipe_to_allocate; pipe < get_pipes_num(dqm);
+			pipe = (pipe + 1) % get_pipes_num(dqm)) {
+		if (dqm->allocated_queues[pipe] != 0) {
+			bit = find_first_bit(
+				(unsigned long *)&dqm->allocated_queues[pipe],
+				QUEUES_PER_PIPE);
+
+			clear_bit(bit,
+				(unsigned long *)&dqm->allocated_queues[pipe]);
+			q->pipe = pipe;
+			q->queue = bit;
+			set = true;
+			break;
+		}
+	}
+
+	if (set == false)
+		return -EBUSY;
+
+	pr_debug("kfd: DQM %s hqd slot - pipe (%d) queue(%d)\n",
+				__func__, q->pipe, q->queue);
+	/* horizontal hqd allocation */
+	dqm->next_pipe_to_allocate = (pipe + 1) % get_pipes_num(dqm);
+
+	return 0;
+}
+
+static inline void deallocate_hqd(struct device_queue_manager *dqm,
+				struct queue *q)
+{
+	set_bit(q->queue, (unsigned long *)&dqm->allocated_queues[q->pipe]);
+}
+
+static int create_compute_queue_nocpsch(struct device_queue_manager *dqm,
+					struct queue *q,
+					struct qcm_process_device *qpd)
+{
+	int retval;
+	struct mqd_manager *mqd;
+
+	BUG_ON(!dqm || !q || !qpd);
+
+	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_COMPUTE);
+	if (mqd == NULL)
+		return -ENOMEM;
+
+	retval = allocate_hqd(dqm, q);
+	if (retval != 0)
+		return retval;
+
+	retval = mqd->init_mqd(mqd, &q->mqd, &q->mqd_mem_obj,
+				&q->gart_mqd_addr, &q->properties);
+	if (retval != 0) {
+		deallocate_hqd(dqm, q);
+		return retval;
+	}
+
+	return 0;
+}
+
+static int destroy_queue_nocpsch(struct device_queue_manager *dqm,
+				struct qcm_process_device *qpd,
+				struct queue *q)
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
+
+	retval = mqd->destroy_mqd(mqd, q->mqd,
+				KFD_PREEMPT_TYPE_WAVEFRONT,
+				QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS,
+				q->pipe, q->queue);
+
+	if (retval != 0)
+		goto out;
+
+	deallocate_hqd(dqm, q);
+
+	mqd->uninit_mqd(mqd, q->mqd, q->mqd_mem_obj);
+
+	list_del(&q->list);
+	if (list_empty(&qpd->queues_list))
+		deallocate_vmid(dqm, qpd, q);
+	dqm->queue_count--;
+out:
+	mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+static int update_queue(struct device_queue_manager *dqm, struct queue *q)
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
+
+	retval = mqd->update_mqd(mqd, q->mqd, &q->properties);
+	if (q->properties.is_active == true)
+		dqm->queue_count++;
+	else
+		dqm->queue_count--;
+
+	if (sched_policy != KFD_SCHED_POLICY_NO_HWS)
+		retval = execute_queues_cpsch(dqm, false);
+
+	mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+static struct mqd_manager *get_mqd_manager_nocpsch(
+		struct device_queue_manager *dqm, enum KFD_MQD_TYPE type)
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
+static int register_process_nocpsch(struct device_queue_manager *dqm,
+					struct qcm_process_device *qpd)
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
+static int unregister_process_nocpsch(struct device_queue_manager *dqm,
+					struct qcm_process_device *qpd)
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
+set_pasid_vmid_mapping(struct device_queue_manager *dqm, unsigned int pasid,
+			unsigned int vmid)
+{
+	uint32_t pasid_mapping;
+
+	pasid_mapping = (pasid == 0) ? 0 : (uint32_t)pasid |
+						ATC_VMID_PASID_MAPPING_VALID;
+	return kfd2kgd->set_pasid_vmid_mapping(dqm->dev->kgd, pasid_mapping,
+						vmid);
+}
+
+static uint32_t compute_sh_mem_bases_64bit(unsigned int top_address_nybble)
+{
+	/* In 64-bit mode, we can only control the top 3 bits of the LDS,
+	 * scratch and GPUVM apertures.
+	 * The hardware fills in the remaining 59 bits according to the
+	 * following pattern:
+	 * LDS:		X0000000'00000000 - X0000001'00000000 (4GB)
+	 * Scratch:	X0000001'00000000 - X0000002'00000000 (4GB)
+	 * GPUVM:	Y0010000'00000000 - Y0020000'00000000 (1TB)
+	 *
+	 * (where X/Y is the configurable nybble with the low-bit 0)
+	 *
+	 * LDS and scratch will have the same top nybble programmed in the
+	 * top 3 bits of SH_MEM_BASES.PRIVATE_BASE.
+	 * GPUVM can have a different top nybble programmed in the
+	 * top 3 bits of SH_MEM_BASES.SHARED_BASE.
+	 * We don't bother to support different top nybbles
+	 * for LDS/Scratch and GPUVM.
+	 */
+
+	BUG_ON((top_address_nybble & 1) || top_address_nybble > 0xE ||
+		top_address_nybble == 0);
+
+	return PRIVATE_BASE(top_address_nybble << 12) |
+			SHARED_BASE(top_address_nybble << 12);
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
+static int init_pipelines(struct device_queue_manager *dqm,
+			unsigned int pipes_num, unsigned int first_pipe)
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
+	 * The driver never accesses this memory after zeroing it.
+	 * It doesn't even have to be saved/restored on suspend/resume
+	 * because it contains no data when there are no active queues.
+	 */
+
+	err = kfd2kgd->allocate_mem(dqm->dev->kgd,
+				CIK_HPD_EOP_BYTES * pipes_num,
+				PAGE_SIZE,
+				KFD_MEMPOOL_SYSTEM_WRITECOMBINE,
+				(struct kgd_mem **) &dqm->pipeline_mem);
+
+	if (err) {
+		pr_err("kfd: error allocate vidmem num pipes: %d\n",
+			pipes_num);
+		return -ENOMEM;
+	}
+
+	hpdptr = dqm->pipeline_mem->cpu_ptr;
+	dqm->pipelines_addr = dqm->pipeline_mem->gpu_addr;
+
+	memset(hpdptr, 0, CIK_HPD_EOP_BYTES * pipes_num);
+
+	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_COMPUTE);
+	if (mqd == NULL) {
+		kfd2kgd->free_mem(dqm->dev->kgd,
+				(struct kgd_mem *) dqm->pipeline_mem);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < pipes_num; i++) {
+		inx = i + first_pipe;
+		pipe_hpd_addr = dqm->pipelines_addr + i * CIK_HPD_EOP_BYTES;
+		pr_debug("kfd: pipeline address %llX\n", pipe_hpd_addr);
+		/* = log2(bytes/4)-1 */
+		kfd2kgd->init_pipeline(dqm->dev->kgd, i,
+				CIK_HPD_EOP_BYTES_LOG2 - 3, pipe_hpd_addr);
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
+
+	retval = init_memory(dqm);
+
+	return retval;
+}
+
+static int initialize_nocpsch(struct device_queue_manager *dqm)
+{
+	int i;
+
+	BUG_ON(!dqm);
+
+	pr_debug("kfd: In func %s num of pipes: %d\n",
+			__func__, get_pipes_num(dqm));
+
+	mutex_init(&dqm->lock);
+	INIT_LIST_HEAD(&dqm->queues);
+	dqm->queue_count = dqm->next_pipe_to_allocate = 0;
+	dqm->allocated_queues = kcalloc(get_pipes_num(dqm),
+					sizeof(unsigned int), GFP_KERNEL);
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
+	kfd2kgd->free_mem(dqm->dev->kgd,
+			(struct kgd_mem *) dqm->pipeline_mem);
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
+	res.gws_mask = res.oac_mask = res.gds_heap_base =
+						res.gds_heap_size = 0;
+
+	pr_debug("kfd: scheduling resources:\n"
+			"      vmid mask: 0x%8X\n"
+			"      queue mask: 0x%8llX\n",
+			res.vmid_mask, res.queue_mask);
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
+	pr_debug("kfd: In func %s num of pipes: %d\n",
+			__func__, get_pipes_num_cpsch());
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
+
+	/* allocate fence memory on the gart */
+	retval = kfd2kgd->allocate_mem(dqm->dev->kgd,
+					sizeof(*dqm->fence_addr),
+					32,
+					KFD_MEMPOOL_SYSTEM_WRITECOMBINE,
+					(struct kgd_mem **) &dqm->fence_mem);
+
+	if (retval != 0)
+		goto fail_allocate_vidmem;
+
+	dqm->fence_addr = dqm->fence_mem->cpu_ptr;
+	dqm->fence_gpu_addr = dqm->fence_mem->gpu_addr;
+
+	list_for_each_entry(node, &dqm->queues, list)
+		if (node->qpd->pqm->process && dqm->dev)
+			kfd_bind_process_to_device(dqm->dev,
+						node->qpd->pqm->process);
+
+	execute_queues_cpsch(dqm, true);
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
+	destroy_queues_cpsch(dqm, true);
+
+	list_for_each_entry(node, &dqm->queues, list) {
+		pdd = kfd_get_process_device_data(dqm->dev,
+						node->qpd->pqm->process, 1);
+		pdd->bound = false;
+	}
+	kfd2kgd->free_mem(dqm->dev->kgd,
+			(struct kgd_mem *) dqm->fence_mem);
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
+	execute_queues_cpsch(dqm, false);
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
+	mutex_lock(&dqm->lock);
+	destroy_queues_cpsch(dqm, false);
+	list_del(&kq->list);
+	dqm->queue_count--;
+	qpd->is_debug = false;
+	execute_queues_cpsch(dqm, false);
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
+	retval = mqd->init_mqd(mqd, &q->mqd, &q->mqd_mem_obj,
+				&q->gart_mqd_addr, &q->properties);
+	if (retval != 0)
+		goto out;
+
+	list_add(&q->list, &qpd->queues_list);
+	if (q->properties.is_active) {
+		dqm->queue_count++;
+		retval = execute_queues_cpsch(dqm, false);
+	}
+
+out:
+	mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+int fence_wait_timeout(unsigned int *fence_addr, unsigned int fence_value,
+			unsigned long timeout)
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
+static int destroy_queues_cpsch(struct device_queue_manager *dqm, bool lock)
+{
+	int retval;
+
+	BUG_ON(!dqm);
+
+	retval = 0;
+
+	if (lock)
+		mutex_lock(&dqm->lock);
+	if (dqm->active_runlist == false)
+		goto out;
+	retval = pm_send_unmap_queue(&dqm->packets, KFD_QUEUE_TYPE_COMPUTE,
+			KFD_PREEMPT_TYPE_FILTER_ALL_QUEUES, 0, false, 0);
+	if (retval != 0)
+		goto out;
+
+	*dqm->fence_addr = KFD_FENCE_INIT;
+	pm_send_query_status(&dqm->packets, dqm->fence_gpu_addr,
+				KFD_FENCE_COMPLETED);
+	/* should be timed out */
+	fence_wait_timeout(dqm->fence_addr, KFD_FENCE_COMPLETED,
+				QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS);
+	pm_release_ib(&dqm->packets);
+	dqm->active_runlist = false;
+
+out:
+	if (lock)
+		mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+static int execute_queues_cpsch(struct device_queue_manager *dqm, bool lock)
+{
+	int retval;
+
+	BUG_ON(!dqm);
+
+	if (lock)
+		mutex_lock(&dqm->lock);
+
+	retval = destroy_queues_cpsch(dqm, false);
+	if (retval != 0) {
+		pr_err("kfd: the cp might be in an unrecoverable state due to an unsuccessful queues preemption");
+		goto out;
+	}
+
+	if (dqm->queue_count <= 0 || dqm->processes_count <= 0) {
+		retval = 0;
+		goto out;
+	}
+
+	if (dqm->active_runlist) {
+		retval = 0;
+		goto out;
+	}
+
+	retval = pm_send_runlist(&dqm->packets, &dqm->queues);
+	if (retval != 0) {
+		pr_err("kfd: failed to execute runlist");
+		goto out;
+	}
+	dqm->active_runlist = true;
+
+out:
+	if (lock)
+		mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+static int destroy_queue_cpsch(struct device_queue_manager *dqm,
+				struct qcm_process_device *qpd,
+				struct queue *q)
+{
+	int retval;
+	struct mqd_manager *mqd;
+
+	BUG_ON(!dqm || !qpd || !q);
+
+	retval = 0;
+
+	/* remove queue from list to prevent rescheduling after preemption */
+	mutex_lock(&dqm->lock);
+
+	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_CP);
+	if (!mqd) {
+		retval = -ENOMEM;
+		goto failed;
+	}
+
+	list_del(&q->list);
+	dqm->queue_count--;
+
+	execute_queues_cpsch(dqm, false);
+
+	mqd->uninit_mqd(mqd, q->mqd, q->mqd_mem_obj);
+
+	mutex_unlock(&dqm->lock);
+
+	return 0;
+
+failed:
+	mutex_unlock(&dqm->lock);
+	return retval;
+}
+
+/*
+ * Low bits must be 0000/FFFF as required by HW, high bits must be 0 to
+ * stay in user mode.
+ */
+#define APE1_FIXED_BITS_MASK 0xFFFF80000000FFFFULL
+/* APE1 limit is inclusive and 64K aligned. */
+#define APE1_LIMIT_ALIGNMENT 0xFFFF
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
+
+	mutex_lock(&dqm->lock);
+
+	if (alternate_aperture_size == 0) {
+		/* base > limit disables APE1 */
+		qpd->sh_mem_ape1_base = 1;
+		qpd->sh_mem_ape1_limit = 0;
+	} else {
+		/*
+		 * In FSA64, APE1_Base[63:0] = { 16{SH_MEM_APE1_BASE[31]},
+		 *			SH_MEM_APE1_BASE[31:0], 0x0000 }
+		 * APE1_Limit[63:0] = { 16{SH_MEM_APE1_LIMIT[31]},
+		 *			SH_MEM_APE1_LIMIT[31:0], 0xFFFF }
+		 * Verify that the base and size parameters can be
+		 * represented in this format and convert them.
+		 * Additionally restrict APE1 to user-mode addresses.
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
+		dqm->destroy_queue = destroy_queue_cpsch;
+		dqm->update_queue = update_queue;
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
+		dqm->update_queue = update_queue;
+		dqm->get_mqd_manager = get_mqd_manager_nocpsch;
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
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
index e495b38..c3f189e8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
@@ -42,6 +42,50 @@ struct device_process_node {
 	struct list_head list;
 };
 
+/**
+ * struct device_queue_manager
+ *
+ * @create_queue: Queue creation routine.
+ *
+ * @destroy_queue: Queue destruction routine.
+ *
+ * @update_queue: Queue update routine.
+ *
+ * @get_mqd_manager: Returns the mqd manager according to the mqd type.
+ *
+ * @exeute_queues: Dispatches the queues list to the H/W.
+ *
+ * @register_process: This routine associates a specific process with device.
+ *
+ * @unregister_process: destroys the associations between process to device.
+ *
+ * @initialize: Initializes the pipelines and memory module for that device.
+ *
+ * @start: Initializes the resources/modules the the device needs for queues
+ * execution. This function is called on device initialization and after the
+ * system woke up after suspension.
+ *
+ * @stop: This routine stops execution of all the active queue running on the
+ * H/W and basically this function called on system suspend.
+ *
+ * @uninitialize: Destroys all the device queue manager resources allocated in
+ * initialize routine.
+ *
+ * @create_kernel_queue: Creates kernel queue. Used for debug queue.
+ *
+ * @destroy_kernel_queue: Destroys kernel queue. Used for debug queue.
+ *
+ * @set_cache_memory_policy: Sets memory policy (cached/ non cached) for the
+ * memory apertures.
+ *
+ * This struct is a base class for the kfd queues scheduler in the
+ * device level. The device base class should expose the basic operations
+ * for queue creation and queue destruction. This base class hides the
+ * scheduling mode of the driver and the specific implementation of the
+ * concrete device. This class is the only class in the queues scheduler
+ * that configures the H/W.
+ */
+
 struct device_queue_manager {
 	int	(*create_queue)(struct device_queue_manager *dqm,
 				struct queue *q,
@@ -52,8 +96,9 @@ struct device_queue_manager {
 				struct queue *q);
 	int	(*update_queue)(struct device_queue_manager *dqm,
 				struct queue *q);
-	struct mqd_manager * (*get_mqd_manager)(
-					struct device_queue_manager *dqm,
+
+	struct mqd_manager * (*get_mqd_manager)
+					(struct device_queue_manager *dqm,
 					enum KFD_MQD_TYPE type);
 
 	int	(*register_process)(struct device_queue_manager *dqm,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 72b2e27..7f3b4fd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -454,6 +454,8 @@ void kfd_process_destroy_wq(void);
 struct kfd_process *kfd_create_process(const struct task_struct *);
 struct kfd_process *kfd_get_process(const struct task_struct *);
 
+struct kfd_process_device *kfd_bind_process_to_device(struct kfd_dev *dev,
+							struct kfd_process *p);
 void kfd_unbind_process_from_device(struct kfd_dev *dev, unsigned int pasid);
 struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
 							struct kfd_process *p,
@@ -509,6 +511,10 @@ void uninit_queue(struct queue *q);
 void print_queue_properties(struct queue_properties *q);
 void print_queue(struct queue *q);
 
+struct mqd_manager *mqd_manager_init(enum KFD_MQD_TYPE type,
+					struct kfd_dev *dev);
+struct device_queue_manager *device_queue_manager_init(struct kfd_dev *dev);
+void device_queue_manager_uninit(struct device_queue_manager *dqm);
 struct kernel_queue *kernel_queue_init(struct kfd_dev *dev,
 					enum kfd_queue_type type);
 void kernel_queue_uninit(struct kernel_queue *kq);
@@ -537,6 +543,8 @@ int pqm_update_queue(struct process_queue_manager *pqm, unsigned int qid,
 
 #define KFD_HIQ_TIMEOUT (500)
 
+#define KFD_FENCE_COMPLETED (100)
+#define KFD_FENCE_INIT   (10)
 #define KFD_UNMAP_LATENCY (150)
 
 struct packet_manager {
@@ -547,6 +555,19 @@ struct packet_manager {
 	struct kfd_mem_obj *ib_buffer_obj;
 };
 
+int pm_init(struct packet_manager *pm, struct device_queue_manager *dqm);
+void pm_uninit(struct packet_manager *pm);
+int pm_send_set_resources(struct packet_manager *pm,
+				struct scheduling_resources *res);
+int pm_send_runlist(struct packet_manager *pm, struct list_head *dqm_queues);
+int pm_send_query_status(struct packet_manager *pm, uint64_t fence_address,
+				uint32_t fence_value);
+
+int pm_send_unmap_queue(struct packet_manager *pm, enum kfd_queue_type type,
+			enum kfd_preempt_type_filter mode,
+			uint32_t filter_param, bool reset,
+			unsigned int sdma_engine);
+
 void pm_release_ib(struct packet_manager *pm);
 
 uint64_t kfd_get_number_elems(struct kfd_dev *kfd);
-- 
2.1.0

