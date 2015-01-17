Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbbAQDxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 22:53:21 -0500
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:37595 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315AbbAQDxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 22:53:20 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, rostedt@goodmis.org,
        mingo@redhat.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iommu: change trace unmap api to report unmapped size
Date: Fri, 16 Jan 2015 20:53:17 -0700
Message-Id: <1421466797-8885-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently map and unmap are implemented as events under a
common trace class declaration. The common class forces
trace_unmap() to require a bogus physical address argument
that it doesn't use. Changing unmap to report unmapped size
will provide useful information for debugging. Remove common
map_unmap trace class and change map and unmap into separate
events as opposed to events under the same class to allow for
differences in the reporting information. In addition, map and
unmap are changed to handle size value as size_t instead of int
to match the passed size value and avoid overflow.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/iommu.c        |  2 +-
 include/trace/events/iommu.h | 31 ++++++++++++++++++-------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2eb7554..9e0dcdb 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1134,7 +1134,7 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 		unmapped += unmapped_page;
 	}
 
-	trace_unmap(orig_iova, 0, size);
+	trace_unmap(orig_iova, size, unmapped);
 	return unmapped;
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
diff --git a/include/trace/events/iommu.h b/include/trace/events/iommu.h
index a8f5c32..2c7befb 100644
--- a/include/trace/events/iommu.h
+++ b/include/trace/events/iommu.h
@@ -83,7 +83,7 @@ DEFINE_EVENT(iommu_device_event, detach_device_from_domain,
 	TP_ARGS(dev)
 );
 
-DECLARE_EVENT_CLASS(iommu_map_unmap,
+TRACE_EVENT(map,
 
 	TP_PROTO(unsigned long iova, phys_addr_t paddr, size_t size),
 
@@ -92,7 +92,7 @@ DECLARE_EVENT_CLASS(iommu_map_unmap,
 	TP_STRUCT__entry(
 		__field(u64, iova)
 		__field(u64, paddr)
-		__field(int, size)
+		__field(size_t, size)
 	),
 
 	TP_fast_assign(
@@ -101,26 +101,31 @@ DECLARE_EVENT_CLASS(iommu_map_unmap,
 		__entry->size = size;
 	),
 
-	TP_printk("IOMMU: iova=0x%016llx paddr=0x%016llx size=0x%x",
+	TP_printk("IOMMU: iova=0x%016llx paddr=0x%016llx size=%zu",
 			__entry->iova, __entry->paddr, __entry->size
 	)
 );
 
-DEFINE_EVENT(iommu_map_unmap, map,
+TRACE_EVENT(unmap,
 
-	TP_PROTO(unsigned long iova, phys_addr_t paddr, size_t size),
-
-	TP_ARGS(iova, paddr, size)
-);
+	TP_PROTO(unsigned long iova, size_t size, size_t unmapped_size),
 
-DEFINE_EVENT_PRINT(iommu_map_unmap, unmap,
+	TP_ARGS(iova, size, unmapped_size),
 
-	TP_PROTO(unsigned long iova, phys_addr_t paddr, size_t size),
+	TP_STRUCT__entry(
+		__field(u64, iova)
+		__field(size_t, size)
+		__field(size_t, unmapped_size)
+	),
 
-	TP_ARGS(iova, paddr, size),
+	TP_fast_assign(
+		__entry->iova = iova;
+		__entry->size = size;
+		__entry->unmapped_size = unmapped_size;
+	),
 
-	TP_printk("IOMMU: iova=0x%016llx size=0x%x",
-			__entry->iova, __entry->size
+	TP_printk("IOMMU: iova=0x%016llx size=%zu unmapped_size=%zu",
+			__entry->iova, __entry->size, __entry->unmapped_size
 	)
 );
 
-- 
2.1.0

