Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaBRWqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:46:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaBRWqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xishi Qiu <qiuxishi@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Keping Chen <chenkeping@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.4 09/24] mm: setup pageblock_order before its used by sparsemem
Date: Tue, 18 Feb 2014 14:46:56 -0800
Message-Id: <20140218224550.493070090@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224550.221535225@linuxfoundation.org>
References: <20140218224550.221535225@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xishi Qiu <qiuxishi@huawei.com>

commit ca57df79d4f64e1a4886606af4289d40636189c5 upstream.

On architectures with CONFIG_HUGETLB_PAGE_SIZE_VARIABLE set, such as
Itanium, pageblock_order is a variable with default value of 0.  It's set
to the right value by set_pageblock_order() in function
free_area_init_core().

But pageblock_order may be used by sparse_init() before free_area_init_core()
is called along path:
sparse_init()
    ->sparse_early_usemaps_alloc_node()
	->usemap_size()
	    ->SECTION_BLOCKFLAGS_BITS
		->((1UL << (PFN_SECTION_SHIFT - pageblock_order)) *
NR_PAGEBLOCK_BITS)

The uninitialized pageblock_size will cause memory wasting because
usemap_size() returns a much bigger value then it's really needed.

For example, on an Itanium platform,
sparse_init() pageblock_order=0 usemap_size=24576
free_area_init_core() before pageblock_order=0, usemap_size=24576
free_area_init_core() after pageblock_order=12, usemap_size=8

That means 24K memory has been wasted for each section, so fix it by calling
set_pageblock_order() from sparse_init().

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Keping Chen <chenkeping@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/internal.h   |    2 ++
 mm/page_alloc.c |    4 ++--
 mm/sparse.c     |    3 +++
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/mm/internal.h
+++ b/mm/internal.h
@@ -309,3 +309,5 @@ extern u64 hwpoison_filter_flags_mask;
 extern u64 hwpoison_filter_flags_value;
 extern u64 hwpoison_filter_memcg;
 extern u32 hwpoison_filter_enable;
+
+extern void set_pageblock_order(void);
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4255,7 +4255,7 @@ static inline void setup_usemap(struct p
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-static inline void __init set_pageblock_order(void)
+void __init set_pageblock_order(void)
 {
 	unsigned int order;
 
@@ -4283,7 +4283,7 @@ static inline void __init set_pageblock_
  * include/linux/pageblock-flags.h for the values of pageblock_order based on
  * the kernel config
  */
-static inline void set_pageblock_order(void)
+void __init set_pageblock_order(void)
 {
 }
 
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -486,6 +486,9 @@ void __init sparse_init(void)
 	struct page **map_map;
 #endif
 
+	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
+	set_pageblock_order();
+
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)
 	 * usemap is less one page (aka 24 bytes)


