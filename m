Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab3ILGZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:25:54 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48994 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab3ILGZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:25:51 -0400
Message-ID: <52315D7D.3030406@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 11:51:49 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] cpufreq: Prevent problems in update_policy_cpu()
 if last_cpu == new_cpu
References: <20130911201239.7832.72612.stgit@srivatsabhat.in.ibm.com> <20130911201334.7832.49714.stgit@srivatsabhat.in.ibm.com> <CAKohpomgd8X4UwFaVtJ49=CXTg2cyEirvD4_mj5ohqS5fk064Q@mail.gmail.com>
In-Reply-To: <CAKohpomgd8X4UwFaVtJ49=CXTg2cyEirvD4_mj5ohqS5fk064Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091206-5816-0000-0000-000009DCF11F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:39 AM, Viresh Kumar wrote:
> On 12 September 2013 01:43, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> If update_policy_cpu() is invoked with the existing policy->cpu itself
>> as the new-cpu parameter, then a lot of things can go terribly wrong.
>>
>> In its present form, update_policy_cpu() always assumes that the new-cpu
>> is different from policy->cpu and invokes other functions to perform their
>> respective updates. And those functions implement the actual update like
>> this:
>>
>> per_cpu(..., new_cpu) = per_cpu(..., last_cpu);
>> per_cpu(..., last_cpu) = NULL;
>>
>> Thus, when new_cpu == last_cpu, the final NULL assignment makes the per-cpu
>> references vanish into thin air! (memory leak). From there, it leads to more
>> problems: cpufreq_stats_create_table() now doesn't find the per-cpu reference
>> and hence tries to create a new sysfs-group; but sysfs already had created
>> the group earlier, so it complains that it cannot create a duplicate filename.
>> In short, the repercussions of a rather innocuous invocation of
>> update_policy_cpu() can turn out to be pretty nasty.
>>
>> Ideally update_policy_cpu() should handle this situation (new == last)
>> gracefully, and not lead to such severe problems. So fix it by adding an
>> appropriate check.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> Tested-by: Stephen Warren <swarren@nvidia.com>
>> ---
>>
>>  drivers/cpufreq/cpufreq.c |    3 +++
>>  1 file changed, 3 insertions(+)
> 
> We don't need this patch for the reasons that I outlined in other thread.

Yeah, we don't need it, but its a good-to-have.

> We should never call this routine when cpu == policy->cpu
> 

Yeah, that's the rule. But no harm in having safe-guards to prevent catastrophes
when we have bugs (code which breaks the rule). Its the same as what we
regularly do in code that access pointers:

if (!ptr)
	return;
or

if (ptr)
	ptr->field = value;

Not having these checks crashes the kernel in case of a bug, which is far more
disastrous than surviving the erroneous input and returning an error code
gracefully. Same analogy applies to this patch as well.

That said, indeed currently there is no code in cpufreq that invokes the
function with last == new. So its not like we are masking an existing bug with
this patch. If you like, perhaps we can change this patch to print a warning
when it gets input values with last == new? That prevents disasters and also
warns when some code is buggy. Sounds like a win-win.

Regards,
Srivatsa S. Bhat

