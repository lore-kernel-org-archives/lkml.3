Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaBCRrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:47:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbaBCRrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:47:20 -0500
Date: Mon, 3 Feb 2014 18:46:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Jiang Liu <liuj97@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        liguang <lig.fnst@cn.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] Add VM_INIT_DEF_MASK and PRCTL_THP_DISABLE
Message-ID: <20140203174650.GA27592@redhat.com>
References: <1391192628-113858-1-git-send-email-athorlton@sgi.com> <1391192628-113858-5-git-send-email-athorlton@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391192628-113858-5-git-send-email-athorlton@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31, Alex Thorlton wrote:
>
> This patch adds a VM_INIT_DEF_MASK,

Perhaps it makes sense to tell a bit more... We add this mask to preserve
VM_NOHUGEPAGE after fork/exec. And this is obviously affects s390, say the
result of KVM_S390_ENABLE_SIE will be preserved.

I hope this is fine, but should be documented and it would be nice to have
the acks from Gerald.


> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1996,6 +1996,23 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
>  		return current->no_new_privs ? 1 : 0;
> +	case PR_GET_THP_DISABLE:
> +		if (arg2 || arg3 || arg4 || arg5)
> +			return -EINVAL;

Cosmetic, but PR_GET_THP_DISABLE only needs to check arg2.

OTOH,

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

Perhaps _GET_ doesn't even need ->mmap_sem, I do not see how the lockless
"&" can get the inconsistent result. But I am fine either way.

Oleg.

