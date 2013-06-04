Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab3FDRCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:02:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48518 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3FDRCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:02:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 62/75] cgroup: fix a subtle bug in descendant pre-order walk
Date: Tue,  4 Jun 2013 09:55:46 -0700
Message-Id: <1370364959-9475-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 7805d000db30a3787a4c969bab6ae4d8a5fd8ce6 upstream.

When cgroup_next_descendant_pre() initiates a walk, it checks whether
the subtree root doesn't have any children and if not returns NULL.
Later code assumes that the subtree isn't empty.  This is broken
because the subtree may become empty inbetween, which can lead to the
traversal escaping the subtree by walking to the sibling of the
subtree root.

There's no reason to have the early exit path.  Remove it along with
the later assumption that the subtree isn't empty.  This simplifies
the code a bit and fixes the subtle bug.

While at it, fix the comment of cgroup_for_each_descendant_pre() which
was incorrectly referring to ->css_offline() instead of
->css_online().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/cgroup.h | 2 +-
 kernel/cgroup.c        | 9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2322df7..f9e42de 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -568,7 +568,7 @@ struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
  *
  * If a subsystem synchronizes against the parent in its ->css_online() and
  * before starting iterating, and synchronizes against @pos on each
- * iteration, any descendant cgroup which finished ->css_offline() is
+ * iteration, any descendant cgroup which finished ->css_online() is
  * guaranteed to be visible in the future iterations.
  *
  * In other words, the following guarantees that a descendant can't escape
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index cddf1d9..02ddadb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3001,11 +3001,8 @@ struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	/* if first iteration, pretend we just visited @cgroup */
-	if (!pos) {
-		if (list_empty(&cgroup->children))
-			return NULL;
+	if (!pos)
 		pos = cgroup;
-	}
 
 	/* visit the first child if exists */
 	next = list_first_or_null_rcu(&pos->children, struct cgroup, sibling);
@@ -3013,14 +3010,14 @@ struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
 		return next;
 
 	/* no child, visit my or the closest ancestor's next sibling */
-	do {
+	while (pos != cgroup) {
 		next = list_entry_rcu(pos->sibling.next, struct cgroup,
 				      sibling);
 		if (&next->sibling != &pos->parent->children)
 			return next;
 
 		pos = pos->parent;
-	} while (pos != cgroup);
+	}
 
 	return NULL;
 }
-- 
1.8.1.2

