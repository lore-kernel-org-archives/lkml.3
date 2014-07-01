Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbaGAK57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:57:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60216 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300AbaGAK55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:57:57 -0400
Subject: [PATCH v2 3/9] seqno-fence: Hardware dma-buf implementation of
 fencing (v6)
To: gregkh@linuxfoundation.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, thellstrom@vmware.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Tue, 01 Jul 2014 12:57:20 +0200
Message-ID: <20140701105720.12718.2421.stgit@patser>
In-Reply-To: <20140701103432.12718.82795.stgit@patser>
References: <20140701103432.12718.82795.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This type of fence can be used with hardware synchronization for simple
hardware that can block execution until the condition
(dma_buf[offset] - value) >= 0 has been met when WAIT_GEQUAL is used,
or (dma_buf[offset] != 0) has been met when WAIT_NONZERO is set.

A software fallback still has to be provided in case the fence is used
with a device that doesn't support this mechanism. It is useful to expose
this for graphics cards that have an op to support this.

Some cards like i915 can export those, but don't have an option to wait,
so they need the software fallback.

I extended the original patch by Rob Clark.

v1: Original
v2: Renamed from bikeshed to seqno, moved into dma-fence.c since
    not much was left of the file. Lots of documentation added.
v3: Use fence_ops instead of custom callbacks. Moved to own file
    to avoid circular dependency between dma-buf.h and fence.h
v4: Add spinlock pointer to seqno_fence_init
v5: Add condition member to allow wait for != 0.
    Fix small style errors pointed out by checkpatch.
v6: Move to a separate file. Fix up api changes in fences.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Reviewed-by: Rob Clark <robdclark@gmail.com> #v4
---
 Documentation/DocBook/device-drivers.tmpl |    2 +
 MAINTAINERS                               |    2 -
 drivers/dma-buf/Makefile                  |    2 -
 drivers/dma-buf/seqno-fence.c             |   73 ++++++++++++++++++
 include/linux/seqno-fence.h               |  116 +++++++++++++++++++++++++++++
 5 files changed, 193 insertions(+), 2 deletions(-)
 create mode 100644 drivers/dma-buf/seqno-fence.c
 create mode 100644 include/linux/seqno-fence.h

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index e634657efb52..ed0ef00cd7bc 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -130,7 +130,9 @@ X!Edrivers/base/interface.c
      <sect1><title>Device Drivers DMA Management</title>
 !Edrivers/dma-buf/dma-buf.c
 !Edrivers/dma-buf/fence.c
+!Edrivers/dma-buf/seqno-fence.c
 !Iinclude/linux/fence.h
+!Iinclude/linux/seqno-fence.h
 !Iinclude/linux/reservation.h
 !Edrivers/base/dma-coherent.c
 !Edrivers/base/dma-mapping.c
diff --git a/MAINTAINERS b/MAINTAINERS
index ebc1ebf6f542..135929f6cf6a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2883,7 +2883,7 @@ L:	linux-media@vger.kernel.org
 L:	dri-devel@lists.freedesktop.org
 L:	linaro-mm-sig@lists.linaro.org
 F:	drivers/dma-buf/
-F:	include/linux/dma-buf* include/linux/reservation.h include/linux/fence.h
+F:	include/linux/dma-buf* include/linux/reservation.h include/linux/*fence.h
 F:	Documentation/dma-buf-sharing.txt
 T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 
diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
index d7825bfe630e..57a675f90cd0 100644
--- a/drivers/dma-buf/Makefile
+++ b/drivers/dma-buf/Makefile
@@ -1 +1 @@
-obj-y := dma-buf.o fence.o reservation.o
+obj-y := dma-buf.o fence.o reservation.o seqno-fence.o
diff --git a/drivers/dma-buf/seqno-fence.c b/drivers/dma-buf/seqno-fence.c
new file mode 100644
index 000000000000..7d12a39a4b57
--- /dev/null
+++ b/drivers/dma-buf/seqno-fence.c
@@ -0,0 +1,73 @@
+/*
+ * seqno-fence, using a dma-buf to synchronize fencing
+ *
+ * Copyright (C) 2012 Texas Instruments
+ * Copyright (C) 2012-2014 Canonical Ltd
+ * Authors:
+ *   Rob Clark <robdclark@gmail.com>
+ *   Maarten Lankhorst <maarten.lankhorst@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/slab.h>
+#include <linux/export.h>
+#include <linux/seqno-fence.h>
+
+static const char *seqno_fence_get_driver_name(struct fence *fence)
+{
+	struct seqno_fence *seqno_fence = to_seqno_fence(fence);
+	return seqno_fence->ops->get_driver_name(fence);
+}
+
+static const char *seqno_fence_get_timeline_name(struct fence *fence)
+{
+	struct seqno_fence *seqno_fence = to_seqno_fence(fence);
+	return seqno_fence->ops->get_timeline_name(fence);
+}
+
+static bool seqno_enable_signaling(struct fence *fence)
+{
+	struct seqno_fence *seqno_fence = to_seqno_fence(fence);
+	return seqno_fence->ops->enable_signaling(fence);
+}
+
+static bool seqno_signaled(struct fence *fence)
+{
+	struct seqno_fence *seqno_fence = to_seqno_fence(fence);
+	return seqno_fence->ops->signaled && seqno_fence->ops->signaled(fence);
+}
+
+static void seqno_release(struct fence *fence)
+{
+	struct seqno_fence *f = to_seqno_fence(fence);
+
+	dma_buf_put(f->sync_buf);
+	if (f->ops->release)
+		f->ops->release(fence);
+	else
+		fence_free(&f->base);
+}
+
+static signed long seqno_wait(struct fence *fence, bool intr, signed long timeout)
+{
+	struct seqno_fence *f = to_seqno_fence(fence);
+	return f->ops->wait(fence, intr, timeout);
+}
+
+const struct fence_ops seqno_fence_ops = {
+	.get_driver_name = seqno_fence_get_driver_name,
+	.get_timeline_name = seqno_fence_get_timeline_name,
+	.enable_signaling = seqno_enable_signaling,
+	.signaled = seqno_signaled,
+	.wait = seqno_wait,
+	.release = seqno_release,
+};
+EXPORT_SYMBOL(seqno_fence_ops);
diff --git a/include/linux/seqno-fence.h b/include/linux/seqno-fence.h
new file mode 100644
index 000000000000..3d6003de4b0d
--- /dev/null
+++ b/include/linux/seqno-fence.h
@@ -0,0 +1,116 @@
+/*
+ * seqno-fence, using a dma-buf to synchronize fencing
+ *
+ * Copyright (C) 2012 Texas Instruments
+ * Copyright (C) 2012 Canonical Ltd
+ * Authors:
+ *   Rob Clark <robdclark@gmail.com>
+ *   Maarten Lankhorst <maarten.lankhorst@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __LINUX_SEQNO_FENCE_H
+#define __LINUX_SEQNO_FENCE_H
+
+#include <linux/fence.h>
+#include <linux/dma-buf.h>
+
+enum seqno_fence_condition {
+	SEQNO_FENCE_WAIT_GEQUAL,
+	SEQNO_FENCE_WAIT_NONZERO
+};
+
+struct seqno_fence {
+	struct fence base;
+
+	const struct fence_ops *ops;
+	struct dma_buf *sync_buf;
+	uint32_t seqno_ofs;
+	enum seqno_fence_condition condition;
+};
+
+extern const struct fence_ops seqno_fence_ops;
+
+/**
+ * to_seqno_fence - cast a fence to a seqno_fence
+ * @fence: fence to cast to a seqno_fence
+ *
+ * Returns NULL if the fence is not a seqno_fence,
+ * or the seqno_fence otherwise.
+ */
+static inline struct seqno_fence *
+to_seqno_fence(struct fence *fence)
+{
+	if (fence->ops != &seqno_fence_ops)
+		return NULL;
+	return container_of(fence, struct seqno_fence, base);
+}
+
+/**
+ * seqno_fence_init - initialize a seqno fence
+ * @fence: seqno_fence to initialize
+ * @lock: pointer to spinlock to use for fence
+ * @sync_buf: buffer containing the memory location to signal on
+ * @context: the execution context this fence is a part of
+ * @seqno_ofs: the offset within @sync_buf
+ * @seqno: the sequence # to signal on
+ * @ops: the fence_ops for operations on this seqno fence
+ *
+ * This function initializes a struct seqno_fence with passed parameters,
+ * and takes a reference on sync_buf which is released on fence destruction.
+ *
+ * A seqno_fence is a dma_fence which can complete in software when
+ * enable_signaling is called, but it also completes when
+ * (s32)((sync_buf)[seqno_ofs] - seqno) >= 0 is true
+ *
+ * The seqno_fence will take a refcount on the sync_buf until it's
+ * destroyed, but actual lifetime of sync_buf may be longer if one of the
+ * callers take a reference to it.
+ *
+ * Certain hardware have instructions to insert this type of wait condition
+ * in the command stream, so no intervention from software would be needed.
+ * This type of fence can be destroyed before completed, however a reference
+ * on the sync_buf dma-buf can be taken. It is encouraged to re-use the same
+ * dma-buf for sync_buf, since mapping or unmapping the sync_buf to the
+ * device's vm can be expensive.
+ *
+ * It is recommended for creators of seqno_fence to call fence_signal
+ * before destruction. This will prevent possible issues from wraparound at
+ * time of issue vs time of check, since users can check fence_is_signaled
+ * before submitting instructions for the hardware to wait on the fence.
+ * However, when ops.enable_signaling is not called, it doesn't have to be
+ * done as soon as possible, just before there's any real danger of seqno
+ * wraparound.
+ */
+static inline void
+seqno_fence_init(struct seqno_fence *fence, spinlock_t *lock,
+		 struct dma_buf *sync_buf,  uint32_t context,
+		 uint32_t seqno_ofs, uint32_t seqno,
+		 enum seqno_fence_condition cond,
+		 const struct fence_ops *ops)
+{
+	BUG_ON(!fence || !sync_buf || !ops);
+	BUG_ON(!ops->wait || !ops->enable_signaling ||
+	       !ops->get_driver_name || !ops->get_timeline_name);
+
+	/*
+	 * ops is used in fence_init for get_driver_name, so needs to be
+	 * initialized first
+	 */
+	fence->ops = ops;
+	fence_init(&fence->base, &seqno_fence_ops, lock, context, seqno);
+	get_dma_buf(sync_buf);
+	fence->sync_buf = sync_buf;
+	fence->seqno_ofs = seqno_ofs;
+	fence->condition = cond;
+}
+
+#endif /* __LINUX_SEQNO_FENCE_H */

