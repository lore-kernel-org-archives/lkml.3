Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3DLKLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 06:11:37 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38741 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3DLKLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 06:11:35 -0400
Message-ID: <1365761482.2543.43.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v2 cpuset] Don't pass offlined cpus to
 partition_sched_domains()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Date: Fri, 12 Apr 2013 18:11:22 +0800
In-Reply-To: <51667AE9.6030209@huawei.com>
References: <1364886990.5859.12.camel@ThinkPad-T5421.cn.ibm.com>
	 <515BF737.7070105@huawei.com>
	 <1365414692.2753.83.camel@ThinkPad-T5421.cn.ibm.com>
	 <1365501570.3597.64.camel@ThinkPad-T5421.cn.ibm.com>
	 <51667AE9.6030209@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041210-9264-0000-0000-000003809BE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 16:57 +0800, Li Zefan wrote:
> On 2013/4/9 17:59, Li Zhong wrote:
> > Hi Zefan, 
> > 
> > I did some test today, enabling cpuset and online/offline the cpus. It
> > caused NULL address dereferencing in get_group(). After adding some
> > debugging code, it seems that it is caused by using some offlined cpus
> > as the parameter to partition_sched_domains(). More details below:
> > 
> > ===================
> > following is printed in build_sched_domain(): 
> > @@ -6476,6 +6486,14 @@ struct sched_domain *build_sched_domain(struct
> > sched_domain_topology_level *tl,
> >                 return child;
> > 
> >         cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
> > +       if (cpumask_empty(sched_domain_span(sd)))
> > +               printk("lz empty domain %p, mask %pS\n", sd, tl->mask);
> > +       char cpulist[128];
> > +       cpumask_scnprintf(cpulist, sizeof(cpulist), cpu_map);
> > +       printk("lz cpu_map %s\n", cpulist);
> > +       cpumask_scnprintf(cpulist, sizeof(cpulist), tl->mask(cpu));
> > +       printk("lz tl->mask(%d) %pS %s\n",cpu, tl->mask, cpulist);
> > +
> >         if (child) {
> >                 sd->level = child->level + 1;
> >                 sched_domain_level_max = max(sched_domain_level_max,
> > sd->level);
> > 
> > [  232.714502] lz empty domain c0000001f73c0000, mask cpu_smt_mask
> > +0x0/0x10
> > [  232.714515] lz cpu_map 1-2,7,13-15
> > [  232.714521] lz tl->mask(1) cpu_smt_mask+0x0/0x10
> > [  232.714529] lz cpu_map 1-2,7,13-15
> > [  232.714536] lz tl->mask(1) cpu_cpu_mask+0x0/0x10 2,7,13-15
> > [  232.714544] lz cpu_map 1-2,7,13-15
> > [  232.714551] lz tl->mask(1) sd_numa_mask+0x0/0x10 2,7,13-15
> > [  232.714558] lz cpu_map 1-2,7,13-15
> > [  232.714565] lz tl->mask(2) cpu_smt_mask+0x0/0x10 2
> > ===================
> > 
> > It seems that one cpu (#1 of the above) could be taken offline in
> > cpuset_hotplug_workfn(), after top_cpuset's allowed cpus changed and the
> > propagated work function finished. But generate_sched_domains(), which
> > uses the cpuset information, still considers this cpu (#1) valid, and
> > passes it down in the cpumask to partition_sched_domains(). Then we have
> > an empty sd as the above. 
> > 
> 
> Thanks for the test and analysis!
> 
> So the bug was caused when the cpuset async cpuset handling hasn't been
> finished, and at this time user triggered another hotplug operation, right?

Seems so, the summary is very clear :)

> Then I think we should wait cpuset to finish its work before starting
> a new hotplug operation.

en.

> This should fix the bug you observed, and it should also fix another bug,
> that the 2nd schedule_work(&cpuset_hotplug_work) returns true, and so
> the root cpuset.cpus won't be updated.

OK, I just realized that the work can only have one instance... 

As schedule_work returns false if work already in the queue, so I guess
we should check against false.

And it seems to me that we also need the logic in cpu_up path, for
similar reasons, or WARN_ON might be triggered, and cpuset cpu info
won't get updated.

> Could you test this patch?

Seems it works, with the above two changes.

For your convenience, the final code I used for testing is attached
below. 

Thanks, Zhong

---
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 8c8a60d..d3ba31d 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -119,6 +119,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 	task_unlock(current);
 }
 
+extern void cpuset_flush_hotplug_work(void);
+
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init(void) { return 0; }
@@ -233,6 +235,10 @@ static inline bool put_mems_allowed(unsigned int seq)
 	return true;
 }
 
+static inline void cpuset_flush_hotplug_work(void)
+{
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index b5e4ab2..6eb914b 100644
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
@@ -352,6 +360,13 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct task_struct *idle;
 
+	/*
+	 * cpuset handles cpu/memory hotplug asynchronously, so it's possible
+	 * that cpuset hasn't finished it's hotplug work for the previous
+	 * hotplug operation.
+	 */
+	cpuset_flush_hotplug_work();
+
 	cpu_hotplug_begin();
 
 	if (cpu_online(cpu) || !cpu_present(cpu)) {
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4f9dfe4..6222c2c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2152,6 +2152,14 @@ static void schedule_cpuset_propagate_hotplug(struct cpuset *cs)
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
@@ -2237,6 +2245,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 
 void cpuset_update_active_cpus(bool cpu_online)
 {
+	bool queued;
+
 	/*
 	 * We're inside cpu hotplug critical region which usually nests
 	 * inside cgroup synchronization.  Bounce actual hotplug processing
@@ -2248,7 +2258,8 @@ void cpuset_update_active_cpus(bool cpu_online)
 	 * cpuset_hotplug_workfn() will rebuild it as necessary.
 	 */
 	partition_sched_domains(1, NULL, NULL);
-	schedule_work(&cpuset_hotplug_work);
+	queued = schedule_work(&cpuset_hotplug_work);
+	WARN_ON(!queued);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG


