Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaCBNk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 08:40:29 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53843 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaCBNk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 08:40:26 -0500
From: Gideon Israel Dsouza <gidisrael@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: [PATCH 1/1] mm: use macros from compiler.h instead of __attribute__((...))
Date: Sun,  2 Mar 2014 19:09:58 +0530
Message-Id: <1393767598-15954-2-git-send-email-gidisrael@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393767598-15954-1-git-send-email-gidisrael@gmail.com>
References: <1393767598-15954-1-git-send-email-gidisrael@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To increase compiler portability there is <linux/compiler.h> which
provides convenience macros for various gcc constructs.  Eg: __weak
for __attribute__((weak)).  I've replaced all instances of gcc
attributes with the right macro in the memory management
(/mm) subsystem.

Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
---
 mm/hugetlb.c | 3 ++-
 mm/nommu.c   | 3 ++-
 mm/sparse.c  | 4 +++-
 mm/util.c    | 5 +++--
 mm/vmalloc.c | 4 +++-
 5 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c01cb9f..2870e19 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -13,6 +13,7 @@
 #include <linux/nodemask.h>
 #include <linux/pagemap.h>
 #include <linux/mempolicy.h>
+#include <linux/compiler.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
 #include <linux/bootmem.h>
@@ -3446,7 +3447,7 @@ follow_huge_pud(struct mm_struct *mm, unsigned long address,
 #else /* !CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
 /* Can be overriden by architectures */
-__attribute__((weak)) struct page *
+__weak struct page *
 follow_huge_pud(struct mm_struct *mm, unsigned long address,
 	       pud_t *pud, int write)
 {
diff --git a/mm/nommu.c b/mm/nommu.c
index 8740213..6556792 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -24,6 +24,7 @@
 #include <linux/vmalloc.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
+#include <linux/compiler.h>
 #include <linux/mount.h>
 #include <linux/personality.h>
 #include <linux/security.h>
@@ -459,7 +460,7 @@ EXPORT_SYMBOL_GPL(vm_unmap_aliases);
  * Implement a stub for vmalloc_sync_all() if the architecture chose not to
  * have one.
  */
-void  __attribute__((weak)) vmalloc_sync_all(void)
+void  __weak vmalloc_sync_all(void)
 {
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 63c3ea5..68ad7da 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -5,10 +5,12 @@
 #include <linux/slab.h>
 #include <linux/mmzone.h>
 #include <linux/bootmem.h>
+#include <linux/compiler.h>
 #include <linux/highmem.h>
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
+
 #include "internal.h"
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
@@ -461,7 +463,7 @@ static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 }
 #endif
 
-void __attribute__((weak)) __meminit vmemmap_populate_print_last(void)
+void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
diff --git a/mm/util.c b/mm/util.c
index a24aa22..d7813e6 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1,6 +1,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/sched.h>
@@ -307,7 +308,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
  * If the architecture not support this function, simply return with no
  * page pinned
  */
-int __attribute__((weak)) __get_user_pages_fast(unsigned long start,
+int __weak __get_user_pages_fast(unsigned long start,
 				 int nr_pages, int write, struct page **pages)
 {
 	return 0;
@@ -338,7 +339,7 @@ EXPORT_SYMBOL_GPL(__get_user_pages_fast);
  * callers need to carefully consider what to use. On many architectures,
  * get_user_pages_fast simply falls back to get_user_pages.
  */
-int __attribute__((weak)) get_user_pages_fast(unsigned long start,
+int __weak get_user_pages_fast(unsigned long start,
 				int nr_pages, int write, struct page **pages)
 {
 	struct mm_struct *mm = current->mm;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0fdf968..a7b522f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -27,7 +27,9 @@
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
 #include <linux/atomic.h>
+#include <linux/compiler.h>
 #include <linux/llist.h>
+
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
@@ -2181,7 +2183,7 @@ EXPORT_SYMBOL(remap_vmalloc_range);
  * Implement a stub for vmalloc_sync_all() if the architecture chose not to
  * have one.
  */
-void  __attribute__((weak)) vmalloc_sync_all(void)
+void __weak vmalloc_sync_all(void)
 {
 }
 
-- 
1.8.5.3

