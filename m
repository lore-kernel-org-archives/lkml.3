Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaIZHyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:54:08 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:37061 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaIZHyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:54:05 -0400
Message-ID: <1411718040.6005.18.camel@marge.simpson.net>
Subject: Re: BUG: sleeping function called from invalid context at
 drivers/cpufreq/cpufreq.c:370
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Viresh Kumar <viresh.kumar@linaro.org>
Date: Fri, 26 Sep 2014 09:54:00 +0200
In-Reply-To: <1411712697.6005.7.camel@marge.simpson.net>
References: <20140924081845.572814794@infradead.org>
	 <1411633803.15810.12.camel@marge.simpson.net>
	 <20140925090619.GA5430@worktop> <20140925091556.GB5430@worktop>
	 <1411639019.15810.31.camel@marge.simpson.net>
	 <1411653544.15810.47.camel@marge.simpson.net>
	 <1411712697.6005.7.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 08:24 +0200, Mike Galbraith wrote: 
> (the hazards of multitasking.. post escaped early, and went to mostly
> the wrong folks)
> 
> 
> While testing some scheduler patches, the below pcc-cpufreq
> might_sleep() gripe fell out.

Because the bits below from 8fec051e didn't make the lock go away first.
Reverting only pcc-cpufreq back to notifier.. works.

--------------------- drivers/cpufreq/integrator-cpufreq.c ---------------------
index 0e27844e8c2d..e5122f1bfe78 100644
@@ -122,7 +122,7 @@ static int integrator_set_target(struct cpufreq_policy *policy,
 		return 0;
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 
 	cm_osc = __raw_readl(cm_base + INTEGRATOR_HDR_OSC_OFFSET);
 
@@ -143,7 +143,7 @@ static int integrator_set_target(struct cpufreq_policy *policy,
 	 */
 	set_cpus_allowed(current, cpus_allowed);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_freq_transition_end(policy, &freqs, 0);
 
 	return 0;
 }

> On Thu, 2014-09-25 at 15:59 +0200, Mike Galbraith wrote:
> 
> > pcc-cpufreq: spin_lock() -> wait_event() -> gripe() gripe() gripe()...
> > 
> > [   50.756280] BUG: sleeping function called from invalid context at drivers/cpufreq/cpufreq.c:370
> > [   50.850582] in_atomic(): 1, irqs_disabled(): 0, pid: 2636, name: modprobe
> > [   50.926744] Preemption disabled at:[<ffffffffa04d74d7>] pcc_cpufreq_target+0x27/0x200 [pcc_cpufreq]
> > [   51.025044]
> > [   51.045454] CPU: 57 PID: 2636 Comm: modprobe Tainted: G            E  3.17.0-default #7
> > [   51.136727] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
> > [   51.218484]  00000000ffffffff ffff88026c46b828 ffffffff81589dbd 0000000000000000
> > [   51.300293]  ffff880037978090 ffff88026c46b848 ffffffff8108e1df ffff880037978090
> > [   51.382666]  0000000000000000 ffff88026c46b878 ffffffff8108e298 ffff88026d73ec00
> > [   51.464884] Call Trace:
> > [   51.495159]  [<ffffffff81589dbd>] dump_stack+0x4d/0x90
> > [   51.555439]  [<ffffffff8108e1df>] ___might_sleep+0x10f/0x180
> > [   51.620610]  [<ffffffff8108e298>] __might_sleep+0x48/0xd0
> > [   51.684774]  [<ffffffff8145b905>] cpufreq_freq_transition_begin+0x75/0x140 drivers/cpufreq/cpufreq.c:370 wait_event(policy->transition_wait, !policy->transition_ongoing);
> > [   51.767992]  [<ffffffff8108fc99>] ? preempt_count_add+0xb9/0xc0
> > [   51.833294]  [<ffffffffa04d7513>] pcc_cpufreq_target+0x63/0x200 [pcc_cpufreq] drivers/cpufreq/pcc-cpufreq.c:207 spin_lock(&pcc_lock);
> > [   51.930204]  [<ffffffff810e0d0f>] ? update_ts_time_stats+0x7f/0xb0
> > [   52.009288]  [<ffffffff8145be55>] __cpufreq_driver_target+0x85/0x170
> > [   52.082479]  [<ffffffff8145e4c8>] od_check_cpu+0xa8/0xb0
> > [   52.143874]  [<ffffffff8145ef10>] dbs_check_cpu+0x180/0x1d0
> > [   52.207329]  [<ffffffff8145f310>] cpufreq_governor_dbs+0x3b0/0x720
> > [   52.276916]  [<ffffffff8145ebe3>] od_cpufreq_governor_dbs+0x33/0xe0
> > [   52.349048]  [<ffffffff814593d9>] __cpufreq_governor+0xa9/0x210
> > [   52.415040]  [<ffffffff81459fb2>] cpufreq_set_policy+0x1e2/0x2e0
> > [   52.480473]  [<ffffffff8145a6cc>] cpufreq_init_policy+0x8c/0x110
> > [   52.545829]  [<ffffffff8145c9a0>] ? cpufreq_update_policy+0x1b0/0x1b0
> > [   52.615796]  [<ffffffff8108fb99>] ? preempt_count_sub+0xb9/0x100
> > [   52.681961]  [<ffffffff8145c6c6>] __cpufreq_add_dev+0x596/0x6b0
> > [   52.746288]  [<ffffffffa016c608>] ? pcc_cpufreq_probe+0x4b4/0x4b4 [pcc_cpufreq]
> > [   52.830472]  [<ffffffff8145c7ee>] cpufreq_add_dev+0xe/0x10
> > [   52.894106]  [<ffffffff81408e81>] subsys_interface_register+0xc1/0xf0
> > [   52.970763]  [<ffffffff8108fb99>] ? preempt_count_sub+0xb9/0x100
> > [   53.038953]  [<ffffffff8145b3d7>] cpufreq_register_driver+0x117/0x2a0
> > [   53.110751]  [<ffffffffa016c65d>] pcc_cpufreq_init+0x55/0x9f8 [pcc_cpufreq]
> > [   53.186920]  [<ffffffffa016c608>] ? pcc_cpufreq_probe+0x4b4/0x4b4 [pcc_cpufreq]
> > [   53.267583]  [<ffffffff81000298>] do_one_initcall+0xc8/0x1f0
> > [   53.330601]  [<ffffffff811a731d>] ? __vunmap+0x9d/0x100
> > [   53.388285]  [<ffffffff810eb9a0>] do_init_module+0x30/0x1b0
> > [   53.451958]  [<ffffffff810edfa6>] load_module+0x686/0x710
> > [   53.514007]  [<ffffffff810ebb20>] ? do_init_module+0x1b0/0x1b0
> > [   53.581246]  [<ffffffff810ee1db>] SyS_init_module+0x9b/0xc0
> > [   53.644024]  [<ffffffff8158f7a9>] system_call_fastpath+0x16/0x1b
> > 
> 
> 


