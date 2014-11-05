Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaKEJ5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:57:12 -0500
Received: from mx2.parallels.com ([199.115.105.18]:57164 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaKEJ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:57:08 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] memcg: zap kmem_account_flags
Date: Wed, 5 Nov 2014 12:56:54 +0300
Message-ID: <1415181414-2205-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only such flag is KMEM_ACCOUNTED_ACTIVE, but it's set iff
mem_cgroup->kmemcg_id >= 0, so we can check kmemcg_id instead of having
a separate flags field.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0c315c99122d..9a37d99aee54 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -296,7 +296,6 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
-	unsigned long kmem_account_flags; /* See KMEM_ACCOUNTED_*, below */
 
 	bool		oom_lock;
 	atomic_t	under_oom;
@@ -363,22 +362,11 @@ struct mem_cgroup {
 	/* WARNING: nodeinfo must be the last member here */
 };
 
-/* internal only representation about the status of kmem accounting. */
-enum {
-	KMEM_ACCOUNTED_ACTIVE, /* accounted by this cgroup itself */
-};
-
 #ifdef CONFIG_MEMCG_KMEM
-static inline void memcg_kmem_set_active(struct mem_cgroup *memcg)
-{
-	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
-}
-
 static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 {
-	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
+	return memcg->kmemcg_id >= 0;
 }
-
 #endif
 
 /* Stuffs for move charges at task migration. */
@@ -3471,22 +3459,21 @@ static int memcg_activate_kmem(struct mem_cgroup *memcg,
 		goto out;
 	}
 
-	memcg->kmemcg_id = memcg_id;
-
 	/*
-	 * We couldn't have accounted to this cgroup, because it hasn't got the
-	 * active bit set yet, so this should succeed.
+	 * We couldn't have accounted to this cgroup, because it hasn't got
+	 * activated yet, so this should succeed.
 	 */
 	err = page_counter_limit(&memcg->kmem, nr_pages);
 	VM_BUG_ON(err);
 
 	static_key_slow_inc(&memcg_kmem_enabled_key);
 	/*
-	 * Setting the active bit after enabling static branching will
+	 * A memory cgroup is considered kmem-active as soon as it gets
+	 * kmemcg_id. Setting the id after enabling static branching will
 	 * guarantee no one starts accounting before all call sites are
 	 * patched.
 	 */
-	memcg_kmem_set_active(memcg);
+	memcg->kmemcg_id = memcg_id;
 out:
 	memcg_resume_kmem_account();
 	return err;
-- 
1.7.10.4

