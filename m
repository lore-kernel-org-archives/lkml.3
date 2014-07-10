Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaGJWFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:05:55 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:53776 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaGJVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:57 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 48/83] hsa/radeon: Add mqd_manager module
Date: Fri, 11 Jul 2014 00:54:04 +0300
Message-Id: <1405029279-6894-20-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

The mqd_manager module handles MQD data structures. MQD stands for Memory Queue
Descriptor, which is used by the H/W to keep the HSA queue state in memory.

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/Makefile               |   2 +-
 drivers/gpu/hsa/radeon/cik_mqds.h             | 251 ++++++++++++++
 drivers/gpu/hsa/radeon/cik_regs.h             |   1 +
 drivers/gpu/hsa/radeon/kfd_mqd_manager.c      | 453 ++++++++++++++++++++++++++
 drivers/gpu/hsa/radeon/kfd_mqd_manager.h      |  48 +++
 drivers/gpu/hsa/radeon/kfd_priv.h             |  26 ++
 drivers/gpu/hsa/radeon/kfd_sched_cik_static.c |  10 -
 drivers/gpu/hsa/radeon/kfd_vidmem.c           |  36 ++
 8 files changed, 816 insertions(+), 11 deletions(-)
 create mode 100644 drivers/gpu/hsa/radeon/cik_mqds.h
 create mode 100644 drivers/gpu/hsa/radeon/kfd_mqd_manager.c
 create mode 100644 drivers/gpu/hsa/radeon/kfd_mqd_manager.h

diff --git a/drivers/gpu/hsa/radeon/Makefile b/drivers/gpu/hsa/radeon/Makefile
index 18e1639..c87b518 100644
--- a/drivers/gpu/hsa/radeon/Makefile
+++ b/drivers/gpu/hsa/radeon/Makefile
@@ -6,6 +6,6 @@ radeon_kfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o \
 		kfd_pasid.o kfd_topology.o kfd_process.o \
 		kfd_doorbell.o kfd_sched_cik_static.o kfd_registers.o \
 		kfd_vidmem.o kfd_interrupt.o kfd_aperture.o \
-		kfd_queue.o kfd_hw_pointer_store.o
+		kfd_queue.o kfd_hw_pointer_store.o kfd_mqd_manager.o
 
 obj-$(CONFIG_HSA_RADEON)	+= radeon_kfd.o
diff --git a/drivers/gpu/hsa/radeon/cik_mqds.h b/drivers/gpu/hsa/radeon/cik_mqds.h
new file mode 100644
index 0000000..58945c8
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/cik_mqds.h
@@ -0,0 +1,251 @@
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
+ * Author: Ben Goz
+ */
+
+#ifndef CIK_MQDS_H_
+#define CIK_MQDS_H_
+
+#pragma pack(push, 4)
+
+struct cik_hpd_registers {
+	u32 cp_hpd_roq_offsets;
+	u32 cp_hpd_eop_base_addr;
+	u32 cp_hpd_eop_base_addr_hi;
+	u32 cp_hpd_eop_vmid;
+	u32 cp_hpd_eop_control;
+};
+
+struct cik_hqd_registers {
+	u32 cp_mqd_base_addr;
+	u32 cp_mqd_base_addr_hi;
+	u32 cp_hqd_active;
+	u32 cp_hqd_vmid;
+	u32 cp_hqd_persistent_state;
+	u32 cp_hqd_pipe_priority;
+	u32 cp_hqd_queue_priority;
+	u32 cp_hqd_quantum;
+	u32 cp_hqd_pq_base;
+	u32 cp_hqd_pq_base_hi;
+	u32 cp_hqd_pq_rptr;
+	u32 cp_hqd_pq_rptr_report_addr;
+	u32 cp_hqd_pq_rptr_report_addr_hi;
+	u32 cp_hqd_pq_wptr_poll_addr;
+	u32 cp_hqd_pq_wptr_poll_addr_hi;
+	u32 cp_hqd_pq_doorbell_control;
+	u32 cp_hqd_pq_wptr;
+	u32 cp_hqd_pq_control;
+	u32 cp_hqd_ib_base_addr;
+	u32 cp_hqd_ib_base_addr_hi;
+	u32 cp_hqd_ib_rptr;
+	u32 cp_hqd_ib_control;
+	u32 cp_hqd_iq_timer;
+	u32 cp_hqd_iq_rptr;
+	u32 cp_hqd_dequeue_request;
+	u32 cp_hqd_dma_offload;
+	u32 cp_hqd_sema_cmd;
+	u32 cp_hqd_msg_type;
+	u32 cp_hqd_atomic0_preop_lo;
+	u32 cp_hqd_atomic0_preop_hi;
+	u32 cp_hqd_atomic1_preop_lo;
+	u32 cp_hqd_atomic1_preop_hi;
+	u32 cp_hqd_hq_scheduler0;
+	u32 cp_hqd_hq_scheduler1;
+	u32 cp_mqd_control;
+};
+
+struct cik_mqd {
+	u32 header;
+	u32 dispatch_initiator;
+	u32 dimensions[3];
+	u32 start_idx[3];
+	u32 num_threads[3];
+	u32 pipeline_stat_enable;
+	u32 perf_counter_enable;
+	u32 pgm[2];
+	u32 tba[2];
+	u32 tma[2];
+	u32 pgm_rsrc[2];
+	u32 vmid;
+	u32 resource_limits;
+	u32 static_thread_mgmt01[2];
+	u32 tmp_ring_size;
+	u32 static_thread_mgmt23[2];
+	u32 restart[3];
+	u32 thread_trace_enable;
+	u32 reserved1;
+	u32 user_data[16];
+	u32 vgtcs_invoke_count[2];
+	struct cik_hqd_registers queue_state;
+	u32 dequeue_cntr;
+	u32 interrupt_queue[64];
+};
+
+/* This structure represents mqd used for cp scheduling queue
+ * taken from Gfx72_cp_program_spec.pdf
+ */
+struct cik_compute_mqd {
+	u32 header;
+	u32 compute_dispatch_initiator;
+	u32 compute_dim_x;
+	u32 compute_dim_y;
+	u32 compute_dim_z;
+	u32 compute_start_x;
+	u32 compute_start_y;
+	u32 compute_start_z;
+	u32 compute_num_thread_x;
+	u32 compute_num_thread_y;
+	u32 compute_num_thread_z;
+	u32 compute_pipelinestat_enable;
+	u32 compute_perfcount_enable;
+	u32 compute_pgm_lo;
+	u32 compute_pgm_hi;
+	u32 compute_tba_lo;
+	u32 compute_tba_hi;
+	u32 compute_tma_lo;
+	u32 compute_tma_hi;
+	u32 compute_pgm_rsrc1;
+	u32 compute_pgm_rsrc2;
+	u32 compute_vmid;
+	u32 compute_resource_limits;
+	u32 compute_static_thread_mgmt_se0;
+	u32 compute_static_thread_mgmt_se1;
+	u32 compute_tmpring_size;
+	u32 compute_static_thread_mgmt_se2;
+	u32 compute_static_thread_mgmt_se3;
+	u32 compute_restart_x;
+	u32 compute_restart_y;
+	u32 compute_restart_z;
+	u32 compute_thread_trace_enable;
+	u32 compute_misc_reserved;
+	u32 compute_user_data[16];
+	u32 vgt_csinvoc_count_lo;
+	u32 vgt_csinvoc_count_hi;
+	u32 cp_mqd_base_addr51;
+	u32 cp_mqd_base_addr_hi;
+	u32 cp_hqd_active;
+	u32 cp_hqd_vmid;
+	u32 cp_hqd_persistent_state;
+	u32 cp_hqd_pipe_priority;
+	u32 cp_hqd_queue_priority;
+	u32 cp_hqd_quantum;
+	u32 cp_hqd_pq_base;
+	u32 cp_hqd_pq_base_hi;
+	u32 cp_hqd_pq_rptr;
+	u32 cp_hqd_pq_rptr_report_addr;
+	u32 cp_hqd_pq_rptr_report_addr_hi;
+	u32 cp_hqd_pq_wptr_poll_addr;
+	u32 cp_hqd_pq_wptr_poll_addr_hi;
+	u32 cp_hqd_pq_doorbell_control;
+	u32 cp_hqd_pq_wptr;
+	u32 cp_hqd_pq_control;
+	u32 cp_hqd_ib_base_addr;
+	u32 cp_hqd_ib_base_addr_hi;
+	u32 cp_hqd_ib_rptr;
+	u32 cp_hqd_ib_control;
+	u32 cp_hqd_iq_timer;
+	u32 cp_hqd_iq_rptr;
+	u32 cp_hqd_dequeue_request;
+	u32 cp_hqd_dma_offload;
+	u32 cp_hqd_sema_cmd;
+	u32 cp_hqd_msg_type;
+	u32 cp_hqd_atomic0_preop_lo;
+	u32 cp_hqd_atomic0_preop_hi;
+	u32 cp_hqd_atomic1_preop_lo;
+	u32 cp_hqd_atomic1_preop_hi;
+	u32 cp_hqd_hq_scheduler0;
+	u32 cp_hqd_hq_scheduler1;
+	u32 cp_mqd_control;
+	u32 reserved1[10];
+	u32 cp_mqd_query_time_lo;
+	u32 cp_mqd_query_time_hi;
+	u32 reserved2[4];
+	u32 cp_mqd_connect_start_time_lo;
+	u32 cp_mqd_connect_start_time_hi;
+	u32 cp_mqd_connect_end_time_lo;
+	u32 cp_mqd_connect_end_time_hi;
+	u32 cp_mqd_connect_end_wf_count;
+	u32 cp_mqd_connect_end_pq_rptr;
+	u32 cp_mqd_connect_end_pq_wptr;
+	u32 cp_mqd_connect_end_ib_rptr;
+	u32 reserved3[18];
+};
+
+/* This structure represents all *IQs
+ * Taken from Gfx73_CPC_Eng_Init_Prog.pdf
+ */
+struct cik_interface_mqd {
+	u32 reserved1[128];
+	u32 cp_mqd_base_addr;
+	u32 cp_mqd_base_addr_hi;
+	u32 cp_hqd_active;
+	u32 cp_hqd_vmid;
+	u32 cp_hqd_persistent_state;
+	u32 cp_hqd_pipe_priority;
+	u32 cp_hqd_queue_priority;
+	u32 cp_hqd_quantum;
+	u32 cp_hqd_pq_base;
+	u32 cp_hqd_pq_base_hi;
+	u32 cp_hqd_pq_rptr;
+	u32 cp_hqd_pq_rptr_report_addr;
+	u32 cp_hqd_pq_rptr_report_addr_hi;
+	u32 cp_hqd_pq_wptr_poll_addr;
+	u32 cp_hqd_pq_wptr_poll_addr_hi;
+	u32 cp_hqd_pq_doorbell_control;
+	u32 cp_hqd_pq_wptr;
+	u32 cp_hqd_pq_control;
+	u32 cp_hqd_ib_base_addr;
+	u32 cp_hqd_ib_base_addr_hi;
+	u32 cp_hqd_ib_rptr;
+	u32 cp_hqd_ib_control;
+	u32 cp_hqd_iq_timer;
+	u32 cp_hqd_iq_rptr;
+	u32 cp_hqd_dequeue_request;
+	u32 cp_hqd_dma_offload;
+	u32 cp_hqd_sema_cmd;
+	u32 cp_hqd_msg_type;
+	u32 cp_hqd_atomic0_preop_lo;
+	u32 cp_hqd_atomic0_preop_hi;
+	u32 cp_hqd_atomic1_preop_lo;
+	u32 cp_hqd_atomic1_preop_hi;
+	u32 cp_hqd_hq_status0;
+	u32 cp_hqd_hq_control0;
+	u32 cp_mqd_control;
+	u32 reserved2[3];
+	u32 cp_hqd_hq_status1;
+	u32 cp_hqd_hq_control1;
+	u32 reserved3[16];
+	u32 cp_hqd_hq_status2;
+	u32 cp_hqd_hq_control2;
+	u32 cp_hqd_hq_status3;
+	u32 cp_hqd_hq_control3;
+	u32 reserved4[2];
+	u32 cp_mqd_query_time_lo;
+	u32 cp_mqd_query_time_hi;
+	u32 reserved5[48];
+	u32 cp_mqd_skip_process[16];
+};
+
+#pragma pack(pop)
+
+
+#endif /* CIK_MQDS_H_ */
diff --git a/drivers/gpu/hsa/radeon/cik_regs.h b/drivers/gpu/hsa/radeon/cik_regs.h
index 93f7b34..fa5ec01 100644
--- a/drivers/gpu/hsa/radeon/cik_regs.h
+++ b/drivers/gpu/hsa/radeon/cik_regs.h
@@ -168,6 +168,7 @@
 
 #define CP_HQD_DEQUEUE_REQUEST				0xC974
 #define	DEQUEUE_REQUEST_DRAIN				1
+#define DEQUEUE_REQUEST_RESET				2
 #define		DEQUEUE_INT					(1U << 8)
 
 #define CP_HQD_SEMA_CMD					0xC97Cu
diff --git a/drivers/gpu/hsa/radeon/kfd_mqd_manager.c b/drivers/gpu/hsa/radeon/kfd_mqd_manager.c
new file mode 100644
index 0000000..14b248f
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_mqd_manager.c
@@ -0,0 +1,453 @@
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
+ * Author: Ben Goz
+ */
+
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include "kfd_priv.h"
+#include "kfd_mqd_manager.h"
+#include "cik_mqds.h"
+#include "cik_regs.h"
+
+inline uint32_t lower_32(uint64_t x)
+{
+	return (uint32_t)x;
+}
+
+inline uint32_t upper_32(uint64_t x)
+{
+	return (uint32_t)(x >> 32);
+}
+
+inline void busy_wait(unsigned long ms)
+{
+	while (time_before(jiffies, ms))
+		cpu_relax();
+}
+
+static inline struct cik_mqd *get_mqd(void *mqd)
+{
+	return (struct cik_mqd *)mqd;
+}
+
+static int init_mqd(struct mqd_manager *mm, void **mqd, kfd_mem_obj *mqd_mem_obj,
+		uint64_t *gart_addr, struct queue_properties *q)
+{
+	uint64_t addr;
+	struct cik_mqd *m;
+	int retval;
+
+	BUG_ON(!mm || !q || !mqd);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	retval = radeon_kfd_vidmem_alloc_map(
+				mm->dev,
+				mqd_mem_obj,
+				(void **)&m,
+				&addr,
+				ALIGN(sizeof(struct cik_mqd), 256));
+
+	if (retval != 0)
+		return -ENOMEM;
+
+	memset(m, 0, sizeof(struct cik_mqd));
+
+	m->header = 0xC0310800;
+	m->pipeline_stat_enable = 1;
+	m->static_thread_mgmt01[0] = 0xFFFFFFFF;
+	m->static_thread_mgmt01[1] = 0xFFFFFFFF;
+	m->static_thread_mgmt23[0] = 0xFFFFFFFF;
+	m->static_thread_mgmt23[1] = 0xFFFFFFFF;
+
+	m->queue_state.cp_hqd_persistent_state = DEFAULT_CP_HQD_PERSISTENT_STATE;
+
+	m->queue_state.cp_mqd_control             = MQD_CONTROL_PRIV_STATE_EN;
+	m->queue_state.cp_mqd_base_addr           = lower_32(addr);
+	m->queue_state.cp_mqd_base_addr_hi        = upper_32(addr);
+
+	m->queue_state.cp_hqd_ib_control = DEFAULT_MIN_IB_AVAIL_SIZE | IB_ATC_EN;
+	/* Although WinKFD writes this, I suspect it should not be necessary. */
+	m->queue_state.cp_hqd_ib_control = IB_ATC_EN | DEFAULT_MIN_IB_AVAIL_SIZE;
+
+	m->queue_state.cp_hqd_quantum = QUANTUM_EN | QUANTUM_SCALE_1MS | QUANTUM_DURATION(10);
+
+	m->queue_state.cp_hqd_pipe_priority = 1;
+	m->queue_state.cp_hqd_queue_priority = 15;
+
+	*mqd = m;
+	if (gart_addr != NULL)
+		*gart_addr = addr;
+	retval = mm->update_mqd(mm, m, q);
+
+	return retval;
+}
+
+static void uninit_mqd(struct mqd_manager *mm, void *mqd, kfd_mem_obj mqd_mem_obj)
+{
+	BUG_ON(!mm || !mqd);
+	radeon_kfd_vidmem_free_unmap(mm->dev, mqd_mem_obj);
+}
+
+static int load_mqd(struct mqd_manager *mm, void *mqd)
+{
+	struct cik_mqd *m;
+
+	BUG_ON(!mm || !mqd);
+
+	m = get_mqd(mqd);
+
+	WRITE_REG(mm->dev, CP_MQD_BASE_ADDR, m->queue_state.cp_mqd_base_addr);
+	WRITE_REG(mm->dev, CP_MQD_BASE_ADDR_HI, m->queue_state.cp_mqd_base_addr_hi);
+	WRITE_REG(mm->dev, CP_MQD_CONTROL, m->queue_state.cp_mqd_control);
+
+	WRITE_REG(mm->dev, CP_HQD_PQ_BASE, m->queue_state.cp_hqd_pq_base);
+	WRITE_REG(mm->dev, CP_HQD_PQ_BASE_HI, m->queue_state.cp_hqd_pq_base_hi);
+	WRITE_REG(mm->dev, CP_HQD_PQ_CONTROL, m->queue_state.cp_hqd_pq_control);
+
+	WRITE_REG(mm->dev, CP_HQD_IB_CONTROL, m->queue_state.cp_hqd_ib_control);
+	WRITE_REG(mm->dev, CP_HQD_IB_BASE_ADDR, m->queue_state.cp_hqd_ib_base_addr);
+	WRITE_REG(mm->dev, CP_HQD_IB_BASE_ADDR_HI, m->queue_state.cp_hqd_ib_base_addr_hi);
+
+	WRITE_REG(mm->dev, CP_HQD_IB_RPTR, m->queue_state.cp_hqd_ib_rptr);
+
+	WRITE_REG(mm->dev, CP_HQD_PERSISTENT_STATE, m->queue_state.cp_hqd_persistent_state);
+	WRITE_REG(mm->dev, CP_HQD_SEMA_CMD, m->queue_state.cp_hqd_sema_cmd);
+	WRITE_REG(mm->dev, CP_HQD_MSG_TYPE, m->queue_state.cp_hqd_msg_type);
+
+	WRITE_REG(mm->dev, CP_HQD_ATOMIC0_PREOP_LO, m->queue_state.cp_hqd_atomic0_preop_lo);
+	WRITE_REG(mm->dev, CP_HQD_ATOMIC0_PREOP_HI, m->queue_state.cp_hqd_atomic0_preop_hi);
+	WRITE_REG(mm->dev, CP_HQD_ATOMIC1_PREOP_LO, m->queue_state.cp_hqd_atomic1_preop_lo);
+	WRITE_REG(mm->dev, CP_HQD_ATOMIC1_PREOP_HI, m->queue_state.cp_hqd_atomic1_preop_hi);
+
+	WRITE_REG(mm->dev, CP_HQD_PQ_RPTR_REPORT_ADDR, m->queue_state.cp_hqd_pq_rptr_report_addr);
+	WRITE_REG(mm->dev, CP_HQD_PQ_RPTR_REPORT_ADDR_HI, m->queue_state.cp_hqd_pq_rptr_report_addr_hi);
+	WRITE_REG(mm->dev, CP_HQD_PQ_RPTR, m->queue_state.cp_hqd_pq_rptr);
+
+	WRITE_REG(mm->dev, CP_HQD_PQ_WPTR_POLL_ADDR, m->queue_state.cp_hqd_pq_wptr_poll_addr);
+	WRITE_REG(mm->dev, CP_HQD_PQ_WPTR_POLL_ADDR_HI, m->queue_state.cp_hqd_pq_wptr_poll_addr_hi);
+
+	WRITE_REG(mm->dev, CP_HQD_PQ_DOORBELL_CONTROL, m->queue_state.cp_hqd_pq_doorbell_control);
+
+	WRITE_REG(mm->dev, CP_HQD_VMID, m->queue_state.cp_hqd_vmid);
+
+	WRITE_REG(mm->dev, CP_HQD_QUANTUM, m->queue_state.cp_hqd_quantum);
+
+	WRITE_REG(mm->dev, CP_HQD_PIPE_PRIORITY, m->queue_state.cp_hqd_pipe_priority);
+	WRITE_REG(mm->dev, CP_HQD_QUEUE_PRIORITY, m->queue_state.cp_hqd_queue_priority);
+
+	WRITE_REG(mm->dev, CP_HQD_HQ_SCHEDULER0, m->queue_state.cp_hqd_hq_scheduler0);
+	WRITE_REG(mm->dev, CP_HQD_HQ_SCHEDULER1, m->queue_state.cp_hqd_hq_scheduler1);
+
+	WRITE_REG(mm->dev, CP_HQD_ACTIVE, m->queue_state.cp_hqd_active);
+
+	return 0;
+}
+
+static int update_mqd(struct mqd_manager *mm, void *mqd, struct queue_properties *q)
+{
+	struct cik_mqd *m;
+
+	BUG_ON(!mm || !q || !mqd);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	m = get_mqd(mqd);
+	m->queue_state.cp_hqd_pq_control = DEFAULT_RPTR_BLOCK_SIZE | DEFAULT_MIN_AVAIL_SIZE | PQ_ATC_EN;
+	/* calculating queue size which is log base 2 of actual queue size -1 dwords and another -1 for ffs */
+	m->queue_state.cp_hqd_pq_control |= ffs(q->queue_size / sizeof(unsigned int)) - 1 - 1;
+	m->queue_state.cp_hqd_pq_base = lower_32((uint64_t)q->queue_address >> 8);
+	m->queue_state.cp_hqd_pq_base_hi = upper_32((uint64_t)q->queue_address >> 8);
+	m->queue_state.cp_hqd_pq_rptr_report_addr = lower_32((uint64_t)q->read_ptr);
+	m->queue_state.cp_hqd_pq_rptr_report_addr_hi = upper_32((uint64_t)q->read_ptr);
+	m->queue_state.cp_hqd_pq_doorbell_control = DOORBELL_EN | DOORBELL_OFFSET(q->doorbell_off);
+
+	m->queue_state.cp_hqd_vmid = q->vmid;
+
+	m->queue_state.cp_hqd_active = 0;
+	q->is_active = false;
+	if (q->queue_size > 0 &&
+			q->queue_address != 0 &&
+			q->queue_percent > 0) {
+		m->queue_state.cp_hqd_active = 1;
+		q->is_active = true;
+	}
+
+	return 0;
+}
+
+static int destroy_mqd(struct mqd_manager *mm, void *mqd, enum kfd_preempt_type type, unsigned int timeout)
+{
+	int status;
+	uint32_t temp;
+	bool sync;
+
+	status = 0;
+	BUG_ON(!mm || !mqd);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	WRITE_REG(mm->dev, CP_HQD_PQ_DOORBELL_CONTROL, 0);
+
+	if (type == KFD_PREEMPT_TYPE_WAVEFRONT_RESET)
+		WRITE_REG(mm->dev, CP_HQD_DEQUEUE_REQUEST, DEQUEUE_REQUEST_RESET);
+	else
+		WRITE_REG(mm->dev, CP_HQD_DEQUEUE_REQUEST, DEQUEUE_REQUEST_DRAIN);
+
+	sync = (timeout > 0);
+	temp = timeout;
+
+	while (READ_REG(mm->dev, CP_HQD_ACTIVE) != 0) {
+		if (sync && timeout <= 0) {
+			status = -EBUSY;
+			pr_err("kfd: cp queue preemption time out (%dms)\n", temp);
+			break;
+		}
+		busy_wait(1000);
+		if (sync)
+			timeout--;
+	}
+
+	return status;
+}
+
+static inline uint32_t make_srbm_gfx_cntl_mpqv(unsigned int me,
+						unsigned int pipe,
+						unsigned int queue,
+						unsigned int vmid)
+{
+	return QUEUEID(queue) | VMID(vmid) | MEID(me) | PIPEID(pipe);
+}
+
+static inline uint32_t get_first_pipe_offset(struct mqd_manager *mm)
+{
+	BUG_ON(!mm);
+	return mm->dev->shared_resources.first_compute_pipe;
+}
+
+static void acquire_hqd(struct mqd_manager *mm, unsigned int pipe, unsigned int queue, unsigned int vmid)
+{
+	unsigned int mec, pipe_in_mec;
+
+	BUG_ON(!mm);
+
+	radeon_kfd_lock_srbm_index(mm->dev);
+
+	pipe_in_mec = (pipe + get_first_pipe_offset(mm)) % 4;
+	mec = (pipe + get_first_pipe_offset(mm)) / 4;
+	mec++;
+
+	pr_debug("kfd: acquire mec: %d pipe: %d queue: %d vmid: %d\n",
+			mec,
+			pipe_in_mec,
+			queue,
+			vmid);
+
+	WRITE_REG(mm->dev, SRBM_GFX_CNTL, make_srbm_gfx_cntl_mpqv(mec,
+			pipe_in_mec, queue, vmid));
+}
+
+static void release_hqd(struct mqd_manager *mm)
+{
+	BUG_ON(!mm);
+	/* Be nice to KGD, reset indexed CP registers to the GFX pipe. */
+	WRITE_REG(mm->dev, SRBM_GFX_CNTL, 0);
+	radeon_kfd_unlock_srbm_index(mm->dev);
+}
+
+bool is_occupied(struct mqd_manager *mm, void *mqd, struct queue_properties *q)
+{
+	int act;
+	struct cik_mqd *m;
+	uint32_t low, high;
+
+	BUG_ON(!mm || !mqd || !q);
+
+	m = get_mqd(mqd);
+
+	act = READ_REG(mm->dev, CP_HQD_ACTIVE);
+	if (act) {
+		low = lower_32((uint64_t)q->queue_address >> 8);
+		high = upper_32((uint64_t)q->queue_address >> 8);
+
+		if (low == READ_REG(mm->dev, CP_HQD_PQ_BASE) &&
+			high == READ_REG(mm->dev, CP_HQD_PQ_BASE_HI))
+			return true;
+	}
+
+	return false;
+}
+
+static int initialize(struct mqd_manager *mm)
+{
+	BUG_ON(!mm);
+	return 0;
+}
+
+static void uninitialize(struct mqd_manager *mm)
+{
+	BUG_ON(!mm);
+}
+
+/*
+ * HIQ MQD Implementation
+ */
+
+static int init_mqd_hiq(struct mqd_manager *mm, void **mqd, kfd_mem_obj *mqd_mem_obj,
+		uint64_t *gart_addr, struct queue_properties *q)
+{
+	uint64_t addr;
+	struct cik_mqd *m;
+	int retval;
+
+	BUG_ON(!mm || !q || !mqd || !mqd_mem_obj);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	retval = radeon_kfd_vidmem_alloc_map(
+				mm->dev,
+				mqd_mem_obj,
+				(void **)&m,
+				&addr,
+				ALIGN(sizeof(struct cik_mqd), PAGE_SIZE));
+
+	if (retval != 0)
+		return -ENOMEM;
+
+	memset(m, 0, sizeof(struct cik_mqd));
+
+	m->header = 0xC0310800;
+	m->pipeline_stat_enable = 1;
+	m->static_thread_mgmt01[0] = 0xFFFFFFFF;
+	m->static_thread_mgmt01[1] = 0xFFFFFFFF;
+	m->static_thread_mgmt23[0] = 0xFFFFFFFF;
+	m->static_thread_mgmt23[1] = 0xFFFFFFFF;
+
+	m->queue_state.cp_hqd_persistent_state = DEFAULT_CP_HQD_PERSISTENT_STATE;
+
+	m->queue_state.cp_mqd_control             = MQD_CONTROL_PRIV_STATE_EN;
+	m->queue_state.cp_mqd_base_addr           = lower_32(addr);
+	m->queue_state.cp_mqd_base_addr_hi        = upper_32(addr);
+
+	m->queue_state.cp_hqd_ib_control = DEFAULT_MIN_IB_AVAIL_SIZE;
+
+	m->queue_state.cp_hqd_quantum = QUANTUM_EN | QUANTUM_SCALE_1MS | QUANTUM_DURATION(10);
+
+	m->queue_state.cp_hqd_pipe_priority = 1;
+	m->queue_state.cp_hqd_queue_priority = 15;
+
+	*mqd = m;
+	if (gart_addr)
+		*gart_addr = addr;
+	retval = mm->update_mqd(mm, m, q);
+
+	return retval;
+}
+
+static int update_mqd_hiq(struct mqd_manager *mm, void *mqd, struct queue_properties *q)
+{
+	struct cik_mqd *m;
+
+	BUG_ON(!mm || !q || !mqd);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	m = get_mqd(mqd);
+	m->queue_state.cp_hqd_pq_control = DEFAULT_RPTR_BLOCK_SIZE | DEFAULT_MIN_AVAIL_SIZE | PRIV_STATE | KMD_QUEUE;
+	/* calculating queue size which is log base 2 of actual queue size -1 dwords */
+	m->queue_state.cp_hqd_pq_control |= ffs(q->queue_size / sizeof(unsigned int)) - 1 - 1;
+	m->queue_state.cp_hqd_pq_base = lower_32((uint64_t)q->queue_address >> 8);
+	m->queue_state.cp_hqd_pq_base_hi = upper_32((uint64_t)q->queue_address >> 8);
+	m->queue_state.cp_hqd_pq_rptr_report_addr = lower_32((uint64_t)q->read_ptr);
+	m->queue_state.cp_hqd_pq_rptr_report_addr_hi = upper_32((uint64_t)q->read_ptr);
+	m->queue_state.cp_hqd_pq_doorbell_control = DOORBELL_EN | DOORBELL_OFFSET(q->doorbell_off);
+
+	m->queue_state.cp_hqd_vmid = q->vmid;
+
+	m->queue_state.cp_hqd_active = 0;
+	q->is_active = false;
+	if (q->queue_size > 0 &&
+			q->queue_address != 0 &&
+			q->queue_percent > 0) {
+		m->queue_state.cp_hqd_active = 1;
+		q->is_active = true;
+	}
+
+	return 0;
+}
+
+struct mqd_manager *mqd_manager_init(enum KFD_MQD_TYPE type, struct kfd_dev *dev)
+{
+	struct mqd_manager *mqd;
+
+	BUG_ON(!dev);
+	BUG_ON(type >= KFD_MQD_TYPE_MAX);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	mqd = kzalloc(sizeof(struct mqd_manager), GFP_KERNEL);
+	if (!mqd)
+		return NULL;
+
+	mqd->dev = dev;
+
+	switch (type) {
+	case KFD_MQD_TYPE_CIK_CP:
+	case KFD_MQD_TYPE_CIK_COMPUTE:
+		mqd->init_mqd = init_mqd;
+		mqd->uninit_mqd = uninit_mqd;
+		mqd->load_mqd = load_mqd;
+		mqd->update_mqd = update_mqd;
+		mqd->destroy_mqd = destroy_mqd;
+		mqd->acquire_hqd = acquire_hqd;
+		mqd->release_hqd = release_hqd;
+		mqd->is_occupied = is_occupied;
+		mqd->initialize = initialize;
+		mqd->uninitialize = uninitialize;
+		break;
+	case KFD_MQD_TYPE_CIK_HIQ:
+		mqd->init_mqd = init_mqd_hiq;
+		mqd->uninit_mqd = uninit_mqd;
+		mqd->load_mqd = load_mqd;
+		mqd->update_mqd = update_mqd_hiq;
+		mqd->destroy_mqd = destroy_mqd;
+		mqd->acquire_hqd = acquire_hqd;
+		mqd->release_hqd = release_hqd;
+		mqd->is_occupied = is_occupied;
+		mqd->initialize = initialize;
+		mqd->uninitialize = uninitialize;
+		break;
+	default:
+		return NULL;
+		break;
+	}
+
+	if (mqd->initialize(mqd) != 0) {
+		pr_err("kfd: mqd manager initialization failed\n");
+		kfree(mqd);
+		return NULL;
+	}
+	return mqd;
+}
+
+/* SDMA queues should be implemented here when the cp will supports them */
diff --git a/drivers/gpu/hsa/radeon/kfd_mqd_manager.h b/drivers/gpu/hsa/radeon/kfd_mqd_manager.h
new file mode 100644
index 0000000..e7b39ee
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_mqd_manager.h
@@ -0,0 +1,48 @@
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
+ * Author: Ben Goz
+ */
+
+#ifndef MQD_MANAGER_H_
+#define MQD_MANAGER_H_
+
+#include "kfd_priv.h"
+
+struct mqd_manager {
+	int	(*init_mqd)(struct mqd_manager *mm, void **mqd, kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
+			    struct queue_properties *q);
+	int	(*load_mqd)(struct mqd_manager *mm, void *mqd);
+	int	(*update_mqd)(struct mqd_manager *mm, void *mqd, struct queue_properties *q);
+	int	(*destroy_mqd)(struct mqd_manager *mm, void *mqd, enum kfd_preempt_type type, unsigned int timeout);
+	void	(*uninit_mqd)(struct mqd_manager *mm, void *mqd, kfd_mem_obj mqd_mem_obj);
+	void	(*acquire_hqd)(struct mqd_manager *mm, unsigned int pipe, unsigned int queue, unsigned int vmid);
+	void	(*release_hqd)(struct mqd_manager *mm);
+	bool	(*is_occupied)(struct mqd_manager *mm, void *mqd, struct queue_properties *q);
+	int	(*initialize)(struct mqd_manager *mm);
+	void	(*uninitialize)(struct mqd_manager *mm);
+
+	struct mutex		mqd_mutex;
+	struct kfd_dev		*dev;
+};
+
+
+#endif /* MQD_MANAGER_H_ */
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index df17387..cc60b48 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -141,6 +141,9 @@ int radeon_kfd_vidmem_gpumap(struct kfd_dev *kfd, kfd_mem_obj mem_obj, uint64_t
 void radeon_kfd_vidmem_ungpumap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
 int radeon_kfd_vidmem_kmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj, void **ptr);
 void radeon_kfd_vidmem_unkmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
+int radeon_kfd_vidmem_alloc_map(struct kfd_dev *kfd, kfd_mem_obj *mem_obj, void **ptr,
+				uint64_t *vmid0_address, size_t size);
+void radeon_kfd_vidmem_free_unmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
 
 /* Character device interface */
 int radeon_kfd_chardev_init(void);
@@ -161,6 +164,17 @@ struct kfd_queue {
 	struct kfd_scheduler_queue scheduler_queue;
 };
 
+enum kfd_preempt_type_filter {
+	KFD_PREEMPT_TYPE_FILTER_SINGLE_QUEUE,
+	KFD_PRERMPT_TYPE_FILTER_ALL_QUEUES,
+	KFD_PRERMPT_TYPE_FILTER_BY_PASID
+};
+
+enum kfd_preempt_type {
+	KFD_PREEMPT_TYPE_WAVEFRONT,
+	KFD_PREEMPT_TYPE_WAVEFRONT_RESET
+};
+
 enum kfd_queue_type  {
 	KFD_QUEUE_TYPE_COMPUTE,
 	KFD_QUEUE_TYPE_SDMA,
@@ -204,6 +218,14 @@ struct queue {
 	struct kfd_dev		*device;
 };
 
+enum KFD_MQD_TYPE {
+	KFD_MQD_TYPE_CIK_COMPUTE = 0, /* for no cp scheduling */
+	KFD_MQD_TYPE_CIK_HIQ, /* for hiq */
+	KFD_MQD_TYPE_CIK_CP, /* for cp queues and diq */
+	KFD_MQD_TYPE_CIK_SDMA, /* for sdma queues */
+	KFD_MQD_TYPE_MAX
+};
+
 /* Data that is per-process-per device. */
 struct kfd_process_device {
 	/* List of all per-device data for a process. Starts from kfd_process.per_device_data. */
@@ -325,10 +347,14 @@ int kgd2kfd_resume(struct kfd_dev *dev);
 int kfd_init_apertures(struct kfd_process *process);
 
 /* Queue Context Management */
+inline uint32_t lower_32(uint64_t x);
+inline uint32_t upper_32(uint64_t x);
+inline void busy_wait(unsigned long ms);
 
 int init_queue(struct queue **q, struct queue_properties properties);
 void uninit_queue(struct queue *q);
 void print_queue_properties(struct queue_properties *q);
 void print_queue(struct queue *q);
 
+struct mqd_manager *mqd_manager_init(enum KFD_MQD_TYPE type, struct kfd_dev *dev);
 #endif
diff --git a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
index 30561a6..d576d95 100644
--- a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
+++ b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
@@ -182,16 +182,6 @@ struct cik_static_queue {
 	uint32_t queue_size_encoded; /* CP_HQD_PQ_CONTROL.QUEUE_SIZE takes the queue size as log2(size) - 3. */
 };
 
-static uint32_t lower_32(uint64_t x)
-{
-	return (uint32_t)x;
-}
-
-static uint32_t upper_32(uint64_t x)
-{
-	return (uint32_t)(x >> 32);
-}
-
 /* SRBM_GFX_CNTL provides the MEC/pipe/queue and vmid for many registers that are
  * In particular, CP_HQD_* and CP_MQD_* are instanced for each queue. CP_HPD_* are instanced for each pipe.
  * SH_MEM_* are instanced per-VMID.
diff --git a/drivers/gpu/hsa/radeon/kfd_vidmem.c b/drivers/gpu/hsa/radeon/kfd_vidmem.c
index c8d3770..9713373 100644
--- a/drivers/gpu/hsa/radeon/kfd_vidmem.c
+++ b/drivers/gpu/hsa/radeon/kfd_vidmem.c
@@ -59,3 +59,39 @@ void radeon_kfd_vidmem_unkmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj)
 {
 	kfd2kgd->unkmap_mem(kfd->kgd, (struct kgd_mem *)mem_obj);
 }
+
+int radeon_kfd_vidmem_alloc_map(struct kfd_dev *kfd, kfd_mem_obj *mem_obj,
+				void **ptr, uint64_t *vmid0_address,
+				size_t size)
+{
+	int retval;
+
+	retval = radeon_kfd_vidmem_alloc(kfd, size, PAGE_SIZE, KFD_MEMPOOL_SYSTEM_WRITECOMBINE,
+			mem_obj);
+	if (retval != 0)
+		goto fail_vidmem_alloc;
+
+	retval = radeon_kfd_vidmem_kmap(kfd, *mem_obj, ptr);
+	if (retval != 0)
+		goto fail_vidmem_kmap;
+
+	retval = radeon_kfd_vidmem_gpumap(kfd, *mem_obj, vmid0_address);
+	if (retval != 0)
+		goto fail_vidmem_gpumap;
+
+	return 0;
+
+fail_vidmem_gpumap:
+	radeon_kfd_vidmem_unkmap(kfd, *mem_obj);
+fail_vidmem_kmap:
+	radeon_kfd_vidmem_free(kfd, *mem_obj);
+fail_vidmem_alloc:
+	return retval;
+}
+
+void radeon_kfd_vidmem_free_unmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj)
+{
+	radeon_kfd_vidmem_ungpumap(kfd, mem_obj);
+	radeon_kfd_vidmem_unkmap(kfd, mem_obj);
+	radeon_kfd_vidmem_free(kfd, mem_obj);
+}
-- 
1.9.1

