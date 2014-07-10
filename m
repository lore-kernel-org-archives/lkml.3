Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaGJV5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:57:45 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59171 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaGJV5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:38 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 80/83] drm/radeon: Add register access functions to kfd2kgd interface
Date: Fri, 11 Jul 2014 00:54:36 +0300
Message-Id: <1405029279-6894-52-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This patch extends the kfd2kgd interface by adding functions
that perform direct register access.

These functions can be called from kfd and will allow to
eliminate all direct register accesses from within the kfd.

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/cikd.h       |  51 +++++-
 drivers/gpu/drm/radeon/radeon_kfd.c | 354 ++++++++++++++++++++++++++++++++++++
 include/linux/radeon_kfd.h          |  11 ++
 3 files changed, 415 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cikd.h b/drivers/gpu/drm/radeon/cikd.h
index 0c6e1b5..0a2a403 100644
--- a/drivers/gpu/drm/radeon/cikd.h
+++ b/drivers/gpu/drm/radeon/cikd.h
@@ -1137,6 +1137,9 @@
 #define			SH_MEM_ALIGNMENT_MODE_UNALIGNED			3
 #define		DEFAULT_MTYPE(x)				((x) << 4)
 #define		APE1_MTYPE(x)					((x) << 7)
+/* valid for both DEFAULT_MTYPE and APE1_MTYPE */
+#define	MTYPE_CACHED					0
+#define	MTYPE_NONCACHED					3
 
 #define	SX_DEBUG_1					0x9060
 
@@ -1447,6 +1450,16 @@
 #define CP_HQD_ACTIVE                                     0xC91C
 #define CP_HQD_VMID                                       0xC920
 
+#define CP_HQD_PERSISTENT_STATE							0xC924u
+#define	DEFAULT_CP_HQD_PERSISTENT_STATE						(0x33U << 8)
+
+#define CP_HQD_PIPE_PRIORITY							0xC928u
+#define CP_HQD_QUEUE_PRIORITY							0xC92Cu
+#define CP_HQD_QUANTUM									0xC930u
+#define	QUANTUM_EN											1U
+#define	QUANTUM_SCALE_1MS									(1U << 4)
+#define	QUANTUM_DURATION(x)									((x) << 8)
+
 #define CP_HQD_PQ_BASE                                    0xC934
 #define CP_HQD_PQ_BASE_HI                                 0xC938
 #define CP_HQD_PQ_RPTR                                    0xC93C
@@ -1474,12 +1487,32 @@
 #define		PRIV_STATE      			(1 << 30)
 #define		KMD_QUEUE      				(1 << 31)
 
-#define CP_HQD_DEQUEUE_REQUEST                          0xC974
+#define CP_HQD_IB_BASE_ADDR				0xC95Cu
+#define CP_HQD_IB_BASE_ADDR_HI			0xC960u
+#define CP_HQD_IB_RPTR					0xC964u
+#define CP_HQD_IB_CONTROL				0xC968u
+#define	IB_ATC_EN							(1U << 23)
+#define	DEFAULT_MIN_IB_AVAIL_SIZE			(3U << 20)
+
+#define CP_HQD_DEQUEUE_REQUEST			0xC974
+#define	DEQUEUE_REQUEST_DRAIN				1
+#define DEQUEUE_REQUEST_RESET				2
 
 #define CP_MQD_CONTROL                                  0xC99C
 #define		MQD_VMID(x)				((x) << 0)
 #define		MQD_VMID_MASK      			(0xf << 0)
 
+#define CP_HQD_SEMA_CMD					0xC97Cu
+#define CP_HQD_MSG_TYPE					0xC980u
+#define CP_HQD_ATOMIC0_PREOP_LO			0xC984u
+#define CP_HQD_ATOMIC0_PREOP_HI			0xC988u
+#define CP_HQD_ATOMIC1_PREOP_LO			0xC98Cu
+#define CP_HQD_ATOMIC1_PREOP_HI			0xC990u
+#define CP_HQD_HQ_SCHEDULER0			0xC994u
+#define CP_HQD_HQ_SCHEDULER1			0xC998u
+
+#define SH_STATIC_MEM_CONFIG			0x9604u
+
 #define DB_RENDER_CONTROL                               0x28000
 
 #define PA_SC_RASTER_CONFIG                             0x28350
@@ -2069,4 +2102,20 @@
 #define VCE_CMD_IB_AUTO		0x00000005
 #define VCE_CMD_SEMAPHORE	0x00000006
 
+#define ATC_VMID0_PASID_MAPPING					0x339Cu
+#define	ATC_VMID_PASID_MAPPING_UPDATE_STATUS	0x3398u
+#define	ATC_VMID_PASID_MAPPING_VALID				(1U << 31)
+
+#define ATC_VM_APERTURE0_CNTL					0x3310u
+#define	ATS_ACCESS_MODE_NEVER						0
+#define	ATS_ACCESS_MODE_ALWAYS						1
+
+#define ATC_VM_APERTURE0_CNTL2					0x3318u
+#define ATC_VM_APERTURE0_HIGH_ADDR				0x3308u
+#define ATC_VM_APERTURE0_LOW_ADDR				0x3300u
+#define ATC_VM_APERTURE1_CNTL					0x3314u
+#define ATC_VM_APERTURE1_CNTL2					0x331Cu
+#define ATC_VM_APERTURE1_HIGH_ADDR				0x330Cu
+#define ATC_VM_APERTURE1_LOW_ADDR				0x3304u
+
 #endif
diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index a28cf6b..738c2b3 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -24,10 +24,81 @@
 #include <linux/radeon_kfd.h>
 #include <drm/drmP.h>
 #include "radeon.h"
+#include "cikd.h"
+#include <linux/fdtable.h>
+#include <linux/uaccess.h>
+
+#define CIK_PIPE_PER_MEC	(4)
 
 struct kgd_mem {
 	struct radeon_bo *bo;
 	u32 domain;
+	struct radeon_bo_va *bo_va;
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
 };
 
 static int allocate_mem(struct kgd_dev *kgd, size_t size, size_t alignment,
@@ -52,6 +123,19 @@ static void unlock_grbm_gfx_idx(struct kgd_dev *kgd);
 
 static uint32_t get_max_engine_clock_in_mhz(struct kgd_dev *kgd);
 
+/*
+ * Register access functions
+ */
+
+static void kgd_program_sh_mem_settings(struct kgd_dev *kgd, uint32_t vmid, uint32_t sh_mem_config,
+		uint32_t sh_mem_ape1_base, uint32_t sh_mem_ape1_limit, uint32_t sh_mem_bases);
+static int kgd_set_pasid_vmid_mapping(struct kgd_dev *kgd, unsigned int pasid, unsigned int vmid);
+static int kgd_init_memory(struct kgd_dev *kgd);
+static int kgd_init_pipeline(struct kgd_dev *kgd, uint32_t pipe_id, uint32_t hpd_size, uint64_t hpd_gpu_addr);
+static int kgd_hqd_load(struct kgd_dev *kgd, void *mqd, uint32_t pipe_id, uint32_t queue_id, uint32_t __user *wptr);
+static bool kgd_hqd_is_occupies(struct kgd_dev *kgd, uint64_t queue_address, uint32_t pipe_id, uint32_t queue_id);
+static int kgd_hqd_destroy(struct kgd_dev *kgd, bool is_reset, unsigned int timeout,
+				uint32_t pipe_id, uint32_t queue_id);
 
 static const struct kfd2kgd_calls kfd2kgd = {
 	.allocate_mem = allocate_mem,
@@ -67,6 +151,13 @@ static const struct kfd2kgd_calls kfd2kgd = {
 	.lock_grbm_gfx_idx = lock_grbm_gfx_idx,
 	.unlock_grbm_gfx_idx = unlock_grbm_gfx_idx,
 	.get_max_engine_clock_in_mhz = get_max_engine_clock_in_mhz,
+	.program_sh_mem_settings = kgd_program_sh_mem_settings,
+	.set_pasid_vmid_mapping = kgd_set_pasid_vmid_mapping,
+	.init_memory = kgd_init_memory,
+	.init_pipeline = kgd_init_pipeline,
+	.hqd_load = kgd_hqd_load,
+	.hqd_is_occupies = kgd_hqd_is_occupies,
+	.hqd_destroy = kgd_hqd_destroy,
 };
 
 static const struct kgd2kfd_calls *kgd2kfd;
@@ -318,3 +409,266 @@ static uint32_t get_max_engine_clock_in_mhz(struct kgd_dev *kgd)
 	/* The sclk is in quantas of 10kHz */
 	return rdev->pm.dpm.dyn_state.max_clock_voltage_on_ac.sclk / 100;
 }
+
+/*
+ * kfd/radeon registers access interface
+ */
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
+static inline struct radeon_device *get_radeon_device(struct kgd_dev *kgd)
+{
+	return (struct radeon_device *)kgd;
+}
+
+static void write_register(struct kgd_dev *kgd, uint32_t offset, uint32_t value)
+{
+	struct radeon_device *rdev = get_radeon_device(kgd);
+
+	writel(value, (void __iomem *)(rdev->rmmio + offset));
+}
+
+static uint32_t read_register(struct kgd_dev *kgd, uint32_t offset)
+{
+	struct radeon_device *rdev = get_radeon_device(kgd);
+
+	return readl((void __iomem *)(rdev->rmmio + offset));
+}
+
+static void lock_srbm(struct kgd_dev *kgd, uint32_t mec, uint32_t pipe, uint32_t queue, uint32_t vmid)
+{
+	struct radeon_device *rdev = get_radeon_device(kgd);
+	uint32_t value = PIPEID(pipe) | MEID(mec) | VMID(vmid) | QUEUEID(queue);
+
+	mutex_lock(&rdev->srbm_mutex);
+	write_register(kgd, SRBM_GFX_CNTL, value);
+}
+
+static void unlock_srbm(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = get_radeon_device(kgd);
+
+	write_register(kgd, SRBM_GFX_CNTL, 0);
+	mutex_unlock(&rdev->srbm_mutex);
+}
+
+static void acquire_queue(struct kgd_dev *kgd, uint32_t pipe_id, uint32_t queue_id)
+{
+	uint32_t mec = (++pipe_id / CIK_PIPE_PER_MEC) + 1;
+	uint32_t pipe = (pipe_id % CIK_PIPE_PER_MEC);
+
+	lock_srbm(kgd, mec, pipe, queue_id, 0);
+}
+
+static void release_queue(struct kgd_dev *kgd)
+{
+	unlock_srbm(kgd);
+}
+
+static void kgd_program_sh_mem_settings(struct kgd_dev *kgd, uint32_t vmid, uint32_t sh_mem_config,
+		uint32_t sh_mem_ape1_base, uint32_t sh_mem_ape1_limit, uint32_t sh_mem_bases)
+{
+	lock_srbm(kgd, 0, 0, 0, vmid);
+
+	write_register(kgd, SH_MEM_CONFIG, sh_mem_config);
+	write_register(kgd, SH_MEM_APE1_BASE, sh_mem_ape1_base);
+	write_register(kgd, SH_MEM_APE1_LIMIT, sh_mem_ape1_limit);
+	write_register(kgd, SH_MEM_BASES, sh_mem_bases);
+
+	unlock_srbm(kgd);
+}
+
+static int kgd_set_pasid_vmid_mapping(struct kgd_dev *kgd, unsigned int pasid, unsigned int vmid)
+{
+	/* We have to assume that there is no outstanding mapping.
+	 * The ATC_VMID_PASID_MAPPING_UPDATE_STATUS bit could be 0 because a mapping
+	 * is in progress or because a mapping finished and the SW cleared it.
+	 * So the protocol is to always wait & clear.
+	 */
+	uint32_t pasid_mapping = (pasid == 0) ? 0 : (uint32_t)pasid | ATC_VMID_PASID_MAPPING_VALID;
+
+	write_register(kgd, ATC_VMID0_PASID_MAPPING + vmid*sizeof(uint32_t), pasid_mapping);
+
+	while (!(read_register(kgd, ATC_VMID_PASID_MAPPING_UPDATE_STATUS) & (1U << vmid)))
+		cpu_relax();
+	write_register(kgd, ATC_VMID_PASID_MAPPING_UPDATE_STATUS, 1U << vmid);
+
+	return 0;
+}
+
+static int kgd_init_memory(struct kgd_dev *kgd)
+{
+	/* Configure apertures:
+	 * LDS:         0x60000000'00000000 - 0x60000001'00000000 (4GB)
+	 * Scratch:     0x60000001'00000000 - 0x60000002'00000000 (4GB)
+	 * GPUVM:       0x60010000'00000000 - 0x60020000'00000000 (1TB)
+	 */
+	int i;
+	uint32_t sh_mem_bases = PRIVATE_BASE(0x6000) | SHARED_BASE(0x6000);
+
+	for (i = 8; i < 16; i++) {
+		uint32_t sh_mem_config;
+
+		lock_srbm(kgd, 0, 0, 0, i);
+
+		sh_mem_config = ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED);
+		sh_mem_config |= DEFAULT_MTYPE(MTYPE_NONCACHED);
+
+		write_register(kgd, SH_MEM_CONFIG, sh_mem_config);
+
+		write_register(kgd, SH_MEM_BASES, sh_mem_bases);
+
+		/* Scratch aperture is not supported for now. */
+		write_register(kgd, SH_STATIC_MEM_CONFIG, 0);
+
+		/* APE1 disabled for now. */
+		write_register(kgd, SH_MEM_APE1_BASE, 1);
+		write_register(kgd, SH_MEM_APE1_LIMIT, 0);
+
+		unlock_srbm(kgd);
+	}
+
+	return 0;
+}
+
+static int kgd_init_pipeline(struct kgd_dev *kgd, uint32_t pipe_id, uint32_t hpd_size, uint64_t hpd_gpu_addr)
+{
+	uint32_t mec = (++pipe_id / CIK_PIPE_PER_MEC) + 1;
+	uint32_t pipe = (pipe_id % CIK_PIPE_PER_MEC);
+
+	lock_srbm(kgd, mec, pipe, 0, 0);
+	write_register(kgd, CP_HPD_EOP_BASE_ADDR, lower_32(hpd_gpu_addr >> 8));
+	write_register(kgd, CP_HPD_EOP_BASE_ADDR_HI, upper_32(hpd_gpu_addr >> 8));
+	write_register(kgd, CP_HPD_EOP_VMID, 0);
+	write_register(kgd, CP_HPD_EOP_CONTROL, hpd_size);
+	unlock_srbm(kgd);
+
+	return 0;
+}
+
+static inline struct cik_mqd *get_mqd(void *mqd)
+{
+	return (struct cik_mqd *)mqd;
+}
+
+static int kgd_hqd_load(struct kgd_dev *kgd, void *mqd, uint32_t pipe_id, uint32_t queue_id, uint32_t __user *wptr)
+{
+	uint32_t wptr_shadow, is_wptr_shadow_valid;
+	struct cik_mqd *m;
+
+	m = get_mqd(mqd);
+
+	is_wptr_shadow_valid = !get_user(wptr_shadow, wptr);
+
+	acquire_queue(kgd, pipe_id, queue_id);
+	write_register(kgd, CP_MQD_BASE_ADDR, m->queue_state.cp_mqd_base_addr);
+	write_register(kgd, CP_MQD_BASE_ADDR_HI, m->queue_state.cp_mqd_base_addr_hi);
+	write_register(kgd, CP_MQD_CONTROL, m->queue_state.cp_mqd_control);
+
+	write_register(kgd, CP_HQD_PQ_BASE, m->queue_state.cp_hqd_pq_base);
+	write_register(kgd, CP_HQD_PQ_BASE_HI, m->queue_state.cp_hqd_pq_base_hi);
+	write_register(kgd, CP_HQD_PQ_CONTROL, m->queue_state.cp_hqd_pq_control);
+
+	write_register(kgd, CP_HQD_IB_CONTROL, m->queue_state.cp_hqd_ib_control);
+	write_register(kgd, CP_HQD_IB_BASE_ADDR, m->queue_state.cp_hqd_ib_base_addr);
+	write_register(kgd, CP_HQD_IB_BASE_ADDR_HI, m->queue_state.cp_hqd_ib_base_addr_hi);
+
+	write_register(kgd, CP_HQD_IB_RPTR, m->queue_state.cp_hqd_ib_rptr);
+
+	write_register(kgd, CP_HQD_PERSISTENT_STATE, m->queue_state.cp_hqd_persistent_state);
+	write_register(kgd, CP_HQD_SEMA_CMD, m->queue_state.cp_hqd_sema_cmd);
+	write_register(kgd, CP_HQD_MSG_TYPE, m->queue_state.cp_hqd_msg_type);
+
+	write_register(kgd, CP_HQD_ATOMIC0_PREOP_LO, m->queue_state.cp_hqd_atomic0_preop_lo);
+	write_register(kgd, CP_HQD_ATOMIC0_PREOP_HI, m->queue_state.cp_hqd_atomic0_preop_hi);
+	write_register(kgd, CP_HQD_ATOMIC1_PREOP_LO, m->queue_state.cp_hqd_atomic1_preop_lo);
+	write_register(kgd, CP_HQD_ATOMIC1_PREOP_HI, m->queue_state.cp_hqd_atomic1_preop_hi);
+
+	write_register(kgd, CP_HQD_PQ_RPTR_REPORT_ADDR, m->queue_state.cp_hqd_pq_rptr_report_addr);
+	write_register(kgd, CP_HQD_PQ_RPTR_REPORT_ADDR_HI, m->queue_state.cp_hqd_pq_rptr_report_addr_hi);
+	write_register(kgd, CP_HQD_PQ_RPTR, m->queue_state.cp_hqd_pq_rptr);
+
+	write_register(kgd, CP_HQD_PQ_WPTR_POLL_ADDR, m->queue_state.cp_hqd_pq_wptr_poll_addr);
+	write_register(kgd, CP_HQD_PQ_WPTR_POLL_ADDR_HI, m->queue_state.cp_hqd_pq_wptr_poll_addr_hi);
+
+	write_register(kgd, CP_HQD_PQ_DOORBELL_CONTROL, m->queue_state.cp_hqd_pq_doorbell_control);
+
+	write_register(kgd, CP_HQD_VMID, m->queue_state.cp_hqd_vmid);
+
+	write_register(kgd, CP_HQD_QUANTUM, m->queue_state.cp_hqd_quantum);
+
+	write_register(kgd, CP_HQD_PIPE_PRIORITY, m->queue_state.cp_hqd_pipe_priority);
+	write_register(kgd, CP_HQD_QUEUE_PRIORITY, m->queue_state.cp_hqd_queue_priority);
+
+	write_register(kgd, CP_HQD_HQ_SCHEDULER0, m->queue_state.cp_hqd_hq_scheduler0);
+	write_register(kgd, CP_HQD_HQ_SCHEDULER1, m->queue_state.cp_hqd_hq_scheduler1);
+
+	if (is_wptr_shadow_valid)
+		write_register(kgd, CP_HQD_PQ_WPTR, wptr_shadow);
+
+	write_register(kgd, CP_HQD_ACTIVE, m->queue_state.cp_hqd_active);
+	release_queue(kgd);
+
+	return 0;
+}
+
+static bool kgd_hqd_is_occupies(struct kgd_dev *kgd, uint64_t queue_address, uint32_t pipe_id, uint32_t queue_id)
+{
+	uint32_t act;
+	bool retval = false;
+	uint32_t low, high;
+
+	acquire_queue(kgd, pipe_id, queue_id);
+	act = read_register(kgd, CP_HQD_ACTIVE);
+	if (act) {
+		low = lower_32(queue_address >> 8);
+		high = upper_32(queue_address >> 8);
+
+		if (low == read_register(kgd, CP_HQD_PQ_BASE) &&
+				high == read_register(kgd, CP_HQD_PQ_BASE_HI))
+			retval = true;
+	}
+	release_queue(kgd);
+	return retval;
+}
+
+static int kgd_hqd_destroy(struct kgd_dev *kgd, bool is_reset,
+				unsigned int timeout, uint32_t pipe_id,
+				uint32_t queue_id)
+{
+	int status = 0;
+	bool sync = (timeout > 0) ? true : false;
+
+	acquire_queue(kgd, pipe_id, queue_id);
+	write_register(kgd, CP_HQD_PQ_DOORBELL_CONTROL, 0);
+
+	if (is_reset)
+		write_register(kgd, CP_HQD_DEQUEUE_REQUEST, DEQUEUE_REQUEST_RESET);
+	else
+		write_register(kgd, CP_HQD_DEQUEUE_REQUEST, DEQUEUE_REQUEST_DRAIN);
+
+
+	while (read_register(kgd, CP_HQD_ACTIVE) != 0) {
+		if (sync && timeout <= 0) {
+			status = -EBUSY;
+			break;
+		}
+		msleep(20);
+		if (sync) {
+			if (timeout >= 20)
+				timeout -= 20;
+			else
+				timeout = 0;
+		}
+	}
+	release_queue(kgd);
+	return status;
+}
diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
index 4114c8e..aa021fb 100644
--- a/include/linux/radeon_kfd.h
+++ b/include/linux/radeon_kfd.h
@@ -95,6 +95,17 @@ struct kfd2kgd_calls {
 	void (*unlock_grbm_gfx_idx)(struct kgd_dev *kgd);
 
 	uint32_t (*get_max_engine_clock_in_mhz)(struct kgd_dev *kgd);
+
+	/* Register access functions */
+	void (*program_sh_mem_settings)(struct kgd_dev *kgd, uint32_t vmid, uint32_t sh_mem_config,
+			uint32_t sh_mem_ape1_base, uint32_t sh_mem_ape1_limit, uint32_t sh_mem_bases);
+	int (*set_pasid_vmid_mapping)(struct kgd_dev *kgd, unsigned int pasid, unsigned int vmid);
+	int (*init_memory)(struct kgd_dev *kgd);
+	int (*init_pipeline)(struct kgd_dev *kgd, uint32_t pipe_id, uint32_t hpd_size, uint64_t hpd_gpu_addr);
+	int (*hqd_load)(struct kgd_dev *kgd, void *mqd, uint32_t pipe_id, uint32_t queue_id, uint32_t __user *wptr);
+	bool (*hqd_is_occupies)(struct kgd_dev *kgd, uint64_t queue_address, uint32_t pipe_id, uint32_t queue_id);
+	int (*hqd_destroy)(struct kgd_dev *kgd, bool is_reset, unsigned int timeout,
+				uint32_t pipe_id, uint32_t queue_id);
 };
 
 bool kgd2kfd_init(unsigned interface_version,
-- 
1.9.1

