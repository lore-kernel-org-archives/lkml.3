Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaKZWRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:17:36 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:41898 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaKZWRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:17:34 -0500
Date: Wed, 26 Nov 2014 14:17:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Qiang Huang <h.huangqiang@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, oom: remove gfp helper function
Message-ID: <alpine.DEB.2.10.1411261416480.13014@chino.kir.corp.google.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b9921ecdee66 ("mm: add a helper function to check may oom
condition") was added because the gfp criteria for oom killing was
checked in both the page allocator and memcg.

That was true for about nine months, but then commit 0029e19ebf84 ("mm:
memcontrol: remove explicit OOM parameter in charge path") removed the
memcg usecase.

Fold the implementation into its only caller.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/oom.h | 5 -----
 mm/page_alloc.c     | 2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -85,11 +85,6 @@ static inline void oom_killer_enable(void)
 	oom_killer_disabled = false;
 }
 
-static inline bool oom_gfp_allowed(gfp_t gfp_mask)
-{
-	return (gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY);
-}
-
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
 /* sysctls */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2706,7 +2706,7 @@ rebalance:
 	 * running out of options and have to consider going OOM
 	 */
 	if (!did_some_progress) {
-		if (oom_gfp_allowed(gfp_mask)) {
+		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
 			if (oom_killer_disabled)
 				goto nopage;
 			/* Coredumps can quickly deplete all memory reserves */
