Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3IXV3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:29:31 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:54580 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865Ab3IXV3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:29:30 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        udknight@gmail.com, aik@ozlabs.ru, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH v4 1/2] iommu: Add iommu_error class event to iommu trace
Date: Tue, 24 Sep 2013 15:21:19 -0600
Message-Id: <ba541bc6b0e58ab9b0ca8ff3058e48deb0b620ae.1380056222.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1380056222.git.shuah.kh@samsung.com>
References: <cover.1380056222.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1380056222.git.shuah.kh@samsung.com>
References: <cover.1380056222.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_error class event can be enabled to trigger when an iommu
error occurs. This trace event is intended to be called to report the
error information. Trace information includes driver name, device name,
iova, and flags.

iommu_error:io_page_fault

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/iommu/iommu-traces.c |  3 +++
 include/trace/events/iommu.h | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/iommu/iommu-traces.c b/drivers/iommu/iommu-traces.c
index a2af60f..71ac5fa 100644
--- a/drivers/iommu/iommu-traces.c
+++ b/drivers/iommu/iommu-traces.c
@@ -22,3 +22,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(detach_device_from_domain);
 /* iommu_map_unmap */
 EXPORT_TRACEPOINT_SYMBOL_GPL(map);
 EXPORT_TRACEPOINT_SYMBOL_GPL(unmap);
+
+/* iommu_error */
+EXPORT_TRACEPOINT_SYMBOL_GPL(io_page_fault);
diff --git a/include/trace/events/iommu.h b/include/trace/events/iommu.h
index 86bcc5a..a8f5c32 100644
--- a/include/trace/events/iommu.h
+++ b/include/trace/events/iommu.h
@@ -123,6 +123,39 @@ DEFINE_EVENT_PRINT(iommu_map_unmap, unmap,
 			__entry->iova, __entry->size
 	)
 );
+
+DECLARE_EVENT_CLASS(iommu_error,
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
+DEFINE_EVENT(iommu_error, io_page_fault,
+
+	TP_PROTO(struct device *dev, unsigned long iova, int flags),
+
+	TP_ARGS(dev, iova, flags)
+);
 #endif /* _TRACE_IOMMU_H */
 
 /* This part must be outside protection */
-- 
1.8.1.2

