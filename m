Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab3JXJ6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:58:22 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60353 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab3JXJ6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:58:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/2] mm: memcg: use proper memcg in limit bypass
Date: Thu, 24 Oct 2013 05:58:14 -0400
Message-Id: <1382608695-24561-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.4.1
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
index 34d3ca9..13a9c80 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2765,10 +2765,10 @@ done:
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
1.8.4.1

