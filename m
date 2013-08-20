Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab3HTQTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:19:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:49539 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab3HTQTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,921,1367996400"; 
   d="scan'208";a="390339162"
Message-ID: <1377015589.12131.110.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH] kernel/futex.c: notice the return value after
 rt_mutex_finish_proxy_lock() fails
From: Darren Hart <dvhart@linux.intel.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, ccross@android.com,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 20 Aug 2013 09:19:49 -0700
In-Reply-To: <5212DD71.7070208@asianux.com>
References: <5212DD71.7070208@asianux.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4 (3.8.4-1.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HopingOn Tue, 2013-08-20 at 11:07 +0800, Chen Gang wrote:


Hi Chen,

> rt_mutex_finish_proxy_lock() can return failure code (e.g. -EINTR,
> -ETIMEDOUT).
> 
> Original implementation has already noticed about it, but not check it
> before next work.
> 
> Also let coments within 80 columns to pass "./scripts/checkpatch.pl".
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/futex.c |   30 ++++++++++++++++--------------
>  1 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index c3a1a55..1a94e7d 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2373,21 +2373,23 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
>  		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
>  		debug_rt_mutex_free_waiter(&rt_waiter);
>  
> -		spin_lock(q.lock_ptr);
> -		/*
> -		 * Fixup the pi_state owner and possibly acquire the lock if we
> -		 * haven't already.
> -		 */
> -		res = fixup_owner(uaddr2, &q, !ret);


This call catches a corner case which appears to be skipped now. Or am I
missing how you accounted for that?


> -		/*
> -		 * If fixup_owner() returned an error, proprogate that.  If it
> -		 * acquired the lock, clear -ETIMEDOUT or -EINTR.
> -		 */
> -		if (res)
> -			ret = (res < 0) ? res : 0;
> +		if (!ret) {
> +			spin_lock(q.lock_ptr);
> +			/*
> +			 * Fixup the pi_state owner and possibly acquire the
> +			 * lock if we haven't already.
> +			 */
> +			res = fixup_owner(uaddr2, &q, !ret);
> +			/*
> +			 * If fixup_owner() returned an error, proprogate that.
> +			 * If it acquired the lock, clear -ETIMEDOUT or -EINTR.
> +			 */
> +			if (res)
> +				ret = (res < 0) ? res : 0;
>  
> -		/* Unqueue and drop the lock. */
> -		unqueue_me_pi(&q);
> +			/* Unqueue and drop the lock. */
> +			unqueue_me_pi(&q);
> +		}
>  	}
>  
>  	/*

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


