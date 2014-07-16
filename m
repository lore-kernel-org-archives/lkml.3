Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030403AbaGPG4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:56:25 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34948 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030381AbaGPG4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:56:23 -0400
X-Sasl-enc: S7DW0CruS/BWWSezMaVT1SrXcb6kNNTfJgzk8zNGw1w8 1405493780
Message-ID: <1405493777.2527.72.camel@perseus.fritz.box>
Subject: Re: [PATCH 3/6] autofs4: allow RCU-walk to walk through autofs4.
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Jul 2014 14:56:17 +0800
In-Reply-To: <20140716155150.044c2ea3@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	 <20140709234114.4525.46882.stgit@notabene.brown>
	 <1405485857.2527.38.camel@perseus.fritz.box>
	 <20140716155150.044c2ea3@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 15:51 +1000, NeilBrown wrote:
> On Wed, 16 Jul 2014 12:44:17 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > On Thu, 2014-07-10 at 09:41 +1000, NeilBrown wrote:
> > > Any attempt to look up a pathname that passes though an
> > > autofs4 mount is currently forced out of RCU-walk into
> > > REF-walk.
> > > 
> > > This can significantly hurt performance of many-thread work
> > > loads on many-core systems, especially if the automounted
> > > filesystem supports RCU-walk but doesn't get to benefit from
> > > it.
> > > 
> > > So if autofs4_d_manage is called with rcu_walk set, only
> > > fail with -ECHILD if it is necessary to wait longer than
> > > a spinlock, and avoid even the spinlock in one trivial case.
> > 
> > I've looked more closely at this one now and mostly it looks good to me.
> > 
> > But I'm probably a bit slow, there's just one place where I can't work
> > out the reasoning ....
> > 
> > > 
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > ---
> > >  fs/autofs4/autofs_i.h  |    2 +-
> > >  fs/autofs4/dev-ioctl.c |    2 +-
> > >  fs/autofs4/expire.c    |    4 +++-
> > >  fs/autofs4/root.c      |   44 +++++++++++++++++++++++++++++---------------
> > >  4 files changed, 34 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
> > > index 22a280151e45..99dbb05d6148 100644
> > > --- a/fs/autofs4/autofs_i.h
> > > +++ b/fs/autofs4/autofs_i.h
> > > @@ -148,7 +148,7 @@ void autofs4_free_ino(struct autofs_info *);
> > >  
> > >  /* Expiration */
> > >  int is_autofs4_dentry(struct dentry *);
> > > -int autofs4_expire_wait(struct dentry *dentry);
> > > +int autofs4_expire_wait(struct dentry *dentry, int rcu_walk);
> > >  int autofs4_expire_run(struct super_block *, struct vfsmount *,
> > >  			struct autofs_sb_info *,
> > >  			struct autofs_packet_expire __user *);
> > > diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> > > index 5b570b6efa28..aaf96cb25452 100644
> > > --- a/fs/autofs4/dev-ioctl.c
> > > +++ b/fs/autofs4/dev-ioctl.c
> > > @@ -450,7 +450,7 @@ static int autofs_dev_ioctl_requester(struct file *fp,
> > >  	ino = autofs4_dentry_ino(path.dentry);
> > >  	if (ino) {
> > >  		err = 0;
> > > -		autofs4_expire_wait(path.dentry);
> > > +		autofs4_expire_wait(path.dentry, 0);
> > >  		spin_lock(&sbi->fs_lock);
> > >  		param->requester.uid = from_kuid_munged(current_user_ns(), ino->uid);
> > >  		param->requester.gid = from_kgid_munged(current_user_ns(), ino->gid);
> > > diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
> > > index a7be57e39be7..7e2f22ce6954 100644
> > > --- a/fs/autofs4/expire.c
> > > +++ b/fs/autofs4/expire.c
> > > @@ -467,7 +467,7 @@ found:
> > >  	return expired;
> > >  }
> > >  
> > > -int autofs4_expire_wait(struct dentry *dentry)
> > > +int autofs4_expire_wait(struct dentry *dentry, int rcu_walk)
> > >  {
> > >  	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
> > >  	struct autofs_info *ino = autofs4_dentry_ino(dentry);
> > > @@ -477,6 +477,8 @@ int autofs4_expire_wait(struct dentry *dentry)
> > >  	spin_lock(&sbi->fs_lock);
> > >  	if (ino->flags & AUTOFS_INF_EXPIRING) {
> > >  		spin_unlock(&sbi->fs_lock);
> > > +		if (rcu_walk)
> > > +			return -ECHILD;
> > >  
> > >  		DPRINTK("waiting for expire %p name=%.*s",
> > >  			 dentry, dentry->d_name.len, dentry->d_name.name);
> > > diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> > > index cc87c1abac97..1ad119407e2f 100644
> > > --- a/fs/autofs4/root.c
> > > +++ b/fs/autofs4/root.c
> > > @@ -208,7 +208,8 @@ next:
> > >  	return NULL;
> > >  }
> > >  
> > > -static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
> > > +static struct dentry *autofs4_lookup_expiring(struct dentry *dentry,
> > > +					      bool rcu_walk)
> > >  {
> > >  	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
> > >  	struct dentry *parent = dentry->d_parent;
> > > @@ -225,6 +226,11 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
> > >  		struct dentry *expiring;
> > >  		struct qstr *qstr;
> > >  
> > > +		if (rcu_walk) {
> > > +			spin_unlock(&sbi->lookup_lock);
> > > +			return ERR_PTR(-ECHILD);
> > > +		}
> > > +
> > >  		ino = list_entry(p, struct autofs_info, expiring);
> > >  		expiring = ino->dentry;
> > >  
> > > @@ -260,13 +266,15 @@ next:
> > >  	return NULL;
> > >  }
> > >  
> > > -static int autofs4_mount_wait(struct dentry *dentry)
> > > +static int autofs4_mount_wait(struct dentry *dentry, bool rcu_walk)
> > >  {
> > >  	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
> > >  	struct autofs_info *ino = autofs4_dentry_ino(dentry);
> > >  	int status = 0;
> > >  
> > >  	if (ino->flags & AUTOFS_INF_PENDING) {
> > > +		if (rcu_walk)
> > > +			return -ECHILD;
> > >  		DPRINTK("waiting for mount name=%.*s",
> > >  			dentry->d_name.len, dentry->d_name.name);
> > >  		status = autofs4_wait(sbi, dentry, NFY_MOUNT);
> > > @@ -276,20 +284,22 @@ static int autofs4_mount_wait(struct dentry *dentry)
> > >  	return status;
> > >  }
> > >  
> > > -static int do_expire_wait(struct dentry *dentry)
> > > +static int do_expire_wait(struct dentry *dentry, bool rcu_walk)
> > >  {
> > >  	struct dentry *expiring;
> > >  
> > > -	expiring = autofs4_lookup_expiring(dentry);
> > > +	expiring = autofs4_lookup_expiring(dentry, rcu_walk);
> > > +	if (IS_ERR(expiring))
> > > +		return PTR_ERR(expiring);
> > >  	if (!expiring)
> > > -		return autofs4_expire_wait(dentry);
> > > +		return autofs4_expire_wait(dentry, rcu_walk);
> > >  	else {
> > >  		/*
> > >  		 * If we are racing with expire the request might not
> > >  		 * be quite complete, but the directory has been removed
> > >  		 * so it must have been successful, just wait for it.
> > >  		 */
> > > -		autofs4_expire_wait(expiring);
> > > +		autofs4_expire_wait(expiring, 0);
> > >  		autofs4_del_expiring(expiring);
> > >  		dput(expiring);
> > >  	}
> > > @@ -341,7 +351,7 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
> > >  	 * and the directory was removed, so just go ahead and try
> > >  	 * the mount.
> > >  	 */
> > > -	status = do_expire_wait(dentry);
> > > +	status = do_expire_wait(dentry, 0);
> > >  	if (status && status != -EAGAIN)
> > >  		return NULL;
> > >  
> > > @@ -349,7 +359,7 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
> > >  	spin_lock(&sbi->fs_lock);
> > >  	if (ino->flags & AUTOFS_INF_PENDING) {
> > >  		spin_unlock(&sbi->fs_lock);
> > > -		status = autofs4_mount_wait(dentry);
> > > +		status = autofs4_mount_wait(dentry, 0);
> > >  		if (status)
> > >  			return ERR_PTR(status);
> > >  		goto done;
> > > @@ -390,7 +400,7 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
> > >  		}
> > >  		ino->flags |= AUTOFS_INF_PENDING;
> > >  		spin_unlock(&sbi->fs_lock);
> > > -		status = autofs4_mount_wait(dentry);
> > > +		status = autofs4_mount_wait(dentry, 0);
> > >  		spin_lock(&sbi->fs_lock);
> > >  		ino->flags &= ~AUTOFS_INF_PENDING;
> > >  		if (status) {
> > > @@ -426,21 +436,25 @@ static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
> > >  		return 0;
> > >  	}
> > >  
> > > -	/* We need to sleep, so we need pathwalk to be in ref-mode */
> > > -	if (rcu_walk)
> > > -		return -ECHILD;
> > > -
> > >  	/* Wait for pending expires */
> > > -	do_expire_wait(dentry);
> > > +	if (do_expire_wait(dentry, rcu_walk) == -ECHILD)
> > > +		return -ECHILD;
> > >  
> > >  	/*
> > >  	 * This dentry may be under construction so wait on mount
> > >  	 * completion.
> > >  	 */
> > > -	status = autofs4_mount_wait(dentry);
> > > +	status = autofs4_mount_wait(dentry, rcu_walk);
> > >  	if (status)
> > >  		return status;
> > >  
> > > +	if (rcu_walk)
> > > +		/* No need to consider returning -EISDIR as
> > > +		 * there is no risk that ->d_automount will
> > > +		 * be called
> > > +		 */
> > > +		return status;
> > > +
> > 
> > This bit here.
> > 
> > The test below says (accepting that d_mountpoint() is unreliable in a
> > multi-namespace environment and needs to be fixed), if this dentry isn't
> > being expired and it's not a mount and the directory isn't empty then we
> > can walk straight through the dentry.
> > 
> > For certain automount map constructs it's possible for a dentry that is
> > not itself a mount point to be expired in the same way a mount or mount
> > tree is expired.
> > 
> > What's the thinking behind this one please?
> 
> I admit that I don't fully understand the role of -EISDIR being returned by
> d_manage.

Yeah, it's to accommodate the so called autofs rootless mutli-mount
where the root of the tree doesn't itself have a mount and path walks
need to walk through them if they aren't expiring or under construction.

> However the comment below suggests that it is an optimisation.  It tells the
> VFS not to even bother calling ->d_automount on this dentry.
> In RCU-walk this doesn't apply.  ->d_automount will not be called if
> ->d_manage returns zero.  So the optimisation is not needed.

Oh yes, I remember now, your talking about __follow_mount_rcu(), the
only place ->d_manage() gets called in an RCU-walk mode.

I get what's going on now, thanks.

> 
> I might have missed a subtlety here but it looks like:
> 
> in rcu_walk mode:
>    ->d_manage returns zero if everything is stable, no automount is
>                       needed, and nothing is expiring
>         and returns non-zero (-ECHILD) if anything doesn't quite look right
>         and we need to re-try with in refwalk mode with spinlocks etc.
> 
> while in refwalk mode:
>    ->d_manage returns zero, possibly after waiting, if everything looks
>         stable and ->d_automount is needed
>      or it returns -EISDIR if the dentry never needs automounting

Yep, that sounds right to me.

> 
> So while the 'success' condition is similar, the 'error' case is quite
> different.  The errors that make sense in one case don't make sense in the
> other.
> 
> So this patch fragment is avoiding a refwalk error return in the rcuwalk case.
> 
> On reflection, there might be something wrong here.
> If a dentry should eventually be mounted on but isn't yet, ->d_manage needs
> to fail.
> So if !d_mountpoint and simple_empty(), maybe d_manage should fail in rcuwalk
> mode.

Yep, that's right, I missed that.

> That looks a bit messy ... I wonder if we could have a new "ino" flag which
> says "This dentry is mounted-on if it needs to be.  Gets set by ->lookup
> and cleared by ->d_automount or when ->d_manage returns -EISDIR.

At one point DCACHE_NEED_AUTOMOUNT and DCACHE_MANAGE_TRANSIT were
handled separately and DCACHE_NEED_AUTOMOUNT was cleared for rootless
multi-mount dentrys following a mount and set again at expire. Not
having to worry about managing that flag was also part of the
optimization.

We could go back to managing DCACHE_NEED_AUTOMOUNT or add a new flag.
I'm not fussy how it's done as long as it works. IIRC there was one
quite convoluted if check (in the expire code) that was removed due to
the optimization.

> Then set again when it expires.
> I'll probably have to understand the code more deeply before I can be sure.

Rootless multi-mount entries have always caused things to be that much
more difficult.

Fyi, here's an example of an autofs map construct that has no root
mount:

root	/one	server:/export/one \
	/two	server2:/export/two \
	/three	server:/export/three

I'll continue, and have a look at the other two patches.

Ian

