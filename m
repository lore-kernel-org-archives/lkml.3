Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3CDTdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:33:14 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:50807 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3CDTdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:33:13 -0500
MIME-Version: 1.0
In-Reply-To: <20130304170508.GA11382@thunk.org>
References: <20130304073908.GA982@kroah.com>
	<1362384208-6687-1-git-send-email-Russ.Dill@gmail.com>
	<20130304170508.GA11382@thunk.org>
Date: Mon, 4 Mar 2013 11:33:11 -0800
Message-ID: <CA+Bv8XYkoRWdgoqaeXuTtLXKCuwNT2AY0PzrnOt1EDbbLqncEw@mail.gmail.com>
Subject: Re: [PATCH] Revert "random: Mix cputime from each thread that exits
 to the pool"
From: Russ Dill <russ.dill@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Russ Dill <russ.dill@gmail.com>,
        stable@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 9:05 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Russ, how about this patch instead?  Can you verify whether or not
> this fixes your issue?  If so, I'll push it to Linus.
>
>                                     - Ted

Yup, fixes the circular locking dependency.

Tested-by: Russ.Dill@gmail.com

> From 24c598b5abd466f2bab954d0cc8c225e0d3a2a74 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Mon, 4 Mar 2013 11:59:12 -0500
> Subject: [PATCH] random: fix locking dependency with the tasklist_lock
>
> Commit 6133705494bb introduced a circular lock dependency because
> posix_cpu_timers_exit() is called by release_task(), which is holding
> a writer lock on tasklist_lock, and this can cause a deadlock since
> kill_fasync() gets called with nonblocking_pool.lock taken.
>
> There's no reason why kill_fasync() needs to be taken while the random
> pool is locked, so move it out to fix this locking dependency.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Reported-by: Russ Dill <Russ.Dill@gmail.com>
> Cc: stable@kernel.org
> ---
>  drivers/char/random.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 85e81ec..57d4b15 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -852,6 +852,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
>                       int reserved)
>  {
>         unsigned long flags;
> +       int wakeup_write = 0;
>
>         /* Hold lock while accounting */
>         spin_lock_irqsave(&r->lock, flags);
> @@ -873,10 +874,8 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
>                 else
>                         r->entropy_count = reserved;
>
> -               if (r->entropy_count < random_write_wakeup_thresh) {
> -                       wake_up_interruptible(&random_write_wait);
> -                       kill_fasync(&fasync, SIGIO, POLL_OUT);
> -               }
> +               if (r->entropy_count < random_write_wakeup_thresh)
> +                       wakeup_write = 1;
>         }
>
>         DEBUG_ENT("debiting %zu entropy credits from %s%s\n",
> @@ -884,6 +883,11 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
>
>         spin_unlock_irqrestore(&r->lock, flags);
>
> +       if (wakeup_write) {
> +               wake_up_interruptible(&random_write_wait);
> +               kill_fasync(&fasync, SIGIO, POLL_OUT);
> +       }
> +
>         return nbytes;
>  }
>
> --
> 1.7.12.rc0.22.gcdd159b
>
