Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3HVVro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:47:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:36662 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab3HVVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:47:43 -0400
X-IronPort-AV: E=Sophos;i="4.89,936,1367971200"; 
   d="scan'208";a="44537798"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>,
        <virtualization@lists.linux-foundation.org>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH] tracing/events: Add bounce tracing to swiotbl-xen
Date: Thu, 22 Aug 2013 22:47:28 +0100
Message-ID: <1377208048-8963-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ftrace is currently not able to detect when SWIOTLB has to do double buffering
under Xen. You can only see it indirectly in function_graph, when
xen_swiotlb_map_page() doesn't stop after range_straddles_page_boundary(), but
calls spinlock functions, memcpy() and xen_phys_to_bus() as well. This patch
introduces the swiotlb-xen:bounced event, which also prints out the following
informations to help you find out why bouncing happened:

dev_name: 0000:08:00.0 dma_mask=ffffffffffffffff dev_addr=9149f000 size=32768
swiotlb_force=0

If (dev_addr + size + 1) > dma_mask, the buffer is out of the device's DMA
range. If swiotlb_force == 1, you should really change the kernel parameters.
Otherwise, the buffer is not contiguous in mfn space.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 drivers/xen/swiotlb-xen.c          |    7 ++++++
 include/trace/events/swiotlb-xen.h |   46 ++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)
 create mode 100644 include/trace/events/swiotlb-xen.h

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index aadffcf..f08440d 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -42,6 +42,10 @@
 #include <xen/page.h>
 #include <xen/xen-ops.h>
 #include <xen/hvc-console.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/swiotlb-xen.h>
+
 /*
  * Used to do a quick range check in swiotlb_tbl_unmap_single and
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
@@ -358,6 +362,9 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
+
+	trace_bounced(dev, dev_addr, size, swiotlb_force);
+
 	map = swiotlb_tbl_map_single(dev, start_dma_addr, phys, size, dir);
 	if (map == SWIOTLB_MAP_ERROR)
 		return DMA_ERROR_CODE;
diff --git a/include/trace/events/swiotlb-xen.h b/include/trace/events/swiotlb-xen.h
new file mode 100644
index 0000000..cbe2dca
--- /dev/null
+++ b/include/trace/events/swiotlb-xen.h
@@ -0,0 +1,46 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM swiotlb-xen
+
+#if !defined(_TRACE_SWIOTLBXEN_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SWIOTLBXEN_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(bounced,
+
+	TP_PROTO(struct device *dev,
+		 dma_addr_t dev_addr,
+		 size_t size,
+		 int swiotlb_force),
+
+	TP_ARGS(dev, dev_addr, size, swiotlb_force),
+
+	TP_STRUCT__entry(
+		__string(	dev_name,	dev_name(dev)	)
+		__field(	u64,	dma_mask		)
+		__field(	dma_addr_t,	dev_addr	)
+		__field(	size_t,	size			)
+		__field(	int,	swiotlb_force		)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev_name, dev_name(dev));
+		__entry->dma_mask = (dev->dma_mask ? *dev->dma_mask : 0);
+		__entry->dev_addr = dev_addr;
+		__entry->size = size;
+		__entry->swiotlb_force = swiotlb_force;
+	),
+
+	TP_printk("dev_name: %s dma_mask=%llx dev_addr=%llx "
+		"size=%zu swiotlb_force=%x",
+		__get_str(dev_name),
+		__entry->dma_mask,
+		(unsigned long long)__entry->dev_addr,
+		__entry->size,
+		__entry->swiotlb_force )
+);
+
+#endif /*  _TRACE_IRQ_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.9.5

