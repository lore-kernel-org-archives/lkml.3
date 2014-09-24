Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaIXVCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:02:33 -0400
Received: from mail-bl2on0141.outbound.protection.outlook.com ([65.55.169.141]:63744
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751537AbaIXVC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:02:29 -0400
X-Greylist: delayed 951 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 17:02:29 EDT
X-WSS-ID: 0NCFB2I-08-8FJ-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 05/23] drm/radeon: Add radeon <--> amdkfd interface
Date: Wed, 24 Sep 2014 23:45:19 +0300
Message-ID: <1411591537-31636-6-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(31966008)(97736003)(90102001)(20776003)(107046002)(47776003)(50226001)(105586002)(86362001)(76482002)(84676001)(4396001)(229853001)(77096002)(92566001)(101416001)(92726001)(106466001)(99396003)(21056001)(36756003)(62966002)(102836001)(33646002)(120916001)(95666004)(50466002)(48376002)(85306004)(87286001)(77156001)(89996001)(104166001)(81542003)(87936001)(19580405001)(68736004)(88136002)(19580395003)(74662003)(575784001)(83322001)(50986999)(76176999)(74502003)(85852003)(93916002)(64706001)(77982003)(83072002)(44976005)(81342003)(79102003)(10300001)(80022003)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the interface between the radeon driver and the amdkfd driver.
The interface implementation is contained in radeon_kfd.c and radeon_kfd.h.

The interface itself is represented by a pointer to struct
kfd_dev. The pointer is located inside radeon_device structure.

All the register accesses that amdkfd need are done using this interface. This
allows us to avoid direct register accesses in amdkfd proper,  while also
avoiding locking between amdkfd and radeon.

The single exception is the doorbells that are used in both of the drivers.
However, because they are located in separate pci bar pages, the danger of
sharing registers between the drivers is minimal.

Having said that, we are planning to move the doorbells as well to radeon.

v3:

Add interface for sa manager init and fini. The init function will allocate a
buffer on system memory and pin it to the GART address space via the radeon sa
manager.

All mappings of buffers to GART address space are done via the radeon sa
manager. The interface of allocate memory will use the radeon sa manager to sub
allocate from the single buffer that was allocated during the init function.

Change lower_32/upper_32 calls to use linux macros

Add documentation for the interface

v4:

Change ptr field type in kgd_mem from uint32_t* to void* to match to type that
is returned by radeon_sa_bo_cpu_addr

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/Makefile     |   1 +
 drivers/gpu/drm/radeon/cik.c        |   9 +
 drivers/gpu/drm/radeon/cik_reg.h    |  65 +++++
 drivers/gpu/drm/radeon/cikd.h       |  51 +++-
 drivers/gpu/drm/radeon/radeon.h     |   4 +
 drivers/gpu/drm/radeon/radeon_drv.c |   5 +
 drivers/gpu/drm/radeon/radeon_kfd.c | 538 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_kfd.h | 177 ++++++++++++
 drivers/gpu/drm/radeon/radeon_kms.c |   7 +
 9 files changed, 856 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.h

diff --git a/drivers/gpu/drm/radeon/Makefile b/drivers/gpu/drm/radeon/Makefile
index d01b879..bad6caa 100644
--- a/drivers/gpu/drm/radeon/Makefile
+++ b/drivers/gpu/drm/radeon/Makefile
@@ -104,6 +104,7 @@ radeon-y += \
 	radeon_vce.o \
 	vce_v1_0.o \
 	vce_v2_0.o \
+	radeon_kfd.o
 
 radeon-$(CONFIG_COMPAT) += radeon_ioc32.o
 radeon-$(CONFIG_VGA_SWITCHEROO) += radeon_atpx_handler.o
diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 69b9027..27c983c 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -32,6 +32,7 @@
 #include "cik_blit_shaders.h"
 #include "radeon_ucode.h"
 #include "clearstate_ci.h"
+#include "radeon_kfd.h"
 
 MODULE_FIRMWARE("radeon/BONAIRE_pfp.bin");
 MODULE_FIRMWARE("radeon/BONAIRE_me.bin");
@@ -7792,6 +7793,9 @@ restart_ih:
 	while (rptr != wptr) {
 		/* wptr/rptr are in bytes! */
 		ring_index = rptr / 4;
+
+		radeon_kfd_interrupt(rdev, (const void *) &rdev->ih.ring[ring_index]);
+
 		src_id =  le32_to_cpu(rdev->ih.ring[ring_index]) & 0xff;
 		src_data = le32_to_cpu(rdev->ih.ring[ring_index + 1]) & 0xfffffff;
 		ring_id = le32_to_cpu(rdev->ih.ring[ring_index + 2]) & 0xff;
@@ -8481,6 +8485,10 @@ static int cik_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
+	r = radeon_kfd_resume(rdev);
+	if (r)
+		return r;
+
 	return 0;
 }
 
@@ -8529,6 +8537,7 @@ int cik_resume(struct radeon_device *rdev)
  */
 int cik_suspend(struct radeon_device *rdev)
 {
+	radeon_kfd_suspend(rdev);
 	radeon_pm_suspend(rdev);
 	dce6_audio_fini(rdev);
 	radeon_vm_manager_fini(rdev);
diff --git a/drivers/gpu/drm/radeon/cik_reg.h b/drivers/gpu/drm/radeon/cik_reg.h
index ca1bb61..1ab3dbc 100644
--- a/drivers/gpu/drm/radeon/cik_reg.h
+++ b/drivers/gpu/drm/radeon/cik_reg.h
@@ -147,4 +147,69 @@
 
 #define CIK_LB_DESKTOP_HEIGHT                     0x6b0c
 
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
 #endif
diff --git a/drivers/gpu/drm/radeon/cikd.h b/drivers/gpu/drm/radeon/cikd.h
index fae4d0c..890bea0 100644
--- a/drivers/gpu/drm/radeon/cikd.h
+++ b/drivers/gpu/drm/radeon/cikd.h
@@ -1139,6 +1139,9 @@
 #define			SH_MEM_ALIGNMENT_MODE_UNALIGNED			3
 #define		DEFAULT_MTYPE(x)				((x) << 4)
 #define		APE1_MTYPE(x)					((x) << 7)
+/* valid for both DEFAULT_MTYPE and APE1_MTYPE */
+#define	MTYPE_CACHED					0
+#define	MTYPE_NONCACHED					3
 
 #define	SX_DEBUG_1					0x9060
 
@@ -1449,6 +1452,16 @@
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
@@ -1476,12 +1489,32 @@
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
@@ -2071,4 +2104,20 @@
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
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index c30f1fd..f11e043 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2400,6 +2400,10 @@ struct radeon_device {
 	u64 vram_pin_size;
 	u64 gart_pin_size;
 
+	/* amdkfd interface */
+	struct kfd_dev		*kfd;
+	struct radeon_sa_manager	kfd_bo;
+
 	struct mutex	mn_lock;
 	DECLARE_HASHTABLE(mn_hash, 7);
 };
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index ec7e963..26b22c3 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -39,6 +39,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/vga_switcheroo.h>
 #include "drm_crtc_helper.h"
+#include "radeon_kfd.h"
+
 /*
  * KMS wrapper.
  * - 2.0.0 - initial interface
@@ -647,12 +649,15 @@ static int __init radeon_init(void)
 #endif
 	}
 
+	radeon_kfd_init();
+
 	/* let modprobe override vga console setting */
 	return drm_pci_init(driver, pdriver);
 }
 
 static void __exit radeon_exit(void)
 {
+	radeon_kfd_fini();
 	drm_pci_exit(driver, pdriver);
 	radeon_unregister_atpx_handler();
 }
diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
new file mode 100644
index 0000000..ebad935
--- /dev/null
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -0,0 +1,538 @@
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
+ */
+
+#include <linux/module.h>
+#include <linux/fdtable.h>
+#include <linux/uaccess.h>
+#include <drm/drmP.h>
+#include "radeon.h"
+#include "cikd.h"
+#include "cik_reg.h"
+#include "radeon_kfd.h"
+
+#define CIK_PIPE_PER_MEC	(4)
+
+struct kgd_mem {
+	struct radeon_sa_bo *sa_bo;
+	uint64_t gpu_addr;
+	void *ptr;
+};
+
+static int init_sa_manager(struct kgd_dev *kgd, unsigned int size);
+static void fini_sa_manager(struct kgd_dev *kgd);
+
+static int allocate_mem(struct kgd_dev *kgd, size_t size, size_t alignment,
+		enum kgd_memory_pool pool, struct kgd_mem **mem);
+
+static void free_mem(struct kgd_dev *kgd, struct kgd_mem *mem);
+
+static uint64_t get_vmem_size(struct kgd_dev *kgd);
+static uint64_t get_gpu_clock_counter(struct kgd_dev *kgd);
+
+static uint32_t get_max_engine_clock_in_mhz(struct kgd_dev *kgd);
+
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
+
+static const struct kfd2kgd_calls kfd2kgd = {
+	.init_sa_manager = init_sa_manager,
+	.fini_sa_manager = fini_sa_manager,
+	.allocate_mem = allocate_mem,
+	.free_mem = free_mem,
+	.get_vmem_size = get_vmem_size,
+	.get_gpu_clock_counter = get_gpu_clock_counter,
+	.get_max_engine_clock_in_mhz = get_max_engine_clock_in_mhz,
+	.program_sh_mem_settings = kgd_program_sh_mem_settings,
+	.set_pasid_vmid_mapping = kgd_set_pasid_vmid_mapping,
+	.init_memory = kgd_init_memory,
+	.init_pipeline = kgd_init_pipeline,
+	.hqd_load = kgd_hqd_load,
+	.hqd_is_occupies = kgd_hqd_is_occupies,
+	.hqd_destroy = kgd_hqd_destroy,
+};
+
+static const struct kgd2kfd_calls *kgd2kfd;
+
+bool radeon_kfd_init(void)
+{
+	bool (*kgd2kfd_init_p)(unsigned, const struct kfd2kgd_calls*,
+				const struct kgd2kfd_calls**);
+
+	kgd2kfd_init_p = symbol_request(kgd2kfd_init);
+
+	if (kgd2kfd_init_p == NULL)
+		return false;
+
+	if (!kgd2kfd_init_p(KFD_INTERFACE_VERSION, &kfd2kgd, &kgd2kfd)) {
+		symbol_put(kgd2kfd_init);
+		kgd2kfd = NULL;
+
+		return false;
+	}
+
+	return true;
+}
+
+void radeon_kfd_fini(void)
+{
+	if (kgd2kfd) {
+		kgd2kfd->exit();
+		symbol_put(kgd2kfd_init);
+	}
+}
+
+void radeon_kfd_device_probe(struct radeon_device *rdev)
+{
+	if (kgd2kfd)
+		rdev->kfd = kgd2kfd->probe((struct kgd_dev *)rdev, rdev->pdev);
+}
+
+void radeon_kfd_device_init(struct radeon_device *rdev)
+{
+	if (rdev->kfd) {
+		struct kgd2kfd_shared_resources gpu_resources = {
+			.compute_vmid_bitmap = 0xFF00,
+
+			.first_compute_pipe = 1,
+			.compute_pipe_count = 8 - 1,
+		};
+
+		radeon_doorbell_get_kfd_info(rdev,
+				&gpu_resources.doorbell_physical_address,
+				&gpu_resources.doorbell_aperture_size,
+				&gpu_resources.doorbell_start_offset);
+
+		kgd2kfd->device_init(rdev->kfd, &gpu_resources);
+	}
+}
+
+void radeon_kfd_device_fini(struct radeon_device *rdev)
+{
+	if (rdev->kfd) {
+		kgd2kfd->device_exit(rdev->kfd);
+		rdev->kfd = NULL;
+	}
+}
+
+void radeon_kfd_interrupt(struct radeon_device *rdev, const void *ih_ring_entry)
+{
+	if (rdev->kfd)
+		kgd2kfd->interrupt(rdev->kfd, ih_ring_entry);
+}
+
+void radeon_kfd_suspend(struct radeon_device *rdev)
+{
+	if (rdev->kfd)
+		kgd2kfd->suspend(rdev->kfd);
+}
+
+int radeon_kfd_resume(struct radeon_device *rdev)
+{
+	int r = 0;
+
+	if (rdev->kfd)
+		r = kgd2kfd->resume(rdev->kfd);
+
+	return r;
+}
+
+static u32 pool_to_domain(enum kgd_memory_pool p)
+{
+	switch (p) {
+	case KGD_POOL_FRAMEBUFFER: return RADEON_GEM_DOMAIN_VRAM;
+	default: return RADEON_GEM_DOMAIN_GTT;
+	}
+}
+
+static int init_sa_manager(struct kgd_dev *kgd, unsigned int size)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+	u64 max_offset[4];
+	int r, i;
+
+	BUG_ON(kgd == NULL);
+
+	r = radeon_sa_bo_manager_init(rdev, &rdev->kfd_bo,
+				      size,
+				      RADEON_GPU_PAGE_SIZE,
+				      RADEON_GEM_DOMAIN_GTT,
+				      RADEON_GEM_GTT_WC);
+
+	if (r)
+		return r;
+
+	/* Try to pin buffer in first 8MB, 16MB or 64MB of GART */
+	max_offset[0] = roundup(size, 8 * 1024 * 1024);
+	max_offset[1] = roundup(size, 16 * 1024 * 1024);
+	max_offset[2] = roundup(size, 64 * 1024 * 1024);
+	max_offset[3] = 0;
+
+	for (i = 0 ; i < 4 ; i++) {
+
+		r = radeon_sa_bo_manager_start(rdev, &rdev->kfd_bo,
+						max_offset[i]);
+		if (!r)
+			return r;
+	}
+
+	radeon_sa_bo_manager_fini(rdev, &rdev->kfd_bo);
+
+	return r;
+}
+
+static void fini_sa_manager(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	BUG_ON(kgd == NULL);
+
+	radeon_sa_bo_manager_suspend(rdev, &rdev->kfd_bo);
+	radeon_sa_bo_manager_fini(rdev, &rdev->kfd_bo);
+}
+
+static int allocate_mem(struct kgd_dev *kgd, size_t size, size_t alignment,
+		enum kgd_memory_pool pool, struct kgd_mem **mem)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+	u32 domain;
+	int r;
+
+	BUG_ON(kgd == NULL);
+
+	domain = pool_to_domain(pool);
+	if (domain != RADEON_GEM_DOMAIN_GTT) {
+		dev_err(rdev->dev,
+			"Only allowed to allocate gart memory for kfd\n");
+		return -EINVAL;
+	}
+
+	*mem = kmalloc(sizeof(struct kgd_mem), GFP_KERNEL);
+	if ((*mem) == NULL)
+		return -ENOMEM;
+
+	r = radeon_sa_bo_new(rdev, &rdev->kfd_bo, &(*mem)->sa_bo, size, alignment);
+	if (r) {
+		dev_err(rdev->dev, "failed to get memory for kfd (%d)\n", r);
+		return r;
+	}
+
+	(*mem)->ptr = radeon_sa_bo_cpu_addr((*mem)->sa_bo);
+	(*mem)->gpu_addr = radeon_sa_bo_gpu_addr((*mem)->sa_bo);
+
+	return 0;
+}
+
+static void free_mem(struct kgd_dev *kgd, struct kgd_mem *mem)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	BUG_ON(kgd == NULL);
+
+	radeon_sa_bo_free(rdev, &mem->sa_bo, NULL);
+	kfree(mem);
+}
+
+static uint64_t get_vmem_size(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	BUG_ON(kgd == NULL);
+
+	return rdev->mc.real_vram_size;
+}
+
+static uint64_t get_gpu_clock_counter(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	return rdev->asic->get_gpu_clock_counter(rdev);
+}
+
+static uint32_t get_max_engine_clock_in_mhz(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	/* The sclk is in quantas of 10kHz */
+	return rdev->pm.dpm.dyn_state.max_clock_voltage_on_ac.sclk / 100;
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
+	/*
+	 * We have to assume that there is no outstanding mapping.
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
+	/*
+	 * Configure apertures:
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
+	write_register(kgd, CP_HPD_EOP_BASE_ADDR, lower_32_bits(hpd_gpu_addr >> 8));
+	write_register(kgd, CP_HPD_EOP_BASE_ADDR_HI, upper_32_bits(hpd_gpu_addr >> 8));
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
+		low = lower_32_bits(queue_address >> 8);
+		high = upper_32_bits(queue_address >> 8);
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
diff --git a/drivers/gpu/drm/radeon/radeon_kfd.h b/drivers/gpu/drm/radeon/radeon_kfd.h
new file mode 100644
index 0000000..a610334
--- /dev/null
+++ b/drivers/gpu/drm/radeon/radeon_kfd.h
@@ -0,0 +1,177 @@
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
+ */
+
+/*
+ * radeon_kfd.h defines the private interface between the
+ * AMD kernel graphics drivers and the AMD KFD.
+ */
+
+#ifndef RADEON_KFD_H_INCLUDED
+#define RADEON_KFD_H_INCLUDED
+
+#include <linux/types.h>
+
+struct pci_dev;
+
+#define KFD_INTERFACE_VERSION 1
+
+struct kfd_dev;
+struct kgd_dev;
+
+struct kgd_mem;
+
+struct radeon_device;
+
+enum kgd_memory_pool {
+	KGD_POOL_SYSTEM_CACHEABLE = 1,
+	KGD_POOL_SYSTEM_WRITECOMBINE = 2,
+	KGD_POOL_FRAMEBUFFER = 3,
+};
+
+struct kgd2kfd_shared_resources {
+	unsigned int compute_vmid_bitmap; /* Bit n == 1 means VMID n is available for KFD. */
+
+	unsigned int first_compute_pipe; /* Compute pipes are counted starting from MEC0/pipe0 as 0. */
+	unsigned int compute_pipe_count; /* Number of MEC pipes available for KFD. */
+
+	phys_addr_t doorbell_physical_address; /* Base address of doorbell aperture. */
+	size_t doorbell_aperture_size; /* Size in bytes of doorbell aperture. */
+	size_t doorbell_start_offset; /* Number of bytes at start of aperture reserved for KGD. */
+};
+
+/**
+ * struct kgd2kfd_calls
+ *
+ * @exit: Notifies amdkfd that radeon kernel module is unloaded
+ *
+ * @probe: Notifies amdkfd about a probe done on a device in the radeon driver.
+ *
+ * @device_init: Initialize the newly probed device (if it is a device that
+ * amdkfd supports)
+ *
+ * @device_exit: Notifies amdkfd about a removal of a radeon device
+ *
+ * @suspend: Notifies amdkfd about a suspend action done to a radeon device
+ *
+ * @resume: Notifies amdkfd about a resume action done to a radeon device
+ *
+ * This structure contains function callback pointers so the radeon driver
+ * will notify to the amdkfd about certain status changes.
+ *
+ */
+struct kgd2kfd_calls {
+	void (*exit)(void);
+	struct kfd_dev* (*probe)(struct kgd_dev *kgd, struct pci_dev *pdev);
+	bool (*device_init)(struct kfd_dev *kfd, const struct kgd2kfd_shared_resources *gpu_resources);
+	void (*device_exit)(struct kfd_dev *kfd);
+	void (*interrupt)(struct kfd_dev *kfd, const void *ih_ring_entry);
+	void (*suspend)(struct kfd_dev *kfd);
+	int (*resume)(struct kfd_dev *kfd);
+};
+
+/**
+ * struct kfd2kgd_calls
+ *
+ * @init_sa_manager: Initialize an instance of the sa manager, used by
+ * amdkfd for all system memory allocations that are mapped to the GART
+ * address space
+ *
+ * @fini_sa_manager: Releases all memory allocations for amdkfd that are
+ * handled by radeon sa manager
+ *
+ * @allocate_mem: Allocate a buffer from amdkfd's sa manager. The buffer can
+ * be used for mqds, hpds, kernel queue, fence and runlists
+ *
+ * @free_mem: Frees a buffer that was allocated by amdkfd's sa manager
+ *
+ * @get_vmem_size: Retrieves (physical) size of VRAM
+ *
+ * @get_gpu_clock_counter: Retrieves GPU clock counter
+ *
+ * @get_max_engine_clock_in_mhz: Retrieves maximum GPU clock in MHz
+ *
+ * @program_sh_mem_settings: A function that should initiate the memory
+ * properties such as main aperture memory type (cache / non cached) and
+ * secondary aperture base address, size and memory type.
+ * This function is used only for no cp scheduling mode.
+ *
+ * @set_pasid_vmid_mapping: Exposes pasid/vmid pair to the H/W for no cp
+ * scheduling mode. Only used for no cp scheduling mode.
+ *
+ * @init_memory: Initializes memory apertures to fixed base/limit address
+ * and non cached memory types.
+ *
+ * @init_pipeline: Initialized the compute pipelines.
+ *
+ * @hqd_load: Loads the mqd structure to a H/W hqd slot. used only for no cp
+ * sceduling mode.
+ *
+ * @hqd_is_occupies: Checks if a hqd slot is occupied.
+ *
+ * @hqd_destroy: Destructs and preempts the queue assigned to that hqd slot.
+ *
+ * This structure contains function pointers to services that the radeon driver
+ * provides to amdkfd driver.
+ *
+ */
+struct kfd2kgd_calls {
+	/* Memory management. */
+	int (*init_sa_manager)(struct kgd_dev *kgd, unsigned int size);
+	void (*fini_sa_manager)(struct kgd_dev *kgd);
+	int (*allocate_mem)(struct kgd_dev *kgd, size_t size, size_t alignment,
+			enum kgd_memory_pool pool, struct kgd_mem **mem);
+
+	void (*free_mem)(struct kgd_dev *kgd, struct kgd_mem *mem);
+
+	uint64_t (*get_vmem_size)(struct kgd_dev *kgd);
+	uint64_t (*get_gpu_clock_counter)(struct kgd_dev *kgd);
+
+	uint32_t (*get_max_engine_clock_in_mhz)(struct kgd_dev *kgd);
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
+};
+
+bool radeon_kfd_init(void);
+void radeon_kfd_fini(void);
+bool kgd2kfd_init(unsigned interface_version,
+		  const struct kfd2kgd_calls *f2g,
+		  const struct kgd2kfd_calls **g2f);
+
+void radeon_kfd_suspend(struct radeon_device *rdev);
+int radeon_kfd_resume(struct radeon_device *rdev);
+void radeon_kfd_interrupt(struct radeon_device *rdev,
+			const void *ih_ring_entry);
+void radeon_kfd_device_probe(struct radeon_device *rdev);
+void radeon_kfd_device_init(struct radeon_device *rdev);
+void radeon_kfd_device_fini(struct radeon_device *rdev);
+
+#endif
+
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 8309b11..6eb561d 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -34,6 +34,8 @@
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 
+#include "radeon_kfd.h"
+
 #if defined(CONFIG_VGA_SWITCHEROO)
 bool radeon_has_atpx(void);
 #else
@@ -63,6 +65,8 @@ int radeon_driver_unload_kms(struct drm_device *dev)
 
 	pm_runtime_get_sync(dev->dev);
 
+	radeon_kfd_device_fini(rdev);
+
 	radeon_acpi_fini(rdev);
 	
 	radeon_modeset_fini(rdev);
@@ -142,6 +146,9 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
 				"Error during ACPI methods call\n");
 	}
 
+	radeon_kfd_device_probe(rdev);
+	radeon_kfd_device_init(rdev);
+
 	if (radeon_is_px(dev)) {
 		pm_runtime_use_autosuspend(dev->dev);
 		pm_runtime_set_autosuspend_delay(dev->dev, 5000);
-- 
1.9.1

