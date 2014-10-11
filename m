Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaJKMwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 08:52:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:49724 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbaJKMwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 08:52:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,698,1406617200"; 
   d="scan'208";a="587239257"
Message-ID: <543927E3.8010402@linux.intel.com>
Date: Sat, 11 Oct 2014 20:51:47 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [x86, irq] BUG: unable to handle kernel NULL pointer dereference
 at 0000003a
References: <20141011112115.GA651@wfg-t540p.sh.intel.com>
In-Reply-To: <20141011112115.GA651@wfg-t540p.sh.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,
	I found the root cause of this failure, it's triggered when
IOAPIC is disabled. We need following patch to fix it.
Regards!
Gerry
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 2df1bff738b1..2d778f508f65 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -255,7 +255,7 @@ int __init arch_probe_nr_irqs(void)
        if (nr < nr_irqs)
                nr_irqs = nr;

-       return 0;
+       return nr_legacy_irqs();
 }

 int __init arch_early_irq_init(void)


On 2014/10/11 19:21, Fengguang Wu wrote:
> Hi Gerry,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> https://github.com/jiangliu/linux.git irqdomain/p2v3
> 
> commit 07ddfcaeda058f3630c5b18cc3da18355a4a87c7
> Author:     Jiang Liu <jiang.liu@linux.intel.com>
> AuthorDate: Wed Jun 25 14:16:18 2014 +0800
> Commit:     Jiang Liu <jiang.liu@linux.intel.com>
> CommitDate: Thu Oct 9 09:33:26 2014 +0800
> 
>     x86, irq: Move IRQ initialization routines from io_apic.c into vector.c
>     
>     Move IRQ initialization routines from io_apic.c into vector.c,
>     preparing for enabling hierarchy irqdomain.
>     
>     Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> 
> +------------------------------------------+------------+------------+------------+
> |                                          | 7ae720aca4 | 07ddfcaeda | 199cd77204 |
> +------------------------------------------+------------+------------+------------+
> | boot_successes                           | 60         | 0          | 0          |
> | boot_failures                            | 0          | 20         | 12         |
> | BUG:unable_to_handle_kernel              | 0          | 20         | 12         |
> | Oops                                     | 0          | 20         | 12         |
> | EIP_is_at_setup_irq                      | 0          | 20         | 12         |
> | Kernel_panic-not_syncing:Fatal_exception | 0          | 20         | 12         |
> +------------------------------------------+------------+------------+------------+
> 
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> [    0.000000] NR_IRQS:16 nr_irqs:16 0
> [    0.000000] BUG: unable to handle kernel NULL pointer dereference at 0000003a
> [    0.000000] IP: [<c10f6fe7>] setup_irq+0x2d/0xbd
> [    0.000000] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
> [    0.000000] Oops: 0000 [#1] DEBUG_PAGEALLOC
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-02811-g07ddfca #2119
> [    0.000000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.000000] task: c1e68140 ti: c1e5e000 task.ti: c1e5e000
> [    0.000000] EIP: 0060:[<c10f6fe7>] EFLAGS: 00210046 CPU: 0
> [    0.000000] EIP is at setup_irq+0x2d/0xbd
> [    0.000000] EAX: 00000000 EBX: 00000002 ECX: 00000000 EDX: 00000002
> [    0.000000] ESI: 00000000 EDI: c1e77480 EBP: c1e5ffa4 ESP: c1e5ff98
> [    0.000000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [    0.000000] CR0: 8005003b CR2: 0000003a CR3: 020e7000 CR4: 000006b0
> [    0.000000] Stack:
> [    0.000000]  00000100 c1e76e0c 565f2e4e c1e5ffb0 c20518eb 00000000 c1e5ffcc c2051678
> [    0.000000]  00000010 00000000 c20b63c0 67667cc0 565f2e4e c1e5ffe8 c204c338 c20b63c0
> [    0.000000]  565f2e4e 00000800 00020800 c20e8800 c1e5fff8 c204b33b 00000800 c20e8800
> [    0.000000] Call Trace:
> [    0.000000]  [<c20518eb>] native_init_IRQ+0x25e/0x284
> [    0.000000]  [<c2051678>] init_IRQ+0x65/0x7a
> [    0.000000]  [<c204c338>] start_kernel+0x587/0xa5e
> [    0.000000]  [<c204b33b>] i386_start_kernel+0xe9/0xfb
> [    0.000000] Code: 05 80 86 8e c2 01 83 15 84 86 8e c2 00 89 e5 57 56 53 89 d7 89 c3 e8 e8 c8 ff ff 83 05 88 86 8e c2 01 89 c6 83 15 8c 86 8e c2 00 <f6> 40 3a 02 74 32 83 05 90 86 8e c2 01 b8 ff 8b d7 c1 ba 09 05
> [    0.000000] EIP: [<c10f6fe7>] setup_irq+0x2d/0xbd SS:ESP 0068:c1e5ff98
> [    0.000000] CR2: 000000000000003a
> [    0.000000] ---[ end trace 18cb1eda9f4a6d8f ]---
> [    0.000000] Kernel panic - not syncing: Fatal exception
> 
> git bisect start 199cd77204a4a265c243beaf2a82ce02296f2941 d5935b07da53f74726e2a65dd4281d0f2c70e5d4 --
> git bisect  bad 5f4d7e1f1beef4f1214872847226fa48cd08dffc  # 17:14      0-     20  x86, irq: Make MSI and HT_IRQ indepenent of X86_IO_APIC
> git bisect good 43d7c7f268310deb5f940a0c17534ec33ee35f2f  # 17:18     20+      0  x86, irq: Introduce helper to check whether an IOAPIC has been registered
> git bisect good ccaac4e425733c68903893dbd814409ada0c44b4  # 17:22     20+      0  x86, irq: Protect __clear_irq_vector() with vector_lock
> git bisect good 02b4095889333a5c2b7b31c5f3af97e8e9dbe715  # 17:26     20+      0  x86, irq: Move PCI MSI related code from io_apic.c into msi.c
> git bisect good 7ae720aca4b294c5934fa465276180e24f09b5a6  # 17:29     20+      0  x86, irq: Move IOAPIC related declarations from hw_irq.h into io_apic.h
> git bisect  bad 07ddfcaeda058f3630c5b18cc3da18355a4a87c7  # 17:32      0-     20  x86, irq: Move IRQ initialization routines from io_apic.c into vector.c
> # first bad commit: [07ddfcaeda058f3630c5b18cc3da18355a4a87c7] x86, irq: Move IRQ initialization routines from io_apic.c into vector.c
> git bisect good 7ae720aca4b294c5934fa465276180e24f09b5a6  # 17:35     60+      0  x86, irq: Move IOAPIC related declarations from hw_irq.h into io_apic.h
> git bisect  bad 199cd77204a4a265c243beaf2a82ce02296f2941  # 17:35      0-     12  x86, uv: Use hierarchy irqdomain to manage UV interrupts
> git bisect good 40c43269cf8e88a0bdc306c717d1dd5446a6f3b8  # 17:41     60+      0  Merge tag 'hwmon-for-linus-v3.18' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
> git bisect good 22f3190416445059ec17332efd71e78ec969d37f  # 17:51     60+      0  Add linux-next specific files for 20141010
> 
> 
> This script may reproduce the error.
> 
> ----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> 
> kvm=(
> 	qemu-system-x86_64
> 	-cpu kvm64
> 	-enable-kvm
> 	-kernel $kernel
> 	-m 320
> 	-smp 2
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-rtc base=localtime
> 	-serial stdio
> 	-display none
> 	-monitor null 
> )
> 
> append=(
> 	hung_task_panic=1
> 	earlyprintk=ttyS0,115200
> 	debug
> 	apic=debug
> 	sysrq_always_enabled
> 	rcupdate.rcu_cpu_stall_timeout=100
> 	panic=-1
> 	softlockup_panic=1
> 	nmi_watchdog=panic
> 	oops=panic
> 	load_ramdisk=2
> 	prompt_ramdisk=0
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> 	drbd.minor_count=8
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
> 
> Thanks,
> Fengguang
> 
