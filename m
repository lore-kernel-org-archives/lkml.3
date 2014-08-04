Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaHDUWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:22:10 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:58678
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaHDUWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:22:09 -0400
Date: Mon, 4 Aug 2014 22:22:07 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, tj@kernel.org,
        akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com,
        hpa@zytor.com, serge.hallyn@canonical.com, xemul@parallels.com,
        segoon@openwall.com, kamezawa.hiroyu@jp.fujitsu.com,
        mtk.manpages@gmail.com, jln@google.com
Subject: Re: [patch 3/4] prctl: PR_SET_MM -- Factor out mmap_sem when update
 mm::exe_file
Message-ID: <20140804202207.GA27304@mail.hallyn.com>
References: <20140804172255.109539743@openvz.org>
 <20140804172610.881395126@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804172610.881395126@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cyrill Gorcunov (gorcunov@openvz.org):
> Instead of taking mm->mmap_sem inside prctl_set_mm_exe_file move
> it out of and rename the helper to prctl_set_mm_exe_file_locked.
> This will allow to reuse this function in a next patch.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Vasiliy Kulikov <segoon@openwall.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Julien Tinnes <jln@google.com>
> ---
>  kernel/sys.c |   21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6.git/kernel/sys.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/sys.c
> +++ linux-2.6.git/kernel/sys.c
> @@ -1628,12 +1628,14 @@ SYSCALL_DEFINE1(umask, int, mask)
>  	return mask;
>  }
>  
> -static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
> +static int prctl_set_mm_exe_file_locked(struct mm_struct *mm, unsigned int fd)
>  {
>  	struct fd exe;
>  	struct inode *inode;
>  	int err;
>  
> +	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
> +
>  	exe = fdget(fd);
>  	if (!exe.file)
>  		return -EBADF;
> @@ -1654,8 +1656,6 @@ static int prctl_set_mm_exe_file(struct
>  	if (err)
>  		goto exit;
>  
> -	down_write(&mm->mmap_sem);
> -
>  	/*
>  	 * Forbid mm->exe_file change if old file still mapped.
>  	 */
> @@ -1667,7 +1667,7 @@ static int prctl_set_mm_exe_file(struct
>  			if (vma->vm_file &&
>  			    path_equal(&vma->vm_file->f_path,
>  				       &mm->exe_file->f_path))
> -				goto exit_unlock;
> +				goto exit;
>  	}
>  
>  	/*
> @@ -1678,13 +1678,10 @@ static int prctl_set_mm_exe_file(struct
>  	 */
>  	err = -EPERM;
>  	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags))
> -		goto exit_unlock;
> +		goto exit;
>  
>  	err = 0;
>  	set_mm_exe_file(mm, exe.file);	/* this grabs a reference to exe.file */
> -exit_unlock:
> -	up_write(&mm->mmap_sem);
> -
>  exit:
>  	fdput(exe);
>  	return err;
> @@ -1703,8 +1700,12 @@ static int prctl_set_mm(int opt, unsigne
>  	if (!capable(CAP_SYS_RESOURCE))
>  		return -EPERM;
>  
> -	if (opt == PR_SET_MM_EXE_FILE)
> -		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
> +	if (opt == PR_SET_MM_EXE_FILE) {
> +		down_write(&mm->mmap_sem);
> +		error = prctl_set_mm_exe_file_locked(mm, (unsigned int)addr);
> +		up_write(&mm->mmap_sem);
> +		return error;
> +	}
>  
>  	if (addr >= TASK_SIZE || addr < mmap_min_addr)
>  		return -EINVAL;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
