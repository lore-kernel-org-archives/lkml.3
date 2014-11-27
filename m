Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaK0FHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 00:07:55 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51842 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaK0FHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 00:07:53 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 27 Nov 2014 14:10:59 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Dave Hansen <dave@sr71.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/8] mm/debug-pagealloc: make debug-pagealloc boottime
 configurable
Message-ID: <20141127051059.GA6755@js1304-P5Q-DELUXE>
References: <1416816926-7756-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1416816926-7756-4-git-send-email-iamjoonsoo.kim@lge.com>
 <20141124145542.08b97076.akpm@linux-foundation.org>
 <20141124234237.GA7824@js1304-P5Q-DELUXE>
 <20141126124936.56cc901e13f27927d7b42aaf@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126124936.56cc901e13f27927d7b42aaf@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 12:49:36PM -0800, Andrew Morton wrote:
> On Tue, 25 Nov 2014 08:42:37 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > On Mon, Nov 24, 2014 at 02:55:42PM -0800, Andrew Morton wrote:
> > > On Mon, 24 Nov 2014 17:15:21 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > > 
> > > > Now, we have prepared to avoid using debug-pagealloc in boottime. So
> > > > introduce new kernel-parameter to disable debug-pagealloc in boottime,
> > > > and makes related functions to be disabled in this case.
> > > > 
> > > > Only non-intuitive part is change of guard page functions. Because
> > > > guard page is effective only if debug-pagealloc is enabled, turning off
> > > > according to debug-pagealloc is reasonable thing to do.
> > > > 
> > > > ...
> > > >
> > > > --- a/Documentation/kernel-parameters.txt
> > > > +++ b/Documentation/kernel-parameters.txt
> > > > @@ -858,6 +858,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> > > >  			causing system reset or hang due to sending
> > > >  			INIT from AP to BSP.
> > > >  
> > > > +	disable_debug_pagealloc
> > > > +			[KNL] When CONFIG_DEBUG_PAGEALLOC is set, this
> > > > +			parameter allows user to disable it at boot time.
> > > > +			With this parameter, we can avoid allocating huge
> > > > +			chunk of memory for debug pagealloc and then
> > > > +			the system will work mostly same with the kernel
> > > > +			built without CONFIG_DEBUG_PAGEALLOC.
> > > > +
> > > 
> > > Weren't we going to make this default to "off", require a boot option
> > > to turn debug_pagealloc on?
> > 
> > Hello, Andrew.
> > 
> > I'm afraid that changing default to "off" confuses some old users.
> > They would expect that it is default "on". But, it is just debug
> > feature, so, it may be no problem. If you prefer to change default, I
> > will rework this patch. Please let me know your decision.
> 
> I suspect the number of "old users" is one ;)
> 
> I think it would be better to default to off - that's the typical
> behaviour for debug features, for good reasons.

Okay.
Here goes the patch.

------------->8----------------
>From 799eba44b2d071d55e4444399be63f1af0aff204 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Wed, 5 Nov 2014 16:05:14 +0900
Subject: [PATCH v4] mm/debug-pagealloc: make debug-pagealloc boottime
 configurable

Now, we have prepared to avoid using debug-pagealloc in boottime. So,
make it disabled in default and introduce new kernel-parameter
to enable debug-pagealloc in boottime. This is a debugging feature, so
default disabled may be more useful.

Only non-intuitive part is change of guard page functions. Because
guard page is effective only if debug-pagealloc is enabled, turning on/off
according to debug-pagealloc is reasonable thing to do.

v2: makes debug-pagealloc boottime configurable for page poisoning, too
v4: makes debug-pagealloc disabled in default

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 Documentation/kernel-parameters.txt |    9 +++++++++
 arch/powerpc/mm/hash_utils_64.c     |    2 +-
 arch/powerpc/mm/pgtable_32.c        |    2 +-
 arch/s390/mm/pageattr.c             |    2 +-
 arch/sparc/mm/init_64.c             |    2 +-
 arch/x86/mm/pageattr.c              |    2 +-
 include/linux/mm.h                  |   17 ++++++++++++++++-
 mm/debug-pagealloc.c                |    8 +++++++-
 mm/page_alloc.c                     |   20 ++++++++++++++++++++
 9 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 3c5a178..e35bfcc 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -829,6 +829,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			CONFIG_DEBUG_PAGEALLOC, hence this option will not help
 			tracking down these problems.
 
+	debug_pagealloc=
+			[KNL] When CONFIG_DEBUG_PAGEALLOC is set, this
+			parameter enables the feature at boot time. In
+			default, it is disabled. We can avoid allocating huge
+			chunk of memory for debug pagealloc if we don't enable
+			it at boot time and the system will work mostly same
+			with the kernel built without CONFIG_DEBUG_PAGEALLOC.
+			on: enable the feature
+
 	debugpat	[X86] Enable PAT debugging
 
 	decnet.addr=	[HW,NET]
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index d5339a3..57b9c23 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -1432,7 +1432,7 @@ static void kernel_unmap_linear_page(unsigned long vaddr, unsigned long lmi)
 			       mmu_kernel_ssize, 0);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long flags, vaddr, lmi;
 	int i;
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index cf11342..b98aac6 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -430,7 +430,7 @@ static int change_page_attr(struct page *page, int numpages, pgprot_t prot)
 }
 
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
 		return;
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index 3fef3b2..426c9d4 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -120,7 +120,7 @@ static void ipte_range(pte_t *pte, unsigned long address, int nr)
 	}
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long address;
 	int nr, i, j;
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 2d91c62..3ea267c 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1621,7 +1621,7 @@ static void __init kernel_physical_mapping_init(void)
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long phys_start = page_to_pfn(page) << PAGE_SHIFT;
 	unsigned long phys_end = phys_start + (numpages * PAGE_SIZE);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 36de293..4d304e1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1801,7 +1801,7 @@ static int __set_pages_np(struct page *page, int numpages)
 	return __change_page_attr_set_clr(&cpa, 0);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
 		return;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5a8d4d4..5dc11e7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2055,7 +2055,22 @@ static inline void vm_stat_account(struct mm_struct *mm,
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-extern void kernel_map_pages(struct page *page, int numpages, int enable);
+extern bool _debug_pagealloc_enabled;
+extern void __kernel_map_pages(struct page *page, int numpages, int enable);
+
+static inline bool debug_pagealloc_enabled(void)
+{
+	return _debug_pagealloc_enabled;
+}
+
+static inline void
+kernel_map_pages(struct page *page, int numpages, int enable)
+{
+	if (!debug_pagealloc_enabled())
+		return;
+
+	__kernel_map_pages(page, numpages, enable);
+}
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif /* CONFIG_HIBERNATION */
diff --git a/mm/debug-pagealloc.c b/mm/debug-pagealloc.c
index 0072f2c..5bf5906 100644
--- a/mm/debug-pagealloc.c
+++ b/mm/debug-pagealloc.c
@@ -10,11 +10,17 @@ static bool page_poisoning_enabled __read_mostly;
 
 static bool need_page_poisoning(void)
 {
+	if (!debug_pagealloc_enabled())
+		return false;
+
 	return true;
 }
 
 static void init_page_poisoning(void)
 {
+	if (!debug_pagealloc_enabled())
+		return;
+
 	page_poisoning_enabled = true;
 }
 
@@ -119,7 +125,7 @@ static void unpoison_pages(struct page *page, int n)
 		unpoison_page(page + i);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (!page_poisoning_enabled)
 		return;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7534733..10310ad 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -426,15 +426,35 @@ static inline void prep_zero_page(struct page *page, unsigned int order,
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 unsigned int _debug_guardpage_minorder;
+bool _debug_pagealloc_enabled __read_mostly;
 bool _debug_guardpage_enabled __read_mostly;
 
+static int __init early_debug_pagealloc(char *buf)
+{
+	if (!buf)
+		return -EINVAL;
+
+	if (strcmp(buf, "on") == 0)
+		_debug_pagealloc_enabled = true;
+
+	return 0;
+}
+early_param("debug_pagealloc", early_debug_pagealloc);
+
 static bool need_debug_guardpage(void)
 {
+	/* If we don't use debug_pagealloc, we don't need guard page */
+	if (!debug_pagealloc_enabled())
+		return false;
+
 	return true;
 }
 
 static void init_debug_guardpage(void)
 {
+	if (!debug_pagealloc_enabled())
+		return;
+
 	_debug_guardpage_enabled = true;
 }
 
-- 
1.7.9.5

