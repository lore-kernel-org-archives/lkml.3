Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaIYCrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:47:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41837 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaIYCrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:47:22 -0400
Date: Thu, 25 Sep 2014 03:47:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Andrey Wagin <avagin@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: linux-next: cgroup_mount() falls asleep forever
Message-ID: <20140925024719.GJ7996@ZenIV.linux.org.uk>
References: <CANaxB-ykM+5h4+x5hHK2Z_APpiQLvGvc=2nBR5pGQS=msqp6ZA@mail.gmail.com>
 <CANaxB-zqeJ0mse0J0=aH4uV+yRdgVhmHbAq4Wa8tW-81sNSMJA@mail.gmail.com>
 <20140924185213.GB7996@ZenIV.linux.org.uk>
 <20140924192456.GA1233@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924192456.GA1233@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:24:56PM -0400, Tejun Heo wrote:

> > Lovely...  First of all, that thing is obviously racy - there's nothing
> > to prevent another mount happening between these two places.  Moreover,
> > kernfs_mount() calling conventions are really atrocious - pointer to
> > bool just to indicate that superblock is new?
> > 
> > Could somebody explain WTF is the whole construction trying to do?  Not
> > to mention anything else, what *does* this pinning a superblock protect
> > from?  Suppose we have a superblock for the same root with non-NULL ns
> > and _that_ gets killed.  We get hit by the same
> > 	percpu_ref_kill(&root->cgrp.self.refcnt);
> > so what's the point of pinned_sb?  Might as well have just bumped the
> > refcount, superblock or no superblock.  And no, delaying that kernfs_kill_sb()
> > does you no good whatsoever - again, pinned_sb might have nothing to do with
> > the superblock we are after.
> 
> Yeah, it's an ugly thing to work around vfs interface not very
> conducive for filesystems which conditionally create or reuse
> superblocks during mount.  There was a thread explaining what's going
> on.  Looking up...
> 
>   http://thread.gmane.org/gmane.linux.kernel.containers/27623/focus=10635

Umm...  I still don't get it.  Could you describe the screnario in which
that percpu_ref_tryget_live() would be called and managed to fail?

It smells to me like most of the problems here are simply due to having too
many locks and not being able to decide where should they live relative to
->s_umount.  That cgroup_mutex thing feels like something way to coarse...
You have it grabbed/dropped in
	cgroup_destroy_root(), cgroup_remount(), cgroup_mount(),
	task_cgroup_path(), cgroup_attach_task_all(), cgroup_rename(),
	cgroup_rm_cftypes(), cgroup_add_cftypes(), cgroup_transfer_tasks(),
	cgroupstats_build(),
	css_release_work_fn() [async, queue_work()],
	css_killed_work_fn() [async, queue_work()],
	cgroup_init_subsys(), cgroup_init(), proc_cgroup_show(),
	proc_cgroupstats_show(), cgroup_release_agent(), __cgroup_procs_write(),
	cgroup_release_agent_write(), cgroup_subtree_control_write(),
	cgroup_mkdir(), cgroup_rmdir()
And that's a single system-wide mutex.  Plus there's a slew of workqueues
and really unpleasant abuse of restart_syscall() tossed in for fun - what
happens if some joker triggers that ->mount() _not_ from mount(2)?

Then there's a global rwsem nesting inside that sucker.  And there's another
mutex in fs/kernfs - also a global one.  Are the locking rules documented
anywhere?  Lifetime rules, as well...

Frankly, my first inclination here would be to try using sget() instead of
scanning the list of roots.  How painful would it be to split the allocation
and setup of roots, always allocate a new root and have sget() wait
for fs shutdown in progress and decide whether it wants to reuse the existing
one.  You can easily tell reuse existing vs. set up a new one from each other -
just look at the root associated with the superblock you've got and check
if it's the one you've allocated.  Freeing the damn thing if we'd reused
an existing one and doing setup otherwise.

I realize that it won't do in such form; your for_each_subsys() loop in there
really depends on holding cgroup_mutex all the way through.  But do we really
need it there?  Would just skipping the ones that doomed in rebind_subsystems()
suffice?

Just looking at the size of the damn thing is depressing, TBH - it's quite
a bit bigger than *anything* in fs/*.c.  And callers are all over the tree ;-/
