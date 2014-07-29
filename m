Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaG2Dlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 23:41:46 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:5484 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaG2Dll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 23:41:41 -0400
Message-ID: <1406605299.2411.59.camel@j-VirtualBox>
Subject: Re: [PATCH -tip/master v2] locking/mutex: Refactor optimistic
 spinning code
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2014 20:41:39 -0700
In-Reply-To: <1406602517.31161.2.camel@buesod1.americas.hpqcorp.net>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-4-git-send-email-davidlohr@hp.com>
	 <1406602517.31161.2.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 19:55 -0700, Davidlohr Bueso wrote:
> +static bool mutex_optimistic_spin(struct mutex *lock,
> +				  struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
> +{
> +	struct task_struct *task = current;
> +
> +	if (!mutex_can_spin_on_owner(lock))
> +		return false;
> +
> +	if (!osq_lock(&lock->osq))
> +		return false;

In the !osq_lock() case, we could exit the cancellable MCS spinlock due
to need_resched(). However, this would return from the function rather
than doing the need_resched() check below. Perhaps we can add something
like "goto out" which goes to the below check?

The mutex_can_spin_on_owner() also returns false if need_resched().

> +	while (true) {
> +		struct task_struct *owner;
> +
> +		if (use_ww_ctx && ww_ctx->acquired > 0) {
> +			struct ww_mutex *ww;
> +
> +			ww = container_of(lock, struct ww_mutex, base);
> +			/*
> +			 * If ww->ctx is set the contents are undefined, only
> +			 * by acquiring wait_lock there is a guarantee that
> +			 * they are not invalid when reading.
> +			 *
> +			 * As such, when deadlock detection needs to be
> +			 * performed the optimistic spinning cannot be done.
> +			 */
> +			if (ACCESS_ONCE(ww->ctx))
> +				break;
> +		}
> +
> +		/*
> +		 * If there's an owner, wait for it to either
> +		 * release the lock or go to sleep.
> +		 */
> +		owner = ACCESS_ONCE(lock->owner);
> +		if (owner && !mutex_spin_on_owner(lock, owner))
> +			break;
> +
> +		/* Try to acquire the mutex if it is unlocked. */
> +		if (mutex_try_to_acquire(lock)) {
> +			if (use_ww_ctx) {
> +				struct ww_mutex *ww;
> +				ww = container_of(lock, struct ww_mutex, base);
> +
> +				ww_mutex_set_context_fastpath(ww, ww_ctx);
> +			}
> +
> +			mutex_set_owner(lock);
> +			osq_unlock(&lock->osq);
> +			return true;
> +		}
> +
> +		/*
> +		 * When there's no owner, we might have preempted between the
> +		 * owner acquiring the lock and setting the owner field. If
> +		 * we're an RT task that will live-lock because we won't let
> +		 * the owner complete.
> +		 */
> +		if (!owner && (need_resched() || rt_task(task)))
> +			break;
> +
> +		/*
> +		 * The cpu_relax() call is a compiler barrier which forces
> +		 * everything in this loop to be re-loaded. We don't need
> +		 * memory barriers as we'll eventually observe the right
> +		 * values at the cost of a few extra spins.
> +		 */
> +		cpu_relax_lowlatency();
> +	}
> +
> +	osq_unlock(&lock->osq);
> +
> +	/*
> +	 * If we fell out of the spin path because of need_resched(),
> +	 * reschedule now, before we try-lock the mutex. This avoids getting
> +	 * scheduled out right after we obtained the mutex.
> +	 */
> +	if (need_resched())
> +		schedule_preempt_disabled();
> +
> +	return false;
> +}


