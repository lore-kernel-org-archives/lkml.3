Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaCZP3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:29:20 -0400
Received: from relay.parallels.com ([195.214.232.42]:41915 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaCZP2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:28:11 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: [PATCH -mm 3/4] fork: charge threadinfo to memcg explicitly
Date: Wed, 26 Mar 2014 19:28:06 +0400
Message-ID: <8f98a5160b9e17947cbb25e91944f332679b9c9c.1395846845.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1395846845.git.vdavydov@parallels.com>
References: <cover.1395846845.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have only a few places where we actually want to charge kmem so
instead of intruding into the general page allocation path with
__GFP_KMEMCG it's better to explictly charge kmem there. All kmem
charges will be easier to follow that way.

This is a step toward removing __GFP_KMEMCG. It makes fork charge task
threadinfo pages explicitly instead of passing __GFP_KMEMCG to
alloc_pages.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
---
 kernel/fork.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f4b09bc15f3a..8209780cf732 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -150,15 +150,22 @@ void __weak arch_release_thread_info(struct thread_info *ti)
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
-	struct page *page = alloc_pages_node(node, THREADINFO_GFP_ACCOUNTED,
-					     THREAD_SIZE_ORDER);
+	struct page *page;
+	struct mem_cgroup *memcg = NULL;
 
+	if (!memcg_kmem_newpage_charge(THREADINFO_GFP_ACCOUNTED, &memcg,
+				       THREAD_SIZE_ORDER))
+		return NULL;
+	page = alloc_pages_node(node, THREADINFO_GFP, THREAD_SIZE_ORDER);
+	memcg_kmem_commit_charge(page, memcg, THREAD_SIZE_ORDER);
 	return page ? page_address(page) : NULL;
 }
 
 static inline void free_thread_info(struct thread_info *ti)
 {
-	free_memcg_kmem_pages((unsigned long)ti, THREAD_SIZE_ORDER);
+	if (ti)
+		memcg_kmem_uncharge_pages(virt_to_page(ti), THREAD_SIZE_ORDER);
+	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
 # else
 static struct kmem_cache *thread_info_cache;
-- 
1.7.10.4

