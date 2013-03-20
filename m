Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab3CTSDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:03:49 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:41645 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab3CTSDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:03:46 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/5] mm: Try harder to allocate vmemmap blocks
Date: Wed, 20 Mar 2013 14:03:28 -0400
Message-Id: <1363802612-32127-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363802612-32127-1-git-send-email-hannes@cmpxchg.org>
References: <1363802612-32127-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

Hot-adding memory on x86_64 normally requires huge page allocation.
When this is done to a VM guest, it's usually because the system is
already tight on memory, so the request tends to fail.  Try to avoid
this by adding __GFP_REPEAT to the allocation flags.

Reported-and-tested-by: Bernhard Schmidt <Bernhard.Schmidt@lrz.de>
Reference: http://bugs.debian.org/699913
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/sparse-vmemmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 1b7e22a..22b7e18 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -53,10 +53,12 @@ void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 		struct page *page;
 
 		if (node_state(node, N_HIGH_MEMORY))
-			page = alloc_pages_node(node,
-				GFP_KERNEL | __GFP_ZERO, get_order(size));
+			page = alloc_pages_node(
+				node, GFP_KERNEL | __GFP_ZERO | __GFP_REPEAT,
+				get_order(size));
 		else
-			page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+			page = alloc_pages(
+				GFP_KERNEL | __GFP_ZERO | __GFP_REPEAT,
 				get_order(size));
 		if (page)
 			return page_address(page);
-- 
1.7.11.7

