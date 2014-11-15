Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaKOKYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 05:24:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:41933 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbaKOKYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 05:24:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,391,1413270000"; 
   d="scan'208";a="637413726"
Date: Sat, 15 Nov 2014 18:24:06 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: [x86, mm] kernel BUG at include/linux/mm.h:548!
Message-ID: <20141115102406.GB6679@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115102225.GA6679@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Kees,

Here is another bisect result.

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
|                                          | b23dc5a7cc | 3622dcc2b4 | 3622dcc2b4 |
+------------------------------------------+------------+------------+------------+
| boot_successes                           | 102        | 3          | 3          |
| boot_failures                            | 1          | 182        | 182        |
| BUG:kernel_boot_hang                     | 1          |            |            |
| kernel_BUG_at_include/linux/mm.h         | 0          | 182        | 182        |
| invalid_opcode                           | 0          | 182        | 182        |
| RIP:__rmqueue                            | 0          | 182        | 182        |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 182        | 182        |
| backtrace:iterate_dir                    | 0          | 1          | 1          |
| backtrace:SyS_getdents                   | 0          | 1          | 1          |
+------------------------------------------+------------+------------+------------+

[    2.033203] flags: 0x80000080068(uptodate|lru|active|swapbacked)
[    2.033347] page dumped because: VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1)
[    2.033347] ------------[ cut here ]------------
[    2.033347] kernel BUG at include/linux/mm.h:548!
[    2.033347] invalid opcode: 0000 [#1] SMP 
[    2.033347] Modules linked in:
[    2.033347] CPU: 0 PID: 284 Comm: udevd Not tainted 3.18.0-rc4-g3622dcc2 #1438
[    2.033347] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.033347] task: ffff8800001022e0 ti: ffff880010bbc000 task.ti: ffff880010bbc000
[    2.033347] RIP: 0010:[<ffffffff811be28e>]  [<ffffffff811be28e>] __rmqueue+0x230/0x770
[    2.033347] RSP: 0000:ffff880010bbf978  EFLAGS: 00010046
[    2.033347] RAX: 0000000000000006 RBX: ffff880012fb4000 RCX: 0000000000000003
[    2.033347] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000046
[    2.033347] RBP: ffff880010bbf9f8 R08: 0000000000000001 R09: 0000000000000000
[    2.033347] R10: ffffffff81b1f800 R11: ffffffff81b1f8c0 R12: ffffffff820d4d80
[    2.033347] R13: ffff880012fb5000 R14: 0000000000000020 R15: ffff880012fb4020
[    2.033347] FS:  00007f5c34ad4700(0000) GS:ffff880013a00000(0000) knlGS:0000000000000000
[    2.033347] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.033347] CR2: 0000000001b80b40 CR3: 0000000010bae000 CR4: 00000000000406b0
[    2.033347] Stack:
[    2.033347]  ffff880010bbf9d8 0000000000000096 0000000000000096 ffffffff820d5078
[    2.033347]  0000000000000006 0000000000000101 ffffffff00000001 0000000000000002
[    2.033347]  0000000000000040 0000000200000000 ffffffff820d6280 ffff880013bd6ec8
[    2.033347] Call Trace:
[    2.033347]  [<ffffffff811beb1d>] get_page_from_freelist+0x34f/0xbde
[    2.033347]  [<ffffffff810415e6>] ? pvclock_clocksource_read+0x12c/0x140
[    2.033347]  [<ffffffff811bf8b7>] __alloc_pages_nodemask+0x2c3/0x1095
[    2.033347]  [<ffffffff811038ed>] ? sched_clock_cpu+0x14d/0x16a
[    2.033347]  [<ffffffff811ee46b>] do_wp_page+0x94b/0x101e
[    2.033347]  [<ffffffff811f088d>] handle_pte_fault+0x7c6/0x833
[    2.033347]  [<ffffffff811f499c>] handle_mm_fault+0x4a0/0x4d2
[    2.033347]  [<ffffffff810466f3>] __do_page_fault+0x867/0xace
[    2.033347]  [<ffffffff811465a7>] ? rcu_eqs_enter_common+0x362/0x371
[    2.033347]  [<ffffffff8114685f>] ? rcu_eqs_exit_common+0xf1/0x326
[    2.033347]  [<ffffffff811466da>] ? rcu_eqs_enter+0x124/0x138
[    2.033347]  [<ffffffff81146bbe>] ? rcu_eqs_exit+0x12a/0x139
[    2.033347]  [<ffffffff81046c61>] trace_do_page_fault+0x1f3/0x25f
[    2.033347]  [<ffffffff8104018a>] do_async_page_fault+0x3a/0x131
[    2.033347]  [<ffffffff818af478>] async_page_fault+0x28/0x30
[    2.033347] Code: 48 83 c0 02 48 ff 04 c5 f8 44 1f 82 44 8a 5d a8 45 84 db 8b 4d a0 4c 8b 55 98 74 11 48 c7 c6 5f a4 f1 81 4c 89 ef e8 e2 a4 02 00 <0f> 0b 41 c7 45 18 80 ff ff ff e9 ec fe ff ff 48 8b 45 b8 49 89 
[    2.033347] RIP  [<ffffffff811be28e>] __rmqueue+0x230/0x770
[    2.033347]  RSP <ffff880010bbf978>
[    2.033347] ---[ end trace 5923814eef589562 ]---
[    2.033347] Kernel panic - not syncing: Fatal exception

git bisect start 3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9 206c5f60a3d902bc4b56dab2de3e88de5eb06108 --
git bisect good 04689e749b7ec156291446028a0ce2e685bf3855  # 08:52     22+      0  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good 6b07974af9698225766d42175470b1a5d7bf9f48  # 11:35     22+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect good 971ad4e4d6833d5f250d0db332ff863c599ae19f  # 11:51     22+      1  Merge branch 'akpm' (fixes from Andrew Morton)
git bisect good 5cf52037042d3ad7432df1aec004a935e83939a6  # 11:51     22+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good b23dc5a7cc6ebc9a0d57351da7a0e8454c9ffea3  # 11:58     22+      1  Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost
# first bad commit: [3622dcc2b4f4eaf23bae2511a30fc449d0e5f0d9] x86, mm: set NX across entire PMD at boot
git bisect good b23dc5a7cc6ebc9a0d57351da7a0e8454c9ffea3  # 12:02     66+      1  Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost
git bisect  bad 192495a3a4e9b8caa94cdd6b8200e6c6bf121aac  # 12:02      0-     36  0day head guard for 'devel-lkp-hsx01-x86_64-201411150620'
git bisect good 56c381f93d57b88a3e667a2f55137947315c17e2  # 12:05     66+      1  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect good d7e5a72b951a4ef6d97b2aa43cad37f237ba8030  # 12:18     66+      0  Add linux-next specific files for 20141114


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
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
