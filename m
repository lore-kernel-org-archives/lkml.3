Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaKHSnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:43:16 -0500
Received: from mail-bl2on0140.outbound.protection.outlook.com ([65.55.169.140]:52672
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752275AbaKHSnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:43:14 -0500
X-WSS-ID: 0NEQHBW-07-RFR-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Jay Cornwall <jay.cornwall@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        "Alexey Skidanov" <Alexey.Skidanov@amd.com>
Subject: [PATCH v5 13/24] amdkfd: Add mqd_manager module
Date: Sat, 8 Nov 2014 20:37:34 +0200
Message-ID: <1415471865-1893-14-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(33646002)(53416004)(50466002)(106466001)(4396001)(50226001)(99396003)(95666004)(62966003)(120916001)(229853001)(105586002)(107046002)(102836001)(68736004)(77096003)(77156002)(64706001)(87286001)(48376002)(87936001)(88136002)(89996001)(20776003)(44976005)(47776003)(104166001)(46102003)(36756003)(86362001)(31966008)(50986999)(97736003)(84676001)(19580395003)(92566001)(101416001)(93916002)(21056001)(92726001)(76176999)(19580405001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(1)(2);SRVR:CO1PR02MB206;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

The mqd_manager module handles MQD data structures.
MQD stands for Memory Queue Descriptor, which is used by the H/W to
keep the usermode queue state in memory.

v3:

Removed new typedefs
Removed pragma pack 4
Remove cik_mqds.h file
Changed lower_32/upper_32 calls to use linux macros
Used new gart allocation functions
Added documentation

v4:

Added missing initialization of the addr field in init_mqd()

Setting the hqd persistent.preload_req bit ON so that when queues switches
on/off, their context will kept and read from the mqd when the cp reassign
them, and thus the dispatched workload context kept consistent without any
interrupts.

v5:

Move amdkfd from drm/radeon/ to drm/amd/
Change format of mqd structure to match latest KV firmware
Add support for AQL queues creation to enable working with open-source HSA
runtime.
Various fixes

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/Makefile          |   2 +-
 drivers/gpu/drm/amd/amdkfd/cik_regs.h        | 221 +++++++++++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c | 346 +++++++++++++++++++++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h |  91 +++++++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h        |  22 ++
 5 files changed, 681 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/amd/amdkfd/cik_regs.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h

diff --git a/drivers/gpu/drm/amd/amdkfd/Makefile b/drivers/gpu/drm/amd/amdkfd/Makefile
index 42df022..301e847 100644
--- a/drivers/gpu/drm/amd/amdkfd/Makefile
+++ b/drivers/gpu/drm/amd/amdkfd/Makefile
@@ -6,6 +6,6 @@ ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/amd/include/
 
 amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_flat_memory.o \
-		kfd_process.o kfd_queue.o
+		kfd_process.o kfd_queue.o kfd_mqd_manager.o
 
 obj-$(CONFIG_HSA_AMD)	+= amdkfd.o
diff --git a/drivers/gpu/drm/amd/amdkfd/cik_regs.h b/drivers/gpu/drm/amd/amdkfd/cik_regs.h
new file mode 100644
index 0000000..607fc5c
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdkfd/cik_regs.h
@@ -0,0 +1,221 @@
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
+#ifndef CIK_REGS_H
+#define CIK_REGS_H
+
+#define IH_VMID_0_LUT					0x3D40u
+
+#define BIF_DOORBELL_CNTL				0x530Cu
+
+#define	SRBM_GFX_CNTL					0xE44
+#define	PIPEID(x)					((x) << 0)
+#define	MEID(x)						((x) << 2)
+#define	VMID(x)						((x) << 4)
+#define	QUEUEID(x)					((x) << 8)
+
+#define	SQ_CONFIG					0x8C00
+
+#define	SH_MEM_BASES					0x8C28
+/* if PTR32, these are the bases for scratch and lds */
+#define	PRIVATE_BASE(x)					((x) << 0) /* scratch */
+#define	SHARED_BASE(x)					((x) << 16) /* LDS */
+#define	SH_MEM_APE1_BASE				0x8C2C
+/* if PTR32, this is the base location of GPUVM */
+#define	SH_MEM_APE1_LIMIT				0x8C30
+/* if PTR32, this is the upper limit of GPUVM */
+#define	SH_MEM_CONFIG					0x8C34
+#define	PTR32						(1 << 0)
+#define PRIVATE_ATC					(1 << 1)
+#define	ALIGNMENT_MODE(x)				((x) << 2)
+#define	SH_MEM_ALIGNMENT_MODE_DWORD			0
+#define	SH_MEM_ALIGNMENT_MODE_DWORD_STRICT		1
+#define	SH_MEM_ALIGNMENT_MODE_STRICT			2
+#define	SH_MEM_ALIGNMENT_MODE_UNALIGNED			3
+#define	DEFAULT_MTYPE(x)				((x) << 4)
+#define	APE1_MTYPE(x)					((x) << 7)
+
+/* valid for both DEFAULT_MTYPE and APE1_MTYPE */
+#define	MTYPE_CACHED					0
+#define	MTYPE_NONCACHED					3
+
+
+#define SH_STATIC_MEM_CONFIG				0x9604u
+
+#define	TC_CFG_L1_LOAD_POLICY0				0xAC68
+#define	TC_CFG_L1_LOAD_POLICY1				0xAC6C
+#define	TC_CFG_L1_STORE_POLICY				0xAC70
+#define	TC_CFG_L2_LOAD_POLICY0				0xAC74
+#define	TC_CFG_L2_LOAD_POLICY1				0xAC78
+#define	TC_CFG_L2_STORE_POLICY0				0xAC7C
+#define	TC_CFG_L2_STORE_POLICY1				0xAC80
+#define	TC_CFG_L2_ATOMIC_POLICY				0xAC84
+#define	TC_CFG_L1_VOLATILE				0xAC88
+#define	TC_CFG_L2_VOLATILE				0xAC8C
+
+#define CP_PQ_WPTR_POLL_CNTL				0xC20C
+#define	WPTR_POLL_EN					(1 << 31)
+
+#define CPC_INT_CNTL					0xC2D0
+#define CP_ME1_PIPE0_INT_CNTL				0xC214
+#define CP_ME1_PIPE1_INT_CNTL				0xC218
+#define CP_ME1_PIPE2_INT_CNTL				0xC21C
+#define CP_ME1_PIPE3_INT_CNTL				0xC220
+#define CP_ME2_PIPE0_INT_CNTL				0xC224
+#define CP_ME2_PIPE1_INT_CNTL				0xC228
+#define CP_ME2_PIPE2_INT_CNTL				0xC22C
+#define CP_ME2_PIPE3_INT_CNTL				0xC230
+#define DEQUEUE_REQUEST_INT_ENABLE			(1 << 13)
+#define WRM_POLL_TIMEOUT_INT_ENABLE			(1 << 17)
+#define PRIV_REG_INT_ENABLE				(1 << 23)
+#define TIME_STAMP_INT_ENABLE				(1 << 26)
+#define GENERIC2_INT_ENABLE				(1 << 29)
+#define GENERIC1_INT_ENABLE				(1 << 30)
+#define GENERIC0_INT_ENABLE				(1 << 31)
+#define CP_ME1_PIPE0_INT_STATUS				0xC214
+#define CP_ME1_PIPE1_INT_STATUS				0xC218
+#define CP_ME1_PIPE2_INT_STATUS				0xC21C
+#define CP_ME1_PIPE3_INT_STATUS				0xC220
+#define CP_ME2_PIPE0_INT_STATUS				0xC224
+#define CP_ME2_PIPE1_INT_STATUS				0xC228
+#define CP_ME2_PIPE2_INT_STATUS				0xC22C
+#define CP_ME2_PIPE3_INT_STATUS				0xC230
+#define DEQUEUE_REQUEST_INT_STATUS			(1 << 13)
+#define WRM_POLL_TIMEOUT_INT_STATUS			(1 << 17)
+#define PRIV_REG_INT_STATUS				(1 << 23)
+#define TIME_STAMP_INT_STATUS				(1 << 26)
+#define GENERIC2_INT_STATUS				(1 << 29)
+#define GENERIC1_INT_STATUS				(1 << 30)
+#define GENERIC0_INT_STATUS				(1 << 31)
+
+#define CP_HPD_EOP_BASE_ADDR				0xC904
+#define CP_HPD_EOP_BASE_ADDR_HI				0xC908
+#define CP_HPD_EOP_VMID					0xC90C
+#define CP_HPD_EOP_CONTROL				0xC910
+#define	EOP_SIZE(x)					((x) << 0)
+#define	EOP_SIZE_MASK					(0x3f << 0)
+#define CP_MQD_BASE_ADDR				0xC914
+#define CP_MQD_BASE_ADDR_HI				0xC918
+#define CP_HQD_ACTIVE					0xC91C
+#define CP_HQD_VMID					0xC920
+
+#define CP_HQD_PERSISTENT_STATE				0xC924u
+#define	DEFAULT_CP_HQD_PERSISTENT_STATE			(0x33U << 8)
+#define	PRELOAD_REQ					(1 << 0)
+
+#define CP_HQD_PIPE_PRIORITY				0xC928u
+#define CP_HQD_QUEUE_PRIORITY				0xC92Cu
+#define CP_HQD_QUANTUM					0xC930u
+#define	QUANTUM_EN					1U
+#define	QUANTUM_SCALE_1MS				(1U << 4)
+#define	QUANTUM_DURATION(x)				((x) << 8)
+
+#define CP_HQD_PQ_BASE					0xC934
+#define CP_HQD_PQ_BASE_HI				0xC938
+#define CP_HQD_PQ_RPTR					0xC93C
+#define CP_HQD_PQ_RPTR_REPORT_ADDR			0xC940
+#define CP_HQD_PQ_RPTR_REPORT_ADDR_HI			0xC944
+#define CP_HQD_PQ_WPTR_POLL_ADDR			0xC948
+#define CP_HQD_PQ_WPTR_POLL_ADDR_HI			0xC94C
+#define CP_HQD_PQ_DOORBELL_CONTROL			0xC950
+#define	DOORBELL_OFFSET(x)				((x) << 2)
+#define	DOORBELL_OFFSET_MASK				(0x1fffff << 2)
+#define	DOORBELL_SOURCE					(1 << 28)
+#define	DOORBELL_SCHD_HIT				(1 << 29)
+#define	DOORBELL_EN					(1 << 30)
+#define	DOORBELL_HIT					(1 << 31)
+#define CP_HQD_PQ_WPTR					0xC954
+#define CP_HQD_PQ_CONTROL				0xC958
+#define	QUEUE_SIZE(x)					((x) << 0)
+#define	QUEUE_SIZE_MASK					(0x3f << 0)
+#define	RPTR_BLOCK_SIZE(x)				((x) << 8)
+#define	RPTR_BLOCK_SIZE_MASK				(0x3f << 8)
+#define	MIN_AVAIL_SIZE(x)				((x) << 20)
+#define	PQ_ATC_EN					(1 << 23)
+#define	PQ_VOLATILE					(1 << 26)
+#define	NO_UPDATE_RPTR					(1 << 27)
+#define	UNORD_DISPATCH					(1 << 28)
+#define	ROQ_PQ_IB_FLIP					(1 << 29)
+#define	PRIV_STATE					(1 << 30)
+#define	KMD_QUEUE					(1 << 31)
+
+#define	DEFAULT_RPTR_BLOCK_SIZE				RPTR_BLOCK_SIZE(5)
+#define	DEFAULT_MIN_AVAIL_SIZE				MIN_AVAIL_SIZE(3)
+
+#define CP_HQD_IB_BASE_ADDR				0xC95Cu
+#define CP_HQD_IB_BASE_ADDR_HI				0xC960u
+#define CP_HQD_IB_RPTR					0xC964u
+#define CP_HQD_IB_CONTROL				0xC968u
+#define	IB_ATC_EN					(1U << 23)
+#define	DEFAULT_MIN_IB_AVAIL_SIZE			(3U << 20)
+
+#define CP_HQD_DEQUEUE_REQUEST				0xC974
+#define	DEQUEUE_REQUEST_DRAIN				1
+#define DEQUEUE_REQUEST_RESET				2
+#define		DEQUEUE_INT					(1U << 8)
+
+#define CP_HQD_SEMA_CMD					0xC97Cu
+#define CP_HQD_MSG_TYPE					0xC980u
+#define CP_HQD_ATOMIC0_PREOP_LO				0xC984u
+#define CP_HQD_ATOMIC0_PREOP_HI				0xC988u
+#define CP_HQD_ATOMIC1_PREOP_LO				0xC98Cu
+#define CP_HQD_ATOMIC1_PREOP_HI				0xC990u
+#define CP_HQD_HQ_SCHEDULER0				0xC994u
+#define CP_HQD_HQ_SCHEDULER1				0xC998u
+
+
+#define CP_MQD_CONTROL					0xC99C
+#define	MQD_VMID(x)					((x) << 0)
+#define	MQD_VMID_MASK					(0xf << 0)
+#define	MQD_CONTROL_PRIV_STATE_EN			(1U << 8)
+
+#define GRBM_GFX_INDEX					0x30800
+#define	INSTANCE_INDEX(x)				((x) << 0)
+#define	SH_INDEX(x)					((x) << 8)
+#define	SE_INDEX(x)					((x) << 16)
+#define	SH_BROADCAST_WRITES				(1 << 29)
+#define	INSTANCE_BROADCAST_WRITES			(1 << 30)
+#define	SE_BROADCAST_WRITES				(1 << 31)
+
+#define SQC_CACHES					0x30d20
+#define SQC_POLICY					0x8C38u
+#define SQC_VOLATILE					0x8C3Cu
+
+#define CP_PERFMON_CNTL					0x36020
+
+#define ATC_VMID0_PASID_MAPPING				0x339Cu
+#define	ATC_VMID_PASID_MAPPING_UPDATE_STATUS		0x3398u
+#define	ATC_VMID_PASID_MAPPING_VALID			(1U << 31)
+
+#define ATC_VM_APERTURE0_CNTL				0x3310u
+#define	ATS_ACCESS_MODE_NEVER				0
+#define	ATS_ACCESS_MODE_ALWAYS				1
+
+#define ATC_VM_APERTURE0_CNTL2				0x3318u
+#define ATC_VM_APERTURE0_HIGH_ADDR			0x3308u
+#define ATC_VM_APERTURE0_LOW_ADDR			0x3300u
+#define ATC_VM_APERTURE1_CNTL				0x3314u
+#define ATC_VM_APERTURE1_CNTL2				0x331Cu
+#define ATC_VM_APERTURE1_HIGH_ADDR			0x330Cu
+#define ATC_VM_APERTURE1_LOW_ADDR			0x3304u
+
+#endif
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
new file mode 100644
index 0000000..59d2407
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
@@ -0,0 +1,346 @@
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
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include "kfd_priv.h"
+#include "kfd_mqd_manager.h"
+#include "cik_regs.h"
+#include "../../radeon/cik_reg.h"
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
+static int init_mqd(struct mqd_manager *mm, void **mqd,
+		struct kfd_mem_obj **mqd_mem_obj, uint64_t *gart_addr,
+		struct queue_properties *q)
+{
+	uint64_t addr;
+	struct cik_mqd *m;
+	int retval;
+
+	BUG_ON(!mm || !q || !mqd);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	retval = kfd2kgd->allocate_mem(mm->dev->kgd,
+					sizeof(struct cik_mqd),
+					256,
+					KFD_MEMPOOL_SYSTEM_WRITECOMBINE,
+					(struct kgd_mem **) mqd_mem_obj);
+
+	if (retval != 0)
+		return -ENOMEM;
+
+	m = (struct cik_mqd *) (*mqd_mem_obj)->cpu_ptr;
+	addr = (*mqd_mem_obj)->gpu_addr;
+
+	memset(m, 0, ALIGN(sizeof(struct cik_mqd), 256));
+
+	m->header = 0xC0310800;
+	m->compute_pipelinestat_enable = 1;
+	m->compute_static_thread_mgmt_se0 = 0xFFFFFFFF;
+	m->compute_static_thread_mgmt_se1 = 0xFFFFFFFF;
+	m->compute_static_thread_mgmt_se2 = 0xFFFFFFFF;
+	m->compute_static_thread_mgmt_se3 = 0xFFFFFFFF;
+
+	/*
+	 * Make sure to use the last queue state saved on mqd when the cp
+	 * reassigns the queue, so when queue is switched on/off (e.g over
+	 * subscription or quantum timeout) the context will be consistent
+	 */
+	m->cp_hqd_persistent_state =
+				DEFAULT_CP_HQD_PERSISTENT_STATE | PRELOAD_REQ;
+
+	m->cp_mqd_control             = MQD_CONTROL_PRIV_STATE_EN;
+	m->cp_mqd_base_addr_lo        = lower_32_bits(addr);
+	m->cp_mqd_base_addr_hi        = upper_32_bits(addr);
+
+	m->cp_hqd_ib_control = DEFAULT_MIN_IB_AVAIL_SIZE | IB_ATC_EN;
+	/* Although WinKFD writes this, I suspect it should not be necessary */
+	m->cp_hqd_ib_control = IB_ATC_EN | DEFAULT_MIN_IB_AVAIL_SIZE;
+
+	m->cp_hqd_quantum = QUANTUM_EN | QUANTUM_SCALE_1MS |
+				QUANTUM_DURATION(10);
+
+	/*
+	 * Pipe Priority
+	 * Identifies the pipe relative priority when this queue is connected
+	 * to the pipeline. The pipe priority is against the GFX pipe and HP3D.
+	 * In KFD we are using a fixed pipe priority set to CS_MEDIUM.
+	 * 0 = CS_LOW (typically below GFX)
+	 * 1 = CS_MEDIUM (typically between HP3D and GFX
+	 * 2 = CS_HIGH (typically above HP3D)
+	 */
+	m->cp_hqd_pipe_priority = 1;
+	m->cp_hqd_queue_priority = 15;
+
+	*mqd = m;
+	if (gart_addr != NULL)
+		*gart_addr = addr;
+	retval = mm->update_mqd(mm, m, q);
+
+	return retval;
+}
+
+static void uninit_mqd(struct mqd_manager *mm, void *mqd,
+			struct kfd_mem_obj *mqd_mem_obj)
+{
+	BUG_ON(!mm || !mqd);
+	kfd2kgd->free_mem(mm->dev->kgd, (struct kgd_mem *) mqd_mem_obj);
+}
+
+static int load_mqd(struct mqd_manager *mm, void *mqd, uint32_t pipe_id,
+			uint32_t queue_id, uint32_t __user *wptr)
+{
+	return kfd2kgd->hqd_load(mm->dev->kgd, mqd, pipe_id, queue_id, wptr);
+
+}
+
+static int update_mqd(struct mqd_manager *mm, void *mqd,
+			struct queue_properties *q)
+{
+	struct cik_mqd *m;
+
+	BUG_ON(!mm || !q || !mqd);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	m = get_mqd(mqd);
+	m->cp_hqd_pq_control = DEFAULT_RPTR_BLOCK_SIZE |
+				DEFAULT_MIN_AVAIL_SIZE | PQ_ATC_EN;
+
+	/*
+	 * Calculating queue size which is log base 2 of actual queue size -1
+	 * dwords and another -1 for ffs
+	 */
+	m->cp_hqd_pq_control |= ffs(q->queue_size / sizeof(unsigned int))
+								- 1 - 1;
+	m->cp_hqd_pq_base_lo = lower_32_bits((uint64_t)q->queue_address >> 8);
+	m->cp_hqd_pq_base_hi = upper_32_bits((uint64_t)q->queue_address >> 8);
+	m->cp_hqd_pq_rptr_report_addr_lo = lower_32_bits((uint64_t)q->read_ptr);
+	m->cp_hqd_pq_rptr_report_addr_hi = upper_32_bits((uint64_t)q->read_ptr);
+	m->cp_hqd_pq_doorbell_control = DOORBELL_EN |
+					DOORBELL_OFFSET(q->doorbell_off);
+
+	m->cp_hqd_vmid = q->vmid;
+
+	if (q->format == KFD_QUEUE_FORMAT_AQL) {
+		m->cp_hqd_iq_rptr = AQL_ENABLE;
+		m->cp_hqd_pq_control |= NO_UPDATE_RPTR;
+	}
+
+	m->cp_hqd_active = 0;
+	q->is_active = false;
+	if (q->queue_size > 0 &&
+			q->queue_address != 0 &&
+			q->queue_percent > 0) {
+		m->cp_hqd_active = 1;
+		q->is_active = true;
+	}
+
+	return 0;
+}
+
+static int destroy_mqd(struct mqd_manager *mm, void *mqd,
+			enum kfd_preempt_type type,
+			unsigned int timeout, uint32_t pipe_id,
+			uint32_t queue_id)
+{
+	return kfd2kgd->hqd_destroy(mm->dev->kgd, type, timeout,
+					pipe_id, queue_id);
+}
+
+bool is_occupied(struct mqd_manager *mm, void *mqd,
+		uint64_t queue_address,	uint32_t pipe_id,
+		uint32_t queue_id)
+{
+
+	return kfd2kgd->hqd_is_occupies(mm->dev->kgd, queue_address,
+					pipe_id, queue_id);
+
+}
+
+/*
+ * HIQ MQD Implementation, concrete implementation for HIQ MQD implementation.
+ * The HIQ queue in Kaveri is using the same MQD structure as all the user mode
+ * queues but with different initial values.
+ */
+
+static int init_mqd_hiq(struct mqd_manager *mm, void **mqd,
+		struct kfd_mem_obj **mqd_mem_obj, uint64_t *gart_addr,
+		struct queue_properties *q)
+{
+	uint64_t addr;
+	struct cik_mqd *m;
+	int retval;
+
+	BUG_ON(!mm || !q || !mqd || !mqd_mem_obj);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	retval = kfd2kgd->allocate_mem(mm->dev->kgd,
+					sizeof(struct cik_mqd),
+					256,
+					KFD_MEMPOOL_SYSTEM_WRITECOMBINE,
+					(struct kgd_mem **) mqd_mem_obj);
+
+	if (retval != 0)
+		return -ENOMEM;
+
+	m = (struct cik_mqd *) (*mqd_mem_obj)->cpu_ptr;
+	addr = (*mqd_mem_obj)->gpu_addr;
+
+	memset(m, 0, ALIGN(sizeof(struct cik_mqd), 256));
+
+	m->header = 0xC0310800;
+	m->compute_pipelinestat_enable = 1;
+	m->compute_static_thread_mgmt_se0 = 0xFFFFFFFF;
+	m->compute_static_thread_mgmt_se1 = 0xFFFFFFFF;
+	m->compute_static_thread_mgmt_se2 = 0xFFFFFFFF;
+	m->compute_static_thread_mgmt_se3 = 0xFFFFFFFF;
+
+	m->cp_hqd_persistent_state = DEFAULT_CP_HQD_PERSISTENT_STATE |
+					PRELOAD_REQ;
+	m->cp_hqd_quantum = QUANTUM_EN | QUANTUM_SCALE_1MS |
+				QUANTUM_DURATION(10);
+
+	m->cp_mqd_control             = MQD_CONTROL_PRIV_STATE_EN;
+	m->cp_mqd_base_addr_lo        = lower_32_bits(addr);
+	m->cp_mqd_base_addr_hi        = upper_32_bits(addr);
+
+	m->cp_hqd_ib_control = DEFAULT_MIN_IB_AVAIL_SIZE;
+
+	/*
+	 * Pipe Priority
+	 * Identifies the pipe relative priority when this queue is connected
+	 * to the pipeline. The pipe priority is against the GFX pipe and HP3D.
+	 * In KFD we are using a fixed pipe priority set to CS_MEDIUM.
+	 * 0 = CS_LOW (typically below GFX)
+	 * 1 = CS_MEDIUM (typically between HP3D and GFX
+	 * 2 = CS_HIGH (typically above HP3D)
+	 */
+	m->cp_hqd_pipe_priority = 1;
+	m->cp_hqd_queue_priority = 15;
+
+	*mqd = m;
+	if (gart_addr)
+		*gart_addr = addr;
+	retval = mm->update_mqd(mm, m, q);
+
+	return retval;
+}
+
+static int update_mqd_hiq(struct mqd_manager *mm, void *mqd,
+				struct queue_properties *q)
+{
+	struct cik_mqd *m;
+
+	BUG_ON(!mm || !q || !mqd);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	m = get_mqd(mqd);
+	m->cp_hqd_pq_control = DEFAULT_RPTR_BLOCK_SIZE |
+				DEFAULT_MIN_AVAIL_SIZE |
+				PRIV_STATE |
+				KMD_QUEUE;
+
+	/*
+	 * Calculating queue size which is log base 2 of actual queue
+	 * size -1 dwords
+	 */
+	m->cp_hqd_pq_control |= ffs(q->queue_size / sizeof(unsigned int))
+								- 1 - 1;
+	m->cp_hqd_pq_base_lo = lower_32_bits((uint64_t)q->queue_address >> 8);
+	m->cp_hqd_pq_base_hi = upper_32_bits((uint64_t)q->queue_address >> 8);
+	m->cp_hqd_pq_rptr_report_addr_lo = lower_32_bits((uint64_t)q->read_ptr);
+	m->cp_hqd_pq_rptr_report_addr_hi = upper_32_bits((uint64_t)q->read_ptr);
+	m->cp_hqd_pq_doorbell_control = DOORBELL_EN |
+					DOORBELL_OFFSET(q->doorbell_off);
+
+	m->cp_hqd_vmid = q->vmid;
+
+	m->cp_hqd_active = 0;
+	q->is_active = false;
+	if (q->queue_size > 0 &&
+			q->queue_address != 0 &&
+			q->queue_percent > 0) {
+		m->cp_hqd_active = 1;
+		q->is_active = true;
+	}
+
+	return 0;
+}
+
+struct mqd_manager *mqd_manager_init(enum KFD_MQD_TYPE type,
+					struct kfd_dev *dev)
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
+		mqd->is_occupied = is_occupied;
+		break;
+	case KFD_MQD_TYPE_CIK_HIQ:
+		mqd->init_mqd = init_mqd_hiq;
+		mqd->uninit_mqd = uninit_mqd;
+		mqd->load_mqd = load_mqd;
+		mqd->update_mqd = update_mqd_hiq;
+		mqd->destroy_mqd = destroy_mqd;
+		mqd->is_occupied = is_occupied;
+		break;
+	default:
+		kfree(mqd);
+		return NULL;
+	}
+
+	return mqd;
+}
+
+/* SDMA queues should be implemented here when the cp will supports them */
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
new file mode 100644
index 0000000..213a71e
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
@@ -0,0 +1,91 @@
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
+#ifndef KFD_MQD_MANAGER_H_
+#define KFD_MQD_MANAGER_H_
+
+#include "kfd_priv.h"
+
+/**
+ * struct mqd_manager
+ *
+ * @init_mqd: Allocates the mqd buffer on local gpu memory and initialize it.
+ *
+ * @load_mqd: Loads the mqd to a concrete hqd slot. Used only for no cp
+ * scheduling mode.
+ *
+ * @update_mqd: Handles a update call for the MQD
+ *
+ * @destroy_mqd: Destroys the HQD slot and by that preempt the relevant queue.
+ * Used only for no cp scheduling.
+ *
+ * @uninit_mqd: Releases the mqd buffer from local gpu memory.
+ *
+ * @is_occupied: Checks if the relevant HQD slot is occupied.
+ *
+ * @mqd_mutex: Mqd manager mutex.
+ *
+ * @dev: The kfd device structure coupled with this module.
+ *
+ * MQD stands for Memory Queue Descriptor which represents the current queue
+ * state in the memory and initiate the HQD (Hardware Queue Descriptor) state.
+ * This structure is actually a base class for the different types of MQDs
+ * structures for the variant ASICs that should be supported in the future.
+ * This base class is also contains all the MQD specific operations.
+ * Another important thing to mention is that each queue has a MQD that keeps
+ * his state (or context) after each preemption or reassignment.
+ * Basically there are a instances of the mqd manager class per MQD type per
+ * ASIC. Currently the kfd driver supports only Kaveri so there are instances
+ * per KFD_MQD_TYPE for each device.
+ *
+ */
+
+struct mqd_manager {
+	int	(*init_mqd)(struct mqd_manager *mm, void **mqd,
+			struct kfd_mem_obj **mqd_mem_obj, uint64_t *gart_addr,
+			struct queue_properties *q);
+
+	int	(*load_mqd)(struct mqd_manager *mm, void *mqd,
+				uint32_t pipe_id, uint32_t queue_id,
+				uint32_t __user *wptr);
+
+	int	(*update_mqd)(struct mqd_manager *mm, void *mqd,
+				struct queue_properties *q);
+
+	int	(*destroy_mqd)(struct mqd_manager *mm, void *mqd,
+				enum kfd_preempt_type type,
+				unsigned int timeout, uint32_t pipe_id,
+				uint32_t queue_id);
+
+	void	(*uninit_mqd)(struct mqd_manager *mm, void *mqd,
+				struct kfd_mem_obj *mqd_mem_obj);
+
+	bool	(*is_occupied)(struct mqd_manager *mm, void *mqd,
+				uint64_t queue_address,	uint32_t pipe_id,
+				uint32_t queue_id);
+
+	struct mutex	mqd_mutex;
+	struct kfd_dev	*dev;
+};
+
+#endif /* KFD_MQD_MANAGER_H_ */
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 5f6f13d..0eb2032 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -119,6 +119,11 @@ void kfd_chardev_exit(void);
 struct device *kfd_chardev(void);
 
 
+enum kfd_preempt_type {
+	KFD_PREEMPT_TYPE_WAVEFRONT,
+	KFD_PREEMPT_TYPE_WAVEFRONT_RESET
+};
+
 /**
  * enum kfd_queue_type
  *
@@ -137,6 +142,11 @@ enum kfd_queue_type  {
 	KFD_QUEUE_TYPE_DIQ
 };
 
+enum kfd_queue_format {
+	KFD_QUEUE_FORMAT_PM4,
+	KFD_QUEUE_FORMAT_AQL
+};
+
 /**
  * struct queue_properties
  *
@@ -183,6 +193,7 @@ enum kfd_queue_type  {
  */
 struct queue_properties {
 	enum kfd_queue_type type;
+	enum kfd_queue_format format;
 	unsigned int queue_id;
 	uint64_t queue_address;
 	uint64_t  queue_size;
@@ -242,6 +253,17 @@ struct queue {
 	struct kfd_dev		*device;
 };
 
+/*
+ * Please read the kfd_mqd_manager.h description.
+ */
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
 	/*
-- 
2.1.0

