Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbaLJQbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:31:40 -0500
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:39173 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758110AbaLJQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:30:38 -0500
Message-Id: <20141210163033.841468065@linux.com>
Date: Wed, 10 Dec 2014 10:30:21 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linuxfoundation.org
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH 4/7] slub: Avoid using the page struct address in allocation fastpath
References: <20141210163017.092096069@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=more_c_page
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use virt_to_page there and only invoke the costly function if
actually a node is specified and we have to check the NUMA locality.

Increases the cost of allocating on a specific NUMA node but then that
was never cheap since we may have to dump our caches and retrieve memory
from the correct node.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2014-12-09 12:27:49.414686959 -0600
+++ linux/mm/slub.c	2014-12-09 12:27:49.414686959 -0600
@@ -2097,6 +2097,15 @@ static inline int node_match(struct page
 	return 1;
 }
 
+static inline int node_match_ptr(void *p, int node)
+{
+#ifdef CONFIG_NUMA
+	if (!p || (node != NUMA_NO_NODE && page_to_nid(virt_to_page(p)) != node))
+		return 0;
+#endif
+	return 1;
+}
+
 #ifdef CONFIG_SLUB_DEBUG
 static int count_free(struct page *page)
 {
@@ -2410,7 +2419,7 @@ redo:
 
 	object = c->freelist;
 	page = c->page;
-	if (unlikely(!object || !node_match(page, node))) {
+	if (unlikely(!object || !node_match_ptr(object, node))) {
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 		stat(s, ALLOC_SLOWPATH);
 	} else {

