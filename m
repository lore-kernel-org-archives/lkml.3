Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaLSBde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:33:34 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:31963 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaLSBdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:33:33 -0500
Message-ID: <54938052.3030809@huawei.com>
Date: Fri, 19 Dec 2014 09:33:06 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        <aneesh.kumar@linux.vnet.ibm.com>, <iamjoonsoo.kim@lge.com>,
        <vishnu.ps@samsung.com>
CC: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        "Xishi Qiu" <qiuxishi@huawei.com>
Subject: [PATCH V2] CMA: add the amount of cma memory in meminfo
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the amount of cma memory in the following meminfo.
/proc/meminfo
/sys/devices/system/node/nodeXX/meminfo

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 drivers/base/node.c | 16 ++++++++++------
 fs/proc/meminfo.c   |  6 ++++++
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 472168c..bc123f9 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -120,6 +120,9 @@ static ssize_t node_read_meminfo(struct device *dev,
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		       "Node %d AnonHugePages:  %8lu kB\n"
 #endif
+#ifdef CONFIG_CMA
+		       "Node %d FreeCMAPages:   %8lu kB\n"
+#endif
 			,
 		       nid, K(node_page_state(nid, NR_FILE_DIRTY)),
 		       nid, K(node_page_state(nid, NR_WRITEBACK)),
@@ -136,14 +139,15 @@ static ssize_t node_read_meminfo(struct device *dev,
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE) +
 				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
-			, nid,
-			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
-			HPAGE_PMD_NR));
-#else
-		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		       ,nid, K(node_page_state(nid,
+			NR_ANON_TRANSPARENT_HUGEPAGES) * HPAGE_PMD_NR)
+#endif
+#ifdef CONFIG_CMA
+		       ,nid, K(node_page_state(nid, NR_FREE_CMA_PAGES))
 #endif
+			);
 	n += hugetlb_report_node_meminfo(nid, buf + n);
 	return n;
 }
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index aa1eee0..9a7e446 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -138,6 +138,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		"AnonHugePages:  %8lu kB\n"
 #endif
+#ifdef CONFIG_CMA
+		"FreeCMAPages:   %8lu kB\n"
+#endif
 		,
 		K(i.totalram),
 		K(i.freeram),
@@ -193,6 +196,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
 		   HPAGE_PMD_NR)
 #endif
+#ifdef CONFIG_CMA
+		,K(global_page_state(NR_FREE_CMA_PAGES))
+#endif
 		);
 
 	hugetlb_report_meminfo(m);
-- 
2.0.0


