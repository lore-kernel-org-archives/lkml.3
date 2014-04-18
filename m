Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaDRQYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:24:39 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57912 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaDRQYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140418150653.GB12515@htj.dyndns.org>
References: <20140417162720.GQ15326@htj.dyndns.org>
	<1397827555-19641-1-git-send-email-laijs@cn.fujitsu.com>
	<1397827555-19641-2-git-send-email-laijs@cn.fujitsu.com>
	<20140418150653.GB12515@htj.dyndns.org>
Date: Sat, 19 Apr 2014 00:24:32 +0800
X-Google-Sender-Auth: qHVFouXDoEYRGFgshtUSPujNU7c
Message-ID: <CACvQF51a-babdUSBiREEsSv=1keiQCTJh-sZFrtFXn9iUHegOw@mail.gmail.com>
Subject: Re: [PATCH 2/2] workqueue: fix a possible race condition between
 rescuer and pwq-release
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 11:06 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> Applied to wq/for-3.15-fixes with put_pwq() relocated and patch
> description and comments updated.
>
> Thanks.
> -------- 8< --------
> From 4b81955722abe4306096c7b0137e0491a7ba7b0e Mon Sep 17 00:00:00 2001
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date: Fri, 18 Apr 2014 11:04:16 -0400
>
> There is a race condition between rescuer_thread() and
> pwq_unbound_release_workfn().
>
> Even after a pwq is scheduled for rescue, the associated work items
> may be consumed by any worker.  If all of them are consumed before the
> rescuer gets to them and the pwq's base ref was put due to attribute
> change, the pwq may be released while still being linked on
> @wq->maydays list making the rescuer dereference already freed pwq
> later.
>
> Make send_mayday() pin the target pwq until the rescuer is done with
> it.
>
> tj: Updated comment and patch description.  Moved put_pwq() to after
>     the last @pwq->pool access.  This isn't strictly necessarily for
>     correctness but is cleaner as the pool is accessed through the
>     pwq.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: stable@vger.kernel.org # v3.10+
> ---
>  kernel/workqueue.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 6ba0c60..a6532f2 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1916,6 +1916,12 @@ static void send_mayday(struct work_struct *work)
>
>         /* mayday mayday mayday */
>         if (list_empty(&pwq->mayday_node)) {
> +               /*
> +                * If @pwq is for an unbound wq, its base ref may be put at
> +                * any time due to an attribute change.  Pin @pwq until the
> +                * rescuer is done with it.
> +                */
> +               get_pwq(pwq);
>                 list_add_tail(&pwq->mayday_node, &wq->maydays);
>                 wake_up_process(wq->rescuer->task);
>         }
> @@ -2459,6 +2465,7 @@ repeat:
>
>                 rescuer->pool = NULL;
>                 spin_unlock(&pool->lock);
> +               put_pwq(pwq);   /* put the ref from send_mayday() */

put_pwq() requires pool->lock held.

>                 spin_lock(&wq_mayday_lock);
>         }
>
> --
> 1.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
