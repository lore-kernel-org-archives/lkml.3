Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaAGJnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:43:55 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:46682 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaAGJnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:43:52 -0500
Message-ID: <52CBCB85.8050607@linux.vnet.ibm.com>
Date: Tue, 07 Jan 2014 15:10:21 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        Morten.Rasmussen@arm.com, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@linaro.org, linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        james.hogan@imgtec.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, Dietmar.Eggemann@arm.com
Subject: Re: [RFC] sched: CPU topology try
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net> <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010709-9332-0000-0000-000002AEA383
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent, Peter,

On 12/18/2013 06:43 PM, Vincent Guittot wrote:
> This patch applies on top of the two patches [1][2] that have been proposed by
> Peter for creating a new way to initialize sched_domain. It includes some minor
> compilation fixes and a trial of using this new method on ARM platform.
> [1] https://lkml.org/lkml/2013/11/5/239
> [2] https://lkml.org/lkml/2013/11/5/449
> 
> Based on the results of this tests, my feeling about this new way to init the
> sched_domain is a bit mitigated.
> 
> The good point is that I have been able to create the same sched_domain
> topologies than before and even more complex ones (where a subset of the cores
> in a cluster share their powergating capabilities). I have described various
> topology results below.
> 
> I use a system that is made of a dual cluster of quad cores with hyperthreading
> for my examples.
> 
> If one cluster (0-7) can powergate its cores independantly but not the other
> cluster (8-15) we have the following topology, which is equal to what I had
> previously:
> 
> CPU0:
> domain 0: span 0-1 level: SMT
>     flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>     groups: 0 1
>   domain 1: span 0-7 level: MC
>       flags: SD_SHARE_PKG_RESOURCES
>       groups: 0-1 2-3 4-5 6-7
>     domain 2: span 0-15 level: CPU
>         flags:
>         groups: 0-7 8-15
> 
> CPU8
> domain 0: span 8-9 level: SMT
>     flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>     groups: 8 9
>   domain 1: span 8-15 level: MC
>       flags: SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>       groups: 8-9 10-11 12-13 14-15
>     domain 2: span 0-15 level CPU
>         flags:
>         groups: 8-15 0-7
> 
> We can even describe some more complex topologies if a susbset (2-7) of the
> cluster can't powergate independatly:
> 
> CPU0:
> domain 0: span 0-1 level: SMT
>     flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>     groups: 0 1
>   domain 1: span 0-7 level: MC
>       flags: SD_SHARE_PKG_RESOURCES
>       groups: 0-1 2-7
>     domain 2: span 0-15 level: CPU
>         flags:
>         groups: 0-7 8-15
> 
> CPU2:
> domain 0: span 2-3 level: SMT
>     flags: SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>     groups: 0 1
>   domain 1: span 2-7 level: MC
>       flags: SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN
>       groups: 2-7 4-5 6-7
>     domain 2: span 0-7 level: MC
>         flags: SD_SHARE_PKG_RESOURCES
>         groups: 2-7 0-1
>       domain 3: span 0-15 level: CPU
>           flags:
>           groups: 0-7 8-15
> 
> In this case, we have an aditionnal sched_domain MC level for this subset (2-7)
> of cores so we can trigger some load balance in this subset before doing that
> on the complete cluster (which is the last level of cache in my example)
> 
> We can add more levels that will describe other dependency/independency like
> the frequency scaling dependency and as a result the final sched_domain
> topology will have additional levels (if they have not been removed during
> the degenerate sequence)
> 
> My concern is about the configuration of the table that is used to create the
> sched_domain. Some levels are "duplicated" with different flags configuration
> which make the table not easily readable and we must also take care of the
> order  because parents have to gather all cpus of its childs. So we must
> choose which capabilities will be a subset of the other one. The order is
> almost straight forward when we describe 1 or 2 kind of capabilities
> (package ressource sharing and power sharing) but it can become complex if we
> want to add more.

What if we want to add arch specific flags to the NUMA domain? Currently
with Peter's patch:https://lkml.org/lkml/2013/11/5/239 and this patch,
the arch can modify the sd flags of the topology levels till just before
the NUMA domain. In sd_init_numa(), the flags for the NUMA domain get
initialized. We need to perhaps call into arch here to probe for
additional flags?

Thanks

Regards
Preeti U Murthy
> 
> Regards
> Vincent
> 

