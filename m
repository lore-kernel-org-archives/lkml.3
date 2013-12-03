Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3LCBd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 20:33:29 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:35272 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3LCBd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 20:33:28 -0500
MIME-Version: 1.0
In-Reply-To: <x49ob4z700n.fsf@segfault.boston.devel.redhat.com>
References: <1385890077-30873-1-git-send-email-tom.leiming@gmail.com>
	<x49ob4z700n.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 3 Dec 2013 09:33:27 +0800
Message-ID: <CACVXFVMmPwOCoe9hU+mO6J2_9shEpRZUKdyt1Gni2Gjw3Zf8Qw@mail.gmail.com>
Subject: Re: [PATCH] block: fix mq request allocation
From: Ming Lei <tom.leiming@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Mon, Dec 2, 2013 at 11:20 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Ming Lei <tom.leiming@gmail.com> writes:
>
>> blk_mq_alloc_request_pinned() may return NULL request in case of
>> !__GFP_WAIT, so cause its callers to derefence NULL pointer for
>> releasing current context.
>>
>> This patch introduces two flags to address the issue.
>
> Hi, Ming,
>
>
> Good catch, but your patch seems overly complicated.  How about
> something like the following (compile-tested only), instead?  Note that

Looks your patch is better and simpler, :-)


> I did not touch blk_make_request, as the put_ctx there seems to
> correlate to a get_ctx earlier in the function (not a leaked reference
> from __blk_mq_alloc_request).
>
> -Jeff
>
> p.s. Jens, every time I see GFP_ATOMIC|__GFP_WAIT, my head explodes.  Just sayin'.
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Reported-by: Ming Lei <tom.leiming@gmail.com>

>
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index cdc629c..70fd6f9 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -202,10 +202,12 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
>                 if (rq) {
>                         blk_mq_rq_ctx_init(q, ctx, rq, rw);
>                         break;
> -               } else if (!(gfp & __GFP_WAIT))
> -                       break;
> +               }
>
>                 blk_mq_put_ctx(ctx);
> +               if (!(gfp & __GFP_WAIT))
> +                       break;
> +
>                 __blk_mq_run_hw_queue(hctx);
>                 blk_mq_wait_for_tags(hctx->tags);
>         } while (1);
> @@ -222,7 +224,8 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
>                 return NULL;
>
>         rq = blk_mq_alloc_request_pinned(q, rw, gfp, reserved);
> -       blk_mq_put_ctx(rq->mq_ctx);
> +       if (rq)
> +               blk_mq_put_ctx(rq->mq_ctx);
>         return rq;
>  }
>
> @@ -235,7 +238,8 @@ struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw,
>                 return NULL;
>
>         rq = blk_mq_alloc_request_pinned(q, rw, gfp, true);
> -       blk_mq_put_ctx(rq->mq_ctx);
> +       if (rq)
> +               blk_mq_put_ctx(rq->mq_ctx);
>         return rq;
>  }
>  EXPORT_SYMBOL(blk_mq_alloc_reserved_request);


Thanks,
-- 
Ming Lei
