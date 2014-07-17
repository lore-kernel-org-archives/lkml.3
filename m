Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaGQKRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:17:44 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38797 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370AbaGQKRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:17:41 -0400
X-Sasl-enc: fsnfj+43+QC3BQrM/RK6fbzQ+agNcxTy75ZhM2X2zYNx 1405592257
Message-ID: <1405592252.20621.63.camel@perseus.fritz.box>
Subject: Re: [PATCH 3/6] autofs4: allow RCU-walk to walk through autofs4.
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 17 Jul 2014 18:17:32 +0800
In-Reply-To: <20140717180414.2e2596d1@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	 <20140709234114.4525.46882.stgit@notabene.brown>
	 <1405485857.2527.38.camel@perseus.fritz.box>
	 <20140716155150.044c2ea3@notabene.brown>
	 <1405493777.2527.72.camel@perseus.fritz.box>
	 <1405573256.3002.25.camel@perseus.fritz.box>
	 <20140717180414.2e2596d1@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2014-07-17 at 18:04 +1000, NeilBrown wrote:
> On Thu, 17 Jul 2014 13:00:56 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > On Wed, 2014-07-16 at 14:56 +0800, Ian Kent wrote:
> > > > That looks a bit messy ... I wonder if we could have a new "ino" flag which
> > > > says "This dentry is mounted-on if it needs to be.  Gets set by ->lookup
> > > > and cleared by ->d_automount or when ->d_manage returns -EISDIR.
> > > 
> > > At one point DCACHE_NEED_AUTOMOUNT and DCACHE_MANAGE_TRANSIT were
> > > handled separately and DCACHE_NEED_AUTOMOUNT was cleared for rootless
> > > multi-mount dentrys following a mount and set again at expire. Not
> > > having to worry about managing that flag was also part of the
> > > optimization.
> > > 
> > > We could go back to managing DCACHE_NEED_AUTOMOUNT or add a new flag.
> > > I'm not fussy how it's done as long as it works. IIRC there was one
> > > quite convoluted if check (in the expire code) that was removed due to
> > > the optimization.
> > 
> > Umm ... using DCACHE_NEED_AUTOMOUNT rather than a new flag means using
> > an additional lock so perhaps a new flag would be preferred since
> > reducing lock overhead was the point of this.
> 
> Actually, I've managed to convince myself that there is nothing that needs
> fixing here.
> 
> autofs4 already sets DCACHE_NEED_AUTOMOUNT on any directory that might need
> to be mounted on.  It does this before the dentry is added to the dcache, so
> before rcuwalk could possibly see the dentry.

Yep, that's right and that takes care of indirect mounts, but also have
a quick look at fs/autofs4/inode.c:autofs4_fill_super() which will set
the flags on the root dentry for direct mounts.

Actually they are often called triggers in the code as the so called
direct and offset mounts have the same semantics, so in
autofs4_fill_super() you'll see:

	if (autofs_type_trigger(sbi->type))
                __managed_dentry_set_managed(root);

which is what I'm referring to.

> 
> If __follow_mount_rcu find that the dentry is d_mountpoint(), it will
> follow down to the mounted directory, which is always correct.
> If it isn't d_mountpoint, then lookup_fast, which is the only caller for
> __follow_mount_rcu, will check if DCACHE_NEED_AUTOMOUNT is set, and if so
> will goto unlazy, which drops back to refwalk and tries again.  So that is
> always safe.

That all sound right having now looked at the rcu-walk code.

> 
> So it is currently either correct or safe.
> 
> I'm not 100% sure about the v4 code paths, but it seems OK.
> If there some documentation about the interactions between the automountd and
> the kernel?

Not really, only the ioctl interaction described in
Documentation/filesystems/autofs4-mount-control.txt

> It looks like:
>  With V5, every name in the root directory gets something mounted on it,
>       either another autofs or the target filesystem.
>  With V4, you don't mount an autofs onto an autofs, but when a name in the
>       root is automounted, all the names beneath there are created and the
>       target filesystems are mounted before the top level automount is
>       acknowledged.
> 
> Does that sound at all right (I suspect I haven't explained it very clearly).

Mostly, but let me try and simplify it (or perhaps confuse you even more
and bore you as a bonus, ;)) and offer a broader picture.

I always relate to this in terms of automount maps and some map features
weren't available in version 4, in particular direct mounts. That lead
to some of the hard to understand code in the kernel, more so because
there's virtually nothing left of it in user space now.

Basically all autofs mounted file systems are either indirect or direct
mounts that are driven by automount maps.

These maps (stored in a file, nis, ldap or other) are associated with
autofs mounts by the master map (poor example below).

Indirect mounts have a mounted autofs filesystem and mounts are entries
in the root of that file system as enumerated by map entry keys (or
matched by a wildcard map entry) in the map. In this case the keys are a
single directory component.

This is where the everything in the root directory gets mounted comes
from, but there are exceptions.

Direct mounts are distinct autofs filesystem mounts that correspond to
distinct map entries in automount maps. Each direct mount map entry
represents a full path that can trigger a mount directly. But there are
exception here too.

This is where the setting in autofs4_fill_super() comes from.

Indirect maps can have one map only associated with a specific autofs
mounted filesystem whereas direct mount maps can have multiple entries
in the master map and therefore can have multiple maps associated with
them. Direct mount entries all have a pseudo mount path of "/-" in the
master map.

For example the master map used by autofs connectathon, before it gets
translated by the test driver script, is (ignore the fact that "_" is
used in map names here, even though the Linux convention is to use "."):

/net            -hosts  -nosuid
#/home          auto_home       -nosuid
/-                      AUTOMAP_DIR/auto_dcthon
/-                      AUTOMAP_DIR/auto_test3_direct
/-                      AUTOMAP_DIR/auto_test4_direct
AUTO_CLIENT_MNTPNT/iparse       AUTOMAP_DIR/auto_icthon
AUTO_CLIENT_MNTPNT/eparse       AUTOMAP_DIR/auto_ecthon
AUTO_CLIENT_MNTPNT/oparse       AUTOMAP_DIR/auto_octhon

AUTO_CLIENT_MNTPNT/test1        AUTOMAP_DIR/auto_icthon
AUTO_CLIENT_MNTPNT/test2        AUTOMAP_DIR/auto_ecthon
AUTO_CLIENT_MNTPNT/test4/indirect       AUTOMAP_DIR/auto_icthon
AUTO_CLIENT_MNTPNT/options      AUTOMAP_DIR/auto_octhon
AUTO_CLIENT_MNTPNT/nested       AUTOMAP_DIR/auto_nested
AUTO_CLIENT_MNTPNT/badnames     AUTOMAP_DIR/auto_badnames

AUTO_CLIENT_MNTPNT/vers         AUTOMAP_DIR/auto_octhon
+auto_master

I'm thinking this is much more than you want or need so I'll cut it
short right now.

Two notable exceptions to the above common map entry types are:

1) multi-mount map entries (as I briefly described before) that can give
rise to the rootless mount trees we have special handling for in kernel.
They can also be used by direct mounts but they always have at least an
autofs file system mounted at the root so are simpler to handle.

2) sub-mounts which are always indirect mounts, mounted within an autofs
mounted filesystem (hence sub-mount). Typically you'll see those as map
entries that have -fstype=autofs in the map entry.

So 1) gives rise to those pesky special cases you see in the kernel
requiring walks to pass through them and 2) gives rise to special cases
mostly in the expire code because they are managed almost entirely by
user space.

And finally the inbuilt hosts map (often mounted on /net) is essentially
a multi-mount map entry of the exports of each host.

So that's version 5.

The differences between v4 and v5 are few.

Most notably direct mounts had no kernel support (and were not
originally implemented in the daemon at all) and this is where the
pseudo-direct mounts of version 4 came from. They where made up of a
directory tree corresponding to the map entries and a convoluted path
matching was done by the daemon to mount and expire leaves of the
directory tree.

And in version 4 multi-mount map entries were mounted and expired as a
whole whereas in version 5 they are mounted and expired on demand (well
almost anyway) using mount triggers (the offset mount type seen in the
kernel). This on demand functionality gives rise to the "mount the base,
mount the triggers inside (and expire in reverse)" that I think you
referred to above.

Other than that there isn't really much difference (although I've
probably forgotten some).

> 
> 
> Also I'd like to send a few of the simple patches to Andrew Morton now to get
> them out of the way.  Then the patches which need more thought and testing
> can wait until we are ready.  I'm in no hurry - as long as there is
> expectation of forward progress I don't need to target any particular release.
> 
> As well as the first two that you provided an Acked-by for, I'd like to send
> akpm:

Feel free to forward those patches and add any attribution you think is
warranted, Acked-by, Reviewed-by or even Signed-off-by.

I think I've made forward progress with my ref-counting problem so, with
some luck, I might be back on track by the end of the weekend, fingers
crossed.

> 
>  - A revised version of the last patch which also avoids the spinlock for
>    autofs4_lookup_active
>  - A patch which removes some more unused 'inlines' from the header file.
>  - a typo-fix.
> 
> I've included the changed one inline below.  If you are happy I'll send them
> all to Andrew.
> 
> Thanks,
> NeilBrown
> 
> 
> From 31b8be2565c72b053d0a92ec4fb2bfadd9545557 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 9 Jul 2014 12:33:15 +1000
> Subject: [PATCH 1/3] autofs4: don't take spinlock when not needed in
>  autofs4_lookup_expiring
> 
> If the expiring_list is empty, we can avoid a costly spinlock
> in the rcu-walk path through autofs4_d_manage (once the rest
> of the path becomes rcu-walk friendly).
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> Acked-by: Ian Kent <raven@themaw.net>
> ---
>  fs/autofs4/root.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index cc87c1abac97..fb202cadd4b3 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -166,8 +166,10 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
>  	const unsigned char *str = name->name;
>  	struct list_head *p, *head;
>  
> -	spin_lock(&sbi->lookup_lock);
>  	head = &sbi->active_list;
> +	if (list_empty(head))
> +		return NULL;
> +	spin_lock(&sbi->lookup_lock);
>  	list_for_each(p, head) {
>  		struct autofs_info *ino;
>  		struct dentry *active;
> @@ -218,8 +220,10 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
>  	const unsigned char *str = name->name;
>  	struct list_head *p, *head;
>  
> -	spin_lock(&sbi->lookup_lock);
>  	head = &sbi->expiring_list;
> +	if (list_empty(head))
> +		return NULL;
> +	spin_lock(&sbi->lookup_lock);
>  	list_for_each(p, head) {
>  		struct autofs_info *ino;
>  		struct dentry *expiring;

Yep, looks fine.

> -- 
> 2.0.0
> 
> From 7ea8366c9b2022e05c4a5bceee1d495bc6517bee Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 17 Jul 2014 14:49:37 +1000
> Subject: [PATCH 2/3] AUTOFS: remove some unused inline functions.
> 
> {__,}manage_dentry_{set,clear}_{automount,transit}
> 
> are 4 unused inline functions.  Discard them.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  fs/autofs4/autofs_i.h | 49 -------------------------------------------------
>  1 file changed, 49 deletions(-)
> 
> diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
> index 22a280151e45..9e359fb20c0a 100644
> --- a/fs/autofs4/autofs_i.h
> +++ b/fs/autofs4/autofs_i.h
> @@ -177,55 +177,6 @@ extern const struct file_operations autofs4_root_operations;
>  extern const struct dentry_operations autofs4_dentry_operations;
>  
>  /* VFS automount flags management functions */
> -
> -static inline void __managed_dentry_set_automount(struct dentry *dentry)
> -{
> -	dentry->d_flags |= DCACHE_NEED_AUTOMOUNT;
> -}
> -
> -static inline void managed_dentry_set_automount(struct dentry *dentry)
> -{
> -	spin_lock(&dentry->d_lock);
> -	__managed_dentry_set_automount(dentry);
> -	spin_unlock(&dentry->d_lock);
> -}
> -
> -static inline void __managed_dentry_clear_automount(struct dentry *dentry)
> -{
> -	dentry->d_flags &= ~DCACHE_NEED_AUTOMOUNT;
> -}
> -
> -static inline void managed_dentry_clear_automount(struct dentry *dentry)
> -{
> -	spin_lock(&dentry->d_lock);
> -	__managed_dentry_clear_automount(dentry);
> -	spin_unlock(&dentry->d_lock);
> -}
> -
> -static inline void __managed_dentry_set_transit(struct dentry *dentry)
> -{
> -	dentry->d_flags |= DCACHE_MANAGE_TRANSIT;
> -}
> -
> -static inline void managed_dentry_set_transit(struct dentry *dentry)
> -{
> -	spin_lock(&dentry->d_lock);
> -	__managed_dentry_set_transit(dentry);
> -	spin_unlock(&dentry->d_lock);
> -}
> -
> -static inline void __managed_dentry_clear_transit(struct dentry *dentry)
> -{
> -	dentry->d_flags &= ~DCACHE_MANAGE_TRANSIT;
> -}
> -
> -static inline void managed_dentry_clear_transit(struct dentry *dentry)
> -{
> -	spin_lock(&dentry->d_lock);
> -	__managed_dentry_clear_transit(dentry);
> -	spin_unlock(&dentry->d_lock);
> -}
> -
>  static inline void __managed_dentry_set_managed(struct dentry *dentry)
>  {
>  	dentry->d_flags |= (DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT);

Yeah, I kept these around deliberately and some were never used and
others became unused over time.

I can always put them back if I need any of them.

> -- 
> 2.0.0
> 
> From e1b74448bf2d0ab7e3c5d5b219d7a938bfd82d99 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 17 Jul 2014 14:58:08 +1000
> Subject: [PATCH 3/3] AUTOFS: comment typo: remove a a doubled word.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  fs/autofs4/root.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index fb202cadd4b3..cdb25ebccc4c 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -377,7 +377,7 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
>  		 * this because the leaves of the directory tree under the
>  		 * mount never trigger mounts themselves (they have an autofs
>  		 * trigger mount mounted on them). But v4 pseudo direct mounts
> -		 * do need the leaves to to trigger mounts. In this case we
> +		 * do need the leaves to trigger mounts. In this case we
>  		 * have no choice but to use the list_empty() check and
>  		 * require user space behave.
>  		 */

Right, not much to say about this one, ;)

Ian

