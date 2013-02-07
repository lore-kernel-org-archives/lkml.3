Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422667Ab3BGTjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:39:52 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:62964 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422629Ab3BGTjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:39:49 -0500
Date: Thu, 7 Feb 2013 23:39:44 +0400
From: Artem Savkov <artem.savkov@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, valdis.kletnieks@vt.edu, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
Message-ID: <20130207193944.GA4016@thinkpad.lan>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1360232293.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 03:57:42PM +0530, Viresh Kumar wrote:
> Hi Rafael,
> 
> This is another unplanned patchset for all the platforms that i broke. :)
> 
> Okay, there are two important fixes (1 & 4) and two general cleanups (2 & 3). I
> hope most of the issues would be resolved by these and we would be able to push
> clean cpufreq core into 3.9.
> 
> I have pushed them in my for-rafael branch at:
> 
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-rafael
> 
> @Artem & Valdis: Please test them and reply with your Tested-by's (in case they
> work :) ).
> 
> Viresh Kumar (4):
>   cpufreq: governors: Fix WARN_ON() for multi-policy platforms
>   cpufreq: Remove unused HOTPLUG_CPU code
>   cpufreq: Create a macro for unlock_policy_rwsem{read,write}
>   cpufreq: Fix locking issues
> 
>  drivers/cpufreq/cpufreq.c          | 126 ++++++++++++++++++-------------------
>  drivers/cpufreq/cpufreq_governor.c |  32 ++++++----
>  2 files changed, 79 insertions(+), 79 deletions(-)

Tested out linux-pm.git/linux-next with this patches pulled. It seems
that my systemd-sleep issue is fixed, however there is a new 'sleeping
in invalid context' bug during boot:

[   12.736484] BUG: sleeping function called from invalid context at mm/slub.c:925
[   12.739727] in_atomic(): 1, irqs_disabled(): 1, pid: 1799, name: systemd-modules
[   12.742961] 2 locks held by systemd-modules/1799:
[   12.746153]  #0:  (subsys mutex#3){......}, at: [<c13f4056>] subsys_interface_register+0x36/0xb0
[   12.749499]  #1:  (cpufreq_driver_lock){......}, at: [<c14ba53b>] cpufreq_add_dev+0x22b/0x3d0
[   12.752865] Pid: 1799, comm: systemd-modules Not tainted 3.8.0-rc6+ #1
[   12.756175] Call Trace:
[   12.759538]  [<c1068150>] __might_sleep+0xe0/0x100
[   12.762156]  [<c112a481>] kmem_cache_alloc_trace+0xb1/0x150
[   12.765432]  [<f804e653>] ? acpi_cpufreq_cpu_init+0x73/0x5c0 [acpi_cpufreq]
[   12.768780]  [<f804e653>] acpi_cpufreq_cpu_init+0x73/0x5c0 [acpi_cpufreq]
[   12.772161]  [<c14ba53b>] ? cpufreq_add_dev+0x22b/0x3d0
[   12.775549]  [<c1695af7>] ? _raw_spin_lock_irqsave+0x77/0x90
[   12.778932]  [<c14ba53b>] ? cpufreq_add_dev+0x22b/0x3d0
[   12.782307]  [<c14ba548>] cpufreq_add_dev+0x238/0x3d0
[   12.785652]  [<c13f4095>] subsys_interface_register+0x75/0xb0
[   12.788989]  [<f804ec20>] ? do_drv_write+0x80/0x80 [acpi_cpufreq]
[   12.792325]  [<c14b986b>] cpufreq_register_driver+0x7b/0x150
[   12.795657]  [<f8075000>] ? 0xf8074fff
[   12.798971]  [<f80750ae>] acpi_cpufreq_init+0xae/0x1b3 [acpi_cpufreq]
[   12.802346]  [<c1001222>] do_one_initcall+0x112/0x160
[   12.805723]  [<c106145a>] ? __blocking_notifier_call_chain+0x4a/0x80
[   12.809123]  [<c10a048e>] load_module+0xd7e/0x1460
[   12.812515]  [<c1696d82>] ? error_code+0x5a/0x60
[   12.815891]  [<c10a0be8>] sys_init_module+0x78/0xb0
[   12.819249]  [<c169d67a>] sysenter_do_call+0x12/0x2d
[   12.822924] ------------[ cut here ]------------
[   12.826275] WARNING: at kernel/smp.c:327 smp_call_function_single+0x104/0x130()
[   12.829668] Hardware name: 0578A21
[   12.833020] Modules linked in: acpi_cpufreq(+) mperf thinkpad_acpi
[   12.836456] Pid: 1799, comm: systemd-modules Not tainted 3.8.0-rc6+ #1
[   12.839891] Call Trace:
[   12.843268]  [<c1036a82>] warn_slowpath_common+0x72/0xa0
[   12.846617]  [<c109b154>] ? smp_call_function_single+0x104/0x130
[   12.849921]  [<c109b154>] ? smp_call_function_single+0x104/0x130
[   12.853149]  [<f804eea0>] ? acpi_cpufreq_target+0x280/0x280 [acpi_cpufreq]
[   12.856361]  [<c1036ad2>] warn_slowpath_null+0x22/0x30
[   12.859518]  [<c109b154>] smp_call_function_single+0x104/0x130
[   12.862691]  [<c109b5b4>] smp_call_function_any+0x44/0xb0
[   12.865788]  [<f804eea0>] ? acpi_cpufreq_target+0x280/0x280 [acpi_cpufreq]
[   12.868893]  [<f804e13e>] get_cur_val+0x7e/0x100 [acpi_cpufreq]
[   12.871957]  [<f804e5bb>] get_cur_freq_on_cpu+0x4b/0x70 [acpi_cpufreq]
[   12.874987]  [<f804e9b8>] acpi_cpufreq_cpu_init+0x3d8/0x5c0 [acpi_cpufreq]
[   12.877998]  [<c14ba53b>] ? cpufreq_add_dev+0x22b/0x3d0
[   12.880982]  [<c14ba548>] cpufreq_add_dev+0x238/0x3d0
[   12.883931]  [<c13f4095>] subsys_interface_register+0x75/0xb0
[   12.886840]  [<f804ec20>] ? do_drv_write+0x80/0x80 [acpi_cpufreq]
[   12.889717]  [<c14b986b>] cpufreq_register_driver+0x7b/0x150
[   12.892550]  [<f8075000>] ? 0xf8074fff
[   12.895339]  [<f80750ae>] acpi_cpufreq_init+0xae/0x1b3 [acpi_cpufreq]
[   12.898169]  [<c1001222>] do_one_initcall+0x112/0x160
[   12.900988]  [<c106145a>] ? __blocking_notifier_call_chain+0x4a/0x80
[   12.903820]  [<c10a048e>] load_module+0xd7e/0x1460
[   12.906631]  [<c1696d82>] ? error_code+0x5a/0x60
[   12.909418]  [<c10a0be8>] sys_init_module+0x78/0xb0
[   12.912193]  [<c169d67a>] sysenter_do_call+0x12/0x2d
[   12.914956] ---[ end trace e15032846f0195a0 ]---


-- 
Kind regards,
Artem
