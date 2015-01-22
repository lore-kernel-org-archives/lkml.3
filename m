Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbbAVNqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:46:08 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:48812 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbbAVNqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:46:06 -0500
Date: Thu, 22 Jan 2015 08:45:50 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>,
        Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [Regression] 3.19-rc3 : memcg: Hang in mount memcg
Message-ID: <20150122134550.GA13876@phnom.home.cmpxchg.org>
References: <54B01335.4060901@arm.com>
 <20150110085525.GD2110@esperanza>
 <54BCFDCF.9090603@arm.com>
 <20150121163955.GM4549@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121163955.GM4549@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 04:39:55PM +0000, Will Deacon wrote:
> On Mon, Jan 19, 2015 at 12:51:27PM +0000, Suzuki K. Poulose wrote:
> > On 10/01/15 08:55, Vladimir Davydov wrote:
> > > The problem is that the memory cgroup controller takes a css reference
> > > per each charged page and does not reparent charged pages on css
> > > offline, while cgroup_mount/cgroup_kill_sb expect all css references to
> > > offline cgroups to be gone soon, restarting the syscall if the ref count
> > > != 0. As a result, if you create a memory cgroup, charge some page cache
> > > to it, and then remove it, unmount/mount will hang forever.
> > >
> > > May be, we should kill the ref counter to the memory controller root in
> > > cgroup_kill_sb only if there is no children at all, neither online nor
> > > offline.
> > >
> > 
> > Still reproducible on 3.19-rc5 with the same setup.
> 
> Yeah, I'm seeing the same failure on my setup too.
> 
> > From git bisect, the last good commit is :
> > 
> > commit 8df0c2dcf61781d2efa8e6e5b06870f6c6785735
> > Author: Pranith Kumar <bobby.prani@gmail.com>
> > Date:   Wed Dec 10 15:42:28 2014 -0800
> > 
> >      slab: replace smp_read_barrier_depends() with lockless_dereference()
> 
> So that points at 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
> as the offending commit.

With b2052564e66d ("mm: memcontrol: continue cache reclaim from
offlined groups"), page cache can pin an old css and its ancestors
indefinitely, making that hang in a second mount() very likely.

However, swap entries have also been doing that for quite a while now,
and as Vladimir pointed out, the same is true for kernel memory.  This
latest change just makes this existing bug easier to trigger.

I think we have to update the lifetime rules to reflect reality here:
memory and swap lifetime is indefinite, so once the memory controller
is used, it has state that is independent from whether its mounted or
not.  We can support an identical remount, but have to fail mounting
with new parameters that would change the behavior of the controller.

Suzuki, Will, could you give the following patch a shot?

Tejun, would that route be acceptable to you?

Thanks

---
>From c5e88d02d185c52748df664aa30a2c5f8949b0f7 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 22 Jan 2015 08:16:31 -0500
Subject: [patch] kernel: cgroup: prevent mount hang due to memory controller
 lifetime

Since b2052564e66d ("mm: memcontrol: continue cache reclaim from
offlined groups"), re-mounting the memory controller after using it is
very likely to hang.

The cgroup core assumes that any remaining references after deleting a
cgroup are temporary in nature, and synchroneously waits for them, but
the above-mentioned commit has left-over page cache pin its css until
it is reclaimed naturally.  That being said, swap entries and charged
kernel memory have been doing the same indefinite pinning forever, the
bug is just more likely to trigger with left-over page cache.

Reparenting kernel memory is highly impractical, which leaves changing
the cgroup assumptions to reflect this: once a controller has been
mounted and used, it has internal state that is independent from mount
and cgroup lifetime.  It can be unmounted and remounted, but it can't
be reconfigured during subsequent mounts.

Don't offline the controller root as long as there are any children,
dead or alive.  A remount will no longer wait for these old references
to drain, it will simply mount the persistent controller state again.

Reported-by: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Reported-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/cgroup.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bb263d0caab3..9a09308c8066 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1819,8 +1819,11 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			goto out_unlock;
 		}
 
-		if (root->flags ^ opts.flags)
-			pr_warn("new mount options do not match the existing superblock, will be ignored\n");
+		if (root->flags ^ opts.flags) {
+			pr_warn("new mount options do not match the existing superblock\n");
+			ret = -EBUSY;
+			goto out_unlock;
+		}
 
 		/*
 		 * We want to reuse @root whose lifetime is governed by its
@@ -1909,7 +1912,7 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 *
 	 * And don't kill the default root.
 	 */
-	if (css_has_online_children(&root->cgrp.self) ||
+	if (!list_empty(&root->cgrp.self.children) ||
 	    root == &cgrp_dfl_root)
 		cgroup_put(&root->cgrp);
 	else
-- 
2.2.0

