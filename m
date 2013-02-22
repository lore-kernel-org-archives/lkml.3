Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab3BVQTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:19:44 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:20288 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212Ab3BVQTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:19:43 -0500
From: Glauber Costa <glommer@parallels.com>
To: <linux-mm@kvack.org>
Cc: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH v2] slub: correctly bootstrap boot caches
Date: Fri, 22 Feb 2013 20:20:00 +0400
Message-Id: <1361550000-14173-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we create a boot cache, we may allocate from it until it is bootstraped.
This will move the page from the partial list to the cpu slab list. If this
happens, the loop:

	list_for_each_entry(p, &n->partial, lru)

that we use to scan for all partial pages will yield nothing, and the pages
will keep pointing to the boot cpu cache, which is of course, invalid. To do
that, we should flush the cache to make sure that the cpu slab is back to the
partial list.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Reported-by:  Steffen Michalke <StMichalke@web.de>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>

 mm/slub.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)
---
 mm/slub.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index ba2ca53..31a494c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3617,6 +3617,12 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
 
 	memcpy(s, static_cache, kmem_cache->object_size);
 
+	/*
+	 * This runs very early, and only the boot processor is supposed to be
+	 * up.  Even if it weren't true, IRQs are not up so we couldn't fire
+	 * IPIs around.
+	 */
+	__flush_cpu_slab(s, smp_processor_id());
 	for_each_node_state(node, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 		struct page *p;
-- 
1.8.1.2

