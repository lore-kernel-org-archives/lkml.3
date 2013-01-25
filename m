Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab3AYNPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:15:40 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:37851 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab3AYNPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:15:37 -0500
MIME-Version: 1.0
In-Reply-To: <1359063833-17174-1-git-send-email-koverstreet@google.com>
References: <20130124211850.GH26407@google.com>
	<1359063833-17174-1-git-send-email-koverstreet@google.com>
Date: Fri, 25 Jan 2013 21:15:37 +0800
Message-ID: <CAJd=RBBFxLeSporsG9xZH=g9G1xCvsmFuu1uQr0CtOa2YntDVA@mail.gmail.com>
Subject: Re: [PATCH 1/3] aio: Fix a null pointer deref in batch_complete_aio
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
> The batch completion code was trying to be a bit too clever, and skip
> checking ctx where it couldn't be NULL - but that broke if a kiocb had
> been cancelled. Move the check to kioctx_ring_unlock().
>
> Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---

Acked-by: Hillf Danton <dhillf@gmail.com>

>  fs/aio.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 62573d3..0d2f39d 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -683,6 +683,9 @@ static inline void kioctx_ring_unlock(struct kioctx *ctx, unsigned tail)
>  {
>         struct aio_ring *ring;
>
> +       if (!ctx)
> +               return;
> +
>         smp_wmb();
>         /* make event visible before updating tail */
>
> @@ -760,8 +763,7 @@ void batch_complete_aio(struct batch_complete *batch)
>                 }
>
>                 if (unlikely(req->ki_ctx != ctx)) {
> -                       if (ctx)
> -                               kioctx_ring_unlock(ctx, tail);
> +                       kioctx_ring_unlock(ctx, tail);
>
>                         ctx = req->ki_ctx;
>                         tail = kioctx_ring_lock(ctx);
> --
> 1.7.12
>
