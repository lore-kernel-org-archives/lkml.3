Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaLJQak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:30:40 -0500
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:51602 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755924AbaLJQag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:30:36 -0500
Message-Id: <20141210163033.497862168@linux.com>
Date: Wed, 10 Dec 2014 10:30:18 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linuxfoundation.org
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH 1/7] slub: Remove __slab_alloc code duplication
References: <20141210163017.092096069@linux.com>
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
--- linux.orig/mm/slub.c	2014-12-08 13:24:05.193185492 -0600
+++ linux/mm/slub.c	2014-12-09 12:23:11.927032128 -0600
@@ -2282,10 +2282,7 @@ redo:
 
 		if (unlikely(!node_match(page, searchnode))) {
 			stat(s, ALLOC_NODE_MISMATCH);
-			deactivate_slab(s, page, c->freelist);
-			c->page = NULL;
-			c->freelist = NULL;
-			goto new_slab;
+			goto deactivate;
 		}
 	}
 
@@ -2294,12 +2291,8 @@ redo:
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
@@ -2328,6 +2321,11 @@ load_freelist:
 	local_irq_restore(flags);
 	return freelist;
 
+deactivate:
+	deactivate_slab(s, page, c->freelist);
+	c->page = NULL;
+	c->freelist = NULL;
+
 new_slab:
 
 	if (c->partial) {

