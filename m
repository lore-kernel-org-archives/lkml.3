Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3H2CSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:18:31 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:54036 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3H2CSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:18:30 -0400
MIME-Version: 1.0
In-Reply-To: <521600cc.22ab440a.2703.53f1SMTPIN_ADDED_BROKEN@mx.google.com>
References: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<1376981696-4312-2-git-send-email-liwanp@linux.vnet.ibm.com>
	<20130820160735.b12fe1b3dd64b4dc146d2fa0@linux-foundation.org>
	<CAE9FiQVy2uqLm2XyStYmzxSmsw7TzrB0XDhCRLymnf+L3NPxrA@mail.gmail.com>
	<52142ffe.84c0440a.57e5.02acSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAE9FiQW1c3-d+iMebRK6JyHCpMt8mjga-TnsfTuVsC1bQZqsYA@mail.gmail.com>
	<52146c58.a3e2440a.0f5a.ffffed8dSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAE9FiQVWVzO93RM_QT-Qp+5jJUEiw=5OOD_454fCjgQ5p9-b3g@mail.gmail.com>
	<521600cc.22ab440a.2703.53f1SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Wed, 28 Aug 2013 19:18:29 -0700
X-Google-Sender-Auth: PQclcuzU54CbgatVqPRJSZyy9yU
Message-ID: <CAE9FiQXrpZU8DCFoF6NuaOoqwGFGcQfnHV7vdWWPfyAymCCGnQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm/sparse: introduce alloc_usemap_and_memmap
From: Yinghai Lu <yinghai@kernel.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiri Kosina <jkosina@suse.cz>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 5:14 AM, Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
>From f21640b6dc15c76ac10fccada96e6b9fdce5a092 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 19:57:54 +0800
Subject: [PATCH] mm/sparse: introduce alloc_usemap_and_memmap fix

Pass function pointer to alloc_usemap_and_memmap() instead of true/false.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/sparse.c | 78 ++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 34 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 55e5752..22a1a26 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -14,6 +14,14 @@
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>

+struct alloc_info {
+    unsigned long **map_map;
+    unsigned long pnum_begin;
+    unsigned long pnum_end;
+    unsigned long map_count;
+    int nodeid;
+};
+
 /*
  * Permanent SPARSEMEM data:
  *
@@ -339,13 +347,16 @@ static void __init check_usemap_section_nr(int
nid, unsigned long *usemap)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */

-static void __init sparse_early_usemaps_alloc_node(unsigned long**usemap_map,
-                 unsigned long pnum_begin,
-                 unsigned long pnum_end,
-                 unsigned long usemap_count, int nodeid)
+static void __init sparse_early_usemaps_alloc_node(void *data)
 {
     void *usemap;
     unsigned long pnum;
+    struct alloc_info *info = (struct alloc_info *)data;
+    unsigned long **usemap_map = info->map_map;
+    unsigned long pnum_begin = info->pnum_begin;
+    unsigned long pnum_end = info->pnum_end;

+    unsigned long usemap_count = info->map_count;
+    int nodeid = info->nodeid;

===>
usemap_count and nodeid is only referred one time, you may omit those
two temp variables.


     int size = usemap_size();

     usemap = sparse_early_usemaps_alloc_pgdat_section(NODE_DATA(nodeid),
@@ -430,23 +441,13 @@ void __init sparse_mem_maps_populate_node(struct
page **map_map,
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */

 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
-static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
-                 unsigned long pnum_begin,
-                 unsigned long pnum_end,
-                 unsigned long map_count, int nodeid)
+static void __init sparse_early_mem_maps_alloc_node(void *data)
 {
-    sparse_mem_maps_populate_node(map_map, pnum_begin, pnum_end,
-                     map_count, nodeid);
+    struct alloc_info *info = (struct alloc_info *)data;
+    sparse_mem_maps_populate_node((struct page **)info->map_map,
+    info->pnum_begin, info->pnum_end, info->map_count, info->nodeid);
 }
 #else
-
-static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
-                unsigned long pnum_begin,
-                unsigned long pnum_end,
-                unsigned long map_count, int nodeid)
-{
-}
-
 static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
     struct page *map;
@@ -471,14 +472,15 @@ void __attribute__((weak)) __meminit
vmemmap_populate_print_last(void)
 /**
  *  alloc_usemap_and_memmap - memory alloction for pageblock flags and vmemmap
  *  @map: usemap_map for pageblock flags or mmap_map for vmemmap
- *  @use_map: true if memory allocated for pageblock flags, otherwise false
  */
-static void alloc_usemap_and_memmap(unsigned long **map, bool use_map)
+static void alloc_usemap_and_memmap(void (*sparse_early_maps_alloc_node)
+                (void *data), void *data)

==> how about changing to :

+static void alloc_map(void (*alloc_fn)(void *), void *data)


 {
     unsigned long pnum;
     unsigned long map_count;
     int nodeid_begin = 0;
     unsigned long pnum_begin = 0;
+    struct alloc_info *info = (struct alloc_info *)data;

     for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
         struct mem_section *ms;
@@ -503,25 +505,24 @@ static void alloc_usemap_and_memmap(unsigned
long **map, bool use_map)
             map_count++;
             continue;
         }
+
+        info->pnum_begin = pnum_begin;
+        info->pnum_end = pnum;
+        info->map_count = map_count;
+        info->nodeid = nodeid_begin;
         /* ok, we need to take cake of from pnum_begin to pnum - 1*/
-        if (use_map)
-            sparse_early_usemaps_alloc_node(map, pnum_begin, pnum,
-                         map_count, nodeid_begin);
-        else
-            sparse_early_mem_maps_alloc_node((struct page **)map,
-                pnum_begin, pnum, map_count, nodeid_begin);
+        sparse_early_maps_alloc_node((void *)info);
         /* new start, update count etc*/
         nodeid_begin = nodeid;
         pnum_begin = pnum;
         map_count = 1;
     }
     /* ok, last chunk */
-    if (use_map)
-        sparse_early_usemaps_alloc_node(map, pnum_begin,
-                NR_MEM_SECTIONS, map_count, nodeid_begin);
-    else
-        sparse_early_mem_maps_alloc_node((struct page **)map,
-            pnum_begin, NR_MEM_SECTIONS, map_count, nodeid_begin);
+    info->pnum_begin = pnum_begin;
+    info->pnum_end = NR_MEM_SECTIONS;
+    info->map_count = map_count;
+    info->nodeid = nodeid_begin;
+    sparse_early_maps_alloc_node((void *)info);
 }

 /*
@@ -535,11 +536,14 @@ void __init sparse_init(void)
     unsigned long *usemap;
     unsigned long **usemap_map;
     int size;
+    struct alloc_info data;
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
     int size2;
     struct page **map_map;
 #endif

+    void (*sparse_early_maps_alloc_node)(void *data);
+
     /* see include/linux/mmzone.h 'struct mem_section' definition */
     BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));

@@ -561,14 +565,20 @@ void __init sparse_init(void)
     usemap_map = alloc_bootmem(size);
     if (!usemap_map)
         panic("can not allocate usemap_map\n");
-    alloc_usemap_and_memmap(usemap_map, true);
+    sparse_early_maps_alloc_node = sparse_early_usemaps_alloc_node;

so you can not use sparse_early_usemaps_alloc_nod() directly?

+    data.map_map = usemap_map;
+    alloc_usemap_and_memmap(sparse_early_maps_alloc_node, (void *)&data);

+    usemap_map = data.map_map;

why do you need to this assign ? data.map_map value get changed?



 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
     size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
     map_map = alloc_bootmem(size2);
     if (!map_map)
         panic("can not allocate map_map\n");
-    alloc_usemap_and_memmap((unsigned long **)map_map, false);
+    sparse_early_maps_alloc_node = sparse_early_mem_maps_alloc_node;
+    data.map_map = (unsigned long **)map_map;
+    alloc_usemap_and_memmap(sparse_early_maps_alloc_node, (void *)&data);
+    map_map = (struct page **)data.map_map;
 #endif


please change to function pointer to
void  (*alloc_func)(void *data,
                                 unsigned long pnum_begin,
                                 unsigned long pnum_end,
                                 unsigned long map_count, int nodeid)

pnum_begin, pnum_end, map_coun, nodeid, should not be in the struct.

please send patch against linus/master, so i could send back updated
version directly.

Thanks

Yinghai
