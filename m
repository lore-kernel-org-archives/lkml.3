Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbaHEPgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:36:45 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:33130
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755854AbaHEPcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:32:53 -0400
X-WSS-ID: 0N9UB6B-07-3G7-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@linux.ie>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>, <Andrew.Lewycky@amd.com>,
        <deathsimple@vodafone.de>, <michel.daenzer@amd.com>,
        Ben Goz <ben.goz@amd.com>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v3 12/23] amdkfd: Add queue module
Date: Tue, 5 Aug 2014 18:30:40 +0300
Message-ID: <1407252651-3539-13-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51234002)(199002)(189002)(47776003)(87936001)(36756003)(83322001)(44976005)(19580395003)(19580405001)(77982001)(64706001)(20776003)(87286001)(76482001)(80022001)(74662001)(575784001)(104166001)(33646002)(229853001)(74502001)(86362001)(77096002)(50226001)(21056001)(62966002)(68736004)(101416001)(99396002)(92726001)(84676001)(107046002)(50986999)(31966008)(102836001)(77156001)(97736001)(92566001)(79102001)(48376002)(4396001)(106466001)(83072002)(46102001)(81542001)(85852003)(105586002)(50466002)(88136002)(81342001)(95666004)(89996001)(85306004)(76176999);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB047;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

The queue module enables allocating and initializing queues uniformly.

v3: remove typedef
v3: break pr_debug to one line
v3: remove memset
v3: add documentation

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/Makefile    |   2 +-
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h  | 123 +++++++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/amdkfd/kfd_queue.c |  85 +++++++++++++++++++++
 3 files changed, 208 insertions(+), 2 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_queue.c

diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
index 6d6746e..392728a 100644
--- a/drivers/gpu/drm/radeon/amdkfd/Makefile
+++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
@@ -6,6 +6,6 @@ ccflags-y := -Iinclude/drm
 
 amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_aperture.o \
-		kfd_process.o
+		kfd_process.o kfd_queue.o
 
 obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index b55b1cb..cf6d40d 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -56,7 +56,6 @@ extern int max_num_of_queues_per_process;
 #define KFD_MAX_NUM_OF_QUEUES_PER_PROCESS_DEFAULT 128
 #define KFD_MAX_NUM_OF_QUEUES_PER_PROCESS 1024
 
-
 struct kfd_device_info {
 	const struct kfd_scheduler_class *scheduler_class;
 	unsigned int max_pasid_bits;
@@ -116,6 +115,128 @@ void kfd_chardev_exit(void);
 struct device *kfd_chardev(void);
 
 
+/**
+ * enum kfd_queue_type
+ *
+ * @KFD_QUEUE_TYPE_COMPUTE: Regular user mode queue type.
+ *
+ * @KFD_QUEUE_TYPE_SDMA: Sdma user mode queue type.
+ *
+ * @KFD_QUEUE_TYPE_HIQ: HIQ queue type.
+ *
+ * @KFD_QUEUE_TYPE_DIQ: DIQ queue type.
+ */
+enum kfd_queue_type  {
+	KFD_QUEUE_TYPE_COMPUTE,
+	KFD_QUEUE_TYPE_SDMA,
+	KFD_QUEUE_TYPE_HIQ,
+	KFD_QUEUE_TYPE_DIQ
+};
+
+/**
+ * struct queue_properties
+ *
+ * @type: The queue type.
+ *
+ * @queue_id: Queue identifier.
+ *
+ * @queue_address: Queue ring buffer address.
+ *
+ * @queue_size: Queue ring buffer size.
+ *
+ * @priority: Defines the queue priority relative to other queues in the process.
+ * This is just an indication and HW scheduling may override the priority as
+ * necessary while keeping the relative prioritization.
+ * the priority granularity is from 0 to f which f is the highest priority.
+ * currently all queues are initialized with the highest priority.
+ *
+ * @queue_percent: This field is partially implemented and currently a zero in
+ * this field defines that the queue is non active.
+ *
+ * @read_ptr: User space address which points to the number of dwords the
+ * cp read from the ring buffer. This field updates automatically by the H/W.
+ *
+ * @write_ptr: Defines the number of dwords written to the ring buffer.
+ *
+ * @doorbell_ptr: This field aim is to notify the H/W of new packet written to
+ * the queue ring buffer. This field should be similar to write_ptr and the user
+ * should update this field after he updated the write_ptr.
+ *
+ * @doorbell_off: The doorbell offset in the doorbell pci-bar.
+ *
+ * @is_interop: Defines if this is a interop queue. Interop queue means that the
+ * queue can access both graphics and compute resources.
+ *
+ * @is_active: Defines if the queue is active or not.
+ *
+ * @vmid: If the scheduling mode is no cp scheduling the field defines the vmid
+ * of the queue.
+ *
+ * This structure represents the queue properties for each queue no matter if
+ * it's user mode or kernel mode queue.
+ *
+ */
+struct queue_properties {
+	enum kfd_queue_type type;
+	unsigned int queue_id;
+	uint64_t queue_address;
+	uint64_t  queue_size;
+	uint32_t priority;
+	uint32_t queue_percent;
+	uint32_t *read_ptr;
+	uint32_t *write_ptr;
+	uint32_t *doorbell_ptr;
+	uint32_t doorbell_off;
+	bool is_interop;
+	bool is_active;
+	/* Not relevant for user mode queues in cp scheduling */
+	unsigned int vmid;
+};
+
+/**
+ * struct queue
+ *
+ * @list: Queue linked list.
+ *
+ * @mqd: The queue MQD.
+ *
+ * @mqd_mem_obj: The MQD local gpu memory object.
+ *
+ * @gart_mqd_addr: The MQD gart mc address.
+ *
+ * @properties: The queue properties.
+ *
+ * @mec: Used only in no cp scheduling mode and identifies to micro engine id
+ * that the queue should be execute on.
+ *
+ * @pipe: Used only in no cp scheduling mode and identifies the queue's pipe id.
+ *
+ * @queue: Used only in no cp scheduliong mode and identifies the queue's slot.
+ *
+ * @process: The kfd process that created this queue.
+ *
+ * @device: The kfd device that created this queue.
+ *
+ * This structure represents user mode compute queues.
+ * It contains all the necessary data to handle such queues.
+ *
+ */
+
+struct queue {
+	struct list_head list;
+	void *mqd;
+	struct kfd_mem_obj *mqd_mem_obj;
+	uint64_t gart_mqd_addr;
+	struct queue_properties properties;
+
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
index 0000000..9a0c90b
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_queue.c
@@ -0,0 +1,85 @@
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
+	pr_debug("Printing queue properties:\n");
+	pr_debug("Queue Type: %u\n", q->type);
+	pr_debug("Queue Size: %llu\n", q->queue_size);
+	pr_debug("Queue percent: %u\n", q->queue_percent);
+	pr_debug("Queue Address: 0x%llX\n", q->queue_address);
+	pr_debug("Queue Id: %u\n", q->queue_id);
+	pr_debug("Queue Process Vmid: %u\n", q->vmid);
+	pr_debug("Queue Read Pointer: 0x%p\n", q->read_ptr);
+	pr_debug("Queue Write Pointer: 0x%p\n", q->write_ptr);
+	pr_debug("Queue Doorbell Pointer: 0x%p\n", q->doorbell_ptr);
+	pr_debug("Queue Doorbell Offset: %u\n", q->doorbell_off);
+}
+
+void print_queue(struct queue *q)
+{
+	if (!q)
+		return;
+	pr_debug("Printing queue:\n");
+	pr_debug("Queue Type: %u\n", q->properties.type);
+	pr_debug("Queue Size: %llu\n", q->properties.queue_size);
+	pr_debug("Queue percent: %u\n", q->properties.queue_percent);
+	pr_debug("Queue Address: 0x%llX\n", q->properties.queue_address);
+	pr_debug("Queue Id: %u\n", q->properties.queue_id);
+	pr_debug("Queue Process Vmid: %u\n", q->properties.vmid);
+	pr_debug("Queue Read Pointer: 0x%p\n", q->properties.read_ptr);
+	pr_debug("Queue Write Pointer: 0x%p\n", q->properties.write_ptr);
+	pr_debug("Queue Doorbell Pointer: 0x%p\n", q->properties.doorbell_ptr);
+	pr_debug("Queue Doorbell Offset: %u\n", q->properties.doorbell_off);
+	pr_debug("Queue MQD Address: 0x%p\n", q->mqd);
+	pr_debug("Queue MQD Gart: 0x%llX\n", q->gart_mqd_addr);
+	pr_debug("Queue Process Address: 0x%p\n", q->process);
+	pr_debug("Queue Device Address: 0x%p\n", q->device);
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

