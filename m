Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3G3O5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:57:21 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:34772 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259Ab3G3O5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:57:19 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH v2] iommu: Add event tracing feature to iommu
Date: Tue, 30 Jul 2013 08:57:09 -0600
Message-Id: <1375196229-2784-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracing feature to iommu to report various iommu events. Classes
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

Testing:
The following is trace is generated when intel-iommu driver adds devices to
to iommu groups during boot-time during its initialization:

       swapper/0-1     [003] ....     1.854793: add_device_to_group: IOMMU: groupID=0 device=0000:00:00.0
       swapper/0-1     [003] ....     1.854797: add_device_to_group: IOMMU: groupID=1 device=0000:00:02.0

Added trace calls to iommu_prepare_identity_map() for testing some of the
conditions that are hard to trigger. Here is the trace from the testing:
       swapper/0-1     [003] ....     1.854099: amd_event: IOMMU:ILLEGAL_DEV_TABLE_ENTRY 0x01 00:00.0 d=0x0010 a=0x00000000cb800000 f=0x0002
       swapper/0-1     [003] ....     1.854101: remove_device_from_group: IOMMU: groupID=0 device=0000:00:02.0
       swapper/0-1     [003] ....     1.854102: attach_device_to_domain: IOMMU: device=0000:00:02.0
       swapper/0-1     [003] ....     1.854102: detach_device_from_domain: IOMMU: device=0000:00:02.0
       swapper/0-1     [003] ....     1.854102: map: IOMMU: iova=0x00000000cb800000 paddr=0x00000000cf9fffff size=0x400
       swapper/0-1     [003] ....     1.854102: unmap: IOMMU: iova=0x00000000cb800000 size=0x400

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
Changed since v1: no code changes, generated single patch. This is v2 without
the test code noise. Please review. I srated with the events I thought would
be useful, please give me feedback on events to add, if you like this approach.

 drivers/iommu/Makefile       |    1 +
 drivers/iommu/amd_iommu.c    |   19 +++++
 drivers/iommu/iommu-traces.c |   27 +++++++
 drivers/iommu/iommu.c        |   17 ++++-
 include/trace/events/iommu.h |  174 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 237 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/iommu-traces.c
 create mode 100644 include/trace/events/iommu.h

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index bbe7041..9015c45 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
+obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
 obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 6dc6594..10ac042 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -42,6 +42,7 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/dma.h>
+#include <trace/events/iommu.h>
 
 #include "amd_iommu_proto.h"
 #include "amd_iommu_types.h"
@@ -659,6 +660,8 @@ retry:
 		       "address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address, flags);
+		trace_amd_event("ILLEGAL_DEV_TABLE_ENTRY", type, domid,
+				      devid, address, flags);
 		dump_dte_entry(devid);
 		break;
 	case EVENT_TYPE_IO_FAULT:
@@ -666,41 +669,57 @@ retry:
 		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       domid, address, flags);
+		trace_amd_event("IO_PAGE_FAULT", type, domid,
+				      devid, address, flags);
 		break;
 	case EVENT_TYPE_DEV_TAB_ERR:
 		printk("DEV_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
 		       "address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address, flags);
+		trace_amd_event("DEV_TAB_HARDWARE_ERROR", type, domid,
+				      devid, address, flags);
 		break;
 	case EVENT_TYPE_PAGE_TAB_ERR:
 		printk("PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
 		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       domid, address, flags);
+		trace_amd_event("PAGE_TAB_HARDWARE_ERROR", type, domid,
+				      devid, address, flags);
 		break;
 	case EVENT_TYPE_ILL_CMD:
 		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
+		trace_amd_event("ILLEGAL_COMMAND_ERROR", type, domid,
+				      devid, address, flags);
 		dump_command(address);
 		break;
 	case EVENT_TYPE_CMD_HARD_ERR:
 		printk("COMMAND_HARDWARE_ERROR address=0x%016llx "
 		       "flags=0x%04x]\n", address, flags);
+		trace_amd_event("COMMAND_HARDWARE_ERROR", type, domid,
+				      devid, address, flags);
 		break;
 	case EVENT_TYPE_IOTLB_INV_TO:
 		printk("IOTLB_INV_TIMEOUT device=%02x:%02x.%x "
 		       "address=0x%016llx]\n",
 		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address);
+		trace_amd_event("IOTLB_INV_TIMEOUT", type, domid,
+				      devid, address, flags);
 		break;
 	case EVENT_TYPE_INV_DEV_REQ:
 		printk("INVALID_DEVICE_REQUEST device=%02x:%02x.%x "
 		       "address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address, flags);
+		trace_amd_event("INVALID_DEVICE_REQUEST", type, domid,
+				      devid, address, flags);
 		break;
 	default:
 		printk(KERN_ERR "UNKNOWN type=0x%02x]\n", type);
+		trace_amd_event("UNKNOWN", type, domid,
+				      devid, address, flags);
 	}
 
 	memset(__evt, 0, 4 * sizeof(u32));
diff --git a/drivers/iommu/iommu-traces.c b/drivers/iommu/iommu-traces.c
new file mode 100644
index 0000000..5b92e4c
--- /dev/null
+++ b/drivers/iommu/iommu-traces.c
@@ -0,0 +1,27 @@
+/*
+ * iommu trace points
+ *
+ * Copyright (C) 2013 Shuah Khan <shuah.kh@samsung.com>
+ *
+ */
+
+#include <linux/string.h>
+#include <linux/types.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/iommu.h>
+
+/* iommu_group_event */
+EXPORT_TRACEPOINT_SYMBOL_GPL(add_device_to_group);
+EXPORT_TRACEPOINT_SYMBOL_GPL(remove_device_from_group);
+
+/* iommu_device_event */
+EXPORT_TRACEPOINT_SYMBOL_GPL(attach_device_to_domain);
+EXPORT_TRACEPOINT_SYMBOL_GPL(detach_device_from_domain);
+
+/* iommu_map_unmap */
+EXPORT_TRACEPOINT_SYMBOL_GPL(map);
+EXPORT_TRACEPOINT_SYMBOL_GPL(unmap);
+
+/* iommu_amd_event */
+EXPORT_TRACEPOINT_SYMBOL_GPL(amd_event);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fbe9ca7..8e77110 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -29,6 +29,7 @@
 #include <linux/idr.h>
 #include <linux/notifier.h>
 #include <linux/err.h>
+#include <trace/events/iommu.h>
 
 static struct kset *iommu_group_kset;
 static struct ida iommu_group_ida;
@@ -363,6 +364,8 @@ rename:
 	/* Notify any listeners about change to group. */
 	blocking_notifier_call_chain(&group->notifier,
 				     IOMMU_GROUP_NOTIFY_ADD_DEVICE, dev);
+
+	trace_add_device_to_group(group->id, dev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iommu_group_add_device);
@@ -399,6 +402,8 @@ void iommu_group_remove_device(struct device *dev)
 	sysfs_remove_link(group->devices_kobj, device->name);
 	sysfs_remove_link(&dev->kobj, "iommu_group");
 
+	trace_remove_device_from_group(group->id, dev);
+
 	kfree(device->name);
 	kfree(device);
 	dev->iommu_group = NULL;
@@ -680,10 +685,16 @@ EXPORT_SYMBOL_GPL(iommu_domain_free);
 
 int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 {
+	int ret;
 	if (unlikely(domain->ops->attach_dev == NULL))
 		return -ENODEV;
 
-	return domain->ops->attach_dev(domain, dev);
+	ret = domain->ops->attach_dev(domain, dev);
+
+	if (!ret)
+		trace_attach_device_to_domain(dev);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_attach_device);
 
@@ -693,6 +704,7 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 		return;
 
 	domain->ops->detach_dev(domain, dev);
+	trace_detach_device_from_domain(dev);
 }
 EXPORT_SYMBOL_GPL(iommu_detach_device);
 
@@ -832,6 +844,8 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	/* unroll mapping in case something went wrong */
 	if (ret)
 		iommu_unmap(domain, orig_iova, orig_size - size);
+	else
+		trace_map(iova, paddr, size);
 
 	return ret;
 }
@@ -880,6 +894,7 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 		unmapped += unmapped_page;
 	}
 
+	trace_unmap(iova, 0, size);
 	return unmapped;
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
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

