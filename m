Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbaJNWMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:12:22 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:38202
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbaJNWMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:12:20 -0400
Date: Wed, 15 Oct 2014 00:12:19 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH] fs: Treat non-ancestor-namespace mounts as MNT_NOSUID
Message-ID: <20141014221219.GA12338@mail.hallyn.com>
References: <d4c63d6c350d26ffc985d061d213bd778055ca5b.1413322603.git.luto@amacapital.net>
 <87tx36l3gp.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tx36l3gp.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Andy Lutomirski <luto@amacapital.net> writes:
> 
> > If a process gets access to a mount from a descendent or unrelated
> > user namespace, that process should not be able to take advantage of
> > setuid files or selinux entrypoints from that filesystem.
> >
> > This will make it safer to allow more complex filesystems to be
> > mounted in non-root user namespaces.
> >
> > This does not remove the need for MNT_LOCK_NOSUID.  The setuid,
> > setgid, and file capability bits can no longer be abused if code in
> > a user namespace were to clear nosuid on an untrusted filesystem,
> > but this patch, by itself, is insufficient to protect the system
> > from abuse of files that, when execed, would increase MAC privilege.
> >
> > As a more concrete explanation, any task that can manipulate a
> > vfsmount associated with a given user namespace already has
> > capabilities in that namespace and all of its descendents.  If they
> > can cause a malicious setuid, setgid, or file-caps executable to
> > appear in that mount, then that executable will only allow them to
> > elevate privileges in exactly the set of namespaces in which they
> > are already privileges.
> >
> > On the other hand, if they can cause a malicious executable to
> > appear with a dangerous MAC label, running it could change the
> > caller's security context in a way that should not have been
> > possible, even inside the namespace in which the task is confined.
> 
> As presented this is complete and total nonsense.  Mount propgation
> strongly weakens if not completely breaks the assumptions you are making
> in this code.
> 
> To write any generic code that knows anything we need to capture a user
> namespace on struct super.
> 
> Further I think all we really want is to filter out security labels from
> unprivileged mounts.   uids/gids and the like should be completely fine
> because of the uid mappings.  
> 
> Having been down the route of comparing uids as userns uid tuples I am
> convinced that anything requires us to take the user namespace into
> account on a routine basis in the core will simply be broken for someone
> forgetting somewhere.  This looks like a design that has that kind of
> susceptibility.

The above paragraph is very compelling.  However Andy's patch is a step
in the right direction from what we've got.  I think given what you say
below and given Andy's rationale above, simply tweaking his patch to
ignore the parent-userns loop, and return false if current_user_ns() !=
mount_userns, should be right?  It'll prevent a child userns from
setting a selinux/apparmor entrypoint or POSIX file capabilities on a
file and having the parent userns trip over those.

> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > ---
> >
> > Seth, this should address a problem that's related to yours.  If a
> > userns creates and untrusted fs (by any means, although admittedly fuse
> > and user namespaces don't work all that well together right now), then
> > this prevents shenanigans that could happen when the userns passes an fd
> > pointing at the filesystem out to the root ns.
> 
> Andy for now I really think we are best not even reading those
> capabilities into the vfs from unprivileged mounts.
> 
> Eric
> 
> >  fs/exec.c                |  2 +-
> >  fs/namespace.c           | 21 +++++++++++++++++++++
> >  include/linux/mount.h    |  1 +
> >  security/commoncap.c     |  2 +-
> >  security/selinux/hooks.c |  4 ++--
> >  5 files changed, 26 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/exec.c b/fs/exec.c
> > index a2b42a98c743..ac0bb22aa3ed 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1267,7 +1267,7 @@ int prepare_binprm(struct linux_binprm *bprm)
> >  	bprm->cred->euid = current_euid();
> >  	bprm->cred->egid = current_egid();
> >  
> > -	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) &&
> > +	if (mnt_may_suid(bprm->file->f_path.mnt) &&
> >  	    !task_no_new_privs(current) &&
> >  	    kuid_has_mapping(bprm->cred->user_ns, inode->i_uid) &&
> >  	    kgid_has_mapping(bprm->cred->user_ns, inode->i_gid)) {
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index a01c7730e9af..53301680ea7e 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -3011,6 +3011,27 @@ found:
> >  	return visible;
> >  }
> >  
> > +bool mnt_may_suid(struct vfsmount *mnt)
> > +{
> > +	struct user_namespace *mount_userns = real_mount(mnt)->mnt_ns->user_ns;
> > +	struct user_namespace *ns;
> > +
> > +	if (mnt->mnt_flags & MNT_NOSUID)
> > +		return false;
> > +
> > +	/*
> > +	 * We only trust mounts in our own namespace or its parents; we
> > +	 * treat untrusted mounts as MNT_NOSUID regardless of whether
> > +	 * they have MNT_NOSUID set.
> > +	 */
> > +	for (ns = current_user_ns(); ns; ns = ns->parent) {
> > +		if (ns == mount_userns)
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> >  static void *mntns_get(struct task_struct *task)
> >  {
> >  	struct mnt_namespace *ns = NULL;
> > diff --git a/include/linux/mount.h b/include/linux/mount.h
> > index 9262e4bf0cc3..b7b84bafe09b 100644
> > --- a/include/linux/mount.h
> > +++ b/include/linux/mount.h
> > @@ -80,6 +80,7 @@ extern void mntput(struct vfsmount *mnt);
> >  extern struct vfsmount *mntget(struct vfsmount *mnt);
> >  extern struct vfsmount *mnt_clone_internal(struct path *path);
> >  extern int __mnt_is_readonly(struct vfsmount *mnt);
> > +extern bool mnt_may_suid(struct vfsmount *mnt);
> >  
> >  struct file_system_type;
> >  extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index bab0611afc1e..52b3eed065e0 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -443,7 +443,7 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
> >  	if (!file_caps_enabled)
> >  		return 0;
> >  
> > -	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
> > +	if (!mnt_may_suid(bprm->file->f_path.mnt))
> >  		return 0;
> >  
> >  	dentry = dget(bprm->file->f_dentry);
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index b0e940497e23..2089fd0d539e 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -2139,7 +2139,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
> >  		 */
> >  		if (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS)
> >  			return -EPERM;
> > -		if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
> > +		if (!mnt_may_suid(bprm->file->f_path.mnt))
> >  			return -EACCES;
> >  	} else {
> >  		/* Check for a default transition on this program. */
> > @@ -2153,7 +2153,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
> >  	ad.type = LSM_AUDIT_DATA_PATH;
> >  	ad.u.path = bprm->file->f_path;
> >  
> > -	if ((bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) ||
> > +	if (!mnt_may_suid(bprm->file->f_path.mnt) ||
> >  	    (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS))
> >  		new_tsec->sid = old_tsec->sid;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
