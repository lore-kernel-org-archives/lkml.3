Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3L0JrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:47:15 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:46138 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3L0JrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:47:14 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH] mm/slub: fix accumulate per cpu partial cache objects
Date: Fri, 27 Dec 2013 17:46:59 +0800
Message-Id: <1388137619-14741-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122709-5564-0000-0000-00000B4B25B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB per cpu partial cache is a list of slab caches to accelerate objects 
allocation. However, current codes just accumulate the objects number of 
the first slab cache of per cpu partial cache instead of traverse the whole 
list.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slub.c |   32 +++++++++++++++++++++++---------
 1 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 545a170..799bfdc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4280,7 +4280,7 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 			struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab,
 							       cpu);
 			int node;
-			struct page *page;
+			struct page *page, *p;
 
 			page = ACCESS_ONCE(c->page);
 			if (!page)
@@ -4298,8 +4298,9 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 			nodes[node] += x;
 
 			page = ACCESS_ONCE(c->partial);
-			if (page) {
-				x = page->pobjects;
+			while ((p = page)) {
+				page = p->next;
+				x = p->pobjects;
 				total += x;
 				nodes[node] += x;
 			}
@@ -4520,13 +4521,15 @@ static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
 	int pages = 0;
 	int cpu;
 	int len;
+	struct page *p;
 
 	for_each_online_cpu(cpu) {
 		struct page *page = per_cpu_ptr(s->cpu_slab, cpu)->partial;
 
-		if (page) {
-			pages += page->pages;
-			objects += page->pobjects;
+		while ((p = page)) {
+			page = p->next;
+			pages += p->pages;
+			objects += p->pobjects;
 		}
 	}
 
@@ -4535,10 +4538,21 @@ static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
 #ifdef CONFIG_SMP
 	for_each_online_cpu(cpu) {
 		struct page *page = per_cpu_ptr(s->cpu_slab, cpu) ->partial;
+		objects = 0;
+		pages = 0;
+
+		if (!page)
+			continue;
+
+		while ((p = page)) {
+			page = p->next;
+			pages += p->pages;
+			objects += p->pobjects;
+		}
 
-		if (page && len < PAGE_SIZE - 20)
-			len += sprintf(buf + len, " C%d=%d(%d)", cpu,
-				page->pobjects, page->pages);
+		if (len < PAGE_SIZE - 20)
+			len += sprintf(buf + len, " C%d=%d(%d)", cpu,
+				objects, pages);
 	}
 #endif
 	return len + sprintf(buf + len, "\n");
-- 
1.7.7.6

