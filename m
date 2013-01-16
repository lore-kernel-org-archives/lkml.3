Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab3APHkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:40:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:63208 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab3APHkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:40:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,476,1355126400"; 
   d="scan'208";a="191672077"
Message-ID: <50F659AD.70405@intel.com>
Date: Wed, 16 Jan 2013 15:41:33 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 05/22] sched: remove domain iterations in fork/exec/wake
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-6-git-send-email-alex.shi@intel.com> <20130109182102.GC2046@e103034-lin> <50EF9B69.3000201@linux.vnet.ibm.com> <50F63E16.1060903@intel.com>
In-Reply-To: <50F63E16.1060903@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 01:43 PM, Alex Shi wrote:
> -		/* while loop will break here if sd == NULL */
>>>
>>> I agree that this should be a major optimization. I just can't figure
>>> out why the existing recursive search for an idle cpu switches to the
>>> new cpu near the end and then starts a search for an idle cpu in the new
>>> cpu's domain. Is this to handle some exotic sched domain configurations?
>>> If so, they probably wouldn't work with your optimizations.
>>
>> Let me explain my understanding of why the recursive search is the way
>> it is.
>>
>>  _________________________  sd0
>> |                         |
>> |  ___sd1__   ___sd2__    |
>> | |        | |        |   |
>> | | sgx    | |  sga   |   |
>> | | sgy    | |  sgb   |   |
>> | |________| |________|   |
>> |_________________________|
>>
>> What the current recursive search is doing is (assuming we start with
>> sd0-the top level sched domain whose flags are rightly set). we find
>> that sd1 is the idlest group,and a cpux1 in sgx is the idlest cpu.
>>
>> We could have ideally stopped the search here.But the problem with this
>> is that there is a possibility that sgx is more loaded than sgy; meaning
>> the cpus in sgx are heavily imbalanced;say there are two cpus cpux1 and
>> cpux2 in sgx,where cpux2 is heavily loaded and cpux1 has recently gotten
>> idle and load balancing has not come to its rescue yet.According to the
>> search above, cpux1 is idle,but is *not the right candidate for
>> scheduling forked task,it is the right candidate for relieving the load
>> from cpux2* due to cache locality etc.
> 
> The problem still exists on the current code. It still goes to cpux1.
> and then goes up to sgx to seek idlest group ... idlest cpu, and back to
> cpux1 again. nothing help.
> 
> 

to resolve the problem, I has tried to walk domains from top down. but testing
show aim9/hackbench performance is not good on our SNB EP. and no change on other platforms.
---
@@ -3351,51 +3363,33 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 
 
-       while (sd) {
+       for_each_lower_domain(sd) {
                int load_idx = sd->forkexec_idx;
-               struct sched_group *group;
-               int weight;
-
-               if (!(sd->flags & sd_flag)) {
-                       sd = sd->child;
-                       continue;
-               }
+               int local = 0;
 
                if (sd_flag & SD_BALANCE_WAKE)
                        load_idx = sd->wake_idx;
 
-               group = find_idlest_group(sd, p, cpu, load_idx);
-               if (!group) {
-                       sd = sd->child;
-                       continue;
-               }
-
-               new_cpu = find_idlest_cpu(group, p, cpu);
-               if (new_cpu == -1 || new_cpu == cpu) {
-                       /* Now try balancing at a lower domain level of cpu */
-                       sd = sd->child;
+               group = find_idlest_group(sd, p, cpu, load_idx, &local);
+               if (local)
                        continue;
-               }
+               if (!group)
+                       goto unlock;
 
-               /* Now try balancing at a lower domain level of new_cpu */
-               cpu = new_cpu;
-               weight = sd->span_weight;
-               sd = NULL;
-               for_each_domain(cpu, tmp) {
-                       if (weight <= tmp->span_weight)
-                               break;
-                       if (tmp->flags & sd_flag)
+               /* go down from non-local group */
+               for_each_domain(group_first_cpu(group), tmp)
+                       if (cpumask_equal(sched_domain_span(tmp),
+                                               sched_group_cpus(group))) {
                                sd = tmp;
-               }
-               /* while loop will break here if sd == NULL */
+                               break;
+                       }
        }
+       if (group)
+               new_cpu = find_idlest_cpu(group, p, cpu);
 unlock:
        rcu_read_unlock();



-- 
Thanks Alex
