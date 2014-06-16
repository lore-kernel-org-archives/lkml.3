Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaFPQn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:43:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:46627 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbaFPQn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:43:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,487,1400050800"; 
   d="scan'208";a="529310267"
Message-ID: <1402937485.15603.21.camel@rage>
Subject: Re: [patch 2/5] futex: Use futex_top_waiter() in lookup_pi_state()
From: Darren Hart <darren@dvhart.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Date: Mon, 16 Jun 2014 09:51:25 -0700
In-Reply-To: <20140611204237.092947239@linutronix.de>
References: <20140611202744.676528190@linutronix.de>
	 <20140611204237.092947239@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 20:45 +0000, Thomas Gleixner wrote:
> No point in open coding the same function again.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/futex.c |  128
> ++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 63 insertions(+), 65 deletions(-)
> 
> Index: linux/kernel/futex.c
> ===================================================================
> --- linux.orig/kernel/futex.c
> +++ linux/kernel/futex.c
> @@ -796,87 +796,85 @@ static int
>  lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
>                 union futex_key *key, struct futex_pi_state **ps)
>  {
> +       struct futex_q *match = futex_top_waiter(hb, key);
>         struct futex_pi_state *pi_state = NULL;
> -       struct futex_q *this, *next;
>         struct task_struct *p;
>         pid_t pid = uval & FUTEX_TID_MASK;
>  
> -       plist_for_each_entry_safe(this, next, &hb->chain, list) {
> -               if (match_futex(&this->key, key)) {
> +       if (match) {
> +               /*
> +                * Sanity check the waiter before increasing the
> +                * refcount and attaching to it.
> +                */
> +               pi_state = match->pi_state;
> +               /*
> +                * Userspace might have messed up non-PI and PI
> +                * futexes [3]
> +                */
> +               if (unlikely(!pi_state))
> +                       return -EINVAL;
> +
> +               WARN_ON(!atomic_read(&pi_state->refcount));
> +
> +               /*
> +                * Handle the owner died case:
> +                */
> +               if (uval & FUTEX_OWNER_DIED) {
>                         /*
> -                        * Sanity check the waiter before increasing
> -                        * the refcount and attaching to it.
> +                        * exit_pi_state_list sets owner to NULL and
> +                        * wakes the topmost waiter. The task which
> +                        * acquires the pi_state->rt_mutex will fixup
> +                        * owner.
>                          */
> -                       pi_state = this->pi_state;
> -                       /*
> -                        * Userspace might have messed up non-PI and
> -                        * PI futexes [3]
> -                        */
> -                       if (unlikely(!pi_state))
> -                               return -EINVAL;
> -
> -                       WARN_ON(!atomic_read(&pi_state->refcount));
> -
> -                       /*
> -                        * Handle the owner died case:
> -                        */
> -                       if (uval & FUTEX_OWNER_DIED) {
> -                               /*
> -                                * exit_pi_state_list sets owner to
> NULL and
> -                                * wakes the topmost waiter. The task
> which
> -                                * acquires the pi_state->rt_mutex
> will fixup
> -                                * owner.
> -                                */
> -                               if (!pi_state->owner) {
> -                                       /*
> -                                        * No pi state owner, but the
> user
> -                                        * space TID is not 0.
> Inconsistent
> -                                        * state. [5]
> -                                        */
> -                                       if (pid)
> -                                               return -EINVAL;
> -                                       /*
> -                                        * Take a ref on the state and
> -                                        * return. [4]
> -                                        */
> -                                       goto out_state;
> -                               }
> -
> +                       if (!pi_state->owner) {
>                                 /*
> -                                * If TID is 0, then either the dying
> owner
> -                                * has not yet executed
> exit_pi_state_list()
> -                                * or some waiter acquired the rtmutex
> in the
> -                                * pi state, but did not yet fixup the
> TID in
> -                                * user space.
> -                                *
> -                                * Take a ref on the state and return.
> [6]
> +                                * No pi state owner, but the user
> +                                * space TID is not 0. Inconsistent
> +                                * state. [5]
>                                  */
> -                               if (!pid)
> -                                       goto out_state;
> -                       } else {
> +                               if (pid)
> +                                       return -EINVAL;
>                                 /*
> -                                * If the owner died bit is not set,
> -                                * then the pi_state must have an
> -                                * owner. [7]
> +                                * Take a ref on the state and
> +                                * return. [4]
>                                  */
> -                               if (!pi_state->owner)
> -                                       return -EINVAL;
> +                               goto out_state;
>                         }
>  
>                         /*
> -                        * Bail out if user space manipulated the
> -                        * futex value. If pi state exists then the
> -                        * owner TID must be the same as the user
> -                        * space TID. [9/10]
> +                        * If TID is 0, then either the dying owner
> +                        * has not yet executed exit_pi_state_list()
> +                        * or some waiter acquired the rtmutex in the
> +                        * pi state, but did not yet fixup the TID in
> +                        * user space.
> +                        *
> +                        * Take a ref on the state and return. [6]
>                          */
> -                       if (pid != task_pid_vnr(pi_state->owner))
> +                       if (!pid)
> +                               goto out_state;
> +               } else {
> +                       /*
> +                        * If the owner died bit is not set,
> +                        * then the pi_state must have an
> +                        * owner. [7]
> +                        */
> +                       if (!pi_state->owner)
>                                 return -EINVAL;
> -
> -               out_state:
> -                       atomic_inc(&pi_state->refcount);
> -                       *ps = pi_state;
> -                       return 0;
>                 }
> +
> +               /*
> +                * Bail out if user space manipulated the
> +                * futex value. If pi state exists then the
> +                * owner TID must be the same as the user
> +                * space TID. [9/10]
> +                */
> +               if (pid != task_pid_vnr(pi_state->owner))
> +                       return -EINVAL;
> +
> +       out_state:
> +               atomic_inc(&pi_state->refcount);
> +               *ps = pi_state;
> +               return 0;


Surely there is a better tool for viewing such "shift left one tab"
patches that don't make one track three if blocks in parallel in one's
head to ensure they all assemble back to the same thing? What do other
people use? Ouch...

Reviewed-by: Darren Hart <darren@dvhart.com>

--
Darren Hart
Intel Open Source Technology Center

