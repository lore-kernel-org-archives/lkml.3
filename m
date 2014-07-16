Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965882AbaGPTRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:17:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42397 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965687AbaGPTRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:17:37 -0400
Message-ID: <53C6CFCC.2050300@arm.com>
Date: Wed, 16 Jul 2014 21:17:32 +0200
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>, Bruno Wolff III <bruno@wolff.to>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from caffcdd8d27ba78730d5540396ce72ad022aff2c
References: <20140716145546.GA6922@wolff.to> <20140716151748.GC2460@hansolo.jdub.homelinux.org>
In-Reply-To: <20140716151748.GC2460@hansolo.jdub.homelinux.org>
X-OriginalArrivalTime: 16 Jul 2014 19:17:33.0843 (UTC) FILETIME=[98A12630:01CFA12A]
X-MC-Unique: 114071620173501001
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno and Josh,

On 16/07/14 17:17, Josh Boyer wrote:
> Adding Dietmar in since he is the original author.
>
> josh
>
> On Wed, Jul 16, 2014 at 09:55:46AM -0500, Bruno Wolff III wrote:
>> caffcdd8d27ba78730d5540396ce72ad022aff2c has been causing crashes
>> early in the boot process on one of three machines I have been
>> testing the kernel on. On that one machine it happens every boot. It
>> happens before netconsole is functional.

I tested this patch on two platforms (ARM TC2 and INTEL i5 M520) by 
replacing the two lines (already with the new sg->sgc->capacity instead 
of the old sg->sgp->power) by:

  BUG_ON(!cpumask_empty(sched_group_cpus(sg)));
  BUG_ON(sg->sgc->capacity);

The memory for sg is allocated and zeroed out in __sdt_alloc() with:

sgc = kzalloc_node(sizeof(struct sched_group_capacity) + cpumask_size(),
					GFP_KERNEL, cpu_to_node(j));

The related call chain:

build_sched_domains()
	__visit_domain_allocation_hell()
		__sdt_alloc()
	build_sched_groups()

>>
>> A partial revert of the commit fixes the problem. I do not know why
>> the commit is broken though.
>>
>> I have filed https://bugzilla.kernel.org/show_bug.cgi?id=80251 for
>> this issue.

 From the issue, I see that the machine making trouble is an Xeon (2 
processors w/ hyper-threading).

Could you please share:

  cat /proc/cpuinfo and
  cat /proc/schedstat (kernel config w/ CONFIG_SCHEDSTATS=y)

from this machine.

I don't think it is SMT (since it's also there on my INTEL i5 M520 
(arch/x86/configs/x86_64_defconfig).

Could you also put the two BUG_ON lines into build_sched_groups() 
[kernel/sched/core.c] wo/ the cpumask_clear() and setting 
sg->sgc->capacity to 0 and share the possible crash output as well?

>>
>> The problem happens on both Fedora and Linus kernels.
>>
>> git diff caffcdd8d27ba78730d5540396ce72ad022aff2c^ caffcdd8d27ba78730d5540396ce72ad022aff2c
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 45d077ed24fb..6340c601475d 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -5794,8 +5794,6 @@ build_sched_groups(struct sched_domain *sd, int cpu)
>>                         continue;
>>
>>                 group = get_group(i, sdd, &sg);
>> -               cpumask_clear(sched_group_cpus(sg));
>> -               sg->sgp->power = 0;
>>                 cpumask_setall(sched_group_mask(sg));
>>
>>                 for_each_cpu(j, span) {
>>
>> By rc5 the second line can't be added back because the structure has
>> changed. However adding back cpumask_clear(sched_group_cpus(sg)); to
>> rc5 got things working for me again.

That's because 'sched: Let 'struct sched_group_power' care about CPU 
capacity' (commit id 63b2ca30bdb3) changes the struct sched_group member 
from struct sched_group_power *sgp to struct sched_group_capacity *sgc .

I.e. the second line becomes

  sg->sgc->capacity = 0;

Thanks,

-- Dietmar

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


