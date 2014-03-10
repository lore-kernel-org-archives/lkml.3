Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaCJJwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:52:10 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:50280 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaCJJwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:52:08 -0400
MIME-Version: 1.0
In-Reply-To: <7hk3cx46rw.fsf@paris.lan>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
	<52F8A51F.4090909@cn.fujitsu.com>
	<20140210184729.GL4250@linux.vnet.ibm.com>
	<20140212182336.GD5496@localhost.localdomain>
	<20140212190241.GD4250@linux.vnet.ibm.com>
	<20140212192354.GC26809@htj.dyndns.org>
	<7hk3cx46rw.fsf@paris.lan>
Date: Mon, 10 Mar 2014 17:52:07 +0800
X-Google-Sender-Auth: frGoegS3F1McCP1TV6AFKSlTiqc
Message-ID: <CAOh2x=nODso5o-GQ1Eih=oP4w7n=+qgUzYD1vXvKHsQmVL1n6g@mail.gmail.com>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient workqueue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 7:24 AM, Kevin Hilman <khilman@linaro.org> wrote:
> From 902a2b58d61a51415457ea6768d687cdb7532eff Mon Sep 17 00:00:00 2001
> From: Kevin Hilman <khilman@linaro.org>
> Date: Fri, 14 Feb 2014 15:10:58 -0800
> Subject: [PATCH] workqueue: for NO_HZ_FULL, set default cpumask to
>  !tick_nohz_full_mask
>
> To help in keeping NO_HZ_FULL CPUs isolated, keep unbound workqueues
> from running on full dynticks CPUs.  To do this, set the default
> workqueue cpumask to be the set of "housekeeping" CPUs instead of all
> possible CPUs.
>
> This is just just the starting/default cpumask, and can be overridden
> with all the normal ways (NUMA settings, apply_workqueue_attrs and via
> sysfs for workqueus with the WQ_SYSFS attribute.)
>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
>  kernel/workqueue.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 987293d03ebc..9a9d9b0eaf6d 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -48,6 +48,7 @@
>  #include <linux/nodemask.h>
>  #include <linux/moduleparam.h>
>  #include <linux/uaccess.h>
> +#include <linux/tick.h>
>
>  #include "workqueue_internal.h"
>
> @@ -3436,7 +3437,11 @@ struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask)
>         if (!alloc_cpumask_var(&attrs->cpumask, gfp_mask))
>                 goto fail;
>
> +#ifdef CONFIG_NO_HZ_FULL
> +       cpumask_complement(attrs->cpumask, tick_nohz_full_mask);
> +#else
>         cpumask_copy(attrs->cpumask, cpu_possible_mask);
> +#endif
>         return attrs;
>  fail:
>         free_workqueue_attrs(attrs);

Can we play with this mask at runtime? I thought a better idea would be
to keep this mask as mask of all CPUs initially and once any CPU enters
NO_HZ_FULL mode we can remove that from mask? And ones it leaves
that mode we can get that added again..

I am looking to use similar concept in case of un-pinned timers with my
activity around cpuset.quiesce option..
