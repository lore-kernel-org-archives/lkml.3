Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaBKVKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:10:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaBKTEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:04:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 017/120] memcg: fix css reference leak and endless loop in mem_cgroup_iter
Date: Tue, 11 Feb 2014 11:04:18 -0800
Message-Id: <20140211184824.023176184@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit 0eef615665ede1e0d603ea9ecca88c1da6f02234 upstream.

Commit 19f39402864e ("memcg: simplify mem_cgroup_iter") has reorganized
mem_cgroup_iter code in order to simplify it.  A part of that change was
dropping an optimization which didn't call css_tryget on the root of the
walked tree.  The patch however didn't change the css_put part in
mem_cgroup_iter which excludes root.

This wasn't an issue at the time because __mem_cgroup_iter_next bailed
out for root early without taking a reference as cgroup iterators
(css_next_descendant_pre) didn't visit root themselves.

Nevertheless cgroup iterators have been reworked to visit root by commit
bd8815a6d802 ("cgroup: make css_for_each_descendant() and friends
include the origin css in the iteration") when the root bypass have been
dropped in __mem_cgroup_iter_next.  This means that css_put is not
called for root and so css along with mem_cgroup and other cgroup
internal object tied by css lifetime are never freed.

Fix the issue by reintroducing root check in __mem_cgroup_iter_next and
do not take css reference for it.

This reference counting magic protects us also from another issue, an
endless loop reported by Hugh Dickins when reclaim races with root
removal and css_tryget called by iterator internally would fail.  There
would be no other nodes to visit so __mem_cgroup_iter_next would return
NULL and mem_cgroup_iter would interpret it as "start looping from root
again" and so mem_cgroup_iter would loop forever internally.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1098,14 +1098,22 @@ skip_node:
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


