Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3HAVyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:54:16 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:55353 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab3HAVu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:50:29 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/23] cgroup: always use cgroup_next_child() to walk the children list
Date: Thu,  1 Aug 2013 17:49:52 -0400
Message-Id: <1375393801-4817-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375393801-4817-1-git-send-email-tj@kernel.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several places where the children list is accessed directly.
This patch converts those places to use cgroup_next_child().  This
will help updating the hierarchy iterators to use @css instead of
@cgrp.

While cgroup_next_child() can be heavy in pathological cases - e.g. a
lot of dead children, this shouldn't cause any noticeable behavior
differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 5 ++---
 kernel/cgroup.c        | 7 +++----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a91c304..df6ab19 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -801,9 +801,8 @@ struct cgroup *cgroup_next_child(struct cgroup *pos, struct cgroup *cgrp);
  * the start of the next iteration by, for example, bumping the css refcnt.
  */
 #define cgroup_for_each_child(pos, cgrp)				\
-	for ((pos) = list_first_or_null_rcu(&(cgrp)->children,		\
-					    struct cgroup, sibling);	\
-	     (pos); (pos) = cgroup_next_child((pos), (cgrp)))
+	for ((pos) = cgroup_next_child(NULL, (cgrp)); (pos);		\
+	     (pos) = cgroup_next_child((pos), (cgrp)))
 
 struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
 					  struct cgroup *cgroup);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e88b50e..7b53b58 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3105,7 +3105,7 @@ struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
 		pos = cgroup;
 
 	/* visit the first child if exists */
-	next = list_first_or_null_rcu(&pos->children, struct cgroup, sibling);
+	next = cgroup_next_child(NULL, pos);
 	if (next)
 		return next;
 
@@ -3144,7 +3144,7 @@ struct cgroup *cgroup_rightmost_descendant(struct cgroup *pos)
 		last = pos;
 		/* ->prev isn't RCU safe, walk ->next till the end */
 		pos = NULL;
-		list_for_each_entry_rcu(tmp, &last->children, sibling)
+		cgroup_for_each_child(tmp, last)
 			pos = tmp;
 	} while (pos);
 
@@ -3158,8 +3158,7 @@ static struct cgroup *cgroup_leftmost_descendant(struct cgroup *pos)
 
 	do {
 		last = pos;
-		pos = list_first_or_null_rcu(&pos->children, struct cgroup,
-					     sibling);
+		pos = cgroup_next_child(NULL, pos);
 	} while (pos);
 
 	return last;
-- 
1.8.3.1

