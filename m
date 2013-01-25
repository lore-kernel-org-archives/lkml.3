Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab3AYNag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:30:36 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54950 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab3AYNad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:30:33 -0500
MIME-Version: 1.0
In-Reply-To: <1359063833-17174-3-git-send-email-koverstreet@google.com>
References: <20130124211850.GH26407@google.com>
	<1359063833-17174-1-git-send-email-koverstreet@google.com>
	<1359063833-17174-3-git-send-email-koverstreet@google.com>
Date: Fri, 25 Jan 2013 21:30:32 +0800
Message-ID: <CAJd=RBAhW7GXUYhem=j2OJtLA9Ru98rLvbU9bJ9iQJm2=CCwog@mail.gmail.com>
Subject: Re: [PATCH 3/3] aio-use-cancellation-list-lazily-fix
From: Hillf Danton <dhillf@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, bcrl@kvack.org,
        zab@zabbo.net, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 5:43 AM, Kent Overstreet <koverstreet@google.com> wrote:
> The cancellation changes were fubar - we can't cancel a kiocb if it
> doesn't actually have a cancellation callback.
>
> The use of xchg() in aio_complete() was right - there we're marking the
> kiocb as completed - but we need to use cmpxchg() in kiocb_cancel() - a
> lock isn't sufficient since we're synchronizing with aio_complete()
> which isn't taking any locks.
>

What is observed without this fix?

> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---
>  fs/aio.c            | 32 ++++++++++++++++++++++----------
>  include/linux/aio.h | 11 +++++++++++
>  2 files changed, 33 insertions(+), 10 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 85d1b38..2760180 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -244,28 +244,40 @@ static int aio_setup_ring(struct kioctx *ctx)
>
>  void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
>  {
> -       if (!req->ki_list.next) {
> -               struct kioctx *ctx = req->ki_ctx;
> -               unsigned long flags;
> +       struct kioctx *ctx = req->ki_ctx;
> +       unsigned long flags;
>
> -               spin_lock_irqsave(&ctx->ctx_lock, flags);
> +       spin_lock_irqsave(&ctx->ctx_lock, flags);
> +
> +       if (!req->ki_list.next)
>                 list_add(&req->ki_list, &ctx->active_reqs);
> -               spin_unlock_irqrestore(&ctx->ctx_lock, flags);
> -       }
>
>         req->ki_cancel = cancel;
> +
> +       spin_unlock_irqrestore(&ctx->ctx_lock, flags);
>  }
>  EXPORT_SYMBOL(kiocb_set_cancel_fn);
>
>  static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
>                         struct io_event *res)
>  {
> -       kiocb_cancel_fn *cancel;
> +       kiocb_cancel_fn *old, *cancel;
>         int ret = -EINVAL;
>
> -       cancel = xchg(&kiocb->ki_cancel, KIOCB_CANCELLED);
> -       if (!cancel || cancel == KIOCB_CANCELLED)
> -               return ret;
> +       /*
> +        * Don't want to set kiocb->ki_cancel = KIOCB_CANCELLED unless it
> +        * actually has a cancel function, hence the cmpxchg()
> +        */
> +
> +       cancel = ACCESS_ONCE(kiocb->ki_cancel);
> +       do {
> +               if (!cancel || cancel == KIOCB_CANCELLED)
> +                       return ret;
> +
> +               BUG();

Hmm, what is trapped?

> +               old = cancel;
> +               cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
> +       } while (cancel != old);
>
>         atomic_inc(&kiocb->ki_users);
>         spin_unlock_irq(&ctx->ctx_lock);
> diff --git a/include/linux/aio.h b/include/linux/aio.h
> index 8eaa490..cd4aea0 100644
> --- a/include/linux/aio.h
> +++ b/include/linux/aio.h
> @@ -15,6 +15,17 @@ struct batch_complete;
>
>  #define KIOCB_KEY              0
>
> +/*
> + * We use ki_cancel == KIOCB_CANCELLED to indicate that a kiocb has been either
> + * cancelled or completed (this makes a certain amount of sense because
> + * successful cancellation - io_cancel() - does deliver the completion to
> + * userspace).
> + *
> + * And since most things don't implement kiocb cancellation and we'd really like
> + * kiocb completion to be lockless when possible, we use ki_cancel to
> + * synchronize cancellation and completion - we only set it to KIOCB_CANCELLED
> + * with xchg() or cmpxchg(), see batch_complete_aio() and kiocb_cancel().
> + */
>  #define KIOCB_CANCELLED                ((void *) (~0ULL))
>
>  typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
> --
> 1.7.12
>
