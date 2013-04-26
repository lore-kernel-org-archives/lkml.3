Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab3DZKBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:01:01 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:59885 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3DZKBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:01:00 -0400
MIME-Version: 1.0
In-Reply-To: <1366910611-20048-12-git-send-email-vincent.guittot@linaro.org>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
	<1366910611-20048-12-git-send-email-vincent.guittot@linaro.org>
Date: Fri, 26 Apr 2013 12:00:58 +0200
Message-ID: <CAKfTPtCUvKmTHzyVRCkGyM-nWOSWP8OUzMgyCyzPEXf1NoxsQQ@mail.gmail.com>
Subject: Re: [PATCH 11/14] sched: filter task pull request
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of this patch is missing, the fix below is needed

@@ -3497,7 +3497,9 @@ static bool is_buddy_full(int cpu)
 static bool is_my_buddy(int cpu, int buddy)
 {
  int my_buddy = per_cpu(sd_pack_buddy, cpu);
- return (my_buddy == -1) || (buddy == my_buddy);
+
+ return ((sysctl_sched_packing_mode == SCHED_PACKING_FULL) &&
+               ((my_buddy == -1) || (buddy == my_buddy)));
 }

 static bool is_light_task(struct task_struct *p)


On 25 April 2013 19:23, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> Only CPUs that participates to the packing effort can pull tasks on a busiest
> group.
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 28f8ea7..6f63fb9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3494,6 +3494,12 @@ static bool is_buddy_full(int cpu)
>         return (sum * 1024 >= period * 1000);
>  }
>
> +static bool is_my_buddy(int cpu, int buddy)
> +{
> +       int my_buddy = per_cpu(sd_pack_buddy, cpu);
> +       return (my_buddy == -1) || (buddy == my_buddy);
> +}
> +
>  static bool is_light_task(struct task_struct *p)
>  {
>         /* A light task runs less than 20% in average */
> @@ -4688,8 +4694,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>
>                 /* Bias balancing toward cpus of our domain */
>                 if (local_group) {
> -                       if (idle_cpu(i) && !first_idle_cpu &&
> -                                       cpumask_test_cpu(i, sched_group_mask(group))) {
> +                       if (is_my_buddy(i, i) && idle_cpu(i) && !first_idle_cpu
> +                        && cpumask_test_cpu(i, sched_group_mask(group))) {
>                                 first_idle_cpu = 1;
>                                 balance_cpu = i;
>                         }
> @@ -4817,6 +4823,10 @@ static void update_plb_buddy(int cpu, int *balance, struct sd_lb_stats *sds,
>
>         /* Get my new buddy */
>         buddy = per_cpu(sd_pack_buddy, cpu);
> +
> +       /* This CPU doesn't act for agressive packing */
> +       if (buddy != cpu)
> +               sds->busiest = 0;
>  }
>
>  /**
> --
> 1.7.9.5
>
