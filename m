Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaIZF6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:58:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45458 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaIZF6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:58:30 -0400
Date: Fri, 26 Sep 2014 06:58:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "cgroup: remove redundant variable in
 cgroup_mount()"
Message-ID: <20140926055825.GO7996@ZenIV.linux.org.uk>
References: <1411704205-28995-1-git-send-email-lizefan@huawei.com>
 <20140926042617.GA14426@htj.dyndns.org>
 <20140926045352.GN7996@ZenIV.linux.org.uk>
 <20140926050457.GB14426@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926050457.GB14426@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 01:04:57AM -0400, Tejun Heo wrote:
> On Fri, Sep 26, 2014 at 05:53:52AM +0100, Al Viro wrote:
> > On Fri, Sep 26, 2014 at 12:26:17AM -0400, Tejun Heo wrote:
> > > On Fri, Sep 26, 2014 at 12:03:25PM +0800, Zefan Li wrote:
> > > > This reverts commit 0c7bf3e8cab7900e17ce7f97104c39927d835469.
> ...
> > > > Cc: Al Viro <viro@ZenIV.linux.org.uk>
> > > > Reported-by: Andrey Wagin <avagin@gmail.com>
> > > > Signed-off-by: Zefan Li <lizefan@huawei.com>
> > > 
> > > Applied to cgroup/for-3.18.
> > 
> > Er?  It's a clear regression since 3.16; shouldn't it go into mainline
> > before 3.17-final?  Another thing: AFAICS, if kernfs_fill_super() fails,
> 
> Hmmm?  This is reverting 0c7bf3e8cab7 which was committed six days ago
> to cgroup/for-3.18.

*blink*
Right you are, I forgot that the tree I'm currently in gets -next as one of
remotes, so seeing that commit there doesn't imply it being in mainline.
My apologies.  I plead going near-blind from digging through shitloads of
callchains leading to __d_move() and __d_rehash() since yesterday ;-/
Oh, well - looks like either I'll go completely insane or fs/dcache.c will
shrink quite a bit come next cycle...

> > you get unbalanced kernfs_put() on the cleanup path - kernfs_kill_sb()
> > will be called in those cases as well.  IOW, we'd better move that
> >         kernfs_get(info->root->kn);
> > in kernfs_fill_super() all way up to the point before kernfs_get_inode().
> > Something like this:
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> > diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> > index f973ae9..e5e92e3 100644
> > --- a/fs/kernfs/mount.c
> > +++ b/fs/kernfs/mount.c
> > @@ -74,6 +74,7 @@ static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
> >  	sb->s_magic = magic;
> >  	sb->s_op = &kernfs_sops;
> >  	sb->s_time_gran = 1;
> > +	kernfs_get(info->root->kn);
> >  
> >  	/* get root inode, initialize and unlock it */
> >  	mutex_lock(&kernfs_mutex);
> > @@ -90,7 +91,6 @@ static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
> >  		pr_debug("%s: could not get root dentry!\n", __func__);
> >  		return -ENOMEM;
> >  	}
> > -	kernfs_get(info->root->kn);
> 
> Ooh, right.  Will test & send the patch to Greg.

OK...  You'll need some way to force those failures to be able to test it -
they are normally triggered when you are very low on memory, i.e. the failure
exits won't trigger on normal testing (and near OOM you could easily fail
not reaching that point at all).

Normally I'm doing such testing by something like slapping
	if (!strcmp(current->comm, "bugger"))
		return -ENOMEM;
in there, followed by cp /bin/mount /tmp/bugger; /tmp/bugger -t cgroup <...>
Hell knows, maybe it would be worth to add a debugging option that would
check some sysctl and if it's non-zero, looked through the call chain in
kmem_cache_alloc() in search of such address, failing allocation if found.
Never got around to doing it properly, might or might not be useful...
