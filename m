Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaG3PKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:10:35 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:29546 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbaG3PKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:10:34 -0400
Message-ID: <1406733032.3544.2.camel@j-VirtualBox>
Subject: Re: [PATCH -tip/master 2/7] locking/mutex: Document quick lock
 release when unlocking
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Jul 2014 08:10:32 -0700
In-Reply-To: <1406524724-17946-2-git-send-email-davidlohr@hp.com>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-2-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-27 at 22:18 -0700, Davidlohr Bueso wrote:
> When unlocking, we always want to reach the slowpath with the lock's counter
> indicating it is unlocked. -- as returned by the asm fastpath call or by
> explicitly setting it. While doing so, at least in theory, we can optimize
> and allow faster lock stealing.
> 
> This is not immediately obvious and deserves to be documented.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  kernel/locking/mutex.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index ad0e333..7a9be39 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -676,7 +676,8 @@ EXPORT_SYMBOL_GPL(__ww_mutex_lock_interruptible);
>  #endif
>  
>  /*
> - * Release the lock, slowpath:
> + * Release the lock, slowpath.
> + *  At this point, the lock counter is 0 or negative.

Hmm, so in the !__mutex_slowpath_needs_to_unlock() case, we could enter
this function with the lock count == 1 right?

>   */
>  static inline void
>  __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
> @@ -684,9 +685,16 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
>  	unsigned long flags;
>  
>  	/*
> -	 * some architectures leave the lock unlocked in the fastpath failure
> +	 * As a performance measurement, release the lock before doing other
> +	 * wakeup related duties to follow. This allows other tasks to acquire
> +	 * the lock sooner, while still handling cleanups in past unlock calls.
> +	 * This can be done as we do not enforce strict equivalence between the
> +	 * mutex counter and wait_list.
> +	 *
> +	 *
> +	 * Some architectures leave the lock unlocked in the fastpath failure
>  	 * case, others need to leave it locked. In the later case we have to
> -	 * unlock it here
> +	 * unlock it here.
>  	 */
>  	if (__mutex_slowpath_needs_to_unlock())
>  		atomic_set(&lock->count, 1);


