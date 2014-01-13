Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaAMKQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:16:34 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:59789 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaAMKQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:16:32 -0500
Date: Mon, 13 Jan 2014 11:16:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com
Subject: Re: [PATCH 5/5] futex: Silence uninitialized warnings
Message-ID: <20140113101628.GA8270@gmail.com>
References: <1389569486-25487-1-git-send-email-davidlohr@hp.com>
 <1389569486-25487-6-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389569486-25487-6-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> From: Davidlohr Bueso <davidlohr@hp.com>
> 
> Callers of cmpxchg_futex_value_locked() can trigger the following:
> 
> kernel/futex.c: In function ‘futex_lock_pi_atomic’:
> kernel/futex.c:725: warning: ‘curval’ may be used uninitialized in this function
> 
> This was initially addressed by commit 7cfdaf38, but others still remain. Silence
> these messages once and for all as the variables really aren't uninitialized.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Acked-by: Darren Hart <dvhart@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Scott Norton <scott.norton@hp.com>
> Cc: Tom Vaden <tom.vaden@hp.com>
> Cc: Aswin Chandramouleeswaran <aswin@hp.com>
> Cc: Waiman Long <Waiman.Long@hp.com>
> Cc: Jason Low <jason.low2@hp.com>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  kernel/futex.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index be6399a..8d40953 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -838,7 +838,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
>  				struct task_struct *task, int set_waiters)
>  {
>  	int lock_taken, ret, force_take = 0;
> -	u32 uval, newval, curval, vpid = task_pid_vnr(task);
> +	u32 uval, newval, uninitialized_var(curval), vpid = task_pid_vnr(task);
>  
>  retry:
>  	ret = lock_taken = 0;
> @@ -2227,7 +2227,7 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
>  	struct futex_hash_bucket *hb;
>  	struct futex_q *this, *next;
>  	union futex_key key = FUTEX_KEY_INIT;
> -	u32 uval, vpid = task_pid_vnr(current);
> +	u32 uninitialized_var(uval), vpid = task_pid_vnr(current);
>  	int ret;
>  
>  retry:
> @@ -2843,7 +2843,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
>  
>  static int __init futex_init(void)
>  {
> -	u32 curval;
> +	u32 uninitialized_var(curval);
>  	unsigned long i;
>  
>  #if CONFIG_BASE_SMALL

I'm skipping this patch though.

I consider the use of uninitialized_var() dangerous and broken: if for 
whatever reason a future change to the code makes the warning trigger 
and makes it _true_, then we won't notice it because it's hidden 
unconditionally ...

The following alternative measures can be used to make spurious 
old-compiler warnings go away:

 - Consider upgrading your compiler.

 - If for whatever reason you can't upgrade your compiler then
   restructure the code so that the flow of logic is more apparent 
   even to older GCC versions. (Chances are that the flow will be more 
   readable to humans too, so it's a win-win!)

 - If you think the flow is exactly perfect and (older) GCC which you
   cannot upgrade is still being silly, then initialize the variable
   to zero. On a new compiler this won't mean a thing because GCC will 
   notice the superfluous initialization and will optimize it out -
   and it's a lot safer than just shutting the warning up forever.

Thanks,

	Ingo
