Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaEMQxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:53:25 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:57438 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaEMQxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:53:15 -0400
Date: Tue, 13 May 2014 12:53:06 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        Michal Hocko <mhocko@suse.cz>
Subject: [PATCH v2 03/14] memcg: update memcg_has_children() to use
 css_next_child()
Message-ID: <20140513165306.GE1866@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399671091-23867-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, memcg_has_children() and mem_cgroup_hierarchy_write()
directly test cgroup->children for list emptiness.  It's semantically
correct in traditional hierarchies as it actually wants to test for
any children dead or alive; however, cgroup->children is not a
published field and scheduled to go away.

This patch moves out .use_hierarchy test out of memcg_has_children()
and updates it to use css_next_child() to test whether there exists
any children.  With .use_hierarchy test moved out, it can also be used
by mem_cgroup_hierarchy_write().

A side note: As .use_hierarchy is going away, it doesn't really matter
but I'm not sure about how it's used in __memcg_activate_kmem().  The
condition tested by memcg_has_children() is mushy when seen from
userland as its result is affected by dead csses which aren't visible
from userland.  I think the rule would be a lot clearer if we have a
dedicated "freshly minted" flag which gets cleared when the first task
is migrated into it or the first child is created and then gate
activation with that.

v2: Added comment noting that testing use_hierarchy is the
    responsibility of the callers of memcg_has_children() as suggested
    by Michal Hocko.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4834,18 +4834,28 @@ static void mem_cgroup_reparent_charges(
 	} while (usage > 0);
 }
 
+/*
+ * Test whether @memcg has children, dead or alive.  Note that this
+ * function doesn't care whether @memcg has use_hierarchy enabled and
+ * returns %true if there are child csses according to the cgroup
+ * hierarchy.  Testing use_hierarchy is the caller's responsiblity.
+ */
 static inline bool memcg_has_children(struct mem_cgroup *memcg)
 {
-	lockdep_assert_held(&memcg_create_mutex);
+	bool ret;
+
 	/*
-	 * The lock does not prevent addition or deletion to the list
-	 * of children, but it prevents a new child from being
-	 * initialized based on this parent in css_online(), so it's
-	 * enough to decide whether hierarchically inherited
-	 * attributes can still be changed or not.
+	 * The lock does not prevent addition or deletion of children, but
+	 * it prevents a new child from being initialized based on this
+	 * parent in css_online(), so it's enough to decide whether
+	 * hierarchically inherited attributes can still be changed or not.
 	 */
-	return memcg->use_hierarchy &&
-		!list_empty(&memcg->css.cgroup->children);
+	lockdep_assert_held(&memcg_create_mutex);
+
+	rcu_read_lock();
+	ret = css_next_child(NULL, &memcg->css);
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
@@ -4920,7 +4930,7 @@ static int mem_cgroup_hierarchy_write(st
 	 */
 	if ((!parent_memcg || !parent_memcg->use_hierarchy) &&
 				(val == 1 || val == 0)) {
-		if (list_empty(&memcg->css.cgroup->children))
+		if (!memcg_has_children(memcg))
 			memcg->use_hierarchy = val;
 		else
 			retval = -EBUSY;
@@ -5037,7 +5047,8 @@ static int __memcg_activate_kmem(struct
 	 * of course permitted.
 	 */
 	mutex_lock(&memcg_create_mutex);
-	if (cgroup_has_tasks(memcg->css.cgroup) || memcg_has_children(memcg))
+	if (cgroup_has_tasks(memcg->css.cgroup) ||
+	    (memcg->use_hierarchy && memcg_has_children(memcg)))
 		err = -EBUSY;
 	mutex_unlock(&memcg_create_mutex);
 	if (err)
