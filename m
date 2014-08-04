Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaHDLbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:31:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44991 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaHDLbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:31:06 -0400
Message-ID: <53DF6EFC.30705@arm.com>
Date: Mon, 04 Aug 2014 12:31:08 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: "bruno@wolff.to" <bruno@wolff.to>, Michael Ellerman <michaele@au1.ibm.com>,
        "jwboyer@redhat.com" <jwboyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infrdead.org" <peterz@infrdead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: scheduler crash on Power
References: <20140730072242.GA21516@us.ibm.com> <53DA2F15.1070605@arm.com>	 <20140801212447.GA25435@us.ibm.com> <1407122432.2286.0.camel@concordia>
In-Reply-To: <1407122432.2286.0.camel@concordia>
X-OriginalArrivalTime: 04 Aug 2014 11:31:02.0574 (UTC) FILETIME=[9261B4E0:01CFAFD7]
X-MC-Unique: 114080412310304901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/14 04:20, Michael Ellerman wrote:
> On Fri, 2014-08-01 at 14:24 -0700, Sukadev Bhattiprolu wrote:
>> Dietmar Eggemann [dietmar.eggemann@arm.com] wrote:
>> | > ltcbrazos2-lp07 login: [  181.915974] ------------[ cut here ]------------
>> | > [  181.915991] WARNING: at ../kernel/sched/core.c:5881
>> | 
>> | This warning indicates the problem. One of the struct sched_domains does
>> | not have it's groups member set.
>> | 
>> | And its happening during a rebuild of the sched domain hierarchy, not
>> | during the initial build.
>> | 
>> | You could run your system with the following patch-let (on top of
>> | https://lkml.org/lkml/2014/7/17/288)  w/ and w/o the perf related
>> | patches (w/ CONFIG_SCHED_DEBUG enabled).
>> | 
>> | @@ -5882,6 +5882,9 @@ static void init_sched_groups_capacity(int cpu,
>> | struct sched_domain *sd)
>> |  {
>> |         struct sched_group *sg = sd->groups;
>> | 
>> | +#ifdef CONFIG_SCHED_DEBUG
>> | +       printk("sd name: %s span: %pc\n", sd->name, sd->span);
>> | +#endif
>> |         WARN_ON(!sg);
>> | 
>> |         do {
>> | 
>> | This will show if the rebuild of the sched domain hierarchy happens on
>> | both systems and hopefully indicate for which sched_domain the
>> | sd->groups is not set.
>>
>> Thanks for the patch. It appears that the NUMA sched domain does not
>> have the sd->groups set - snippet of the error (with your patch and
>> Peter's patch)
>>
>> [  181.914494] build_sched_groups: got group c000000006da0000 with cpus: 
>> [  181.914498] build_sched_groups: got group c0000000dd830000 with cpus: 
>> [  181.915234] sd name: SMT span: 8-15
>> [  181.915239] sd name: DIE span: 0-7
>> [  181.915242] sd name: NUMA span: 0-15
>> [  181.915250] ------------[ cut here ]------------
>> [  181.915253] WARNING: at ../kernel/sched/core.c:5891
>>
>> Patched code:
>>
>> 	5884 static void init_sched_groups_capacity(int cpu, struct sched_domain *sd)
>> 	5885 {
>> 	5886         struct sched_group *sg = sd->groups;
>> 	5887 
>> 	5888 #ifdef CONFIG_SCHED_DEBUG
>> 	5889         printk("sd name: %s span: %pc\n", sd->name, sd->span);
>> 	5890 #endif
>> 	5891         WARN_ON(!sg);
>>
>> Complete log below.
>>
>> I was able to bisect it down to this patch in the 24x7 patchset
>>
>> 	https://lkml.org/lkml/2014/5/27/804
>>
>> I replaced the kfree(page) calls in the patch with
>> kmem_cache_free(hv_page_cache, page).
>>
>> The problem sems to disappear if the call to create_events_from_catalog()
>> in hv_24x7_init() is skipped. I am continuing to debug the 24x7 patch.
> 
> Is that patch just clobbering memory it doesn't own and corrupting the
> scheduler data structures?

Quite likely. When the system comes up initially, it has SMT and DIE
sched domain level:

...
[    0.033832] build_sched_groups: got group c0000000e7d50000 with cpus:
[    0.033835] build_sched_groups: got group c0000000e7d80000 with cpus:
[    0.033844] sd name: SMT span: 8-15
[    0.033847] sd name: DIE span: 0-15  <-- !!!
[    0.033850] sd name: SMT span: 8-15
[    0.033853] sd name: DIE span: 0-15
...

and the cpu mask of DIE spans all CPUs '0-15'.

Then during the rebuild of the sched domain hierarchy, this looks very
different:

...
[  181.914494] build_sched_groups: got group c000000006da0000 with cpus:
[  181.914498] build_sched_groups: got group c0000000dd830000 with cpus:
[  181.915234] sd name: SMT span: 8-15
[  181.915239] sd name: DIE span: 0-7   <-- !!!
[  181.915242] sd name: NUMA span: 0-15
...

The cpu mask of the DIE level is all the sudden '0-7', which is clearly
wrong.

So I suspect that sched_domain_mask_f mask function for the DIE level
'cpu_cpu_mask()' returns a wrong value during this rebuild.

Could be checked with this little patch-let:

@@ -6467,6 +6467,12 @@ struct sched_domain *build_sched_domain(struct
sched_domain_topology_level *tl,
        if (!sd)
                return child;

+       printk("%s: cpu: %d level: %s cpu_map: %pc tl->mask: %pc\n",
+                       __func__,
+                       cpu, tl->name,
+                       cpu_map,
+                       tl->mask(cpu));
+
        cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
        if (child) {
                sd->level = child->level + 1;


Should give you something similar like:

...
build_sched_domain: cpu: 0 level: GMC cpu_map: 0-4 tl->mask: 0
build_sched_domain: cpu: 0 level: MC cpu_map: 0-4 tl->mask: 0-1
build_sched_domain: cpu: 0 level: DIE cpu_map: 0-4 tl->mask: 0-4
build_sched_domain: cpu: 1 level: GMC cpu_map: 0-4 tl->mask: 1
build_sched_domain: cpu: 1 level: MC cpu_map: 0-4 tl->mask: 0-1
build_sched_domain: cpu: 1 level: DIE cpu_map: 0-4 tl->mask: 0-4
...

> 
> cheers
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


