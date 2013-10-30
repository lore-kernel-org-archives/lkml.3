Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3J3V6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:58:18 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33632 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab3J3V6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:58:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/3] mm: memcg: use proper memcg in limit bypass
Date: Wed, 30 Oct 2013 17:55:25 -0400
Message-Id: <1383170127-32284-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383170127-32284-1-git-send-email-hannes@cmpxchg.org>
References: <1383170127-32284-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

84235de ("fs: buffer: move allocation failure loop into the
allocator") allowed __GFP_NOFAIL allocations to bypass the limit if
they fail to reclaim enough memory for the charge.  Because the main
test case was on a 3.2-based system, this patch missed the fact that
on newer kernels the charge function needs to return root_mem_cgroup
when bypassing the limit, and not NULL.  This will corrupt whatever
memory is at NULL + percpu pointer offset.  Fix this quickly before
problems are reported.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 34d3ca9572d6..13a9c80d5708 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2765,10 +2765,10 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 	*ptr = memcg;
 	return 0;
 nomem:
-	*ptr = NULL;
-	if (gfp_mask & __GFP_NOFAIL)
-		return 0;
-	return -ENOMEM;
+	if (!(gfp_mask & __GFP_NOFAIL)) {
+		*ptr = NULL;
+		return -ENOMEM;
+	}
 bypass:
 	*ptr = root_mem_cgroup;
 	return -EINTR;
-- 
1.8.4.2

