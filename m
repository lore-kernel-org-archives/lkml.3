Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbbAZRCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:02:13 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:44236 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbbAZRCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:02:06 -0500
Date: Mon, 26 Jan 2015 12:02:02 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [GIT PULL] cgroup fixes for v3.19-rc6
Message-ID: <20150126170202.GC21242@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

The lifetime rules of cgroup hierarchies always have been somewhat
counter-intuitive and cgroup core tried to enforce that hierarchies
w/o userland-visible usages must die in finite amount of time so that
the controllers can be reused for other hierarchies; unfortunately,
this can't be implemented reasonably for the memory controller - the
kmemcg part doesn't have any way to forcefully drain the existing
usages, leading to an interruptible hang if a following mount attempts
to use the controller in any way.

So, it seems like we're stuck with "hierarchies live on till they die
whenever that may be" at least for now.  This pretty much confines
attaching controllers to hierarchies to before the hierarchies are
actively used by making dynamic configurations post active usages
unreliable.  This has never been reliable and should be fine in
practice given how cgroups are used.

After the patch, hierarchies aren't killed if it isn't already
drained.  A following mount attempt of the same mount options will
reuse the existing hierarchy.  Mount attempts with differing options
will fail w/ -EBUSY.

Thanks.

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.19-fixes

for you to fetch changes up to 3c606d35fe9766ede86a45273a628b320be13b45:

  cgroup: prevent mount hang due to memory controller lifetime (2015-01-22 10:26:43 -0500)

----------------------------------------------------------------
Johannes Weiner (1):
      cgroup: prevent mount hang due to memory controller lifetime

 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bb263d0..04cfe8a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1909,7 +1909,7 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 *
 	 * And don't kill the default root.
 	 */
-	if (css_has_online_children(&root->cgrp.self) ||
+	if (!list_empty(&root->cgrp.self.children) ||
 	    root == &cgrp_dfl_root)
 		cgroup_put(&root->cgrp);
 	else

-- 
tejun
