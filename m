Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaBGRGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:06:06 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:58558 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaBGREh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:04:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 4/8] memcg: !memcg && !mm is not allowed for __mem_cgroup_try_charge
Date: Fri,  7 Feb 2014 12:04:21 -0500
Message-Id: <1391792665-21678-5-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
References: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

An ancient comment tries to explain that a given mm might be NULL when a
task is migrated. It has been introduced by 8a9f3ccd (Memory controller:
memory accounting) along with other bigger changes so it is not much
more specific about the conditions.

Anyway, Even if the task is migrated to another memcg there is no way we
can see NULL mm struct. So either this was not correct from the very
beginning or it is not true anymore.
The only remaining case would be seeing charges after exit_mm but that
would be a bug on its own as the task doesn't have an address space
anymore.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b8a96c7d1167..e1d7f33227e4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2737,15 +2737,6 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;
-
-	/*
-	 * We always charge the cgroup the mm_struct belongs to.
-	 * The mm_struct's mem_cgroup changes on task migration if the
-	 * thread group leader migrates. It's possible that mm is not
-	 * set, if so charge the root memcg (happens for pagecache usage).
-	 */
-	if (!*ptr && !mm)
-		*ptr = root_mem_cgroup;
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
-- 
1.8.5.3

