Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaBDN31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:29:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526AbaBDN3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:29:13 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH -v2 3/6] memcg: mm == NULL is not allowed for mem_cgroup_try_charge_mm
Date: Tue,  4 Feb 2014 14:28:57 +0100
Message-Id: <1391520540-17436-4-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.9.rc1
In-Reply-To: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
References: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This patch replaces the check by VM_BUG_ON to make it obvious that we
really expect non-NULL mm_struct.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 72fbe0fb3320..2fcdee529ad3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2782,14 +2782,7 @@ static struct mem_cgroup *mem_cgroup_try_charge_mm(struct mm_struct *mm,
 	struct mem_cgroup *memcg;
 	int ret;
 
-	/*
-	 * We always charge the cgroup the mm_struct belongs to.
-	 * The mm_struct's mem_cgroup changes on task migration if the
-	 * thread group leader migrates. It's possible that mm is not
-	 * set, if so charge the root memcg (happens for pagecache usage).
-	 */
-	if (!mm)
-		goto bypass;
+	VM_BUG_ON(!mm);
 	memcg = try_get_mem_cgroup_from_mm(mm);
 	if (!memcg)
 		goto bypass;
-- 
1.9.rc1

