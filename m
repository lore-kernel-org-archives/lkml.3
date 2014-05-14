Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaENToI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:44:08 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:62362 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaENToE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:44:04 -0400
Message-ID: <5372E1C6.5070109@gmail.com>
Date: Wed, 14 May 2014 05:23:50 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: Re: [PATCH 1/3] sched: Make sched_setattr() correctly return -EFBIG
References: <536CEAEE.4010609@gmail.com> <536CEC17.9070903@gmail.com>
In-Reply-To: <536CEC17.9070903@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

In the title of this patch, EFBIG should have been E2BIG. Shall
I resubmit a corrected version?

Cheers,

Michael

On 05/09/2014 04:54 PM, Michael Kerrisk (man-pages) wrote:
> From: Michael Kerrisk <mtk.manpages@gmail.com>
> 
> The documented[1] behavior of sched_attr() in your proposed man page text is:
> 
>     sched_attr::size must be set to the size of the structure, as in
>     sizeof(struct sched_attr), if the provided structure is smaller
>     than the kernel structure, any additional fields are assumed
>     '0'. If the provided structure is larger than the kernel structure,
>     the kernel verifies all additional fields are '0' if not the
>     syscall will fail with -E2BIG.
> 
> As currently implemented, sched_copy_attr() returns -EFBIG for
> for this case, but the logic in sys_sched_setattr() converts that
> error to -EFAULT. This patch fixes the behavior.
> 
> [1] http://thread.gmane.org/gmane.linux.kernel/1615615/focus=1697760
> 
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
> ---
>  kernel/sched/core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 268a45e..6c9ce28 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3650,8 +3650,9 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
>  	if (!uattr || pid < 0 || flags)
>  		return -EINVAL;
>  
> -	if (sched_copy_attr(uattr, &attr))
> -		return -EFAULT;
> +	retval = sched_copy_attr(uattr, &attr);
> +	if (retval)
> +		return retval;
>  
>  	rcu_read_lock();
>  	retval = -ESRCH;
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
