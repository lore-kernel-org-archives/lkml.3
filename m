Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaGQNcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:32:54 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:45999
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756732AbaGQNcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:32:51 -0400
X-WSS-ID: 0N8UYYL-07-C1F-02
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
Subject: [PATCH v2 13/25] amdkfd: Add queue module
Date: Thu, 17 Jul 2014 16:29:20 +0300
Message-ID: <1405603773-32688-14-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(101416001)(84676001)(92566001)(83072002)(20776003)(76176999)(104166001)(102836001)(68736004)(31966008)(76482001)(46102001)(93916002)(33646002)(106466001)(95666004)(97736001)(50986999)(80022001)(92726001)(50226001)(47776003)(62966002)(81342001)(79102001)(21056001)(86362001)(85306003)(77096002)(87286001)(64706001)(74502001)(87936001)(229853001)(36756003)(77156001)(81542001)(77982001)(85852003)(4396001)(48376002)(50466002)(107046002)(19580405001)(83322001)(44976005)(89996001)(19580395003)(105586002)(74662001)(99396002)(88136002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB041;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

The queue module enables allocating and initializing queues uniformly.

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/Makefile    |   2 +-
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h  |  48 +++++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_queue.c | 109 ++++++++++++++++++++++++++++++
 3 files changed, 158 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_queue.c

diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
index daf75a8..dbff147 100644
--- a/drivers/gpu/drm/radeon/amdkfd/Makefile
+++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
@@ -6,6 +6,6 @@ ccflags-y := -Iinclude/drm
 
 amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_vidmem.o kfd_aperture.o \
-		kfd_process.o
+		kfd_process.o kfd_queue.o
 
 obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 604c317..94ff1c3 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -65,6 +65,9 @@ typedef unsigned int pasid_t;
 /* Type that represents a HW doorbell slot. */
 typedef u32 doorbell_t;
 
+/* Type that represents queue pointer */
+typedef u32 qptr_t;
+
 struct kfd_device_info {
 	const struct kfd_scheduler_class *scheduler_class;
 	unsigned int max_pasid_bits;
@@ -125,12 +128,57 @@ void kfd_vidmem_unkmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
 int kfd_vidmem_alloc_map(struct kfd_dev *kfd, kfd_mem_obj *mem_obj, void **ptr,
 			uint64_t *vmid0_address, size_t size);
 void kfd_vidmem_free_unmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
+
 /* Character device interface */
 int kfd_chardev_init(void);
 void kfd_chardev_exit(void);
 struct device *kfd_chardev(void);
 
 
+enum kfd_queue_type  {
+	KFD_QUEUE_TYPE_COMPUTE,
+	KFD_QUEUE_TYPE_SDMA,
+	KFD_QUEUE_TYPE_HIQ,
+	KFD_QUEUE_TYPE_DIQ
+};
+
+struct queue_properties {
+	enum kfd_queue_type type;
+	unsigned int queue_id;
+	uint64_t queue_address;
+	uint64_t  queue_size;
+	uint32_t priority;
+	uint32_t queue_percent;
+	qptr_t *read_ptr;
+	qptr_t *write_ptr;
+	qptr_t *doorbell_ptr;
+	qptr_t doorbell_off;
+	bool is_interop;
+	bool is_active;
+	/* Not relevant for user mode queues in cp scheduling */
+	unsigned int vmid;
+};
+
+struct queue {
+	struct list_head list;
+	void *mqd;
+	/* kfd_mem_obj contains the mqd */
+	kfd_mem_obj mqd_mem_obj;
+	uint64_t gart_mqd_addr; /* needed for cp scheduling */
+	struct queue_properties properties;
+
+	/*
+	 * Used by the queue device manager to track the hqd slot per queue
+	 * when using no cp scheduling
+	 */
+	uint32_t mec;
+	uint32_t pipe;
+	uint32_t queue;
+
+	struct kfd_process	*process;
+	struct kfd_dev		*device;
+};
+
 /* Data that is per-process-per device. */
 struct kfd_process_device {
 	/*
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_queue.c b/drivers/gpu/drm/radeon/amdkfd/kfd_queue.c
new file mode 100644
index 0000000..646b6d1
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_queue.c
@@ -0,0 +1,109 @@
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
+#include "kfd_priv.h"
+
+void print_queue_properties(struct queue_properties *q)
+{
+	if (!q)
+		return;
+
+	pr_debug("Printing queue properties\n"
+			"Queue Type: %u\n"
+			"Queue Size: %llu\n"
+			"Queue percent: %u\n"
+			"Queue Address: 0x%llX\n"
+			"Queue Id: %u\n"
+			"Queue Process Vmid: %u\n"
+			"Queue Read Pointer: 0x%p\n"
+			"Queue Write Pointer: 0x%p\n"
+			"Queue Doorbell Pointer: 0x%p\n"
+			"Queue Doorbell Offset: %u\n",  q->type,
+							q->queue_size,
+							q->queue_percent,
+							q->queue_address,
+							q->queue_id,
+							q->vmid,
+							q->read_ptr,
+							q->write_ptr,
+							q->doorbell_ptr,
+							q->doorbell_off);
+}
+
+void print_queue(struct queue *q)
+{
+	if (!q)
+		return;
+	pr_debug("Printing queue\n"
+			"Queue Type: %u\n"
+			"Queue Size: %llu\n"
+			"Queue percent: %u\n"
+			"Queue Address: 0x%llX\n"
+			"Queue Id: %u\n"
+			"Queue Process Vmid: %u\n"
+			"Queue Read Pointer: 0x%p\n"
+			"Queue Write Pointer: 0x%p\n"
+			"Queue Doorbell Pointer: 0x%p\n"
+			"Queue Doorbell Offset: %u\n"
+			"Queue MQD Address: 0x%p\n"
+			"Queue MQD Gart: 0x%llX\n"
+			"Queue Process Address: 0x%p\n"
+			"Queue Device Address: 0x%p\n",
+					q->properties.type,
+					q->properties.queue_size,
+					q->properties.queue_percent,
+					q->properties.queue_address,
+					q->properties.queue_id,
+					q->properties.vmid,
+					q->properties.read_ptr,
+					q->properties.write_ptr,
+					q->properties.doorbell_ptr,
+					q->properties.doorbell_off,
+					q->mqd,
+					q->gart_mqd_addr,
+					q->process,
+					q->device);
+}
+
+int init_queue(struct queue **q, struct queue_properties properties)
+{
+	struct queue *tmp;
+
+	BUG_ON(!q);
+
+	tmp = kzalloc(sizeof(struct queue), GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	memset(&tmp->properties, 0, sizeof(struct queue_properties));
+	memcpy(&tmp->properties, &properties, sizeof(struct queue_properties));
+
+	*q = tmp;
+	return 0;
+}
+
+void uninit_queue(struct queue *q)
+{
+	kfree(q);
+}
-- 
1.9.1

