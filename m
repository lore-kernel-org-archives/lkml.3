Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934928Ab3DPJKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:10:34 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48727 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934807Ab3DPJKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:10:31 -0400
Date: Tue, 16 Apr 2013 11:10:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 2/3] mutex: Queue mutex spinners with MCS lock to
 reduce cacheline contention
Message-ID: <20130416091026.GB9569@gmail.com>
References: <1366036679-9702-1-git-send-email-Waiman.Long@hp.com>
 <1366036679-9702-3-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366036679-9702-3-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <Waiman.Long@hp.com> wrote:

> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3021,9 +3021,6 @@ static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
>   */
>  int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
>  {
> -	if (!sched_feat(OWNER_SPIN))
> -		return 0;
> -
>  	rcu_read_lock();
>  	while (owner_running(lock, owner)) {
>  		if (need_resched())
> @@ -3040,6 +3037,27 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
>  	 */
>  	return lock->owner == NULL;
>  }
> +
> +/*
> + * Initial check for entering the mutex spinning loop
> + */
> +int mutex_can_spin_on_owner(struct mutex *lock)
> +{
> +	int retval = 1;
> +
> +	if (!sched_feat(OWNER_SPIN))
> +		return 0;
> +
> +	rcu_read_lock();
> +	if (lock->owner)
> +		retval = lock->owner->on_cpu;
> +	rcu_read_unlock();
> +	/*
> +	 * if lock->owner is not set, the mutex owner may have just acquired
> +	 * it and not set the owner yet or the mutex has been released.
> +	 */
> +	return retval;
> +}

The SCHED_FEAT_OWNER_SPIN was really just an early hack we did to make 
with/without mutex-spinning testable.

I'd suggest a preparatory patch that gets rid of that flag and moves these two 
functions from sched/core.c to mutex.c where they belong.

This will also allow the removal of the mutex prototypes from sched.h.

Thanks,

	Ingo
