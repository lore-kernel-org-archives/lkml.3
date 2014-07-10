Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaGJV5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:57:46 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49623 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaGJV5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:43 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 81/83] hsa/radeon: Eliminating all direct register accesses
Date: Fri, 11 Jul 2014 00:54:37 +0300
Message-Id: <1405029279-6894-53-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This patch eliminates all direct register accesses from KFD
and eliminate using of shared locks between KFD and radeon.

The single exception is the doorbells that are used in
both of the drivers. However, because they are located
in separate pci bar pages, the danger of sharing registers
between the drivers is minimal.

Having said that, we are planning to move the doorbells as well
to radeon.

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/Makefile                   |   2 +-
 drivers/gpu/hsa/radeon/kfd_device.c               |   2 -
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.c | 113 +++-----------
 drivers/gpu/hsa/radeon/kfd_kernel_queue.c         |  12 +-
 drivers/gpu/hsa/radeon/kfd_mqd_manager.c          | 175 +---------------------
 drivers/gpu/hsa/radeon/kfd_mqd_manager.h          |  37 +++--
 drivers/gpu/hsa/radeon/kfd_priv.h                 |  18 ---
 drivers/gpu/hsa/radeon/kfd_registers.c            |  50 -------
 8 files changed, 54 insertions(+), 355 deletions(-)
 delete mode 100644 drivers/gpu/hsa/radeon/kfd_registers.c

diff --git a/drivers/gpu/hsa/radeon/Makefile b/drivers/gpu/hsa/radeon/Makefile
index b5f05b4..d838bce 100644
--- a/drivers/gpu/hsa/radeon/Makefile
+++ b/drivers/gpu/hsa/radeon/Makefile
@@ -4,7 +4,7 @@
 
 radeon_kfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o \
 		kfd_pasid.o kfd_topology.o kfd_process.o \
-		kfd_doorbell.o kfd_registers.o kfd_vidmem.o \
+		kfd_doorbell.o kfd_vidmem.o \
 		kfd_interrupt.o kfd_aperture.o kfd_queue.o kfd_mqd_manager.o \
 		kfd_kernel_queue.o kfd_packet_manager.o \
 		kfd_process_queue_manager.o kfd_device_queue_manager.o
diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
index 30558c9..0ff2241 100644
--- a/drivers/gpu/hsa/radeon/kfd_device.c
+++ b/drivers/gpu/hsa/radeon/kfd_device.c
@@ -157,8 +157,6 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 {
 	kfd->shared_resources = *gpu_resources;
 
-	kfd->regs = gpu_resources->mmio_registers;
-
 	radeon_kfd_doorbell_init(kfd);
 
 	if (radeon_kfd_interrupt_init(kfd))
diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
index 12b8b33..3eb5db3 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
@@ -112,30 +112,15 @@ static void init_process_memory(struct device_queue_manager *dqm, struct qcm_pro
 
 static void program_sh_mem_settings(struct device_queue_manager *dqm, struct qcm_process_device *qpd)
 {
-	struct mqd_manager *mqd;
-
-	BUG_ON(qpd->vmid < KFD_VMID_START_OFFSET);
-
-	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_COMPUTE);
-	if (mqd == NULL)
-		return;
-
-	mqd->acquire_hqd(mqd, 0, 0, qpd->vmid);
-
-	WRITE_REG(dqm->dev, SH_MEM_CONFIG, qpd->sh_mem_config);
-
-	WRITE_REG(dqm->dev, SH_MEM_APE1_BASE, qpd->sh_mem_ape1_base);
-	WRITE_REG(dqm->dev, SH_MEM_APE1_LIMIT, qpd->sh_mem_ape1_limit);
-	WRITE_REG(dqm->dev, SH_MEM_BASES, qpd->sh_mem_bases);
-
-	mqd->release_hqd(mqd);
+	return kfd2kgd->program_sh_mem_settings(dqm->dev->kgd, qpd->vmid, qpd->sh_mem_config,
+			qpd->sh_mem_ape1_base, qpd->sh_mem_ape1_limit, qpd->sh_mem_bases);
 }
 
 static int create_queue_nocpsch(struct device_queue_manager *dqm, struct queue *q,
 			struct qcm_process_device *qpd, int *allocate_vmid)
 {
 	bool set, is_new_vmid;
-	int bit, retval, pipe;
+	int bit, retval, pipe, i;
 	struct mqd_manager *mqd;
 
 	BUG_ON(!dqm || !q || !qpd || !allocate_vmid);
@@ -171,8 +156,8 @@ static int create_queue_nocpsch(struct device_queue_manager *dqm, struct queue *
 	q->properties.vmid = qpd->vmid;
 
 	set = false;
-	for (pipe = dqm->next_pipe_to_allocate; pipe < get_pipes_num(dqm);
-			pipe = (pipe + 1) % get_pipes_num(dqm)) {
+	for (i = 0, pipe = dqm->next_pipe_to_allocate; i < get_pipes_num(dqm);
+			pipe = (pipe + i++) % get_pipes_num(dqm)) {
 		if (dqm->allocated_queues[pipe] != 0) {
 			bit = find_first_bit((unsigned long *)&dqm->allocated_queues[pipe], QUEUES_PER_PIPE);
 			clear_bit(bit, (unsigned long *)&dqm->allocated_queues[pipe]);
@@ -238,9 +223,7 @@ static int destroy_queue_nocpsch(struct device_queue_manager *dqm, struct qcm_pr
 		retval = -ENOMEM;
 		goto out;
 	}
-	mqd->acquire_hqd(mqd, q->pipe, q->queue, 0);
-	retval = mqd->destroy_mqd(mqd, q->mqd, KFD_PREEMPT_TYPE_WAVEFRONT, QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS);
-	mqd->release_hqd(mqd);
+	retval = mqd->destroy_mqd(mqd, false, QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS, q->pipe, q->queue);
 	if (retval != 0)
 		goto out;
 
@@ -299,12 +282,7 @@ static int destroy_queues_nocpsch(struct device_queue_manager *dqm)
 
 	list_for_each_entry(cur, &dqm->queues, list) {
 		list_for_each_entry(q, &cur->qpd->queues_list, list) {
-
-
-			mqd->acquire_hqd(mqd, q->pipe, q->queue, 0);
-			mqd->destroy_mqd(mqd, q->mqd, KFD_PREEMPT_TYPE_WAVEFRONT,
-					QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS);
-			mqd->release_hqd(mqd);
+			mqd->destroy_mqd(mqd, false, QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS, q->pipe, q->queue);
 		}
 	}
 
@@ -352,10 +330,9 @@ static int execute_queues_nocpsch(struct device_queue_manager *dqm)
 		qpd = node->qpd;
 		list_for_each_entry(q, &qpd->queues_list, list) {
 			pr_debug("kfd: executing queue (%d, %d)\n", q->pipe, q->queue);
-			mqd->acquire_hqd(mqd, q->pipe, q->queue, 0);
-			if (mqd->is_occupied(mqd, q->mqd, &q->properties) == false)
-				mqd->load_mqd(mqd, q->mqd);
-			mqd->release_hqd(mqd);
+			if (mqd->is_occupied(mqd, q->properties.queue_address, q->pipe, q->queue) == false &&
+					q->properties.is_active == true)
+				mqd->load_mqd(mqd, q->mqd, q->pipe, q->queue, q->properties.write_ptr);
 		}
 	}
 
@@ -420,25 +397,9 @@ out:
 static int
 set_pasid_vmid_mapping(struct device_queue_manager *dqm, unsigned int pasid, unsigned int vmid)
 {
-	/* We have to assume that there is no outstanding mapping.
-	 * The ATC_VMID_PASID_MAPPING_UPDATE_STATUS bit could be 0 because a mapping
-	 * is in progress or because a mapping finished and the SW cleared it.
-	 * So the protocol is to always wait & clear.
-	 */
 	uint32_t pasid_mapping;
-
-	BUG_ON(!dqm);
-
-	pr_debug("kfd: In %s set pasid: %d to vmid: %d\n", __func__, pasid, vmid);
 	pasid_mapping = (pasid == 0) ? 0 : (uint32_t)pasid | ATC_VMID_PASID_MAPPING_VALID;
-
-	WRITE_REG(dqm->dev, ATC_VMID0_PASID_MAPPING + vmid*sizeof(uint32_t), pasid_mapping);
-
-	while (!(READ_REG(dqm->dev, ATC_VMID_PASID_MAPPING_UPDATE_STATUS) & (1U << vmid)))
-		cpu_relax();
-	WRITE_REG(dqm->dev, ATC_VMID_PASID_MAPPING_UPDATE_STATUS, 1U << vmid);
-
-	return 0;
+	return kfd2kgd->set_pasid_vmid_mapping(dqm->dev->kgd, pasid_mapping, vmid);
 }
 
 static uint32_t compute_sh_mem_bases_64bit(unsigned int top_address_nybble)
@@ -463,46 +424,18 @@ static uint32_t compute_sh_mem_bases_64bit(unsigned int top_address_nybble)
 
 static int init_memory(struct device_queue_manager *dqm)
 {
-	int i;
-	struct mqd_manager *mqd;
-
-	BUG_ON(!dqm);
-
-	pr_debug("kfd: In func %s\n", __func__);
-	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_COMPUTE);
-	if (mqd == NULL)
-		return -ENOMEM;
-	for (i = 0; i < 16; i++) {
-		uint32_t sh_mem_config;
+	int i, retval;
 
-		mqd->acquire_hqd(mqd, 0, 0, i);
+	for (i = 8; i < 16; i++)
 		set_pasid_vmid_mapping(dqm, 0, i);
 
-		sh_mem_config = ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED);
-		sh_mem_config |= DEFAULT_MTYPE(MTYPE_NONCACHED);
-
-		WRITE_REG(dqm->dev, SH_MEM_CONFIG, sh_mem_config);
-
-		/* Configure apertures:
-		 * LDS:         0x60000000'00000000 - 0x60000001'00000000 (4GB)
-		 * Scratch:     0x60000001'00000000 - 0x60000002'00000000 (4GB)
-		 * GPUVM:       0x60010000'00000000 - 0x60020000'00000000 (1TB)
-		 */
-		WRITE_REG(dqm->dev, SH_MEM_BASES, compute_sh_mem_bases_64bit(6));
-
-		/* Scratch aperture is not supported for now. */
-		WRITE_REG(dqm->dev, SH_STATIC_MEM_CONFIG, 0);
-
-		/* APE1 disabled for now. */
-		WRITE_REG(dqm->dev, SH_MEM_APE1_BASE, 1);
-		WRITE_REG(dqm->dev, SH_MEM_APE1_LIMIT, 0);
-
-		mqd->release_hqd(mqd);
-	}
-	is_mem_initialized = true;
-	return 0;
+	retval = kfd2kgd->init_memory(dqm->dev->kgd);
+	if (retval == 0)
+		is_mem_initialized = true;
+	return retval;
 }
 
+
 static int init_pipelines(struct device_queue_manager *dqm, unsigned int pipes_num, unsigned int first_pipe)
 {
 	void *hpdptr;
@@ -552,13 +485,7 @@ static int init_pipelines(struct device_queue_manager *dqm, unsigned int pipes_n
 		inx = i + first_pipe;
 		pipe_hpd_addr = dqm->pipelines_addr + i * CIK_HPD_SIZE;
 		pr_debug("kfd: pipeline address %llX\n", pipe_hpd_addr);
-
-		mqd->acquire_hqd(mqd, inx, 0, 0);
-		WRITE_REG(dqm->dev, CP_HPD_EOP_BASE_ADDR, lower_32(pipe_hpd_addr >> 8));
-		WRITE_REG(dqm->dev, CP_HPD_EOP_BASE_ADDR_HI, upper_32(pipe_hpd_addr >> 8));
-		WRITE_REG(dqm->dev, CP_HPD_EOP_VMID, 0);
-		WRITE_REG(dqm->dev, CP_HPD_EOP_CONTROL, CIK_HPD_SIZE_LOG2 - 1);
-		mqd->release_hqd(mqd);
+		kfd2kgd->init_pipeline(dqm->dev->kgd, i, CIK_HPD_SIZE_LOG2, pipe_hpd_addr);
 	}
 
 	return 0;
@@ -925,7 +852,6 @@ static bool set_cache_memory_policy(struct device_queue_manager *dqm,
 	uint32_t ape1_mtype;
 
 	pr_debug("kfd: In func %s\n", __func__);
-
 	mutex_lock(&dqm->lock);
 
 	if (alternate_aperture_size == 0) {
@@ -954,6 +880,7 @@ static bool set_cache_memory_policy(struct device_queue_manager *dqm,
 
 		qpd->sh_mem_ape1_base = base >> 16;
 		qpd->sh_mem_ape1_limit = limit >> 16;
+
 	}
 
 	default_mtype = (default_policy == cache_policy_coherent) ?
diff --git a/drivers/gpu/hsa/radeon/kfd_kernel_queue.c b/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
index ce3261b..315d48e 100644
--- a/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
+++ b/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
@@ -108,10 +108,7 @@ static bool initialize(struct kernel_queue *kq, struct kfd_dev *dev,
 		pr_debug("assigning hiq to hqd\n");
 		kq->queue->pipe = KFD_CIK_HIQ_PIPE;
 		kq->queue->queue = KFD_CIK_HIQ_QUEUE;
-
-		kq->mqd->acquire_hqd(kq->mqd, kq->queue->pipe, kq->queue->queue, 0);
-		kq->mqd->load_mqd(kq->mqd, kq->queue->mqd);
-		kq->mqd->release_hqd(kq->mqd);
+		kq->mqd->load_mqd(kq->mqd, kq->queue->mqd, kq->queue->pipe, kq->queue->queue, NULL);
 	} else {
 		/* allocate fence for DIQ */
 		retval = radeon_kfd_vidmem_alloc_map(
@@ -152,9 +149,10 @@ static void uninitialize(struct kernel_queue *kq)
 
 	if (kq->queue->properties.type == KFD_QUEUE_TYPE_HIQ)
 		kq->mqd->destroy_mqd(kq->mqd,
-					kq->queue->mqd,
-					KFD_PREEMPT_TYPE_WAVEFRONT,
-					QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS);
+					false,
+					QUEUE_PREEMPT_DEFAULT_TIMEOUT_MS,
+					kq->queue->pipe,
+					kq->queue->queue);
 
 	radeon_kfd_vidmem_free_unmap(kq->dev, kq->rptr_mem);
 	radeon_kfd_vidmem_free_unmap(kq->dev, kq->wptr_mem);
diff --git a/drivers/gpu/hsa/radeon/kfd_mqd_manager.c b/drivers/gpu/hsa/radeon/kfd_mqd_manager.c
index 8c1192e..45e3fd0 100644
--- a/drivers/gpu/hsa/radeon/kfd_mqd_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_mqd_manager.c
@@ -108,59 +108,10 @@ static void uninit_mqd(struct mqd_manager *mm, void *mqd, kfd_mem_obj mqd_mem_ob
 	radeon_kfd_vidmem_free_unmap(mm->dev, mqd_mem_obj);
 }
 
-static int load_mqd(struct mqd_manager *mm, void *mqd)
+static int load_mqd(struct mqd_manager *mm, void *mqd, uint32_t pipe_id, uint32_t queue_id, uint32_t __user *wptr)
 {
-	struct cik_mqd *m;
-
-	BUG_ON(!mm || !mqd);
-
-	m = get_mqd(mqd);
-
-	WRITE_REG(mm->dev, CP_MQD_BASE_ADDR, m->queue_state.cp_mqd_base_addr);
-	WRITE_REG(mm->dev, CP_MQD_BASE_ADDR_HI, m->queue_state.cp_mqd_base_addr_hi);
-	WRITE_REG(mm->dev, CP_MQD_CONTROL, m->queue_state.cp_mqd_control);
-
-	WRITE_REG(mm->dev, CP_HQD_PQ_BASE, m->queue_state.cp_hqd_pq_base);
-	WRITE_REG(mm->dev, CP_HQD_PQ_BASE_HI, m->queue_state.cp_hqd_pq_base_hi);
-	WRITE_REG(mm->dev, CP_HQD_PQ_CONTROL, m->queue_state.cp_hqd_pq_control);
-
-	WRITE_REG(mm->dev, CP_HQD_IB_CONTROL, m->queue_state.cp_hqd_ib_control);
-	WRITE_REG(mm->dev, CP_HQD_IB_BASE_ADDR, m->queue_state.cp_hqd_ib_base_addr);
-	WRITE_REG(mm->dev, CP_HQD_IB_BASE_ADDR_HI, m->queue_state.cp_hqd_ib_base_addr_hi);
-
-	WRITE_REG(mm->dev, CP_HQD_IB_RPTR, m->queue_state.cp_hqd_ib_rptr);
-
-	WRITE_REG(mm->dev, CP_HQD_PERSISTENT_STATE, m->queue_state.cp_hqd_persistent_state);
-	WRITE_REG(mm->dev, CP_HQD_SEMA_CMD, m->queue_state.cp_hqd_sema_cmd);
-	WRITE_REG(mm->dev, CP_HQD_MSG_TYPE, m->queue_state.cp_hqd_msg_type);
-
-	WRITE_REG(mm->dev, CP_HQD_ATOMIC0_PREOP_LO, m->queue_state.cp_hqd_atomic0_preop_lo);
-	WRITE_REG(mm->dev, CP_HQD_ATOMIC0_PREOP_HI, m->queue_state.cp_hqd_atomic0_preop_hi);
-	WRITE_REG(mm->dev, CP_HQD_ATOMIC1_PREOP_LO, m->queue_state.cp_hqd_atomic1_preop_lo);
-	WRITE_REG(mm->dev, CP_HQD_ATOMIC1_PREOP_HI, m->queue_state.cp_hqd_atomic1_preop_hi);
-
-	WRITE_REG(mm->dev, CP_HQD_PQ_RPTR_REPORT_ADDR, m->queue_state.cp_hqd_pq_rptr_report_addr);
-	WRITE_REG(mm->dev, CP_HQD_PQ_RPTR_REPORT_ADDR_HI, m->queue_state.cp_hqd_pq_rptr_report_addr_hi);
-	WRITE_REG(mm->dev, CP_HQD_PQ_RPTR, m->queue_state.cp_hqd_pq_rptr);
-
-	WRITE_REG(mm->dev, CP_HQD_PQ_WPTR_POLL_ADDR, m->queue_state.cp_hqd_pq_wptr_poll_addr);
-	WRITE_REG(mm->dev, CP_HQD_PQ_WPTR_POLL_ADDR_HI, m->queue_state.cp_hqd_pq_wptr_poll_addr_hi);
-
-	WRITE_REG(mm->dev, CP_HQD_PQ_DOORBELL_CONTROL, m->queue_state.cp_hqd_pq_doorbell_control);
-
-	WRITE_REG(mm->dev, CP_HQD_VMID, m->queue_state.cp_hqd_vmid);
+	return kfd2kgd->hqd_load(mm->dev->kgd, mqd, pipe_id, queue_id, wptr);
 
-	WRITE_REG(mm->dev, CP_HQD_QUANTUM, m->queue_state.cp_hqd_quantum);
-
-	WRITE_REG(mm->dev, CP_HQD_PIPE_PRIORITY, m->queue_state.cp_hqd_pipe_priority);
-	WRITE_REG(mm->dev, CP_HQD_QUEUE_PRIORITY, m->queue_state.cp_hqd_queue_priority);
-
-	WRITE_REG(mm->dev, CP_HQD_HQ_SCHEDULER0, m->queue_state.cp_hqd_hq_scheduler0);
-	WRITE_REG(mm->dev, CP_HQD_HQ_SCHEDULER1, m->queue_state.cp_hqd_hq_scheduler1);
-
-	WRITE_REG(mm->dev, CP_HQD_ACTIVE, m->queue_state.cp_hqd_active);
-
-	return 0;
 }
 
 static int update_mqd(struct mqd_manager *mm, void *mqd, struct queue_properties *q)
@@ -195,117 +146,16 @@ static int update_mqd(struct mqd_manager *mm, void *mqd, struct queue_properties
 	return 0;
 }
 
-static int destroy_mqd(struct mqd_manager *mm, void *mqd, enum kfd_preempt_type type, unsigned int timeout)
-{
-	int status;
-	uint32_t temp;
-	bool sync;
-
-	status = 0;
-	BUG_ON(!mm || !mqd);
-
-	pr_debug("kfd: In func %s\n", __func__);
-
-	WRITE_REG(mm->dev, CP_HQD_PQ_DOORBELL_CONTROL, 0);
-
-	if (type == KFD_PREEMPT_TYPE_WAVEFRONT_RESET)
-		WRITE_REG(mm->dev, CP_HQD_DEQUEUE_REQUEST, DEQUEUE_REQUEST_RESET);
-	else
-		WRITE_REG(mm->dev, CP_HQD_DEQUEUE_REQUEST, DEQUEUE_REQUEST_DRAIN);
-
-	sync = (timeout > 0);
-	temp = timeout;
-
-	while (READ_REG(mm->dev, CP_HQD_ACTIVE) != 0) {
-		if (sync && timeout <= 0) {
-			status = -EBUSY;
-			pr_err("kfd: cp queue preemption time out (%dms)\n", temp);
-			break;
-		}
-		busy_wait(1000);
-		if (sync)
-			timeout--;
-	}
-
-	return status;
-}
-
-static inline uint32_t make_srbm_gfx_cntl_mpqv(unsigned int me,
-						unsigned int pipe,
-						unsigned int queue,
-						unsigned int vmid)
+static int destroy_mqd(struct mqd_manager *mm, bool is_reset, unsigned int timeout, uint32_t pipe_id, uint32_t queue_id)
 {
-	return QUEUEID(queue) | VMID(vmid) | MEID(me) | PIPEID(pipe);
+	return kfd2kgd->hqd_destroy(mm->dev->kgd, is_reset, timeout, pipe_id, queue_id);
 }
 
-static inline uint32_t get_first_pipe_offset(struct mqd_manager *mm)
+bool is_occupied(struct mqd_manager *mm, uint64_t queue_address, uint32_t pipe_id, uint32_t queue_id)
 {
-	BUG_ON(!mm);
-	return mm->dev->shared_resources.first_compute_pipe;
-}
-
-static void acquire_hqd(struct mqd_manager *mm, unsigned int pipe, unsigned int queue, unsigned int vmid)
-{
-	unsigned int mec, pipe_in_mec;
-
-	BUG_ON(!mm);
-
-	radeon_kfd_lock_srbm_index(mm->dev);
-
-	pipe_in_mec = (pipe + get_first_pipe_offset(mm)) % 4;
-	mec = (pipe + get_first_pipe_offset(mm)) / 4;
-	mec++;
-
-	pr_debug("kfd: acquire mec: %d pipe: %d queue: %d vmid: %d\n",
-			mec,
-			pipe_in_mec,
-			queue,
-			vmid);
-
-	WRITE_REG(mm->dev, SRBM_GFX_CNTL, make_srbm_gfx_cntl_mpqv(mec,
-			pipe_in_mec, queue, vmid));
-}
-
-static void release_hqd(struct mqd_manager *mm)
-{
-	BUG_ON(!mm);
-	/* Be nice to KGD, reset indexed CP registers to the GFX pipe. */
-	WRITE_REG(mm->dev, SRBM_GFX_CNTL, 0);
-	radeon_kfd_unlock_srbm_index(mm->dev);
-}
-
-bool is_occupied(struct mqd_manager *mm, void *mqd, struct queue_properties *q)
-{
-	int act;
-	struct cik_mqd *m;
-	uint32_t low, high;
 
-	BUG_ON(!mm || !mqd || !q);
+	return kfd2kgd->hqd_is_occupies(mm->dev->kgd, queue_address, pipe_id, queue_id);
 
-	m = get_mqd(mqd);
-
-	act = READ_REG(mm->dev, CP_HQD_ACTIVE);
-	if (act) {
-		low = lower_32((uint64_t)q->queue_address >> 8);
-		high = upper_32((uint64_t)q->queue_address >> 8);
-
-		if (low == READ_REG(mm->dev, CP_HQD_PQ_BASE) &&
-			high == READ_REG(mm->dev, CP_HQD_PQ_BASE_HI))
-			return true;
-	}
-
-	return false;
-}
-
-static int initialize(struct mqd_manager *mm)
-{
-	BUG_ON(!mm);
-	return 0;
-}
-
-static void uninitialize(struct mqd_manager *mm)
-{
-	BUG_ON(!mm);
 }
 
 /*
@@ -418,11 +268,7 @@ struct mqd_manager *mqd_manager_init(enum KFD_MQD_TYPE type, struct kfd_dev *dev
 		mqd->load_mqd = load_mqd;
 		mqd->update_mqd = update_mqd;
 		mqd->destroy_mqd = destroy_mqd;
-		mqd->acquire_hqd = acquire_hqd;
-		mqd->release_hqd = release_hqd;
 		mqd->is_occupied = is_occupied;
-		mqd->initialize = initialize;
-		mqd->uninitialize = uninitialize;
 		break;
 	case KFD_MQD_TYPE_CIK_HIQ:
 		mqd->init_mqd = init_mqd_hiq;
@@ -430,11 +276,7 @@ struct mqd_manager *mqd_manager_init(enum KFD_MQD_TYPE type, struct kfd_dev *dev
 		mqd->load_mqd = load_mqd;
 		mqd->update_mqd = update_mqd_hiq;
 		mqd->destroy_mqd = destroy_mqd;
-		mqd->acquire_hqd = acquire_hqd;
-		mqd->release_hqd = release_hqd;
 		mqd->is_occupied = is_occupied;
-		mqd->initialize = initialize;
-		mqd->uninitialize = uninitialize;
 		break;
 	default:
 		kfree(mqd);
@@ -442,11 +284,6 @@ struct mqd_manager *mqd_manager_init(enum KFD_MQD_TYPE type, struct kfd_dev *dev
 		break;
 	}
 
-	if (mqd->initialize(mqd) != 0) {
-		pr_err("kfd: mqd manager initialization failed\n");
-		kfree(mqd);
-		return NULL;
-	}
 	return mqd;
 }
 
diff --git a/drivers/gpu/hsa/radeon/kfd_mqd_manager.h b/drivers/gpu/hsa/radeon/kfd_mqd_manager.h
index 314d490..a6b0007 100644
--- a/drivers/gpu/hsa/radeon/kfd_mqd_manager.h
+++ b/drivers/gpu/hsa/radeon/kfd_mqd_manager.h
@@ -27,21 +27,28 @@
 #include "kfd_priv.h"
 
 struct mqd_manager {
-	int	(*init_mqd)(struct mqd_manager *mm, void **mqd, kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
-			    struct queue_properties *q);
-	int	(*load_mqd)(struct mqd_manager *mm, void *mqd);
-	int	(*update_mqd)(struct mqd_manager *mm, void *mqd, struct queue_properties *q);
-	int	(*destroy_mqd)(struct mqd_manager *mm, void *mqd, enum kfd_preempt_type type, unsigned int timeout);
-	void	(*uninit_mqd)(struct mqd_manager *mm, void *mqd, kfd_mem_obj mqd_mem_obj);
-	void	(*acquire_hqd)(struct mqd_manager *mm, unsigned int pipe, unsigned int queue, unsigned int vmid);
-	void	(*release_hqd)(struct mqd_manager *mm);
-	bool	(*is_occupied)(struct mqd_manager *mm, void *mqd, struct queue_properties *q);
-	int	(*initialize)(struct mqd_manager *mm);
-	void	(*uninitialize)(struct mqd_manager *mm);
-
-	struct mutex		mqd_mutex;
-	struct kfd_dev		*dev;
-};
+	int	(*init_mqd)(struct mqd_manager *mm, void **mqd,
+			kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
+			struct queue_properties *q);
+
+	int	(*load_mqd)(struct mqd_manager *mm, void *mqd,
+				uint32_t pipe_id, uint32_t queue_id,
+				uint32_t __user *wptr);
+
+	int	(*update_mqd)(struct mqd_manager *mm, void *mqd,
+				struct queue_properties *q);
 
+	int	(*destroy_mqd)(struct mqd_manager *mm, bool is_reset,
+				unsigned int timeout, uint32_t pipe_id,
+				uint32_t queue_id);
+
+	void	(*uninit_mqd)(struct mqd_manager *mm, void *mqd,
+				kfd_mem_obj mqd_mem_obj);
+	bool	(*is_occupied)(struct mqd_manager *mm, uint64_t queue_address,
+				uint32_t pipe_id, uint32_t queue_id);
+
+	struct mutex	mqd_mutex;
+	struct kfd_dev	*dev;
+};
 
 #endif /* KFD_MQD_MANAGER_H_ */
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index b61187a..be77ca8 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -100,8 +100,6 @@ struct kfd_dev {
 	const struct kfd_device_info *device_info;
 	struct pci_dev *pdev;
 
-	void __iomem *regs;
-
 	bool init_complete;
 
 	unsigned int id;		/* topology stub index */
@@ -148,11 +146,6 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd);
 
 extern const struct kfd2kgd_calls *kfd2kgd;
 
-
-/* KFD2KGD callback wrappers */
-void radeon_kfd_lock_srbm_index(struct kfd_dev *kfd);
-void radeon_kfd_unlock_srbm_index(struct kfd_dev *kfd);
-
 enum kfd_mempool {
 	KFD_MEMPOOL_SYSTEM_CACHEABLE = 1,
 	KFD_MEMPOOL_SYSTEM_WRITECOMBINE = 2,
@@ -198,11 +191,6 @@ enum kfd_preempt_type_filter {
 	KFD_PRERMPT_TYPE_FILTER_BY_PASID
 };
 
-enum kfd_preempt_type {
-	KFD_PREEMPT_TYPE_WAVEFRONT,
-	KFD_PREEMPT_TYPE_WAVEFRONT_RESET
-};
-
 enum kfd_queue_type  {
 	KFD_QUEUE_TYPE_COMPUTE,
 	KFD_QUEUE_TYPE_SDMA,
@@ -406,12 +394,6 @@ struct kfd_dev *radeon_kfd_device_by_id(uint32_t gpu_id);
 struct kfd_dev *radeon_kfd_device_by_pci_dev(const struct pci_dev *pdev);
 struct kfd_dev *kfd_topology_enum_kfd_devices(uint8_t idx);
 
-/* MMIO registers */
-#define WRITE_REG(dev, reg, value) radeon_kfd_write_reg((dev), (reg), (value))
-#define READ_REG(dev, reg) radeon_kfd_read_reg((dev), (reg))
-void radeon_kfd_write_reg(struct kfd_dev *dev, uint32_t reg, uint32_t value);
-uint32_t radeon_kfd_read_reg(struct kfd_dev *dev, uint32_t reg);
-
 /* Interrupts */
 int radeon_kfd_interrupt_init(struct kfd_dev *dev);
 void radeon_kfd_interrupt_exit(struct kfd_dev *dev);
diff --git a/drivers/gpu/hsa/radeon/kfd_registers.c b/drivers/gpu/hsa/radeon/kfd_registers.c
deleted file mode 100644
index 223debd..0000000
--- a/drivers/gpu/hsa/radeon/kfd_registers.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * Copyright 2014 Advanced Micro Devices, Inc.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
- * OTHER DEALINGS IN THE SOFTWARE.
- */
-
-#include <linux/io.h>
-#include "kfd_priv.h"
-
-/* In KFD, "reg" is the byte offset of the register. */
-static void __iomem *reg_address(struct kfd_dev *dev, uint32_t reg)
-{
-	return dev->regs + reg;
-}
-
-void radeon_kfd_write_reg(struct kfd_dev *dev, uint32_t reg, uint32_t value)
-{
-	writel(value, reg_address(dev, reg));
-}
-
-uint32_t radeon_kfd_read_reg(struct kfd_dev *dev, uint32_t reg)
-{
-	return readl(reg_address(dev, reg));
-}
-
-void radeon_kfd_lock_srbm_index(struct kfd_dev *dev)
-{
-	kfd2kgd->lock_srbm_gfx_cntl(dev->kgd);
-}
-
-void radeon_kfd_unlock_srbm_index(struct kfd_dev *dev)
-{
-	kfd2kgd->unlock_srbm_gfx_cntl(dev->kgd);
-}
-- 
1.9.1

