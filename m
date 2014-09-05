Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaIERgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:36:16 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36788 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaIERgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:36:14 -0400
Date: Fri, 5 Sep 2014 12:36:05 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, seth.forshee@canonical.com
Subject: Re: [PATCH v2 3/3] fuse: Add support for mounts from user namespaces
Message-ID: <20140905173605.GA84919@ubuntu-hedt>
Mail-Followup-To: Serge Hallyn <serge.hallyn@ubuntu.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
 <1409672696-15847-4-git-send-email-seth.forshee@canonical.com>
 <20140905164811.GH16450@ubuntumail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905164811.GH16450@ubuntumail>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 04:48:11PM +0000, Serge Hallyn wrote:
> Quoting Seth Forshee (seth.forshee@canonical.com):
> > Update fuse to support mounts from within user namespaces. This
> > is mostly a matter of translating uids and gids into the
> > namespace of the process reading requests before handing the
> > requests off to userspace.
> > 
> > Due to security concerns the namespace used should be fixed,
> > otherwise a user might be able to pass the fuse fd to
> > init_user_ns and inject suid files owned by a user outside the
> > namespace in order to gain elevated privileges. For fuse we
> > stash current_user_ns() when a filesystem is first mounted and
> > abort the mount if this namespace is different than the one used
> > to open the fd passed in the mount options.
> > 
> > The allow_others options could also be a problem, as a userns
> > mount could bypass system policy for this option and thus open
> > the possiblity of DoS attacks. This is prevented by restricting
> > the scope of allow_other to apply only to that superblock's
> > userns and its children, giving the expected behavior within the
> > userns while preventing DoS attacks on more privileged contexts.
> > 
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> 
> Thanks, Seth, just two little questions below.
> 
> > ---
> >  fs/fuse/dev.c    |  4 ++--
> >  fs/fuse/dir.c    | 46 +++++++++++++++++++++++++++++++++-------------
> >  fs/fuse/fuse_i.h |  4 ++++
> >  fs/fuse/inode.c  | 28 ++++++++++++++++++++--------
> >  4 files changed, 59 insertions(+), 23 deletions(-)
> > 
> > diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> > index 839caebd34f1..03c8785ed731 100644
> > --- a/fs/fuse/dev.c
> > +++ b/fs/fuse/dev.c
> > @@ -127,8 +127,8 @@ static void __fuse_put_request(struct fuse_req *req)
> >  
> >  static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
> >  {
> > -	req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
> > -	req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
> > +	req->in.h.uid = from_kuid_munged(fc->user_ns, current_fsuid());
> > +	req->in.h.gid = from_kgid_munged(fc->user_ns, current_fsgid());
> >  	req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
> >  }
> >  
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index de1d84af9f7c..c0b9968db6a1 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -905,8 +905,8 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
> >  	stat->ino = attr->ino;
> >  	stat->mode = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
> >  	stat->nlink = attr->nlink;
> > -	stat->uid = make_kuid(&init_user_ns, attr->uid);
> > -	stat->gid = make_kgid(&init_user_ns, attr->gid);
> > +	stat->uid = make_kuid(fc->user_ns, attr->uid);
> > +	stat->gid = make_kgid(fc->user_ns, attr->gid);
> >  	stat->rdev = inode->i_rdev;
> >  	stat->atime.tv_sec = attr->atime;
> >  	stat->atime.tv_nsec = attr->atimensec;
> > @@ -1085,12 +1085,20 @@ int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
> >   */
> >  int fuse_allow_current_process(struct fuse_conn *fc)
> >  {
> > -	const struct cred *cred;
> > +	const struct cred *cred = current_cred();
> >  
> > -	if (fc->flags & FUSE_ALLOW_OTHER)
> > -		return 1;
> > +	if (fc->flags & FUSE_ALLOW_OTHER) {
> > +		if (kuid_has_mapping(fc->user_ns, cred->euid) &&
> > +		    kuid_has_mapping(fc->user_ns, cred->suid) &&
> > +		    kuid_has_mapping(fc->user_ns, cred->uid) &&
> > +		    kgid_has_mapping(fc->user_ns, cred->egid) &&
> > +		    kgid_has_mapping(fc->user_ns, cred->sgid) &&
> > +		    kgid_has_mapping(fc->user_ns, cred->gid))
> 
> Should fsuid be checked here?

The point of restricting access here is to prevent a DoS type of attack
on a more privileged context by making a filesystem operation block
indefinitely. Coming from that perspective I was thinking that these
checks ought to be sufficient, but I could be wrong.

> 
> > +			return 1;
> > +
> > +		return 0;
> > +	}
> >  
> > -	cred = current_cred();
> >  	if (uid_eq(cred->euid, fc->user_id) &&
> >  	    uid_eq(cred->suid, fc->user_id) &&
> >  	    uid_eq(cred->uid,  fc->user_id) &&
> > @@ -1556,17 +1564,25 @@ static bool update_mtime(unsigned ivalid, bool trust_local_mtime)
> >  	return true;
> >  }
> >  
> > -static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
> > -			   bool trust_local_cmtime)
> > +static int iattr_to_fattr(struct fuse_conn *fc, struct iattr *iattr,
> > +			   struct fuse_setattr_in *arg, bool trust_local_cmtime)
> >  {
> >  	unsigned ivalid = iattr->ia_valid;
> >  
> >  	if (ivalid & ATTR_MODE)
> >  		arg->valid |= FATTR_MODE,   arg->mode = iattr->ia_mode;
> > -	if (ivalid & ATTR_UID)
> > -		arg->valid |= FATTR_UID,    arg->uid = from_kuid(&init_user_ns, iattr->ia_uid);
> > -	if (ivalid & ATTR_GID)
> > -		arg->valid |= FATTR_GID,    arg->gid = from_kgid(&init_user_ns, iattr->ia_gid);
> > +	if (ivalid & ATTR_UID) {
> > +		arg->uid = from_kuid(fc->user_ns, iattr->ia_uid);
> > +		if (arg->uid == (uid_t)-1)
> 
> Any reason not to use uid_valid() here (and gid_valid() below)?

Yes. arg->uid is a uid_t and not a kuid_t, so it wouldn't be valid to
pass that to uid_valid(). And from_kuid() can return -1 for values other
than INVALID_UID.

Thanks,
Seth
