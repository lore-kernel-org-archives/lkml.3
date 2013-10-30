Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3J3V6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:58:21 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33636 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab3J3V6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:58:19 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/3] mm: memcg: lockdep annotation for memcg OOM lock
Date: Wed, 30 Oct 2013 17:55:26 -0400
Message-Id: <1383170127-32284-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383170127-32284-1-git-send-email-hannes@cmpxchg.org>
References: <1383170127-32284-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memcg OOM lock is a mutex-type lock that is open-coded due to
memcg's special needs.  Add annotations for lockdep coverage.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 13a9c80d5708..3e8cd0d9f716 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -54,6 +54,7 @@
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
+#include <linux/lockdep.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -2046,6 +2047,12 @@ static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
 	return total;
 }
 
+#ifdef CONFIG_LOCKDEP
+static struct lockdep_map memcg_oom_lock_dep_map = {
+	.name = "memcg_oom_lock",
+};
+#endif
+
 static DEFINE_SPINLOCK(memcg_oom_lock);
 
 /*
@@ -2083,7 +2090,8 @@ static bool mem_cgroup_oom_trylock(struct mem_cgroup *memcg)
 			}
 			iter->oom_lock = false;
 		}
-	}
+	} else
+		mutex_acquire(&memcg_oom_lock_dep_map, 0, 1, _RET_IP_);
 
 	spin_unlock(&memcg_oom_lock);
 
@@ -2095,6 +2103,7 @@ static void mem_cgroup_oom_unlock(struct mem_cgroup *memcg)
 	struct mem_cgroup *iter;
 
 	spin_lock(&memcg_oom_lock);
+	mutex_release(&memcg_oom_lock_dep_map, 1, _RET_IP_);
 	for_each_mem_cgroup_tree(iter, memcg)
 		iter->oom_lock = false;
 	spin_unlock(&memcg_oom_lock);
-- 
1.8.4.2

