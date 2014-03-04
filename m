Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbaCDUab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:30:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbaCDUFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 38/97] memcg: fix endless loop caused by mem_cgroup_iter
Date: Tue,  4 Mar 2014 12:03:51 -0800
Message-Id: <20140304200347.307435883@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit ecc736fc3c71c411a9d201d8588c9e7e049e5d8c upstream.

Hugh has reported an endless loop when the hardlimit reclaim sees the
same group all the time.  This might happen when the reclaim races with
the memcg removal.

shrink_zone
                                                [rmdir root]
  mem_cgroup_iter(root, NULL, reclaim)
    // prev = NULL
    rcu_read_lock()
    mem_cgroup_iter_load
      last_visited = iter->last_visited   // gets root || NULL
      css_tryget(last_visited)            // failed
      last_visited = NULL                 [1]
    memcg = root = __mem_cgroup_iter_next(root, NULL)
    mem_cgroup_iter_update
      iter->last_visited = root;
    reclaim->generation = iter->generation

 mem_cgroup_iter(root, root, reclaim)
   // prev = root
   rcu_read_lock
    mem_cgroup_iter_load
      last_visited = iter->last_visited   // gets root
      css_tryget(last_visited)            // failed
    [1]

The issue seemed to be introduced by commit 5f5781619718 ("memcg: relax
memcg iter caching") which has replaced unconditional css_get/css_put by
css_tryget/css_put for the cached iterator.

This patch fixes the issue by skipping css_tryget on the root of the
tree walk in mem_cgroup_iter_load and symmetrically doesn't release it
in mem_cgroup_iter_update.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1220,7 +1220,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			if (dead_count == iter->last_dead_count) {
 				smp_rmb();
 				last_visited = iter->last_visited;
-				if (last_visited &&
+				if (last_visited && last_visited != root &&
 				    !css_tryget(&last_visited->css))
 					last_visited = NULL;
 			}
@@ -1229,7 +1229,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		memcg = __mem_cgroup_iter_next(root, last_visited);
 
 		if (reclaim) {
-			if (last_visited)
+			if (last_visited && last_visited != root)
 				css_put(&last_visited->css);
 
 			iter->last_visited = memcg;


