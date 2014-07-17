Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbaGQLYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:24:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47593 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbaGQLX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:23:56 -0400
Message-ID: <53C7B247.2070309@arm.com>
Date: Thu, 17 Jul 2014 13:23:51 +0200
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Bruno Wolff III <bruno@wolff.to>, Josh Boyer <jwboyer@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from caffcdd8d27ba78730d5540396ce72ad022aff2c
References: <20140716145546.GA6922@wolff.to> <20140716151748.GC2460@hansolo.jdub.homelinux.org> <53C6CFCC.2050300@arm.com> <20140716195414.GA16401@wolff.to> <53C7084C.7090104@arm.com> <20140717030947.GA17889@wolff.to> <53C79013.1020808@arm.com> <20140717090452.GH19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140717090452.GH19379@twins.programming.kicks-ass.net>
X-OriginalArrivalTime: 17 Jul 2014 11:23:51.0844 (UTC) FILETIME=[96360640:01CFA1B1]
X-MC-Unique: 114071712235410801
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/14 11:04, Peter Zijlstra wrote:
> On Thu, Jul 17, 2014 at 10:57:55AM +0200, Dietmar Eggemann wrote:
>> There is also the possibility that the memory for sched_group sg is not
>> (completely) zeroed out:
>>
>>    sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
>> 			GFP_KERNEL, cpu_to_node(j));
>>
>>
>>    struct sched_group {
>> 	...
>> 	 * NOTE: this field is variable length. (Allocated dynamically
>> 	 * by attaching extra space to the end of the structure,
>> 	 * depending on how many CPUs the kernel has booted up with)
>> 	 */
>> 	unsigned long cpumask[0];
>
> well kZalloc should Zero the entire allocated size, and the specified
> size very much includes the cpumask size as per:
>    sizeof(struct sched_group) + cpumask_size()

Yes, I think so too.

>
> But yeah, I'm also a bit puzzled why this goes bang. Makes we worry we
> scribble it somewhere or so.
>

But then, this must be happening in build_sched_domains() between 
__visit_domain_allocation_hell()->__sdt_alloc() and build_sched_groups().


Couldn't catch this phenomena by adding a fake SMT level (just a copy of 
the real MC level) to my ARM TC2 (dual cluster dual/triple core, no 
hyper-threading) to provoke sd degenerate. It does not show the issue 
and MC level gets degenerated nicely. Might not be the real example 
since SMT and MC are using the same cpu mask here).

@@ -281,6 +281,7 @@ static inline const int cpu_corepower_flags(void)
  }

  static struct sched_domain_topology_level arm_topology[] = {
+       { cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(SMT) },
  #ifdef CONFIG_SCHED_MC
         { cpu_corepower_mask, cpu_corepower_flags, SD_INIT_NAME(GMC) },
         { cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },


Maybe by enabling sched_debug on command line (earlyprintk=keep 
sched_debug), Bruno could spot topology setup issues on his XEON machine 
which could lead to this problem unless the sg cpumask gets zeroed out 
in build_sched_groups() a second time ?

Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz dmesg snippet as an example when 
booted with 'earlyprintk=keep sched_debug':
  ...
  [    0.119737] CPU0 attaching sched-domain:
  [    0.119740]  domain 0: span 0-1 level SIBLING
  [    0.119742]   groups: 0 (cpu_power = 588) 1 (cpu_power = 588)
  [    0.119745]   domain 1: span 0-3 level MC
  [    0.119747]    groups: 0-1 (cpu_power = 1176) 2-3 (cpu_power = 1176)
  ...











