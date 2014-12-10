Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbaLJTtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:49:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:33536 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932827AbaLJTtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770535"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 02/13] misc: mic: SCIF ring buffer infrastructure
Date: Wed, 10 Dec 2014 11:47:42 -0800
Message-Id: <6a99cdd6459ca70802f0000c1904bfdb8f45b73b.1418237176.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCIF ring buffer is a single producer, single consumer byte stream ring
buffer optimized for avoiding reads across the PCIe bus. The ring buffer is
used to implement a receive queue for SCIF driver messaging between nodes and
for byte stream messaging between SCIF endpoints. Each SCIF node has a
receive queue for every other SCIF node, and each connected endpoint has a
receive queue for messages from its peer. This pair of receive queues is
referred to as a SCIF queue pair.

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/scif/scif_rb.h | 100 ++++++++++++++++
 drivers/misc/mic/scif/scif_rb.c | 248 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 348 insertions(+)
 create mode 100644 drivers/misc/mic/scif/scif_rb.h
 create mode 100644 drivers/misc/mic/scif/scif_rb.c

diff --git a/drivers/misc/mic/scif/scif_rb.h b/drivers/misc/mic/scif/scif_rb.h
new file mode 100644
index 0000000..ba4bfce
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_rb.h
@@ -0,0 +1,100 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * * Redistributions of source code must retain the above copyright
+ *   notice, this list of conditions and the following disclaimer.
+ * * Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the
+ *   distribution.
+ * * Neither the name of Intel Corporation nor the names of its
+ *   contributors may be used to endorse or promote products derived
+ *   from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * Intel SCIF driver.
+ */
+#ifndef SCIF_RB_H
+#define SCIF_RB_H
+/*
+ * This file describes a general purpose, byte based ring buffer. Writers to the
+ * ring buffer need to synchronize using a lock. The same is true for readers,
+ * although in practice, the ring buffer has a single reader. It is lockless
+ * between producer and consumer so it can handle being used across the PCIe
+ * bus. The ring buffer ensures that there are no reads across the PCIe bus for
+ * performance reasons. Two of these are used to form a single bidirectional
+ * queue-pair across PCIe.
+ */
+/*
+ * struct scif_rb - SCIF Ring Buffer
+ *
+ * @rb_base: The base of the memory used for storing RB messages
+ * @read_ptr: Pointer to the read offset
+ * @write_ptr: Pointer to the write offset
+ * @size: Size of the memory in rb_base
+ * @current_read_offset: Cached read offset for performance
+ * @current_write_offset: Cached write offset for performance
+ */
+struct scif_rb {
+	void *rb_base;
+	uint32_t *read_ptr;
+	uint32_t *write_ptr;
+	uint32_t size;
+	uint32_t current_read_offset;
+	uint32_t current_write_offset;
+};
+
+/* methods used by both */
+void scif_rb_init(struct scif_rb *rb, uint32_t *read_ptr, uint32_t *write_ptr,
+		  void *rb_base, uint8_t size);
+/* writer only methods */
+/* write a new command, then scif_rb_commit() */
+int scif_rb_write(struct scif_rb *rb, void *msg, uint32_t size);
+/* after write(), then scif_rb_commit() */
+void scif_rb_commit(struct scif_rb *rb);
+/* query space available for writing to a RB. */
+uint32_t scif_rb_space(struct scif_rb *rb);
+
+/* reader only methods */
+/* read a new message from the ring buffer of size bytes */
+uint32_t scif_rb_get_next(struct scif_rb *rb, void *msg, uint32_t size);
+/* update the read pointer so that the space can be reused */
+void scif_rb_update_read_ptr(struct scif_rb *rb);
+/* count the number of bytes that can be read */
+uint32_t scif_rb_count(struct scif_rb *rb, uint32_t size);
+#endif
diff --git a/drivers/misc/mic/scif/scif_rb.c b/drivers/misc/mic/scif/scif_rb.c
new file mode 100644
index 0000000..b72da07
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_rb.c
@@ -0,0 +1,248 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * Intel SCIF driver.
+ *
+ */
+#include <linux/circ_buf.h>
+#include <linux/types.h>
+#include <linux/io.h>
+
+#include "scif_rb.h"
+
+#define scif_rb_ring_cnt(head, tail, size) CIRC_CNT(head, tail, size)
+#define scif_rb_ring_space(head, tail, size) CIRC_SPACE(head, tail, size)
+
+/**
+ * scif_rb_init - Initializes the ring buffer
+ * @rb: ring buffer
+ * @read_ptr: A pointer to the read offset
+ * @write_ptr: A pointer to the write offset
+ * @rb_base: A pointer to the base of the ring buffer
+ * @size: The size of the ring buffer in powers of two
+ */
+void scif_rb_init(struct scif_rb *rb, u32 *read_ptr, u32 *write_ptr,
+		  void *rb_base, u8 size)
+{
+	rb->rb_base = rb_base;
+	rb->size = (1 << size);
+	rb->read_ptr = read_ptr;
+	rb->write_ptr = write_ptr;
+	rb->current_read_offset = *read_ptr;
+	rb->current_write_offset = *write_ptr;
+}
+
+/* Copies a message to the ring buffer -- handles the wrap around case */
+static void memcpy_torb(struct scif_rb *rb, void *header,
+			void *msg, u32 size)
+{
+	u32 size1, size2;
+
+	if (header + size >= rb->rb_base + rb->size) {
+		/* Need to call two copies if it wraps around */
+		size1 = (u32)(rb->rb_base + rb->size - header);
+		size2 = size - size1;
+		memcpy_toio((void __iomem __force *)header, msg, size1);
+		memcpy_toio((void __iomem __force *)rb->rb_base,
+			    msg + size1, size2);
+	} else {
+		memcpy_toio((void __iomem __force *)header, msg, size);
+	}
+}
+
+/* Copies a message from the ring buffer -- handles the wrap around case */
+static void memcpy_fromrb(struct scif_rb *rb, void *header,
+			  void *msg, u32 size)
+{
+	u32 size1, size2;
+
+	if (header + size >= rb->rb_base + rb->size) {
+		/* Need to call two copies if it wraps around */
+		size1 = (u32)(rb->rb_base + rb->size - header);
+		size2 = size - size1;
+		memcpy_fromio(msg, (void __iomem __force *)header, size1);
+		memcpy_fromio(msg+size1,
+			      (void __iomem __force *)rb->rb_base, size2);
+	} else {
+		memcpy_fromio(msg, (void __iomem __force *)header, size);
+	}
+}
+
+/**
+ * scif_rb_space - Query space available for writing to the RB
+ * @rb: ring buffer
+ *
+ * Return: size available for writing to RB in bytes.
+ */
+u32 scif_rb_space(struct scif_rb *rb)
+{
+	rb->current_read_offset = *rb->read_ptr;
+	/*
+	 * Update from the HW read pointer only once the peer has exposed the
+	 * new empty slot. This barrier is paired with the memory barrier
+	 * scif_rb_update_read_ptr()
+	 */
+	mb();
+	return scif_rb_ring_space(rb->current_write_offset,
+				  rb->current_read_offset, rb->size);
+}
+
+/**
+ * scif_rb_write - Write a message to the RB
+ * @rb: ring buffer
+ * @msg: buffer to send the message.  Must be at least size bytes long
+ * @size: the size (in bytes) to be copied to the RB
+ *
+ * This API does not block if there isn't enough space in the RB.
+ * Returns: 0 on success or -ENOMEM on failure
+ */
+int scif_rb_write(struct scif_rb *rb, void *msg, u32 size)
+{
+	void *header;
+
+	if (scif_rb_space(rb) < size)
+		return -ENOMEM;
+	header = rb->rb_base + rb->current_write_offset;
+	memcpy_torb(rb, header, msg, size);
+	/*
+	 * Wait until scif_rb_commit(). Update the local ring
+	 * buffer data, not the shared data until commit.
+	 */
+	rb->current_write_offset =
+		(rb->current_write_offset + size) & (rb->size - 1);
+	return 0;
+}
+
+/**
+ * scif_rb_commit - To submit the message to let the peer fetch it
+ * @rb: ring buffer
+ */
+void scif_rb_commit(struct scif_rb *rb)
+{
+	/*
+	 * We must ensure ordering between the all the data committed
+	 * previously before we expose the new message to the peer by
+	 * updating the write_ptr. This write barrier is paired with
+	 * the read barrier in scif_rb_count(..)
+	 */
+	wmb();
+	ACCESS_ONCE(*rb->write_ptr) = rb->current_write_offset;
+#ifdef CONFIG_INTEL_MIC_CARD
+	/*
+	 * X100 Si bug: For the case where a Core is performing an EXT_WR
+	 * followed by a Doorbell Write, the Core must perform two EXT_WR to the
+	 * same address with the same data before it does the Doorbell Write.
+	 * This way, if ordering is violated for the Interrupt Message, it will
+	 * fall just behind the first Posted associated with the first EXT_WR.
+	 */
+	ACCESS_ONCE(*rb->write_ptr) = rb->current_write_offset;
+#endif
+}
+
+/**
+ * scif_rb_get - To get next message from the ring buffer
+ * @rb: ring buffer
+ * @size: Number of bytes to be read
+ *
+ * Return: NULL if no bytes to be read from the ring buffer, otherwise the
+ *	pointer to the next byte
+ */
+static void *scif_rb_get(struct scif_rb *rb, u32 size)
+{
+	void *header = NULL;
+
+	if (scif_rb_count(rb, size) >= size)
+		header = rb->rb_base + rb->current_read_offset;
+	return header;
+}
+
+/*
+ * scif_rb_get_next - Read from ring buffer.
+ * @rb: ring buffer
+ * @msg: buffer to hold the message.  Must be at least size bytes long
+ * @size: Number of bytes to be read
+ *
+ * Return: number of bytes read if available bytes are >= size, otherwise
+ * returns zero.
+ */
+u32 scif_rb_get_next(struct scif_rb *rb, void *msg, u32 size)
+{
+	void *header = NULL;
+	int read_size = 0;
+
+	header = scif_rb_get(rb, size);
+	if (header) {
+		u32 next_cmd_offset =
+			(rb->current_read_offset + size) & (rb->size - 1);
+
+		read_size = size;
+		rb->current_read_offset = next_cmd_offset;
+		memcpy_fromrb(rb, header, msg, size);
+	}
+	return read_size;
+}
+
+/**
+ * scif_rb_update_read_ptr
+ * @rb: ring buffer
+ */
+void scif_rb_update_read_ptr(struct scif_rb *rb)
+{
+	u32 new_offset;
+
+	new_offset = rb->current_read_offset;
+	/*
+	 * We must ensure ordering between the all the data committed or read
+	 * previously before we expose the empty slot to the peer by updating
+	 * the read_ptr. This barrier is paired with the read barrier in
+	 * scif_rb_space(..)
+	 */
+	mb();
+	ACCESS_ONCE(*rb->read_ptr) = new_offset;
+#ifdef CONFIG_INTEL_MIC_CARD
+	/*
+	 * X100 Si Bug: For the case where a Core is performing an EXT_WR
+	 * followed by a Doorbell Write, the Core must perform two EXT_WR to the
+	 * same address with the same data before it does the Doorbell Write.
+	 * This way, if ordering is violated for the Interrupt Message, it will
+	 * fall just behind the first Posted associated with the first EXT_WR.
+	 */
+	ACCESS_ONCE(*rb->read_ptr) = new_offset;
+#endif
+}
+
+/**
+ * scif_rb_count
+ * @rb: ring buffer
+ * @size: Number of bytes expected to be read
+ *
+ * Return: number of bytes that can be read from the RB
+ */
+u32 scif_rb_count(struct scif_rb *rb, u32 size)
+{
+	if (scif_rb_ring_cnt(rb->current_write_offset,
+			     rb->current_read_offset,
+			     rb->size) < size) {
+		rb->current_write_offset = *rb->write_ptr;
+		/*
+		 * Update from the HW write pointer if empty only once the peer
+		 * has exposed the new message. This read barrier is paired
+		 * with the write barrier in scif_rb_commit(..)
+		 */
+		smp_rmb();
+	}
+	return scif_rb_ring_cnt(rb->current_write_offset,
+				rb->current_read_offset,
+				rb->size);
+}
-- 
1.8.2.1

