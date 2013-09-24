Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3IXV3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:29:36 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:51252
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865Ab3IXV3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:29:33 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Sep 2013 17:29:33 EDT
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        udknight@gmail.com, aik@ozlabs.ru, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH v4 2/2] iommu: Change iommu driver to call io_page_fault trace event
Date: Tue, 24 Sep 2013 15:21:20 -0600
Message-Id: <5d124e3b1aee697d24c4b427cb21784c7c3a90e5.1380056222.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1380056222.git.shuah.kh@samsung.com>
References: <cover.1380056222.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1380056222.git.shuah.kh@samsung.com>
References: <cover.1380056222.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change iommu driver call io_page_fault trace event. This iommu_error class
event can be enabled to trigger when an iommu error occurs. Trace information
includes driver name, device name, iova, and flags.

Testing:
Added trace calls to iommu_prepare_identity_map() for testing some of the
conditions that are hard to trigger. Here is the trace from the testing:

       swapper/0-1     [003] ....     2.003774: io_page_fault: IOMMU:pci 0000:00:02.0 iova=0x00000000cb800000 flags=0x0002
       swapper/0-1     [003] ....     2.004098: io_page_fault: IOMMU:pci 0000:00:1d.0 iova=0x00000000cadc6000 flags=0x0002
       swapper/0-1     [003] ....     2.004115: io_page_fault: IOMMU:pci 0000:00:1a.0 iova=0x00000000cadc6000 flags=0x0002
       swapper/0-1     [003] ....     2.004129: io_page_fault: IOMMU:pci 0000:00:1f.0 iova=0x0000000000000000 flags=0x0002

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 include/linux/iommu.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 7ea319e..a444c79 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -22,6 +22,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/types.h>
+#include <trace/events/iommu.h>
 
 #define IOMMU_READ	(1)
 #define IOMMU_WRITE	(2)
@@ -227,6 +228,7 @@ static inline int report_iommu_fault(struct iommu_domain *domain,
 		ret = domain->handler(domain, dev, iova, flags,
 						domain->handler_token);
 
+	trace_io_page_fault(dev, iova, flags);
 	return ret;
 }
 
-- 
1.8.1.2

