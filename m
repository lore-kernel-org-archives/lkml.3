Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3H2PxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:53:14 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38576 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3H2PxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:53:12 -0400
Date: Thu, 29 Aug 2013 11:53:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v3.11-rc7
Message-ID: <20130829155308.GB23531@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

During percpu reference counting update which was merged during
v3.11-rc1, cgroup destruction path was updated so that a cgroup in the
process of dying may linger on the children list, which was necessary
as the cgroup should still be included in child/descendant iteration
while percpu ref is being killed.  Unfortunately, I forgot to update
cgroup destruction path accordingly and cgroup destruction may fail
spuriously with -EBUSY due to lingering dying children even when
there's no live child left - e.g. "rmdir parent/child parent" will
usually fail.

This can be easily fixed by iterating through the children list to
verify that there's no live child left.  While this is very late in
the release cycle, this bug is very visible to userland and I believe
the fix is relatively safe.

Thanks Hugh for spotting and providing fix for the issue.

The following changes since commit c95389b4cd6a4b52af78bea706a274453e886251:

  Merge branch 'akpm' (patches from Andrew Morton) (2013-08-28 19:31:33 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.11-fixes

for you to fetch changes up to bb78a92f47696b2da49f2692b6a9fa56d07c444a:

  cgroup: fix rmdir EBUSY regression in 3.11 (2013-08-29 11:05:07 -0400)

----------------------------------------------------------------
Hugh Dickins (1):
      cgroup: fix rmdir EBUSY regression in 3.11

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
