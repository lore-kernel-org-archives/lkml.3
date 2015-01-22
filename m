Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbbAVPTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:19:55 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:48826 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbbAVPTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:19:53 -0500
Date: Thu, 22 Jan 2015 10:19:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tejun Heo <tj@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [Regression] 3.19-rc3 : memcg: Hang in mount memcg
Message-ID: <20150122151943.GA27368@phnom.home.cmpxchg.org>
References: <54B01335.4060901@arm.com>
 <20150110085525.GD2110@esperanza>
 <54BCFDCF.9090603@arm.com>
 <20150121163955.GM4549@arm.com>
 <20150122134550.GA13876@phnom.home.cmpxchg.org>
 <20150122143454.GA4507@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122143454.GA4507@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 22, 2015 at 09:34:54AM -0500, Tejun Heo wrote:
> On Thu, Jan 22, 2015 at 08:45:50AM -0500, Johannes Weiner wrote:
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index bb263d0caab3..9a09308c8066 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -1819,8 +1819,11 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
> >  			goto out_unlock;
> >  		}
> >  
> > -		if (root->flags ^ opts.flags)
> > -			pr_warn("new mount options do not match the existing superblock, will be ignored\n");
> > +		if (root->flags ^ opts.flags) {
> > +			pr_warn("new mount options do not match the existing superblock\n");
> > +			ret = -EBUSY;
> > +			goto out_unlock;
> > +		}
> 
> Do we really need the above chunk?

Inform and ignore or fail hard?  I guess we can drop this hunk and
keep with the current behavior.

> > @@ -1909,7 +1912,7 @@ static void cgroup_kill_sb(struct super_block *sb)
> >  	 *
> >  	 * And don't kill the default root.
> >  	 */
> > -	if (css_has_online_children(&root->cgrp.self) ||
> > +	if (!list_empty(&root->cgrp.self.children) ||
> >  	    root == &cgrp_dfl_root)
> >  		cgroup_put(&root->cgrp);
> 
> I tried to do something a bit more advanced so that eventual async
> release of dying children, if they happen, can also release the
> hierarchy but I don't think it really matters unless we can forcefully
> drain.  So, shouldn't just the above part be enough?

Yep, I'd be fine with that.

---

>From 3d7ae5aeb16ce6118d8bff17194e791339a1f06c Mon Sep 17 00:00:00 2001
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
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bb263d0caab3..04cfe8ace520 100644
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
2.2.0
