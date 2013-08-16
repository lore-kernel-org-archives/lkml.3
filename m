Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3HPRUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:20:54 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:46126
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755162Ab3HPRUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:20:47 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        udknight@gmail.com, aik@ozlabs.ru, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 2/2] iommu: Change iommu driver to call report_fault trace event
Date: Fri, 16 Aug 2013 11:20:17 -0600
Message-Id: <035c998d4a5508ba999a9c87ea70c73dc130e804.1376672275.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1376672275.git.shuah.kh@samsung.com>
References: <cover.1376672275.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1376672275.git.shuah.kh@samsung.com>
References: <cover.1376672275.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change iommu driver report_iommu_fault() to call report_fault trace event.
This iommu_fault class event can be enabled to trigger when an iommu fault
occurs. Trace information includes driver name, device name, iova, and flags.

Testing:
Added trace calls to iommu_prepare_identity_map() for testing some of the
conditions that are hard to trigger. Here is the trace from the testing:

       swapper/0-1     [003] ....     1.926331: report_fault: IOMMU:pci 0000:00:1d.0 iova=0x00000000cadc6000 flags=0x0001

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 include/linux/iommu.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 3aeb730..9d1c051 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -22,6 +22,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/types.h>
+#include <trace/events/iommu.h>
 
 #define IOMMU_READ	(1)
 #define IOMMU_WRITE	(2)
@@ -211,6 +212,7 @@ static inline int report_iommu_fault(struct iommu_domain *domain,
 		ret = domain->handler(domain, dev, iova, flags,
 						domain->handler_token);
 
+	trace_report_fault(dev, iova, flags);
 	return ret;
 }
 
-- 
1.7.10.4

