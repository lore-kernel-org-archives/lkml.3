Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaJTS7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:59:49 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43921 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaJTS7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:59:47 -0400
Date: Mon, 20 Oct 2014 20:59:44 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: micro-optimize
 mem_cgroup_update_page_stat()
Message-ID: <20141020185944.GC505@dhcp22.suse.cz>
References: <1413818259-10913-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413818259-10913-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-10-14 11:17:39, Johannes Weiner wrote:
> Do not look up the page_cgroup when the memory controller is
> runtime-disabled, but do assert that the locking protocol is followed
> under DEBUG_VM regardless.  Also remove the unused flags variable.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

mem_cgroup_split_huge_fixup is following the same pattern and might be
folded into this one. I can send a separate patch if you prefer, though.
---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3a203c7ec6c7..544e32292c7f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3167,7 +3167,7 @@ static inline void memcg_unregister_all_caches(struct mem_cgroup *memcg)
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
-	struct page_cgroup *head_pc = lookup_page_cgroup(head);
+	struct page_cgroup *head_pc;
 	struct page_cgroup *pc;
 	struct mem_cgroup *memcg;
 	int i;
@@ -3175,6 +3175,8 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 	if (mem_cgroup_disabled())
 		return;
 
+	head_pc = lookup_page_cgroup(head);
+
 	memcg = head_pc->mem_cgroup;
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		pc = head_pc + i;
-- 
Michal Hocko
SUSE Labs
