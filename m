Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaG3PTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:19:01 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:52328 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbaG3PS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:18:59 -0400
Message-ID: <1406733536.3544.7.camel@j-VirtualBox>
Subject: Re: [PATCH -tip/master 4/7] locking/mutex: Refactor optimistic
 spinning code
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Jul 2014 08:18:56 -0700
In-Reply-To: <1406524724-17946-4-git-send-email-davidlohr@hp.com>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-4-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-27 at 22:18 -0700, Davidlohr Bueso wrote:

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
> +
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

Was it intended to remove the call to lock_acquired() which was
in the original code?

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


