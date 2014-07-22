Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaGVMMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:12:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35916 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbaGVMMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:12:40 -0400
Message-ID: <53CE5536.4000005@arm.com>
Date: Tue, 22 Jul 2014 13:12:38 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Bruno Wolff III <bruno@wolff.to>
CC: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from caffcdd8d27ba78730d5540396ce72ad022aff2c
References: <53C7B247.2070309@arm.com> <20140717123502.GL19379@twins.programming.kicks-ass.net> <20140718053449.GA2039@wolff.to> <20140718101633.GP9918@twins.programming.kicks-ass.net> <20140718130126.GA2401@wolff.to> <20140718141648.GE20603@laptop.programming.kicks-ass.net> <20140718145040.GG12054@laptop.lan> <20140718161602.GH12054@laptop.lan> <20140721163528.GA10433@wolff.to> <20140721165212.GO3935@laptop> <20140722094740.GJ12054@laptop.lan>
In-Reply-To: <20140722094740.GJ12054@laptop.lan>
X-OriginalArrivalTime: 22 Jul 2014 12:12:37.0123 (UTC) FILETIME=[39E0ED30:01CFA5A6]
X-MC-Unique: 114072213123805701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/14 10:47, Peter Zijlstra wrote:
> On Mon, Jul 21, 2014 at 06:52:12PM +0200, Peter Zijlstra wrote:
>> On Mon, Jul 21, 2014 at 11:35:28AM -0500, Bruno Wolff III wrote:
>>> Is there more I can do to help with this now? Or should I just wait for
>>> patches to test?
>>
>> Yeah, sorry, was wiped out today. I'll go stare harder at the P4
>> topology setup code tomorrow. Something fishy there.
> 
> Does this make your machine boot again (while giving an error)?
> 
> It tries to robustify the topology setup a bit, crashing on crap input
> should be avoided if possible of course.
> 
> I'll go stare at the x86/P4 topology code like promised.
> 
> ---
> Subject: sched: Robustify topology setup
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon Jul 21 23:07:06 CEST 2014
> 
> We hard assume that higher topology levels are strict supersets of
> lower levels.

IMHO, we require only that higher topology levels are supersets of lower
levels, not strict (proper) supersets.

AFAICS, the patch itself requires only supersets, i.e. on ARM TC2 with
the following change in cpu_corepower_mask:

 const struct cpumask *cpu_corepower_mask(int cpu)
 {
-       return &cpu_topology[cpu].thread_sibling;
+       return &cpu_topology[cpu].core_sibling;
 }

I get:

...
build_sched_domain: cpu: 0 level: GMC cpu_map: 0-4 tl->mask: 0-1
build_sched_domain: cpu: 0 level: MC cpu_map: 0-4 tl->mask: 0-1
build_sched_domain: cpu: 0 level: DIE cpu_map: 0-4 tl->mask: 0-4
...

without hitting the newly introduced pr_err's.

> 
> Detect, warn and try to fixup when we encounter this violated.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-cgp9j2tk0qnunhtpps3udsom@git.kernel.org
> ---
>  kernel/sched/core.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6480,6 +6480,20 @@ struct sched_domain *build_sched_domain(
>  		sched_domain_level_max = max(sched_domain_level_max, sd->level);
>  		child->parent = sd;
>  		sd->child = child;
> +
> +		if (!cpumask_subset(sched_domain_span(child),
> +				    sched_domain_span(sd))) {
> +			pr_err("BUG: arch topology borken\n");
> +#ifdef CONFIG_SCHED_DEBUG
> +			pr_err("     the %s domain not a subset of the %s domain\n",
> +					child->name, sd->name);
> +#endif
> +			/* Fixup, ensure @sd has at least @child cpus. */
> +			cpumask_or(sched_domain_span(sd),
> +				   sched_domain_span(sd),
> +				   sched_domain_span(child));

This fixup will (probably) heal the Bruno's issue with it's wrong
cpu_coregroup_mask() function.

If I exchange cpu_corepower_mask with cpu_coregroup_mask in arm_topology[]

 static struct sched_domain_topology_level arm_topology[] = {
 #ifdef CONFIG_SCHED_MC
-       { cpu_corepower_mask, cpu_corepower_flags, SD_INIT_NAME(GMC) },
-       { cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
+       { cpu_coregroup_mask, cpu_corepower_flags, SD_INIT_NAME(GMC) },
+       { cpu_corepower_mask, cpu_core_flags, SD_INIT_NAME(MC) },
 #endif

I get:

...
build_sched_domain: cpu: 0 level: GMC cpu_map: 0-4 tl->mask: 0-1
build_sched_domain: cpu: 0 level: MC cpu_map: 0-4 tl->mask: 0
BUG: arch topology borken
     the GMC domain not a subset of the MC domain
build_sched_domain: cpu: 0 level: DIE cpu_map: 0-4 tl->mask: 0-4
...

cat /proc/schedstat
...
cpu0 0 0 16719 6169 10937 6392 5348510220 2935348625 10448
domain0 03 19190 19168 9 10265 13 0 0 19168 16 16 0 0 0 0 0 16 1196 1080
46 43570 75 0 0 1080 0 0 0 0 0 0 0 0 0 2947 280 0
domain1 1f 18768 18763 3 3006 2 0 9 18055 6 6 0 0 0 0 0 1 1125 996 94
81038 43 0 18 978 0 0 0 0 0 0 0 0 0 1582 172 0

# cat /proc/sys/kernel/sched_domain/cpu0/domain*/name
GMC
DIE

so MC level gets changed to mask 0-1.

> +		}
> +
>  	}
>  	set_domain_attribute(sd, attr);
>  
> 

Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>



















