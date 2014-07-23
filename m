Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbaGWUgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:36:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45722 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095AbaGWUgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:36:31 -0400
Date: Wed, 23 Jul 2014 22:36:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 13/70] x86, x2apic_cluster: _FROZEN Cleanup
Message-ID: <20140723203628.GJ21707@pd.tnic>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-14-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406080786-3938-14-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 09:58:49PM -0400, Chen, Gong wrote:
> Remove XXX_FROZEN state from x86/x2apic_cluster.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  arch/x86/kernel/apic/x2apic_cluster.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
> index e66766b..bfd2369 100644
> --- a/arch/x86/kernel/apic/x2apic_cluster.c
> +++ b/arch/x86/kernel/apic/x2apic_cluster.c
> @@ -154,8 +154,11 @@ update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  	unsigned int cpu;
>  	int err = 0;
>  
> -	switch (action) {
> +	switch (action & ~CPU_TASKS_FROZEN) {
>  	case CPU_UP_PREPARE:
> +		if (action & CPU_TASKS_FROZEN)
> +			break;
> +
>  		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
>  					GFP_KERNEL)) {
>  			err = -ENOMEM;
> @@ -165,9 +168,11 @@ update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  			err = -ENOMEM;
>  		}
>  		break;
> -	case CPU_UP_CANCELED:
> -	case CPU_UP_CANCELED_FROZEN:
>  	case CPU_DEAD:
> +		/* fall though to next if action == CPU_DEAD */
> +		if (action & CPU_TASKS_FROZEN)
> +			break;
> +	case CPU_UP_CANCELED:
>  		for_each_online_cpu(cpu) {
>  			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
>  				continue;

Those checks dealing with CPU_TASKS_FROZEN in-between make the whole
switch statement hard to follow.

How about we go a step further and deal with CPU_UP_CANCELED_FROZEN
upfront and even simplify the rest:

---
Index: b/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- a/arch/x86/kernel/apic/x2apic_cluster.c	2014-07-23 22:21:27.574344741 +0200
+++ b/arch/x86/kernel/apic/x2apic_cluster.c	2014-07-23 22:30:58.638338359 +0200
@@ -144,6 +144,21 @@ static void init_x2apic_ldr(void)
 	}
 }
 
+static void __update_clusterinfo(unsigned int this_cpu)
+{
+	unsigned int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
+			continue;
+		__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
+		__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
+	}
+
+	free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
+	free_cpumask_var(per_cpu(ipi_mask, this_cpu));
+}
+
  /*
   * At CPU state changes, update the x2apic cluster sibling info.
   */
@@ -151,9 +166,14 @@ static int
 update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int this_cpu = (unsigned long)hcpu;
-	unsigned int cpu;
 	int err = 0;
 
+	if (action & CPU_TASKS_FROZEN) {
+		if ((action & ~CPU_TASKS_FROZEN) == CPU_UP_CANCELED)
+			__update_clusterinfo(this_cpu);
+		return NOTIFY_OK;
+	}
+
 	switch (action) {
 	case CPU_UP_PREPARE:
 		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
@@ -166,16 +186,10 @@ update_clusterinfo(struct notifier_block
 		}
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-		for_each_online_cpu(cpu) {
-			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
-				continue;
-			__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
-			__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
-		}
-		free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
-		free_cpumask_var(per_cpu(ipi_mask, this_cpu));
+		__update_clusterinfo(this_cpu);
+		break;
+	default:
 		break;
 	}
 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
