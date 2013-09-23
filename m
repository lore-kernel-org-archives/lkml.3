Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3IWMGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:06:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:23103 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab3IWMGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:06:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,962,1371106800"; 
   d="scan'208";a="405796213"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv6 06/22] thp: represent file thp pages in meminfo and friends
Date: Mon, 23 Sep 2013 15:05:34 +0300
Message-Id: <1379937950-8411-7-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds new zone stat to count file transparent huge pages and
adjust related places.

For now we don't count mapped or dirty file thp pages separately.

The patch depends on patch
 thp: account anon transparent huge pages into NR_ANON_PAGES

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
---
 drivers/base/node.c    | 4 ++++
 fs/proc/meminfo.c      | 3 +++
 include/linux/mmzone.h | 1 +
 mm/vmstat.c            | 1 +
 4 files changed, 9 insertions(+)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index bc9f43bf7e..de261f5722 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -119,6 +119,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 		       "Node %d SUnreclaim:     %8lu kB\n"
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		       "Node %d AnonHugePages:  %8lu kB\n"
+		       "Node %d FileHugePages:  %8lu kB\n"
 #endif
 			,
 		       nid, K(node_page_state(nid, NR_FILE_DIRTY)),
@@ -140,6 +141,9 @@ static ssize_t node_read_meminfo(struct device *dev,
 		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
 			, nid,
 			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
+			HPAGE_PMD_NR)
+			, nid,
+			K(node_page_state(nid, NR_FILE_TRANSPARENT_HUGEPAGES) *
 			HPAGE_PMD_NR));
 #else
 		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 59d85d6088..a62952cd4f 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -104,6 +104,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		"AnonHugePages:  %8lu kB\n"
+		"FileHugePages:  %8lu kB\n"
 #endif
 		,
 		K(i.totalram),
@@ -158,6 +159,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
 		   HPAGE_PMD_NR)
+		,K(global_page_state(NR_FILE_TRANSPARENT_HUGEPAGES) *
+		   HPAGE_PMD_NR)
 #endif
 		);
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index bd791e452a..8b4525bd4f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -143,6 +143,7 @@ enum zone_stat_item {
 	NUMA_OTHER,		/* allocation from other node */
 #endif
 	NR_ANON_TRANSPARENT_HUGEPAGES,
+	NR_FILE_TRANSPARENT_HUGEPAGES,
 	NR_FREE_CMA_PAGES,
 	NR_VM_ZONE_STAT_ITEMS };
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 9bb3145779..9af0d8536b 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -771,6 +771,7 @@ const char * const vmstat_text[] = {
 	"numa_other",
 #endif
 	"nr_anon_transparent_hugepages",
+	"nr_file_transparent_hugepages",
 	"nr_free_cma",
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
-- 
1.8.4.rc3

