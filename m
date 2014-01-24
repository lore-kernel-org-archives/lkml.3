Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaAXPUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:20:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:7890 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbaAXPUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:20:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,713,1384329600"; 
   d="scan'208";a="464172468"
Subject: [linux-next][PATCH] mm: slub: work around unneeded lockdep warning
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
        peterz@infradead.org, penberg@kernel.org, linux@arm.linux.org.uk
From: Dave Hansen <dave@sr71.net>
Date: Fri, 24 Jan 2014 07:20:23 -0800
Message-Id: <20140124152023.A450E599@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think this is a next-only thing.  Pekka, can you pick this up,
please?

--

From: Dave Hansen <dave.hansen@linux.intel.com>

The slub code does some setup during early boot in
early_kmem_cache_node_alloc() with some local data.  There is no
possible way that another CPU can see this data, so the slub code
doesn't unnecessarily lock it.  However, some new lockdep asserts
check to make sure that add_partial() _always_ has the list_lock
held.

Just add the locking, even though it is technically unnecessary.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
---

 b/mm/slub.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/slub.c~slub-lockdep-workaround mm/slub.c
--- a/mm/slub.c~slub-lockdep-workaround	2014-01-24 07:19:23.794069012 -0800
+++ b/mm/slub.c	2014-01-24 07:19:23.799069236 -0800
@@ -2890,7 +2890,13 @@ static void early_kmem_cache_node_alloc(
 	init_kmem_cache_node(n);
 	inc_slabs_node(kmem_cache_node, node, page->objects);
 
+	/*
+	 * the lock is for lockdep's sake, not for any actual
+	 * race protection
+	 */
+	spin_lock(&n->list_lock);
 	add_partial(n, page, DEACTIVATE_TO_HEAD);
+	spin_unlock(&n->list_lock);
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)
_
