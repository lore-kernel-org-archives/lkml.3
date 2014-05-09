Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbaEIVNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:13:49 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:36816 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754AbaEIVNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:13:46 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/9] cgroup: move cgroup->sibling unlinking to cgroup_put()
Date: Fri,  9 May 2014 17:13:31 -0400
Message-Id: <1399670015-23463-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move cgroup->sibling unlinking from cgroup_destroy_css_killed() to
cgroup_put().  This is later but still before the RCU grace period, so
it doesn't break css_next_child() although there now is a larger
window in which a dead cgroup is visible during css iteration.  As css
iteration always could have included offline csses, this doesn't
affect correctness; however, it does make css_next_child() fall back
to reiterting mode more often.  This also makes cgroup_put() directly
take cgroup_mutex, which limits where it can be called from.  These
are not immediately problematic and will be dealt with later.

This change enables simplification of cgroup destruction path.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 45149b7..87ea2ce 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1056,6 +1056,11 @@ static void cgroup_put(struct cgroup *cgrp)
 	if (WARN_ON_ONCE(cgrp->parent && !cgroup_is_dead(cgrp)))
 		return;
 
+	/* delete this cgroup from parent->children */
+	mutex_lock(&cgroup_mutex);
+	list_del_rcu(&cgrp->sibling);
+	mutex_unlock(&cgroup_mutex);
+
 	cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 	cgrp->id = -1;
 
@@ -4560,9 +4565,6 @@ static void cgroup_destroy_css_killed(struct cgroup *cgrp)
 {
 	lockdep_assert_held(&cgroup_mutex);
 
-	/* delete this cgroup from parent->children */
-	list_del_rcu(&cgrp->sibling);
-
 	cgroup_put(cgrp);
 }
 
-- 
1.9.0

