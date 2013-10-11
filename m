Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3JKUvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:51:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab3JKTh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [ 44/48] mm, show_mem: suppress page counts in non-blockable contexts
Date: Fri, 11 Oct 2013 12:36:51 -0700
Message-Id: <20131011193642.017906507@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit 4b59e6c4730978679b414a8da61514a2518da512 upstream.

On large systems with a lot of memory, walking all RAM to determine page
types may take a half second or even more.

In non-blockable contexts, the page allocator will emit a page allocation
failure warning unless __GFP_NOWARN is specified.  In such contexts, irqs
are typically disabled and such a lengthy delay may even result in NMI
watchdog timeouts.

To fix this, suppress the page walk in such contexts when printing the
page allocation failure warning.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/init.c       |    3 +++
 arch/ia64/mm/contig.c    |    2 ++
 arch/ia64/mm/discontig.c |    2 ++
 arch/parisc/mm/init.c    |    2 ++
 arch/unicore32/mm/init.c |    3 +++
 include/linux/mm.h       |    3 ++-
 lib/show_mem.c           |    3 +++
 mm/page_alloc.c          |    7 +++++++
 8 files changed, 24 insertions(+), 1 deletion(-)

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -98,6 +98,9 @@ void show_mem(unsigned int filter)
 	printk("Mem-info:\n");
 	show_free_areas(filter);
 
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
+
 	for_each_bank (i, mi) {
 		struct membank *bank = &mi->bank[i];
 		unsigned int pfn1, pfn2;
--- a/arch/ia64/mm/contig.c
+++ b/arch/ia64/mm/contig.c
@@ -47,6 +47,8 @@ void show_mem(unsigned int filter)
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas(filter);
 	printk(KERN_INFO "Node memory in pages:\n");
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
 		unsigned long flags;
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -623,6 +623,8 @@ void show_mem(unsigned int filter)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas(filter);
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
 	printk(KERN_INFO "Node memory in pages:\n");
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -685,6 +685,8 @@ void show_mem(unsigned int filter)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas(filter);
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
 #ifndef CONFIG_DISCONTIGMEM
 	i = max_mapnr;
 	while (i-- > 0) {
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -66,6 +66,9 @@ void show_mem(unsigned int filter)
 	printk(KERN_DEFAULT "Mem-info:\n");
 	show_free_areas(filter);
 
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
+
 	for_each_bank(i, mi) {
 		struct membank *bank = &mi->bank[i];
 		unsigned int pfn1, pfn2;
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -866,7 +866,8 @@ extern void pagefault_out_of_memory(void
  * Flags passed to show_mem() and show_free_areas() to suppress output in
  * various contexts.
  */
-#define SHOW_MEM_FILTER_NODES	(0x0001u)	/* filter disallowed nodes */
+#define SHOW_MEM_FILTER_NODES		(0x0001u)	/* disallowed nodes */
+#define SHOW_MEM_FILTER_PAGE_COUNT	(0x0002u)	/* page type count */
 
 extern void show_free_areas(unsigned int flags);
 extern bool skip_free_areas_node(unsigned int flags, int nid);
--- a/lib/show_mem.c
+++ b/lib/show_mem.c
@@ -18,6 +18,9 @@ void show_mem(unsigned int filter)
 	printk("Mem-Info:\n");
 	show_free_areas(filter);
 
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
+
 	for_each_online_pgdat(pgdat) {
 		unsigned long i, flags;
 
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1885,6 +1885,13 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 		return;
 
 	/*
+	 * Walking all memory to count page types is very expensive and should
+	 * be inhibited in non-blockable contexts.
+	 */
+	if (!(gfp_mask & __GFP_WAIT))
+		filter |= SHOW_MEM_FILTER_PAGE_COUNT;
+
+	/*
 	 * This documents exceptions given to allocations in certain
 	 * contexts that are allowed to allocate outside current's set
 	 * of allowed nodes.


