Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab3CZMwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:52:45 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34973
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759271Ab3CZMwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:52:43 -0400
Message-ID: <1364302359.5053.21.camel@laptop>
Subject: Re: [RFC PATCH v3 5/6] sched: pack the idle load balance
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Date: Tue, 26 Mar 2013 13:52:39 +0100
In-Reply-To: <1363955155-18382-6-git-send-email-vincent.guittot@linaro.org>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	 <1363955155-18382-6-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
> Look for an idle CPU close to the pack buddy CPU whenever possible.
> The goal is to prevent the wake up of a CPU which doesn't share the
> power
> domain of the pack buddy CPU.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> Reviewed-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---
>  kernel/sched/fair.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b636199..52a7736 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5455,7 +5455,25 @@ static struct {
>  
>  static inline int find_new_ilb(int call_cpu)
>  {
> +       struct sched_domain *sd;
>         int ilb = cpumask_first(nohz.idle_cpus_mask);
> +       int buddy = per_cpu(sd_pack_buddy, call_cpu);
> +
> +       /*
> +        * If we have a pack buddy CPU, we try to run load balance on
> a CPU
> +        * that is close to the buddy.
> +        */
> +       if (buddy != -1)
> +               for_each_domain(buddy, sd) {
> +                       if (sd->flags & SD_SHARE_CPUPOWER)
> +                               continue;
> +
> +                       ilb = cpumask_first_and(sched_domain_span(sd),
> +                                       nohz.idle_cpus_mask);
> +
> +                       if (ilb < nr_cpu_ids)
> +                               break;
> +               }

/me hands you a fresh bucket of curlies, no reason to skimp on them.

But ha! here's your NO_HZ link.. but does the above DTRT and ensure
that the ILB is a little core when possible?


