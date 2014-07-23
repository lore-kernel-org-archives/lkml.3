Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbaGWLYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:24:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757643AbaGWLYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:24:19 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: [PATCH 1/2] mm: Avoid full RCU lookup of memcg for statistics updates
Date: Wed, 23 Jul 2014 12:24:15 +0100
Message-Id: <1406114656-16350-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406114656-16350-1-git-send-email-mgorman@suse.de>
References: <1406114656-16350-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When updating memcg VM statistics like PGFAULT we take the rcu read
lock and lookup the memcg. For statistic updates this is overkill
when the process may not belong to a memcg. This patch adds a light
check to check if a memcg potentially exists. It's race-prone in that
some VM stats may be missed when a process first joins a memcg but
that is not serious enough to justify a constant performance penalty.

The exact impact of this is difficult to quantify because it's timing
sensitive, workload sensitive and sensitive to the RCU options set. However,
broadly speaking there should be less interference due to page fault
activity in both the number of RCU grace periods and their age.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/memcontrol.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index eb65d29..76fa97d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -220,6 +220,14 @@ static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
 {
 	if (mem_cgroup_disabled())
 		return;
+	/*
+	 * For statistic updates it's overkill to take the RCU lock and do
+	 * a fully safe lookup of an associated memcg. Do a simple check
+	 * first. At worst, we miss a few stat updates when a process is
+	 * moved to a memcg for the first time.
+	 */
+	if (!rcu_access_pointer(mm->owner))
+		return;
 	__mem_cgroup_count_vm_event(mm, idx);
 }
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-- 
1.8.4.5

