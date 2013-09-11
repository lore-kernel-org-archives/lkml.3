Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3IKLNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:13:17 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:35263 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab3IKLNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:13:15 -0400
Message-ID: <52304F5A.8070509@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 16:39:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan> <522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan> <52304439.3030301@linux.vnet.ibm.com>
In-Reply-To: <52304439.3030301@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091111-1396-0000-0000-0000038A4A87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 03:51 PM, Srivatsa S. Bhat wrote:
> On 09/11/2013 04:04 AM, Rafael J. Wysocki wrote:
>> On Tuesday, September 10, 2013 02:53:01 PM Stephen Warren wrote:
>>> On 09/09/2013 05:14 PM, Rafael J. Wysocki wrote:
>>>> On Monday, September 09, 2013 03:29:06 PM Stephen Warren wrote:
>>>>> On 09/09/2013 02:24 PM, Rafael J. Wysocki wrote:
>>>>>> On Monday, September 09, 2013 02:01:32 PM Stephen Warren wrote:
>>>>>>> On 09/09/2013 02:01 PM, Rafael J. Wysocki wrote:
>>>>>>>> On Monday, September 09, 2013 01:22:23 PM Stephen Warren wrote:
>>>>>>>>> Viresh,
>>>>>>>>>
>>>>>>>>> I'm seeing the crash below when suspending my system for the second time.
>>>>>>>>>
>>>>>>>>> I can avoid this with the following patch, which adds a check which
>>>>>>>>> already exists in all-but-one other places that the same lookup is made:
>>>>>>>>
>>>>>>>> Which kernel did you test?
>>>>>>>
>>>>>>> next-20130909.
>>>>>>
>>>>>> Is it reproducible with the current mainline?
>>>>>
>>>>> This does not affect v3.11, but does affect current HEAD; 300893b "Merge
>>>>> tag 'xfs-for-linus-v3.12-rc1' of git://oss.sgi.com/xfs/xfs".
>>>>
>>>> What system does it break on?
>>>
>>> A dual-core ARM system (NVIDIA Tegra20 SoC, Harmony board).
>>>
>>>> Any chance to bisect cpufreq changes between 3.11 and the current HEAD?
>>>
>>> Sure, it's due to 5302c3f "cpufreq: Perform light-weight init/teardown
>>> during suspend/resume".
>>
>> Thanks!
>>
>> Srivatsa, any chance to look into this?
>>
> 
> Sure, Rafael. Thanks for CC'ing me.
> 
> Stephen, I went through the code and I think I found out what is going wrong.
> Can you please try the following patch?
> 
> Regards,
> Srivatsa S. Bhat
> 
> ----------------------------------------------------------------------------
> 
> 
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] cpufreq: Fix crash in cpufreq-stats during suspend/resume
> 

And here is a follow-up patch, on top of this one. I hit the bug while working
on this patch, but it doesn't occur in practice, since none of the existing
callers call update_policy_cpu() with new == old. (I had called it like that
by mistake while working on the fix and was surprised by the level of problems
it caused; hence thought of adding a check).

Regards,
Srivatsa S. Bhat

-----------------------------------------------------------------------------
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] cpufreq: Prevent problems in update_policy_cpu() if last_cpu == new_cpu

If update_policy_cpu() is invoked with the existing policy->cpu itself
as the new-cpu parameter, then a lot of things can go terribly wrong.

In its present form, update_policy_cpu() always assumes that the new-cpu
is different from policy->cpu and invokes other functions to perform their
respective updates. And those functions implement the actual update like
this:

per_cpu(..., new_cpu) = per_cpu(..., last_cpu);
per_cpu(..., last_cpu) = NULL;

Thus, when new_cpu == last_cpu, the final NULL assignment makes the per-cpu
references vanish into thin air! (memory leak). From there, it leads to more
problems: cpufreq_stats_create_table() now doesn't find the per-cpu reference
and hence tries to create a new sysfs-group; but sysfs already had created
the group earlier, so it complains that it cannot create a duplicate filename.
In short, the repercussions of a rather innocuous invocation of
update_policy_cpu() can turn out to be pretty nasty.

Ideally update_policy_cpu() should handle this situation (new == last)
gracefully, and not lead to such severe problems. So fix it by adding an
appropriate check.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 62bdb95..a61b7a1 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -949,6 +949,9 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
 
 static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 {
+	if (cpu == policy->cpu)
+		return;
+
 	policy->last_cpu = policy->cpu;
 	policy->cpu = cpu;
 

