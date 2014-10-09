Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaJIIVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:21:19 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35554 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaJIIVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:21:11 -0400
Message-ID: <54364564.3090305@linux.vnet.ibm.com>
Date: Thu, 09 Oct 2014 13:50:52 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, lizefan@huawei.com, anton@samba.org,
        tj@kernel.org
CC: svaidy@linux.vnet.ibm.com, rjw@rjwysocki.net, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks hotplug
 invariant
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com> <20141008080706.GC10832@worktop.programming.kicks-ass.net> <543505EF.7070804@linux.vnet.ibm.com> <20141008101828.GG10832@worktop.programming.kicks-ass.net>
In-Reply-To: <20141008101828.GG10832@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100908-0025-0000-0000-000000B49C6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 03:48 PM, Peter Zijlstra wrote:
> On Wed, Oct 08, 2014 at 03:07:51PM +0530, Preeti U Murthy wrote:
> 
>>> I still completely hate all that.. It basically makes cpusets useless,
>>> they no longer guarantee anything, it makes then an optional placement
>>> hint instead.
>>
>> Why do you say they don't guarantee anything? We ensure that we always
>> run on the cpus in our cpuset which are online. We do not run in any
>> arbitrary cpuset. We also do not wait unreasonably on an offline cpu to
>> come back. What we are doing is ensuring that if the resources that we
>> began with are available we use them. Why is this not a logical thing to
>> expect?
> 
> Because if you randomly hotplug cpus your tasks can randomly flip
> between sets.
> 
> Therefore there is no strict containment and no guarantees.
> 
>>> You also break long standing behaviour.
>>
>> Which is? As I understand cpusets are meant to ensure a dedicated set of
>> resources to some tasks. We cannot scheduler the tasks anywhere outside
>> this set as long as they are available. And when they are not, currently
>> we move them to their parents,
> 
> No currently we hard break affinity and never look back. That move to
> parent and back crap is all new fangled stuff, and broken because of the
> above argument.
> 
>> but you had also suggested killing the
>> task. Maybe this can be debated. But what behavior are we changing by
>> ensuring that we retain our original configuration at all times?
> 
> See above, by pretending hotplug is a sane operation you loose all
> guarantees.

Ok I see the point. The kernel must not be bothered about keeping
cpusets and hotplug operations consistent when both of these are user
initiated actions specifying affinity with the former and breaking the
same with the latter.

> 
>>> Also, power is insane if it needs/uses hotplug for operational crap
>>> like that.
>>
>> SMT 8 on Power8 can help/hinder workloads. Hence we dynamically switch
>> the modes at runtime.
> 
> That's just a horrible piece of crap hack and you deserve any and all
> pain you get from doing it.
> 
> Randomly removing/adding cpus like that is horrible and makes a mockery
> of all the affinity interfaces we have.

We observed this on ubuntu kernel, in which systemd explicitly mounts
cgroup controllers under a child cgroup identified by the user pid.
Since we had not observed this additional cgroup being added under the
hood, it came as a surprise to us that cgroup/cpuset handling in the
kernel should indeed kick in.

At best we expect hotplug to be handled well if the users have not
explicitly configured cpusets, hence implicitly specifying that task
affinity is for all online cpus. This is indeed the case today, so that
is good.

However what remains to be answered is that the V2 of cgroup design -
the default hierarchy, tracks hotplug operations for children cgroups as
well. Tejun, Li, will not the concerns that Peter raised above hold for
the default hierarchy as well?

Regards
Preeti U Murthy
> 

