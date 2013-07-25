Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3GYNPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:15:41 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:44171 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755925Ab3GYNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:15:30 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 4/4] iommu: Add event tracing feature to iommu - iommu driver trace events
Date: Thu, 25 Jul 2013 07:15:05 -0600
Message-Id: <735116faffe67fea4de5496c5cd9ba16e5ca9d00.1374711464.git.shuah.kh@samsung.com>
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
unmap iommu ops complete. Trace information includes iova, physical address
(map event only), and size.

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
 drivers/iommu/iommu.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

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
-- 
1.7.10.4

