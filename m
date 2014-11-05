Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaKEM07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:26:59 -0500
Received: from mx2.parallels.com ([199.115.105.18]:56326 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaKEM04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:26:56 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] memcg: don't check mm in __memcg_kmem_{get_cache,newpage_charge}
Date: Wed, 5 Nov 2014 15:26:47 +0300
Message-ID: <1415190408-4921-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already assured the current task has mm in memcg_kmem_should_charge,
no need to double check.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 95ee47c0f0a2..f61ecbc97d30 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2687,7 +2687,7 @@ struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
 	VM_BUG_ON(!cachep->memcg_params);
 	VM_BUG_ON(!cachep->memcg_params->is_root_cache);
 
-	if (!current->mm || current->memcg_kmem_skip_account)
+	if (current->memcg_kmem_skip_account)
 		return cachep;
 
 	rcu_read_lock();
@@ -2773,7 +2773,7 @@ __memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **_memcg, int order)
 	 * allocations are extremely rare but can happen, for instance, for the
 	 * cache arrays. We bring this test here.
 	 */
-	if (!current->mm || current->memcg_kmem_skip_account)
+	if (current->memcg_kmem_skip_account)
 		return true;
 
 	memcg = get_mem_cgroup_from_mm(current->mm);
-- 
1.7.10.4

