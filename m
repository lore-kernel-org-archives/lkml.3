Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab3IYBDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:03:08 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52241 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab3IYBDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:03:04 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v7 1/4] mm/vmalloc: don't set area->caller twice
Date: Wed, 25 Sep 2013 09:02:41 +0800
Message-Id: <1380070964-12975-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-5490-0000-0000-00000434D8DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 *v1 -> v2: rebase against mmotm tree
 *v6 -> v7: drop "caller" argument of __vmalloc_area_node()

The caller address has already been set in set_vmalloc_vm(), there's no need
to set it again in __vmalloc_area_node.

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/vmalloc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1074543..f75c2aa 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1546,7 +1546,7 @@ static void *__vmalloc_node(unsigned long size, unsigned long align,
 			    gfp_t gfp_mask, pgprot_t prot,
 			    int node, const void *caller);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
-				 pgprot_t prot, int node, const void *caller)
+				 pgprot_t prot, int node)
 {
 	const int order = 0;
 	struct page **pages;
@@ -1560,13 +1560,12 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|__GFP_HIGHMEM,
-				PAGE_KERNEL, node, caller);
+				PAGE_KERNEL, node, area->caller);
 		area->flags |= VM_VPAGES;
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
 	area->pages = pages;
-	area->caller = caller;
 	if (!area->pages) {
 		remove_vm_area(area->addr);
 		kfree(area);
@@ -1634,7 +1633,7 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	if (!area)
 		goto fail;
 
-	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+	addr = __vmalloc_area_node(area, gfp_mask, prot, node);
 	if (!addr)
 		goto fail;
 
-- 
1.7.5.4

