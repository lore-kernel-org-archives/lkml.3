Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbbAVLCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:02:51 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:42143 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbbAVLCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:02:42 -0500
Date: Thu, 22 Jan 2015 13:02:10 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Calvin Owens <calvinowens@fb.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][PATCH] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Message-ID: <20150122110210.GA31186@node.dhcp.inet.fi>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <20150114152501.GB9820@node.dhcp.inet.fi>
 <20150114153323.GF2253@moon>
 <20150114204653.GA26698@mail.thefacebook.com>
 <20150114211613.GH2253@moon>
 <20150122024554.GB23762@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122024554.GB23762@mail.thefacebook.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 06:45:54PM -0800, Calvin Owens wrote:
> Currently, /proc/<pid>/map_files/ is restricted to CAP_SYS_ADMIN, and
> is only exposed if CONFIG_CHECKPOINT_RESTORE is set. This interface
> is very useful for enumerating the files mapped into a process when
> the more verbose information in /proc/<pid>/maps is not needed.
> 
> This patch moves the folder out from behind CHECKPOINT_RESTORE, and
> removes the CAP_SYS_ADMIN restrictions. To avoid exposing files to
> processes for whom they may not be visible, a follow_link() stub is
> added to the inode_operations struct attached to the symlinks that
> prevent them from being followed without CAP_SYS_ADMIN.
> 
> Signed-off-by: Calvin Owens <calvinowens@fb.com>
> ---
>  fs/proc/base.c | 42 +++++++++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 3f3d7ae..7d48003 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1632,8 +1632,6 @@ end_instantiate:
>  	return dir_emit(ctx, name, len, 1, DT_UNKNOWN);
>  }
>  
> -#ifdef CONFIG_CHECKPOINT_RESTORE
> -
>  /*
>   * dname_to_vma_addr - maps a dentry name into two unsigned longs
>   * which represent vma start and end addresses.
> @@ -1660,11 +1658,6 @@ static int map_files_d_revalidate(struct dentry *dentry, unsigned int flags)
>  	if (flags & LOOKUP_RCU)
>  		return -ECHILD;
>  
> -	if (!capable(CAP_SYS_ADMIN)) {
> -		status = -EPERM;
> -		goto out_notask;
> -	}
> -
>  	inode = dentry->d_inode;
>  	task = get_proc_task(inode);
>  	if (!task)
> @@ -1753,6 +1746,28 @@ struct map_files_info {
>  	unsigned char	name[4*sizeof(long)+2]; /* max: %lx-%lx\0 */
>  };
>  
> +/*
> + * Allowing any user to follow the symlinks in /proc/<pid>/map_files/ could
> + * allow processes to access files that should not be visible to them, so
> + * restrict follow_link() to CAP_SYS_ADMIN for these files.
> + */
> +static void *proc_map_files_follow_link(struct dentry *d, struct nameidata *n)
> +{
> +	if (!capable(CAP_SYS_ADMIN))
> +		return ERR_PTR(-EPERM);
> +
> +	return proc_pid_follow_link(d, n);
> +}

I have thought a bit more about this and not sure it's reasonable to
limit it to CAP_SYS_ADMIN. What scenario are we protecting from?

Initially, I thought about something like this: privileged process opens a
file, map part of it, closes the file and drop privileges with hope to
limit further access to mapped window of the file. But I don't see what
would stop the unprivileged process from accessing rest of the file using
mremap(2). And if a process can do this, anybody who can ptrace(2) the
process can do this.

Am I missing something?

-- 
 Kirill A. Shutemov
