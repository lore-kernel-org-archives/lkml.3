Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab3DBOav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:30:51 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:58362 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761170Ab3DBOau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:30:50 -0400
MIME-Version: 1.0
In-Reply-To: <1364654108-16307-4-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
	<1364654108-16307-4-git-send-email-alex.shi@intel.com>
Date: Tue, 2 Apr 2013 16:30:48 +0200
Message-ID: <CAKfTPtArivjSsVn=Xc_421oqo+mXUfMaXhfyATK+s=xXO+P3eA@mail.gmail.com>
Subject: Re: [patch v6 03/21] sched: only count runnable avg on cfs_rq's nr_running
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 March 2013 15:34, Alex Shi <alex.shi@intel.com> wrote:
> Old function count the runnable avg on rq's nr_running even there is
> only rt task in rq. That is incorrect, so correct it to cfs_rq's
> nr_running.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2881d42..026e959 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2829,7 +2829,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>         }
>
>         if (!se) {
> -               update_rq_runnable_avg(rq, rq->nr_running);
> +               update_rq_runnable_avg(rq, rq->cfs.nr_running);

A RT task that preempts your CFS task will be accounted in the
runnable_avg fields. So whatever you do, RT task will impact your
runnable_avg statistics. Instead of trying to get only CFS tasks, you
should take into account all tasks activity in the rq.

Vincent
>                 inc_nr_running(rq);
>         }
>         hrtick_update(rq);
> --
> 1.7.12
>
