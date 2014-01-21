Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaAUKqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:46:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbaAUKqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:46:16 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 2/2] memcg: fix css reference leak and endless loop in mem_cgroup_iter
Date: Tue, 21 Jan 2014 11:45:43 +0100
Message-Id: <1390301143-9541-2-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1390301143-9541-1-git-send-email-mhocko@suse.cz>
References: <20140121083454.GA1894@dhcp22.suse.cz>
 <1390301143-9541-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19f39402864e (memcg: simplify mem_cgroup_iter) has reorganized
mem_cgroup_iter code in order to simplify it. A part of that change was
dropping an optimization which didn't call css_tryget on the root of
the walked tree. The patch however didn't change the css_put part in
mem_cgroup_iter which excludes root.
This wasn't an issue at the time because __mem_cgroup_iter_next bailed
out for root early without taking a reference as cgroup iterators
(css_next_descendant_pre) didn't visit root themselves.

Nevertheless cgroup iterators have been reworked to visit root by
bd8815a6d802 (cgroup: make css_for_each_descendant() and friends include
the origin css in the iteration) when the root bypass have been dropped
in __mem_cgroup_iter_next. This means that css_put is not called for
root and so css along with mem_cgroup and other cgroup internal object
tied by css lifetime are never freed.

Fix the issue by reintroducing root check in __mem_cgroup_iter_next
and do not take css reference for it.

This reference counting magic protects us also from another issue, an
endless loop reported by Hugh Dickins when reclaim races with root
removal and css_tryget called by iterator internally would fail. There
would be no other nodes to visit so __mem_cgroup_iter_next would return
NULL and mem_cgroup_iter would interpret it as "start looping from root
again" and so mem_cgroup_iter would loop forever internally.

Cc: stable@vger.kernel.org # mem_leak part 3.12+
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 45786dc129dc..55bb1f8c6907 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1076,14 +1076,22 @@ skip_node:
 	 * skipped and we should continue the tree walk.
 	 * last_visited css is safe to use because it is
 	 * protected by css_get and the tree walk is rcu safe.
+	 *
+	 * We do not take a reference on the root of the tree walk
+	 * because we might race with the root removal when it would
+	 * be the only node in the iterated hierarchy and mem_cgroup_iter
+	 * would end up in an endless loop because it expects that at
+	 * least one valid node will be returned. Root cannot disappear
+	 * because caller of the iterator should hold it already so
+	 * skipping css reference should be safe.
 	 */
 	if (next_css) {
-		if ((next_css->flags & CSS_ONLINE) && css_tryget(next_css))
+		if ((next_css->flags & CSS_ONLINE) &&
+				(next_css == &root->css || css_tryget(next_css)))
 			return mem_cgroup_from_css(next_css);
-		else {
-			prev_css = next_css;
-			goto skip_node;
-		}
+
+		prev_css = next_css;
+		goto skip_node;
 	}
 
 	return NULL;
-- 
1.8.5.2

