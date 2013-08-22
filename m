Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3HVFTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:19:54 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40952 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3HVFTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:19:53 -0400
MIME-Version: 1.0
In-Reply-To: <52146c58.a3e2440a.0f5a.ffffed8dSMTPIN_ADDED_BROKEN@mx.google.com>
References: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<1376981696-4312-2-git-send-email-liwanp@linux.vnet.ibm.com>
	<20130820160735.b12fe1b3dd64b4dc146d2fa0@linux-foundation.org>
	<CAE9FiQVy2uqLm2XyStYmzxSmsw7TzrB0XDhCRLymnf+L3NPxrA@mail.gmail.com>
	<52142ffe.84c0440a.57e5.02acSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAE9FiQW1c3-d+iMebRK6JyHCpMt8mjga-TnsfTuVsC1bQZqsYA@mail.gmail.com>
	<52146c58.a3e2440a.0f5a.ffffed8dSMTPIN_ADDED_BROKEN@mx.google.com>
Date: Wed, 21 Aug 2013 22:19:52 -0700
X-Google-Sender-Auth: spPDxbV7PsZodsdABOZ0agDcd5w
Message-ID: <CAE9FiQVWVzO93RM_QT-Qp+5jJUEiw=5OOD_454fCjgQ5p9-b3g@mail.gmail.com>
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

On Wed, Aug 21, 2013 at 12:29 AM, Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
> Hi Yinghai,
> On Tue, Aug 20, 2013 at 09:28:29PM -0700, Yinghai Lu wrote:
>>On Tue, Aug 20, 2013 at 8:11 PM, Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
>>> Hi Yinghai,
>>> On Tue, Aug 20, 2013 at 05:02:17PM -0700, Yinghai Lu wrote:
>>>>>> -     /* ok, last chunk */
>>>>>> -     sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, NR_MEM_SECTIONS,
>>>>>> -                                      usemap_count, nodeid_begin);
>>>>>> +     alloc_usemap_and_memmap(usemap_map, true);
>>>>
>>>>alloc_usemap_and_memmap() is somehow confusing.
>>>>
>>>>Please check if you can pass function pointer instead of true/false.
>>>>
>>>
>>> sparse_early_usemaps_alloc_node and sparse_early_mem_maps_alloc_node is
>>> similar, however, one has a parameter unsigned long ** and the other has
>>> struct page **. function pointer can't help, isn't it? ;-)
>>
>>you could have one generic function pointer like
>>void *alloc_func(void *data);
>>
>>and in the every alloc function, have own struct data to pass in/out...
>>
>>Yinghai
>
> How about this?


>From a78e12a9ff31f2a73b87145ce7ad943a0f712708 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Date: Wed, 21 Aug 2013 15:23:08 +0800
Subject: [PATCH] mm/sparse: introduce alloc_usemap_and_memmap fix

Pass function pointer to alloc_usemap_and_memmap() instead of true/false.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/sparse.c |   54 +++++++++++++++++++++++++-----------------------------
 1 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 55e5752..06adf3c 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -339,14 +339,16 @@ static void __init check_usemap_section_nr(int
nid, unsigned long *usemap)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */

-static void __init sparse_early_usemaps_alloc_node(unsigned long**usemap_map,
+static void __init sparse_early_usemaps_alloc_node(void **usemap_map,
                  unsigned long pnum_begin,
                  unsigned long pnum_end,
                  unsigned long usemap_count, int nodeid)
 {
     void *usemap;
     unsigned long pnum;
+    unsigned long **map;
     int size = usemap_size();
+    map = (unsigned long **) usemap_map;

     usemap = sparse_early_usemaps_alloc_pgdat_section(NODE_DATA(nodeid),
                               size * usemap_count);
@@ -358,9 +360,9 @@ static void __init
sparse_early_usemaps_alloc_node(unsigned long**usemap_map,
     for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
         if (!present_section_nr(pnum))
             continue;
-        usemap_map[pnum] = usemap;
+        map[pnum] = usemap;
         usemap += size;
-        check_usemap_section_nr(nodeid, usemap_map[pnum]);
+        check_usemap_section_nr(nodeid, map[pnum]);
     }
 }

@@ -430,23 +432,16 @@ void __init sparse_mem_maps_populate_node(struct
page **map_map,
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */

 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
-static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
+static void __init sparse_early_mem_maps_alloc_node(void **map_map,
                  unsigned long pnum_begin,
                  unsigned long pnum_end,
                  unsigned long map_count, int nodeid)
 {
-    sparse_mem_maps_populate_node(map_map, pnum_begin, pnum_end,
+    struct page **map = (struct page **)map_map;
+    sparse_mem_maps_populate_node(map, pnum_begin, pnum_end,
                      map_count, nodeid);
 }

======> maybe you can have:

struct alloc_info {
   struct page **map_map;
   unsigned long pnum_begin;
   unsigned long pnum_end;
   unsigned long map_count;
   int nodeid;
};

static void __init sparse_early_mem_maps_alloc_node(void *data)
 {
    struct alloc_info *info = (struct alloc_info *)data;

    sparse_mem_maps_populate_node(info->map_map, info->pnum_begin,
info->pnum_end,
                      info->map_count, info->nodeid);
 }

==============

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
@@ -471,9 +466,10 @@ void __attribute__((weak)) __meminit
vmemmap_populate_print_last(void)
 /**
  *  alloc_usemap_and_memmap - memory alloction for pageblock flags and vmemmap
  *  @map: usemap_map for pageblock flags or mmap_map for vmemmap
- *  @use_map: true if memory allocated for pageblock flags, otherwise false
  */
-static void alloc_usemap_and_memmap(unsigned long **map, bool use_map)
+static void alloc_usemap_and_memmap(void (*sparse_early_maps_alloc_node)
+                (void **, unsigned long, unsigned long,
+                unsigned long, int), void **map)
 {
     unsigned long pnum;
     unsigned long map_count;
@@ -504,24 +500,16 @@ static void alloc_usemap_and_memmap(unsigned
long **map, bool use_map)
             continue;
         }
         /* ok, we need to take cake of from pnum_begin to pnum - 1*/
-        if (use_map)
-            sparse_early_usemaps_alloc_node(map, pnum_begin, pnum,
-                         map_count, nodeid_begin);
-        else
-            sparse_early_mem_maps_alloc_node((struct page **)map,
-                pnum_begin, pnum, map_count, nodeid_begin);
+        (*sparse_early_maps_alloc_node)(map, pnum_begin, pnum,
+                    map_count, nodeid_begin);


========> can you use sparse_early_maps_alloc_node() ?

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
+    (*sparse_early_maps_alloc_node)(map, pnum_begin, NR_MEM_SECTIONS,
+                    map_count, nodeid_begin);
 }

 /*
@@ -540,6 +528,10 @@ void __init sparse_init(void)
     struct page **map_map;
 #endif

+    void (*sparse_early_maps_alloc_node)(void **map,
+            unsigned long pnum_begin, unsigned long pnum_end,
+                unsigned long map_count, int nodeid);
+
     /* see include/linux/mmzone.h 'struct mem_section' definition */
     BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));

@@ -561,14 +553,18 @@ void __init sparse_init(void)
     usemap_map = alloc_bootmem(size);
     if (!usemap_map)
         panic("can not allocate usemap_map\n");
-    alloc_usemap_and_memmap(usemap_map, true);
+    sparse_early_maps_alloc_node = sparse_early_usemaps_alloc_node;

why do you need to assign again?

+    alloc_usemap_and_memmap(sparse_early_maps_alloc_node,
+                        (void **)usemap_map);

 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
     size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
     map_map = alloc_bootmem(size2);
     if (!map_map)
         panic("can not allocate map_map\n");
-    alloc_usemap_and_memmap((unsigned long **)map_map, false);
+    sparse_early_maps_alloc_node = sparse_early_mem_maps_alloc_node;
+    alloc_usemap_and_memmap(sparse_early_maps_alloc_node,
+                        (void **)map_map);
 #endif

     for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-- 
1.7.7.6
