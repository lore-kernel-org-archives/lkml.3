Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181Ab3DIJ7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:59:45 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38792 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935428Ab3DIJ7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:59:44 -0400
Message-ID: <1365501570.3597.64.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [RFC PATCH v2 cpuset] Don't pass offlined cpus to
 partition_sched_domains()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Date: Tue, 09 Apr 2013 17:59:30 +0800
In-Reply-To: <1365414692.2753.83.camel@ThinkPad-T5421.cn.ibm.com>
References: <1364886990.5859.12.camel@ThinkPad-T5421.cn.ibm.com>
	 <515BF737.7070105@huawei.com>
	 <1365414692.2753.83.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040909-2674-0000-0000-00000886A9D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zefan, 

I did some test today, enabling cpuset and online/offline the cpus. It
caused NULL address dereferencing in get_group(). After adding some
debugging code, it seems that it is caused by using some offlined cpus
as the parameter to partition_sched_domains(). More details below:

===================
following is printed in build_sched_domain(): 
@@ -6476,6 +6486,14 @@ struct sched_domain *build_sched_domain(struct
sched_domain_topology_level *tl,
                return child;

        cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
+       if (cpumask_empty(sched_domain_span(sd)))
+               printk("lz empty domain %p, mask %pS\n", sd, tl->mask);
+       char cpulist[128];
+       cpumask_scnprintf(cpulist, sizeof(cpulist), cpu_map);
+       printk("lz cpu_map %s\n", cpulist);
+       cpumask_scnprintf(cpulist, sizeof(cpulist), tl->mask(cpu));
+       printk("lz tl->mask(%d) %pS %s\n",cpu, tl->mask, cpulist);
+
        if (child) {
                sd->level = child->level + 1;
                sched_domain_level_max = max(sched_domain_level_max,
sd->level);

[  232.714502] lz empty domain c0000001f73c0000, mask cpu_smt_mask
+0x0/0x10
[  232.714515] lz cpu_map 1-2,7,13-15
[  232.714521] lz tl->mask(1) cpu_smt_mask+0x0/0x10
[  232.714529] lz cpu_map 1-2,7,13-15
[  232.714536] lz tl->mask(1) cpu_cpu_mask+0x0/0x10 2,7,13-15
[  232.714544] lz cpu_map 1-2,7,13-15
[  232.714551] lz tl->mask(1) sd_numa_mask+0x0/0x10 2,7,13-15
[  232.714558] lz cpu_map 1-2,7,13-15
[  232.714565] lz tl->mask(2) cpu_smt_mask+0x0/0x10 2
===================

It seems that one cpu (#1 of the above) could be taken offline in
cpuset_hotplug_workfn(), after top_cpuset's allowed cpus changed and the
propagated work function finished. But generate_sched_domains(), which
uses the cpuset information, still considers this cpu (#1) valid, and
passes it down in the cpumask to partition_sched_domains(). Then we have
an empty sd as the above. 

With the empty domain, in get_group(),
        if (child)
                cpu = cpumask_first(sched_domain_span(child));

this might cause the cpu to be returned a value >= nr_cpu_ids, then
cause bad dereference with the wrong cpu value in the later code. 

This following code tries to fix the issue by anding the cpu_active_mask
at the end of generate_sched_domains() for each partition. This might
result the partiton (set of domains) not the best one, but we know
another rebuild (caused by the cpu offline in the middle of
cpuset_hotplug_workfn()) is on the way. 

Also it seems that generate_sched_domains() needs be called together
with partition_sched_domains(), under the hotplug lock. Or similarly,
one cpu might be taken offline while doing generate_sched_domains(), and
cause the above issue. 

Or maybe we could put the whole cpuset_hotplug_workfn() into the hotplug
lock? 

Thanks, Zhong

---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4f9dfe4..aed8436 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -754,6 +754,12 @@ done:
 	 */
 	if (doms == NULL)
 		ndoms = 1;
+	else {
+		for (nslot = 0; nslot < ndoms; nslot++) {
+			struct cpumask *dp = doms[nslot];
+			cpumask_and(dp, dp, cpu_active_mask);
+		}
+	}
 
 	*domains    = doms;
 	*attributes = dattr;
@@ -2222,17 +2228,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	flush_workqueue(cpuset_propagate_hotplug_wq);
 
 	/* rebuild sched domains if cpus_allowed has changed */
-	if (cpus_updated) {
-		struct sched_domain_attr *attr;
-		cpumask_var_t *doms;
-		int ndoms;
-
-		mutex_lock(&cpuset_mutex);
-		ndoms = generate_sched_domains(&doms, &attr);
-		mutex_unlock(&cpuset_mutex);
-
-		partition_sched_domains(ndoms, doms, attr);
-	}
+	if (cpus_updated)
+		rebuild_sched_domains();
 }
 
 void cpuset_update_active_cpus(bool cpu_online)


