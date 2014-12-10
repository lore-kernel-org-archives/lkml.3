Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbaLJQbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:31:55 -0500
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:57739 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758104AbaLJQah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:30:37 -0500
Message-Id: <20141210163033.717707217@linux.com>
Date: Wed, 10 Dec 2014 10:30:20 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linuxfoundation.org
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH 3/7] slub: Do not use c->page on free
References: <20141210163017.092096069@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=slub_free_compare_address_range
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid using the page struct address on free by just doing an
address comparison. That is easily doable now that the page address
is available in the page struct and we already have the page struct
address of the object to be freed calculated.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2014-12-09 12:25:45.770405462 -0600
+++ linux/mm/slub.c	2014-12-09 12:25:45.766405582 -0600
@@ -2625,6 +2625,13 @@ slab_empty:
 	discard_slab(s, page);
 }
 
+static bool same_slab_page(struct kmem_cache *s, struct page *page, void *p)
+{
+	long d = p - page->address;
+
+	return d > 0 && d < (1 << MAX_ORDER) && d < (compound_order(page) << PAGE_SHIFT);
+}
+
 /*
  * Fastpath with forced inlining to produce a kfree and kmem_cache_free that
  * can perform fastpath freeing without additional function calls.
@@ -2658,7 +2665,7 @@ redo:
 	tid = c->tid;
 	preempt_enable();
 
-	if (likely(page == c->page)) {
+	if (likely(same_slab_page(s, page, c->freelist))) {
 		set_freepointer(s, object, c->freelist);
 
 		if (unlikely(!this_cpu_cmpxchg_double(

