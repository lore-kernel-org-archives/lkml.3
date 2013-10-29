Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3J2Fig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:38:36 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51055 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3J2Fie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:38:34 -0400
Message-ID: <526F4923.8020400@linux.vnet.ibm.com>
Date: Tue, 29 Oct 2013 11:05:31 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/3] sched: Aggressive balance in domains whose groups
 share package resources
References: <20131021114002.13291.31478.stgit@drishya> <20131021114502.13291.60794.stgit@drishya> <20131028155316.GQ19466@laptop.lan>
In-Reply-To: <20131028155316.GQ19466@laptop.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102905-5816-0000-0000-00000A9FB80F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 10/28/2013 09:23 PM, Peter Zijlstra wrote:
> On Mon, Oct 21, 2013 at 05:15:02PM +0530, Vaidyanathan Srinivasan wrote:
>> From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>>
>> The current logic in load balance is such that after picking the
>> busiest group, the load is attempted to be moved from the busiest cpu
>> in that group to the dst_cpu. If the load cannot be moved from the
>> busiest cpu to dst_cpu due to either tsk_cpus_allowed mask or cache
>> hot tasks, then the dst_cpu is changed to be another idle cpu within
>> the dst->grpmask. If even then, the load cannot be moved from the
>> busiest cpu, then the source group is changed. The next busiest group
>> is found and the above steps are repeated.
>>
>> However if the cpus in the group share package resources, then when
>> a load movement from the busiest cpu in this group fails as above,
>> instead of finding the next busiest group to move load from, find the
>> next busiest cpu *within the same group* from which to move load away.
>> By doing so, a conscious effort is made during load balancing to keep
>> just one cpu busy as much as possible within domains that have
>> SHARED_PKG_RESOURCES flag set unless under scenarios of high load.
>> Having multiple cpus busy within a domain which share package resource
>> could lead to a performance hit.
>>
>> A similar scenario arises in active load balancing as well. When the
>> current task on the busiest cpu cannot be moved away due to task
>> pinning, currently no more attempts at load balancing is made.
> 
>> This
>> patch checks if the balancing is being done on a group whose cpus
>> share package resources. If so, then check if the load balancing can
>> be done for other cpus in the same group.
> 
> So I absolutely hate this patch... Also I'm not convinced I actually
> understand the explanation above.
> 
> Furthermore; there is nothing special about spreading tasks for
> SHARED_PKG_RESOURCES and special casing that one case is just wrong.
> 
> If anything it should be keyed off of SD_PREFER_SIBLING and or
> cpu_power.

At a SIBLING level, which has SHARED_PKG_RESOURCES set, cpu_power in
fact takes care of ensuring that the scheduler mostly spreads the load
when there is more than one running task by nominating the group as
busy. But the issue that this patch is bringing to the front is a bit
different; its not during the time of this nomination, its at the time
of load balancing. It is explained below.

So metrics like cpu_power and flags like SD_PREFER_SIBLING ensure that
we spread the load by nominating such groups as busiest in
update_sg_lb_stats() and update_sd_lb_stats(). So "nominating a group"
as busiest by virtue of cpu_power or flags is taken care of.

However, in load_balance(), if the imbalance cannot be offset by moving
load from the busiest_cpu in the busiest_group, then today we do not try
the *next busiest cpu in the group*; instead we try the next busiest_group.

So whatever effort we put in by nominating this group as busiest, if the
grp_power and flags do not favour tasks on it, seems relevant only if
the busiest cpu in that group co-operates in offloading tasks. Should we
not be trying our best to move load from any other cpu in this group ?

This patch identifies one such situation, which led to too many tasks on
a core and got me to ponder over this question. I agree that the fix in
this patch is not right. But I thought this would open up discussion
around the above question. Its true that iterating over all the cpus in
a group during the actual load balance is too much of an overhead, but
isn't there a balance we can strike during load balance iterations for
such groups which have limited cpu power?
> 
Thanks

Regards
Preeti U Murthy

