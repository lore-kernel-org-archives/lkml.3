Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbaAFSst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:48:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:9339 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351AbaAFSso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:48:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="434633869"
Message-ID: <1389034115.30730.32.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH 5/4] futex: silence uninitialized warnings
From: Darren Hart <dvhart@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com
Date: Mon, 06 Jan 2014 10:48:35 -0800
In-Reply-To: <1388972316.4918.5.camel@buesod1.americas.hpqcorp.net>
References: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
	 <1388972316.4918.5.camel@buesod1.americas.hpqcorp.net>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-05 at 17:38 -0800, Davidlohr Bueso wrote:
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

I've gone after such things myself and seen arguments against this as it
will mask any future such bugs. If, as in this case, the value is indeed
not being used uninitialized, I believe this is considered a compiler
bug. Do we mask compiler bugs in the kernel at the expense of catching
legitimate future bugs? There are certainly several examples of this
method being used throughout the kernel.

Alternatively - does anyone see something Davidlohr or I have missed in
this call chain? It seems to me that the only way for curval not be
initialized is if cmpxchg_futex_value_lock() returns an error, in which
case we return without using curval anyway.

Is there some rule about how to deal with this when inline ASM is
involved? (Although there is an explicit assignment following that ASM).

If not, given existing precedent, and the unlikelihood of this
particular path seeing significant changes, I'm inclined to agree with
the proposed fix:

Acked-by: Darren Hart <dvhart@linux.intel.com>

--
Darren

> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  kernel/futex.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 5b4d09e..65ade8a 100644
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

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


