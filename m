Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3CFKS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:18:58 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:62780 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab3CFKSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:18:53 -0500
X-Nat-Received: from [202.181.97.72]:50154 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1362565006.19983
Message-Id: <201303061016.r26AGkVV038627@www262.sakura.ne.jp>
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 06 Mar 2013 19:16:46 +0900
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp> <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp> <201303052031.JFG81705.FSOOFQHJMVFOLt@I-love.SAKURA.ne.jp> <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp> <20130305180650.GD4914@pd.tnic> <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp> <51367104.5050200@linux.vnet.ibm.com> <20130305224432.GD27022@pd.tnic> <51368C45.40303@linux.vnet.ibm.com>
In-Reply-To: <51368C45.40303@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 06032013 #9670980, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> Could you also add the following to your .config:
> 
> 	CONFIG_ACPI_DEBUG=y
> 
> and boot with these on the kernel command-line:
> 
> 	acpi.debug_layer=0xffffffff acpi.debug_level=0x2
> 
> I _think_ that\'ll shed some light on exactly which ACPI table is being
> parsed when the BUG_ON() trips.  That will hopefully let other folks
> reproduce it more easily.
> 
Using CONFIG_ACPI_DEBUG=y and adding acpi.debug_layer=0xffffffff acpi.debug_level=0x2
changed nothing.

But I found that this bug occurs only when the system has little RAM.

With 892MB RAM where /proc/meminfo would show HighTotal > 0,
this bug does not occur.

    HighTotal:          4040 kB
    LowTotal:         873960 kB

With 888MB RAM where /proc/meminfo would show HighTotal == 0,
this bug occurs.

[    0.005852] ------------[ cut here ]------------
[    0.007043] kernel BUG at arch/x86/mm/physaddr.c:79!
[    0.008203] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[    0.009546] Modules linked in:
[    0.010303] Pid: 0, comm: swapper/0 Not tainted 3.9.0-rc1 #38 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
[    0.013023] EIP: 0060:[<c1030082>] EFLAGS: 00210206 CPU: 0
[    0.014294] EIP is at __phys_addr+0x42/0x90
[    0.015270] EAX: 00000000 EBX: 376f0000 ECX: 0000000c EDX: 00000000
[    0.016686] ESI: 00000000 EDI: c1665e90 EBP: c1665dc8 ESP: c1665dc4
[    0.018161]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.019422] CR0: 80050033 CR2: ffe13000 CR3: 01882000 CR4: 000406d0
[    0.020911] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.022363] DR6: ffff0ff0 DR7: 00000400
[    0.023242] Process swapper/0 (pid: 0, ti=c1664000 task=c166f140 task.ti=c1664000)
[    0.024957] Stack:
[    0.025427]  c1665e90 c1665de8 c102d02e c10d7b49 c166f5c8 c167dd00 00000000 c167dd00
[    0.027391]  f72b9bc0 c1665e70 c102d565 c1665e30 c10d7b49 00000002 c1664000 00000000
[    0.029372]  c10d78e2 c1665e18 c167dce8 00000001 c1665e60 c14b7000 c1665e18 000002f0
[    0.031373] Call Trace:
[    0.031947]  [<c102d02e>] __cpa_process_fault+0x3e/0x80
[    0.033165]  [<c10d7b49>] ? __purge_vmap_area_lazy+0x2a9/0x360
[    0.034500]  [<c102d565>] __change_page_attr_set_clr+0x2c5/0x5b0
[    0.035879]  [<c10d7b49>] ? __purge_vmap_area_lazy+0x2a9/0x360
[    0.037211]  [<c10d78e2>] ? __purge_vmap_area_lazy+0x42/0x360
[    0.038538]  [<c10d9194>] ? vm_unmap_aliases+0x64/0x300
[    0.039717]  [<c102d935>] change_page_attr_set_clr+0xe5/0x390
[    0.041059]  [<c102dc12>] _set_memory_wb+0x32/0x40
[    0.042143]  [<c102ca5f>] ioremap_change_attr+0xf/0x40
[    0.043330]  [<c102eec7>] kernel_map_sync_memtype+0x87/0xf0
[    0.044610]  [<c102c88b>] __ioremap_caller+0x21b/0x2f0
[    0.045813]  [<c103db8a>] ? walk_system_ram_range+0xca/0xf0
[    0.047072]  [<c102c993>] ioremap_cache+0x13/0x20
[    0.048183]  [<c14a5eb1>] ? acpi_os_map_memory+0xb6/0x112
[    0.049405]  [<c14a5eb1>] acpi_os_map_memory+0xb6/0x112
[    0.050620]  [<c12d1af8>] acpi_tb_verify_table+0x20/0x49
[    0.051840]  [<c12d2527>] acpi_load_tables+0x35/0x156
[    0.053009]  [<c16d7be7>] acpi_early_init+0x67/0xeb
[    0.054117]  [<c16b7b17>] start_kernel+0x30e/0x319
[    0.055203]  [<c16b767a>] ? repair_env_string+0x5b/0x5b
[    0.056422]  [<c16b7356>] i386_start_kernel+0x12c/0x12f
[    0.057599] Code: 0e dc c1 8d 98 00 00 00 40 85 d2 74 12 89 d9 c1 e9 0c 39 ca 72 19 e8 3e cd ff ff 39 c3 75 0c 89 d8 5b 5d c3 0f 0b 8d 76 00 eb fb <0f> 0b eb fe 0f 0b 90 8d b4 26 00 00 00 00 eb f6 8b 15 4c 0e dc
[    0.063695] EIP: [<c1030082>] __phys_addr+0x42/0x90 SS:ESP 0068:c1665dc4
[    0.065336] ---[ end trace ddccf428d5f1e08d ]---
[    0.066391] Kernel panic - not syncing: Attempted to kill the idle task!
