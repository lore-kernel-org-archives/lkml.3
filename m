Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbaAFUnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:43:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:16492 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191AbaAFUnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:43:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="462491402"
Subject: [PATCH] mm: slub: fix ALLOC_SLOWPATH stat
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        akpm@linux-foundation.org, penberg@kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 06 Jan 2014 12:43:00 -0800
Message-Id: <20140106204300.DE79BA86@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

There used to be only one path out of __slab_alloc(), and
ALLOC_SLOWPATH got bumped in that exit path.  Now there are two,
and a bunch of gotos.  ALLOC_SLOWPATH can now get set more than once
during a single call to __slab_alloc() which is pretty bogus.
Here's the sequence:

1. Enter __slab_alloc(), fall through all the way to the
   stat(s, ALLOC_SLOWPATH);
2. hit 'if (!freelist)', and bump DEACTIVATE_BYPASS, jump to
   new_slab (goto #1)
3. Hit 'if (c->partial)', bump CPU_PARTIAL_ALLOC, goto redo
   (goto #2)
4. Fall through in the same path we did before all the way to
   stat(s, ALLOC_SLOWPATH)
5. bump ALLOC_REFILL stat, then return

Doing this is obviously bogus.  It keeps us from being able to
accurately compare ALLOC_SLOWPATH vs. ALLOC_FASTPATH.  It also
means that the total number of allocs always exceeds the total
number of frees.

This patch moves stat(s, ALLOC_SLOWPATH) to be called from the
same place that __slab_alloc() is.  This makes it much less
likely that ALLOC_SLOWPATH will get botched again in the
spaghetti-code inside __slab_alloc().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/mm/slub.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/slub.c~slub-ALLOC_SLOWPATH-stat mm/slub.c
--- linux.git/mm/slub.c~slub-ALLOC_SLOWPATH-stat	2014-01-06 12:39:28.148072544 -0800
+++ linux.git-davehans/mm/slub.c	2014-01-06 12:39:28.155072860 -0800
@@ -2301,8 +2301,6 @@ redo:
 	if (freelist)
 		goto load_freelist;
 
-	stat(s, ALLOC_SLOWPATH);
-
 	freelist = get_freelist(s, page);
 
 	if (!freelist) {
@@ -2409,10 +2407,10 @@ redo:
 
 	object = c->freelist;
 	page = c->page;
-	if (unlikely(!object || !node_match(page, node)))
+	if (unlikely(!object || !node_match(page, node))) {
 		object = __slab_alloc(s, gfpflags, node, addr, c);
-
-	else {
+		stat(s, ALLOC_SLOWPATH);
+	} else {
 		void *next_object = get_freepointer_safe(s, object);
 
 		/*
_
