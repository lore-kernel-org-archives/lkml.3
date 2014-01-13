Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaAMHwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 02:52:47 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:37637 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaAMHwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 02:52:41 -0500
MIME-Version: 1.0
In-Reply-To: <20140106113912.GC6178@suse.de>
References: <20140106113912.GC6178@suse.de>
Date: Mon, 13 Jan 2014 13:22:40 +0530
Message-ID: <CAM4v1pNQsoJxgC9Kwe+ca=hSbDYr3huNrchzqWEvs26AfypmSw@mail.gmail.com>
Subject: Re: [PATCH] sched: Calculate effective load even if local weight is 0
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 6, 2014 at 5:09 PM, Mel Gorman <mgorman@suse.de> wrote:
> (Rik, you authored this patch so it should be sent from you and needs a
> signed-off assuming people are ok with the changelog.)
>
> Thomas Hellstrom bisected a regression where erratic 3D performance is
> experienced on virtual machines as measured by glxgears. It identified
> commit 58d081b5 (sched/numa: Avoid overloading CPUs on a preferred NUMA
> node) as the problem which had modified the behaviour of effective_load.
>
> Effective load calculates the difference to the system-wide load if a
> scheduling entity was moved to another CPU. The task group is not heavier
> as a result of the move but overall system load can increase/decrease as a
> result of the change. Commit 58d081b5 (sched/numa: Avoid overloading CPUs
> on a preferred NUMA node) changed effective_load to make it suitable for
> calculating if a particular NUMA node was compute overloaded. To reduce
> the cost of the function, it assumed that a current sched entity weight
> of 0 was uninteresting but that is not the case.
>
> wake_affine uses a weight of 0 for sync wakeups on the grounds that it
> is assuming the waking task will sleep and not contribute to load in the
> near future. In this case, we still want to calculate the effective load
> of the sched entity hierarchy. As effective_load is no longer used by

Would it be worth mentioning that besides sync wakeups, wake_affine() uses a
weight of 0 for the sched entity, for effective load calculation on
the prev_cpu as well?
This is so as to find the effect of  moving this task away from the
prev_cpu. Here
too we are interested in calculating the effective load of the root
task group of this
sched entity on the prev_cpu and the below restored check will be relevant.

Without the below check the difference in the loads of the wake affine
CPU and the
prev_cpu can get messed up.

Thanks

Regards
Preeti U Murthy


> task_numa_compare since commit fb13c7ee (sched/numa: Use a system-wide
> search to find swap/migration candidates), this patch simply restores the
> historical behaviour.
>
> [mgorman@suse.de: Wrote changelog]
> Reported-and-tested-by: Thomas Hellstrom <thellstrom@vmware.com>
> Should-be-signed-off-and-authored-by-Rik
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c7395d9..e64b079 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3923,7 +3923,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>  {
>         struct sched_entity *se = tg->se[cpu];
>
> -       if (!tg->parent || !wl) /* the trivial, non-cgroup case */
> +       if (!tg->parent)        /* the trivial, non-cgroup case */
>                 return wl;
>
>         for_each_sched_entity(se) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
