Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaAaXBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 18:01:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaAaXBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 18:01:33 -0500
Date: Fri, 31 Jan 2014 15:00:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Jiang Liu <liuj97@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        liguang <lig.fnst@cn.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] Add VM_INIT_DEF_MASK and PRCTL_THP_DISABLE
Message-Id: <20140131150058.99a9e70637f9b5112b8ab18f@linux-foundation.org>
In-Reply-To: <1391192628-113858-5-git-send-email-athorlton@sgi.com>
References: <1391192628-113858-1-git-send-email-athorlton@sgi.com>
	<1391192628-113858-5-git-send-email-athorlton@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 12:23:45 -0600 Alex Thorlton <athorlton@sgi.com> wrote:

> This patch adds a VM_INIT_DEF_MASK, to allow us to set the default flags
> for VMs.  It also adds a prctl control which alllows us to set the THP
> disable bit in mm->def_flags so that VMs will pick up the setting as
> they are created.
> 
> ...
>
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -177,6 +177,8 @@ extern unsigned int kobjsize(const void *objp);
>   */
>  #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP)
>  
> +#define VM_INIT_DEF_MASK	VM_NOHUGEPAGE

Document this here?

>  /*
>   * mapping from the currently active vm_flags protection bits (the
>   * low four bits) to a page protection mask..
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index 289760f..58afc04 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -149,4 +149,7 @@
>  
>  #define PR_GET_TID_ADDRESS	40
>  
> +#define PR_SET_THP_DISABLE	41
> +#define PR_GET_THP_DISABLE	42
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index a17621c..9fc0a30 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -529,8 +529,6 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
>  	atomic_set(&mm->mm_count, 1);
>  	init_rwsem(&mm->mmap_sem);
>  	INIT_LIST_HEAD(&mm->mmlist);
> -	mm->flags = (current->mm) ?
> -		(current->mm->flags & MMF_INIT_MASK) : default_dump_filter;
>  	mm->core_state = NULL;
>  	atomic_long_set(&mm->nr_ptes, 0);
>  	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
> @@ -539,8 +537,15 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
>  	mm_init_owner(mm, p);
>  	clear_tlb_flush_pending(mm);
>  
> -	if (likely(!mm_alloc_pgd(mm))) {
> +	if (current->mm) {
> +		mm->flags = current->mm->flags & MMF_INIT_MASK;
> +		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;

So VM_INIT_DEF_MASK defines which vm flags a process may inherit from
its parent?

> +	} else {
> +		mm->flags = default_dump_filter;
>  		mm->def_flags = 0;
> +	}
> +
> +	if (likely(!mm_alloc_pgd(mm))) {
>  		mmu_notifier_mm_init(mm);
>  		return mm;
>  	}
> diff --git a/kernel/sys.c b/kernel/sys.c
> index c0a58be..d59524a 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1996,6 +1996,23 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
>  		return current->no_new_privs ? 1 : 0;
> +	case PR_GET_THP_DISABLE:
> +		if (arg2 || arg3 || arg4 || arg5)
> +			return -EINVAL;

Please add

		/* fall through */

here.  So people don't think you added a bug.  Also, iirc there's a
static checking tool which will complain about this and there was talk
about using the /* fall through */ to suppress the warning.

> +	case PR_SET_THP_DISABLE:
> +		if (arg3 || arg4 || arg5)
> +			return -EINVAL;
> +		down_write(&me->mm->mmap_sem);
> +		if (option == PR_SET_THP_DISABLE) {
> +			if (arg2)
> +				me->mm->def_flags |= VM_NOHUGEPAGE;
> +			else
> +				me->mm->def_flags &= ~VM_NOHUGEPAGE;
> +		} else {
> +			error = !!(me->mm->def_flags & VM_NOHUGEPAGE);
> +		}
> +		up_write(&me->mm->mmap_sem);
> +		break;

I suspect it would be simpler to not try to combine the set and get
code in the same lump.

The prctl() extension should be added to user-facing documentation. 
Please work with Michael Kerrisk <mtk.manpages@gmail.com> on that.

