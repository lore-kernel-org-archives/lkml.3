Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbaLIDYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 22:24:25 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:15634 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755069AbaLIDYY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 22:24:24 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Kirill A. Shutemov'" <kirill@shutemov.name>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>
Date: Tue, 9 Dec 2014 11:24:20 +0800
Subject: [RFC V5] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
Thread-Topic: [RFC V5] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
Thread-Index: AdAS3POBh48LiUfmSOiU07RH13dqIwAgkhXw
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313FB@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
 <CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
 <20141205143134.37139da2208c654a0d3cd942@linux-foundation.org>
 <35FD53F367049845BC99AC72306C23D103E688B313F4@CNBJMBX05.corpusers.net>
 <20141208114601.GA28846@node.dhcp.inet.fi>
In-Reply-To: <20141208114601.GA28846@node.dhcp.inet.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add KPF_ZERO_PAGE flag for zero_page,
so that userspace process can notice zero_page from
/proc/kpageflags, and then do memory analysis more accurately.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 Documentation/vm/pagemap.txt           |  8 ++++++++
 fs/proc/page.c                         | 16 +++++++++++++---
 include/linux/huge_mm.h                | 12 ++++++++++++
 include/uapi/linux/kernel-page-flags.h |  1 +
 mm/huge_memory.c                       |  7 +------
 tools/vm/page-types.c                  |  1 +
 6 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/Documentation/vm/pagemap.txt b/Documentation/vm/pagemap.txt
index 5948e45..6fbd55e 100644
--- a/Documentation/vm/pagemap.txt
+++ b/Documentation/vm/pagemap.txt
@@ -62,6 +62,8 @@ There are three components to pagemap:
     20. NOPAGE
     21. KSM
     22. THP
+    23. BALLOON
+    24. ZERO_PAGE
 
 Short descriptions to the page flags:
 
@@ -102,6 +104,12 @@ Short descriptions to the page flags:
 22. THP
     contiguous pages which construct transparent hugepages
 
+23. BALLOON
+    balloon compaction page
+
+24. ZERO_PAGE
+    zero page for pfn_zero or huge_zero page
+
     [IO related page flags]
  1. ERROR     IO error occurred
  3. UPTODATE  page has up-to-date data
diff --git a/fs/proc/page.c b/fs/proc/page.c
index 1e3187d..7eee2d8 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -5,6 +5,7 @@
 #include <linux/ksm.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
+#include <linux/huge_mm.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/hugetlb.h>
@@ -121,9 +122,18 @@ u64 stable_page_flags(struct page *page)
 	 * just checks PG_head/PG_tail, so we need to check PageLRU/PageAnon
 	 * to make sure a given page is a thp, not a non-huge compound page.
 	 */
-	else if (PageTransCompound(page) && (PageLRU(compound_head(page)) ||
-					     PageAnon(compound_head(page))))
-		u |= 1 << KPF_THP;
+	else if (PageTransCompound(page)) {
+		struct page *head = compound_head(page);
+
+		if (PageLRU(head) || PageAnon(head))
+			u |= 1 << KPF_THP;
+		else if (is_huge_zero_page(head)) {
+			u |= 1 << KPF_ZERO_PAGE;
+			u |= 1 << KPF_THP;
+		}
+	} else if (is_zero_pfn(page_to_pfn(page)))
+		u |= 1 << KPF_ZERO_PAGE;
+
 
 	/*
 	 * Caveats on high order pages: page->_count will only be set
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ad9051b..f10b20f 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -157,6 +157,13 @@ static inline int hpage_nr_pages(struct page *page)
 extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
 
+extern struct page *huge_zero_page;
+
+static inline bool is_huge_zero_page(struct page *page)
+{
+	return ACCESS_ONCE(huge_zero_page) == page;
+}
+
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
@@ -206,6 +213,11 @@ static inline int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_str
 	return 0;
 }
 
+static inline bool is_huge_zero_page(struct page *page)
+{
+	return false;
+}
+
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff --git a/include/uapi/linux/kernel-page-flags.h b/include/uapi/linux/kernel-page-flags.h
index 2f96d23..a6c4962 100644
--- a/include/uapi/linux/kernel-page-flags.h
+++ b/include/uapi/linux/kernel-page-flags.h
@@ -32,6 +32,7 @@
 #define KPF_KSM			21
 #define KPF_THP			22
 #define KPF_BALLOON		23
+#define KPF_ZERO_PAGE		24
 
 
 #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index de98415..d7bc7a5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -171,12 +171,7 @@ static int start_khugepaged(void)
 }
 
 static atomic_t huge_zero_refcount;
-static struct page *huge_zero_page __read_mostly;
-
-static inline bool is_huge_zero_page(struct page *page)
-{
-	return ACCESS_ONCE(huge_zero_page) == page;
-}
+struct page *huge_zero_page __read_mostly;
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index 264fbc2..8bdf16b 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -133,6 +133,7 @@ static const char * const page_flag_names[] = {
 	[KPF_KSM]		= "x:ksm",
 	[KPF_THP]		= "t:thp",
 	[KPF_BALLOON]		= "o:balloon",
+	[KPF_ZERO_PAGE]		= "z:zero_page",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
-- 
2.1.3
