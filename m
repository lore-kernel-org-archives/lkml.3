Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaKOK0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 05:26:39 -0500
Received: from mga14.intel.com ([192.55.52.115]:2930 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaKOK0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 05:26:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,391,1413270000"; 
   d="scan'208";a="622811646"
Date: Sat, 15 Nov 2014 18:26:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: [x86, mm] WARNING: CPU: 0 PID: 1 at arch/x86/mm/pageattr.c:1086
 __cpa_process_fault()
Message-ID: <20141115102633.GC6679@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115102225.GA6679@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

FYI, one more warning message and call trace.

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

+---------------------------------------------------------+------------+------------+------------+
|                                                         | b23dc5a7cc | 3622dcc2b4 | 082b92dbde |
+---------------------------------------------------------+------------+------------+------------+
| boot_successes                                          | 60         | 0          | 0          |
| boot_failures                                           | 0          | 20         | 12         |
| WARNING:at_arch/x86/mm/pageattr.c:__cpa_process_fault() | 0          | 20         | 12         |
| backtrace:set_memory_np                                 | 0          | 20         | 12         |
| backtrace:free_init_pages                               | 0          | 20         | 12         |
| backtrace:mark_rodata_ro                                | 0          | 20         | 12         |
| Kernel_panic-not_syncing:No_working_init_found          | 0          | 0          | 12         |
| backtrace:panic                                         | 0          | 0          | 12         |
+---------------------------------------------------------+------------+------------+------------+

[   16.701884] Write protecting the kernel read-only data: 16384k
[   16.703198] debug: unmapping init [mem 0xffffffff8385d000-0xffffffff839fffff]
[   16.703893] ------------[ cut here ]------------
[   16.704426] WARNING: CPU: 0 PID: 1 at arch/x86/mm/pageattr.c:1086 __cpa_process_fault+0x2be/0x2e3()
[   16.705450] CPA: called for zero pte. vaddr = ffffffff8385d000 cpa->vaddr = ffffffff8385d000
[   16.706259] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4-g3622dcc2 #13
[   16.706965] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.707528]  0000000000000009 ffff88000018bbc8 ffffffff819252f3 ffff88000018bc18
[   16.708301]  0000000000000009 ffff88000018bc08 ffffffff8108806b ffff88000018bc28
[   16.709121]  ffffffff810358fe ffff88000018bdf8 ffffffff8385d000 0000000000000000
[   16.709898] Call Trace:
[   16.710157]  [<ffffffff819252f3>] dump_stack+0x51/0xaa
[   16.710659]  [<ffffffff8108806b>] warn_slowpath_common+0x7c/0x96
[   16.711231]  [<ffffffff810358fe>] ? __cpa_process_fault+0x2be/0x2e3
[   16.711831]  [<ffffffff810880ea>] warn_slowpath_fmt+0x46/0x48
[   16.712398]  [<ffffffff810358fe>] __cpa_process_fault+0x2be/0x2e3
[   16.713001]  [<ffffffff810359d3>] ? lookup_address_in_pgd+0x6e/0xd9
[   16.713608]  [<ffffffff81035c4f>] __change_page_attr_set_clr+0xe0/0x73e
[   16.714264]  [<ffffffff811666db>] ? vm_unmap_aliases+0x169/0x178
[   16.714852]  [<ffffffff8103648e>] change_page_attr_set_clr+0x1e1/0x428
[   16.715476]  [<ffffffff81036804>] change_page_attr_clear+0x21/0x23
[   16.716109]  [<ffffffff81036cd2>] set_memory_np+0x21/0x23
[   16.716620]  [<ffffffff810319e9>] free_init_pages+0xbb/0xca
[   16.717157]  [<ffffffff81032581>] mark_rodata_ro+0xb1/0x125
[   16.717698]  [<ffffffff8191c2ad>] ? rest_init+0xc1/0xc1
[   16.718202]  [<ffffffff8191c2ca>] kernel_init+0x1d/0xda
[   16.718717]  [<ffffffff8193243c>] ret_from_fork+0x7c/0xb0
[   16.719234]  [<ffffffff8191c2ad>] ? rest_init+0xc1/0xc1
[   16.719820] ---[ end trace 98571e0ac619c2b1 ]---
[   16.720325] debug: unmapping init [mem 0xffff880001939000-0xffff8800019fffff]

git bisect start 082b92dbdee2006706aff377ae38d6ceacea91c5 206c5f60a3d902bc4b56dab2de3e88de5eb06108 --
git bisect  bad 156311ecaa588b59a508951a62431e24786e284e  # 12:57      0-      1  Merge 'kees/nak/fw-relative' into devel-snb-smoke-201411151150
git bisect good cbb20c815bbd7b0c37f68ac038ebda2ffe0072d3  # 13:13     20+      0  Merge 'linuxtv-media/master' into devel-snb-smoke-201411151150
git bisect good 00276f48b04f0d099b954197e86f9535d915cf28  # 13:42     20+      0  Merge 'kees/yama/extras' into devel-snb-smoke-201411151150
git bisect  bad 63f537793215742753990ae83f610e578a39d871  # 13:56      0-      1  Merge 'kees/ptdump' into devel-snb-smoke-201411151150
git bisect  bad 86b9e4d12ff4737b3b0b172b6d942ddbbb331fdf  # 14:13      0-      1  Merge 'kees/x86/pmd-nx' into devel-snb-smoke-201411151150
git bisect  bad 3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9  # 14:35      0-      5  x86, mm: set NX across entire PMD at boot
# first bad commit: [3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9] x86, mm: set NX across entire PMD at boot
git bisect good b23dc5a7cc6ebc9a0d57351da7a0e8454c9ffea3  # 14:46     60+      0  Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost
git bisect  bad 082b92dbdee2006706aff377ae38d6ceacea91c5  # 14:46      0-     12  0day head guard for 'devel-snb-smoke-201411151150'
git bisect good 56c381f93d57b88a3e667a2f55137947315c17e2  # 14:50     60+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect good d7e5a72b951a4ef6d97b2aa43cad37f237ba8030  # 14:59     60+      0  Add linux-next specific files for 20141114


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
