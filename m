Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab3GCIwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:52:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34136 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3GCIuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:50:37 -0400
Date: Wed, 3 Jul 2013 10:50:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v2] sched: smart wake-affine
Message-ID: <20130703085025.GG23916@twins.programming.kicks-ass.net>
References: <51A43B16.9080801@linux.vnet.ibm.com>
 <51D25A80.8090406@linux.vnet.ibm.com>
 <51D3C058.3020601@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D3C058.3020601@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 02:10:32PM +0800, Michael Wang wrote:
> +static int wake_wide(struct task_struct *p)
> +{
> +	int factor = nr_cpus_node(cpu_to_node(smp_processor_id()));

That's still a cpumask_weight() in there... we should avoid that. How
about something like the below:

> +
> +	/*
> +	 * Yeah, it's the switching-frequency, could means many wakee or
> +	 * rapidly switch, use factor here will just help to automatically
> +	 * adjust the loose-degree, so bigger node will lead to more pull.
> +	 */
> +	if (p->nr_wakee_switch > factor) {
> +		/*
> +		 * wakee is somewhat hot, it needs certain amount of cpu
> +		 * resource, so if waker is far more hot, prefer to leave
> +		 * it alone.
> +		 */
> +		if (current->nr_wakee_switch > (factor * p->nr_wakee_switch))
> +			return 1;
> +	}
> +
> +	return 0;
> +}

---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9b1f2e5..166ab9b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5081,18 +5083,23 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
  * two cpus are in the same cache domain, see cpus_share_cache().
  */
 DEFINE_PER_CPU(struct sched_domain *, sd_llc);
+DEFINE_PER_CPU(int, sd_llc_size);
 DEFINE_PER_CPU(int, sd_llc_id);
 
 static void update_top_cache_domain(int cpu)
 {
 	struct sched_domain *sd;
 	int id = cpu;
+	int size = 1;
 
 	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
-	if (sd)
+	if (sd) {
 		id = cpumask_first(sched_domain_span(sd));
+		size = cpumask_weight(sched_domain_span(sd));
+	}
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
+	per_cpu(sd_llc_size, cpu) = size;
 	per_cpu(sd_llc_id, cpu) = id;
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ef0a7b2..c992f58 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -595,6 +595,7 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 }
 
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
+DECLARE_PER_CPU(int, sd_llc_size);
 DECLARE_PER_CPU(int, sd_llc_id);
 
 struct sched_group_power {
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3175,7 +3175,7 @@ static inline unsigned long effective_lo
 
 static int wake_wide(struct task_struct *p)
 {
-	int factor = nr_cpus_node(cpu_to_node(smp_processor_id()));
+	int factor = this_cpu_read(sd_llc_size);
 
 	/*
 	 * Yeah, it's the switching-frequency, could means many wakee or

