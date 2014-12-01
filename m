Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaLAAxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:53:18 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:43797 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaLAAxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:53:16 -0500
MIME-Version: 1.0
In-Reply-To: <1417021067-4853-1-git-send-email-bobby.prani@gmail.com>
References: <1417021067-4853-1-git-send-email-bobby.prani@gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 30 Nov 2014 19:52:45 -0500
Message-ID: <CAJhHMCDg0AE8Mbo1Xank4azU2zq2dtS=sC-sD7KqC8eR9hF4KQ@mail.gmail.com>
Subject: Re: [RFC PATCH] set_mb: Use smp_store_release() instead of set_mb()
To: Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        "open list:OVERLAYFS FILESYSTEM" <linux-fsdevel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 11:57 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> set_mb() and smp_store_release() perform the same function. Also there are only
> a few users of set_mb(). We can convert these users to use smp_store_release()
> and delete the set_mb() definition.
>
> The following patch changes the users and if this is OK I will go ahead and
> delete the set_mb() definition. Comments and suggestions welcome.
>
> Thanks!
> Pranith
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Please disregard this patch. I just realized that I read the code
wrong. Sorry for the noise.

Thanks!


> ---
>  fs/select.c           |  6 +++---
>  include/linux/sched.h | 14 +++++++-------
>  kernel/futex.c        |  4 ++--
>  kernel/sched/wait.c   |  4 ++--
>  4 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/fs/select.c b/fs/select.c
> index 467bb1c..959a908 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -189,7 +189,7 @@ static int __pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
>          * doesn't imply write barrier and the users expect write
>          * barrier semantics on wakeup functions.  The following
>          * smp_wmb() is equivalent to smp_wmb() in try_to_wake_up()
> -        * and is paired with set_mb() in poll_schedule_timeout.
> +        * and is paired with smp_store_release() in poll_schedule_timeout.
>          */
>         smp_wmb();
>         pwq->triggered = 1;
> @@ -244,7 +244,7 @@ int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
>         /*
>          * Prepare for the next iteration.
>          *
> -        * The following set_mb() serves two purposes.  First, it's
> +        * The following smp_store_release() serves two purposes.  First, it's
>          * the counterpart rmb of the wmb in pollwake() such that data
>          * written before wake up is always visible after wake up.
>          * Second, the full barrier guarantees that triggered clearing
> @@ -252,7 +252,7 @@ int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
>          * this problem doesn't exist for the first iteration as
>          * add_wait_queue() has full barrier semantics.
>          */
> -       set_mb(pwq->triggered, 0);
> +       smp_store_release(pwq->triggered, 0);
>
>         return rc;
>  }
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8db31ef..4621d0b 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -253,7 +253,7 @@ extern char ___assert_task_state[1 - 2*!!(
>  #define set_task_state(tsk, state_value)                       \
>         do {                                                    \
>                 (tsk)->task_state_change = _THIS_IP_;           \
> -               set_mb((tsk)->state, (state_value));            \
> +               smp_store_release((tsk)->state, (state_value)); \
>         } while (0)
>
>  /*
> @@ -272,10 +272,10 @@ extern char ___assert_task_state[1 - 2*!!(
>                 current->task_state_change = _THIS_IP_;         \
>                 current->state = (state_value);                 \
>         } while (0)
> -#define set_current_state(state_value)                         \
> -       do {                                                    \
> -               current->task_state_change = _THIS_IP_;         \
> -               set_mb(current->state, (state_value));          \
> +#define set_current_state(state_value)                                 \
> +       do {                                                            \
> +               current->task_state_change = _THIS_IP_;                 \
> +               smp_store_release(current->state, (state_value));       \
>         } while (0)
>
>  #else
> @@ -283,7 +283,7 @@ extern char ___assert_task_state[1 - 2*!!(
>  #define __set_task_state(tsk, state_value)             \
>         do { (tsk)->state = (state_value); } while (0)
>  #define set_task_state(tsk, state_value)               \
> -       set_mb((tsk)->state, (state_value))
> +       smp_store_release((tsk)->state, (state_value))
>
>  /*
>   * set_current_state() includes a barrier so that the write of current->state
> @@ -299,7 +299,7 @@ extern char ___assert_task_state[1 - 2*!!(
>  #define __set_current_state(state_value)               \
>         do { current->state = (state_value); } while (0)
>  #define set_current_state(state_value)                 \
> -       set_mb(current->state, (state_value))
> +       smp_store_release(current->state, (state_value))
>
>  #endif
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 63678b5..0604355 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2055,8 +2055,8 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
>  {
>         /*
>          * The task state is guaranteed to be set before another task can
> -        * wake it. set_current_state() is implemented using set_mb() and
> -        * queue_me() calls spin_unlock() upon completion, both serializing
> +        * wake it. set_current_state() is implemented using smp_store_release()
> +        * and queue_me() calls spin_unlock() upon completion, both serializing
>          * access to the hash list and forcing another memory barrier.
>          */
>         set_current_state(TASK_INTERRUPTIBLE);
> diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
> index 852143a..7d990c0 100644
> --- a/kernel/sched/wait.c
> +++ b/kernel/sched/wait.c
> @@ -341,7 +341,7 @@ long wait_woken(wait_queue_t *wait, unsigned mode, long timeout)
>          * condition being true _OR_ WQ_FLAG_WOKEN such that we will not miss
>          * an event.
>          */
> -       set_mb(wait->flags, wait->flags & ~WQ_FLAG_WOKEN); /* B */
> +       smp_store_release(wait->flags, wait->flags & ~WQ_FLAG_WOKEN); /* B */
>
>         return timeout;
>  }
> @@ -354,7 +354,7 @@ int woken_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
>          * doesn't imply write barrier and the users expects write
>          * barrier semantics on wakeup functions.  The following
>          * smp_wmb() is equivalent to smp_wmb() in try_to_wake_up()
> -        * and is paired with set_mb() in wait_woken().
> +        * and is paired with smp_store_release() in wait_woken().
>          */
>         smp_wmb(); /* C */
>         wait->flags |= WQ_FLAG_WOKEN;
> --
> 1.9.1
>



-- 
Pranith
