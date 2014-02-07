Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaBGREf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:04:35 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:58549 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaBGREc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:04:32 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 1/8] mm: memcg: remove unnecessary preemption disabling
Date: Fri,  7 Feb 2014 12:04:18 -0500
Message-Id: <1391792665-21678-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
References: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_page_cgroup() disables preemption, remove explicit preemption
disabling for code paths holding this lock.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 53385cd4e6f0..befb3dd9d46c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -921,8 +921,6 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 					 struct page *page,
 					 bool anon, int nr_pages)
 {
-	preempt_disable();
-
 	/*
 	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
 	 * counted as CACHE even if it's on ANON LRU.
@@ -947,8 +945,6 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 	}
 
 	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
-
-	preempt_enable();
 }
 
 unsigned long
@@ -3780,17 +3776,14 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static inline
-void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
-					struct mem_cgroup *to,
-					unsigned int nr_pages,
-					enum mem_cgroup_stat_index idx)
+static void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
+					      struct mem_cgroup *to,
+					      unsigned int nr_pages,
+					      enum mem_cgroup_stat_index idx)
 {
 	/* Update stat data for mem_cgroup */
-	preempt_disable();
 	__this_cpu_sub(from->stat->count[idx], nr_pages);
 	__this_cpu_add(to->stat->count[idx], nr_pages);
-	preempt_enable();
 }
 
 /**
-- 
1.8.5.3

