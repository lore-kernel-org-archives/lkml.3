Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbaCEWjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:39:01 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50037 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaCEWi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:38:59 -0500
Message-ID: <5317A77C.8020501@arm.com>
Date: Wed, 05 Mar 2014 22:38:52 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
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
	<linux-arm-kernel@lists.infradead.org>
CC: "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC 6/6] sched: ARM: create a dedicated scheduler topology table
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org> <1394003906-11630-7-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1394003906-11630-7-git-send-email-vincent.guittot@linaro.org>
X-OriginalArrivalTime: 05 Mar 2014 22:39:01.0891 (UTC) FILETIME=[B4BA2530:01CF38C3]
X-MC-Unique: 114030522385600501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/14 07:18, Vincent Guittot wrote:
> Create a dedicated topology table for ARM which will create new level to
> differentiate CPUs that can or not powergate independantly from others.
> 
> The patch gives an example of how to add domain that will take advantage of
> SD_SHARE_POWERDOMAIN.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>   arch/arm/kernel/topology.c |   26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 0bc94b1..ae8ffbc 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -185,6 +185,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>   	return &cpu_topology[cpu].core_sibling;
>   }
>   
> +/*
> + * The current assumption is that we can power gate each core independently.
> + * This will be superseded by DT binding once available.
> + */
> +const struct cpumask *cpu_corepower_mask(int cpu)
> +{
> +	return &cpu_topology[cpu].thread_sibling;
> +}

Although you already explained this to me in a private conversation,
it's important to notice that running this set-up on a dual cluster TC2
(2 Cortex A15 - 3 Cortex A7) (no independent core power gating) we
don't see the SD_SHARE_POWERDOMAIN topology flag set in the sd's on MC
level because this patch-set doesn't contain the appropriate DT
parsing. Like you said back then, the comment above mentions this.

> +
>   static void update_siblings_masks(unsigned int cpuid)
>   {
>   	struct cputopo_arm *cpu_topo, *cpuid_topo = &cpu_topology[cpuid];
> @@ -266,6 +275,20 @@ void store_cpu_topology(unsigned int cpuid)
>   		cpu_topology[cpuid].socket_id, mpidr);
>   }
>   
> +static struct sched_domain_topology_level arm_topology[] = {
> +#ifdef CONFIG_SCHED_MC
> +	{ cpu_corepower_mask, SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN, SD_INIT_NAME(GMC) },
> +	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES, SD_INIT_NAME(MC) },
> +#endif
> +	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
> +	{ NULL, },
> +};
> +
> +static void __init set_sched_topology(void)
> +{
> +	sched_domain_topology = arm_topology;
> +}
> +
>   /*
>    * init_cpu_topology is called at boot when only one cpu is running
>    * which prevent simultaneous write access to cpu_topology array
> @@ -289,4 +312,7 @@ void __init init_cpu_topology(void)
>   	smp_wmb();
>   
>   	parse_dt_topology();
> +
> +	/* Set scheduler topology descriptor */
> +	set_sched_topology();
>   }
> 

How about the core scheduler provides an interface set_sched_topology()
instead of each arch has its own __init function? Sketched out below
for ARM.

-- >8 --
Subject: [PATCH] sched: set_sched_topology() as an interface of core scheduler

---
 arch/arm/kernel/topology.c | 7 +------
 include/linux/sched.h      | 2 +-
 kernel/sched/core.c        | 5 +++++
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index ae8ffbc..89d5592 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -284,11 +284,6 @@ static struct sched_domain_topology_level arm_topology[] = {
 	{ NULL, },
 };
 
-static void __init set_sched_topology(void)
-{
-	sched_domain_topology = arm_topology;
-}
-
 /*
  * init_cpu_topology is called at boot when only one cpu is running
  * which prevent simultaneous write access to cpu_topology array
@@ -314,5 +309,5 @@ void __init init_cpu_topology(void)
 	parse_dt_topology();
 
 	/* Set scheduler topology descriptor */
-	set_sched_topology();
+	set_sched_topology(arm_topology);
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8831413..fefd4e7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -998,7 +998,7 @@ struct sched_domain_topology_level {
 #endif
 };
 
-extern struct sched_domain_topology_level *sched_domain_topology;
+extern void set_sched_topology(struct sched_domain_topology_level *tl);
 
 #ifdef CONFIG_SCHED_DEBUG
 # define SD_INIT_NAME(type)            .name = #type
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b4fb0df..a748c92 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6105,6 +6105,11 @@ static struct sched_domain_topology_level default_topology[] = {
 
 struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+void set_sched_topology(struct sched_domain_topology_level *tl)
+{
+	sched_domain_topology = tl;
+}
+
 #define for_each_sd_topology(tl)                       \
        for (tl = sched_domain_topology; tl->mask; tl++)
 
-- 
1.8.3.2





