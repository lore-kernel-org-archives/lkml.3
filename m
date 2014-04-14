Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaDNNNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:13:44 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:43094 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaDNNNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:13:42 -0400
MIME-Version: 1.0
In-Reply-To: <3760742.KPOjd8C4i8@daeseok-laptop.cloud.net>
References: <3760742.KPOjd8C4i8@daeseok-laptop.cloud.net>
Date: Mon, 14 Apr 2014 21:13:42 +0800
X-Google-Sender-Auth: yAivqtFMWTt5PZNQ_iYRzNVYLqU
Message-ID: <CACvQF5036uEas=7i7gMQW7M5XnhxH93N3jDYJGXBRK6oNh5o7Q@mail.gmail.com>
Subject: Re: [PATCH V2] workqueue: fix double unlock bug
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 6:41 PM, Daeseok Youn <daeseok.youn@gmail.com> wrote:
>
> mutex_unlock() and put_pwq_unlocked() do not need to be called
> when alloc_unbound_pwq() is failed.
>
> And remove "if" condition for whether "pwq" is same as "wq->dfl_pwq"
> when wq_calc_node_cpumask() returns false and just use "goto use_dfl_pwq"
>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> V2: replace "if condition" with "goto" as Lai's comment.
>
>  kernel/workqueue.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 0ee63af..9853067 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4087,10 +4087,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
>                 if (cpumask_equal(cpumask, pwq->pool->attrs->cpumask))
>                         goto out_unlock;
>         } else {
> -               if (pwq == wq->dfl_pwq)
> -                       goto out_unlock;
> -               else
> -                       goto use_dfl_pwq;
> +               goto use_dfl_pwq;
>         }
>
>         mutex_unlock(&wq->mutex);
> @@ -4100,7 +4097,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
>         if (!pwq) {
>                 pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
>                            wq->name);
> -               goto out_unlock;
> +               return;

Please acquire the  wq->mutex and goto use_dfl_pwq;

>         }
>
>         /*
> --
> 1.7.4.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
