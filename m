Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaEHNUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:20:46 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35449 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbaEHNUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:20:45 -0400
MIME-Version: 1.0
In-Reply-To: <1399480621-19555-7-git-send-email-fweisbec@gmail.com>
References: <1399480621-19555-1-git-send-email-fweisbec@gmail.com>
	<1399480621-19555-7-git-send-email-fweisbec@gmail.com>
Date: Thu, 8 May 2014 21:20:45 +0800
X-Google-Sender-Auth: r15jAWEg9R7L-x_40EEnPRg8nCU
Message-ID: <CACvQF526QozPynmw46k36qZvPJFU1Tk0S5ii35zMH7dhCYNUzg@mail.gmail.com>
Subject: Re: [PATCH 6/6] workqueue: Record real per-workqueue cpumask
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 12:37 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> The real cpumask set by the user on WQ_SYSFS workqueues fails to be
> recorded as is: What is actually recorded as per workqueue attribute
> is the per workqueue cpumask intersected with the global unbounds cpumask.
>
> Eventually when the user overwrites a WQ_SYSFS cpumask and later read
> this attibute, the value returned is not the last one written.
>
> The other bad side effect is that widening the global unbounds cpumask
> doesn't actually widen the unbound workqueues affinity because their
> own cpumask has been schrinked.
>
> In order to fix this, lets record the real per workqueue cpumask on the
> workqueue struct. We restore this value when attributes are re-evaluated
> later.
>
> FIXME: Maybe I should rather invert that. Have the user set workqueue
> cpumask on attributes and the effective one on the workqueue struct instead.
> We'll just need some tweaking in order to make the attributes of lower layers
> (pools, worker pools, worker, ...) to inherit the effective cpumask and not
> the user one.
>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Mike Galbraith <bitbucket@online.de>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/workqueue.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 5978cee..504cf0a 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -248,6 +248,7 @@ struct workqueue_struct {
>         int                     saved_max_active; /* WQ: saved pwq max_active */
>
>         struct workqueue_attrs  *unbound_attrs; /* WQ: only for unbound wqs */
> +       cpumask_var_t           saved_cpumask;  /* WQ: only for unbound wqs */


Forgot to use it? or use it in next patches?

>         struct pool_workqueue   *dfl_pwq;       /* WQ: only for unbound wqs */
>
>  #ifdef CONFIG_SYSFS
> @@ -3694,6 +3695,7 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
>         mutex_lock(&wq->mutex);
>
>         copy_workqueue_attrs(wq->unbound_attrs, new_attrs);
> +       cpumask_copy(wq->saved_cpumask, attrs->cpumask);

I think you can use ->unbound_attrs directly:
          copy_workqueue_attrs(wq->unbound_attrs, attrs);

and update wq_update_unbound_numa():
         copy_workqueue_attrs(tmp_attrs, wq->unbound_attrs);
         cpumask_and(&tmp_attrs->cpumask, wq_unbound_cpumask)

use tmp_attr instead of wq->unbound_attrs in the left code of
wq_update_unbound_numa()

>
>         /* save the previous pwq and install the new one */
>         for_each_node(node)
> @@ -4326,6 +4328,11 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
>                 wq->unbound_attrs = alloc_workqueue_attrs(GFP_KERNEL);
>                 if (!wq->unbound_attrs)
>                         goto err_free_wq;
> +
> +               if (!alloc_cpumask_var(&wq->saved_cpumask, GFP_KERNEL))
> +                       goto err_free_wq;
> +
> +               cpumask_copy(wq->saved_cpumask, cpu_possible_mask);
>         }
>
>         va_start(args, lock_name);
> @@ -4397,6 +4404,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
>         return wq;
>
>  err_free_wq:
> +       free_cpumask_var(wq->saved_cpumask);
>         free_workqueue_attrs(wq->unbound_attrs);
>         kfree(wq);
>         return NULL;
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
