Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbaCSLJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:09:17 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60861 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759053AbaCSLJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:09:15 -0400
Message-ID: <532979E6.8070402@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 16:35:10 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v2 5/7] sched: add a new SD_SHARE_POWERDOMAIN for sched_domain
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org> <1395165409-18055-6-git-send-email-vincent.guittot@linaro.org> <53293782.9060708@linux.vnet.ibm.com> <CAKfTPtA3GTZM_M=0yqOMLspXYHb9V32f1g0a+zs9_8DtX9xUow@mail.gmail.com>
In-Reply-To: <CAKfTPtA3GTZM_M=0yqOMLspXYHb9V32f1g0a+zs9_8DtX9xUow@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031911-0320-0000-0000-000002B95FC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 03:22 PM, Vincent Guittot wrote:
> On 19 March 2014 07:21, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> Hi Vincent,
>>
>> On 03/18/2014 11:26 PM, Vincent Guittot wrote:
>>> A new flag SD_SHARE_POWERDOMAIN is created to reflect whether groups of CPUs
>>> in a sched_domain level can or not reach different power state. As an example,
>>> the flag should be cleared at CPU level if groups of cores can be power gated
>>> independently. This information can be used to add load balancing level between
>>> group of CPUs than can power gate independantly. The default behavior of the
>>> scheduler is to spread tasks across CPUs and groups of CPUs so the flag is set
>>> into all sched_domains.
>>
>> I don't see this flag being set either in sd_init() or in
>> default_topology[]. Should not the default_topology[] flag setting
>> routines set this flag at every level of sched domain along with other
>> topology flags, unless the arch wants to override it?
> 
> Hi Preeti
> 
> I have made the choice to not add it in the default table for the
> moment because the scheduler behavior is not changed. It will be added
> with patchset that will take advantage of this flag in the load
> balance decision.

Ok if you are looking at setting this flag in the default topology table
then [patch 7/7]:sched: powerpc: Add SD_SHARE_POWERDOMAIN for SMT level
looks good to me. Please add my Reviewed-by to this patch.

However if you are looking at initializing this flag as being set by
default in sd_init() then the archs will have to revert the flag, rather
than set it in their respective topology tables for the sched domains
which have their groups power gated. In which case the    [patch 7/7]
would be incorrect.
   But wait, I see that you  mention that the topology level flags are
left to the archs to set if required. So I am assuming you will not set
the SD_SHARE_POWER_DOMAIN flag in sd_init() right?

Regards
Preeti U Murthy
> 
> Regards,
> Vincent
> 
>>
>> Regards
>> Preeti U Murthy
>>> This flag is part of the topology flags that can be set by arch.
>>>
>>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>>> ---
>>>  include/linux/sched.h | 1 +
>>>  kernel/sched/core.c   | 9 ++++++---
>>>  2 files changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>> index 6479de4..7048369 100644
>>> --- a/include/linux/sched.h
>>> +++ b/include/linux/sched.h
>>> @@ -861,6 +861,7 @@ enum cpu_idle_type {
>>>  #define SD_BALANCE_WAKE              0x0010  /* Balance on wakeup */
>>>  #define SD_WAKE_AFFINE               0x0020  /* Wake task to waking CPU */
>>>  #define SD_SHARE_CPUPOWER    0x0080  /* Domain members share cpu power */
>>> +#define SD_SHARE_POWERDOMAIN 0x0100  /* Domain members share power domain */
>>>  #define SD_SHARE_PKG_RESOURCES       0x0200  /* Domain members share cpu pkg resources */
>>>  #define SD_SERIALIZE         0x0400  /* Only a single load balancing instance */
>>>  #define SD_ASYM_PACKING              0x0800  /* Place busy groups earlier in the domain */
>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>> index 0b51ee3..224ec3b 100644
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -5298,7 +5298,8 @@ static int sd_degenerate(struct sched_domain *sd)
>>>                        SD_BALANCE_FORK |
>>>                        SD_BALANCE_EXEC |
>>>                        SD_SHARE_CPUPOWER |
>>> -                      SD_SHARE_PKG_RESOURCES)) {
>>> +                      SD_SHARE_PKG_RESOURCES |
>>> +                      SD_SHARE_POWERDOMAIN)) {
>>>               if (sd->groups != sd->groups->next)
>>>                       return 0;
>>>       }
>>> @@ -5329,7 +5330,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
>>>                               SD_BALANCE_EXEC |
>>>                               SD_SHARE_CPUPOWER |
>>>                               SD_SHARE_PKG_RESOURCES |
>>> -                             SD_PREFER_SIBLING);
>>> +                             SD_PREFER_SIBLING |
>>> +                             SD_SHARE_POWERDOMAIN);
>>>               if (nr_node_ids == 1)
>>>                       pflags &= ~SD_SERIALIZE;
>>>       }
>>> @@ -5946,7 +5948,8 @@ static int sched_domains_curr_level;
>>>       (SD_SHARE_CPUPOWER |            \
>>>        SD_SHARE_PKG_RESOURCES |       \
>>>        SD_NUMA |                      \
>>> -      SD_ASYM_PACKING)
>>> +      SD_ASYM_PACKING |              \
>>> +      SD_SHARE_POWERDOMAIN)
>>>
>>>  static struct sched_domain *
>>>  sd_init(struct sched_domain_topology_level *tl, int cpu)
>>>
>>
> 

