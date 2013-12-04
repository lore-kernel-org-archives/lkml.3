Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab3LDCtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:49:07 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50270 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3LDCtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:49:02 -0500
MIME-Version: 1.0
In-Reply-To: <1384878243-5086-1-git-send-email-prarit@redhat.com>
References: <1384878243-5086-1-git-send-email-prarit@redhat.com>
Date: Wed, 4 Dec 2013 10:48:59 +0800
Message-ID: <CANVTcTZo8pN8y7UiSFyGNLWNwRm8nwQyzCFdQJy50z95vV15oQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before CPU down
From: rui wang <ruiv.wang@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, gong.chen@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13, Prarit Bhargava <prarit@redhat.com> wrote:
> Second try at this ...
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64791
>
> When a cpu is downed on a system, the irqs on the cpu are assigned to other
> cpus.  It is possible, however, that when a cpu is downed there aren't
> enough free vectors on the remaining cpus to account for the vectors from
> the cpu that is being downed.
>
> This results in an interesting "overflow" condition where irqs are
> "assigned" to a CPU but are not handled.
>
> For example, when downing cpus on a 1-64 logical processor system:
>
> <snip>
> [  232.021745] smpboot: CPU 61 is now offline
> [  238.480275] smpboot: CPU 62 is now offline
> [  245.991080] ------------[ cut here ]------------
> [  245.996270] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:264
> dev_watchdog+0x246/0x250()
> [  246.005688] NETDEV WATCHDOG: p786p1 (ixgbe): transmit queue 0 timed out
> [  246.013070] Modules linked in: lockd sunrpc iTCO_wdt iTCO_vendor_support
> sb_edac ixgbe microcode e1000e pcspkr joydev edac_core lpc_ich ioatdma ptp
> mdio mfd_core i2c_i801 dca pps_core i2c_core wmi acpi_cpufreq isci libsas
> scsi_transport_sas
> [  246.037633] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0+ #14
> [  246.044451] Hardware name: Intel Corporation S4600LH
> ........../SVRBD-ROW_T, BIOS SE5C600.86B.01.08.0003.022620131521 02/26/2013
> [  246.057371]  0000000000000009 ffff88081fa03d40 ffffffff8164fbf6
> ffff88081fa0ee48
> [  246.065728]  ffff88081fa03d90 ffff88081fa03d80 ffffffff81054ecc
> ffff88081fa13040
> [  246.074073]  0000000000000000 ffff88200cce0000 0000000000000040
> 0000000000000000
> [  246.082430] Call Trace:
> [  246.085174]  <IRQ>  [<ffffffff8164fbf6>] dump_stack+0x46/0x58
> [  246.091633]  [<ffffffff81054ecc>] warn_slowpath_common+0x8c/0xc0
> [  246.098352]  [<ffffffff81054fb6>] warn_slowpath_fmt+0x46/0x50
> [  246.104786]  [<ffffffff815710d6>] dev_watchdog+0x246/0x250
> [  246.110923]  [<ffffffff81570e90>] ?
> dev_deactivate_queue.constprop.31+0x80/0x80
> [  246.119097]  [<ffffffff8106092a>] call_timer_fn+0x3a/0x110
> [  246.125224]  [<ffffffff8106280f>] ? update_process_times+0x6f/0x80
> [  246.132137]  [<ffffffff81570e90>] ?
> dev_deactivate_queue.constprop.31+0x80/0x80
> [  246.140308]  [<ffffffff81061db0>] run_timer_softirq+0x1f0/0x2a0
> [  246.146933]  [<ffffffff81059a80>] __do_softirq+0xe0/0x220
> [  246.152976]  [<ffffffff8165fedc>] call_softirq+0x1c/0x30
> [  246.158920]  [<ffffffff810045f5>] do_softirq+0x55/0x90
> [  246.164670]  [<ffffffff81059d35>] irq_exit+0xa5/0xb0
> [  246.170227]  [<ffffffff8166062a>] smp_apic_timer_interrupt+0x4a/0x60
> [  246.177324]  [<ffffffff8165f40a>] apic_timer_interrupt+0x6a/0x70
> [  246.184041]  <EOI>  [<ffffffff81505a1b>] ? cpuidle_enter_state+0x5b/0xe0
> [  246.191559]  [<ffffffff81505a17>] ? cpuidle_enter_state+0x57/0xe0
> [  246.198374]  [<ffffffff81505b5d>] cpuidle_idle_call+0xbd/0x200
> [  246.204900]  [<ffffffff8100b7ae>] arch_cpu_idle+0xe/0x30
> [  246.210846]  [<ffffffff810a47b0>] cpu_startup_entry+0xd0/0x250
> [  246.217371]  [<ffffffff81646b47>] rest_init+0x77/0x80
> [  246.223028]  [<ffffffff81d09e8e>] start_kernel+0x3ee/0x3fb
> [  246.229165]  [<ffffffff81d0989f>] ? repair_env_string+0x5e/0x5e
> [  246.235787]  [<ffffffff81d095a5>] x86_64_start_reservations+0x2a/0x2c
> [  246.242990]  [<ffffffff81d0969f>] x86_64_start_kernel+0xf8/0xfc
> [  246.249610] ---[ end trace fb74fdef54d79039 ]---
> [  246.254807] ixgbe 0000:c2:00.0 p786p1: initiating reset due to tx
> timeout
> [  246.262489] ixgbe 0000:c2:00.0 p786p1: Reset adapter
> Last login: Mon Nov 11 08:35:14 from 10.18.17.119
> [root@(none) ~]# [  246.792676] ixgbe 0000:c2:00.0 p786p1: detected SFP+: 5
> [  249.231598] ixgbe 0000:c2:00.0 p786p1: NIC Link is Up 10 Gbps, Flow
> Control: RX/TX
> [  246.792676] ixgbe 0000:c2:00.0 p786p1: detected SFP+: 5
> [  249.231598] ixgbe 0000:c2:00.0 p786p1: NIC Link is Up 10 Gbps, Flow
> Control: RX/TX
>
> (last lines keep repeating.  ixgbe driver is dead until module reload.)
>
> If the downed cpu has more vectors than are free on the remaining cpus on
> the
> system, it is possible that some vectors are "orphaned" even though they
> are
> assigned to a cpu.  In this case, since the ixgbe driver had a watchdog,
> the
> watchdog fired and notified that something was wrong.
>
> This patch adds a function, check_vectors(), to compare the number of
> vectors
> on the CPU going down and compares it to the number of vectors available on
> the system.  If there aren't enough vectors for the CPU to go down, an
> error is returned and propogated back to userspace.
>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: x86@kernel.org
> ---
>  arch/x86/include/asm/irq.h |    1 +
>  arch/x86/kernel/irq.c      |   33 +++++++++++++++++++++++++++++++++
>  arch/x86/kernel/smpboot.c  |    6 ++++++
>  3 files changed, 40 insertions(+)
>
> diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
> index 0ea10f27..dfd7372 100644
> --- a/arch/x86/include/asm/irq.h
> +++ b/arch/x86/include/asm/irq.h
> @@ -25,6 +25,7 @@ extern void irq_ctx_init(int cpu);
>
>  #ifdef CONFIG_HOTPLUG_CPU
>  #include <linux/cpumask.h>
> +extern int check_vectors(void);
>  extern void fixup_irqs(void);
>  extern void irq_force_complete_move(int);
>  #endif
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 22d0687..ea5fa19 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -262,6 +262,39 @@ __visible void smp_trace_x86_platform_ipi(struct
> pt_regs *regs)
>  EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
>
>  #ifdef CONFIG_HOTPLUG_CPU
> +/*
> + * This cpu is going to be removed and its vectors migrated to the
> remaining
> + * online cpus.  Check to see if there are enough vectors in the remaining
> cpus.
> + */
> +int check_vectors(void)
> +{
> +	int cpu;
> +	unsigned int vector, this_count, count;
> +
> +	this_count = 0;
> +	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++)
> +		if (__this_cpu_read(vector_irq[vector]) >= 0)
> +			this_count++;
> +
> +	count = 0;
> +	for_each_online_cpu(cpu) {
> +		if (cpu == smp_processor_id())
> +			continue;
> +		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
> +		     vector++) {
> +			if (per_cpu(vector_irq, cpu)[vector] < 0)
> +				count++;
> +		}
> +	}
> +
> +	if (count < this_count) {
> +		pr_warn("CPU %d disable failed: CPU has %u vectors assigned and there are
> only %u available.\n",
> +			smp_processor_id(), this_count, count);
> +		return -ERANGE;
> +	}
> +	return 0;
> +}
> +

Have you considered the case when an IRQ is destined to more than one CPU? e.g.:

bash# cat /proc/irq/89/smp_affinity_list
30,62
bash#

In this case offlining CPU30 does not seem to require an empty vector
slot. It seems that we only need to change the affinity mask of irq89.
Your check_vectors() assumed that each irq on the offlining cpu
requires a new vector slot.

Rui Wang

>  /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
>  void fixup_irqs(void)
>  {
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 6cacab6..6d991d1 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1310,6 +1310,12 @@ void cpu_disable_common(void)
>
>  int native_cpu_disable(void)
>  {
> +	int ret;
> +
> +	ret = check_vectors();
> +	if (ret)
> +		return ret;
> +
>  	clear_local_APIC();
>
>  	cpu_disable_common();
> --
> 1.7.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
