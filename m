Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaKOKWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 05:22:34 -0500
Received: from mga03.intel.com ([134.134.136.65]:24255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbaKOKWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 05:22:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,391,1413270000"; 
   d="scan'208";a="637413316"
Date: Sat, 15 Nov 2014 18:22:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: [x86, mm] BUG: Bad page state in process swapper/0  pfn:020c0
Message-ID: <20141115102225.GA6679@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git x86/pmd-nx

commit 3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Fri Nov 14 11:36:17 2014 -0800
Commit:     Kees Cook <keescook@chromium.org>
CommitDate: Fri Nov 14 13:36:37 2014 -0800

    x86, mm: set NX across entire PMD at boot
    
    When setting up permissions on kernel memory at boot, the end of the
    PMD that was split from bss remained executable. It should be NX like
    the rest. This performs a PMD alignment instead of a PAGE alignment to
    get the correct span of memory, and should be freed.
    
    Before:
    ---[ High Kernel Mapping ]---
    ...
    0xffffffff8202d000-0xffffffff82200000  1868K     RW       GLB NX pte
    0xffffffff82200000-0xffffffff82c00000    10M     RW   PSE GLB NX pmd
    0xffffffff82c00000-0xffffffff82df5000  2004K     RW       GLB NX pte
    0xffffffff82df5000-0xffffffff82e00000    44K     RW       GLB x  pte
    0xffffffff82e00000-0xffffffffc0000000   978M                     pmd
    
    After:
    ---[ High Kernel Mapping ]---
    ...
    0xffffffff8202d000-0xffffffff82200000  1868K     RW       GLB NX pte
    0xffffffff82200000-0xffffffff82c00000    10M     RW   PSE GLB NX pmd
    0xffffffff82c00000-0xffffffff82df5000  2004K     RW       GLB NX pte
    0xffffffff82df5000-0xffffffff82e00000    44K     RW           NX pte
    0xffffffff82e00000-0xffffffffc0000000   978M                     pmd
    
    Signed-off-by: Kees Cook <keescook@chromium.org>

+------------------------------------------+------------+------------+------------+
|                                          | b23dc5a7cc | 3622dcc2b4 | 192495a3a4 |
+------------------------------------------+------------+------------+------------+
| boot_successes                           | 64         | 0          | 0          |
| boot_failures                            | 1          | 20         | 14         |
| BUG:kernel_boot_hang                     | 1          |            |            |
| BUG:Bad_page_state_in_process            | 0          | 20         | 14         |
| BUG:Bad_page_map_in_process              | 0          | 15         | 10         |
| backtrace:free_reserved_area             | 0          | 20         | 14         |
| backtrace:free_init_pages                | 0          | 20         | 14         |
| backtrace:mark_rodata_ro                 | 0          | 20         | 14         |
| backtrace:do_execve_common               | 0          | 3          | 2          |
| backtrace:SyS_execve                     | 0          | 3          | 2          |
| backtrace:do_group_exit                  | 0          | 13         | 7          |
| backtrace:SyS_exit_group                 | 0          | 13         | 7          |
| general_protection_fault                 | 0          | 7          | 6          |
| RIP:release_pages                        | 0          | 5          | 5          |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 10         | 5          |
| backtrace:vfs_read                       | 0          | 4          | 3          |
| backtrace:SyS_read                       | 0          | 4          | 3          |
| BUG:unable_to_handle_kernel              | 0          | 3          |            |
| Oops                                     | 0          | 3          |            |
| RIP:__delete_from_page_cache             | 0          | 2          |            |
| backtrace:SYSC_renameat2                 | 0          | 2          |            |
| backtrace:SyS_rename                     | 0          | 2          |            |
| RIP:__page_cache_release                 | 0          | 2          |            |
| RIP:free_pcppages_bulk                   | 0          | 1          |            |
| backtrace:vfs_write                      | 0          | 0          | 1          |
| backtrace:SyS_write                      | 0          | 0          | 1          |
+------------------------------------------+------------+------------+------------+

[    2.615868]   #3: Internal PC-Speaker at port 0x61
[    2.617590] Freeing unused kernel memory: 924K (ffffffff81f15000 - ffffffff81ffc000)
[    2.619355] Write protecting the kernel read-only data: 14336k
[    2.621361] BUG: Bad page state in process swapper/0  pfn:020c0
[    2.622959] page:ffff880012f69000 count:0 mapcount:-127 mapping:          (null) index:0x2
[    2.624982] flags: 0x80000000000()
[    2.626452] page dumped because: nonzero mapcount
[    2.627529] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4-g3622dcc2 #1477
[    2.629672] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.630904]  ffffffff81caf350 ffff88001289fd78 ffffffff819360c5 0000000000000000
[    2.633079]  ffff880012f69000 ffff88001289fda8 ffffffff8113046b 0000000000000001
[    2.635141]  ffff880012f69000 0000000000000000 ffff880012f69040 ffff88001289fdf8
[    2.637254] Call Trace:
[    2.637950]  [<ffffffff819360c5>] dump_stack+0x4f/0x7c
[    2.639063]  [<ffffffff8113046b>] bad_page+0xdb/0x130
[    2.640278]  [<ffffffff811305fe>] free_pages_prepare+0x13e/0x160
[    2.641536]  [<ffffffff8113272c>] free_hot_cold_page+0x4c/0x1e0
[    2.642757]  [<ffffffff81132947>] __free_pages+0x27/0x30
[    2.643885]  [<ffffffff81132c5f>] free_reserved_area+0xcf/0x150
[    2.645144]  [<ffffffff810350c4>] free_init_pages+0x74/0xb0
[    2.646327]  [<ffffffff8193fc9c>] ? bad_gs+0x299/0x171d
[    2.647451]  [<ffffffff81035d04>] mark_rodata_ro+0xb4/0x120
[    2.648678]  [<ffffffff819288a0>] ? rest_init+0x80/0x80
[    2.650138]  [<ffffffff819288b8>] kernel_init+0x18/0xf0
[    2.651258]  [<ffffffff8193d6bc>] ret_from_fork+0x7c/0xb0
[    2.652420]  [<ffffffff819288a0>] ? rest_init+0x80/0x80
[    2.653559] Disabling lock debugging due to kernel taint
[    2.659112] BUG: Bad page state in process swapper/0  pfn:02100
[    2.660356] page:ffff880012f6a000 count:0 mapcount:-127 mapping:          (null) index:0x2
[    2.662165] flags: 0x80000000000()
[    2.663090] page dumped because: nonzero mapcount
[    2.664137] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G    B          3.18.0-rc4-g3622dcc2 #1477
[    2.665978] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.667168]  ffffffff81caf350 ffff88001289fd78 ffffffff819360c5 0000000000000000
[    2.669248]  ffff880012f6a000 ffff88001289fda8 ffffffff8113046b 0000000000000001
[    2.671299]  ffff880012f6a000 0000000000000000 ffff880012f6a040 ffff88001289fdf8
[    2.673381] Call Trace:
[    2.674071]  [<ffffffff819360c5>] dump_stack+0x4f/0x7c
[    2.675168]  [<ffffffff8113046b>] bad_page+0xdb/0x130
[    2.676378]  [<ffffffff811305fe>] free_pages_prepare+0x13e/0x160
[    2.677627]  [<ffffffff8113272c>] free_hot_cold_page+0x4c/0x1e0
[    2.678853]  [<ffffffff81132947>] __free_pages+0x27/0x30
[    2.679983]  [<ffffffff81132c5f>] free_reserved_area+0xcf/0x150
[    2.681233]  [<ffffffff810350c4>] free_init_pages+0x74/0xb0
[    2.682411]  [<ffffffff8193fc9c>] ? bad_gs+0x299/0x171d
[    2.683531]  [<ffffffff81035d04>] mark_rodata_ro+0xb4/0x120
[    2.684729]  [<ffffffff819288a0>] ? rest_init+0x80/0x80
[    2.685849]  [<ffffffff819288b8>] kernel_init+0x18/0xf0
[    2.686967]  [<ffffffff8193d6bc>] ret_from_fork+0x7c/0xb0
[    2.688125]  [<ffffffff819288a0>] ? rest_init+0x80/0x80
[    2.689990] Freeing unused kernel memory: 1284K (ffffffff820bf000 - ffffffff82200000)
[    2.694431] Freeing unused kernel memory: 752K (ffff880001944000 - ffff880001a00000)
[    2.697790] Freeing unused kernel memory: 456K (ffff880001d8e000 - ffff880001e00000)
[    2.807184] BUG: Bad page state in process udevd  pfn:020bf
[    2.813249] BUG: Bad page map in process udevd  pte:80000000020bf045 pmd:0fd3a067
[    2.815394] page:ffff880012f68fc0 count:2 mapcount:-1 mapping:ffff88000fceb7a9 index:0x2
[    2.817744] flags: 0x80000080068(uptodate|lru|active|swapbacked)
[    2.819911] page dumped because: bad pte
[    2.821153] addr:00007fffba69d000 vm_flags:00100173 anon_vma:ffff88000fd347a8 mapping:          (null) index:7fffffff6
[    2.824010] CPU: 0 PID: 141 Comm: udevd Tainted: G    B          3.18.0-rc4-g3622dcc2 #1477
[    2.826355] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.827847]  ffff88000fd283f0 ffff88000fd33c28 ffffffff819360c5 0000000000000000
[    2.830479]  00007fffba69d000 ffff88000fd33c78 ffffffff8114da8a ffff880012f68fc0
[    2.833278]  0000000000000000 00007fffba6a6000 ffff88000fd3a4e8 ffff880012f68fc0
[    2.834890] Call Trace:
[    2.835394]  [<ffffffff819360c5>] dump_stack+0x4f/0x7c
[    2.836228]  [<ffffffff8114da8a>] print_bad_pte+0x1ba/0x280
[    2.837097]  [<ffffffff8114f063>] unmap_page_range+0x713/0x7c0
[    2.838191]  [<ffffffff8114f164>] unmap_single_vma+0x54/0xd0
[    2.839438]  [<ffffffff8114fc91>] unmap_vmas+0x41/0x60
[    2.840554]  [<ffffffff81158cfc>] exit_mmap+0x8c/0x160
[    2.841367]  [<ffffffff810aa820>] mmput+0x40/0xd0
[    2.842133]  [<ffffffff810af43b>] do_exit+0x31b/0xa40
[    2.842942]  [<ffffffff815153c3>] ? __this_cpu_preempt_check+0x13/0x20
[    2.843905]  [<ffffffff810afbe2>] do_group_exit+0x42/0xc0
[    2.844868]  [<ffffffff810afc6f>] SyS_exit_group+0xf/0x10
[    2.845930]  [<ffffffff8193d93d>] tracesys_phase2+0xd8/0xdd
[    2.875770] page:ffff880012f68fc0 count:2 mapcount:-1 mapping:ffff88000fceb7a9 index:0x2
[    2.890680] BUG: Bad page map in process udevd  pte:80000000020c5045 pmd:0feed067
[    2.892246] page:ffff880012f69140 count:39 mapcount:-128 mapping:ffff88000fcbfdc9 index:0x61f
[    2.894275] flags: 0x80000080068(uptodate|lru|active|swapbacked)
[    2.896077] page dumped because: bad pte
[    2.896999] addr:000000000061f000 vm_flags:00100073 anon_vma:ffff88000f5ed498 mapping:          (null) index:61f
[    2.899209] CPU: 0 PID: 202 Comm: udevd Tainted: G    B          3.18.0-rc4-g3622dcc2 #1477
[    2.901739] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.903219]  ffff88000f4a01f8 ffff88000fedbc28 ffffffff819360c5 0000000000000000
[    2.905844]  000000000061f000 ffff88000fedbc78 ffffffff8114da8a ffff880012f69140
[    2.908544]  0000000000000000 000000000063f000 ffff88000feed0f8 ffff880012f69140
[    2.911174] Call Trace:
[    2.911855]  [<ffffffff819360c5>] dump_stack+0x4f/0x7c
[    2.913263]  [<ffffffff8114da8a>] print_bad_pte+0x1ba/0x280
[    2.914788]  [<ffffffff8114f063>] unmap_page_range+0x713/0x7c0
[    2.916371]  [<ffffffff8114f164>] unmap_single_vma+0x54/0xd0
[    2.917922]  [<ffffffff8114fc91>] unmap_vmas+0x41/0x60
[    2.919354]  [<ffffffff81158cfc>] exit_mmap+0x8c/0x160
[    2.920825]  [<ffffffff810aa820>] mmput+0x40/0xd0
[    2.922158]  [<ffffffff810af43b>] do_exit+0x31b/0xa40
[    2.923598]  [<ffffffff815153c3>] ? __this_cpu_preempt_check+0x13/0x20
[    2.925297]  [<ffffffff810afbe2>] do_group_exit+0x42/0xc0
[    2.926762]  [<ffffffff810afc6f>] SyS_exit_group+0xf/0x10
[    2.928258]  [<ffffffff8193d93d>] tracesys_phase2+0xd8/0xdd
[    2.929764] BUG: Bad page map in process udevd  pte:80000000020c6045 pmd:0feed067
[    2.931917] page:ffff880012f69180 count:39 mapcount:-128 mapping:ffff88000fcbfdc9 index:0x625
[    2.934302] flags: 0x80000080068(uptodate|lru|active|swapbacked)
[    2.936576] page dumped because: bad pte
[    2.937501] addr:0000000000625000 vm_flags:00100073 anon_vma:ffff88000f5ed498 mapping:          (null) index:625
[    2.940062] CPU: 0 PID: 202 Comm: udevd Tainted: G    B          3.18.0-rc4-g3622dcc2 #1477
[    2.942520] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.944001]  ffff88000f4a01f8 ffff88000fedbc28 ffffffff819360c5 0000000000000000
[    2.946229]  0000000000625000 ffff88000fedbc78 ffffffff8114da8a ffff880012f69180
[    2.948384]  0000000000000000 000000000063f000 ffff88000feed128 ffff880012f69180
[    2.950556] Call Trace:
[    2.951224]  [<ffffffff819360c5>] dump_stack+0x4f/0x7c
[    2.952561]  [<ffffffff8114da8a>] print_bad_pte+0x1ba/0x280
[    2.953723]  [<ffffffff8114f063>] unmap_page_range+0x713/0x7c0
[    2.955039]  [<ffffffff8114f164>] unmap_single_vma+0x54/0xd0
[    2.956316]  [<ffffffff8114fc91>] unmap_vmas+0x41/0x60
[    2.957419]  [<ffffffff81158cfc>] exit_mmap+0x8c/0x160
[    2.958646]  [<ffffffff810aa820>] mmput+0x40/0xd0
[    2.959746]  [<ffffffff810af43b>] do_exit+0x31b/0xa40
[    2.960877]  [<ffffffff815153c3>] ? __this_cpu_preempt_check+0x13/0x20
[    2.962281]  [<ffffffff810afbe2>] do_group_exit+0x42/0xc0
[    2.963484]  [<ffffffff810afc6f>] SyS_exit_group+0xf/0x10
[    2.964663]  [<ffffffff8193d93d>] tracesys_phase2+0xd8/0xdd
[    2.966091] BUG: Bad page map in process udevd  pte:80000000020c5045 pmd:0f49d067
[    2.967933] page:ffff880012f69140 count:39 mapcount:-129 mapping:ffff88000fcbfdc9 index:0x61f
[    2.969878] flags: 0x80000080068(uptodate|lru|active|swapbacked)
[    2.971684] page dumped because: bad pte
[    2.972598] addr:000000000061f000 vm_flags:00100073 anon_vma:ffff88000f4a5188 mapping:          (null) index:61f
[    2.974838] CPU: 0 PID: 203 Comm: udevd Tainted: G    B          3.18.0-rc4-g3622dcc2 #1477
[    2.976811] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.978111]  ffff88000feb29d8 ffff880000867c28 ffffffff819360c5 0000000000000000
[    2.980364]  000000000061f000 ffff880000867c78 ffffffff8114da8a ffff880012f69140
[    2.982611]  0000000000000000 000000000063f000 ffff88000f49d0f8 ffff880012f69140
[    2.984865] Call Trace:
[    2.985620]  [<ffffffff819360c5>] dump_stack+0x4f/0x7c
[    2.986824]  [<ffffffff8114da8a>] print_bad_pte+0x1ba/0x280
[    2.988113]  [<ffffffff8114f063>] unmap_page_range+0x713/0x7c0
[    2.989428]  [<ffffffff8114f164>] unmap_single_vma+0x54/0xd0
[    2.990715]  [<ffffffff8114fc91>] unmap_vmas+0x41/0x60
[    2.991913]  [<ffffffff81158cfc>] exit_mmap+0x8c/0x160
[    2.993136]  [<ffffffff810aa820>] mmput+0x40/0xd0
[    2.994274]  [<ffffffff810af43b>] do_exit+0x31b/0xa40
[    2.995465]  [<ffffffff815153c3>] ? __this_cpu_preempt_check+0x13/0x20
[    2.996910]  [<ffffffff810afbe2>] do_group_exit+0x42/0xc0
[    2.998156]  [<ffffffff810afc6f>] SyS_exit_group+0xf/0x10
[    2.999390]  [<ffffffff8193d93d>] tracesys_phase2+0xd8/0xdd
[    3.000690] BUG: Bad page map in process udevd  pte:80000000020c6045 pmd:0f49d067
[    3.002514] page:ffff880012f69180 count:39 mapcount:-129 mapping:ffff88000fcbfdc9 index:0x625
[    3.004534] flags: 0x80000080068(uptodate|lru|active|swapbacked)
[    3.006404] page dumped because: bad pte
[    3.007396] addr:0000000000625000 vm_flags:00100073 anon_vma:ffff88000f4a5188 mapping:          (null) index:625
[    3.009709] CPU: 0 PID: 203 Comm: udevd Tainted: G    B          3.18.0-rc4-g3622dcc2 #1477
[    3.011682] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.012999]  ffff88000feb29d8 ffff880000867c28 ffffffff819360c5 0000000000000000
[    3.015236]  0000000000625000 ffff880000867c78 ffffffff8114da8a ffff880012f69180
[    3.017500]  0000000000000000 000000000063f000 ffff88000f49d128 ffff880012f69180
[    3.019726] Call Trace:
[    3.025162]  [<ffffffff819360c5>] dump_stack+0x4f/0x7c
[    3.026361]  [<ffffffff8114da8a>] print_bad_pte+0x1ba/0x280
[    3.027635]  [<ffffffff8114f063>] unmap_page_range+0x713/0x7c0
[    3.029108]  [<ffffffff8114f164>] unmap_single_vma+0x54/0xd0
[    3.030650]  [<ffffffff8114fc91>] unmap_vmas+0x41/0x60
[    3.032108]  [<ffffffff81158cfc>] exit_mmap+0x8c/0x160
[    3.033563]  [<ffffffff810aa820>] mmput+0x40/0xd0
[    3.034918]  [<ffffffff810af43b>] do_exit+0x31b/0xa40
[    3.036356]  [<ffffffff815153c3>] ? __this_cpu_preempt_check+0x13/0x20
[    3.038062]  [<ffffffff810afbe2>] do_group_exit+0x42/0xc0
[    3.039548]  [<ffffffff810afc6f>] SyS_exit_group+0xf/0x10
[    3.041066]  [<ffffffff8193d93d>] tracesys_phase2+0xd8/0xdd
[    3.042759] BUG: Bad page map in process udevd  pte:80000000020c5045 pmd:0f42d067
[    3.044939] page:ffff880012f69140 count:39 mapcount:-130 mapping:ffff88000fcbfdc9 index:0x61f
[    3.047288] flags: 0x80000080068(uptodate|lru|active|swapbacked)
[    3.049519] page dumped because: bad pte
[    3.050684] addr:000000000061f000 vm_flags:00100073 anon_vma:ffff88000f4bf620 mapping:          (null) index:61f
[    3.053409] CPU: 0 PID: 204 Comm: udevd Tainted: G    B          3.18.0-rc4-g3622dcc2 #1477
[    3.055763] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.057309]  ffff88000f604dc8 ffff88000feb7c28 ffffffff819360c5 0000000000000000
[    3.059963]  000000000061f000 ffff88000feb7c78 ffffffff8114da8a ffff880012f69140
[    3.062398]  0000000000000000 000000000063f000 ffff88000f42d0f8 ffff880012f69140
[    3.064485] Call Trace:
[    3.065168]  [<ffffffff819360c5>] dump_stack+0x4f/0x7c
[    3.066268]  [<ffffffff8114da8a>] print_bad_pte+0x1ba/0x280
[    3.067450]  [<ffffffff8114f063>] unmap_page_range+0x713/0x7c0
[    3.068686]  [<ffffffff8114f164>] unmap_single_vma+0x54/0xd0
[    3.069906]  [<ffffffff8114fc91>] unmap_vmas+0x41/0x60
[    3.071011]  [<ffffffff81158cfc>] exit_mmap+0x8c/0x160
[    3.072134]  [<ffffffff810aa820>] mmput+0x40/0xd0
[    3.073177]  [<ffffffff810af43b>] do_exit+0x31b/0xa40
[    3.074265]  [<ffffffff815153c3>] ? __this_cpu_preempt_check+0x13/0x20
[    3.075584]  [<ffffffff810afbe2>] do_group_exit+0x42/0xc0
[    3.076741]  [<ffffffff810afc6f>] SyS_exit_group+0xf/0x10
[    3.078076]  [<ffffffff8193d93d>] tracesys_phase2+0xd8/0xdd
[    3.079678] BUG: Bad page map in process udevd  pte:80000000020c6045 pmd:0f42d067
[    3.081997] page:ffff880012f69180 count:39 mapcount:-130 mapping:ffff88000fcbfdc9 index:0x625
[    3.084528] flags: 0x80000080068(uptodate|lru|active|swapbacked)
[    3.086633] page dumped because: bad pte
[    3.087631] addr:0000000000625000 vm_flags:00100073 anon_vma:ffff88000f4bf620 mapping:          (null) index:625
[    3.089937] CPU: 0 PID: 204 Comm: udevd Tainted: G    B          3.18.0-rc4-g3622dcc2 #1477
[    3.091915] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.093234]  ffff88000f604dc8 ffff88000feb7c28 ffffffff819360c5 0000000000000000

git bisect start 192495a3a4e9b8caa94cdd6b8200e6c6bf121aac 206c5f60a3d902bc4b56dab2de3e88de5eb06108 --
git bisect good 61a8059d0afcc6b1b0a9c2a966dd62d8783f53ed  # 08:39     20+      0  Merge 'kees/nak/proc-r' into devel-lkp-hsx01-x86_64-201411150620
git bisect  bad 5da0b3a5296b6f5d556aa8e531a2284a15318eac  # 08:52      0-     18  Merge 'kees/x86/pmd-nx' into devel-lkp-hsx01-x86_64-201411150620
git bisect good ac9d677530d3f02a83dbffbca150f95e47f9953e  # 09:16     20+      0  Merge 'kees/nak/tcp-simult' into devel-lkp-hsx01-x86_64-201411150620
git bisect good d3299c8c39943125e642787d34bf34d947eac7b3  # 09:26     20+      0  Merge 'kees/ptdump' into devel-lkp-hsx01-x86_64-201411150620
git bisect good b6044f9cbd7c128ada23e491ec0b1ac365a20eeb  # 09:41     20+      0  Merge 'kees/seccomp/arm64' into devel-lkp-hsx01-x86_64-201411150620
git bisect  bad 3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9  # 09:54      0-      2  x86, mm: set NX across entire PMD at boot
# first bad commit: [3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9] x86, mm: set NX across entire PMD at boot
git bisect good b23dc5a7cc6ebc9a0d57351da7a0e8454c9ffea3  # 09:59     60+      1  Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost
git bisect  bad 192495a3a4e9b8caa94cdd6b8200e6c6bf121aac  # 09:59      0-     14  0day head guard for 'devel-lkp-hsx01-x86_64-201411150620'
git bisect good 56c381f93d57b88a3e667a2f55137947315c17e2  # 10:03     60+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect good d7e5a72b951a4ef6d97b2aa43cad37f237ba8030  # 11:07     60+      1  Add linux-next specific files for 20141114


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang
