Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaGQI6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:58:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52625 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaGQI57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:57:59 -0400
Message-ID: <53C79013.1020808@arm.com>
Date: Thu, 17 Jul 2014 10:57:55 +0200
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bruno Wolff III <bruno@wolff.to>
CC: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from caffcdd8d27ba78730d5540396ce72ad022aff2c
References: <20140716145546.GA6922@wolff.to> <20140716151748.GC2460@hansolo.jdub.homelinux.org> <53C6CFCC.2050300@arm.com> <20140716195414.GA16401@wolff.to> <53C7084C.7090104@arm.com> <20140717030947.GA17889@wolff.to>
In-Reply-To: <20140717030947.GA17889@wolff.to>
X-OriginalArrivalTime: 17 Jul 2014 08:57:55.0930 (UTC) FILETIME=[334793A0:01CFA19D]
X-MC-Unique: 114071709575700501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/14 05:09, Bruno Wolff III wrote:
> On Thu, Jul 17, 2014 at 01:18:36 +0200,
>    Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>> So the output of
>>
>> $ cat /proc/sys/kernel/sched_domain/cpu*/domain*/*
>>
>> would be handy too.

Thanks, this was helpful.
I see from the sched domain layout that you have SMT (domain0) and DIE 
(domain1) level. So on this system, the MC level gets degenerated 
(sd_degenerate() in kernel/sched/core.c).
I fail so far to see how this can have an effect on the memory of the 
sched groups. But I can try to fake this situation on one of my platforms.

There is also the possibility that the memory for sched_group sg is not 
(completely) zeroed out:

   sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
			GFP_KERNEL, cpu_to_node(j));


   struct sched_group {
	...
	 * NOTE: this field is variable length. (Allocated dynamically
	 * by attaching extra space to the end of the structure,
	 * depending on how many CPUs the kernel has booted up with)
	 */
	unsigned long cpumask[0];
};

so that the cpumask of a sched group is not 0 and can only be cured by 
an explicit cpumask_clear(sched_group_cpus(sg)) in build_sched_groups() 
on this kind of machine.

>
> Attached and added to the bug.
>
>> Just to make sure, you do have 'CONFIG_X86_32=y' and '# CONFIG_NUMA is
>> not set' in your build?
>
> Yes.
>
> I probably won't be able to get /proc/schedstat on my next test since the
> system will probably crash right away. However, I probably will have a
> much faster rebuild and might still be able to get the info for you
> before I leave tomorrow.
>


