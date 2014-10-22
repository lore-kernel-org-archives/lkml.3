Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaJVPze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:55:34 -0400
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:59030 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535AbaJVPza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:55:30 -0400
Message-Id: <20141022155526.942670823@linux.com>
Date: Wed, 22 Oct 2014 10:55:18 -0500
From: Christoph Lameter <cl@linux.com>
To: akpm@linuxfoundation.org
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com
Subject: [RFC 1/4] slub: Remove __slab_alloc code duplication
References: <20141022155517.560385718@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=simplify_code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow the two branches in __slab_alloc do the same.
Unify them.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -2280,12 +2280,8 @@ redo:
 		if (node != NUMA_NO_NODE && !node_present_pages(node))
 			searchnode = node_to_mem_node(node);
 
-		if (unlikely(!node_match(page, searchnode))) {
-			stat(s, ALLOC_NODE_MISMATCH);
-			deactivate_slab(s, page, c->freelist);
-			c->page = NULL;
-			c->freelist = NULL;
-			goto new_slab;
+		if (unlikely(!node_match(page, searchnode)))
+			goto deactivate;
 		}
 	}
 
@@ -2294,12 +2290,8 @@ redo:
 	 * PFMEMALLOC but right now, we are losing the pfmemalloc
 	 * information when the page leaves the per-cpu allocator
 	 */
-	if (unlikely(!pfmemalloc_match(page, gfpflags))) {
-		deactivate_slab(s, page, c->freelist);
-		c->page = NULL;
-		c->freelist = NULL;
-		goto new_slab;
-	}
+	if (unlikely(!pfmemalloc_match(page, gfpflags)))
+		goto deactivate;
 
 	/* must check again c->freelist in case of cpu migration or IRQ */
 	freelist = c->freelist;
@@ -2328,6 +2320,11 @@ load_freelist:
 	local_irq_restore(flags);
 	return freelist;
 
+deactivate:
+	deactivate_slab(s, page, c->freelist);
+	c->page = NULL;
+	c->freelist = NULL;
+
 new_slab:
 
 	if (c->partial) {

