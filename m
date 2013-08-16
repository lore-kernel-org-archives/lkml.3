Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3HPRUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:20:47 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:41908 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755079Ab3HPRUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:20:42 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        udknight@gmail.com, aik@ozlabs.ru, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 1/2] iommu: Add iommu_fault class event to iommu trace
Date: Fri, 16 Aug 2013 11:20:16 -0600
Message-Id: <7a14c27d8341e53f2aed7b80e08a4480d89eac5e.1376672275.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1376672275.git.shuah.kh@samsung.com>
References: <cover.1376672275.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1376672275.git.shuah.kh@samsung.com>
References: <cover.1376672275.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add iommu_fault class event can be enabled to trigger when an iommu
fault occurs. This trace event is intended to be called to report the
fault information. Trace information includes driver name, device name,
iova, and flags.

iommu_fault:report_fault

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/iommu/iommu-traces.c |    3 +++
 include/trace/events/iommu.h |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/iommu/iommu-traces.c b/drivers/iommu/iommu-traces.c
index a2af60f..314aa93 100644
--- a/drivers/iommu/iommu-traces.c
+++ b/drivers/iommu/iommu-traces.c
@@ -22,3 +22,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(detach_device_from_domain);
 /* iommu_map_unmap */
 EXPORT_TRACEPOINT_SYMBOL_GPL(map);
 EXPORT_TRACEPOINT_SYMBOL_GPL(unmap);
+
+/* iommu_fault */
+EXPORT_TRACEPOINT_SYMBOL_GPL(report_fault);
diff --git a/include/trace/events/iommu.h b/include/trace/events/iommu.h
index 86bcc5a..74847fb 100644
--- a/include/trace/events/iommu.h
+++ b/include/trace/events/iommu.h
@@ -123,6 +123,39 @@ DEFINE_EVENT_PRINT(iommu_map_unmap, unmap,
 			__entry->iova, __entry->size
 	)
 );
+
+DECLARE_EVENT_CLASS(iommu_fault,
+
+	TP_PROTO(struct device *dev, unsigned long iova, int flags),
+
+	TP_ARGS(dev, iova, flags),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(dev))
+		__string(driver, dev_driver_string(dev))
+		__field(u64, iova)
+		__field(int, flags)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(dev));
+		__assign_str(driver, dev_driver_string(dev));
+		__entry->iova = iova;
+		__entry->flags = flags;
+	),
+
+	TP_printk("IOMMU:%s %s iova=0x%016llx flags=0x%04x",
+			__get_str(driver), __get_str(device),
+			__entry->iova, __entry->flags
+	)
+);
+
+DEFINE_EVENT(iommu_fault, report_fault,
+
+	TP_PROTO(struct device *dev, unsigned long iova, int flags),
+
+	TP_ARGS(dev, iova, flags)
+);
 #endif /* _TRACE_IOMMU_H */
 
 /* This part must be outside protection */
-- 
1.7.10.4

