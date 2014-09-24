Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaIXVEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:04:38 -0400
Received: from mail-by2on0114.outbound.protection.outlook.com ([207.46.100.114]:42880
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753590AbaIXVEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:04:35 -0400
X-WSS-ID: 0NCFB6I-07-TA2-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 16/23] amdkfd: Add packet manager module
Date: Wed, 24 Sep 2014 23:45:30 +0300
Message-ID: <1411591537-31636-17-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(51234002)(189002)(77156001)(74662003)(21056001)(36756003)(64706001)(50466002)(90102001)(101416001)(33646002)(86362001)(46102003)(48376002)(107046002)(99396003)(93916002)(20776003)(81342003)(4396001)(92726001)(229853001)(47776003)(92566001)(81542003)(87286001)(89996001)(50226001)(79102003)(62966002)(97736003)(80022003)(88136002)(77096002)(87936001)(85852003)(83072002)(74502003)(106466001)(19580405001)(68736004)(84676001)(31966008)(76482002)(102836001)(77982003)(83322001)(44976005)(105586002)(19580395003)(85306004)(95666004)(50986999)(104166001)(76176999)(10300001)(120916001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0201MB1084;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0201MB1084;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

The packet manager module builds PM4 packets for the sole use of the CP
scheduler. Those packets are used by the HIQ to submit runlists to the CP.

v3:

Removed include of cik_mqds.h
Changed lower_32/upper_32 calls to use linux macros
Used new gart allocation functions
Added documentation

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/Makefile             |   2 +-
 drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c | 495 +++++++++++++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |  72 +++
 3 files changed, 568 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c

diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
index 020d6c7..b88e637 100644
--- a/drivers/gpu/drm/radeon/amdkfd/Makefile
+++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
@@ -7,6 +7,6 @@ ccflags-y := -Iinclude/drm
 amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_aperture.o \
 		kfd_process.o kfd_queue.o kfd_mqd_manager.o \
-		kfd_kernel_queue.o
+		kfd_kernel_queue.o kfd_packet_manager.o
 
 obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c b/drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c
new file mode 100644
index 0000000..aabc17e
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c
@@ -0,0 +1,495 @@
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
+#include <linux/mutex.h>
+#include "kfd_device_queue_manager.h"
+#include "kfd_kernel_queue.h"
+#include "kfd_priv.h"
+#include "kfd_pm4_headers.h"
+#include "kfd_pm4_opcodes.h"
+
+static inline void inc_wptr(unsigned int *wptr, unsigned int increment_bytes, unsigned int buffer_size_bytes)
+{
+	unsigned int temp = *wptr + increment_bytes / sizeof(uint32_t);
+
+	BUG_ON((temp * sizeof(uint32_t)) > buffer_size_bytes);
+	*wptr = temp;
+}
+
+static unsigned int build_pm4_header(unsigned int opcode, size_t packet_size)
+{
+	union PM4_TYPE_3_HEADER header;
+
+	header.u32all = 0;
+	header.opcode = opcode;
+	header.count = packet_size/sizeof(uint32_t) - 2;
+	header.type = PM4_TYPE_3;
+
+	return header.u32all;
+}
+
+static void pm_calc_rlib_size(struct packet_manager *pm, unsigned int *rlib_size, bool *over_subscription)
+{
+	unsigned int process_count, queue_count;
+
+	BUG_ON(!pm || !rlib_size || !over_subscription);
+
+	process_count = pm->dqm->processes_count;
+	queue_count = pm->dqm->queue_count;
+
+	/* check if there is over subscription*/
+	*over_subscription = false;
+	if ((process_count >= VMID_PER_DEVICE) ||
+			queue_count > PIPE_PER_ME_CP_SCHEDULING * QUEUES_PER_PIPE) {
+		*over_subscription = true;
+		pr_debug("kfd: over subscribed runlist\n");
+	}
+
+	/* calculate run list ib allocation size */
+	*rlib_size = process_count * sizeof(struct pm4_map_process) +
+		     queue_count * sizeof(struct pm4_map_queues);
+
+	/* increase the allocation size in case we need a chained run list when over subscription */
+	if (*over_subscription)
+		*rlib_size += sizeof(struct pm4_runlist);
+
+	pr_debug("kfd: runlist ib size %d\n", *rlib_size);
+}
+
+static int pm_allocate_runlist_ib(struct packet_manager *pm, unsigned int **rl_buffer, uint64_t *rl_gpu_buffer,
+		unsigned int *rl_buffer_size, bool *is_over_subscription)
+{
+	int retval;
+
+	BUG_ON(!pm);
+	BUG_ON(pm->allocated == true);
+	BUG_ON(is_over_subscription == NULL);
+
+	pm_calc_rlib_size(pm, rl_buffer_size, is_over_subscription);
+
+	retval = kfd2kgd->allocate_mem(pm->dqm->dev->kgd,
+					*rl_buffer_size,
+					PAGE_SIZE,
+					KFD_MEMPOOL_SYSTEM_WRITECOMBINE,
+					(struct kgd_mem **) &pm->ib_buffer_obj);
+
+	if (retval != 0) {
+		pr_err("kfd: failed to allocate runlist IB\n");
+		return retval;
+	}
+
+	*(void **)rl_buffer = pm->ib_buffer_obj->ptr;
+	*rl_gpu_buffer = pm->ib_buffer_obj->gpu_addr;
+
+	memset(*rl_buffer, 0, *rl_buffer_size);
+	pm->allocated = true;
+	return retval;
+}
+
+static int pm_create_runlist(struct packet_manager *pm, uint32_t *buffer,
+			uint64_t ib, size_t ib_size_in_dwords, bool chain)
+{
+	struct pm4_runlist *packet;
+
+	BUG_ON(!pm || !buffer || !ib);
+
+	packet = (struct pm4_runlist *)buffer;
+
+	memset(buffer, 0, sizeof(struct pm4_runlist));
+	packet->header.u32all = build_pm4_header(IT_RUN_LIST, sizeof(struct pm4_runlist));
+
+	packet->bitfields4.ib_size = ib_size_in_dwords;
+	packet->bitfields4.chain = chain ? 1 : 0;
+	packet->bitfields4.offload_polling = 0;
+	packet->bitfields4.valid = 1;
+	packet->bitfields4.vmid = 0;
+	packet->ordinal2 = lower_32_bits(ib);
+	packet->bitfields3.ib_base_hi = upper_32_bits(ib);
+
+	return 0;
+}
+
+static int pm_create_map_process(struct packet_manager *pm, uint32_t *buffer, struct qcm_process_device *qpd)
+{
+	struct pm4_map_process *packet;
+
+	BUG_ON(!pm || !buffer || !qpd);
+
+	packet = (struct pm4_map_process *)buffer;
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	memset(buffer, 0, sizeof(struct pm4_map_process));
+
+	packet->header.u32all = build_pm4_header(IT_MAP_PROCESS, sizeof(struct pm4_map_process));
+	packet->bitfields2.diq_enable = (qpd->is_debug) ? 1 : 0;
+	packet->bitfields2.pasid = qpd->pqm->process->pasid;
+	packet->bitfields3.page_table_base = qpd->page_table_base;
+	packet->bitfields4.gds_size = qpd->gds_size;
+	packet->bitfields4.num_gws = qpd->num_gws;
+	packet->bitfields4.num_oac = qpd->num_oac;
+
+	packet->sh_mem_config = qpd->sh_mem_config;
+	packet->sh_mem_bases = qpd->sh_mem_bases;
+	packet->sh_mem_ape1_base = qpd->sh_mem_ape1_base;
+	packet->sh_mem_ape1_limit = qpd->sh_mem_ape1_limit;
+
+	packet->gds_addr_lo = lower_32_bits(qpd->gds_context_area);
+	packet->gds_addr_hi = upper_32_bits(qpd->gds_context_area);
+
+	return 0;
+}
+
+static int pm_create_map_queue(struct packet_manager *pm, uint32_t *buffer, struct queue *q)
+{
+	struct pm4_map_queues *packet;
+
+	BUG_ON(!pm || !buffer || !q);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	packet = (struct pm4_map_queues *)buffer;
+	memset(buffer, 0, sizeof(struct pm4_map_queues));
+
+	packet->header.u32all = build_pm4_header(IT_MAP_QUEUES, sizeof(struct pm4_map_queues));
+	packet->bitfields2.alloc_format = alloc_format___map_queues__one_per_pipe;
+	packet->bitfields2.num_queues = 1;
+	packet->bitfields2.queue_sel = queue_sel___map_queues__map_to_hws_determined_queue_slots;
+	packet->bitfields2.vidmem = (q->properties.is_interop) ? vidmem___map_queues__uses_video_memory :
+			vidmem___map_queues__uses_no_video_memory;
+
+	switch (q->properties.type) {
+	case KFD_QUEUE_TYPE_COMPUTE:
+	case KFD_QUEUE_TYPE_DIQ:
+		packet->bitfields2.engine_sel = engine_sel___map_queues__compute;
+		break;
+	case KFD_QUEUE_TYPE_SDMA:
+		packet->bitfields2.engine_sel = engine_sel___map_queues__sdma0_queue;
+		break;
+	default:
+		BUG();
+		break;
+	}
+
+	packet->_map_queues_ordinals[0].bitfields3.doorbell_offset = q->properties.doorbell_off;
+	packet->_map_queues_ordinals[0].mqd_addr_lo = lower_32_bits(q->gart_mqd_addr);
+	packet->_map_queues_ordinals[0].mqd_addr_hi = upper_32_bits(q->gart_mqd_addr);
+	packet->_map_queues_ordinals[0].wptr_addr_lo = lower_32_bits((uint64_t)q->properties.write_ptr);
+	packet->_map_queues_ordinals[0].wptr_addr_hi = upper_32_bits((uint64_t)q->properties.write_ptr);
+
+	return 0;
+}
+
+static int pm_create_runlist_ib(struct packet_manager *pm, struct list_head *queues,
+				uint64_t *rl_gpu_addr, size_t *rl_size_bytes)
+{
+	unsigned int alloc_size_bytes;
+	unsigned int *rl_buffer, rl_wptr, i;
+	int retval, proccesses_mapped;
+	struct device_process_node *cur;
+	struct qcm_process_device *qpd;
+	struct queue *q;
+	struct kernel_queue *kq;
+	bool is_over_subscription;
+
+	BUG_ON(!pm || !queues || !rl_size_bytes || !rl_gpu_addr);
+
+	rl_wptr = retval = proccesses_mapped = 0;
+
+	retval = pm_allocate_runlist_ib(pm, &rl_buffer, rl_gpu_addr, &alloc_size_bytes, &is_over_subscription);
+	if (retval != 0)
+		return retval;
+
+	*rl_size_bytes = alloc_size_bytes;
+
+	pr_debug("kfd: In func %s\n", __func__);
+	pr_debug("kfd: building runlist ib process count: %d queues count %d\n", pm->dqm->processes_count,
+			pm->dqm->queue_count);
+
+	/* build the run list ib packet */
+	list_for_each_entry(cur, queues, list) {
+		qpd = cur->qpd;
+		/* build map process packet */
+		if (proccesses_mapped >= pm->dqm->processes_count) {
+			pr_debug("kfd: not enough space left in runlist IB\n");
+			pm_release_ib(pm);
+			return -ENOMEM;
+		}
+		retval = pm_create_map_process(pm, &rl_buffer[rl_wptr], qpd);
+		if (retval != 0)
+			return retval;
+		proccesses_mapped++;
+		inc_wptr(&rl_wptr, sizeof(struct pm4_map_process), alloc_size_bytes);
+		list_for_each_entry(kq, &qpd->priv_queue_list, list) {
+			if (kq->queue->properties.is_active != true)
+				continue;
+			retval = pm_create_map_queue(pm, &rl_buffer[rl_wptr], kq->queue);
+			if (retval != 0)
+				return retval;
+			inc_wptr(&rl_wptr, sizeof(struct pm4_map_queues), alloc_size_bytes);
+		}
+
+		list_for_each_entry(q, &qpd->queues_list, list) {
+			if (q->properties.is_active != true)
+				continue;
+			retval = pm_create_map_queue(pm, &rl_buffer[rl_wptr], q);
+			if (retval != 0)
+				return retval;
+			inc_wptr(&rl_wptr, sizeof(struct pm4_map_queues), alloc_size_bytes);
+		}
+	}
+
+	pr_debug("kfd: finished map process and queues to runlist\n");
+
+	if (is_over_subscription)
+		pm_create_runlist(pm, &rl_buffer[rl_wptr], *rl_gpu_addr, alloc_size_bytes / sizeof(uint32_t), true);
+
+	for (i = 0; i < alloc_size_bytes / sizeof(uint32_t); i++)
+		pr_debug("0x%2X ", rl_buffer[i]);
+	pr_debug("\n");
+
+	return 0;
+}
+
+int pm_init(struct packet_manager *pm, struct device_queue_manager *dqm)
+{
+	BUG_ON(!dqm);
+
+	pm->dqm = dqm;
+	mutex_init(&pm->lock);
+	pm->priv_queue = kernel_queue_init(dqm->dev, KFD_QUEUE_TYPE_HIQ);
+	if (pm->priv_queue == NULL) {
+		mutex_destroy(&pm->lock);
+		return -ENOMEM;
+	}
+	pm->allocated = false;
+
+	return 0;
+}
+
+void pm_uninit(struct packet_manager *pm)
+{
+	BUG_ON(!pm);
+
+	mutex_destroy(&pm->lock);
+	kernel_queue_uninit(pm->priv_queue);
+}
+
+int pm_send_set_resources(struct packet_manager *pm, struct scheduling_resources *res)
+{
+	struct pm4_set_resources *packet;
+
+	BUG_ON(!pm || !res);
+
+	pr_debug("kfd: In func %s\n", __func__);
+
+	mutex_lock(&pm->lock);
+	pm->priv_queue->acquire_packet_buffer(pm->priv_queue, sizeof(*packet) / sizeof(uint32_t),
+			(unsigned int **)&packet);
+	if (packet == NULL) {
+		mutex_unlock(&pm->lock);
+		pr_err("kfd: failed to allocate buffer on kernel queue\n");
+		return -ENOMEM;
+	}
+
+	memset(packet, 0, sizeof(struct pm4_set_resources));
+	packet->header.u32all = build_pm4_header(IT_SET_RESOURCES, sizeof(struct pm4_set_resources));
+
+	packet->bitfields2.queue_type = queue_type___set_resources__hsa_interface_queue_hiq;
+	packet->bitfields2.vmid_mask = res->vmid_mask;
+	packet->bitfields2.unmap_latency = KFD_UNMAP_LATENCY;
+	packet->bitfields3.oac_mask = res->oac_mask;
+	packet->bitfields4.gds_heap_base = res->gds_heap_base;
+	packet->bitfields4.gds_heap_size = res->gds_heap_size;
+
+	packet->gws_mask_lo = lower_32_bits(res->gws_mask);
+	packet->gws_mask_hi = upper_32_bits(res->gws_mask);
+
+	packet->queue_mask_lo = lower_32_bits(res->queue_mask);
+	packet->queue_mask_hi = upper_32_bits(res->queue_mask);
+
+	pm->priv_queue->submit_packet(pm->priv_queue);
+	pm->priv_queue->sync_with_hw(pm->priv_queue, KFD_HIQ_TIMEOUT);
+
+	mutex_unlock(&pm->lock);
+
+	return 0;
+}
+
+int pm_send_runlist(struct packet_manager *pm, struct list_head *dqm_queues)
+{
+	uint64_t rl_gpu_ib_addr;
+	uint32_t *rl_buffer;
+	size_t rl_ib_size, packet_size_dwords;
+	int retval;
+
+	BUG_ON(!pm || !dqm_queues);
+
+	retval = pm_create_runlist_ib(pm, dqm_queues, &rl_gpu_ib_addr, &rl_ib_size);
+	if (retval != 0)
+		goto fail_create_runlist_ib;
+
+	pr_debug("kfd: runlist IB address: 0x%llX\n", rl_gpu_ib_addr);
+
+	packet_size_dwords = sizeof(struct pm4_runlist) / sizeof(uint32_t);
+	mutex_lock(&pm->lock);
+
+	retval = pm->priv_queue->acquire_packet_buffer(pm->priv_queue, packet_size_dwords, &rl_buffer);
+	if (retval != 0)
+		goto fail_acquire_packet_buffer;
+
+	retval = pm_create_runlist(pm, rl_buffer, rl_gpu_ib_addr, rl_ib_size / sizeof(uint32_t), false);
+	if (retval != 0)
+		goto fail_create_runlist;
+
+	pm->priv_queue->submit_packet(pm->priv_queue);
+	pm->priv_queue->sync_with_hw(pm->priv_queue, KFD_HIQ_TIMEOUT);
+
+	mutex_unlock(&pm->lock);
+
+	return retval;
+
+fail_create_runlist:
+	pm->priv_queue->rollback_packet(pm->priv_queue);
+fail_acquire_packet_buffer:
+	mutex_unlock(&pm->lock);
+fail_create_runlist_ib:
+	if (pm->allocated == true)
+		pm_release_ib(pm);
+	return retval;
+}
+
+int pm_send_query_status(struct packet_manager *pm, uint64_t fence_address, uint32_t fence_value)
+{
+	int retval;
+	struct pm4_query_status *packet;
+
+	BUG_ON(!pm || !fence_address);
+
+	mutex_lock(&pm->lock);
+	retval = pm->priv_queue->acquire_packet_buffer(pm->priv_queue,
+			sizeof(struct pm4_query_status) / sizeof(uint32_t), (unsigned int **)&packet);
+	if (retval != 0)
+		goto fail_acquire_packet_buffer;
+
+	packet->header.u32all = build_pm4_header(IT_QUERY_STATUS, sizeof(struct pm4_query_status));
+
+	packet->bitfields2.context_id = 0;
+	packet->bitfields2.interrupt_sel = interrupt_sel___query_status__completion_status;
+	packet->bitfields2.command = command___query_status__fence_only_after_write_ack;
+
+	packet->addr_hi = upper_32_bits((uint64_t)fence_address);
+	packet->addr_lo = lower_32_bits((uint64_t)fence_address);
+	packet->data_hi = upper_32_bits((uint64_t)fence_value);
+	packet->data_lo = lower_32_bits((uint64_t)fence_value);
+
+	pm->priv_queue->submit_packet(pm->priv_queue);
+	pm->priv_queue->sync_with_hw(pm->priv_queue, KFD_HIQ_TIMEOUT);
+	mutex_unlock(&pm->lock);
+
+	return 0;
+
+fail_acquire_packet_buffer:
+	mutex_unlock(&pm->lock);
+	return retval;
+}
+
+int pm_send_unmap_queue(struct packet_manager *pm, enum kfd_queue_type type,
+			enum kfd_preempt_type_filter mode, uint32_t filter_param, bool reset)
+{
+	int retval;
+	uint32_t *buffer;
+	struct pm4_unmap_queues *packet;
+
+	BUG_ON(!pm);
+
+	mutex_lock(&pm->lock);
+	retval = pm->priv_queue->acquire_packet_buffer(pm->priv_queue,
+				sizeof(struct pm4_unmap_queues) / sizeof(uint32_t), &buffer);
+	if (retval != 0)
+		goto err_acquire_packet_buffer;
+
+	packet = (struct pm4_unmap_queues *)buffer;
+	memset(buffer, 0, sizeof(struct pm4_unmap_queues));
+
+	packet->header.u32all = build_pm4_header(IT_UNMAP_QUEUES, sizeof(struct pm4_unmap_queues));
+	switch (type) {
+	case KFD_QUEUE_TYPE_COMPUTE:
+	case KFD_QUEUE_TYPE_DIQ:
+		packet->bitfields2.engine_sel = engine_sel___unmap_queues__compute;
+		break;
+	case KFD_QUEUE_TYPE_SDMA:
+		packet->bitfields2.engine_sel = engine_sel___unmap_queues__sdma0;
+		break;
+	default:
+		BUG();
+		break;
+	}
+
+	if (reset)
+		packet->bitfields2.action = action___unmap_queues__reset_queues;
+	else
+		packet->bitfields2.action = action___unmap_queues__preempt_queues;
+
+	switch (mode) {
+	case KFD_PREEMPT_TYPE_FILTER_SINGLE_QUEUE:
+	    packet->bitfields2.queue_sel = queue_sel___unmap_queues__perform_request_on_specified_queues;
+	    packet->bitfields2.num_queues = 1;
+	    packet->bitfields4.doorbell_offset0 = filter_param;
+	    break;
+	case KFD_PRERMPT_TYPE_FILTER_BY_PASID:
+	    packet->bitfields2.queue_sel = queue_sel___unmap_queues__perform_request_on_pasid_queues;
+	    packet->bitfields3.pasid = filter_param;
+	    break;
+	case KFD_PRERMPT_TYPE_FILTER_ALL_QUEUES:
+	    packet->bitfields2.queue_sel = queue_sel___unmap_queues__perform_request_on_all_active_queues;
+	    break;
+	default:
+	    BUG();
+	    break;
+	};
+
+	pm->priv_queue->submit_packet(pm->priv_queue);
+	pm->priv_queue->sync_with_hw(pm->priv_queue, KFD_HIQ_TIMEOUT);
+
+	mutex_unlock(&pm->lock);
+	return 0;
+
+err_acquire_packet_buffer:
+	mutex_unlock(&pm->lock);
+	return retval;
+}
+
+void pm_release_ib(struct packet_manager *pm)
+{
+	BUG_ON(!pm);
+
+	mutex_lock(&pm->lock);
+	if (pm->allocated) {
+		kfd2kgd->free_mem(pm->dqm->dev->kgd,
+				(struct kgd_mem *) pm->ib_buffer_obj);
+		pm->allocated = false;
+	}
+	mutex_unlock(&pm->lock);
+}
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 5835d07..34028f8 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -159,6 +159,21 @@ int kfd_chardev_init(void);
 void kfd_chardev_exit(void);
 struct device *kfd_chardev(void);
 
+/**
+ * enum kfd_preempt_type_filter
+ *
+ * @KFD_PREEMPT_TYPE_FILTER_SINGLE_QUEUE: Preempts single queue.
+ *
+ * @KFD_PRERMPT_TYPE_FILTER_ALL_QUEUES: Preempts all queues in the running queues list.
+ *
+ * @KFD_PRERMPT_TYPE_FILTER_BY_PASID: Preempts queues that belongs to specific process.
+ *
+ */
+enum kfd_preempt_type_filter {
+	KFD_PREEMPT_TYPE_FILTER_SINGLE_QUEUE,
+	KFD_PRERMPT_TYPE_FILTER_ALL_QUEUES,
+	KFD_PRERMPT_TYPE_FILTER_BY_PASID
+};
 
 /**
  * enum kfd_queue_type
@@ -293,6 +308,51 @@ enum KFD_MQD_TYPE {
 	KFD_MQD_TYPE_MAX
 };
 
+struct scheduling_resources {
+	unsigned int vmid_mask;
+	enum kfd_queue_type type;
+	uint64_t queue_mask;
+	uint64_t gws_mask;
+	uint32_t oac_mask;
+	uint32_t gds_heap_base;
+	uint32_t gds_heap_size;
+};
+
+struct process_queue_manager {
+	/* data */
+	struct kfd_process	*process;
+	unsigned int		num_concurrent_processes;
+	struct list_head	queues;
+	unsigned long		*queue_slot_bitmap;
+};
+
+struct qcm_process_device {
+	/* The Device Queue Manager that owns this data */
+	struct device_queue_manager *dqm;
+	struct process_queue_manager *pqm;
+	/* Device Queue Manager lock */
+	struct mutex *lock;
+	/* Queues list */
+	struct list_head queues_list;
+	struct list_head priv_queue_list;
+
+	unsigned int queue_count;
+	unsigned int vmid;
+	bool is_debug;
+	/*
+	 * All the memory management data should be here too
+	 */
+	uint64_t gds_context_area;
+	uint32_t sh_mem_config;
+	uint32_t sh_mem_bases;
+	uint32_t sh_mem_ape1_base;
+	uint32_t sh_mem_ape1_limit;
+	uint32_t page_table_base;
+	uint32_t gds_size;
+	uint32_t num_gws;
+	uint32_t num_oac;
+};
+
 /* Data that is per-process-per device. */
 struct kfd_process_device {
 	/*
@@ -412,12 +472,22 @@ int kgd2kfd_resume(struct kfd_dev *dev);
 int kfd_init_apertures(struct kfd_process *process);
 
 /* Queue Context Management */
+inline uint32_t lower_32(uint64_t x);
+inline uint32_t upper_32(uint64_t x);
+
 int init_queue(struct queue **q, struct queue_properties properties);
 void uninit_queue(struct queue *q);
 void print_queue(struct queue *q);
 
+struct kernel_queue *kernel_queue_init(struct kfd_dev *dev, enum kfd_queue_type type);
+void kernel_queue_uninit(struct kernel_queue *kq);
+
 /* Packet Manager */
 
+#define KFD_HIQ_TIMEOUT (500)
+
+#define KFD_UNMAP_LATENCY (15)
+
 struct packet_manager {
 	struct device_queue_manager *dqm;
 	struct kernel_queue *priv_queue;
@@ -426,6 +496,8 @@ struct packet_manager {
 	struct kfd_mem_obj *ib_buffer_obj;
 };
 
+void pm_release_ib(struct packet_manager *pm);
+
 uint64_t kfd_get_number_elems(struct kfd_dev *kfd);
 phys_addr_t kfd_get_process_doorbells(struct kfd_dev *dev,
 					struct kfd_process *process);
-- 
1.9.1

