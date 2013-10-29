Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab3J2PgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:36:15 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:59402
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755121Ab3J2PgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:36:14 -0400
Date: Tue, 29 Oct 2013 15:36:10 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aditya Kali <adityakali@google.com>
Cc: ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: Fix namespace mountpoint path in /proc/mounts
Message-ID: <20131029153610.GB32008@mail.hallyn.com>
References: <1382737870-12792-1-git-send-email-adityakali@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382737870-12792-1-git-send-email-adityakali@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> Commit bf056bfa80596a5d14b26b17276a56a0dcb080e5:
> "proc: Fix the namespace inode permission checks." converted
> the namespace files into symlinks. The same commit changed
> the way namespace bind mounts appear in /proc/mounts:
>   $ mount --bind /proc/self/ns/ipc /mnt/ipc
> Originally:
>   $ cat /proc/mounts | grep ipc
>   proc /mnt/ipc proc rw,nosuid,nodev,noexec 0 0
> 
> After commit bf056bfa80596a5d14b26b17276a56a0dcb080e5:
>   $ cat /proc/mounts | grep ipc
>   proc ipc:[4026531839] proc rw,nosuid,nodev,noexec 0 0
> 
> This breaks userspace which expects the 2nd field in
> /proc/mounts to be a valid path. This patch restores the
> original format of namespace bind-mount entries in
> /proc/mounts.

Oh, at first I was thinking the mount source was showing up like that,
not the target.  That is particularly ugly, I agree.

I'm not sure what the purpose was of the ns_dname().  dcache.c says it's
for filesystems wanting to do 'special "root names"'.  But this file
gets mounted to real paths, it's not actually rootless (like a pipefs
inode or anon_inode).  So I think your patch is correct, but I'm waiting
to hear from Eric, as I'm not sure if you're masking some other effect
which Eric actually wanted, and maybe this should be fixed another
way...

> Signed-off-by: Aditya Kali <adityakali@google.com>
> ---
>  fs/proc/namespaces.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
> index 49a7fff..d19989d 100644
> --- a/fs/proc/namespaces.c
> +++ b/fs/proc/namespaces.c
> @@ -48,19 +48,9 @@ static int ns_delete_dentry(const struct dentry *dentry)
>  	return 1;
>  }
>  
> -static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
> -{
> -	struct inode *inode = dentry->d_inode;
> -	const struct proc_ns_operations *ns_ops = PROC_I(inode)->ns.ns_ops;
> -
> -	return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
> -		ns_ops->name, inode->i_ino);
> -}
> -
>  const struct dentry_operations ns_dentry_operations =
>  {
>  	.d_delete	= ns_delete_dentry,
> -	.d_dname	= ns_dname,
>  };
>  
>  static struct dentry *proc_ns_get_dentry(struct super_block *sb,
> -- 
> 1.8.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
