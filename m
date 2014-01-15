Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaAOPUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:20:11 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:9338 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaAOPUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:20:07 -0500
Message-ID: <52D6A710.7040309@hp.com>
Date: Wed, 15 Jan 2014 10:19:44 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        aswin@hp.com, scott.norton@hp.com
Subject: Re: [RFC 3/3] mutex: When there is no owner, stop spinning after
 too many tries
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com> <1389745990-7069-4-git-send-email-jason.low2@hp.com>
In-Reply-To: <1389745990-7069-4-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 07:33 PM, Jason Low wrote:
> When running workloads that have high contention in mutexes on an 8 socket
> machine, spinners would often spin for a long time with no lock owner.
>
> One of the potential reasons for this is because a thread can be preempted
> after clearing lock->owner but before releasing the lock, or preempted after
> acquiring the mutex but before setting lock->owner. In those cases, the
> spinner cannot check if owner is not on_cpu because lock->owner is NULL.
>
> A solution that would address the preemption part of this problem would
> be to disable preemption between acquiring/releasing the mutex and
> setting/clearing the lock->owner. However, that will require adding overhead
> to the mutex fastpath.
>
> The solution used in this patch is to limit the # of times thread can spin on
> lock->count when !owner.
>
> The threshold used in this patch for each spinner was 128, which appeared to
> be a generous value, but any suggestions on another method to determine
> the threshold are welcomed.
>
> Signed-off-by: Jason Low<jason.low2@hp.com>
> ---
>   kernel/locking/mutex.c |   10 +++++++---
>   1 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index b500cc7..9465604 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -43,6 +43,7 @@
>    * mutex.
>    */
>   #define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count)>= 0)
> +#define	MUTEX_SPIN_THRESHOLD		(128)
>
>   void
>   __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
> @@ -418,7 +419,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>   	struct task_struct *task = current;
>   	struct mutex_waiter waiter;
>   	unsigned long flags;
> -	int ret;
> +	int ret, nr_spins = 0;
>   	struct mspin_node node;
>
>   	preempt_disable();
> @@ -453,6 +454,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>   	mspin_lock(MLOCK(lock),&node);
>   	for (;;) {
>   		struct task_struct *owner;
> +		nr_spins++;
>
>   		if (use_ww_ctx&&  ww_ctx->acquired>  0) {
>   			struct ww_mutex *ww;
> @@ -502,9 +504,11 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>   		 * When there's no owner, we might have preempted between the
>   		 * owner acquiring the lock and setting the owner field. If
>   		 * we're an RT task that will live-lock because we won't let
> -		 * the owner complete.
> +		 * the owner complete. Additionally, when there is no owner,
> +		 * stop spinning after too many tries.
>   		 */
> -		if (!owner&&  (need_resched() || rt_task(task))) {
> +		if (!owner&&  (need_resched() || rt_task(task) ||
> +		               nr_spins>  MUTEX_SPIN_THRESHOLD)) {
>   			mspin_unlock(MLOCK(lock),&node);
>   			goto slowpath;
>   		}

The time that a thread spent on one iteration of the loop can be highly 
variable. Instead of a predefined iteration count, you may consider 
setting an elapsed time limit on how long  a thread can spin in the loop 
using changes in jiffies as a proxy. Let say setting a limit of 40ms. On 
a 1000Hz system, a changes of 40 or more in jiffies will indicate it is 
time to leave and go to the slowpath.

-Longman
