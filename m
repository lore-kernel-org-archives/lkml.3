Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaI0TiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 15:38:10 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52608 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752154AbaI0TiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 15:38:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at drivers/cpufreq/cpufreq.c:370
Date: Sat, 27 Sep 2014 21:57:59 +0200
Message-ID: <2063016.pueklnzY3W@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411798486.5097.46.camel@marge.simpson.net>
References: <20140924081845.572814794@infradead.org> <2457441.tHFXzSCneW@vostro.rjw.lan> <1411798486.5097.46.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 27, 2014 08:14:46 AM Mike Galbraith wrote:
> On Sat, 2014-09-27 at 00:44 +0200, Rafael J. Wysocki wrote:
> 
> > Shouldn't that be pcc-cpufreq.c rather?
> 
> Yeah, silly mouse copy/pasted the wrong gitk bits.
> 
> > Also moving the spin_lock(&pcc_lock) after the cpufreq_freq_transition_begin()
> > should fix the problem too (like the below).  Have you tried that?
> 
> Have now.  Yup, works and is prettier.

OK, thanks!

Below it goes again with full changelog.

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: cpufreq: pcc-cpufreq: Fix wait_event() under spinlock

Fix the following bug introduced by commit 8fec051eea73 (cpufreq:
Convert existing drivers to use cpufreq_freq_transition_{begin|end})
that forgot to move the spin_lock() in pcc_cpufreq_target() past
cpufreq_freq_transition_begin() which calls wait_event():

BUG: sleeping function called from invalid context at drivers/cpufreq/cpufreq.c:370
in_atomic(): 1, irqs_disabled(): 0, pid: 2636, name: modprobe
Preemption disabled at:[<ffffffffa04d74d7>] pcc_cpufreq_target+0x27/0x200 [pcc_cpufreq]
[   51.025044]
CPU: 57 PID: 2636 Comm: modprobe Tainted: G            E  3.17.0-default #7
Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
 00000000ffffffff ffff88026c46b828 ffffffff81589dbd 0000000000000000
 ffff880037978090 ffff88026c46b848 ffffffff8108e1df ffff880037978090
 0000000000000000 ffff88026c46b878 ffffffff8108e298 ffff88026d73ec00
Call Trace:
 [<ffffffff81589dbd>] dump_stack+0x4d/0x90
 [<ffffffff8108e1df>] ___might_sleep+0x10f/0x180
 [<ffffffff8108e298>] __might_sleep+0x48/0xd0
 [<ffffffff8145b905>] cpufreq_freq_transition_begin+0x75/0x140 drivers/cpufreq/cpufreq.c:370 wait_event(policy->transition_wait, !policy->transition_ongoing);
 [<ffffffff8108fc99>] ? preempt_count_add+0xb9/0xc0
 [<ffffffffa04d7513>] pcc_cpufreq_target+0x63/0x200 [pcc_cpufreq] drivers/cpufreq/pcc-cpufreq.c:207 spin_lock(&pcc_lock);
 [<ffffffff810e0d0f>] ? update_ts_time_stats+0x7f/0xb0
 [<ffffffff8145be55>] __cpufreq_driver_target+0x85/0x170
 [<ffffffff8145e4c8>] od_check_cpu+0xa8/0xb0
 [<ffffffff8145ef10>] dbs_check_cpu+0x180/0x1d0
 [<ffffffff8145f310>] cpufreq_governor_dbs+0x3b0/0x720
 [<ffffffff8145ebe3>] od_cpufreq_governor_dbs+0x33/0xe0
 [<ffffffff814593d9>] __cpufreq_governor+0xa9/0x210
 [<ffffffff81459fb2>] cpufreq_set_policy+0x1e2/0x2e0
 [<ffffffff8145a6cc>] cpufreq_init_policy+0x8c/0x110
 [<ffffffff8145c9a0>] ? cpufreq_update_policy+0x1b0/0x1b0
 [<ffffffff8108fb99>] ? preempt_count_sub+0xb9/0x100
 [<ffffffff8145c6c6>] __cpufreq_add_dev+0x596/0x6b0
 [<ffffffffa016c608>] ? pcc_cpufreq_probe+0x4b4/0x4b4 [pcc_cpufreq]
 [<ffffffff8145c7ee>] cpufreq_add_dev+0xe/0x10
 [<ffffffff81408e81>] subsys_interface_register+0xc1/0xf0
 [<ffffffff8108fb99>] ? preempt_count_sub+0xb9/0x100
 [<ffffffff8145b3d7>] cpufreq_register_driver+0x117/0x2a0
 [<ffffffffa016c65d>] pcc_cpufreq_init+0x55/0x9f8 [pcc_cpufreq]
 [<ffffffffa016c608>] ? pcc_cpufreq_probe+0x4b4/0x4b4 [pcc_cpufreq]
 [<ffffffff81000298>] do_one_initcall+0xc8/0x1f0
 [<ffffffff811a731d>] ? __vunmap+0x9d/0x100
 [<ffffffff810eb9a0>] do_init_module+0x30/0x1b0
 [<ffffffff810edfa6>] load_module+0x686/0x710
 [<ffffffff810ebb20>] ? do_init_module+0x1b0/0x1b0
 [<ffffffff810ee1db>] SyS_init_module+0x9b/0xc0
 [<ffffffff8158f7a9>] system_call_fastpath+0x16/0x1b

Fixes: 8fec051eea73 (cpufreq: Convert existing drivers to use cpufreq_freq_transition_{begin|end})
Reported-and-tested-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: 3.15+ <stable@vger.kernel.org> # 3.15+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/cpufreq/pcc-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/cpufreq/pcc-cpufreq.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/pcc-cpufreq.c
+++ linux-pm/drivers/cpufreq/pcc-cpufreq.c
@@ -204,7 +204,6 @@ static int pcc_cpufreq_target(struct cpu
 	u32 input_buffer;
 	int cpu;
 
-	spin_lock(&pcc_lock);
 	cpu = policy->cpu;
 	pcc_cpu_data = per_cpu_ptr(pcc_cpu_info, cpu);
 
@@ -216,6 +215,7 @@ static int pcc_cpufreq_target(struct cpu
 	freqs.old = policy->cur;
 	freqs.new = target_freq;
 	cpufreq_freq_transition_begin(policy, &freqs);
+	spin_lock(&pcc_lock);
 
 	input_buffer = 0x1 | (((target_freq * 100)
 			       / (ioread32(&pcch_hdr->nominal) * 1000)) << 8);
