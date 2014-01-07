Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaAGMkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:40:31 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37742 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaAGMkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:40:22 -0500
MIME-Version: 1.0
In-Reply-To: <52C3A0F1.3040803@linux.vnet.ibm.com>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org> <52C3A0F1.3040803@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 7 Jan 2014 13:40:02 +0100
Message-ID: <CAKfTPtBgUinz2Db0L_iVMQ9uZEkhQA_vdorA8GjP=wA2mTVvHQ@mail.gmail.com>
Subject: Re: [RFC] sched: CPU topology try
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jon Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 January 2014 06:00, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> Hi Vincent,
>
> On 12/18/2013 06:43 PM, Vincent Guittot wrote:
>> This patch applies on top of the two patches [1][2] that have been proposed by
>> Peter for creating a new way to initialize sched_domain. It includes some minor
>> compilation fixes and a trial of using this new method on ARM platform.
>> [1] https://lkml.org/lkml/2013/11/5/239
>> [2] https://lkml.org/lkml/2013/11/5/449
>>
>> Based on the results of this tests, my feeling about this new way to init the
>> sched_domain is a bit mitigated.
>>
>> The good point is that I have been able to create the same sched_domain
>> topologies than before and even more complex ones (where a subset of the cores
>> in a cluster share their powergating capabilities). I have described various
>> topology results below.
>>
>> I use a system that is made of a dual cluster of quad cores with hyperthreading
>> for my examples.
>>
>> If one cluster (0-7) can powergate its cores independantly but not the other
>> cluster (8-15) we have the following topology, which is equal to what I had
>> previously:
>>
>> CPU0:
>> domain 0: span 0-1 level: SMT
>>     flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>>     groups: 0 1
>>   domain 1: span 0-7 level: MC
>>       flags: SD_SHARE_PKG_RESOURCES
>>       groups: 0-1 2-3 4-5 6-7
>>     domain 2: span 0-15 level: CPU
>>         flags:
>>         groups: 0-7 8-15
>>
>> CPU8
>> domain 0: span 8-9 level: SMT
>>     flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>>     groups: 8 9
>>   domain 1: span 8-15 level: MC
>>       flags: SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>>       groups: 8-9 10-11 12-13 14-15
>>     domain 2: span 0-15 level CPU
>>         flags:
>>         groups: 8-15 0-7
>>
>> We can even describe some more complex topologies if a susbset (2-7) of the
>> cluster can't powergate independatly:
>>
>> CPU0:
>> domain 0: span 0-1 level: SMT
>>     flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>>     groups: 0 1
>>   domain 1: span 0-7 level: MC
>>       flags: SD_SHARE_PKG_RESOURCES
>>       groups: 0-1 2-7
>>     domain 2: span 0-15 level: CPU
>>         flags:
>>         groups: 0-7 8-15
>>
>> CPU2:
>> domain 0: span 2-3 level: SMT
>>     flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>>     groups: 0 1
>>   domain 1: span 2-7 level: MC
>>       flags: SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>>       groups: 2-7 4-5 6-7
>>     domain 2: span 0-7 level: MC
>>         flags: SD_SHARE_PKG_RESOURCES
>>         groups: 2-7 0-1
>>       domain 3: span 0-15 level: CPU
>>           flags:
>>           groups: 0-7 8-15
>>
>> In this case, we have an aditionnal sched_domain MC level for this subset (2-7)
>> of cores so we can trigger some load balance in this subset before doing that
>> on the complete cluster (which is the last level of cache in my example)
>>
>> We can add more levels that will describe other dependency/independency like
>> the frequency scaling dependency and as a result the final sched_domain
>> topology will have additional levels (if they have not been removed during
>> the degenerate sequence)
>
> The design looks good to me. In my opinion information like P-states and
> C-states dependency can be kept separate from the topology levels, it
> might get too complicated unless the information is tightly coupled to
> the topology.
>
>>
>> My concern is about the configuration of the table that is used to create the
>> sched_domain. Some levels are "duplicated" with different flags configuration
>
> I do not feel this is a problem since the levels are not duplicated,
> rather they have different properties within them which is best
> represented by flags like you have introduced in this patch.
>
>> which make the table not easily readable and we must also take care of the
>> order  because parents have to gather all cpus of its childs. So we must
>> choose which capabilities will be a subset of the other one. The order is
>
> The sched domain levels which have SD_SHARE_POWERDOMAIN set is expected
> to have cpus which are a subset of the cpus that this domain would have
> included had this flag not been set. In addition to this every higher
> domain, irrespective of SD_SHARE_POWERDOMAIN being set, will include all
> cpus of the lower domains. As far as I see, this patch does not change
> these assumptions. Hence I am unable to imagine a scenario when the
> parent might not include all cpus of its children domain. Do you have
> such a scenario in mind which can arise due to this patch ?

My patch doesn't have issue because i have added only 1 layer which is
always a subset of the current cache level topology but if we add
another feature with another layer, we have to decide which feature
will be a subset of the other one.

Vincent

>
> Thanks
>
> Regards
> Preeti U Murthy
>
