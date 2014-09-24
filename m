Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaIXNUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:20:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:50226 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaIXNUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:20:21 -0400
X-IronPort-AV: E=Sophos;i="5.04,589,1406592000"; 
   d="scan'208";a="174673754"
Message-ID: <5422C512.1010602@citrix.com>
Date: Wed, 24 Sep 2014 14:20:18 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <jbeulich@suse.com>
Subject: Re: [PATCH V3] xen: eliminate scalability issues from initial mapping
 setup
References: <1410965981-15444-1-git-send-email-jgross@suse.com> <1410965981-15444-2-git-send-email-jgross@suse.com>
In-Reply-To: <1410965981-15444-2-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/14 15:59, Juergen Gross wrote:
> Direct Xen to place the initial P->M table outside of the initial
> mapping, as otherwise the 1G (implementation) / 2G (theoretical)
> restriction on the size of the initial mapping limits the amount
> of memory a domain can be handed initially.
> 
> As the initial P->M table is copied rather early during boot to
> domain private memory and it's initial virtual mapping is dropped,
> the easiest way to avoid virtual address conflicts with other
> addresses in the kernel is to use a user address area for the
> virtual address of the initial P->M table. This allows us to just
> throw away the page tables of the initial mapping after the copy
> without having to care about address invalidation.
> 
> It should be noted that this patch won't enable a pv-domain to USE
> more than 512 GB of RAM. It just enables it to be started with a
> P->M table covering more memory. This is especially important for
> being able to boot a Dom0 on a system with more than 512 GB memory.

This doesn't seem to work.  It crashes when attempting to construct
the page tables.  Have these patches been tested on a host with > 512 GiB?

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc6.davidvr (davidvr@qabil) (gcc version 4.4
[    0.000000] Command line: root=LABEL=root-kivexhrj ro hpet=disable console=tn
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] Set 526888 page(s) to 1-1 mapping
[    0.000000] Remapped 526888 page(s), last_pfn=131598888
[    0.000000] Released 0 page(s)
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x000000007f637fff] usable
[    0.000000] Xen: [mem 0x000000007f638000-0x000000007f64dfff] reserved
[    0.000000] Xen: [mem 0x000000007f64e000-0x000000007f6ccfff] ACPI data
[    0.000000] Xen: [mem 0x000000007f6cd000-0x000000008fffffff] reserved
[    0.000000] Xen: [mem 0x00000000ecff0000-0x00000000ecff1fff] reserved
[    0.000000] Xen: [mem 0x00000000fe000000-0x00000000ffffffff] reserved
[    0.000000] Xen: [mem 0x0000000100000000-0x0000007cffffffff] usable
[    0.000000] Xen: [mem 0x0000007d00000000-0x000001007fffffff] unusable
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x7d00000 max_arch_pfn = 0x400000000
[    0.000000] e820: last_pfn = 0x7f638 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x7cffe00000-0x7cffffffff]
[    0.000000] init_memory_mapping: [mem 0x7cfc000000-0x7cffdfffff]
[    0.000000] init_memory_mapping: [mem 0x7c80000000-0x7cfbffffff]
[    0.000000] init_memory_mapping: [mem 0x7000000000-0x7c7fffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7f637fff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x6fffffffff]
[    0.000000] RAMDISK: [mem 0x04000000-0x04856fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0A90 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x00000000000F0C54 000094 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: FACP 0x000000007F68F588 0000F4 (v03 DELL   PE_SC3   000000)
[    0.000000] ACPI: DSDT 0x000000007F64E000 0055C3 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: FACS 0x000000007F691000 000040
[    0.000000] ACPI: APIC 0x000000007F68E478 0002DE (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: SPCR 0x000000007F68E764 000050 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: HPET 0x000000007F68E7B8 000038 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: XMAR 0x000000007F68E7F4 0001C8 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: MCFG 0x000000007F68EAE8 00003C (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: WD__ 0x000000007F68EB28 000134 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: SLIC 0x000000007F68EC60 000024 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: ERST 0x000000007F653744 000270 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: HEST 0x000000007F6539B4 000514 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: BERT 0x000000007F6535C4 000030 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: EINJ 0x000000007F6535F4 000150 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: SRAT 0x000000007F68EDE4 000738 (v01 DELL   PE_SC3   000000)
[    0.000000] ACPI: TCPA 0x000000007F68F520 000064 (v02 DELL   PE_SC3   000000)
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x7cffffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x7f637fff]
[    0.000000]   node   0: [mem 0x100000000-0x7cffffffff]
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at        )
[    0.000000] IP: [<ffffffff8100b7d4>] get_phys_to_machine+0x64/0x70
[    0.000000] PGD 0 
[    0.000000] Oops: 0000 [#1] SMP 
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-rc6.davidvr #1
[    0.000000] Hardware name: Dell Inc. PowerEdge R910/0P658H, BIOS 1.2.0 06/220
[    0.000000] task: ffffffff81a1a4a0 ti: ffffffff81a00000 task.ti: ffffffff81a0
[    0.000000] RIP: e030:[<ffffffff8100b7d4>]  [<ffffffff8100b7d4>] get_phys_to0
[    0.000000] RSP: e02b:ffffffff81a03d70  EFLAGS: 00010007
[    0.000000] RAX: 00000080003fc000 RBX: 001000806d0000e7 RCX: 00000000000001f4
[    0.000000] RDX: ffffffff820c2000 RSI: 000000000000005a RDI: 0000000007d0025a
[    0.000000] RBP: ffffffff81a03d70 R08: ffffffff81a03d94 R09: ffff880000000000
[    0.000000] R10: ffffffff81a03d90 R11: ffffff82fff7dfff R12: 000000000806d000
[    0.000000] R13: 0000000007d0025a R14: ffff880000000000 R15: ffff880044859ec0
[    0.000000] FS:  0000000000000000(0000) GS:ffffffff81ad8000(0000) knlGS:00000
[    0.000000] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.000000] CR2: 0000000000000000 CR3: 0000000001a13000 CR4: 0000000000002660
[    0.000000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.000000] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[    0.000000] Stack:
[    0.000000]  ffffffff81a03da0 ffffffff8100624f ffffffff81058bf7 000000807b000
[    0.000000]  00003ffffffff000 ffff887a4fce0000 ffffffff81a03db0 ffffffff8100e
[    0.000000]  ffffffff81a03e58 ffffffff810054c9 ffffff82fff7dfff ffffffff81a00
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8100624f>] pte_mfn_to_pfn+0x7f/0x100
[    0.000000]  [<ffffffff81058bf7>] ? lookup_address_in_pgd+0x27/0xf0
[    0.000000]  [<ffffffff8100a07e>] xen_pmd_val+0xe/0x10
[    0.000000]  [<ffffffff810054c9>] __raw_callee_save_xen_pmd_val+0x11/0x1e
[    0.000000]  [<ffffffff81af2640>] ? xen_pagetable_init+0x1ba/0x3cb
[    0.000000]  [<ffffffff81af678b>] setup_arch+0xbcd/0xccf
[    0.000000]  [<ffffffff8159ecbe>] ? printk+0x4d/0x4f
[    0.000000]  [<ffffffff81aedcfd>] start_kernel+0x8b/0x416
[    0.000000]  [<ffffffff81aed5f0>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81af0fc7>] xen_start_kernel+0x582/0x584
[    0.000000] Code: f9 48 89 f8 48 c1 e9 12 48 c1 e8 09 48 89 fe 25 ff 01 00 0 
[    0.000000] RIP  [<ffffffff8100b7d4>] get_phys_to_machine+0x64/0x70
[    0.000000]  RSP <ffffffff81a03d70>
[    0.000000] CR2: 0000000000000000
[    0.000000] ---[ end trace 7aee8d2e027fb7f0 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!

