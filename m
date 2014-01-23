Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaAWBxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 20:53:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaAWBxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 20:53:13 -0500
Date: Thu, 23 Jan 2014 09:53:00 +0800
From: Dave Young <dyoung@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140123015300.GA3768@dhcp-16-126.nay.redhat.com>
References: <20131212140835.729222186@infradead.org>
 <20131212141655.362219382@infradead.org>
 <52DEF495.2020304@oracle.com>
 <20140122104532.GJ31570@twins.programming.kicks-ass.net>
 <20140122115918.GG3694@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122115918.GG3694@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/14 at 12:59pm, Peter Zijlstra wrote:
> On Wed, Jan 22, 2014 at 11:45:32AM +0100, Peter Zijlstra wrote:
> > Ho humm.
> 
> OK, so I had me a ponder; does the below fix things for you and David?
> I've only done a boot test on real proper hardware :-)
> 
> ---
>  kernel/sched/clock.c | 42 +++++++++++++++++++++++++++++++++---------
>  1 file changed, 33 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
> index 6bd6a6731b21..6bbcd97f4532 100644
> --- a/kernel/sched/clock.c
> +++ b/kernel/sched/clock.c
> @@ -77,35 +77,45 @@ __read_mostly int sched_clock_running;
>  
>  #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
>  static struct static_key __sched_clock_stable = STATIC_KEY_INIT;
> +static int __sched_clock_stable_early;
>  
>  int sched_clock_stable(void)
>  {
> -	if (static_key_false(&__sched_clock_stable))
> -		return false;
> -	return true;
> +	return static_key_false(&__sched_clock_stable);
>  }
>  
>  void set_sched_clock_stable(void)
>  {
> +	__sched_clock_stable_early = 1;
> +
> +	smp_mb(); /* matches sched_clock_init() */
> +
> +	if (!sched_clock_running)
> +		return;
> +
>  	if (!sched_clock_stable())
> -		static_key_slow_dec(&__sched_clock_stable);
> +		static_key_slow_inc(&__sched_clock_stable);
>  }
>  
>  static void __clear_sched_clock_stable(struct work_struct *work)
>  {
>  	/* XXX worry about clock continuity */
>  	if (sched_clock_stable())
> -		static_key_slow_inc(&__sched_clock_stable);
> +		static_key_slow_dec(&__sched_clock_stable);
>  }
>  
>  static DECLARE_WORK(sched_clock_work, __clear_sched_clock_stable);
>  
>  void clear_sched_clock_stable(void)
>  {
> -	if (keventd_up())
> -		schedule_work(&sched_clock_work);
> -	else
> -		__clear_sched_clock_stable(&sched_clock_work);
> +	__sched_clock_stable_early = 0;
> +
> +	smp_mb(); /* matches sched_clock_init() */
> +
> +	if (!sched_clock_running)
> +		return;
> +
> +	schedule_work(&sched_clock_work);
>  }
>  
>  struct sched_clock_data {
> @@ -140,6 +150,20 @@ void sched_clock_init(void)
>  	}
>  
>  	sched_clock_running = 1;
> +
> +	/*
> +	 * Ensure that it is impossible to not do a static_key update.
> +	 *
> +	 * Either {set,clear}_sched_clock_stable() must see sched_clock_running
> +	 * and do the update, or we must see their __sched_clock_stable_early
> +	 * and do the update, or both.
> +	 */
> +	smp_mb(); /* matches {set,clear}_sched_clock_stable() */
> +
> +	if (__sched_clock_stable_early)
> +		set_sched_clock_stable();
> +	else
> +		clear_sched_clock_stable();
>  }
>  
>  /*

It does not fix the prink time issue, here is the log:
[    0.000000] efi: mem26: type=6, attr=0x800000000000000f, range=[0x000000000dbe0000-0x000000000dc00000) (0MB)
[    0.000000] DMI not present or invalid.
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: last_pfn = 0xdbe0 max_arch_pfn = 0x400000000
[    0.000000] PAT not supported by CPU.
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x0aa00000-0x0abfffff]
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0a9fffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000] init_memory_mapping: [mem 0x0ac00000-0x0bd93fff]
[    0.000000] init_memory_mapping: [mem 0x0bdc1000-0x0d580fff]
[    0.000000] init_memory_mapping: [mem 0x0d5e5000-0x0dbdffff]
[    0.000000] RAMDISK: [mem 0x0ac0e000-0x0b583fff]
[    0.000000] ACPI: RSDP 000000000d5e0014 000024 (v02 OVMF  )
[    0.000000] ACPI: XSDT 000000000d5df0e8 00003C (v01 OVMF   OVMFEDK2 20130221      01000013)
[    0.000000] ACPI: FACP 000000000d5de000 0000F4 (v03 OVMF   OVMFEDK2 20130221 OVMF 00000099)
[    0.000000] ACPI: DSDT 000000000d5dc000 000D57 (v01 INTEL  OVMF     00000004 INTL 20120913)
[    0.000000] ACPI: FACS 000000000d5e4000 000040
[    0.000000] ACPI: APIC 000000000d5dd000 000078 (v01 OVMF   OVMFEDK2 20130221 OVMF 00000099)
[    0.000000] ACPI: SSDT 000000000d5db000 000057 (v01 REDHAT OVMF     00000001 INTL 20120913)
[    0.000000] crashkernel reservation failed - No suitable area found.
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:d401001, boot clock
[65465.267798] Zone ranges:
[65465.268914]   DMA      [mem 0x00001000-0x00ffffff]
[65465.271107]   DMA32    [mem 0x01000000-0xffffffff]
[65465.273348]   Normal   empty
[65465.274683] Movable zone start for each node
[65465.276646] Early memory node ranges
[65465.278321]   node   0: [mem 0x00001000-0x0009ffff]
[65465.280572]   node   0: [mem 0x00100000-0x0bd93fff]
[65465.282825]   node   0: [mem 0x0bdc1000-0x0d580fff]
[65465.285084]   node   0: [mem 0x0d5e5000-0x0dbdffff]
[65465.289251] ACPI: PM-Timer IO Port: 0xb008
[65465.291105] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[65465.293766] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[65465.296413] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[65465.299460] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[65465.302607] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[65465.305524] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[65465.308622] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[65465.311685] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[65465.314766] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[65465.317792] Using ACPI (MADT) for SMP configuration information
[65465.320608] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[65465.322958] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[65465.325861] PM: Registered nosave memory: [mem 0x0bd94000-0x0bdc0fff]
[65465.328809] PM: Registered nosave memory: [mem 0x0d581000-0x0d5d8fff]
[65465.331770] PM: Registered nosave memory: [mem 0x0d5d9000-0x0d5e0fff]
[65465.334716] PM: Registered nosave memory: [mem 0x0d5e1000-0x0d5e4fff]
[65465.337723] e820: [mem 0x0dc00000-0xffffffff] available for PCI devices
[65465.340880] Booting paravirtualized kernel on KVM
[65465.343045] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:1 nr_node_ids:1
[65465.346736] PERCPU: Embedded 28 pages/cpu @ffff88000a800000 s83392 r8192 d23104 u2097152
[65465.350469] kvm-clock: cpu 0, msr 0:d401001, primary cpu clock
[65465.353143] KVM setup async PF for cpu 0
[65465.354969] kvm-stealtime: cpu 0, msr a80dfc0
[65465.357124] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 53096
[65465.360905] Kernel command line: root=UUID=4522081c-614f-43ba-927b-1ef26d69fe20 ro console=ttyS0 earlyprintk=serial,ttyS0 nomodeset selinux=0 crashkernel=128M
[65465.367711] PID hash table entries: 1024 (order: 1, 8192 bytes)
[65465.370534] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[65465.373903] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[65465.377467] Memory: 144368K/224184K available (4748K kernel code, 788K rwdata, 2376K rodata, 888K init, 8968K bss, 79816K reserved)
[65465.382968] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[65465.386095] Preemptible hierarchical RCU implementation.
[65465.388602] 	RCU debugfs-based tracing is enabled.
[65465.390851] 	CONFIG_RCU_FANOUT set to non-default value of 32
[65465.393569] 	RCU dyntick-idle grace-period acceleration is enabled.
[65465.396494] 	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=1.
[65465.399422] 	Offload RCU callbacks from all CPUs
[65465.401594] 	Offload RCU callbacks from CPUs: 0.
[65465.403781] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
[65465.406906] NO_HZ: Full dynticks CPUs: 1-15.
[65465.408963] NR_IRQS:4352 nr_irqs:256 16
[65465.411104] Console: colour dummy device 80x25
[65465.413229] console [ttyS0] enabled
[65465.413229] console [ttyS0] enabled
[65465.416579] bootconsole [earlyser0] disabled
[65465.416579] bootconsole [earlyser0] disabled
[65465.420729] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[65465.424454] ... MAX_LOCKDEP_SUBCLASSES:  8
[65465.426418] ... MAX_LOCK_DEPTH:          48
[65465.428422] ... MAX_LOCKDEP_KEYS:        8191
[65465.430509] ... CLASSHASH_SIZE:          4096
[65465.432576] ... MAX_LOCKDEP_ENTRIES:     16384
[65465.434717] ... MAX_LOCKDEP_CHAINS:      32768
[65465.436858] ... CHAINHASH_SIZE:          16384
[65465.438991]  memory used by lock dependency info: 5855 kB
[65465.441630]  per task-struct memory footprint: 1920 bytes
[65465.444477] tsc: Detected 2793.268 MHz processor
[65465.446663] BUG: unable to handle kernel NULL pointer dereference at 0000000000000182
[65465.450471] IP: [<ffffffff81074023>] __queue_work+0x45/0x1ee
[65465.453195] PGD 0 
[65465.454270] Oops: 0000 [#1] PREEMPT SMP 
[65465.456286] Modules linked in:
[65465.457815] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0+ #15
[65465.460610] task: ffffffff81719490 ti: ffffffff816f8000 task.ti: ffffffff816f8000
[65465.464099] RIP: 0010:[<ffffffff81074023>]  [<ffffffff81074023>] __queue_work+0x45/0x1ee
[65465.467932] RSP: 0000:ffffffff816f9eb8  EFLAGS: 00010046
[65465.470418] RAX: 0000000000000006 RBX: 0000000000000292 RCX: 0000000000000030
[65465.473790] RDX: ffffffff817328e0 RSI: 0000000000000000 RDI: 0000000000000010
[65465.477159] RBP: ffffffff816f9ee8 R08: ffffffff817b6ac8 R09: 00000000ffffffff
[65465.480531] R10: 00000000fffea071 R11: 0000000225c17d03 R12: 0000000000000000
[65465.483927] R13: ffffffff817328e0 R14: ffffffff81857ac0 R15: 000000000b584000
[65465.487348] FS:  0000000000000000(0000) GS:ffff88000a800000(0000) knlGS:0000000000000000
[65465.491138] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[65465.493900] CR2: 0000000000000182 CR3: 0000000002714000 CR4: 00000000000006b0
[65465.497214] Stack:
[65465.498208]  0000001081857ac0 0000000000000292 000000000032dcd5 ffff88000b585680
[65465.501853]  ffffffff81857ac0 000000000b584000 ffffffff816f9f20 ffffffff8107420f
[65465.505492]  00000010816f9f30 0000000000000000 ffffffff817328e0 0000000000014280
[65465.509180] Call Trace:
[65465.510385]  [<ffffffff8107420f>] queue_work_on+0x43/0x7c
[65465.512932]  [<ffffffff810868a5>] clear_sched_clock_stable+0x32/0x34
[65465.515985]  [<ffffffff81086921>] sched_clock_init+0x7a/0x7f
[65465.518696]  [<ffffffff817d4cd8>] start_kernel+0x351/0x3fa
[65465.521367]  [<ffffffff817d4795>] ? repair_env_string+0x58/0x58
[65465.524159]  [<ffffffff817d4120>] ? early_idt_handlers+0x120/0x120
[65465.527044]  [<ffffffff817d4498>] x86_64_start_reservations+0x2a/0x2c
[65465.530038]  [<ffffffff817d458d>] x86_64_start_kernel+0xf3/0x100
[65465.532832] Code: 25 30 d2 72 81 f6 c4 02 74 21 80 3d 91 22 73 00 00 75 18 be 31 05 00 00 48 c7 c7 ca 0b 64 81 e8 80 c9 fe ff c6 05 77 22 73 00 01 <41> f6 84 24 82 01 00 00 01 74 59 65 48 8b 3c 25 c0 c9 00 00 f6 
[65465.544401] RIP  [<ffffffff81074023>] __queue_work+0x45/0x1ee
[65465.547201]  RSP <ffffffff816f9eb8>
[65465.548880] CR2: 0000000000000182
[65465.550462] ---[ end trace 8bf023a4e6e5d79e ]---
[65465.552655] Kernel panic - not syncing: Attempted to kill the idle task!

Thanks
Dave

