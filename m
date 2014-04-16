Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422813AbaDPQWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:22:44 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:52800 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbaDPQWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <58237829.Dxp0IlFuXc@daeseok-laptop.cloud.net>
References: <58237829.Dxp0IlFuXc@daeseok-laptop.cloud.net>
Date: Thu, 17 Apr 2014 00:22:41 +0800
X-Google-Sender-Auth: JFlL0dQLFoXb-wRTL3mIVllE_C0
Message-ID: <CACvQF52acD74ZKZeLL5M-vQKH5E+QH0bTXAS-H18rJYAVk-NuQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] workqueue: fix bugs in wq_update_unbound_numa()
 failure path
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked.

On Wed, Apr 16, 2014 at 1:32 PM, Daeseok Youn <daeseok.youn@gmail.com> wrote:
>
> wq_update_unbound_numa() failure path has the following two bugs.
>  - alloc_unbound_pwq() is called without holding wq->mutex;
>  however, if the allocation fails, it jumps to out_unlock
>  which tries to unlock wq->mutex.
>
>  - The function should switch to dfl_pwq on failure
>  but didn't do so after alloc_unbound_pwq() failure.
>
> Fix it by regrabbing wq->mutex and jumping to use_dfl_pwq on
> alloc_unbound_pwq() failure.
>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  kernel/workqueue.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 0ee63af..3150b21 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4100,7 +4100,8 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
>         if (!pwq) {
>                 pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
>                            wq->name);
> -               goto out_unlock;
> +               mutex_lock(&wq->mutex);
> +               goto use_dfl_pwq;
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
