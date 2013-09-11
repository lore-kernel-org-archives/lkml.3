Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab3IKTuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:50:40 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:46095 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab3IKTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:50:37 -0400
Message-ID: <5230C89D.7010801@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 01:16:37 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan> <522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan> <52304439.3030301@linux.vnet.ibm.com> <523094CD.3000506@wwwdotorg.org> <5230B078.3070306@linux.vnet.ibm.com> <5230B991.3040702@linux.vnet.ibm.com> <5230BE75.7040307@wwwdotorg.org>
In-Reply-To: <5230BE75.7040307@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091119-5816-0000-0000-000009DB888B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 12:33 AM, Stephen Warren wrote:
> On 09/11/2013 12:42 PM, Srivatsa S. Bhat wrote:
> ...
>> OK, I took a second look at the code, and I suspect that applying the
>> second patch might help. So can you try by applying both the patches
>> please[1][2]?
>>
> ...
>> [1]. http://marc.info/?l=linux-kernel&m=137889516210816&w=2
>> [2]. http://marc.info/?l=linux-kernel&m=137889800511940&w=2
> 
> Yes, with both of those patches applies, the problem is solved:-)
> 
> I was going to test the second patch originally, but it sounded like it
> was more of a cleanup rather than a fix for my issue, so I didn't bother
> when I found the problem wasn't solved by patch 1. Sorry!
> 

Well, honestly, even I had intended the second patch as a cleanup and
hadn't asked you to test it ;-) Only when you reported that the first patch
failed to solve your problem, I realized that the second patch was
important too! :-) Thanks for testing!

> For the record, I'm testing on a 2-CPU system, so I'm not sure whether
> your explanation applies; it talks about CPUs 2 and 3 whereas I only
> have CPUs 0 and 1, but perhaps your explanation applies equally to any
> pair of CPUs?
> 

Yes, it applies to any pair of CPUs, as long as the CPU first taken down
is not the policy->cpu. In your case, it applies like this:
IIUC, CPU0 is the boot cpu, and hence it wont be taken offline using hotplug.
So only CPU 1 is taken offline during suspend. And if it is not the policy->cpu,
then it hits the very same bug that I described with the analogy of CPUs 2
and 3.

> For the record, here's the information you requested in the other email:
> 
> # cat /sys/devices/system/cpu/cpu*/cpufreq/related_cpus
> 0 1
> 0 1
> 

Thanks! It would have been more useful to somehow know which was the
policy->cpu. But looking at the problem, certainly CPU0 was the policy->cpu
in your case. Anyway, nevermind, good to know that the problem got solved
by the 2 patches :-) And more importantly, we now fully understand the
problems that can lead to the NULL deref and the solutions, as outlined below:

Problem 1 : The last surviving policy->cpu during suspend might not
be the one which is onlined during resume. So policy->cpu updates can
get missed by the cpufreq-stats code. This is solved by patch 1.

Problem 2 : If a CPU other than the policy->cpu goes down first during
suspend, then we end up spuriously updating the policy->cpu field, making
update_policy_cpu() go crazy. This is solved by patch 2.

Ideally, I think we should fix the weird if/else condition, since *that*
is the real culprit; and retain patch 2 as a cleanup.

Something like this:


From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] cpufreq: Restructure if/else block to avoid unintended behavior

In __cpufreq_remove_dev_prepare(), the code which decides whether to remove
the sysfs link or nominate a new policy cpu, is governed by an if/else block
with a rather complex set of conditionals. Worse, they harbor a subtlety
which leads to certain unintended behavior.

The code looks like this:

        if (cpu != policy->cpu && !frozen) {
                sysfs_remove_link(&dev->kobj, "cpufreq");
        } else if (cpus > 1) {
		new_cpu = cpufreq_nominate_new_policy_cpu(...);
		...
		update_policy_cpu(..., new_cpu);
	}

The original intention was:
If the CPU going offline is not policy->cpu, just remove the link.
On the other hand, if the CPU going offline is the policy->cpu itself,
handover the policy->cpu job to some other surviving CPU in that policy.

But because the 'if' condition also includes the 'frozen' check, now there
are *two* possibilities by which we can enter the 'else' block:

1. cpu == policy->cpu (intended)
2. cpu != policy->cpu && frozen (unintended)

Due to the second (unintended) scenario, we end up spuriously nominating
a CPU as the policy->cpu, even when the existing policy->cpu is alive and
well. This can cause problems further down the line, especially when we end
up nominating the same policy->cpu as the new one (ie., old == new),
because it totally confuses update_policy_cpu().

To avoid this mess, restructure the if/else block to only do what was
originally intended, and thus prevent any unwelcome surprises.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 62bdb95..247842b 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1193,8 +1193,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		cpumask_clear_cpu(cpu, policy->cpus);
 	unlock_policy_rwsem_write(cpu);
 
-	if (cpu != policy->cpu && !frozen) {
-		sysfs_remove_link(&dev->kobj, "cpufreq");
+	if (cpu != policy->cpu) {
+		if (!frozen)
+			sysfs_remove_link(&dev->kobj, "cpufreq");
 	} else if (cpus > 1) {
 
 		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);




So can you see if patch 1 + this above fix solves your problem as well?
Then we can retain the original patch 2 as a cleanup, after these 2 patches.
This organization also makes the code look better and understandable.

Rafael, I'll post the 3 patches separately after knowing the results from
Stephen. You don't have to bother deciphering the patch ordering just yet ;-)

Regards,
Srivatsa S. Bhat

