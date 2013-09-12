Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3ILOcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:32:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:58986 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3ILOcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:32:10 -0400
Date: Thu, 12 Sep 2013 16:32:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: dvhart@linux.intel.com, ccross@android.com, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/futex.c: notice the return value after
 rt_mutex_finish_proxy_lock() fails
In-Reply-To: <5212DD71.7070208@asianux.com>
Message-ID: <alpine.DEB.2.02.1309121627040.4089@ionos.tec.linutronix.de>
References: <5212DD71.7070208@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Chen Gang wrote:

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
> -		/*
> -		 * If fixup_owner() returned an error, proprogate that.  If it
> -		 * acquired the lock, clear -ETIMEDOUT or -EINTR.
> -		 */
> -		if (res)
> -			ret = (res < 0) ? res : 0;
> +		if (!ret) {

Again. This is completely wrong!  

We MUST call fixup_owner even if finish_proxy_lock() returned with an
error code. Simply because finish_proxy_lock() is called outside of
the spin_lock(q.lock_ptr) region and another thread might have
modified the futex state. So we need to handle the corner cases
otherwise we might leave the futex in some undefined state.

You're reintroducing a hard to decode bug, which got analyzed and
fixed in futex_lock_pi() years ago. See the history for the
explanation.

Sigh.

	tglx



