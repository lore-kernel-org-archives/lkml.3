Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaL2Py4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 10:54:56 -0500
Received: from mx2.parallels.com ([199.115.105.18]:35580 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaL2Pyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 10:54:55 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] memcg: fix destination cgroup leak on task charges migration
Date: Mon, 29 Dec 2014 18:54:43 +0300
Message-ID: <1419868483-30612-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are supposed to take one css reference per each memory page and per
each swap entry accounted to a memory cgroup. However, during task
charges migration we take a reference to the destination cgroup twice
per each swap entry: first in mem_cgroup_do_precharge()->try_charge()
and then in mem_cgroup_move_swap_account(), permanently leaking the
destination cgroup.

The hunk taking the second reference seems to be a leftover from the
pre-00501b531c472 ("mm: memcontrol: rewrite charge API") era. Remove it
to fix the leak.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ef91e856c7e4..d62c335dfef4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3043,18 +3043,6 @@ static int mem_cgroup_move_swap_account(swp_entry_t entry,
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
 		mem_cgroup_swap_statistics(from, false);
 		mem_cgroup_swap_statistics(to, true);
-		/*
-		 * This function is only called from task migration context now.
-		 * It postpones page_counter and refcount handling till the end
-		 * of task migration(mem_cgroup_clear_mc()) for performance
-		 * improvement. But we cannot postpone css_get(to)  because if
-		 * the process that has been moved to @to does swap-in, the
-		 * refcount of @to might be decreased to 0.
-		 *
-		 * We are in attach() phase, so the cgroup is guaranteed to be
-		 * alive, so we can just call css_get().
-		 */
-		css_get(&to->css);
 		return 0;
 	}
 	return -EINVAL;
-- 
1.7.10.4

