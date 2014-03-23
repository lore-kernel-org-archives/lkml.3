Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaCWQ2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 12:28:43 -0400
Received: from www84.your-server.de ([213.133.104.84]:48210 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaCWQ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 12:28:41 -0400
Message-ID: <1395592096.20113.2.camel@vger.seibold.net>
Subject: Re: [x86,vdso32] kernel BUG at mm/swap.c:134!
From: Stefani Seibold <stefani@seibold.net>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Sun, 23 Mar 2014 17:28:16 +0100
In-Reply-To: <20140322114700.GA14326@localhost>
References: <20140322114700.GA14326@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry,

i forgot do adjust the size of get_unmapped_area(). I will send a
incremental patch for this issue.

Thanks
Stefani

Am Samstag, den 22.03.2014, 19:47 +0800 schrieb Fengguang Wu:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
> 
> commit 4e40112c4ff6a577dd06d92b2a54cdf06265bf74
> Author:     Stefani Seibold <stefani@seibold.net>
> AuthorDate: Mon Mar 17 23:22:13 2014 +0100
> Commit:     H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue Mar 18 12:52:54 2014 -0700
> 
>     x86, vdso32: handle 32 bit vDSO larger one page
>     
>     This patch enables 32 bit vDSO which are larger than a page.
>     
>     Signed-off-by: Stefani Seibold <stefani@seibold.net>
>     Link: http://lkml.kernel.org/r/1395094933-14252-14-git-send-email-stefani@seibold.net
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> +----------------------------------------+------------+---------------+
> |                                        | 4e40112c4f | next-20140320 |
> +----------------------------------------+------------+---------------+
> | boot_successes                         | 0          | 0             |
> | boot_failures                          | 21         | 19            |
> | kernel_BUG_at_mm/swap.c                | 21         | 19            |
> | invalid_opcode:PREEMPT_DEBUG_PAGEALLOC | 21         | 19            |
> | EIP_is_at_put_compound_page            | 21         | 19            |
> | backtrace:do_execve                    | 8          | 11            |
> | backtrace:SyS_execve                   | 8          | 11            |
> | backtrace:do_group_exit                | 13         | 8             |
> | backtrace:SyS_exit_group               | 13         | 8             |
> +----------------------------------------+------------+---------------+
> 
> [    9.196432] page:8670b3e8 count:0 mapcount:1 mapping:  (null) index:0x0
> [    9.199071] page flags: 0x40008004(referenced|tail)
> [    9.216380] ------------[ cut here ]------------
> [    9.218008] kernel BUG at mm/swap.c:134!
> [    9.220257] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [    9.222817] Modules linked in:
> [    9.224080] CPU: 0 PID: 69 Comm: init Not tainted 3.14.0-rc7-next-20140320-10753-ga654dc7 #1
> [    9.225460] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    9.225460] task: 7ef39880 ti: 78a02000 task.ti: 78a02000
> [    9.225460] EIP: 0060:[<7907ae36>] EFLAGS: 00010246 CPU: 0
> [    9.225460] EIP is at put_compound_page+0x7d/0x1da
> [    9.225460] EAX: 795143df EBX: 8670b3c0 ECX: 7904b884 EDX: 00000001
> [    9.225460] ESI: 8670b3e8 EDI: ffffffff EBP: 78a03d40 ESP: 78a03d34
> [    9.225460]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    9.225460] CR0: 8005003b CR2: 77bd1f38 CR3: 00a05000 CR4: 000006d0
> [    9.225460] Stack:
> [    9.225460]  8670b3e8 00000000 ffffffff 78a03d78 7907b036 00000001 78a03d64 00000000
> [    9.225460]  000000e1 78a0700c 00000246 00000092 865509a4 8654e26c 78a07000 78a03db0
> [    9.225460]  78a03dc4 78a03d8c 79086cb7 78a03db0 78960280 00000000 78a03d9c 79086cd8
> [    9.225460] Call Trace:
> [    9.225460]  [<7907b036>] release_pages+0x58/0x175
> [    9.225460]  [<79086cb7>] tlb_flush_mmu+0x30/0x45
> [    9.225460]  [<79086cd8>] tlb_finish_mmu+0xc/0x2b
> [    9.225460]  [<7908cab1>] exit_mmap+0x84/0xcb
> [    9.225460]  [<79025a31>] mmput+0x2c/0xb1
> [    9.225460]  [<790a2c79>] flush_old_exec+0x4af/0x564
> [    9.225460]  [<790c3030>] load_elf_binary+0x272/0xb86
> [    9.225460]  [<790a2220>] search_binary_handler+0x5f/0x145
> [    9.225460]  [<790c2c06>] load_script+0x17a/0x183
> [    9.225460]  [<79041c35>] ? sched_clock_cpu+0xaa/0xd3
> [    9.225460]  [<790482bd>] ? lock_release+0x13c/0x19a
> [    9.225460]  [<79311444>] ? _raw_read_unlock+0x27/0x38
> [    9.225460]  [<790a2220>] search_binary_handler+0x5f/0x145
> [    9.225460]  [<790a32eb>] do_execve+0x371/0x47c
> [    9.225460]  [<790a354a>] SyS_execve+0x1c/0x20
> [    9.225460]  [<793154d5>] sysenter_do_call+0x12/0x37
> [    9.225460] Code: 0f 84 a3 00 00 00 89 d8 e8 73 fc ff ff 85 c0 75 0b 31 d2 89 d8 e8 f5 c5 ff ff 0f 0b 8b 46 0c 40 74 0b 31 d2 89 f0 e8 e4 c5 ff ff <0f> 0b 89 d8 e8 e5 fc ff ff 85 c0 0f 84 47 01 00 00 8b 03 a8 80
> [    9.225460] EIP: [<7907ae36>] put_compound_page+0x7d/0x1da SS:ESP 0068:78a03d34
> [    9.379006] ---[ end trace cdeaef9772248ae3 ]---
> 
> git bisect start 016319d375c00db40dac165fcdaec78b67094243 v3.11 --
> git bisect good 843f4f4bb1a2c4c196a1af1d18bb6477a580ac78  # 16:35     21+      0  Merge tag 'trace-fixes-3.13-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
> git bisect good 5a5e75f4714a592f31e57f248b8f5c866f278b8d  # 17:03     21+      0  tile: remove compat_sys_lookup_dcookie declaration to fix compile error
> git bisect good 721f0c126075294e66df73051cc2e1d795ef2095  # 17:46     21+      0  Merge tag 'trace-fixes-v3.14-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
> git bisect good 767a656e0f9139efcdcd0b64fc30e46e82d090b7  # 18:33     21+      0  Merge remote-tracking branch 'f2fs/dev'
> git bisect good 8d5ec484dbbee2784e88974eca3249024e0c2bdd  # 19:13     21+      0  Merge remote-tracking branch 'omap_dss2/for-next'
> git bisect  bad 4b797d758496f2a3142fd52f974587151692e1b2  # 19:49      0-     19  Merge remote-tracking branch 'leds/for-next'
> git bisect good 5535681dc44e2050d9b4e4e756b7a1b47d770d72  # 20:39     21+      0  Merge remote-tracking branch 'dt-rh/for-next'
> git bisect  bad ebcbda16d34470aca469fa93ba1523dcca5ea272  # 21:00      0-      3  Merge remote-tracking branch 'ftrace/for-next'
> git bisect  bad 7bbcbf42f5d85f15ed4f28865e531d4c4984f591  # 21:35      0-      1  Merge remote-tracking branch 'tip/auto-latest'
> git bisect good 8f752c4d5d976feb0640db091687ac5da714bf9a  # 22:06     21+      0  Merge remote-tracking branch 'spi/for-next'
> git bisect good 10c8f975283dc6fe180d3dfd7e27968dcccfb81f  # 22:28     21+      1  Merge branch 'perf/core'
> git bisect good 8061da5dffffc4399df17a517592a5652a3d931c  # 23:06     21+      0  Merge branch 'x86/apic'
> git bisect good f06640d5519dd5f7ee211b530d9a44f5402fb302  # 00:07     21+      0  Merge branch 'x86/debug'
> git bisect good c28087ca73812d93516a06099fe49997a0f8d2c0  # 00:36     21+      0  Merge branch 'x86/mm'
> git bisect good 4dab93cc97ad85b7abbc6b70531b412a3b1d6aa2  # 01:27     21+      0  Merge branch 'x86/threadinfo'
> git bisect good ef721987aef0cc0abba08c88810f2155f76b0b1f  # 01:52     21+      0  x86, vdso: Introduce VVAR marco for vdso32
> git bisect good 008cc907de327d83a0be609cd495fccb0e5dfa4c  # 02:51     21+      0  x86, vdso32: Disable stack protector, adjust optimizations
> git bisect good dce44e03b0a3448ad11ac6c6e0cbe299e0400791  # 04:14     21+      0  compat: Fix sparse address space warnings
> git bisect  bad eb16b5ea273bd7b00f512d7ec3ad6070dd120623  # 04:32      0-     21  Merge branch 'x86/vdso'
> git bisect  bad 4e40112c4ff6a577dd06d92b2a54cdf06265bf74  # 05:45      0-      4  x86, vdso32: handle 32 bit vDSO larger one page
> # first bad commit: [4e40112c4ff6a577dd06d92b2a54cdf06265bf74] x86, vdso32: handle 32 bit vDSO larger one page
> git bisect good 008cc907de327d83a0be609cd495fccb0e5dfa4c  # 05:49     63+      0  x86, vdso32: Disable stack protector, adjust optimizations
> git bisect  bad a654dc797f3ea1cb5719a71a17af35f57fddb2d8  # 05:49      0-     19  Add linux-next specific files for 20140320
> git bisect good 08edb33c4e1b810011f21d7705811b7b9a0535f0  # 06:29     63+     10  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
> git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 06:55      0-      1  Add linux-next specific files for 20140321
> 
> Thanks,
> Fengguang


