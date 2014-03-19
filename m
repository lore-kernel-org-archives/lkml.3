Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965165AbaCSNqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:46:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58735 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbaCSNqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:46:43 -0400
Message-ID: <53299FCB.1070109@arm.com>
Date: Wed, 19 Mar 2014 13:46:51 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v2 2/7] sched: rework of sched_domain topology definition
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org> <1395165409-18055-3-git-send-email-vincent.guittot@linaro.org> <53297F10.3050106@arm.com> <20140319124149.GM27632@laptop.programming.kicks-ass.net>
In-Reply-To: <20140319124149.GM27632@laptop.programming.kicks-ass.net>
X-OriginalArrivalTime: 19 Mar 2014 13:46:53.0352 (UTC) FILETIME=[AF9E3A80:01CF4379]
X-MC-Unique: 114031913464105601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/14 12:41, Peter Zijlstra wrote:
> 
> The keyboard deity gave us delete, please apply graciously when replying
> to large emails.

Sorry about that, will do next time.

> 
> On Wed, Mar 19, 2014 at 11:27:12AM +0000, Dietmar Eggemann wrote:
>> On 18/03/14 17:56, Vincent Guittot wrote:
>>> +       if (sd->flags & SD_SHARE_CPUPOWER) {
>>> +               sd->imbalance_pct = 110;
>>> +               sd->smt_gain = 1178; /* ~15% */
>>> +               sd->flags |= arch_sd_sibling_asym_packing();
>>> +
>>> +       } else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
>>> +               sd->imbalance_pct = 117;
>>> +               sd->cache_nice_tries = 1;
>>> +               sd->busy_idx = 2;
>>> +
>>> +#ifdef CONFIG_NUMA
>>> +       } else if (sd->flags & SD_NUMA) {
>>> +               sd->cache_nice_tries = 2;
>>> +               sd->busy_idx = 3;
>>> +               sd->idle_idx = 2;
>>> +
>>> +               sd->flags |= SD_SERIALIZE;
>>> +               if (sched_domains_numa_distance[tl->numa_level] > RECLAIM_DISTANCE) {
>>> +                       sd->flags &= ~(SD_BALANCE_EXEC |
>>> +                                      SD_BALANCE_FORK |
>>> +                                      SD_WAKE_AFFINE);
>>> +               }
>>> +
>>> +#endif
>>> +       } else {
>>> +               sd->flags |= SD_PREFER_SIBLING;
>>> +               sd->cache_nice_tries = 1;
>>> +               sd->busy_idx = 2;
>>> +               sd->idle_idx = 1;
>>> +       }
>>
>> This 'if ... else statement' is still a weak point from the perspective
>> of making the code robust:
> 
> <snip>
> 
>> Is there a way to check that MC and GMC have to have
>> SD_SHARE_PKG_RESOURCES set so that this can't happen unnoticed?
> 
> So from the core codes perspective those names mean less than nothing.
> Its just a string to carry along for us meat-bags. The string isn't even
> there when !SCHED_DEBUG.
> 
> So from this codes POV you told it it had a domain without PKGSHARE,
> that's fine.

I see your point. So what we want to avoid is to enable archs to create
different (per-cpu) set-ups inside a domain (as a specific set of cpu's
from a viewpoint of a cpu) but misconfiguration of the whole domain is a
different story. Got it!

> 
> That said; yeah the thing isn't the prettiest piece of code. But it has
> the big advantage of being the one place where we convert topology into
> behaviour.
> 


