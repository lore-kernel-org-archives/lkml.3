Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbaJWOby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:31:54 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42746 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbaJWObs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:31:48 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: memcontrol: uncharge pages on swapout fix
Date: Thu, 23 Oct 2014 10:31:40 -0400
Message-Id: <1414074700-13995-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladimir notes:

> > +   local_irq_disable();
> > +   mem_cgroup_charge_statistics(memcg, page, -1);
> > +   memcg_check_events(memcg, page);
> > +   local_irq_enable();
>
> AFAICT mem_cgroup_swapout() is called under mapping->tree_lock with irqs
> disabled, so we should use irq_save/restore here.

Simply remove the irq-disabling altogether and rely on the caller
holding the mapping->tree_lock for now.

Reported-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

For "mm: memcontrol: uncharge pages on swapout" in -mm.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae9b630e928b..09fece0eb9f1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5777,10 +5777,11 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, 1);
 
-	local_irq_disable();
+	/* XXX: caller holds IRQ-safe mapping->tree_lock */
+	VM_BUG_ON(!irqs_disabled());
+
 	mem_cgroup_charge_statistics(memcg, page, -1);
 	memcg_check_events(memcg, page);
-	local_irq_enable();
 }
 
 /**
-- 
2.1.2

