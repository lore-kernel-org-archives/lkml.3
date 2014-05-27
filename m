Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaE0VhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:37:22 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50012 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaE0VhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:37:21 -0400
Date: Tue, 27 May 2014 14:36:04 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH mmotm/next] memcg-mm-introduce-lowlimit-reclaim-fix2.patch
Message-ID: <alpine.LSU.2.11.1405271432400.4485@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_within_guarantee() oopses in _raw_spin_lock_irqsave() when
booted with cgroup_disable=memory.  Fix that in the obvious inelegant
way for now - though I hope we are moving towards a world in which
almost all of the mem_cgroup_disabled() tests will vanish, with a
root_mem_cgroup which can handle the basics even when disabled.

I bet there's a neater way of doing this, rearranging the loop (and we
shall want to avoid spinlocking on root_mem_cgroup when we reach that
new world), but that's the kind of thing I'd get wrong in a hurry!

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

--- mmotm/mm/memcontrol.c	2014-05-21 18:12:18.072022438 -0700
+++ linux/mm/memcontrol.c	2014-05-21 19:34:30.608546905 -0700
@@ -2793,6 +2793,9 @@ static struct mem_cgroup *mem_cgroup_loo
 bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 		struct mem_cgroup *root)
 {
+	if (mem_cgroup_disabled())
+		return false;
+
 	do {
 		if (!res_counter_low_limit_excess(&memcg->res))
 			return true;
