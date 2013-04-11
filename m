Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161600Ab3DKI50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:57:26 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25225 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462Ab3DKI5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:57:24 -0400
Message-ID: <51667AE9.6030209@huawei.com>
Date: Thu, 11 Apr 2013 16:57:13 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <tj@kernel.org>
Subject: Re: [RFC PATCH v2 cpuset] Don't pass offlined cpus to partition_sched_domains()
References: <1364886990.5859.12.camel@ThinkPad-T5421.cn.ibm.com>  <515BF737.7070105@huawei.com>  <1365414692.2753.83.camel@ThinkPad-T5421.cn.ibm.com> <1365501570.3597.64.camel@ThinkPad-T5421.cn.ibm.com>
In-Reply-To: <1365501570.3597.64.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/9 17:59, Li Zhong wrote:
> Hi Zefan, 
> 
> I did some test today, enabling cpuset and online/offline the cpus. It
> caused NULL address dereferencing in get_group(). After adding some
> debugging code, it seems that it is caused by using some offlined cpus
> as the parameter to partition_sched_domains(). More details below:
> 
> ===================
> following is printed in build_sched_domain(): 
> @@ -6476,6 +6486,14 @@ struct sched_domain *build_sched_domain(struct
> sched_domain_topology_level *tl,
>                 return child;
> 
>         cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
> +       if (cpumask_empty(sched_domain_span(sd)))
> +               printk("lz empty domain %p, mask %pS\n", sd, tl->mask);
> +       char cpulist[128];
> +       cpumask_scnprintf(cpulist, sizeof(cpulist), cpu_map);
> +       printk("lz cpu_map %s\n", cpulist);
> +       cpumask_scnprintf(cpulist, sizeof(cpulist), tl->mask(cpu));
> +       printk("lz tl->mask(%d) %pS %s\n",cpu, tl->mask, cpulist);
> +
>         if (child) {
>                 sd->level = child->level + 1;
>                 sched_domain_level_max = max(sched_domain_level_max,
> sd->level);
> 
> [  232.714502] lz empty domain c0000001f73c0000, mask cpu_smt_mask
> +0x0/0x10
> [  232.714515] lz cpu_map 1-2,7,13-15
> [  232.714521] lz tl->mask(1) cpu_smt_mask+0x0/0x10
> [  232.714529] lz cpu_map 1-2,7,13-15
> [  232.714536] lz tl->mask(1) cpu_cpu_mask+0x0/0x10 2,7,13-15
> [  232.714544] lz cpu_map 1-2,7,13-15
> [  232.714551] lz tl->mask(1) sd_numa_mask+0x0/0x10 2,7,13-15
> [  232.714558] lz cpu_map 1-2,7,13-15
> [  232.714565] lz tl->mask(2) cpu_smt_mask+0x0/0x10 2
> ===================
> 
> It seems that one cpu (#1 of the above) could be taken offline in
> cpuset_hotplug_workfn(), after top_cpuset's allowed cpus changed and the
> propagated work function finished. But generate_sched_domains(), which
> uses the cpuset information, still considers this cpu (#1) valid, and
> passes it down in the cpumask to partition_sched_domains(). Then we have
> an empty sd as the above. 
> 

Thanks for the test and analysis!

So the bug was caused when the cpuset async cpuset handling hasn't been
finished, and at this time user triggered another hotplug operation, right?

Then I think we should wait cpuset to finish its work before starting
a new hotplug operation.

This should fix the bug you observed, and it should also fix another bug,
that the 2nd schedule_work(&cpuset_hotplug_work) returns true, and so
the root cpuset.cpus won't be updated.

Could you test this patch?

--
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index ccd1de8..ece226c 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -118,6 +118,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 	task_unlock(current);
 }
 
+extern void cpuset_flush_hotplug_work(void);
+
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init(void) { return 0; }
@@ -232,6 +234,10 @@ static inline bool put_mems_allowed(unsigned int seq)
 	return true;
 }
 
+static inline void cpuset_flush_hotplug_work(void)
+{
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index b5e4ab2..283a993 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/suspend.h>
+#include <linux/cpuset.h>
 
 #include "smpboot.h"
 
@@ -278,6 +279,13 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
+	/*
+	 * cpuset handles cpu/memory hotplug asynchronously, so it's possible
+	 * that cpuset hasn't finished it's hotplug work for the previous
+	 * hotplug operation.
+	 */
+	cpuset_flush_hotplug_work();
+
 	cpu_hotplug_begin();
 
 	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c55763b..9bb5018 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2141,6 +2141,14 @@ static void schedule_cpuset_propagate_hotplug(struct cpuset *cs)
 }
 
 /**
+ * cpuset_flush_hotplug_work() - wait cpuset hotplug work to finish
+ */
+void cpuset_flush_hotplug_work(void)
+{
+	flush_work(&cpuset_hotplug_work);
+}
+
+/**
  * cpuset_hotplug_workfn - handle CPU/memory hotunplug for a cpuset
  *
  * This function is called after either CPU or memory configuration has
@@ -2226,6 +2234,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 
 void cpuset_update_active_cpus(bool cpu_online)
 {
+	bool queued;
+
 	/*
 	 * We're inside cpu hotplug critical region which usually nests
 	 * inside cgroup synchronization.  Bounce actual hotplug processing
@@ -2237,7 +2247,8 @@ void cpuset_update_active_cpus(bool cpu_online)
 	 * cpuset_hotplug_workfn() will rebuild it as necessary.
 	 */
 	partition_sched_domains(1, NULL, NULL);
-	schedule_work(&cpuset_hotplug_work);
+	queued = schedule_work(&cpuset_hotplug_work);
+	WARN_ON(queued);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG


> With the empty domain, in get_group(),
>         if (child)
>                 cpu = cpumask_first(sched_domain_span(child));
> 
> this might cause the cpu to be returned a value >= nr_cpu_ids, then
> cause bad dereference with the wrong cpu value in the later code. 
> 
> This following code tries to fix the issue by anding the cpu_active_mask
> at the end of generate_sched_domains() for each partition. This might
> result the partiton (set of domains) not the best one, but we know
> another rebuild (caused by the cpu offline in the middle of
> cpuset_hotplug_workfn()) is on the way. 
> 
> Also it seems that generate_sched_domains() needs be called together
> with partition_sched_domains(), under the hotplug lock. Or similarly,
> one cpu might be taken offline while doing generate_sched_domains(), and
> cause the above issue. 
> 
> Or maybe we could put the whole cpuset_hotplug_workfn() into the hotplug
> lock? 

