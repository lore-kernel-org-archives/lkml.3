Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaJIFMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 01:12:22 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36943 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaJIFML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 01:12:11 -0400
Message-ID: <54361922.8070808@linux.vnet.ibm.com>
Date: Thu, 09 Oct 2014 10:42:02 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
CC: svaidy@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        rjw@rjwysocki.net, lizefan@huawei.com,
        Anton Blanchard <anton@samba.org>, Tejun Heo <tj@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks hotplug
 invariant
References: <CAC4Lta2AS6M5upg8n9Qu5+1pqCMF3j8_cYuLAS1DH9C_BQP0PA@mail.gmail.com>
In-Reply-To: <CAC4Lta2AS6M5upg8n9Qu5+1pqCMF3j8_cYuLAS1DH9C_BQP0PA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100905-0033-0000-0000-00000248055A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Raghu,

On 10/08/2014 08:24 PM, Raghavendra KT wrote:
> On Wed, Oct 8, 2014 at 12:37 PM, Preeti U Murthy
> <preeti@linux.vnet.ibm.com> wrote:
>> There are two masks associated with cpusets. The cpus/mems_allowed
>> and effective_cpus/mems. On the legacy hierarchy both these masks
>> are consistent with each other. This is the intersection of their
>> value and the currently active cpus. This means that we destroy the
>> original values set in these masks on each cpu/mem hot unplug operation.
>>         As a consequence when we hot plug back the cpus/mems, the tasks
>> no longer run on them and performance degrades, inspite of having
>> resources to run on.
>>
>> This effect is not seen in the default hierarchy since the
>> allowed and effective masks are distinctly maintained.
>> allowed masks are never touched once configured and effective masks
>> alone are hotplug variant.
>>
>> This patch replicates the above design even for the legacy hierarchy,
>> so that:
>>
>> 1. Tasks always run on the cpus/memory nodes that they are allowed to run on
>> as long as they are online. The allowed masks are hotplug invariant.
>>
>> 2. When all cpus/memory nodes in a cpuset are hot unplugged out, the tasks
>> are moved to their nearest ancestor which has resources to run on.
> 
> Hi Preeti,
> 
> I may be missing some thing here could you please explain when do we get
> tasks move out of a cpuset after this patch and why it is even necessary?

On the legacy hierarchy the tasks are moved to their parents cpusets if
the cpuset to which they were initially bound becomes empty. What the
patch does has nothing to do with moving tasks when the cpuset to which
they are bound becomes empty.The point 2 above was mentioned to merely
state that this part of the behavior is not really changed with the
patch. The patch merely ensures that the original cpuset configuration
is not messed with during hotplug operations.

> 
> IIUC, with default hierarchy we should never hit a case where we have empty
> effective cpuset and hence remove_tasks_in_empty_cpuset should never happen. no?
> 
> if my assumption is correct then we should remove
> remove_tasks_in_empty_cpuset itself...

remove_tasks_in_empty_cpuset() is called on the legacy hierarchy when
the cpuset becomes empty, hence we require it. But you are right its not
called on the default hierarchy.

Regards
Preeti U Murthy
> 

