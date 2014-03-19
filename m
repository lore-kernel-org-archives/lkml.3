Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaCSTOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:14:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41901 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaCSTOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:14:53 -0400
Message-ID: <5329ECB5.9020002@arm.com>
Date: Wed, 19 Mar 2014 19:15:01 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
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
Subject: Re: [RFC 0/6] rework sched_domain topology description
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org> <5317B092.7070805@arm.com> <CAKfTPtDGbT717Y5F1GoBgr4pnvApG5Gphu2Me_bAFrM0+qsfAg@mail.gmail.com> <53186A8A.9060406@arm.com> <CAKfTPtCspVk+X3O23ikTt3MZUHVrrp21PyhmrcLF-GwW3OjOqA@mail.gmail.com> <531B0FDA.2040302@arm.com> <20140311131719.GY9987@twins.programming.kicks-ass.net> <532060E7.7010203@arm.com> <20140317115225.GZ9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140317115225.GZ9987@twins.programming.kicks-ass.net>
X-OriginalArrivalTime: 19 Mar 2014 19:15:02.0056 (UTC) FILETIME=[87000A80:01CF43A7]
X-MC-Unique: 114031919145101601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/14 11:52, Peter Zijlstra wrote:
> On Wed, Mar 12, 2014 at 01:28:07PM +0000, Dietmar Eggemann wrote:
[...]
>> By making it robust, I guess you mean that the core scheduler has to
>> check that the provided set-ups are sane, something like the following
>> code snippet in sd_init()
>>
>> if (WARN_ONCE(tl->sd_flags & ~TOPOLOGY_SD_FLAGS,
>> 		"wrong sd_flags in topology description\n"))
>> 	tl->sd_flags &= ~TOPOLOGY_SD_FLAGS;
>>
>> but for per cpu set-up's.
> 
> So a domain is principally a group of CPUs with the same properties.
> However per-cpu domain attributes allows you to specify different domain
> properties within the one domain mask.
> 
> That's completely broken.
> 
> So the way to validate something like that would be:
> 
> 	cpu = cpumask_first(tl->mask());
> 	flags = tl->flags(cpu);
> 
> 	for (;cpu = cpumask_next(cpu, tl->mask()), cpu < nr_cpu_ids;)
> 		BUG_ON(tl->flags(cpu) != flags);
> 
> Or something along those lines.

I tried this idea inside sd_init() on top of Vincent's V3 and it's doing
its job. 

> 
> But for me its far easier to think in the simple one domain one flags
> scenario. The whole degenerate folding is a very simple optimization
> simply removing redundant levels.
> 

For me, the approach with the 'int cpu' parameter in the flag function is
easier to understand. One of the things I had to grasp though was the fact that
we can only specify SD_SHARE_FOO flags and not SD_NOT_SHARE_FOO per domain.

-- >8 --

Subject: [PATCH] sched: check that the sd_flags are consistent in one domain

---
 arch/arm/kernel/topology.c |   13 +++++++++----
 include/linux/sched.h      |    6 +++---
 kernel/sched/core.c        |   11 +++++++++--
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 71e1fec6d31a..425f133c690d 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -275,15 +275,20 @@ void store_cpu_topology(unsigned int cpuid)
 		cpu_topology[cpuid].socket_id, mpidr);
 }
 
-static inline const int cpu_corepower_flags(void)
+//static inline const int cpu_corepower_flags(void)
+//{
+//	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
+//}
+
+static inline const int arm_cpu_core_flags(int cpu)
 {
-	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
+	return (cpu < 2) ? SD_SHARE_PKG_RESOURCES : SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
 }
 
 static struct sched_domain_topology_level arm_topology[] = {
 #ifdef CONFIG_SCHED_MC
-	{ cpu_corepower_mask, cpu_corepower_flags, SD_INIT_NAME(GMC) },
-	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
+//	{ cpu_corepower_mask, cpu_corepower_flags, SD_INIT_NAME(GMC) },
+	{ cpu_coregroup_mask, arm_cpu_core_flags, SD_INIT_NAME(MC) },
 #endif
 	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
 	{ NULL, },
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 05ce264e5144..45e5aa3d3e80 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -870,14 +870,14 @@ enum cpu_idle_type {
 #define SD_NUMA			0x4000	/* cross-node balancing */
 
 #ifdef CONFIG_SCHED_SMT
-static inline const int cpu_smt_flags(void)
+static inline const int cpu_smt_flags(int cpu)
 {
        return SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
 }
 #endif
 
 #ifdef CONFIG_SCHED_MC
-static inline const int cpu_core_flags(void)
+static inline const int cpu_core_flags(int cpu)
 {
        return SD_SHARE_PKG_RESOURCES;
 }
@@ -990,7 +990,7 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
 bool cpus_share_cache(int this_cpu, int that_cpu);
 
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
-typedef const int (*sched_domain_flags_f)(void);
+typedef const int (*sched_domain_flags_f)(int cpu);
 
 #define SDTL_OVERLAP   0x01
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f2ee6c72b13a..6b8ba837977c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5968,7 +5968,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
        sd_weight = cpumask_weight(tl->mask(cpu));
 
        if (tl->sd_flags)
-               sd_flags = (*tl->sd_flags)();
+               sd_flags = (*tl->sd_flags)(cpu);
        if (WARN_ONCE(sd_flags & ~TOPOLOGY_SD_FLAGS,
                        "wrong sd_flags in topology description\n"))
                sd_flags &= ~TOPOLOGY_SD_FLAGS;
@@ -6044,9 +6044,16 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
                sd->idle_idx = 1;
        }
 
+       if (tl->sd_flags) {
+	       int flags = (*tl->sd_flags)(cpumask_first(tl->mask(cpu)));
+
+	       for (;cpu = cpumask_next(cpu, tl->mask(cpu)), cpu < nr_cpu_ids;)
+		       BUG_ON((*tl->sd_flags)(cpu) != flags);
+       }
+
        sd->private = &tl->data;
 
-	return sd;
+       return sd;
 }
 
 /*
-- 
1.7.9.5





