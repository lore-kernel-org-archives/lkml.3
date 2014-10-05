Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaJEQs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:48:27 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:42892 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaJEQsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:48:23 -0400
Date: Sun, 5 Oct 2014 11:48:21 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20141005164821.GA5691@ubuntu-mba51>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	fuse-devel <fuse-devel@lists.sourceforge.net>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
	"Serge E. Hallyn" <serge@hallyn.com>
References: <87y4t9ndw5.fsf@x220.int.ebiederm.org>
 <CAJfpegs3QNdKMZWmN324OqHFw+e2qwU9kfkQ491==yP_JRrcWw@mail.gmail.com>
 <87wq8reftb.fsf@x220.int.ebiederm.org>
 <20140925184403.GB28101@ubuntu-hedt>
 <87bnq3a4xy.fsf@x220.int.ebiederm.org>
 <20140925194825.GB39447@ubuntu-hedt>
 <874mvtkfg2.fsf@x220.int.ebiederm.org>
 <20140927042447.GA19672@ubuntu-hedt>
 <87tx3qdxuz.fsf@x220.int.ebiederm.org>
 <20140930162559.GA1057@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930162559.GA1057@ubuntu-hedt>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 11:25:59AM -0500, Seth Forshee wrote:
> > >> From 6ae88ecfe4e8c8998478932ca225d1d9753b6c4b Mon Sep 17 00:00:00 2001
> > >> From: "Eric W. Biederman" <ebiederm@xmission.com>
> > >> Date: Fri, 5 Oct 2012 14:33:36 -0700
> > >> Subject: [PATCH 4/4] fuse: Only allow read/writing user xattrs
> > >> 
> > >> In the context of unprivileged mounts supporting anything except
> > >> xattrs with the "user." prefix seems foolish.  Return -EOPNOSUPP
> > >> for all other types of xattrs.
> > >> 
> > >> Cc: Miklos Szeredi <miklos@szeredi.hu>
> > >> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > >> ---
> > >>  fs/fuse/dir.c | 7 +++++++
> > >>  1 file changed, 7 insertions(+)
> > >> 
> > >> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > >> index d74c75a057cd..d84f5b819fab 100644
> > >> --- a/fs/fuse/dir.c
> > >> +++ b/fs/fuse/dir.c
> > >> @@ -13,6 +13,7 @@
> > >>  #include <linux/sched.h>
> > >>  #include <linux/namei.h>
> > >>  #include <linux/slab.h>
> > >> +#include <linux/xattr.h>
> > >>  
> > >>  static bool fuse_use_readdirplus(struct inode *dir, struct dir_context *ctx)
> > >>  {
> > >> @@ -1868,6 +1869,9 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
> > >>  	if (fc->no_setxattr)
> > >>  		return -EOPNOTSUPP;
> > >>  
> > >> +	if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
> > >> +		return -EOPNOTSUPP;
> > >> +
> > >>  	req = fuse_get_req_nopages(fc);
> > >>  	if (IS_ERR(req))
> > >>  		return PTR_ERR(req);
> > >> @@ -1911,6 +1915,9 @@ static ssize_t fuse_getxattr(struct dentry *entry, const char *name,
> > >>  	if (fc->no_getxattr)
> > >>  		return -EOPNOTSUPP;
> > >>  
> > >> +	if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
> > >> +		return -EOPNOTSUPP;
> > >> +
> > >>  	req = fuse_get_req_nopages(fc);
> > >>  	if (IS_ERR(req))
> > >>  		return PTR_ERR(req);
> > >
> > > This I hadn't considered, but it seems reasonable. Two questions though.
> > >
> > > Why shouldn't we let root-owned mounts support namespaces other than
> > > "user."?
> > 
> > Are there any users of fuse who care.  Certainly the core use case of
> > fuse is unprivileged mounts and in that case nosuid should take care of
> > this.
> 
> I couldn't say for sure - I'm thinking that there are some filesystems
> which are only supported via fuse, and if distros are automounting any
> of those then it would likely be via root-owned fuse mounts. And if any
> of those supports xattrs then this could be considered a regression.
> 
> > > Thinking ahead to (hopefully) allowing other filesystems to be mounted
> > > from user namespaces, should this be enforced by the vfs instead?
> > 
> > Potentially.  I would have to look to see how hard it is to lift this
> > code into the vfs.  At least historically the xattr interface was ugly
> > enough getting some of this stuff into the vfs would require
> > refactoring.
> > 
> > My tenative patches in this area look pretty rough.  For ext2 I
> > just implemented:
> > 
> > +       if (dentry->d_inode->i_sb->s_user_ns != &init_user_ns)
> > +               return -EOPNOTSUPP;
> > +
> > 
> > So for ext2 I did honor allow things to happen as you would have
> > suspected.
> > 
> > But if we are not going to require specifying nosuid looking closely at
> > xattrs and acls and security attributes seems pretty important.
> > 
> > Looking at all of this my guess is we probably want to write a list of
> > rules for unprivileged mounting of filesystems.  So that people can
> > (a) review the basic theory in case they are aware of anything we may
> >     have missed.
> > (b) Have a reference for the whatever filesystems come next.
> 
> Several namespaces are restricted at the vfs level right now, though
> system.* and security.* are specifically called out as being left to the
> individual filesystem to decide.
> 
> I'm not well versed in the use of xattrs, so I'll need to go do some
> studying before I'll fully understand everything that needs to be done.
> I guess there are a couple of options: try to tackle all of this before
> merging any patches for fuse, or put some limits if fuse right now that
> could potentially be lifted after we have more general rules. I'd prefer
> the second option so we can get some level of support for fuse in
> containers sooner.
> 
> For xattrs I could do something like this to avoid regressions in
> init_user_ns while restricting to user.* in other namespaces for now:
> 
>         if (fc->user_ns != &init_user_ns &&
>             strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
>         	return -EOPNOTSUPP;

After digging into this some more I think I agree with you. At minimum
letting users insert arbitrary xattrs via fuse bypasses the usual
restrictions on setting xattrs. This is probably mitigated by the
limited visibility of the fuse mount in the usual case for unprivileged
users, but it does seem like a bad idea fundamentally.

So I was thinking of something like the following (untested) to let root
in the host support privileged xattrs while limiting unprivileged users
to user.*. Miklos, does this look acceptable or would you prefer
something different?


diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index e3123bfbc711..1a3ee5663dea 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1882,6 +1882,10 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
 	if (fc->no_setxattr)
 		return -EOPNOTSUPP;
 
+	if (!(fc->flags & FUSE_PRIV_XATTRS) &&
+	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
+		return -EOPNOTSUPP;
+
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -1925,6 +1929,10 @@ static ssize_t fuse_getxattr(struct dentry *entry, const char *name,
 	if (fc->no_getxattr)
 		return -EOPNOTSUPP;
 
+	if (!(fc->flags & FUSE_PRIV_XATTRS) &&
+	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
+		return -EOPNOTSUPP;
+
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 81187ba04e4a..bc0fd14b962a 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -46,6 +46,11 @@
     doing the mount will be allowed to access the filesystem */
 #define FUSE_ALLOW_OTHER         (1 << 1)
 
+/** If the FUSE_PRIV_XATTRS flag is given, then xattrs outside the
+    user.* namespace are allowed. This option is only allowed for
+    system root. */
+#define FUSE_PRIV_XATTRS	(1 << 2)
+
 /** Number of page pointers embedded in fuse_req */
 #define FUSE_REQ_INLINE_PAGES 1
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index b88b5a780228..6716b56d43a1 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -493,6 +493,7 @@ enum {
 	OPT_ALLOW_OTHER,
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
+	OPT_PRIV_XATTRS,
 	OPT_ERR
 };
 
@@ -505,6 +506,7 @@ static const match_table_t tokens = {
 	{OPT_ALLOW_OTHER,		"allow_other"},
 	{OPT_MAX_READ,			"max_read=%u"},
 	{OPT_BLKSIZE,			"blksize=%u"},
+	{OPT_PRIV_XATTRS,		"priv_xattr"},
 	{OPT_ERR,			NULL}
 };
 
@@ -592,6 +594,12 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 			d->blksize = value;
 			break;
 
+		case OPT_PRIV_XATTRS:
+			if (!capable(CAP_SYS_ADMIN))
+				return 0;
+			d->flags |= FUSE_PRIV_XATTRS;
+			break;
+
 		default:
 			return 0;
 		}

