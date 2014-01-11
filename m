Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaAKPxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 10:53:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaAKPxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 10:53:46 -0500
Date: Sat, 11 Jan 2014 16:53:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: thp: Add per-mm_struct flag to control THP
Message-ID: <20140111155337.GA16003@redhat.com>
References: <1389383718-46031-1-git-send-email-athorlton@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389383718-46031-1-git-send-email-athorlton@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Alex Thorlton wrote:
>
> This patch adds an mm flag (MMF_THP_DISABLE) to disable transparent
> hugepages using prctl.  It is based on my original patch to add a
> per-task_struct flag to disable THP:

I leave the "whether we need this feature" to other reviewers, although
personally I think it probably makes sense anyway.

But the patch doesn't look nice imho.

> @@ -373,7 +373,15 @@ extern int get_dumpable(struct mm_struct *mm);
>  #define MMF_HAS_UPROBES		19	/* has uprobes */
>  #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
>  
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#define MMF_THP_DISABLE		21	/* disable THP for this mm */
> +#define MMF_THP_DISABLE_MASK	(1 << MMF_THP_DISABLE)
> +
> +#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK | MMF_THP_DISABLE_MASK)
> +#else
>  #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
> +#endif

It would be nice to lessen the number of ifdef's. Why we can't define
MMF_THP_DISABLE unconditionally and include it into MMF_INIT_MASK?
Or define it == 0 if !CONFIG_THP. But this is minor.

> +#define PR_SET_THP_DISABLE	41
> +#define PR_CLEAR_THP_DISABLE	42
> +#define PR_GET_THP_DISABLE	43

Why we can't add 2 PR_'s, set and get?

> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -818,6 +818,7 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
>  	mm->pmd_huge_pte = NULL;
>  #endif
> +
>  	if (!mm_init(mm, tsk))
>  		goto fail_nomem;

Why? looks like the accidental change.

> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1835,6 +1835,42 @@ static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
>  }
>  #endif
>  
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +static int prctl_set_thp_disable(struct task_struct *me)
> +{
> +	set_bit(MMF_THP_DISABLE, &me->mm->flags);
> +	return 0;
> +}
> +
> +static int prctl_clear_thp_disable(struct task_struct *me)
> +{
> +	clear_bit(MMF_THP_DISABLE, &me->mm->flags);
> +	return 0;
> +}
> +
> +static int prctl_get_thp_disable(struct task_struct *me,
> +				  int __user *thp_disabled)
> +{
> +	return put_user(test_bit(MMF_THP_DISABLE, &me->mm->flags), thp_disabled);
> +}
> +#else
> +static int prctl_set_thp_disable(struct task_struct *me)
> +{
> +	return -EINVAL;
> +}
> +
> +static int prctl_clear_thp_disable(struct task_struct *me)
> +{
> +	return -EINVAL;
> +}
> +
> +static int prctl_get_thp_disable(struct task_struct *me,
> +				  int __user *thp_disabled)
> +{
> +	return -EINVAL;
> +}
> +#endif
> +
>  SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		unsigned long, arg4, unsigned long, arg5)
>  {
> @@ -1998,6 +2034,15 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
>  		return current->no_new_privs ? 1 : 0;
> +	case PR_SET_THP_DISABLE:
> +		error = prctl_set_thp_disable(me);
> +		break;
> +	case PR_CLEAR_THP_DISABLE:
> +		error = prctl_clear_thp_disable(me);
> +		break;
> +	case PR_GET_THP_DISABLE:
> +		error = prctl_get_thp_disable(me, (int __user *) arg2);
> +		break;
>  	default:
>  		error = -EINVAL;
>  		break;

I simply can't understand, this all looks like overkill. Can't you simply add

	#idfef CONFIG_TRANSPARENT_HUGEPAGE
	case GET:
		error = test_bit(MMF_THP_DISABLE);
		break;
	case PUT:
		if (arg2)
			set_bit();
		else
			clear_bit();
		break;
	#endif

into sys_prctl() ?	

Oleg.

