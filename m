Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3GYNPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:15:31 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:44171 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894Ab3GYNP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:15:27 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 1/4] iommu: Add event tracing feature to iommu - Add iommu trace events
Date: Thu, 25 Jul 2013 07:15:02 -0600
Message-Id: <7b0b388ea2e8f1d245450a8ec34755f608618224.1374711464.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1374711464.git.shuah.kh@samsung.com>
References: <cover.1374711464.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1374711464.git.shuah.kh@samsung.com>
References: <cover.1374711464.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracing feature to iommu driver to report various iommu events. Classes
iommu_group, iommu_device, iommu_map_unmap, and iommu_amd_event are defined.

iommu_group class events can be enabled to trigger when devices get added
to and removed from an iommu group. Trace information includes iommu group
id and device name.

iommu:add_device_to_group
iommu:remove_device_from_group

iommu_device class events can be enabled to trigger when devices are attached
to and detached from a domain. Trace information includes device name.

iommu:attach_device_to_domain
iommu:detach_device_from_domain

iommu_map_unmap class events can be enabled to trigger when iommu map and
unmap iommu ops. Trace information includes iova, physical address (map event
only), and size.

iommu:unmap
iommu:map

iommu_amd_event class can be enabled to trigger when AMD IOMMU driver finds
events when it polls the IOMMU Event Log. Trace information includes the
event string derived from the event type in human friendly form, event type,
id of the domain the device is placed in, device (bus number, slot number,
and function number), address associated with the event, and flags.

iommu:amd_event

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 include/trace/events/iommu.h |  174 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 174 insertions(+)
 create mode 100644 include/trace/events/iommu.h

diff --git a/include/trace/events/iommu.h b/include/trace/events/iommu.h
new file mode 100644
index 0000000..3d8d5e8
--- /dev/null
+++ b/include/trace/events/iommu.h
@@ -0,0 +1,174 @@
+/*
+ * iommu trace points
+ *
+ * Copyright (C) 2013 Shuah Khan <shuah.kh@samsung.com>
+ *
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM iommu
+
+#if !defined(_TRACE_IOMMU_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IOMMU_H
+
+#include <linux/tracepoint.h>
+#include <linux/pci.h>
+
+struct device;
+
+DECLARE_EVENT_CLASS(iommu_group_event,
+
+	TP_PROTO(int group_id, struct device *dev),
+
+	TP_ARGS(group_id, dev),
+
+	TP_STRUCT__entry(
+		__field(int, gid)
+		__string(device, dev_name(dev))
+	),
+
+	TP_fast_assign(
+		__entry->gid = group_id;
+		__assign_str(device, dev_name(dev));
+	),
+
+	TP_printk("IOMMU: groupID=%d device=%s",
+			__entry->gid, __get_str(device)
+	)
+);
+
+DEFINE_EVENT(iommu_group_event, add_device_to_group,
+
+	TP_PROTO(int group_id, struct device *dev),
+
+	TP_ARGS(group_id, dev)
+
+);
+
+DEFINE_EVENT(iommu_group_event, remove_device_from_group,
+
+	TP_PROTO(int group_id, struct device *dev),
+
+	TP_ARGS(group_id, dev)
+);
+
+DECLARE_EVENT_CLASS(iommu_device_event,
+
+	TP_PROTO(struct device *dev),
+
+	TP_ARGS(dev),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(dev))
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(dev));
+	),
+
+	TP_printk("IOMMU: device=%s", __get_str(device)
+	)
+);
+
+DEFINE_EVENT(iommu_device_event, attach_device_to_domain,
+
+	TP_PROTO(struct device *dev),
+
+	TP_ARGS(dev)
+);
+
+DEFINE_EVENT(iommu_device_event, detach_device_from_domain,
+
+	TP_PROTO(struct device *dev),
+
+	TP_ARGS(dev)
+);
+
+DECLARE_EVENT_CLASS(iommu_map_unmap,
+
+	TP_PROTO(unsigned long iova, phys_addr_t paddr, size_t size),
+
+	TP_ARGS(iova, paddr, size),
+
+	TP_STRUCT__entry(
+		__field(u64, iova)
+		__field(u64, paddr)
+		__field(int, size)
+	),
+
+	TP_fast_assign(
+		__entry->iova = iova;
+		__entry->paddr = paddr;
+		__entry->size = size;
+	),
+
+	TP_printk("IOMMU: iova=0x%016llx paddr=0x%016llx size=0x%x",
+			__entry->iova, __entry->paddr, __entry->size
+	)
+);
+
+DEFINE_EVENT(iommu_map_unmap, map,
+
+	TP_PROTO(unsigned long iova, phys_addr_t paddr, size_t size),
+
+	TP_ARGS(iova, paddr, size)
+);
+
+DEFINE_EVENT_PRINT(iommu_map_unmap, unmap,
+
+	TP_PROTO(unsigned long iova, phys_addr_t paddr, size_t size),
+
+	TP_ARGS(iova, paddr, size),
+
+	TP_printk("IOMMU: iova=0x%016llx size=0x%x",
+			__entry->iova, __entry->size
+	)
+);
+
+DECLARE_EVENT_CLASS(iommu_amd_event,
+
+	TP_PROTO(char *event_str, int type, int domain_id, int device_id,
+		 u64 address, int flags),
+
+	TP_ARGS(event_str, type, domain_id, device_id, address, flags),
+
+	TP_STRUCT__entry(
+		__string(event_str, event_str)
+		__field(int, type)
+		__field(int, domain_id)
+		__field(int, device_id)
+		__field(u64, address)
+		__field(int, flags)
+	),
+
+	TP_fast_assign(
+		__assign_str(event_str, event_str);
+		__entry->type = type;
+		__entry->domain_id = domain_id;
+		__entry->device_id = device_id;
+		__entry->address = address;
+		__entry->flags = flags;
+	),
+
+	TP_printk("IOMMU:%s 0x%02x %02x:%02x.%x d=0x%04x a=0x%016llx f=0x%04x",
+			__get_str(event_str),
+			__entry->type,
+			PCI_BUS_NUM(__entry->device_id),
+			PCI_SLOT(__entry->device_id),
+			PCI_FUNC(__entry->device_id),
+			__entry->domain_id,
+			__entry->address, __entry->flags
+	)
+);
+
+DEFINE_EVENT(iommu_amd_event, amd_event,
+
+	TP_PROTO(char *event_str, int type, int domain_id, int device_id,
+		 u64 address, int flags),
+
+	TP_ARGS(event_str, type, domain_id, device_id, address, flags)
+);
+
+#endif /* _TRACE_IOMMU_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.10.4

