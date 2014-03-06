Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaCFImf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:42:35 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:48615 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaCFImd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:42:33 -0500
MIME-Version: 1.0
In-Reply-To: <5317A77C.8020501@arm.com>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
 <1394003906-11630-7-git-send-email-vincent.guittot@linaro.org> <5317A77C.8020501@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 6 Mar 2014 16:42:13 +0800
Message-ID: <CAKfTPtCDoLCxnud8OgUTWzUu8SNQv7e36Z_85=-A6j0zveNkuQ@mail.gmail.com>
Subject: Re: [RFC 6/6] sched: ARM: create a dedicated scheduler topology table
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2014 06:38, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 05/03/14 07:18, Vincent Guittot wrote:
>> Create a dedicated topology table for ARM which will create new level to
>> differentiate CPUs that can or not powergate independantly from others.
>>
>> The patch gives an example of how to add domain that will take advantage of
>> SD_SHARE_POWERDOMAIN.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

[snip]

>>
>>       parse_dt_topology();
>> +
>> +     /* Set scheduler topology descriptor */
>> +     set_sched_topology();
>>   }
>>
>
> How about the core scheduler provides an interface set_sched_topology()
> instead of each arch has its own __init function? Sketched out below
> for ARM.

yes, i will add it

>
> -- >8 --
> Subject: [PATCH] sched: set_sched_topology() as an interface of core scheduler
>
> ---
>  arch/arm/kernel/topology.c | 7 +------
>  include/linux/sched.h      | 2 +-
>  kernel/sched/core.c        | 5 +++++
>  3 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index ae8ffbc..89d5592 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -284,11 +284,6 @@ static struct sched_domain_topology_level arm_topology[] = {
>         { NULL, },
>  };
>
> -static void __init set_sched_topology(void)
> -{
> -       sched_domain_topology = arm_topology;
> -}
> -
>  /*
>   * init_cpu_topology is called at boot when only one cpu is running
>   * which prevent simultaneous write access to cpu_topology array
> @@ -314,5 +309,5 @@ void __init init_cpu_topology(void)
>         parse_dt_topology();
>
>         /* Set scheduler topology descriptor */
> -       set_sched_topology();
> +       set_sched_topology(arm_topology);
>  }
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8831413..fefd4e7 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -998,7 +998,7 @@ struct sched_domain_topology_level {
>  #endif
>  };
>
> -extern struct sched_domain_topology_level *sched_domain_topology;
> +extern void set_sched_topology(struct sched_domain_topology_level *tl);
>
>  #ifdef CONFIG_SCHED_DEBUG
>  # define SD_INIT_NAME(type)            .name = #type
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b4fb0df..a748c92 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6105,6 +6105,11 @@ static struct sched_domain_topology_level default_topology[] = {
>
>  struct sched_domain_topology_level *sched_domain_topology = default_topology;
>
> +void set_sched_topology(struct sched_domain_topology_level *tl)
> +{
> +       sched_domain_topology = tl;
> +}
> +
>  #define for_each_sd_topology(tl)                       \
>         for (tl = sched_domain_topology; tl->mask; tl++)
>
> --
> 1.8.3.2
>
>
>
>
>
