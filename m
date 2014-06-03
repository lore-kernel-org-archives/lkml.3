Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbaFCAv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:51:29 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:52825 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaFCAv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:51:28 -0400
Date: Mon, 2 Jun 2014 17:51:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: [patch v2] mm, memcg: periodically schedule when emptying page
 list
In-Reply-To: <alpine.DEB.2.02.1406021612550.6487@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1406021749590.13910@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406021612550.6487@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

mem_cgroup_force_empty_list() can iterate a large number of pages on an lru and 
mem_cgroup_move_parent() doesn't return an errno unless certain criteria, none 
of which indicate that the iteration may be taking too long, is met.

We have encountered the following stack trace many times indicating
"need_resched set for > 51000020 ns (51 ticks) without schedule", for example:

	scheduler_tick()
	<timer irq>
	mem_cgroup_move_account+0x4d/0x1d5
	mem_cgroup_move_parent+0x8d/0x109
	mem_cgroup_reparent_charges+0x149/0x2ba
	mem_cgroup_css_offline+0xeb/0x11b
	cgroup_offline_fn+0x68/0x16b
	process_one_work+0x129/0x350

If this iteration is taking too long, we still need to do cond_resched() even 
when an individual page is not busy.

[rientjes@google.com: changelog]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 v2: always reschedule if needed, "page" itself may not have a pc mismatch
     or been unable to isolate.

 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4784,9 +4784,9 @@ static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 		if (mem_cgroup_move_parent(page, pc, memcg)) {
 			/* found lock contention or "pc" is obsolete. */
 			busy = page;
-			cond_resched();
 		} else
 			busy = NULL;
+		cond_resched();
 	} while (!list_empty(list));
 }
 
