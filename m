Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab3HaAgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:36:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49300 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3HaAgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:36:43 -0400
Date: Fri, 30 Aug 2013 17:36:41 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: mutex warning in cpufreq + RFC patch
Message-ID: <20130831003641.GE19754@codeaurora.org>
References: <20130828025721.GA19754@codeaurora.org>
 <CAKohpomLL0rCYngM81iaTV37TTsrYE+f3ouGuT2D6TRE5E4W5A@mail.gmail.com>
 <521E2ADE.4070401@codeaurora.org>
 <CAKohpoke5BHypqKcLjPK5eHHvvfRTjCz36FMQNT1OGTVnueRkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpoke5BHypqKcLjPK5eHHvvfRTjCz36FMQNT1OGTVnueRkw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29, Viresh Kumar wrote:
> On 28 August 2013 22:22, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >
> > I've applied these patches on top of v3.10
> >
> > f51e1eb63d9c28cec188337ee656a13be6980cfd (cpufreq: Fix cpufreq regression after suspend/resume
> > aae760ed21cd690fe8a6db9f3a177ad55d7e12ab (cpufreq: Revert commit a66b2e to fix suspend/resume regression)
> > e8d05276f236ee6435e78411f62be9714e0b9377 (cpufreq: Revert commit 2f7021a8 to fix CPU hotplug regression)
> > 2a99859932281ed6c2ecdd988855f8f6838f6743 (cpufreq: Fix cpufreq driver module refcount balance after suspend/resume)
> > 419e172145cf6c51d436a8bf4afcd17511f0ff79 (cpufreq: don't leave stale policy pointer in cdbs->cur_policy)
> > 95731ebb114c5f0c028459388560fc2a72fe5049 (cpufreq: Fix governor start/stop race condition)
> >
> > That second to last one causes a NULL pointer exception after the mutex
> > warning above because the limits case does
> >
> >     if (policy->max < cpu_cdbs->cur_policy->cur)
> >
> > and that dereferences a NULL cur_policy pointer.
> 
> I have seen something similar and the error checking patch that
> I mentioned earlier came as solution to that only..

Yes that patch may reduce the chance of the race condition but I
don't believe it removes it entirely. I believe this bug still
exists in linux-next. Consider the scenario where CPU1 is going
down.

__cpufreq_remove_dev()
 ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
  __cpufreq_governor()
   policy->governor->governor(policy, CPUFREQ_GOV_STOP);
    cpufreq_governor_dbs()
     case CPUFREQ_GOV_STOP:
      mutex_destroy(&cpu_cdbs->timer_mutex)
      cpu_cdbs->cur_policy = NULL;
  <PREEMPT>
store()
 __cpufreq_set_policy()
  ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
   __cpufreq_governor()
    policy->governor->governor(policy, CPUFREQ_GOV_LIMITS);
     case CPUFREQ_GOV_LIMITS:
      mutex_lock(&cpu_cdbs->timer_mutex); <-- Warning (destroyed mutex)
       if (policy->max < cpu_cdbs->cur_policy->cur) <- cur_policy == NULL

Once we stop the governor I don't see how another thread can't
race in and get all the way down into the GOV_LIMITS case. Even
if we wanted to lock out that thread with some mutex or semaphore
it will have to continue running eventually and so we really need
to wait until all the sysfs files are gone before we stop the
governor (in the case of the last cpu for the policy) or we need
to stop and start the governor while holding the policy semaphore
to prevent a race.

> 
> > Are there any fixes that I'm missing? I see that some things are
> > changing in linux-next but they don't look like fixes, more like
> > optimizations.
> 
> Getting patches over 3.10 would be tricky.. You are two kernel
> version back and that's not going to help much.. There are too many
> patches in between linux-next and 3.10..
>
> 
> I really can't tell you which specific ones to include, as I am lost in them :)

That's a problem. 3.10 is the next long term stable kernel and so we need to
backport any fixes to 3.10 for the next two years. Hopefully these bugs I'm
finding in the 3.10 stable kernel's cpufreq code aren't known issues on
3.11/next.

> 
> probably try to get all of them in ? i.e. All patches touching drivers/cpufreq
> and include/linux/cpufreq.h..

I may have to try that. I got another crash below. This time
governor was assigned to NULL in cpufreq_add_dev_interface() and
then userspace came in and wrote to sampling_min_rate which tries
to use the governor pointer in __cpufreq_governor() but it's
NULL. It looks like a change silently fixed this problem by
wrapping all this code in a rwsem (6eed940 cpufreq: Use rwsem for
protecting critical sections). Should we backport that change to
3.10.x trees? Alternatively, we can reorder the creation of the
sysfs files with the policy setup during CPU up (patch below) so
that userspace can't possibly be in the kernel at this time.

I think there is also another race between the cpufreq stats and
hotplug. I'm getting a sysfs warning about creating duplicate
cpufreq/stats files and I think that's because the thread that
craeted the sysfs file is preempted before it can assign the
cpufreq_stats_table and then cpufreq_add_dev_interface() comes in
and tries to create the table a second time. I need to keep
looking at that race to better understand it.

> 
> I have got Arndale (Samsung-exnos) board where offlining CPUs is broken
> @Kukjin: Can you please try to get it fixed?? It leads to crashes..

Maybe you can reproduce this on an x86 machine? This is all
generic code.

Unable to handle kernel NULL pointer dereference at virtual address 00000020
pgd = ea46c000
[00000020] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT SMP ARM
Modules linked in: 
CPU: 1 PID: 3665 Comm: sh Tainted: G        W    3.10.0 #37
task: ea5b2300 ti: eaa6e000 task.ti: eaa6e000
PC is at __cpufreq_governor+0x10/0x1a4
LR is at __cpufreq_set_policy+0x278/0x2c0
pc : [<c0677218>]    lr : [<c067765c>]    psr: 60000013
sp : eaa6fe40  ip : 00000000  fp : 00000000
r10: ea437ddc  r9 : c0a6d86c  r8 : eaa6ff80
r7 : 00000000  r6 : 00000000  r5 : 00000003  r4 : ea437d80
r3 : 00000000  r2 : 000493e0  r1 : 00000000  r0 : ea437d80
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5787d  Table: 2a46c06a  DAC: 00000015
Process sh (pid: 3665, stack limit = 0xeaa6e238)
Stack: (0xeaa6fe40 to 0xeaa70000)
fe40: eaa6fe74 ea437d80 00000000 c067765c ea437d80 eaa6fe74 000493e0 ea437d80
fe60: 00000007 ea8d5000 c0ffb028 c0677c38 01437300 00000002 00000002 00000000
fe80: 00000001 00000000 00229200 000493e0 00000000 000493e0 00229200 000493e0
fea0: 00000000 00000000 00000000 00000000 ffffffe0 ea437dc0 ea437dc0 c0678ef4
fec0: 000493e0 00229200 00000000 00000000 ebe297c0 ea437de0 ea437de0 c32d3050
fee0: 00000000 c0ffaf84 ebd6ce40 00000002 00000003 00000000 00000000 dead4ead
ff00: ffffffff ffffffff ea437e14 ea437e14 00000007 ea437d80 ea8d5000 c06788fc
ff20: 00000007 eab7ecc0 ebe26e00 00000007 ebe26e18 c02ae634 ea437300 00000007
ff40: b85ae36c eaa6ff80 b85ae36c eaa6e000 00000007 c025d438 ea437300 b85ae36c
ff60: 00000007 00000000 00000000 ea437300 00000000 b85ae36c 00000007 c025d790
ff80: 00000000 00000000 00000007 00000003 00000007 00000001 00000004 c0106304
ffa0: 00000000 c0106180 00000003 00000007 00000001 b85ae36c 00000007 ffffffff
ffc0: 00000003 00000007 00000001 00000004 b85ae36c 00000000 00000000 00000000
ffe0: 00000000 bed834c8 b6f67d75 b6f02208 20000010 00000001 00000000 00000000
[<c0677218>] (__cpufreq_governor+0x10/0x1a4) from [<c067765c>] (__cpufreq_set_policy+0x278/0x2c0)
[<c067765c>] (__cpufreq_set_policy+0x278/0x2c0) from [<c0677c38>] (store_scaling_min_freq+0x80/0x9c)
[<c0677c38>] (store_scaling_min_freq+0x80/0x9c) from [<c06788fc>] (store+0x58/0x90)
[<c06788fc>] (store+0x58/0x90) from [<c02ae634>] (sysfs_write_file+0x100/0x148)
[<c02ae634>] (sysfs_write_file+0x100/0x148) from [<c025d438>] (vfs_write+0xcc/0x174)
[<c025d438>] (vfs_write+0xcc/0x174) from [<c025d790>] (SyS_write+0x38/0x64)
[<c025d790>] (SyS_write+0x38/0x64) from [<c0106180>] (ret_fast_syscall+0x0/0x30)
Code: e92d4070 e1a05001 e5901030 e1a04000 (e5913020)

Patch is based on 3.10 plus all the patches I mentioned above.

---8<----

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index cbfe3c1..ae4b59c 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -755,6 +755,29 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 	if (ret)
 		return ret;
 
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	for_each_cpu(j, policy->cpus) {
+		per_cpu(cpufreq_cpu_data, j) = policy;
+		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
+	}
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+	memcpy(&new_policy, policy, sizeof(struct cpufreq_policy));
+	/* assure that the starting sequence is run in __cpufreq_set_policy */
+	policy->governor = NULL;
+
+	/* set default policy */
+	ret = __cpufreq_set_policy(policy, &new_policy);
+	policy->user_policy.policy = policy->policy;
+	policy->user_policy.governor = policy->governor;
+
+	if (ret) {
+		pr_debug("setting policy failed\n");
+		if (cpufreq_driver->exit)
+			cpufreq_driver->exit(policy);
+		return ret;
+	}
+
 	/* set up files for this cpu device */
 	drv_attr = cpufreq_driver->attr;
 	while ((drv_attr) && (*drv_attr)) {
@@ -779,31 +802,10 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 			goto err_out_kobj_put;
 	}
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus) {
-		per_cpu(cpufreq_cpu_data, j) = policy;
-		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
-	}
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
 	ret = cpufreq_add_dev_symlink(cpu, policy);
 	if (ret)
 		goto err_out_kobj_put;
 
-	memcpy(&new_policy, policy, sizeof(struct cpufreq_policy));
-	/* assure that the starting sequence is run in __cpufreq_set_policy */
-	policy->governor = NULL;
-
-	/* set default policy */
-	ret = __cpufreq_set_policy(policy, &new_policy);
-	policy->user_policy.policy = policy->policy;
-	policy->user_policy.governor = policy->governor;
-
-	if (ret) {
-		pr_debug("setting policy failed\n");
-		if (cpufreq_driver->exit)
-			cpufreq_driver->exit(policy);
-	}
 	return ret;
 
 err_out_kobj_put:

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
