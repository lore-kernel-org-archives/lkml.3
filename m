Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaGJVwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:52:00 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63266 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaGJVv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:51:58 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 16/83] hsa/radeon: Add the isr function of the KFD scehduler
Date: Fri, 11 Jul 2014 00:50:16 +0300
Message-Id: <1405029027-6085-15-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the isr function to the KFD scheduler code. This
function us called from the kgd2kfd_interrupt function which is
an interrupt-context function.

The purpose of the isr function is to determine whether the interrupt
that arrived is interesting, i.e. some action need to be taken.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/cik_int.h              | 50 ++++++++++++++++++++++++
 drivers/gpu/hsa/radeon/cik_regs.h             |  2 +
 drivers/gpu/hsa/radeon/kfd_sched_cik_static.c | 56 +++++++++++++++++++++++++++
 3 files changed, 108 insertions(+)
 create mode 100644 drivers/gpu/hsa/radeon/cik_int.h

diff --git a/drivers/gpu/hsa/radeon/cik_int.h b/drivers/gpu/hsa/radeon/cik_int.h
new file mode 100644
index 0000000..e98551d
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/cik_int.h
@@ -0,0 +1,50 @@
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
+#ifndef HSA_RADEON_CIK_INT_H_INCLUDED
+#define HSA_RADEON_CIK_INT_H_INCLUDED
+
+#include <linux/types.h>
+
+struct cik_ih_ring_entry {
+	uint32_t source_id	: 8;
+	uint32_t reserved1	: 8;
+	uint32_t reserved2	: 16;
+
+	uint32_t data		: 28;
+	uint32_t reserved3	: 4;
+
+	/* pipeid, meid and unused3 are officially called RINGID,
+	 * but for our purposes, they always decode into pipe and ME. */
+	uint32_t pipeid		: 2;
+	uint32_t meid		: 2;
+	uint32_t reserved4	: 4;
+	uint32_t vmid		: 8;
+	uint32_t pasid		: 16;
+
+	uint32_t reserved5;
+};
+
+#define CIK_INTSRC_DEQUEUE_COMPLETE	0xC6
+
+#endif
+
diff --git a/drivers/gpu/hsa/radeon/cik_regs.h b/drivers/gpu/hsa/radeon/cik_regs.h
index d0cdc57..ef1d7ab 100644
--- a/drivers/gpu/hsa/radeon/cik_regs.h
+++ b/drivers/gpu/hsa/radeon/cik_regs.h
@@ -23,6 +23,8 @@
 #ifndef CIK_REGS_H
 #define CIK_REGS_H
 
+#define IH_VMID_0_LUT					0x3D40u
+
 #define BIF_DOORBELL_CNTL				0x530Cu
 
 #define	SRBM_GFX_CNTL					0xE44
diff --git a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
index b986ff9..f86f958 100644
--- a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
+++ b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
@@ -25,9 +25,12 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
+#include <linux/device.h>
+#include <linux/sched.h>
 #include "kfd_priv.h"
 #include "kfd_scheduler.h"
 #include "cik_regs.h"
+#include "cik_int.h"
 
 /* CIK CP hardware is arranged with 8 queues per pipe and 8 pipes per MEC (microengine for compute).
  * The first MEC is ME 1 with the GFX ME as ME 0.
@@ -273,6 +276,8 @@ static void set_vmid_pasid_mapping(struct cik_static_private *priv, unsigned int
 	while (!(READ_REG(priv->dev, ATC_VMID_PASID_MAPPING_UPDATE_STATUS) & (1U << vmid)))
 		cpu_relax();
 	WRITE_REG(priv->dev, ATC_VMID_PASID_MAPPING_UPDATE_STATUS, 1U << vmid);
+
+	WRITE_REG(priv->dev, IH_VMID_0_LUT + vmid*sizeof(uint32_t), pasid);
 }
 
 static uint32_t compute_sh_mem_bases_64bit(unsigned int top_address_nybble)
@@ -786,6 +791,54 @@ cik_static_destroy_queue(struct kfd_scheduler *scheduler, struct kfd_scheduler_q
 	release_hqd(priv, hwq->queue);
 }
 
+/* Figure out the KFD compute pipe ID for an interrupt ring entry.
+ * Returns true if it's a KFD compute pipe, false otherwise. */
+static bool int_compute_pipe(const struct cik_static_private *priv,
+			     const struct cik_ih_ring_entry *ih_ring_entry,
+			     uint32_t *kfd_pipe)
+{
+	uint32_t pipe_id;
+
+	if (ih_ring_entry->meid == 0) /* Ignore graphics interrupts - compute only. */
+		return false;
+
+	pipe_id = (ih_ring_entry->meid - 1) * CIK_PIPES_PER_MEC + ih_ring_entry->pipeid;
+	if (pipe_id < priv->first_pipe)
+		return false;
+
+	pipe_id -= priv->first_pipe;
+
+	*kfd_pipe = pipe_id;
+
+	return true;
+}
+
+static bool
+cik_static_interrupt_isr(struct kfd_scheduler *scheduler, const void *ih_ring_entry)
+{
+	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
+	const struct cik_ih_ring_entry *ihre = ih_ring_entry;
+	uint32_t source_id = ihre->source_id;
+	uint32_t pipe_id;
+
+	/* We only care about CP interrupts here, they all come with a pipe. */
+	if (!int_compute_pipe(priv, ihre, &pipe_id))
+		return false;
+
+	dev_info(radeon_kfd_chardev(), "INT(ISR): src=%02x, data=0x%x, pipe=%u, vmid=%u, pasid=%u\n",
+		 ihre->source_id, ihre->data, pipe_id, ihre->vmid, ihre->pasid);
+
+	switch (source_id) {
+	default:
+		return false; /* Not interested. */
+	}
+}
+
+static void
+cik_static_interrupt_wq(struct kfd_scheduler *scheduler, const void *ih_ring_entry)
+{
+}
+
 const struct kfd_scheduler_class radeon_kfd_cik_static_scheduler_class = {
 	.name = "CIK static scheduler",
 	.create = cik_static_create,
@@ -797,4 +850,7 @@ const struct kfd_scheduler_class radeon_kfd_cik_static_scheduler_class = {
 	.queue_size = sizeof(struct cik_static_queue),
 	.create_queue = cik_static_create_queue,
 	.destroy_queue = cik_static_destroy_queue,
+
+	.interrupt_isr = cik_static_interrupt_isr,
+	.interrupt_wq = cik_static_interrupt_wq,
 };
-- 
1.9.1

