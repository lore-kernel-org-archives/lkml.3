Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3H2Pml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:42:41 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:61147 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3H2Pmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:42:38 -0400
Date: Thu, 29 Aug 2013 11:42:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH cgroup/for-3.11-fixes] cgroup: fix rmdir EBUSY regression in
 3.11
Message-ID: <20130829154234.GA23531@htj.dyndns.org>
References: <alpine.LNX.2.00.1308281624430.1266@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1308281624430.1266@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hugh.

Oops, sorry about that.  I massaged the patch a bit and applied it to
cgroup/for-3.11-fixes.  Will send pull request to Linus right away.

Thanks.
------ 8< ------
>From bb78a92f47696b2da49f2692b6a9fa56d07c444a Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Wed, 28 Aug 2013 16:31:23 -0700

On 3.11-rc we are seeing cgroup directories left behind when they should
have been removed.  Here's a trivial reproducer:

cd /sys/fs/cgroup/memory
mkdir parent parent/child; rmdir parent/child parent
rmdir: failed to remove `parent': Device or resource busy

It's because cgroup_destroy_locked() (step 1 of destruction) leaves
cgroup on parent's children list, letting cgroup_offline_fn() (step 2 of
destruction) remove it; but step 2 is run by work queue, which may not
yet have removed the children when parent destruction checks the list.

Fix that by checking through a non-empty list of children: if every one
of them has already been marked CGRP_DEAD, then it's safe to proceed:
those children are invisible to userspace, and should not obstruct rmdir.

(I didn't see any reason to keep the cgrp->children checks under the
unrelated css_set_lock, so moved them out.)

tj: Flattened nested ifs a bit and updated comment so that it's
    correct on both for-3.11-fixes and for-3.12.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 781845a..e919633 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4480,6 +4480,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	struct dentry *d = cgrp->dentry;
 	struct cgroup_event *event, *tmp;
 	struct cgroup_subsys *ss;
+	struct cgroup *child;
 	bool empty;
 
 	lockdep_assert_held(&d->d_inode->i_mutex);
@@ -4490,12 +4491,28 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * @cgrp from being removed while __put_css_set() is in progress.
 	 */
 	read_lock(&css_set_lock);
-	empty = list_empty(&cgrp->cset_links) && list_empty(&cgrp->children);
+	empty = list_empty(&cgrp->cset_links);
 	read_unlock(&css_set_lock);
 	if (!empty)
 		return -EBUSY;
 
 	/*
+	 * Make sure there's no live children.  We can't test ->children
+	 * emptiness as dead children linger on it while being destroyed;
+	 * otherwise, "rmdir parent/child parent" may fail with -EBUSY.
+	 */
+	empty = true;
+	rcu_read_lock();
+	list_for_each_entry_rcu(child, &cgrp->children, sibling) {
+		empty = cgroup_is_dead(child);
+		if (!empty)
+			break;
+	}
+	rcu_read_unlock();
+	if (!empty)
+		return -EBUSY;
+
+	/*
 	 * Block new css_tryget() by killing css refcnts.  cgroup core
 	 * guarantees that, by the time ->css_offline() is invoked, no new
 	 * css reference will be given out via css_tryget().  We can't
-- 
1.8.3.1

