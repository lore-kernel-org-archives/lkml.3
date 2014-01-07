Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaAGQfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:35:44 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:55671 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbaAGQfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:35:30 -0500
Message-ID: <52CC2BFC.8080405@linux.vnet.ibm.com>
Date: Tue, 07 Jan 2014 22:01:56 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>, Morten.Rasmussen@arm.com
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@linaro.org,
        linaro-kernel@lists.linaro.org, rafael.j.wysocki@intel.com,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        james.hogan@imgtec.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, Dietmar.Eggemann@arm.com
Subject: Re: [RFC] sched: CPU topology try
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net> <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org> <52CBCB85.8050607@linux.vnet.ibm.com> <20140107095039.GA2480@laptop.programming.kicks-ass.net> <52CBD96B.4050103@linux.vnet.ibm.com> <20140107111341.GS31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140107111341.GS31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010716-0928-0000-0000-0000056A1994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 04:43 PM, Peter Zijlstra wrote:
> On Tue, Jan 07, 2014 at 04:09:39PM +0530, Preeti U Murthy wrote:
>> On 01/07/2014 03:20 PM, Peter Zijlstra wrote:
>>> On Tue, Jan 07, 2014 at 03:10:21PM +0530, Preeti U Murthy wrote:
>>>> What if we want to add arch specific flags to the NUMA domain? Currently
>>>> with Peter's patch:https://lkml.org/lkml/2013/11/5/239 and this patch,
>>>> the arch can modify the sd flags of the topology levels till just before
>>>> the NUMA domain. In sd_init_numa(), the flags for the NUMA domain get
>>>> initialized. We need to perhaps call into arch here to probe for
>>>> additional flags?
>>>
>>> What are you thinking of? I was hoping all NUMA details were captured in
>>> the distance table.
>>>
>>> Its far easier to talk of specifics in this case.
>>>
>> If the processor can be core gated, then there is very little power
>> savings that we could yield from consolidating all the load onto a
>> single node in a NUMA domain. 6 cores on one node or 3 cores each on two
>> nodes, the power is drawn by 6 cores in all. So I was thinking under
>> this circumstance we might want to set the SD_SHARE_POWERDOMAIN flag at
>> the NUMA domain and spread the load if it favours the workload.
> 
> So Intel has so far not said a lot of sensible things about power
> management on their multi-socket platform.
> 
> And I've not heard anything at all from IBM on the POWER chips.
> 
> What I know from the Intel side is that packet idle hardly saves
> anything when compared to the DRAM power and the cost of having to do
> remote memory accesses.
> 
> In other words, I'm not at all considering power aware scheduling for
> NUMA systems until someone starts talking sense :-)
> 

On Power8 systems, most of the cpuidle power management is done at the
core level. Doing so is expected to yield us good power savings without
much loss of performance, with little exit latency from these idle
states and little overhead obtained from re-initialization of the cores.

However doing idle power management at a node level could hit
performance although good power savings is obtained due to the overhead
of re-initialization of the node which could be significant and of
course the large exit latency from such idle states.

Therefore we would try and consolidate load to cores as much as possible
rather than to nodes so as to leave as many cores idle. Again
consolidation to cores needs to be to 3-4 threads in a core. With 8
threads in a core, running just one thread would hardly do justice to
the core's resources. At the same time running the core full throttle
would hit performance. Hence a fine balance could be obtained by
consolidating load to minimum number of threads.
  *Consolidating load to core and spreading the load across nodes* would
probably help memory intensive workloads finish faster due to less
contention on local node memory and can get the cores to idle faster.

Thanks

Regards
Preeti U Murthy

