Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3ATPbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 10:31:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:61345 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab3ATPbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 10:31:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,500,1355126400"; 
   d="scan'208";a="193164629"
Message-ID: <50FC0DB1.6050605@intel.com>
Date: Sun, 20 Jan 2013 23:30:57 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Robin Randhawa <robin.randhawa@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
References: <50E3B61A.3040808@linux.vnet.ibm.com> <CAKfTPtDF==vxfLy8JA5UtszdRPFSoTs8t7LkdeUjUOM6SsF1PA@mail.gmail.com> <50EBB76A.3070501@linux.vnet.ibm.com> <CAKfTPtB4ABqkB=x6sUzCmvJCj6p+RaFKpGYneNt+zASyL-oU0w@mail.gmail.com> <50ECE097.7010609@linux.vnet.ibm.com>
In-Reply-To: <50ECE097.7010609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 11:14 AM, Preeti U Murthy wrote:
>>>>> Here comes the point of making both load balancing and wake up
>>>>> balance(select_idle_sibling) co operative. How about we always schedule
>>>>> the woken up task on the prev_cpu? This seems more sensible considering
>>>>> load balancing considers blocked load as being a part of the load of cpu2.
>>>>
>>>> Hi Preeti,
>>>>
>>>> I'm not sure that we want such steady state at cores level because we
>>>> take advantage of migrating wake up tasks between cores that share
>>>> their cache as Matthew demonstrated. But I agree that reaching such
>>>> steady state at cluster and CPU level is interesting.
>>>>
>>>> IMHO, you're right that taking the blocked load into consideration
>>>> should minimize tasks migration between cluster but it should no
>>>> prevent fast task migration between cores that share their cache
>>>
>>> True Vincent.But I think the one disadvantage even at cpu or cluster
>>> level is that when we consider blocked load, we might prevent any more
>>> tasks from being scheduled on that cpu during periodic load balance if
>>> the blocked load is too much.This is very poor cpu utilization
>>
>> The blocked load of a cluster will be high if the blocked tasks have
>> run recently. The contribution of a blocked task will be divided by 2
>> each 32ms, so it means that a high blocked load will be made of recent
>> running tasks and the long sleeping tasks will not influence the load
>> balancing.
>> The load balance period is between 1 tick (10ms for idle load balance
>> on ARM) and up to 256 ms (for busy load balance) so a high blocked
>> load should imply some tasks that have run recently otherwise your
>> blocked load will be small and will not have a large influence on your
>> load balance

Just tried using cfs's runnable_load_avg + blocked_load_avg in
weighted_cpuload() with my v3 patchset, aim9 shared workfile testing
show the performance dropped 70% more on the NHM EP machine. :(
