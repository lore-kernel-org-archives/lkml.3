Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbaAFNlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:41:53 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34615 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaAFNlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:41:51 -0500
MIME-Version: 1.0
In-Reply-To: <52B87149.4010801@arm.com>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org> <52B87149.4010801@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 6 Jan 2014 14:41:31 +0100
Message-ID: <CAKfTPtDmb1fa8PUcrqEGaoQLxoPBddu-Yn_oS8KwsCJJWJzQug@mail.gmail.com>
Subject: Re: [RFC] sched: CPU topology try
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 December 2013 18:22, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> Hi Vincent,
>
>
> On 18/12/13 14:13, Vincent Guittot wrote:
>>
>> This patch applies on top of the two patches [1][2] that have been
>> proposed by
>> Peter for creating a new way to initialize sched_domain. It includes some
>> minor
>> compilation fixes and a trial of using this new method on ARM platform.
>> [1] https://lkml.org/lkml/2013/11/5/239
>> [2] https://lkml.org/lkml/2013/11/5/449
>
>
> I came up w/ a similar implementation proposal for an arch specific
> interface for scheduler domain set-up a couple of days ago:
>
> [1] https://lkml.org/lkml/2013/12/13/182
>
> I had the following requirements in mind:
>
> 1) The arch should not be able to fine tune individual scheduler behaviour,
> i.e. get rid of the arch specific SD_FOO_INIT macros.
>
> 2) Unify the set-up code for conventional and NUMA scheduler domains.
>
> 3) The arch is able to specify additional scheduler domain level, other than
> SMT, MC, BOOK, and CPU.
>
> 4) Allow to integrate the provision of additional topology related data
> (e.g. energy information) to the scheduler.
>
> Moreover, I think now that:
>
> 5) Something like the existing default set-up via default_topology[] is
> needed to avoid code duplication for archs not interested in (3) or (4).

Hi Dietmar,

I agree. This default array is available in Peter's patch and my
patches overwrites the default array only if it wants to add more/new
levels

[snip]

>>
>> CPU2:
>> domain 0: span 2-3 level: SMT
>>      flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES |
>> SD_SHARE_POWERDOMAIN
>>      groups: 0 1
>>    domain 1: span 2-7 level: MC
>>        flags: SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>>        groups: 2-7 4-5 6-7
>>      domain 2: span 0-7 level: MC
>>          flags: SD_SHARE_PKG_RESOURCES
>>          groups: 2-7 0-1
>>        domain 3: span 0-15 level: CPU
>>            flags:
>>            groups: 0-7 8-15
>>
>> In this case, we have an aditionnal sched_domain MC level for this subset
>> (2-7)
>> of cores so we can trigger some load balance in this subset before doing
>> that
>> on the complete cluster (which is the last level of cache in my example)
>
>
> I think the weakest point right now is the condition in sd_init() where we
> convert the topology flags into scheduler behaviour. We not only introduce a
> very tight coupling between topology flags and scheduler domain level but
> also we need to follow a certain order in the initialization. This bit needs
> more thinking.

IMHO, these settings will disappear sooner or later, as an example the
idle/busy _idx are going to be removed by Alex's patch.

>
>
>>
>> We can add more levels that will describe other dependency/independency
>> like
>> the frequency scaling dependency and as a result the final sched_domain
>> topology will have additional levels (if they have not been removed during
>> the degenerate sequence)
>>
>> My concern is about the configuration of the table that is used to create
>> the
>> sched_domain. Some levels are "duplicated" with different flags
>> configuration
>> which make the table not easily readable and we must also take care of the
>> order  because parents have to gather all cpus of its childs. So we must
>> choose which capabilities will be a subset of the other one. The order is
>> almost straight forward when we describe 1 or 2 kind of capabilities
>> (package ressource sharing and power sharing) but it can become complex if
>> we
>> want to add more.
>
>
> I'm not sure if the idea to create a dedicated sched_domain level for every
> topology flag representing a specific functionality will scale. From the

It's up to the arch to decide how many levels they want to add; if a
dedicated level is needed or if it can gather some features/flags.
IMHO, having sub structs for energy information like what we have for
the cpu/group capacity will not prevent from having a 1st and quick
topology tree description

> perspective of energy-aware scheduling we need e.g. energy costs (P and C
> state) which can only be populated towards the scheduler via an additional
> sub-struct and additional function arch_sd_energy() like depicted in
> Morten's email:
>
> [2] lkml.org/lkml/2013/11/14/102
>

[snip]

>> +
>> +static int __init arm_sched_topology(void)
>> +{
>> +       sched_domain_topology = arm_topology;
>
>
> return missing

good catch

Thanks

Vincent
