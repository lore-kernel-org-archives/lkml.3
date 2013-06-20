Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965577Ab3FTOFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:05:38 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:43719 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030288Ab3FTOFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:05:22 -0400
Date: Thu, 20 Jun 2013 14:05:20 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 1/2] mm: make vmstat_update periodic run conditional
In-Reply-To: <1371672168-9869-1-git-send-email-gilad@benyossef.com>
Message-ID: <0000013f61e7609b-a8d1907b-8169-4f77-ab83-a624a8d0ab4a-000000@email.amazonses.com>
References: <CAOtvUMc5w3zNe8ed6qX0OOM__3F_hOTqvFa1AkdXF0PHvzGZqg@mail.gmail.com> <1371672168-9869-1-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.20-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013, Gilad Ben-Yossef wrote:

> +static void vmstat_update(struct work_struct *w)
> +{
> +	int cpu, this_cpu = smp_processor_id();
> +
> +	if (unlikely(this_cpu == vmstat_monitor_cpu))
> +		for_each_cpu_not(cpu, &vmstat_cpus)
> +			if (need_vmstat(cpu))
> +				start_cpu_timer(cpu);
> +
> +	if (likely(refresh_cpu_vm_stats(this_cpu) || (this_cpu == vmstat_monitor_cpu)))
> +		schedule_delayed_work(&__get_cpu_var(vmstat_work),
> +				round_jiffies_relative(sysctl_stat_interval));
> +	else
> +		cpumask_clear_cpu(this_cpu, &vmstat_cpus);

The clearing of vmstat_cpus could be avoided if this processor is not
running tickless. Frequent updates to vmstat_cpus could become an issue.

>  	case CPU_DOWN_PREPARE_FROZEN:
> -		cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
> -		per_cpu(vmstat_work, cpu).work.func = NULL;
> +		if (cpumask_test_cpu(cpu, &vmstat_cpus)) {
> +			cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
> +			per_cpu(vmstat_work, cpu).work.func = NULL;
> +			if(cpu == vmstat_monitor_cpu) {
> +				int this_cpu = smp_processor_id();
> +				vmstat_monitor_cpu = this_cpu;
> +				if (!cpumask_test_cpu(this_cpu, &vmstat_cpus))
> +					start_cpu_timer(this_cpu);
> +			}
> +		}
>  		break;

If the disabling of vmstat is tied into the nohz logic then these portions
are no longer necessary.

> @@ -1237,8 +1299,10 @@ static int __init setup_vmstat(void)
>
>  	register_cpu_notifier(&vmstat_notifier);
>
> +	vmstat_monitor_cpu = smp_processor_id();
> +

Drop the vmstat_monitor_cpu and use the dynticks processor.

