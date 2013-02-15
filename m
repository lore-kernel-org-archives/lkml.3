Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161030Ab3BOCpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 21:45:42 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55428 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3BOCpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 21:45:40 -0500
MIME-Version: 1.0
In-Reply-To: <1360279763-4768-1-git-send-email-sustrik@250bpm.com>
References: <1360279763-4768-1-git-send-email-sustrik@250bpm.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Fri, 15 Feb 2013 03:45:20 +0100
Message-ID: <CAHXqBFKpByeeLPD5ibDxTW94wsLA3hSnqhakZ_8YQO_BDT7ruQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
To: Martin Sustrik <sustrik@250bpm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/8 Martin Sustrik <sustrik@250bpm.com>:
> When implementing network protocols in user space, one has to implement
> fake user-space file descriptors to represent the sockets for the protocol.
[...]
> This patch implements new EFD_MASK flag which attempts to solve this problem.
[...]
> @@ -55,6 +64,9 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
>  {
>         unsigned long flags;
>
> +       /* This function should never be used with eventfd in the mask mode. */
> +       BUG_ON(ctx->flags & EFD_MASK);
> +
>         spin_lock_irqsave(&ctx->wqh.lock, flags);
>         if (ULLONG_MAX - ctx->count < n)
>                 n = ULLONG_MAX - ctx->count;
> @@ -123,12 +135,16 @@ static unsigned int eventfd_poll(struct file *file, poll_table *wait)
>         poll_wait(file, &ctx->wqh, wait);
>
>         spin_lock_irqsave(&ctx->wqh.lock, flags);
> -       if (ctx->count > 0)
> -               events |= POLLIN;
> -       if (ctx->count == ULLONG_MAX)
> -               events |= POLLERR;
> -       if (ULLONG_MAX - 1 > ctx->count)
> -               events |= POLLOUT;
> +       if (ctx->flags & EFD_MASK) {
> +               events = ctx->mask.events;
> +       } else {
> +               if (ctx->count > 0)
> +                       events |= POLLIN;
> +               if (ctx->count == ULLONG_MAX)
> +                       events |= POLLERR;
> +               if (ULLONG_MAX - 1 > ctx->count)
> +                       events |= POLLOUT;
> +       }
>         spin_unlock_irqrestore(&ctx->wqh.lock, flags);
>
>         return events;
[...]
> @@ -412,7 +464,12 @@ struct file *eventfd_file_create(unsigned int count, int flags)
>
>         kref_init(&ctx->kref);
>         init_waitqueue_head(&ctx->wqh);
> -       ctx->count = count;
> +       if (flags & EFD_MASK) {
> +               ctx->mask.events = 0;
> +               ctx->mask.ptr = NULL;
> +       } else {
> +               ctx->count = count;
> +       }
>         ctx->flags = flags;
>
>         file = anon_inode_getfile("[eventfd]", &eventfd_fops, ctx,

Since EFD_MASK is a persistent flag for a fd's lifetime, maybe you
could instead of all those if/elses and BUG_ON()s use another
file_operations struct for this feature?

Best Regards,
Michał Mirosław
