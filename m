Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbaIIOyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:54:36 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61471 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757344AbaIIOy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:54:26 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Processor: Fix dead lock between cpu hotplug and handler of ACPI processor power notify event
Date: Tue, 09 Sep 2014 17:13:52 +0200
Message-ID: <2956933.E3doTrsqJD@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410273857-13598-1-git-send-email-tianyu.lan@intel.com>
References: <1410273857-13598-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 09, 2014 10:44:17 PM Lan Tianyu wrote:
> There is a dead lock between between cpu hotplug and handler of ACPI Processor
> Power notify event. Cpu hotplug lock is held and then hold cpuidle lock during cpu hotplug.
> During ACPI processor power notify event, acpi_processor_cst_has_chaged() does converse
> thing and cause dead lock. Just like the following log shows.

Isn't this patch equivalent to commit 6726655dfdd2 (ACPI / cpuidle: fix deadlock
between cpuidle_lock and cpu_hotplug.lock)?

> [   91.456670] ======================================================
> [   91.457160] [ INFO: possible circular locking dependency detected ]
> [   91.457658] 3.17.0-rc3+ #15 Not tainted
> [   91.457968] -------------------------------------------------------
> [   91.458463] kworker/0:1/75 is trying to acquire lock:
> [   91.458866]  (cpu_hotplug.lock){++++++}, at: [<ffffffff810c3334>] get_online_cpus+0x24/0x70
> [   91.459600]
> [   91.459600] but task is already holding lock:
> [   91.460062]  (cpuidle_lock){+.+.+.}, at: [<ffffffff81666147>] cpuidle_pause_and_lock+0x17/0x40
> [   91.460810]
> [   91.460810] which lock already depends on the new lock.
> [   91.460810]
> [   91.461451]
> [   91.461451] the existing dependency chain (in reverse order) is:
> [   91.462038]
> [   91.462038] -> #2 (cpuidle_lock){+.+.+.}:
> [   91.462442]        [<ffffffff8110cba4>] lock_acquire+0xa4/0x120
> [   91.462931]        [<ffffffff817eb4de>] mutex_lock_nested+0x4e/0x3b0
> [   91.463453]        [<ffffffff81666147>] cpuidle_pause_and_lock+0x17/0x40
> [   91.464000]        [<ffffffff8148ea5b>] acpi_processor_hotplug+0x49/0x8d
> [   91.464548]        [<ffffffff8148cc9f>] acpi_cpu_soft_notify+0xaf/0xe4
> [   91.465081]        [<ffffffff810e20ac>] notifier_call_chain+0x4c/0x70
> [   91.465609]        [<ffffffff810e217e>] __raw_notifier_call_chain+0xe/0x10
> [   91.466169]        [<ffffffff810c3443>] cpu_notify+0x23/0x50
> [   91.466637]        [<ffffffff810c36a0>] _cpu_up+0x150/0x160
> [   91.467098]        [<ffffffff817dba6f>] enable_nonboot_cpus+0xaf/0x170
> [   91.467632]        [<ffffffff81113085>] hibernation_snapshot+0x275/0x380
> [   91.468181]        [<ffffffff81113990>] hibernate+0x160/0x210
> [   91.468655]        [<ffffffff81111314>] state_store+0xe4/0xf0
> [   91.469129]        [<ffffffff813eb16f>] kobj_attr_store+0xf/0x20
> [   91.469624]        [<ffffffff812aba54>] sysfs_kf_write+0x44/0x60
> [   91.470118]        [<ffffffff812ab357>] kernfs_fop_write+0xe7/0x170
> [   91.470632]        [<ffffffff81230da7>] vfs_write+0xb7/0x1f0
> [   91.471100]        [<ffffffff81231959>] SyS_write+0x49/0xb0
> [   91.471561]        [<ffffffff817ee429>] system_call_fastpath+0x16/0x1b
> [   91.472096]
> [   91.472096] -> #1 (cpu_hotplug.lock#2){+.+.+.}:
> [   91.472556]        [<ffffffff8110cba4>] lock_acquire+0xa4/0x120
> [   91.473044]        [<ffffffff817eb4de>] mutex_lock_nested+0x4e/0x3b0
> [   91.473564]        [<ffffffff810c34df>] cpu_hotplug_begin+0x4f/0x80
> [   91.474078]        [<ffffffff810c3584>] _cpu_up+0x34/0x160
> [   91.474532]        [<ffffffff810c3709>] cpu_up+0x59/0x80
> [   91.474973]        [<ffffffff81d8170c>] smp_init+0x86/0x88
> [   91.475429]        [<ffffffff81d5e203>] kernel_init_freeable+0x16c/0x27b
> [   91.475976]        [<ffffffff817da77e>] kernel_init+0xe/0xf0
> [   91.476443]        [<ffffffff817ee37c>] ret_from_fork+0x7c/0xb0
> [   91.476930]
> [   91.476930] -> #0 (cpu_hotplug.lock){++++++}:
> [   91.477359]        [<ffffffff8110c0b0>] __lock_acquire+0x1760/0x1a70
> [   91.477880]        [<ffffffff8110cba4>] lock_acquire+0xa4/0x120
> [   91.478367]        [<ffffffff810c335a>] get_online_cpus+0x4a/0x70
> [   91.478868]        [<ffffffff8148eb12>] acpi_processor_cst_has_changed+0x73/0x17d
> [   91.479475]        [<ffffffff8148cd5e>] acpi_processor_notify+0x8a/0xe2
> [   91.480014]        [<ffffffff814743fb>] acpi_ev_notify_dispatch+0x44/0x5c
> [   91.480569]        [<ffffffff8146019a>] acpi_os_execute_deferred+0x14/0x20
> [   91.481130]        [<ffffffff810dba1f>] process_one_work+0x1df/0x4d0
> [   91.481652]        [<ffffffff810dbe2b>] worker_thread+0x11b/0x490
> [   91.482152]        [<ffffffff810e100d>] kthread+0xed/0x110
> [   91.482606]        [<ffffffff817ee37c>] ret_from_fork+0x7c/0xb0
> [   91.483094]
> [   91.483094] other info that might help us debug this:
> [   91.483094]
> [   91.483721] Chain exists of:
> [   91.483721]   cpu_hotplug.lock --> cpu_hotplug.lock#2 --> cpuidle_lock
> [   91.483721]
> [   91.484486]  Possible unsafe locking scenario:
> [   91.484486]
> [   91.491113]        CPU0                    CPU1
> [   91.494496]        ----                    ----
> [   91.497833]   lock(cpuidle_lock);
> [   91.501083]                                lock(cpu_hotplug.lock#2);
> [   91.504572]                                lock(cpuidle_lock);
> [   91.507944]   lock(cpu_hotplug.lock);
> [   91.511115]
> [   91.511115]  *** DEADLOCK ***
> [   91.511115]
> [   91.519889] 3 locks held by kworker/0:1/75:
> [   91.522918]  #0:  ("kacpi_notify"){++++..}, at: [<ffffffff810db9bd>] process_one_work+0x17d/0x4d0
> [   91.526445]  #1:  ((&dpc->work)){+.+...}, at: [<ffffffff810db9bd>] process_one_work+0x17d/0x4d0
> [   91.530031]  #2:  (cpuidle_lock){+.+.+.}, at: [<ffffffff81666147>] cpuidle_pause_and_lock+0x17/0x40
> [   91.533653]
> [   91.533653] stack backtrace:
> [   91.539712] CPU: 0 PID: 75 Comm: kworker/0:1 Not tainted 3.17.0-rc3+ #15
> [   91.543086] Hardware name: Intel Corporation CHERRYVIEW A3 PLATFORM/Braswell CRB, BIOS BRASWEL1.X64.0035.R00.1409041111 09/04/2014
> [   91.546930] Workqueue: kacpi_notify acpi_os_execute_deferred
> [   91.550405]  ffffffff82656d40 ffff880078883b68 ffffffff817e44fd ffffffff82656b90
> [   91.554096]  ffff880078883ba8 ffffffff817dff2a ffff880078883c00 ffff88007884e218
> [   91.557807]  0000000000000002 0000000000000003 ffff88007884e218 ffff88007884da50
> [   91.561524] Call Trace:
> [   91.564833]  [<ffffffff817e44fd>] dump_stack+0x45/0x56
> [   91.568350]  [<ffffffff817dff2a>] print_circular_bug+0x200/0x20f
> [   91.571946]  [<ffffffff8110c0b0>] __lock_acquire+0x1760/0x1a70
> [   91.575529]  [<ffffffff8110a42a>] ? mark_held_locks+0x6a/0x90
> [   91.579100]  [<ffffffff810856f9>] ? flat_send_IPI_allbutself+0xe9/0x140
> [   91.582747]  [<ffffffff8110cba4>] lock_acquire+0xa4/0x120
> [   91.586323]  [<ffffffff810c3334>] ? get_online_cpus+0x24/0x70
> [   91.589927]  [<ffffffff810c335a>] get_online_cpus+0x4a/0x70
> [   91.593520]  [<ffffffff810c3334>] ? get_online_cpus+0x24/0x70
> [   91.597125]  [<ffffffff8148eb12>] acpi_processor_cst_has_changed+0x73/0x17d
> [   91.600840]  [<ffffffff8148cd5e>] acpi_processor_notify+0x8a/0xe2
> [   91.604508]  [<ffffffff814743fb>] acpi_ev_notify_dispatch+0x44/0x5c
> [   91.608188]  [<ffffffff8146019a>] acpi_os_execute_deferred+0x14/0x20
> [   91.611856]  [<ffffffff810dba1f>] process_one_work+0x1df/0x4d0
> [   91.615495]  [<ffffffff810db9bd>] ? process_one_work+0x17d/0x4d0
> [   91.619121]  [<ffffffff810dbe2b>] worker_thread+0x11b/0x490
> [   91.622713]  [<ffffffff810dbd10>] ? process_one_work+0x4d0/0x4d0
> [   91.626347]  [<ffffffff810e100d>] kthread+0xed/0x110
> [   91.629907]  [<ffffffff810e0f20>] ? kthread_create_on_node+0x200/0x200
> [   91.633606]  [<ffffffff817ee37c>] ret_from_fork+0x7c/0xb0
> [   91.637238]  [<ffffffff810e0f20>] ? kthread_create_on_node+0x200/0x200
> 
> This patch is to change the sequence of holding cpu hotplug
> and cpu idle lock in the acpi_processor_cst_has_changed() to avoid the
> dead lock.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/acpi/processor_idle.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 3dca36d..385ec5f 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -1071,9 +1071,9 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
>  
>  	if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
>  
> -		cpuidle_pause_and_lock();
>  		/* Protect against cpu-hotplug */
>  		get_online_cpus();
> +		cpuidle_pause_and_lock();
>  
>  		/* Disable all cpuidle devices */
>  		for_each_online_cpu(cpu) {
> @@ -1100,8 +1100,9 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
>  				cpuidle_enable_device(dev);
>  			}
>  		}
> -		put_online_cpus();
> +
>  		cpuidle_resume_and_unlock();
> +		put_online_cpus();
>  	}
>  
>  	return 0;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
