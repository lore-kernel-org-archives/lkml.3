Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaI3Q1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:27:19 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36464 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaI3Q0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:26:05 -0400
Date: Tue, 30 Sep 2014 11:25:59 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20140930162559.GA1057@ubuntu-hedt>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	fuse-devel <fuse-devel@lists.sourceforge.net>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
	"Serge E. Hallyn" <serge@hallyn.com>
References: <20140924132925.GA48721@ubuntu-hedt>
 <87y4t9ndw5.fsf@x220.int.ebiederm.org>
 <CAJfpegs3QNdKMZWmN324OqHFw+e2qwU9kfkQ491==yP_JRrcWw@mail.gmail.com>
 <87wq8reftb.fsf@x220.int.ebiederm.org>
 <20140925184403.GB28101@ubuntu-hedt>
 <87bnq3a4xy.fsf@x220.int.ebiederm.org>
 <20140925194825.GB39447@ubuntu-hedt>
 <874mvtkfg2.fsf@x220.int.ebiederm.org>
 <20140927042447.GA19672@ubuntu-hedt>
 <87tx3qdxuz.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tx3qdxuz.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 12:34:44PM -0700, Eric W. Biederman wrote:
> >> -static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
> >> +static int fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
> >>  			  struct kstat *stat)
> >>  {
> >>  	unsigned int blkbits;
> >> @@ -905,8 +905,12 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
> >>  	stat->ino = attr->ino;
> >>  	stat->mode = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
> >>  	stat->nlink = attr->nlink;
> >> -	stat->uid = make_kuid(&init_user_ns, attr->uid);
> >> -	stat->gid = make_kgid(&init_user_ns, attr->gid);
> >> +	stat->uid = make_kuid(fc->user_ns, attr->uid);
> >> +	if (!uid_valid(stat->uid))
> >> +		return -EOVERFLOW;
> >> +	stat->gid = make_kgid(fc->user_ns, attr->gid);
> >> +	if (!gid_valid(stat->gid))
> >> +		return -EOVERFLOW;
> >
> > If we were to go with the invalid id approach these checks shouldn't be
> > necessary, and they'll get converted to the overflow ids for
> > userspace.
> 
> Correct.  
> 
> > In my make_bad_inode patches I'm doing this check when we update the
> > inode and returning -EINVAL if it doesn't map. 
> 
> In fuse_change_attributes?  That seems reasonable.

In fuse_change_attributes_common, which then filters up to
fuse_change_attributes.

> >> @@ -1033,6 +1037,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
> >>  	sb->s_maxbytes = MAX_LFS_FILESIZE;
> >>  	sb->s_time_gran = 1;
> >>  	sb->s_export_op = &fuse_export_operations;
> >> +	sb->s_user_ns = get_user_ns(current_user_ns());
> >>  
> >>  	file = fget(d.fd);
> >>  	err = -EINVAL;
> >> @@ -1149,6 +1154,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
> >>  	}
> >>  
> >>  	kill_anon_super(sb);
> >> +	put_user_ns(sb->s_user_ns);
> >>  }
> >
> > What's the point of s_user_ns? It doesn't seem to be used anywhere.
> 
> Not in these patches, and the field isn't added here either.  It was my
> exporting of the user namespace that ids are enconded in the filesystem
> to generic code in the vfs.  By default that I am setting that field
> to init_user_ns.
> 
> Looking through my tree the only real user of it is the quota code.
> 
> However for acls and other xattrs we may also care.  
> 
> For block based filesystems I woudn't expect to need the fuse connection
> structure and storing the user namespace there.  So that field becomes
> a lot less redundant in the general case.

Hmm, so that does seem to make sense for acls. The ids should be getting
translated relative to the namespace used for the superblock.  Currently
they're translated relative to init_user_ns.

> >> From 55226d169826abd110d9bc60a6b079f6be3f6a46 Mon Sep 17 00:00:00 2001
> >> From: "Eric W. Biederman" <ebiederm@xmission.com>
> >> Date: Fri, 5 Oct 2012 10:18:28 -0700
> >> Subject: [PATCH 3/4] userns: fuse unprivileged mount suport
> >> 
> >> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >> ---
> >>  fs/fuse/inode.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> >> index 5284d7fda269..75f5326868e0 100644
> >> --- a/fs/fuse/inode.c
> >> +++ b/fs/fuse/inode.c
> >> @@ -1164,7 +1164,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
> >>  static struct file_system_type fuse_fs_type = {
> >>  	.owner		= THIS_MODULE,
> >>  	.name		= "fuse",
> >> -	.fs_flags	= FS_HAS_SUBTYPE,
> >> +	.fs_flags	= FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
> >>  	.mount		= fuse_mount,
> >>  	.kill_sb	= fuse_kill_sb_anon,
> >>  };
> >
> > I have the order of my patches switched, then this one squashed in with
> > the one which adds userns support to fuse.
> 
> It is nice having this as a separate patch because it allows incremental
> progress.   Then this patch can be added when victory is declared.
> 
> Although looking at my code this looks like this patch is probably a
> little early in the series ;-)

It doesn't really make any difference to me, so I'll go ahead and split
it out.

> >> From 6ae88ecfe4e8c8998478932ca225d1d9753b6c4b Mon Sep 17 00:00:00 2001
> >> From: "Eric W. Biederman" <ebiederm@xmission.com>
> >> Date: Fri, 5 Oct 2012 14:33:36 -0700
> >> Subject: [PATCH 4/4] fuse: Only allow read/writing user xattrs
> >> 
> >> In the context of unprivileged mounts supporting anything except
> >> xattrs with the "user." prefix seems foolish.  Return -EOPNOSUPP
> >> for all other types of xattrs.
> >> 
> >> Cc: Miklos Szeredi <miklos@szeredi.hu>
> >> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >> ---
> >>  fs/fuse/dir.c | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >> 
> >> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> >> index d74c75a057cd..d84f5b819fab 100644
> >> --- a/fs/fuse/dir.c
> >> +++ b/fs/fuse/dir.c
> >> @@ -13,6 +13,7 @@
> >>  #include <linux/sched.h>
> >>  #include <linux/namei.h>
> >>  #include <linux/slab.h>
> >> +#include <linux/xattr.h>
> >>  
> >>  static bool fuse_use_readdirplus(struct inode *dir, struct dir_context *ctx)
> >>  {
> >> @@ -1868,6 +1869,9 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
> >>  	if (fc->no_setxattr)
> >>  		return -EOPNOTSUPP;
> >>  
> >> +	if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
> >> +		return -EOPNOTSUPP;
> >> +
> >>  	req = fuse_get_req_nopages(fc);
> >>  	if (IS_ERR(req))
> >>  		return PTR_ERR(req);
> >> @@ -1911,6 +1915,9 @@ static ssize_t fuse_getxattr(struct dentry *entry, const char *name,
> >>  	if (fc->no_getxattr)
> >>  		return -EOPNOTSUPP;
> >>  
> >> +	if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
> >> +		return -EOPNOTSUPP;
> >> +
> >>  	req = fuse_get_req_nopages(fc);
> >>  	if (IS_ERR(req))
> >>  		return PTR_ERR(req);
> >
> > This I hadn't considered, but it seems reasonable. Two questions though.
> >
> > Why shouldn't we let root-owned mounts support namespaces other than
> > "user."?
> 
> Are there any users of fuse who care.  Certainly the core use case of
> fuse is unprivileged mounts and in that case nosuid should take care of
> this.

I couldn't say for sure - I'm thinking that there are some filesystems
which are only supported via fuse, and if distros are automounting any
of those then it would likely be via root-owned fuse mounts. And if any
of those supports xattrs then this could be considered a regression.

> > Thinking ahead to (hopefully) allowing other filesystems to be mounted
> > from user namespaces, should this be enforced by the vfs instead?
> 
> Potentially.  I would have to look to see how hard it is to lift this
> code into the vfs.  At least historically the xattr interface was ugly
> enough getting some of this stuff into the vfs would require
> refactoring.
> 
> My tenative patches in this area look pretty rough.  For ext2 I
> just implemented:
> 
> +       if (dentry->d_inode->i_sb->s_user_ns != &init_user_ns)
> +               return -EOPNOTSUPP;
> +
> 
> So for ext2 I did honor allow things to happen as you would have
> suspected.
> 
> But if we are not going to require specifying nosuid looking closely at
> xattrs and acls and security attributes seems pretty important.
> 
> Looking at all of this my guess is we probably want to write a list of
> rules for unprivileged mounting of filesystems.  So that people can
> (a) review the basic theory in case they are aware of anything we may
>     have missed.
> (b) Have a reference for the whatever filesystems come next.

Several namespaces are restricted at the vfs level right now, though
system.* and security.* are specifically called out as being left to the
individual filesystem to decide.

I'm not well versed in the use of xattrs, so I'll need to go do some
studying before I'll fully understand everything that needs to be done.
I guess there are a couple of options: try to tackle all of this before
merging any patches for fuse, or put some limits if fuse right now that
could potentially be lifted after we have more general rules. I'd prefer
the second option so we can get some level of support for fuse in
containers sooner.

For xattrs I could do something like this to avoid regressions in
init_user_ns while restricting to user.* in other namespaces for now:

        if (fc->user_ns != &init_user_ns &&
            strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
        	return -EOPNOTSUPP;

Thoughts?

Thanks,
Seth
