Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaIVLpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 07:45:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaIVLpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 07:45:44 -0400
Date: Mon, 22 Sep 2014 13:45:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        keescook@chromium.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH 2/3] sched: add a macro to define bitops for task atomic
 flags
Message-ID: <20140922114539.GC2832@worktop.localdomain>
References: <541F9C96.10705@huawei.com>
 <541F9CD4.5040407@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541F9CD4.5040407@huawei.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 11:51:48AM +0800, Zefan Li wrote:
> This will simplify code when we add new flags.
> 
> Signed-off-by: Zefan Li <lizefan@huawei.com>
> ---
>  include/linux/sched.h | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 4557765..04a2ae2 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1959,15 +1959,17 @@ static inline void memalloc_noio_restore(unsigned int flags)
>  /* Per-process atomic flags. */
>  #define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
>  
> -static inline bool task_no_new_privs(struct task_struct *p)
> -{
> -	return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
> -}
> -
> -static inline void task_set_no_new_privs(struct task_struct *p)
> -{
> -	set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
> -}
> +#define TASK_PFA_BITOPS(name, func)				\
> +static inline bool task_##func(struct task_struct *p)		\
> +{ return test_bit(PFA_##name, &p->atomic_flags); }		\
> +								\
> +static inline void task_set_##func(struct task_struct *p)	\
> +{ set_bit(PFA_##name, &p->atomic_flags); }			\
> +								\
> +static inline void task_clear_##func(struct task_struct *p)	\
> +{ clear_bit(PFA_##name, &p->atomic_flags); }
> +
> +TASK_PFA_BITOPS(NO_NEW_PRIVS, no_new_privs)

This could really do with a corresponding script/tags.sh update.

	--regex-c++='TASK_PFA_BITOPS\([^,]*,([^)]*)\)/task_\1/'
	--regex-c++='TASK_PFA_BITOPS\([^,]*,([^)]*)\)/task_set_\1/'
	--regex-c++='TASK_PFA_BITOPS\([^,]*,([^)]*)\)/task_clear_\1/'

For exhuberant and matching bits for emacs.
