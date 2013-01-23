Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3AWFJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:09:37 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:35957 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3AWFJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:09:36 -0500
Message-ID: <50FF7086.4020509@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 13:09:26 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <50ED384C.1030301@linux.vnet.ibm.com> <1357977704.6796.47.camel@marge.simpson.net> <1357985943.6796.55.camel@marge.simpson.net> <1358155290.5631.19.camel@marge.simpson.net> <50F79256.1010900@linux.vnet.ibm.com> <1358654997.5743.17.camel@marge.simpson.net> <50FCACE3.5000706@linux.vnet.ibm.com> <1358743128.4994.33.camel@marge.simpson.net> <50FCCCF5.30504@linux.vnet.ibm.com> <1358750523.4994.55.camel@marge.simpson.net> <1358752180.4994.65.camel@marge.simpson.net> <50FCF212.3010504@linux.vnet.ibm.com> <1358759355.4994.108.camel@marge.simpson.net> <50FD08E1.8000302@linux.vnet.ibm.com> <1358761496.4994.118.camel@marge.simpson.net> <50FE0ADC.6060701@linux.vnet.ibm.com> <1358841795.5782.255.camel@marge.simpson.net> <50FE5433.1070801@linux.vnet.ibm.com> <1358865692.5782.420.camel@marge.simpson.net> <50FF4EA0.1070000@linux.vnet.ibm.com> <1358915494.5752.46.camel@marge.simpson.net>
In-Reply-To: <1358915494.5752.46.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012305-2000-0000-0000-00000AB3405D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 12:31 PM, Mike Galbraith wrote:
> On Wed, 2013-01-23 at 10:44 +0800, Michael Wang wrote: 
>> On 01/22/2013 10:41 PM, Mike Galbraith wrote:
>>> On Tue, 2013-01-22 at 16:56 +0800, Michael Wang wrote:
>>>
>>>> What about this patch? May be the wrong map is the killer on balance
>>>> path, should we check it? ;-) 
>>>
>>> [    1.232249] Brought up 40 CPUs
>>> [    1.236003] smpboot: Total of 40 processors activated (180873.90 BogoMIPS)
>>> [    1.244744] CPU0 attaching sched-domain:
>>> [    1.254131] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
>>> [    1.252010]  domain 0: span 0,16 level SIBLING
>>> [    1.280001]   groups: 0 (cpu_power = 589) 16 (cpu_power = 589)
>>> [    1.292540]   domain 1: span 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38 level MC
>>> [    1.312001]    groups: 0,16 (cpu_power = 1178) 2,18 (cpu_power = 1178) 4,20 (cpu_power = 1178) 6,22 (cpu_power = 1178) 8,24 (cpu_power = 1178)
>>>                          10,26 (cpu_power = 1178)12,28 (cpu_power = 1178)14,30 (cpu_power = 1178)32,36 (cpu_power = 1178)34,38 (cpu_power = 1178)
>>> [    1.368002]    domain 2: span 0-39 level NUMA
>>> [    1.376001]     groups: 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38 (cpu_power = 11780)
>>>                            1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39 (cpu_power = 11780)
>>
>> Thanks for the testing, that's not all the output but just for cpu 0,
>> correct?
> 
> Yeah, I presumed one was enough.  You can have more if you like, there's
> LOTS more where that came from (reboot is amazing with low speed serial
> console -> high latency low bandwidth DSL conection;). 
> 
>>> [    1.412546] WYT: sbm of cpu 0
>>> [    1.416001] WYT:      exec map
>>> [    1.424002] WYT:              sd 6ce55000, idx 0, level 0, weight 2
>>> [    1.436001] WYT:              sd 6ce74000, idx 1, level 1, weight 20
>>> [    1.448001] WYT:              sd 6cef3000, idx 3, level 3, weight 40
>>> [    1.460001] WYT:      fork map
>>> [    1.468001] WYT:              sd 6ce55000, idx 0, level 0, weight 2
>>> [    1.480001] WYT:              sd 6ce74000, idx 1, level 1, weight 20
>>
>> This is not by design... sd in idx 2 should point to level 1 sd if there
>> is no level 2 sd, this part is broken...oh, how could level 3 sd be
>> there with out level 2 created? strange...
>>
>> So with this map, the new balance path will no doubt broken, I think we
>> got the reason, amazing ;-)
>>
>> Let's see how to fix it, hmm... need some study firstly.
> 
> Another thing that wants fixing: root can set flags for _existing_
> domains any way he likes,

Can he? on running time changing the domain flags? I do remember I used to
send out some patch to achieve that but was refused since it's dangerous...

but when he invokes godly powers to rebuild
> domains, he gets what's hard coded, which is neither clever (godly
> wrath;), nor wonderful for godly runtime path decisions.

The purpose is to using a map to describe the sd topology of a cpu, it
should be rebuild correctly according to the new topology when attaching
new domain to a cpu.

For this case, it's really strange that level 2 was missed in topology,
I found that in build_sched_domains(), the level was added one by one,
and I don't know why it jumps here...sounds like some BUG to me.

Whatever, the sbm should still work properly by designed, even in such
strange topology, if it's initialized correctly.

And below patch will do help on it, just based on the original patch set.

Could you please take a try on it, it's supposed to make the balance path
correctly, and please apply below DEBUG patch too, so we could know how it
changes, I think this time, we may be able to solve the issue by the right
way ;-)

Regards,
Michael Wang

---
 kernel/sched/core.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0c63303..c2a13bc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5582,7 +5582,6 @@ static void build_sched_balance_map(int cpu)
 {
        struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
        struct sched_domain *sd = cpu_rq(cpu)->sd;
-       struct sched_domain *top_sd = NULL;
        int i, type, level = 0;

        memset(sbm->top_level, 0, sizeof((*sbm).top_level));
@@ -5625,11 +5624,9 @@ static void build_sched_balance_map(int cpu)
         * fill the hole to get lower level sd easily.
         */
        for (type = 0; type < SBM_MAX_TYPE; type++) {
-               level = sbm->top_level[type];
-               top_sd = sbm->sd[type][level];
-               if ((++level != sbm_max_level) && top_sd) {
-                       for (; level < sbm_max_level; level++)
-                               sbm->sd[type][level] = top_sd;
+               for (level = 1; level < sbm_max_level; level++) {
+                       if (!sbm->sd[type][level])
+                               sbm->sd[type][level] = sbm->sd[type][level - 1];
                }
        }
 }
-- 
1.7.4.1



DEBUG PATCH:

---
 kernel/sched/core.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c2a13bc..7c6c736 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5578,6 +5578,35 @@ static void update_top_cache_domain(int cpu)
 static int sbm_max_level;
 DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_balance_map, sbm_array);

+static void debug_sched_balance_map(int cpu)
+{
+       int i, type, level = 0;
+       struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
+
+       printk("WYT: sbm of cpu %d\n", cpu);
+
+       for (type = 0; type < SBM_MAX_TYPE; type++) {
+               if (type == SBM_EXEC_TYPE)
+                       printk("WYT: \t exec map\n");
+               else if (type == SBM_FORK_TYPE)
+                       printk("WYT: \t fork map\n");
+               else if (type == SBM_WAKE_TYPE)
+                       printk("WYT: \t wake map\n");
+
+               for (level = 0; level < sbm_max_level; level++) {
+                       if (sbm->sd[type][level])
+                               printk("WYT: \t\t sd %x, idx %d, level %d, weight %d\n", sbm->sd[type][level], level, sbm->sd[type][level]->level, sbm->sd[type][level]->span_weight);
+               }
+       }
+
+       printk("WYT: \t affine map\n");
+
+       for_each_possible_cpu(i) {
+               if (sbm->affine_map[i])
+               if (sbm->affine_map[i])
+                       printk("WYT: \t\t affine with cpu %x in sd %x, weight %d\n", i, sbm->affine_map[i], sbm->affine_map[i]->span_weight);
+       }
+}
+
 static void build_sched_balance_map(int cpu)
 {
        struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
@@ -5685,6 +5714,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
         * destroy_sched_domains() already do the work.
         */
        build_sched_balance_map(cpu);
+       debug_sched_balance_map(cpu);
        rcu_assign_pointer(rq->sbm, sbm);
 }

-- 
1.7.4.1




> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

