Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaBMB3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 20:29:55 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37419 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaBMB3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 20:29:53 -0500
Date: Wed, 12 Feb 2014 17:29:09 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] memcg: barriers to see memcgs as fully initialized
In-Reply-To: <alpine.LSU.2.11.1402121717420.5917@eggly.anvils>
Message-ID: <alpine.LSU.2.11.1402121727050.5917@eggly.anvils>
References: <alpine.LSU.2.11.1402121717420.5917@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d8ad30559715 ("mm/memcg: iteration skip memcgs not yet fully
initialized") is not bad, but Greg Thelen asks "Are barriers needed?"

Yes, I'm afraid so: this makes it a little heavier than the original,
but there's no point in guaranteeing that mem_cgroup_iter() returns only
fully initialized memcgs, if we don't guarantee that the initialization
is visible.

If we move online_css()'s setting CSS_ONLINE after rcu_assign_pointer()
(I don't see why not), we can reasonably rely on the smp_wmb() in that.
But I can't find a pre-existing barrier at the mem_cgroup_iter() end,
so add an smp_rmb() where __mem_cgroup_iter_next() returns non-NULL.

Fixes: d8ad30559715 ("mm/memcg: iteration skip memcgs not yet fully initialized")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org # 3.12+
---
I'd have been happier not to have to add this patch: maybe you can see
a better placement, or a way we can avoid this altogether.

 kernel/cgroup.c |    8 +++++++-
 mm/memcontrol.c |   11 +++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

--- 3.14-rc2+/kernel/cgroup.c	2014-02-02 18:49:07.737302111 -0800
+++ linux/kernel/cgroup.c	2014-02-12 11:59:52.804041895 -0800
@@ -4063,9 +4063,15 @@ static int online_css(struct cgroup_subs
 	if (ss->css_online)
 		ret = ss->css_online(css);
 	if (!ret) {
-		css->flags |= CSS_ONLINE;
 		css->cgroup->nr_css++;
 		rcu_assign_pointer(css->cgroup->subsys[ss->subsys_id], css);
+		/*
+		 * Set CSS_ONLINE after rcu_assign_pointer(), so that its
+		 * smp_wmb() will guarantee that those seeing CSS_ONLINE
+		 * can see the initialization done in ss->css_online() - if
+		 * they provide an smp_rmb(), as in __mem_cgroup_iter_next().
+		 */
+		css->flags |= CSS_ONLINE;
 	}
 	return ret;
 }
--- 3.14-rc2+/mm/memcontrol.c	2014-02-12 11:55:02.836035004 -0800
+++ linux/mm/memcontrol.c	2014-02-12 11:59:52.804041895 -0800
@@ -1128,9 +1128,16 @@ skip_node:
 	 */
 	if (next_css) {
 		if ((next_css == &root->css) ||
-		    ((next_css->flags & CSS_ONLINE) && css_tryget(next_css)))
+		    ((next_css->flags & CSS_ONLINE) && css_tryget(next_css))) {
+			/*
+			 * Ensure that all memcg initialization, done before
+			 * CSS_ONLINE was set, will be visible to our caller.
+			 * This matches the smp_wmb() in online_css()'s
+			 * rcu_assign_pointer(), before it set CSS_ONLINE.
+			 */
+			smp_rmb();
 			return mem_cgroup_from_css(next_css);
-
+		}
 		prev_css = next_css;
 		goto skip_node;
 	}
