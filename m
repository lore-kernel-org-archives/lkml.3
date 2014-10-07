Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaJGXkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:40:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaJGXTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.16 05/26] mm: memcontrol: do not iterate uninitialized memcgs
Date: Tue,  7 Oct 2014 16:19:21 -0700
Message-Id: <20141007231848.652284739@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 2f7dd7a4100ad4affcb141605bef178ab98ccb18 upstream.

The cgroup iterators yield css objects that have not yet gone through
css_online(), but they are not complete memcgs at this point and so the
memcg iterators should not return them.  Commit d8ad30559715 ("mm/memcg:
iteration skip memcgs not yet fully initialized") set out to implement
exactly this, but it uses CSS_ONLINE, a cgroup-internal flag that does
not meet the ordering requirements for memcg, and so the iterator may
skip over initialized groups, or return partially initialized memcgs.

The cgroup core can not reasonably provide a clear answer on whether the
object around the css has been fully initialized, as that depends on
controller-specific locking and lifetime rules.  Thus, introduce a
memcg-specific flag that is set after the memcg has been initialized in
css_online(), and read before mem_cgroup_iter() callers access the memcg
members.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -292,6 +292,9 @@ struct mem_cgroup {
 	/* vmpressure notifications */
 	struct vmpressure vmpressure;
 
+	/* css_online() has been completed */
+	int initialized;
+
 	/*
 	 * the counter to account for mem+swap usage.
 	 */
@@ -1106,10 +1109,21 @@ skip_node:
 	 * skipping css reference should be safe.
 	 */
 	if (next_css) {
-		if ((next_css == &root->css) ||
-		    ((next_css->flags & CSS_ONLINE) &&
-		     css_tryget_online(next_css)))
-			return mem_cgroup_from_css(next_css);
+		struct mem_cgroup *memcg = mem_cgroup_from_css(next_css);
+
+		if (next_css == &root->css)
+			return memcg;
+
+		if (css_tryget_online(next_css)) {
+			/*
+			 * Make sure the memcg is initialized:
+			 * mem_cgroup_css_online() orders the the
+			 * initialization against setting the flag.
+			 */
+			if (smp_load_acquire(&memcg->initialized))
+				return memcg;
+			css_put(next_css);
+		}
 
 		prev_css = next_css;
 		goto skip_node;
@@ -6277,6 +6291,7 @@ mem_cgroup_css_online(struct cgroup_subs
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup *parent = mem_cgroup_from_css(css->parent);
+	int ret;
 
 	if (css->id > MEM_CGROUP_ID_MAX)
 		return -ENOSPC;
@@ -6313,7 +6328,18 @@ mem_cgroup_css_online(struct cgroup_subs
 	}
 	mutex_unlock(&memcg_create_mutex);
 
-	return memcg_init_kmem(memcg, &memory_cgrp_subsys);
+	ret = memcg_init_kmem(memcg, &memory_cgrp_subsys);
+	if (ret)
+		return ret;
+
+	/*
+	 * Make sure the memcg is initialized: mem_cgroup_iter()
+	 * orders reading memcg->initialized against its callers
+	 * reading the memcg members.
+	 */
+	smp_store_release(&memcg->initialized, 1);
+
+	return 0;
 }
 
 /*


