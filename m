Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaANBw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:52:59 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63801 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaANBw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:52:56 -0500
Date: Mon, 13 Jan 2014 17:52:30 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mm/memcg: fix endless iteration in reclaim
In-Reply-To: <alpine.LSU.2.11.1401131742370.2229@eggly.anvils>
Message-ID: <alpine.LSU.2.11.1401131751080.2229@eggly.anvils>
References: <alpine.LSU.2.11.1401131742370.2229@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one home machine I can easily reproduce (by rmdir of memcgdir during
reclaim) multiple processes stuck looping forever in mem_cgroup_iter():
__mem_cgroup_iter_next() keeps selecting the memcg being destroyed, fails
to tryget it, returns NULL to mem_cgroup_iter(), which goes around again.

It's better to err on the side of leaving the loop too soon than never
when such races occur: once we've served prev (using root if none),
get out the next time __mem_cgroup_iter_next() cannot deliver.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
Securing the tree iterator against such races is difficult, I've
certainly got it wrong myself before.  Although the bug is real, and
deserves a Cc stable, you may want to play around with other solutions
before committing to this one.  The current iterator goes back to v3.12:
I'm really not sure if v3.11 was good or not - I never saw the problem
in the vanilla kernel, but with Google mods in we also had to make an
adjustment, there to stop __mem_cgroup_iter() being called endlessly
from the reclaim level.

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- mmotm/mm/memcontrol.c	2014-01-10 18:25:02.236448954 -0800
+++ linux/mm/memcontrol.c	2014-01-12 22:21:10.700570471 -0800
@@ -1254,8 +1252,11 @@ struct mem_cgroup *mem_cgroup_iter(struc
 				reclaim->generation = iter->generation;
 		}
 
-		if (prev && !memcg)
+		if (!memcg) {
+			if (!prev)
+				memcg = root;
 			goto out_unlock;
+		}
 	}
 out_unlock:
 	rcu_read_unlock();
