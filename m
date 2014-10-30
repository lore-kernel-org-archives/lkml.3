Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934525AbaJ3PcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:32:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932611AbaJ3PcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:32:01 -0400
Date: Thu, 30 Oct 2014 16:31:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, peterz@infradead.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: initialize variable for mem_cgroup_end_page_stat
Message-ID: <20141030153159.GA3639@dhcp22.suse.cz>
References: <1414633464-19419-1-git-send-email-sasha.levin@oracle.com>
 <20141030082712.GB4664@dhcp22.suse.cz>
 <54523DDE.9000904@oracle.com>
 <20141030141401.GA24520@phnom.home.cmpxchg.org>
 <54524A2F.5050907@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54524A2F.5050907@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 30-10-14 10:24:47, Sasha Levin wrote:
> On 10/30/2014 10:14 AM, Johannes Weiner wrote:
> >> The problem is that you are attempting to read 'locked' when you call
> >> > mem_cgroup_end_page_stat(), so it gets used even before you enter the
> >> > function - and using uninitialized variables is undefined.
> > We are not using that value anywhere if !memcg.  What path are you
> > referring to?
> 
> You're using that value as soon as you are passing it to a function, it
> doesn't matter what happens inside that function.

I have discussed that with our gcc guys and you are right. Strictly
speaking the compiler is free to do
if (!memcg) abort();
mem_cgroup_end_page_stat(...);

but it is highly unlikely that this will ever happen. Anyway better be
safe than sorry. I guess the following should be sufficient and even
more symmetric:
---
>From 6c3e748af7ee24984477e850bb93d65f83914903 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 30 Oct 2014 16:18:23 +0100
Subject: [PATCH] mm, memcg: fix potential undefined when for page stat
 accounting

since d7365e783edb (mm: memcontrol: fix missed end-writeback page
accounting) mem_cgroup_end_page_stat consumes locked and flags variables
directly rather than via pointers which might trigger C undefined
behavior as those variables are initialized only in the slow path of
mem_cgroup_begin_page_stat.
Although mem_cgroup_end_page_stat handles parameters correctly and
touches them only when they hold a sensible value it is caller which
loads a potentially uninitialized value which then might allow compiler
to do crazy things.

Fix this by using pointer parameters for both locked and flags. This is
even better from the API point of view because it is symmetrical to
mem_cgroup_begin_page_stat.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h | 6 +++---
 mm/memcontrol.c            | 8 ++++----
 mm/page-writeback.c        | 4 ++--
 mm/rmap.c                  | 4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d4575a1d6e99..de018766be45 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -141,8 +141,8 @@ static inline bool mem_cgroup_disabled(void)
 
 struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page, bool *locked,
 					      unsigned long *flags);
-void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
-			      unsigned long flags);
+void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool *locked,
+			      unsigned long *flags);
 void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
 				 enum mem_cgroup_stat_index idx, int val);
 
@@ -297,7 +297,7 @@ static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
 }
 
 static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg,
-					bool locked, unsigned long flags)
+					bool *locked, unsigned long *flags)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b841bf430179..031ca345677b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2053,11 +2053,11 @@ again:
  * @locked: value received from mem_cgroup_begin_page_stat()
  * @flags: value received from mem_cgroup_begin_page_stat()
  */
-void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
-			      unsigned long flags)
+void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool *locked,
+			      unsigned long *flags)
 {
-	if (memcg && locked)
-		spin_unlock_irqrestore(&memcg->move_lock, flags);
+	if (memcg && *locked)
+		spin_unlock_irqrestore(&memcg->move_lock, *flags);
 
 	rcu_read_unlock();
 }
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 19ceae87522d..d5d81f5384d1 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2357,7 +2357,7 @@ int test_clear_page_writeback(struct page *page)
 		dec_zone_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITTEN);
 	}
-	mem_cgroup_end_page_stat(memcg, locked, memcg_flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &memcg_flags);
 	return ret;
 }
 
@@ -2399,7 +2399,7 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITEBACK);
 	}
-	mem_cgroup_end_page_stat(memcg, locked, memcg_flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &memcg_flags);
 	return ret;
 
 }
diff --git a/mm/rmap.c b/mm/rmap.c
index 740dd7d15806..f782b6c2ae48 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1051,7 +1051,7 @@ void page_add_file_rmap(struct page *page)
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
 	}
-	mem_cgroup_end_page_stat(memcg, locked, flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &flags);
 }
 
 static void page_remove_file_rmap(struct page *page)
@@ -1081,7 +1081,7 @@ static void page_remove_file_rmap(struct page *page)
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
 out:
-	mem_cgroup_end_page_stat(memcg, locked, flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &flags);
 }
 
 /**
-- 
2.1.1

-- 
Michal Hocko
SUSE Labs
