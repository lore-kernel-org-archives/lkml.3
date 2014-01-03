Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaACSEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:04:45 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:38052 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaACSEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:04:43 -0500
Date: Fri, 3 Jan 2014 20:04:36 +0200
From: Gleb Natapov <gleb@kernel.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kashyap Chamarthy <kchamart@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
Message-ID: <20140103180435.GK10961@minantech.com>
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com>
 <4794554.Hmd2RUNYDT@vostro.rjw.lan>
 <52C18A23.10703@redhat.com>
 <3710588.K8glfx1cYs@vostro.rjw.lan>
 <52C6F3B4.3050904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C6F3B4.3050904@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 09:30:28AM -0800, Dirk Brandewie wrote:
> Hi All,
> 
> Sorry for being late to the party but I just got back from vacation.
> 
> There is something deeply wrong here.  We should have never gotten to
> intel_pstate_init_cpu().  The VM had to have returned value from the read
> of the max pstate at driver init time and 0 when the CPU was being brought up.
> 
> intel_pstate_msrs_not_valid() was added to solve this issue early on
> if I remember correctly it was Josh that reported it then.  Is there
> a definative way to detect whether we are running in a VM?
> 
Checking for VM is a wrong thing to do here. KVM should behave like it
does not support p-state.

> Can some one tell me how the nested environment differs in regards to
> reading MSRs?
> 
It shouldn't differ, but there may be bug somewhere in nested emulation.
We shouldn't try and hind the bug by doing more checks in Linux but
rather fixing KVM bug that causes Linux to behave incorrectly.

> TIA
> --Dirk
> 
> On 12/30/2013 06:07 PM, Rafael J. Wysocki wrote:
> >>>---
> >>>  drivers/cpufreq/intel_pstate.c |    5 +++++
> >>>  1 file changed, 5 insertions(+)
> >>>
> >>>Index: linux-pm/drivers/cpufreq/intel_pstate.c
> >>>===================================================================
> >>>--- linux-pm.orig/drivers/cpufreq/intel_pstate.c
> >>>+++ linux-pm/drivers/cpufreq/intel_pstate.c
> >>>@@ -614,6 +614,11 @@ static int intel_pstate_init_cpu(unsigne
> >>>  	cpu = all_cpu_data[cpunum];
> >>>
> >>>  	intel_pstate_get_cpu_pstates(cpu);
> >>>+	if (!cpu->pstate.current_pstate) {
> >>>+		all_cpu_data[cpunum] = NULL;
> >>>+		kfree(cpu);
> >>>+		return -ENODATA;
> >>>+	}
> >>>
> >>>  	cpu->cpu = cpunum;
> >>>
> >>>
> >>
> >>
> >>Thanks Rafel, I can confirm this patch helps.
> >
> >Awesome, thanks!
> >
> >Below is an official version with a changelog.  I'll queue it up as a fix
> >for 3.13.
> >
> >Thanks,
> >Rafael
> >
> >
> >---
> >From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >Subject: intel_pstate: Fail initialization if P-state information is missing
> >
> >If pstate.current_pstate is 0 after the initial
> >intel_pstate_get_cpu_pstates(), this means that we were unable to
> >obtain any useful P-state information and there is no reason to
> >continue, so free memory and return an error in that case.
> >
> >This fixes the following divide error occuring in a nested KVM
> >guest:
> >
> >Intel P-state driver initializing.
> >Intel pstate controlling: cpu 0
> >cpufreq: __cpufreq_add_dev: ->get() failed
> >divide error: 0000 [#1] SMP
> >Modules linked in:
> >CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-0.rc4.git5.1.fc21.x86_64 #1
> >Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> >task: ffff88001ea20000 ti: ffff88001e9bc000 task.ti: ffff88001e9bc000
> >RIP: 0010:[<ffffffff815c551d>]  [<ffffffff815c551d>] intel_pstate_timer_func+0x11d/0x2b0
> >RSP: 0000:ffff88001ee03e18  EFLAGS: 00010246
> >RAX: 0000000000000000 RBX: ffff88001a454348 RCX: 0000000000006100
> >RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> >RBP: ffff88001ee03e38 R08: 0000000000000000 R09: 0000000000000000
> >R10: ffff88001ea20000 R11: 0000000000000000 R12: 00000c0a1ea20000
> >R13: 1ea200001ea20000 R14: ffffffff815c5400 R15: ffff88001a454348
> >FS:  0000000000000000(0000) GS:ffff88001ee00000(0000) knlGS:0000000000000000
> >CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >CR2: 0000000000000000 CR3: 0000000001c0c000 CR4: 00000000000006f0
> >Stack:
> >  fffffffb1a454390 ffffffff821a4500 ffff88001a454390 0000000000000100
> >  ffff88001ee03ea8 ffffffff81083e9a ffffffff81083e15 ffffffff82d5ed40
> >  ffffffff8258cc60 0000000000000000 ffffffff81ac39de 0000000000000000
> >Call Trace:
> >  <IRQ>
> >  [<ffffffff81083e9a>] call_timer_fn+0x8a/0x310
> >  [<ffffffff81083e15>] ? call_timer_fn+0x5/0x310
> >  [<ffffffff815c5400>] ? pid_param_set+0x130/0x130
> >  [<ffffffff81084354>] run_timer_softirq+0x234/0x380
> >  [<ffffffff8107aee4>] __do_softirq+0x104/0x430
> >  [<ffffffff8107b5fd>] irq_exit+0xcd/0xe0
> >  [<ffffffff81770645>] smp_apic_timer_interrupt+0x45/0x60
> >  [<ffffffff8176efb2>] apic_timer_interrupt+0x72/0x80
> >  <EOI>
> >  [<ffffffff810e15cd>] ? vprintk_emit+0x1dd/0x5e0
> >  [<ffffffff81757719>] printk+0x67/0x69
> >  [<ffffffff815c1493>] __cpufreq_add_dev.isra.13+0x883/0x8d0
> >  [<ffffffff815c14f0>] cpufreq_add_dev+0x10/0x20
> >  [<ffffffff814a14d1>] subsys_interface_register+0xb1/0xf0
> >  [<ffffffff815bf5cf>] cpufreq_register_driver+0x9f/0x210
> >  [<ffffffff81fb19af>] intel_pstate_init+0x27d/0x3be
> >  [<ffffffff81761e3e>] ? mutex_unlock+0xe/0x10
> >  [<ffffffff81fb1732>] ? cpufreq_gov_dbs_init+0x12/0x12
> >  [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
> >  [<ffffffff8109dbf5>] ? parse_args+0x225/0x3f0
> >  [<ffffffff81f64193>] kernel_init_freeable+0x1fc/0x287
> >  [<ffffffff81f638d0>] ? do_early_param+0x88/0x88
> >  [<ffffffff8174b530>] ? rest_init+0x150/0x150
> >  [<ffffffff8174b53e>] kernel_init+0xe/0x130
> >  [<ffffffff8176e27c>] ret_from_fork+0x7c/0xb0
> >  [<ffffffff8174b530>] ? rest_init+0x150/0x150
> >Code: c1 e0 05 48 63 bc 03 10 01 00 00 48 63 83 d0 00 00 00 48 63 d6 48 c1 e2 08 c1 e1 08 4c 63 c2 48 c1 e0 08 48 98 48 c1 e0 08 48 99 <49> f7 f8 48 98 48 0f af f8 48 c1 ff 08 29 f9 89 ca c1 fa 1f 89
> >RIP  [<ffffffff815c551d>] intel_pstate_timer_func+0x11d/0x2b0
> >  RSP <ffff88001ee03e18>
> >---[ end trace f166110ed22cc37a ]---
> >Kernel panic - not syncing: Fatal exception in interrupt
> >
> >Reported-and-tested-by: Kashyap Chamarthy <kchamart@redhat.com>
> >Cc: Josh Boyer <jwboyer@fedoraproject.org>
> >Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >---
> >  drivers/cpufreq/intel_pstate.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> >Index: linux-pm/drivers/cpufreq/intel_pstate.c
> >===================================================================
> >--- linux-pm.orig/drivers/cpufreq/intel_pstate.c
> >+++ linux-pm/drivers/cpufreq/intel_pstate.c
> >@@ -614,6 +614,11 @@ static int intel_pstate_init_cpu(unsigne
> >  	cpu = all_cpu_data[cpunum];
> >
> >  	intel_pstate_get_cpu_pstates(cpu);
> >+	if (!cpu->pstate.current_pstate) {
> >+		all_cpu_data[cpunum] = NULL;
> >+		kfree(cpu);
> >+		return -ENODATA;
> >+	}
> >
> >  	cpu->cpu = cpunum;
> >
> >
> 

--
			Gleb.
