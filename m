Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab3J1PGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:06:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab3J1Osw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:48:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 14/64] mm, show_mem: suppress page counts in non-blockable contexts
Date: Mon, 28 Oct 2013 14:47:33 +0000
Message-Id: <1382971703-17393-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mm/init.c       | 3 +++
 arch/ia64/mm/contig.c    | 2 ++
 arch/ia64/mm/discontig.c | 2 ++
 arch/parisc/mm/init.c    | 2 ++
 arch/unicore32/mm/init.c | 3 +++
 include/linux/mm.h       | 3 ++-
 lib/show_mem.c           | 3 +++
 mm/page_alloc.c          | 7 +++++++
 8 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index f54d592..01ad1f6 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -99,6 +99,9 @@ void show_mem(unsigned int filter)
 	printk("Mem-info:\n");
 	show_free_areas(filter);
 
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
+
 	for_each_bank (i, mi) {
 		struct membank *bank = &mi->bank[i];
 		unsigned int pfn1, pfn2;
diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
index 1516d1d..f2652fc 100644
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
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index c641333..2230817 100644
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
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 3ac462d..cf2da13 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -697,6 +697,8 @@ void show_mem(unsigned int filter)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas(filter);
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
 #ifndef CONFIG_DISCONTIGMEM
 	i = max_mapnr;
 	while (i-- > 0) {
diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
index de186bd..6444828 100644
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
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 920beba..53eb728 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -868,7 +868,8 @@ extern void pagefault_out_of_memory(void);
  * Flags passed to show_mem() and show_free_areas() to suppress output in
  * various contexts.
  */
-#define SHOW_MEM_FILTER_NODES	(0x0001u)	/* filter disallowed nodes */
+#define SHOW_MEM_FILTER_NODES		(0x0001u)	/* disallowed nodes */
+#define SHOW_MEM_FILTER_PAGE_COUNT	(0x0002u)	/* page type count */
 
 extern void show_free_areas(unsigned int flags);
 extern bool skip_free_areas_node(unsigned int flags, int nid);
diff --git a/lib/show_mem.c b/lib/show_mem.c
index 4407f8c..b7c7231 100644
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
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 63e6fa4..715b395 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1929,6 +1929,13 @@ void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...)
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
-- 
1.8.3.2

