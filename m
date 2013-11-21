Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3KUVum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:50:42 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:44980
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751680Ab3KUVuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:50:39 -0500
Date: Thu, 21 Nov 2013 21:50:35 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Aditya Kali <adityakali@google.com>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: Fix namespace mountpoint path in /proc/mounts
Message-ID: <20131121215035.GA9773@mail.hallyn.com>
References: <1382737870-12792-1-git-send-email-adityakali@google.com>
 <20131029153610.GB32008@mail.hallyn.com>
 <87a9heqwkg.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9heqwkg.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Quoting Aditya Kali (adityakali@google.com):
> >> Commit bf056bfa80596a5d14b26b17276a56a0dcb080e5:
> >> "proc: Fix the namespace inode permission checks." converted
> >> the namespace files into symlinks. The same commit changed
> >> the way namespace bind mounts appear in /proc/mounts:
> >>   $ mount --bind /proc/self/ns/ipc /mnt/ipc
> >> Originally:
> >>   $ cat /proc/mounts | grep ipc
> >>   proc /mnt/ipc proc rw,nosuid,nodev,noexec 0 0
> >> 
> >> After commit bf056bfa80596a5d14b26b17276a56a0dcb080e5:
> >>   $ cat /proc/mounts | grep ipc
> >>   proc ipc:[4026531839] proc rw,nosuid,nodev,noexec 0 0
> >> 
> >> This breaks userspace which expects the 2nd field in
> >> /proc/mounts to be a valid path. This patch restores the
> >> original format of namespace bind-mount entries in
> >> /proc/mounts.
> >
> > Oh, at first I was thinking the mount source was showing up like that,
> > not the target.  That is particularly ugly, I agree.
> >
> > I'm not sure what the purpose was of the ns_dname().  dcache.c says it's
> > for filesystems wanting to do 'special "root names"'.  But this file
> > gets mounted to real paths, it's not actually rootless (like a pipefs
> > inode or anon_inode).  So I think your patch is correct, but I'm waiting
> > to hear from Eric, as I'm not sure if you're masking some other effect
> > which Eric actually wanted, and maybe this should be fixed another
> > way...
> 
> My apologies for taking a long time to get back to this one.  I have
> been scratching my head on this one.
> 
> There is most definitely a bug here, and worth fixing.
> 
> But I believe the bug is actually in buried in /proc/mounts. ns_dname
> should be irrelevant as we are mounted.
> 
> The problem comes down to d_path.
> 
> I am not certain which is the best fix at the moment.  It should either
> be a case of fixing d_path to see if the dentry is mounted, or making
> certain that the dentries have the name ns_dname is giving them when
> we allocate the dentries.
> 
> I was focusing on the what a ns file descriptor should look like when it
> is opened but not mounted, when I wrote ns_dname, and that appearance
> really should continue if possible.
> 
> I expect the easist way to fix this is to simply modify proc_ns_get_dentry to
> compute the dentry name that ns_dname uses today, and pass that name to
> d_alloc_psuedo.
> 
> At which point we can delete ns_dname without problems.

Aditya, is this something you'd have time to write a patch for?

> Eric
> 
> 
> >> Signed-off-by: Aditya Kali <adityakali@google.com>
> >> ---
> >>  fs/proc/namespaces.c | 10 ----------
> >>  1 file changed, 10 deletions(-)
> >> 
> >> diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
> >> index 49a7fff..d19989d 100644
> >> --- a/fs/proc/namespaces.c
> >> +++ b/fs/proc/namespaces.c
> >> @@ -48,19 +48,9 @@ static int ns_delete_dentry(const struct dentry *dentry)
> >>  	return 1;
> >>  }
> >>  
> >> -static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
> >> -{
> >> -	struct inode *inode = dentry->d_inode;
> >> -	const struct proc_ns_operations *ns_ops = PROC_I(inode)->ns.ns_ops;
> >> -
> >> -	return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
> >> -		ns_ops->name, inode->i_ino);
> >> -}
> >> -
> >>  const struct dentry_operations ns_dentry_operations =
> >>  {
> >>  	.d_delete	= ns_delete_dentry,
> >> -	.d_dname	= ns_dname,
> >>  };
> >>  
> >>  static struct dentry *proc_ns_get_dentry(struct super_block *sb,
> >> -- 
> >> 1.8.4.1
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
