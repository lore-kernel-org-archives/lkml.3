Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaHMAgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:36:08 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34638 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaHMAgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:36:05 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 12 Aug 2014 17:35:42 -0700
Message-ID: <CALCETrUnparMXo37n7xRUMELErcY9DV=uwCnqMnnO_awHxmGjA@mail.gmail.com>
Subject: 3.16 regression: oops in copy_process
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first oops I got was:

[    5.220159] [TTM] Zone  kernel: Available graphics memory: 16451530 kiB
[    5.220162] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    5.220163] [TTM] Initializing pool allocator
[    5.220167] [TTM] Initializing DMA pool allocator
[    5.250463] BUG: unable to handle kernel [    5.252639] megasas:
INIT adapter done

[    5.258919] paging request at ffff880817493000
[    5.258920] IP: [<ffffffff812dd077>] clear_page_c+0x7/0x10
[    5.258927] fbcon: mgadrmfb (fb0) is primary device
[    5.258928] PGD 1cdd067 PUD 1ce0067 PMD 817599063 PTE 8000000817493161

I'm not sure what happened to the rest of the oops.

With a less screwy serial console config, I got this:

[   10.841418] BUG: unable to handle kernel paging request at ffff880035b4c000
[   10.849212] IP: [<ffffffff8106f673>] copy_process.part.33+0x153/0x19a0
[   10.849214] PGD 1cdd067 PUD 1cde067 PMD 35b49063 PTE 8000000035b4c161
[   10.849215] Oops: 0003 [#1] PREEMPT SMP
[   10.849226] Modules linked in: sb_edac ioatdma edac_core ehci_pci
shpchp ehci_hcd crc32_pclmul lpc_ich tpm_tis dcdbas acpi_power_meter
dca microcode wmi mfd_core acpi_pad binfmt_misc ipmi_si
ipmi_msghandler coretemp mgag200 syscopyarea sysfillrect sysimgblt ttm
tg3 mtd drm_kms_helper ptp drm mdio megaraid_sas i2c_algo_bit pps_core
[   10.849228] CPU: 26 PID: 887 Comm: vlan-network-in Not tainted
3.16.0-ama+ #59
[   10.849228] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS
1.2.6 05/10/2012
[   10.849229] task: ffff880418c1b0e0 ti: ffff88041bcc8000 task.ti:
ffff88041bcc8000
[   10.849231] RIP: 0010:[<ffffffff8106f673>]  [<ffffffff8106f673>]
copy_process.part.33+0x153/0x19a0
[   10.849232] RSP: 0018:ffff88041bccbdf8  EFLAGS: 00010246
[   10.849233] RAX: ffff88041bcc8000 RBX: 0000000001200011 RCX: ffff880418c1b0e0
[   10.849233] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffff880035971a00
[   10.849234] RBP: ffff88041bccbeb0 R08: 0000000000016840 R09: ffff880035971a00
[   10.849234] R10: ffffea0000d6d320 R11: 0000000000000000 R12: ffff880035b4c000
[   10.849235] R13: 0000000000000000 R14: 00007fc7e3fa1a10 R15: ffff880419b6c950
[   10.849235] FS:  00007fc7e3fa1740(0000) GS:ffff88041fda0000(0000)
knlGS:0000000000000000
[   10.849236] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.849237] CR2: ffff880035b4c000 CR3: 000000041a2b9000 CR4: 00000000000407e0
[   10.849237] Stack:
[   10.849238]  ffff8804000000a9 800000041902f065 ffff880418dea738
00000000000000a9
[   10.849239]  0000000000000007 00007fff6d8e7f68 ffff88041bccbf58
ffff88041872ec00
[   10.849240]  ffff88041bccbf38 ffffffff81040eec 0000000000060054
ffff880418c1b0e0
[   10.849241] Call Trace:
[   10.849244]  [<ffffffff81040eec>] ? __do_page_fault+0x1fc/0x5d0
[   10.849245]  [<ffffffff81071075>] do_fork+0xd5/0x360
[   10.849248]  [<ffffffff8119ba8f>] ? SYSC_newstat+0x2f/0x40
[   10.849250]  [<ffffffff81071386>] SyS_clone+0x16/0x20
[   10.849261]  [<ffffffff815a7939>] stub_clone+0x69/0x90
[   10.849262]  [<ffffffff815a7692>] ? system_call_fastpath+0x16/0x1b
[   10.849274] Code: 0f 84 27 05 00 00 48 8b 74 24 58 4c 89 ff e8 15
d9 f9 ff 85 c0 0f 85 05 05 00 00 48 8b 44 24 58 4d 89 67 08 48 8b 40
08 48 8b 08 <49> 89 0c 24 48 8b 48 08 49 89 4c 24 08 48 8b 48 10 49 89
4c 24
[   10.849275] RIP  [<ffffffff8106f673>] copy_process.part.33+0x153/0x19a0
[   10.849276]  RSP <ffff88041bccbdf8>
[   10.849276] CR2: ffff880035b4c000
[   10.849278] ---[ end trace aed3dfbe8d8529ce ]---
[   10.849280] BUG: unable to handle kernel paging request at ffff880035b56000
[   10.849659] IP: [<ffffffff812dd077>] clear_page_c+0x7/0x10
[   10.849661] PGD 1cdd067 PUD 1cde067 PMD 35b49063 PTE 8000000035b56161
[   10.849662] Oops: 0003 [#2] PREEMPT SMP
[   10.849670] Modules linked in: sb_edac ioatdma edac_core ehci_pci
shpchp ehci_hcd crc32_pclmul lpc_ich tpm_tis dcdbas acpi_power_meter
dca microcode wmi mfd_core acpi_pad binfmt_misc ipmi_si
ipmi_msghandler coretemp mgag200 syscopyarea sysfillrect sysimgblt ttm
tg3 mtd drm_kms_helper ptp drm mdio megaraid_sas i2c_algo_bit pps_core
[   10.849672] CPU: 20 PID: 885 Comm: sed Tainted: G      D
3.16.0-ama+ #59
[   10.849672] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS
1.2.6 05/10/2012
[   10.849673] task: ffff880818758000 ti: ffff88081b8ac000 task.ti:
ffff88081b8ac000
[   10.849675] RIP: 0010:[<ffffffff812dd077>]  [<ffffffff812dd077>]
clear_page_c+0x7/0x10
[   10.849675] RSP: 0000:ffff88081b8afb00  EFLAGS: 00010246
[   10.849676] RAX: 0000000000000000 RBX: 0000000000d6d580 RCX: 0000000000000200
[   10.849677] RDX: ffff880818758000 RSI: 0000000000000000 RDI: ffff880035b56000
[   10.849677] RBP: ffff88081b8afbd0 R08: ffffffff817ea96d R09: ffffea0000d6d5c0
[   10.849678] R10: 0000000000003ce8 R11: 0000000000000000 R12: ffff880000000000
[   10.849678] R13: 0000000000d6d5c0 R14: ffffea0000d6d580 R15: ffff88041fd56648
[   10.849679] FS:  0000000000000000(0000) GS:ffff88041fd40000(0000)
knlGS:0000000000000000
[   10.849679] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.849680] CR2: ffff880035b56000 CR3: 0000000419406000 CR4: 00000000000407e0
[   10.849680] Stack:
[   10.849682]  ffffffff8113e4dd 0000000000000ffc ffff88042fffcd08
0000000000000000
[   10.849683]  00000003000024ba ffff88042fffcd00 0000014100000000
ffff88042fffcd28
[   10.849684]  0000000000000000 0000000200000000 0000000000000000
0000014100000000
[   10.849684] Call Trace:
[   10.849688]  [<ffffffff8113e4dd>] ? get_page_from_freelist+0x4fd/0x8b0
[   10.849690]  [<ffffffff8113e9f4>] __alloc_pages_nodemask+0x164/0xae0
[   10.849692]  [<ffffffff812e71b3>] ? __this_cpu_preempt_check+0x13/0x20
[   10.849694]  [<ffffffff81152c37>] ? __inc_zone_state+0x47/0xa0
[   10.849696]  [<ffffffff812e71b3>] ? __this_cpu_preempt_check+0x13/0x20
[   10.849698]  [<ffffffff8117cba4>] alloc_pages_current+0xa4/0x170
[   10.849700]  [<ffffffff810459e7>] pte_alloc_one+0x17/0x70
[   10.849701]  [<ffffffff8115e027>] __pte_alloc+0x27/0x150
[   10.849702]  [<ffffffff811619c7>] handle_mm_fault+0xbd7/0xc60
[   10.849704]  [<ffffffff81040e74>] __do_page_fault+0x184/0x5d0
[   10.849705]  [<ffffffff81167c55>] ? do_mmap_pgoff+0x2f5/0x3c0
[   10.849707]  [<ffffffff81151222>] ? vm_mmap_pgoff+0x72/0xa0
[   10.849708]  [<ffffffff810412cc>] do_page_fault+0xc/0x10
[   10.849710]  [<ffffffff815a9062>] page_fault+0x22/0x30
[   10.849721] Code: 4c 29 ea 39 da 89 d1 7f c4 85 d2 7f 9d 89 d0 eb
bc 0f 1f 00 e8 0b 4c d9 ff 90 90 90 90 90 90 90 90 90 90 90 b9 00 02
00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 b9 00 10 00 00 31 c0 f3 aa c3
66 0f
[   10.849722] RIP  [<ffffffff812dd077>] clear_page_c+0x7/0x10
[   10.849723]  RSP <ffff88081b8afb00>
[   10.849723] CR2: ffff880035b56000
[   10.849724] ---[ end trace aed3dfbe8d8529cf ]---

... and much more.

The crash is here:

   0xffffffff8106f5c1 <+161>:   mov    0x690(%r12),%rdx
   0xffffffff8106f5c9 <+169>:   cmp    0x20(%rdx),%rax
   0xffffffff8106f5cd <+173>:   jne    0xffffffff8106f590 <copy_process+112>
   0xffffffff8106f5cf <+175>:   nop
   0xffffffff8106f5d0 <+176>:   mov    %gs:0xb940,%rax
   0xffffffff8106f5d9 <+185>:   mov    %rax,%rdi
   0xffffffff8106f5dc <+188>:   mov    %rax,0x58(%rsp)
   0xffffffff8106f5e1 <+193>:   callq  0xffffffff81093e20 <tsk_fork_get_node>
   0xffffffff8106f5e6 <+198>:   mov    0xbc1913(%rip),%rdi        # 0xffffffff8>
   0xffffffff8106f5ed <+205>:   mov    $0xd0,%esi
   0xffffffff8106f5f2 <+210>:   mov    %eax,%edx
   0xffffffff8106f5f4 <+212>:   mov    %eax,%r12d
   0xffffffff8106f5f7 <+215>:   callq  0xffffffff811873a0 <kmem_cache_alloc_nod>
   0xffffffff8106f5fc <+220>:   test   %rax,%rax
   0xffffffff8106f5ff <+223>:   mov    %rax,%r15
   0xffffffff8106f602 <+226>:   je     0xffffffff8106fb84 <copy_process+1636>
   0xffffffff8106f608 <+232>:   mov    $0x2,%edx
   0xffffffff8106f60d <+237>:   mov    $0x2000d0,%esi
   0xffffffff8106f612 <+242>:   mov    %r12d,%edi
   0xffffffff8106f615 <+245>:   callq  0xffffffff8113f430 <alloc_kmem_pages_nod-
>
   0xffffffff8106f61a <+250>:   test   %rax,%rax
   0xffffffff8106f61d <+253>:   je     0xffffffff8106fb75 <copy_process+1621>
   0xffffffff8106f623 <+259>:   movabs $0x160000000000,%rdx
   0xffffffff8106f62d <+269>:   add    %rdx,%rax
   0xffffffff8106f630 <+272>:   movabs $0xffff880000000000,%rdx
   0xffffffff8106f63a <+282>:   sar    $0x6,%rax
   0xffffffff8106f63e <+286>:   shl    $0xc,%rax
   0xffffffff8106f642 <+290>:   add    %rdx,%rax
   0xffffffff8106f645 <+293>:   mov    %rax,%r12
   0xffffffff8106f648 <+296>:   je     0xffffffff8106fb75 <copy_process+1621>
   0xffffffff8106f64e <+302>:   mov    0x58(%rsp),%rsi
   0xffffffff8106f653 <+307>:   mov    %r15,%rdi
   0xffffffff8106f656 <+310>:   callq  0xffffffff8100cf70 <arch_dup_task_struct>
   0xffffffff8106f65b <+315>:   test   %eax,%eax
   0xffffffff8106f65d <+317>:   jne    0xffffffff8106fb68 <copy_process+1608>
   0xffffffff8106f663 <+323>:   mov    0x58(%rsp),%rax
   0xffffffff8106f668 <+328>:   mov    %r12,0x8(%r15)
   0xffffffff8106f66c <+332>:   mov    0x8(%rax),%rax
   0xffffffff8106f670 <+336>:   mov    (%rax),%rcx
   0xffffffff8106f673 <+339>:   mov    %rcx,(%r12)  <--- here
   0xffffffff8106f677 <+343>:   mov    0x8(%rax),%rcx
   0xffffffff8106f67b <+347>:   mov    %rcx,0x8(%r12)
   0xffffffff8106f680 <+352>:   mov    0x10(%rax),%rcx
   0xffffffff8106f684 <+356>:   mov    %rcx,0x10(%r12)
   0xffffffff8106f689 <+361>:   mov    0x18(%rax),%rcx
   0xffffffff8106f68d <+365>:   mov    %rcx,0x18(%r12)
   0xffffffff8106f692 <+370>:   mov    0x20(%rax),%rcx
   0xffffffff8106f696 <+374>:   mov    %rcx,0x20(%r12)
   0xffffffff8106f69b <+379>:   mov    0x28(%rax),%rcx
   0xffffffff8106f69f <+383>:   mov    %rcx,0x28(%r12)
   0xffffffff8106f6a4 <+388>:   mov    0x30(%rax),%rcx

At the bad instruction, it looks like r15 contains tsk.  r12 might be
ti (not sure I followed this part right).

Any ideas?

--Andy
