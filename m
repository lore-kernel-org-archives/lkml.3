Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab3HTGzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:55:23 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42604 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab3HTGzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:55:19 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 4/4] mm/vmalloc: use wrapper function get_vm_area_size to caculate size of vm area
Date: Tue, 20 Aug 2013 14:54:56 +0800
Message-Id: <1376981696-4312-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082006-5816-0000-0000-0000097E8E50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 -> v2:
 * replace all the spots by function get_vm_area_size().

Use wrapper function get_vm_area_size to calculate size of vm area.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/vmalloc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 93d3182..1074543 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1258,7 +1258,7 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
 int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
 {
 	unsigned long addr = (unsigned long)area->addr;
-	unsigned long end = addr + area->size - PAGE_SIZE;
+	unsigned long end = addr + get_vm_area_size(area);
 	int err;
 
 	err = vmap_page_range(addr, end, prot, *pages);
@@ -1553,7 +1553,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	unsigned int nr_pages, array_size, i;
 	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
 
-	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
+	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
 
 	area->nr_pages = nr_pages;
@@ -1985,7 +1985,7 @@ long vread(char *buf, char *addr, unsigned long count)
 
 		vm = va->vm;
 		vaddr = (char *) vm->addr;
-		if (addr >= vaddr + vm->size - PAGE_SIZE)
+		if (addr >= vaddr + get_vm_area_size(vm))
 			continue;
 		while (addr < vaddr) {
 			if (count == 0)
@@ -1995,7 +1995,7 @@ long vread(char *buf, char *addr, unsigned long count)
 			addr++;
 			count--;
 		}
-		n = vaddr + vm->size - PAGE_SIZE - addr;
+		n = vaddr + get_vm_area_size(vm) - addr;
 		if (n > count)
 			n = count;
 		if (!(vm->flags & VM_IOREMAP))
@@ -2067,7 +2067,7 @@ long vwrite(char *buf, char *addr, unsigned long count)
 
 		vm = va->vm;
 		vaddr = (char *) vm->addr;
-		if (addr >= vaddr + vm->size - PAGE_SIZE)
+		if (addr >= vaddr + get_vm_area_size(vm))
 			continue;
 		while (addr < vaddr) {
 			if (count == 0)
@@ -2076,7 +2076,7 @@ long vwrite(char *buf, char *addr, unsigned long count)
 			addr++;
 			count--;
 		}
-		n = vaddr + vm->size - PAGE_SIZE - addr;
+		n = vaddr + get_vm_area_size(vm) - addr;
 		if (n > count)
 			n = count;
 		if (!(vm->flags & VM_IOREMAP)) {
-- 
1.8.1.2

