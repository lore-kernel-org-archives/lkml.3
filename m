Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab3JHRPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:15:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:44295 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab3JHRPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:15:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1057,1371106800"; 
   d="log'?scan'208";a="407619794"
Date: Wed, 9 Oct 2013 01:15:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>, Jakub Jelinek <jakub@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [x86] BUG: unable to handle kernel NULL pointer dereference at (null)
Message-ID: <20131008171522.GA29277@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I managed to find and bisect down some more different call traces to
the same commit 0c44c2d0f ("x86: Use asm goto to implement better
modify_and_test() functions"). Hope this helps.

The below dmesg chunks represent 25 bad kernel boots.  This is an very
reproducible bug: this kernel has no good boots at all.

The kernel is compiled from 0c44c2d0f with kconfig
i386-randconfig-r8-1005 (attached).  Also attached one full dmesg and
the bisect log.

dmesg-quantal-ant-2:20131009002432:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[   27.865422] ------------[ cut here ]------------
[   27.865982] Kernel BUG at c10563af [verbose debug info unavailable]
[   27.866625] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[   27.867363] Modules linked in:
[   27.867363] CPU: 0 PID: 40 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[   27.867363] task: c6c33420 ti: c6d44000 task.ti: c6d44000
[   27.867363] EIP: 0060:[<c10563af>] EFLAGS: 00000202 CPU: 0
[   27.867363] EIP is at __put_cred+0x2f/0x90
[   27.867363] EAX: c14bb720 EBX: c6d28380 ECX: 00000000 EDX: 00000001
[   27.867363] ESI: c6c33420 EDI: 00000001 EBP: c6d45f24 ESP: c6d45f18
[   27.867363]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   27.867363] CR0: 8005003b CR2: b768d000 CR3: 06d57000 CR4: 000006b0
[   27.867363] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   27.867363] DR6: 00000000 DR7: 00000000
[   27.867363] Stack:
[   27.867363]  c6d27000 c6c336b8 c6c33420 c6d45f30 c110a408 c6d27f00 c6d45f44 c104d499
[   27.867363]  c6c336d0 c6d1c480 c6c33420 c6d45f8c c1031202 c6d44000 c6c33420 c1075fab
[   27.867363]  c6d45f78 00000001 00000100 00000000 00000046 00000030 c6d1c4d0 c6c33420
[   27.867363] Call Trace:
[   27.867363]  [<c110a408>] file_free_rcu+0x28/0x40
[   27.867363]  [<c104d499>] task_work_run+0x79/0xa0
[   27.867363]  [<c1031202>] do_exit+0x2f2/0x950
[   27.867363]  [<c1075fab>] ? trace_hardirqs_off+0xb/0x10
[   27.867363]  [<c10327ea>] do_group_exit+0x4a/0xa0
[   27.867363]  [<c1032858>] SyS_exit_group+0x18/0x20
[   27.867363]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[   27.867363] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[   27.867363] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d45f18
[   27.891948] ---[ end trace f04df4e1fba40cb1 ]---
[   27.892595] Fixing recursive fault but reboot is needed!

dmesg-quantal-ant-9:20131009002506:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[   27.856676] debug: unmapping init [mem 0xc14d7000-0xc151bfff]
[   28.193490] ------------[ cut here ]------------
[   28.194993] WARNING: CPU: 0 PID: 39 at lib/list_debug.c:36 __list_add+0x141/0x180()
[   28.195809] list_add double add: new=c6d1e368, prev=c6d58324, next=c6d1e368.
[   28.196480] Modules linked in:
[   28.197809] CPU: 0 PID: 39 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[   28.199056]  c141a43f c6d43d10 c1301315 c6d43d40 c10304aa c141af68 c6d43d6c 00000027
[   28.201674]  c141a43f 00000024 c11a08c1 c11a08c1 c6d58324 c6d1e368 c6d1e368 c6d43d58
[   28.203312]  c1030503 00000009 c6d43d50 c141af68 c6d43d6c c6d43d8c c11a08c1 c141a43f
[   28.205715] Call Trace:
[   28.206656]  [<c1301315>] dump_stack+0x16/0x18
[   28.208033]  [<c10304aa>] warn_slowpath_common+0x7a/0xa0
[   28.208966]  [<c11a08c1>] ? __list_add+0x141/0x180
[   28.209759]  [<c11a08c1>] ? __list_add+0x141/0x180
[   28.211208]  [<c1030503>] warn_slowpath_fmt+0x33/0x40
[   28.212113]  [<c11a08c1>] __list_add+0x141/0x180
[   28.212949]  [<c11fd745>] tty_add_file+0x35/0x50
[   28.213881]  [<c11ff526>] tty_open+0x1b6/0x7f0
[   28.215102]  [<c110cfae>] chrdev_open+0x6e/0x170
[   28.215897]  [<c110cf40>] ? exact_lock+0x20/0x20
[   28.216694]  [<c1106f31>] do_dentry_open+0x2d1/0x370
[   28.218077]  [<c110cf40>] ? exact_lock+0x20/0x20
[   28.218911]  [<c1107019>] finish_open+0x49/0x60
[   28.219690]  [<c1119308>] do_last.isra.27+0xa88/0x10b0
[   28.221002]  [<c1114d92>] ? link_path_walk+0x122/0x1010
[   28.221890]  [<c1114a0d>] ? path_init+0x34d/0x5b0
[   28.222714]  [<c1119b8c>] path_openat+0x25c/0x770
[   28.223522]  [<c111a774>] do_filp_open+0x34/0xb0
[   28.224851]  [<c110847d>] do_sys_open+0x19d/0x250
[   28.225661]  [<c1307a7e>] ? restore_all+0xf/0xf
[   28.226408]  [<c1108552>] SyS_open+0x22/0x30
[   28.227668]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[   28.228719] ---[ end trace 080224f174f53ed2 ]---
[   52.287137] BUG: soft lockup - CPU#0 stuck for 22s! [modprobe:39]

dmesg-quantal-athens-19:20131009003413:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    1.490835] ------------[ cut here ]------------
[    1.491578] Kernel BUG at c10563af [verbose debug info unavailable]
[    1.492534] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.493063] Modules linked in:
[    1.493063] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    1.493063] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.493063] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    1.493063] EIP is at __put_cred+0x2f/0x90
[    1.493063] EAX: c14bb720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.493063] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.493063]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.493063] CR0: 8005003b CR2: b7756000 CR3: 06d1e000 CR4: 000006b0
[    1.493063] Stack:
[    1.493063]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a408 c006ed00 c6d1bf44 c104d499
[    1.493063]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c1031202 00000000 c6d1bf80 c110a636
[    1.493063]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.493063] Call Trace:
[    1.493063]  [<c110a408>] file_free_rcu+0x28/0x40
[    1.493063]  [<c104d499>] task_work_run+0x79/0xa0
[    1.493063]  [<c1031202>] do_exit+0x2f2/0x950
[    1.493063]  [<c110a636>] ? __fput+0x216/0x380
[    1.493063]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    1.493063]  [<c1032858>] SyS_exit_group+0x18/0x20
[    1.493063]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    1.493063] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    1.493063] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d1bf18
[    1.511493] ---[ end trace d0b4907160520dd2 ]---
[    1.512226] Fixing recursive fault but reboot is needed!

dmesg-quantal-cairo-12:20131009003424:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    1.666630] ------------[ cut here ]------------
[    1.667251] Kernel BUG at c10563af [verbose debug info unavailable]
[    1.668098] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.668885] Modules linked in:
[    1.669147] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    1.669147] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.669147] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    1.669147] EIP is at __put_cred+0x2f/0x90
[    1.669147] EAX: c14bb720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.669147] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.669147]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.669147] CR0: 8005003b CR2: b773d000 CR3: 06d1e000 CR4: 000006b0
[    1.669147] Stack:
[    1.669147]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a408 c006ed00 c6d1bf44 c104d499
[    1.669147]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c1031202 00000000 c6d1bf80 c110a636
[    1.669147]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.669147] Call Trace:
[    1.669147]  [<c110a408>] file_free_rcu+0x28/0x40
[    1.669147]  [<c104d499>] task_work_run+0x79/0xa0
[    1.669147]  [<c1031202>] do_exit+0x2f2/0x950
[    1.669147]  [<c110a636>] ? __fput+0x216/0x380
[    1.669147]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    1.669147]  [<c1032858>] SyS_exit_group+0x18/0x20
[    1.669147]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    1.669147] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    1.669147] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d1bf18
[    1.687323] ---[ end trace 0d9dbb73e2934b28 ]---
[    1.687769] Fixing recursive fault but reboot is needed!

dmesg-quantal-cairo-23:20131009003413:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    1.660398] ------------[ cut here ]------------
[    1.661181] Kernel BUG at c10563af [verbose debug info unavailable]
[    1.662218] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.663116] Modules linked in:
[    1.663358] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    1.663358] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.663358] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    1.663358] EIP is at __put_cred+0x2f/0x90
[    1.663358] EAX: c14bb720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.663358] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.663358]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.663358] CR0: 8005003b CR2: b76ee000 CR3: 06d1e000 CR4: 000006b0
[    1.663358] Stack:
[    1.663358]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a408 c006ed00 c6d1bf44 c104d499
[    1.663358]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c1031202 00000000 c6d1bf80 c110a636
[    1.663358]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.663358] Call Trace:
[    1.663358]  [<c110a408>] file_free_rcu+0x28/0x40
[    1.663358]  [<c104d499>] task_work_run+0x79/0xa0
[    1.663358]  [<c1031202>] do_exit+0x2f2/0x950
[    1.663358]  [<c110a636>] ? __fput+0x216/0x380
[    1.663358]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    1.663358]  [<c1032858>] SyS_exit_group+0x18/0x20
[    1.663358]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    1.663358] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    1.663358] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d1bf18
[    1.688713] ---[ end trace 09588e96c335cb0f ]---
[    1.689507] Fixing recursive fault but reboot is needed!

dmesg-quantal-jaketown-31:20131009003413:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    3.623281] ------------[ cut here ]------------
[    3.624356] Kernel BUG at c10563af [verbose debug info unavailable]
[    3.624356] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    3.624356] Modules linked in:
[    3.624356] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    3.624356] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    3.624356] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    3.624356] EIP is at __put_cred+0x2f/0x90
[    3.624356] EAX: c14bb720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    3.624356] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    3.624356]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    3.624356] CR0: 8005003b CR2: b77db000 CR3: 06d12000 CR4: 000006b0
[    3.624356] Stack:
[    3.624356]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a408 c006ed00 c6d17f44 c104d499
[    3.624356]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c1031202 00000000 c6d17f80 c110a636
[    3.624356]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    3.624356] Call Trace:
[    3.624356]  [<c110a408>] file_free_rcu+0x28/0x40
[    3.624356]  [<c104d499>] task_work_run+0x79/0xa0
[    3.624356]  [<c1031202>] do_exit+0x2f2/0x950
[    3.624356]  [<c110a636>] ? __fput+0x216/0x380
[    3.624356]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    3.624356]  [<c1032858>] SyS_exit_group+0x18/0x20
[    3.624356]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    3.624356] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    3.624356] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d17f18
[    3.698673] ---[ end trace 1b998c263f6d23dd ]---
[    3.700715] Fixing recursive fault but reboot is needed!

dmesg-quantal-lkp-st01-11:20131009003427:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    2.203638] ------------[ cut here ]------------
[    2.204376] Kernel BUG at c10563af [verbose debug info unavailable]
[    2.205357] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.206198] Modules linked in:
[    2.206708] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    2.206795] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    2.206795] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    2.206795] EIP is at __put_cred+0x2f/0x90
[    2.206795] EAX: c14bb720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    2.206795] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    2.206795]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.206795] CR0: 8005003b CR2: b77cc000 CR3: 06d1e000 CR4: 000006b0
[    2.206795] Stack:
[    2.206795]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a408 c006ed00 c6d1bf44 c104d499
[    2.206795]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c1031202 00000000 c6d1bf80 c110a636
[    2.206795]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    2.206795] Call Trace:
[    2.206795]  [<c110a408>] file_free_rcu+0x28/0x40
[    2.206795]  [<c104d499>] task_work_run+0x79/0xa0
[    2.206795]  [<c1031202>] do_exit+0x2f2/0x950
[    2.206795]  [<c110a636>] ? __fput+0x216/0x380
[    2.206795]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    2.206795]  [<c1032858>] SyS_exit_group+0x18/0x20
[    2.206795]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    2.206795] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    2.206795] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d1bf18
[    2.229464] ---[ end trace 923a2748b0895c86 ]---
[    2.230243] Fixing recursive fault but reboot is needed!

dmesg-quantal-lkp-st01-9:20131009003354:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    2.198579] ------------[ cut here ]------------
[    2.199309] Kernel BUG at c10563af [verbose debug info unavailable]
[    2.200292] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.200773] Modules linked in:
[    2.200773] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    2.200773] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    2.200773] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    2.200773] EIP is at __put_cred+0x2f/0x90
[    2.200773] EAX: c14bb720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    2.200773] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    2.200773]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.200773] CR0: 8005003b CR2: b7762000 CR3: 06d1e000 CR4: 000006b0
[    2.200773] Stack:
[    2.200773]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a408 c006ed00 c6d1bf44 c104d499
[    2.200773]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c1031202 00000000 c6d1bf80 c110a636
[    2.200773]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    2.200773] Call Trace:
[    2.200773]  [<c110a408>] file_free_rcu+0x28/0x40
[    2.200773]  [<c104d499>] task_work_run+0x79/0xa0
[    2.200773]  [<c1031202>] do_exit+0x2f2/0x950
[    2.200773]  [<c110a636>] ? __fput+0x216/0x380
[    2.200773]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    2.200773]  [<c1032858>] SyS_exit_group+0x18/0x20
[    2.200773]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    2.200773] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    2.200773] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d1bf18
[    2.224358] ---[ end trace d92dad60f62732f8 ]---
[    2.225080] Fixing recursive fault but reboot is needed!

dmesg-quantal-lkp-tt02-3:20131008150513:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    2.468734] ------------[ cut here ]------------
[    2.469698] Kernel BUG at c10563af [verbose debug info unavailable]
[    2.470992] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.471993] Modules linked in:
[    2.471993] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    2.471993] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    2.471993] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    2.471993] EIP is at __put_cred+0x2f/0x90
[    2.471993] EAX: c14bb720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    2.471993] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    2.471993]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.471993] CR0: 8005003b CR2: b7748000 CR3: 06d12000 CR4: 000006b0
[    2.471993] Stack:
[    2.471993]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a408 c006ed00 c6d17f44 c104d499
[    2.471993]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c1031202 00000000 c6d17f80 c110a636
[    2.471993]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    2.471993] Call Trace:
[    2.471993]  [<c110a408>] file_free_rcu+0x28/0x40
[    2.471993]  [<c104d499>] task_work_run+0x79/0xa0
[    2.471993]  [<c1031202>] do_exit+0x2f2/0x950
[    2.471993]  [<c110a636>] ? __fput+0x216/0x380
[    2.471993]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    2.471993]  [<c1032858>] SyS_exit_group+0x18/0x20
[    2.471993]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    2.471993] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    2.471993] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d17f18
[    2.503251] ---[ end trace 3b2042225c4df31d ]---
[    2.504205] Fixing recursive fault but reboot is needed!

dmesg-quantal-lkp-tt02-7:20131008150522:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    2.428135] ------------[ cut here ]------------
[    2.429119] Kernel BUG at c10563af [verbose debug info unavailable]
[    2.430431] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.431049] Modules linked in:
[    2.431049] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    2.431049] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    2.431049] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    2.431049] EIP is at __put_cred+0x2f/0x90
[    2.431049] EAX: c14bb720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    2.431049] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    2.431049]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.431049] CR0: 8005003b CR2: b7732000 CR3: 06d12000 CR4: 000006b0
[    2.431049] Stack:
[    2.431049]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a408 c006ed00 c6d17f44 c104d499
[    2.431049]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c1031202 00000000 c6d17f80 c110a636
[    2.431049]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    2.431049] Call Trace:
[    2.431049]  [<c110a408>] file_free_rcu+0x28/0x40
[    2.431049]  [<c104d499>] task_work_run+0x79/0xa0
[    2.431049]  [<c1031202>] do_exit+0x2f2/0x950
[    2.431049]  [<c110a636>] ? __fput+0x216/0x380
[    2.431049]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    2.431049]  [<c1032858>] SyS_exit_group+0x18/0x20
[    2.431049]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    2.431049] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    2.431049] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d17f18
[    2.470717] ---[ end trace 49b1330184d07147 ]---
[    2.472096] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-10:20131009003411:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    2.004517] ------------[ cut here ]------------
[    2.005444] Kernel BUG at c10563af [verbose debug info unavailable]
[    2.006199] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.006199] Modules linked in:
[    2.006199] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    2.006199] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    2.006199] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    2.006199] EIP is at __put_cred+0x2f/0x90
[    2.006199] EAX: c14bb720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    2.006199] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    2.006199]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.006199] CR0: 8005003b CR2: b7751000 CR3: 06d1e000 CR4: 000006b0
[    2.006199] Stack:
[    2.006199]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a408 c006ed00 c6d1bf44 c104d499
[    2.006199]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c1031202 00000000 c6d1bf80 c110a636
[    2.006199]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    2.006199] Call Trace:
[    2.006199]  [<c110a408>] file_free_rcu+0x28/0x40
[    2.006199]  [<c104d499>] task_work_run+0x79/0xa0
[    2.006199]  [<c1031202>] do_exit+0x2f2/0x950
[    2.006199]  [<c110a636>] ? __fput+0x216/0x380
[    2.006199]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    2.006199]  [<c1032858>] SyS_exit_group+0x18/0x20
[    2.006199]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    2.006199] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    2.006199] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d1bf18
[    2.035701] ---[ end trace 7c659a37d71008c4 ]---
[    2.036575] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-14:20131009003352:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    1.873594] ------------[ cut here ]------------
[    1.874449] Kernel BUG at c10563af [verbose debug info unavailable]
[    1.875562] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.876517] Modules linked in:
[    1.876825] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    1.876825] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.876825] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    1.876825] EIP is at __put_cred+0x2f/0x90
[    1.876825] EAX: c14bb720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.876825] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.876825]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.876825] CR0: 8005003b CR2: b775c000 CR3: 06d1e000 CR4: 000006b0
[    1.876825] Stack:
[    1.876825]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a408 c006ed00 c6d1bf44 c104d499
[    1.876825]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c1031202 00000000 c6d1bf80 c110a636
[    1.876825]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.876825] Call Trace:
[    1.876825]  [<c110a408>] file_free_rcu+0x28/0x40
[    1.876825]  [<c104d499>] task_work_run+0x79/0xa0
[    1.876825]  [<c1031202>] do_exit+0x2f2/0x950
[    1.876825]  [<c110a636>] ? __fput+0x216/0x380
[    1.876825]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    1.876825]  [<c1032858>] SyS_exit_group+0x18/0x20
[    1.876825]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    1.876825] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    1.876825] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d1bf18
[    1.904117] ---[ end trace 751354922a6f111b ]---
[    1.904956] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-5:20131009003359:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    1.939202] ------------[ cut here ]------------
[    1.940093] Kernel BUG at c10563af [verbose debug info unavailable]
[    1.940937] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.940937] Modules linked in:
[    1.940937] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    1.940937] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.940937] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    1.940937] EIP is at __put_cred+0x2f/0x90
[    1.940937] EAX: c14bb720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.940937] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.940937]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.940937] CR0: 8005003b CR2: b7751000 CR3: 06d1e000 CR4: 000006b0
[    1.940937] Stack:
[    1.940937]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a408 c006ed00 c6d1bf44 c104d499
[    1.940937]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c1031202 00000000 c6d1bf80 c110a636
[    1.940937]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.940937] Call Trace:
[    1.940937]  [<c110a408>] file_free_rcu+0x28/0x40
[    1.940937]  [<c104d499>] task_work_run+0x79/0xa0
[    1.940937]  [<c1031202>] do_exit+0x2f2/0x950
[    1.940937]  [<c110a636>] ? __fput+0x216/0x380
[    1.940937]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    1.940937]  [<c1032858>] SyS_exit_group+0x18/0x20
[    1.940937]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    1.940937] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    1.940937] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d1bf18
[    1.968415] ---[ end trace 8c5056fc7a63be1b ]---
[    1.969230] Fixing recursive fault but reboot is needed!

dmesg-quantal-stoakley-7:20131009003427:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    2.027904] ------------[ cut here ]------------
[    2.028164] Kernel BUG at c10563af [verbose debug info unavailable]
[    2.028164] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.028164] Modules linked in:
[    2.028164] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    2.028164] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    2.028164] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    2.028164] EIP is at __put_cred+0x2f/0x90
[    2.028164] EAX: c14bb720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    2.028164] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    2.028164]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.028164] CR0: 8005003b CR2: b77af000 CR3: 06d1e000 CR4: 000006b0
[    2.028164] Stack:
[    2.028164]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a408 c006ed00 c6d1bf44 c104d499
[    2.028164]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c1031202 00000000 c6d1bf80 c110a636
[    2.028164]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    2.028164] Call Trace:
[    2.028164]  [<c110a408>] file_free_rcu+0x28/0x40
[    2.028164]  [<c104d499>] task_work_run+0x79/0xa0
[    2.028164]  [<c1031202>] do_exit+0x2f2/0x950
[    2.028164]  [<c110a636>] ? __fput+0x216/0x380
[    2.028164]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    2.028164]  [<c1032858>] SyS_exit_group+0x18/0x20
[    2.028164]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    2.028164] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    2.028164] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d1bf18
[    2.050744] ---[ end trace 2e535460ae08e2e8 ]---
[    2.051392] Fixing recursive fault but reboot is needed!

dmesg-quantal-waimea-10:20131009083054:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    0.933170] ------------[ cut here ]------------
[    0.933702] Kernel BUG at c10563af [verbose debug info unavailable]
[    0.934452] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.934728] Modules linked in:
[    0.934728] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    0.934728] task: c6c322c0 ti: c6d2a000 task.ti: c6d2a000
[    0.934728] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    0.934728] EIP is at __put_cred+0x2f/0x90
[    0.934728] EAX: c14bb720 EBX: c6d17400 ECX: 00000000 EDX: 00000001
[    0.934728] ESI: c6c322c0 EDI: 00000001 EBP: c6d2bf24 ESP: c6d2bf18
[    0.934728]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.934728] CR0: 8005003b CR2: b7793000 CR3: 06d19000 CR4: 000006b0
[    0.934728] Stack:
[    0.934728]  c006ee00 c6c32558 c6c322c0 c6d2bf30 c110a408 c006ed00 c6d2bf44 c104d499
[    0.934728]  c6c32570 c6d2c000 c6c322c0 c6d2bf8c c1031202 00000000 c6d2bf80 c110a636
[    0.934728]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d2c050 c6c322c0
[    0.934728] Call Trace:
[    0.934728]  [<c110a408>] file_free_rcu+0x28/0x40
[    0.934728]  [<c104d499>] task_work_run+0x79/0xa0
[    0.934728]  [<c1031202>] do_exit+0x2f2/0x950
[    0.934728]  [<c110a636>] ? __fput+0x216/0x380
[    0.934728]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    0.934728]  [<c1032858>] SyS_exit_group+0x18/0x20
[    0.934728]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    0.934728] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    0.934728] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d2bf18
[    0.952083] ---[ end trace e034291e60bada3a ]---
[    0.952608] Fixing recursive fault but reboot is needed!

dmesg-quantal-xian-31:20131009003413:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    1.615252] ------------[ cut here ]------------
[    1.616087] Kernel BUG at c10563af [verbose debug info unavailable]
[    1.617129] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.618032] Modules linked in:
[    1.618136] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    1.618136] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.618136] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    1.618136] EIP is at __put_cred+0x2f/0x90
[    1.618136] EAX: c14bb720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.618136] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.618136]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.618136] CR0: 8005003b CR2: b775f000 CR3: 06d1e000 CR4: 000006b0
[    1.618136] Stack:
[    1.618136]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a408 c006ed00 c6d1bf44 c104d499
[    1.618136]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c1031202 00000000 c6d1bf80 c110a636
[    1.618136]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.618136] Call Trace:
[    1.618136]  [<c110a408>] file_free_rcu+0x28/0x40
[    1.618136]  [<c104d499>] task_work_run+0x79/0xa0
[    1.618136]  [<c1031202>] do_exit+0x2f2/0x950
[    1.618136]  [<c110a636>] ? __fput+0x216/0x380
[    1.618136]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    1.618136]  [<c1032858>] SyS_exit_group+0x18/0x20
[    1.618136]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    1.618136] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    1.618136] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d1bf18
[    1.640485] ---[ end trace 544ba4c9cb172e4b ]---
[    1.641182] Fixing recursive fault but reboot is needed!

dmesg-quantal-xian-43:20131009003355:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

[    1.638354] ------------[ cut here ]------------
[    1.639150] Kernel BUG at c10563af [verbose debug info unavailable]
[    1.639256] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.639256] Modules linked in:
[    1.639256] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    1.639256] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.639256] EIP: 0060:[<c10563af>] EFLAGS: 00010202 CPU: 0
[    1.639256] EIP is at __put_cred+0x2f/0x90
[    1.639256] EAX: c14bb720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.639256] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.639256]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.639256] CR0: 8005003b CR2: b77ac000 CR3: 06d1e000 CR4: 000006b0
[    1.639256] Stack:
[    1.639256]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a408 c006ed00 c6d1bf44 c104d499
[    1.639256]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c1031202 00000000 c6d1bf80 c110a636
[    1.639256]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.639256] Call Trace:
[    1.639256]  [<c110a408>] file_free_rcu+0x28/0x40
[    1.639256]  [<c104d499>] task_work_run+0x79/0xa0
[    1.639256]  [<c1031202>] do_exit+0x2f2/0x950
[    1.639256]  [<c110a636>] ? __fput+0x216/0x380
[    1.639256]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    1.639256]  [<c1032858>] SyS_exit_group+0x18/0x20
[    1.639256]  [<c130ee30>] sysenter_do_call+0x12/0x3c
[    1.639256] Code: 56 53 e8 35 8f 2b 00 89 c3 8b 00 8b 03 85 c0 0f 95 c0 25 ff 00 00 00 89 c6 31 c9 89 c2 b8 34 b7 4b c1 e8 25 1a 05 00 85 f6 74 02 <0f> 0b 8b 35 88 d7 46 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7
[    1.639256] EIP: [<c10563af>] __put_cred+0x2f/0x90 SS:ESP 0068:c6d1bf18
[    1.665505] ---[ end trace 0e638a59e536f317 ]---
[    1.666366] Fixing recursive fault but reboot is needed!

dmesg-yocto-lkp-tt02-2:20131008145515:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391


mount: mounting proc on /proc failed: No such device
[    0.997823] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.999402] IP: [<  (null)>]   (null)
[    1.000224] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    1.000712] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    1.000712] Modules linked in:
[    1.000712] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    1.000712] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    1.000712] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    1.000712] EIP is at 0x0
[    1.000712] EAX: cd0dc500 EBX: cd0dce00 ECX: 00000000 EDX: cd0dc500
[    1.000712] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    1.000712]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.000712] CR0: 8005003b CR2: 00000000 CR3: 0d102000 CR4: 000006b0
[    1.000712] Stack:
[    1.000712]  c104d499 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c1031202 00000000 00000000
[    1.000712]  cee9d000 00000035 00000001 cd10bf88 c1109351 00000001 00000000 cd0d6a50
[    1.000712]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ea
[    1.000712] Call Trace:
[    1.000712]  [<c104d499>] ? task_work_run+0x79/0xa0
[    1.000712]  [<c1031202>] do_exit+0x2f2/0x950
[    1.000712]  [<c1109351>] ? vfs_write+0x161/0x1a0
[    1.000712]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    1.000712]  [<c1032858>] SyS_exit_group+0x18/0x20
[    1.000712]  [<c1307a45>] syscall_call+0x7/0xb
[    1.000712] Code:  Bad EIP value.
[    1.000712] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10bf34
[    1.000712] CR2: 0000000000000000

dmesg-yocto-nhm4-1:20131008162924:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391


mount: mounting proc on /proc failed: No such device
[    0.441443] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.442048] IP: [<c110a470>] __fput+0x50/0x380
[    0.442432] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.442928] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.443319] Modules linked in:
[    0.443524] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    0.443524] Workqueue: events delayed_fput
[    0.443524] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.443524] EIP: 0060:[<c110a470>] EFLAGS: 00010212 CPU: 0
[    0.443524] EIP is at __fput+0x50/0x380
[    0.443524] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.443524] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.443524]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.443524] CR0: 8005003b CR2: 00000000 CR3: 0d10b000 CR4: 000006b0
[    0.443524] Stack:
[    0.443524]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.443524]  00000000 c0124540 ce867ea4 c110a7c9 c148d640 ce867efc c1048fb9 00000000
[    0.443524]  00000002 00000000 c1048f81 00000000 00000000 00000000 0019ebc7 c0083400
[    0.443524] Call Trace:
[    0.443524]  [<c110a7c9>] delayed_fput+0x29/0x30
[    0.443524]  [<c1048fb9>] process_one_work+0x2f9/0x650
[    0.443524]  [<c1048f81>] ? process_one_work+0x2c1/0x650
[    0.443524]  [<c104a8ef>] worker_thread+0x28f/0x610
[    0.443524]  [<c104a660>] ? cancel_delayed_work_sync+0x20/0x20
[    0.443524]  [<c1050902>] kthread+0x92/0xa0
[    0.443524]  [<c130ed9b>] ret_from_kernel_thread+0x1b/0x30
[    0.443524]  [<c1050870>] ? kthread_create_on_node+0xd0/0xd0
[    0.443524] Code: 00 b8 ad 5e 41 c1 e8 b0 fe f4 ff e8 fb b1 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.443524] EIP: [<c110a470>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.443524] CR2: 0000000000000000
[    0.456633] ---[ end trace 904c44bc0abd3aee ]---
[    0.460187] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6d00 with usage -1

dmesg-yocto-snb-38:20131009002344:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391


mount: mounting proc on /proc failed: No such device
[    0.918117] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.919547] IP: [<  (null)>]   (null)
[    0.919794] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.919794] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    0.919794] Modules linked in:
[    0.919794] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    0.919794] task: cd7cbcd0 ti: cd10e000 task.ti: cd10e000
[    0.919794] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    0.919794] EIP is at 0x0
[    0.919794] EAX: cd0e3500 EBX: cd0e3e00 ECX: 00000000 EDX: cd0e3500
[    0.919794] ESI: cd7cbf68 EDI: cd7cbcd0 EBP: cd10ff44 ESP: cd10ff34
[    0.919794]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.919794] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.919794] Stack:
[    0.919794]  c104d499 cd7cbf80 cd0daa00 cd7cbcd0 cd10ff8c c1031202 00000000 00000000
[    0.919794]  cee9d000 00000035 00000001 cd10ff88 c1109351 00000001 00000000 cd0daa50
[    0.919794]  cd7cbcd0 080d3208 cd10ff9c 0000ff00 cd0ee600 cd7cbcd0 cd10ffa4 c10327ea
[    0.919794] Call Trace:
[    0.919794]  [<c104d499>] ? task_work_run+0x79/0xa0
[    0.919794]  [<c1031202>] do_exit+0x2f2/0x950
[    0.919794]  [<c1109351>] ? vfs_write+0x161/0x1a0
[    0.919794]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    0.919794]  [<c1032858>] SyS_exit_group+0x18/0x20
[    0.919794]  [<c1307a45>] syscall_call+0x7/0xb
[    0.919794] Code:  Bad EIP value.
[    0.919794] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10ff34
[    0.919794] CR2: 0000000000000000

dmesg-yocto-snb-43:20131009002416:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391


mount: mounting proc on /proc failed: No such device
[    0.873183] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.874508] IP: [<  (null)>]   (null)
[    0.874688] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.874688] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    0.874688] Modules linked in:
[    0.874688] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    0.874688] task: cd7cbcd0 ti: cd10e000 task.ti: cd10e000
[    0.874688] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    0.874688] EIP is at 0x0
[    0.874688] EAX: cd0e3100 EBX: cd0e3e00 ECX: 00000000 EDX: cd0e3100
[    0.874688] ESI: cd7cbf68 EDI: cd7cbcd0 EBP: cd10ff44 ESP: cd10ff34
[    0.874688]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.874688] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.874688] Stack:
[    0.874688]  c104d499 cd7cbf80 cd0daa00 cd7cbcd0 cd10ff8c c1031202 00000000 00000000
[    0.874688]  cee9d000 00000035 00000001 cd10ff88 c1109351 00000001 00000000 cd0daa50
[    0.874688]  cd7cbcd0 080d3208 cd10ff9c 0000ff00 cd0ee600 cd7cbcd0 cd10ffa4 c10327ea
[    0.874688] Call Trace:
[    0.874688]  [<c104d499>] ? task_work_run+0x79/0xa0
[    0.874688]  [<c1031202>] do_exit+0x2f2/0x950
[    0.874688]  [<c1109351>] ? vfs_write+0x161/0x1a0
[    0.874688]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    0.874688]  [<c1032858>] SyS_exit_group+0x18/0x20
[    0.874688]  [<c1307a45>] syscall_call+0x7/0xb
[    0.874688] Code:  Bad EIP value.
[    0.874688] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10ff34
[    0.874688] CR2: 0000000000000000

dmesg-yocto-stoakley-3:20131009002418:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391

mount: mounting proc on /proc failed: No such device
[    0.831874] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    0.832409] BUG: unable to handle kernel paging request at cd0e3a08
[    0.832409] IP: [<cd0e3a08>] 0xcd0e3a07
[    0.832409] *pdpt = 000000000151c001 *pde = 000000000fbfc067 *pte = 800000000d0e3163 
[    0.832409] Oops: 0011 [#1] DEBUG_PAGEALLOC
[    0.832409] Modules linked in:
[    0.832409] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    0.832409] task: cd7cbcd0 ti: cd10e000 task.ti: cd10e000
[    0.832409] EIP: 0060:[<cd0e3a08>] EFLAGS: 00010246 CPU: 0
[    0.832409] EIP is at 0xcd0e3a08
[    0.832409] EAX: cd0e3a00 EBX: cd0e3800 ECX: 00000000 EDX: cd0e3a00
[    0.832409] ESI: cd7cbf68 EDI: cd7cbcd0 EBP: cd10ff44 ESP: cd10ff34
[    0.832409]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.832409] CR0: 8005003b CR2: cd0e3a08 CR3: 0d10a000 CR4: 000006b0
[    0.832409] Stack:
[    0.832409]  c104d499 cd7cbf80 cd0daa00 cd7cbcd0 cd10ff8c c1031202 00000000 00000000
[    0.832409]  cee9d000 00000035 00000001 cd10ff88 c1109351 00000001 00000000 cd0daa50
[    0.832409]  cd7cbcd0 080d3208 cd10ff9c 0000ff00 cd0ee600 cd7cbcd0 cd10ffa4 c10327ea
[    0.832409] Call Trace:
[    0.832409]  [<c104d499>] ? task_work_run+0x79/0xa0
[    0.832409]  [<c1031202>] do_exit+0x2f2/0x950
[    0.832409]  [<c1109351>] ? vfs_write+0x161/0x1a0
[    0.832409]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    0.832409]  [<c1032858>] SyS_exit_group+0x18/0x20
[    0.832409]  [<c1307a45>] syscall_call+0x7/0xb
[    0.832409] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0e cd 08 3a 0e cd <20> 00 00 00 4c 3a 0e cd 44 3a 0e cd 48 3a 0e cd 01 00 00 00 ad
[    0.832409] EIP: [<cd0e3a08>] 0xcd0e3a08 SS:ESP 0068:cd10ff34
[    0.832409] CR2: 00000000cd0e3a08

dmesg-yocto-stoakley-4:20131009002412:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391


mount: mounting proc on /proc failed: No such device
[    0.840034] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.841074] IP: [<  (null)>]   (null)
[    0.841610] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.841824] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    0.841824] Modules linked in:
[    0.841824] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    0.841824] task: cd7cbcd0 ti: cd10e000 task.ti: cd10e000
[    0.841824] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    0.841824] EIP is at 0x0
[    0.841824] EAX: cd0e3100 EBX: cd0e3e00 ECX: 00000000 EDX: cd0e3100
[    0.841824] ESI: cd7cbf68 EDI: cd7cbcd0 EBP: cd10ff44 ESP: cd10ff34
[    0.841824]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.841824] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.841824] Stack:
[    0.841824]  c104d499 cd7cbf80 cd0daa00 cd7cbcd0 cd10ff8c c1031202 00000000 00000000
[    0.841824]  cee9d000 00000035 00000001 cd10ff88 c1109351 00000001 00000000 cd0daa50
[    0.841824]  cd7cbcd0 080d3208 cd10ff9c 0000ff00 cd0ee600 cd7cbcd0 cd10ffa4 c10327ea
[    0.841824] Call Trace:
[    0.841824]  [<c104d499>] ? task_work_run+0x79/0xa0
[    0.841824]  [<c1031202>] do_exit+0x2f2/0x950
[    0.841824]  [<c1109351>] ? vfs_write+0x161/0x1a0
[    0.841824]  [<c10327ea>] do_group_exit+0x4a/0xa0
[    0.841824]  [<c1032858>] SyS_exit_group+0x18/0x20
[    0.841824]  [<c1307a45>] syscall_call+0x7/0xb
[    0.841824] Code:  Bad EIP value.
[    0.841824] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10ff34
[    0.841824] CR2: 0000000000000000

dmesg-yocto-xian-45:20131009002407:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391


mount: mounting proc on /proc failed: No such device
[    0.780760] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.781899] IP: [<c110a470>] __fput+0x50/0x380
[    0.782253] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.782253] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.782253] Modules linked in:
[    0.782253] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    0.782253] Workqueue: events delayed_fput
[    0.782253] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.782253] EIP: 0060:[<c110a470>] EFLAGS: 00010212 CPU: 0
[    0.782253] EIP is at __fput+0x50/0x380
[    0.782253] EAX: 00000000 EBX: cd0e3700 ECX: 00000000 EDX: 0000001d
[    0.782253] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.782253]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.782253] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.782253] Stack:
[    0.782253]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.782253]  00000000 c0124540 ce867ea4 c110a7c9 c148d640 ce867efc c1048fb9 00000000
[    0.782253]  00000002 00000000 c1048f81 00000000 00000000 00000000 0019ebc7 c0083400
[    0.782253] Call Trace:
[    0.782253]  [<c110a7c9>] delayed_fput+0x29/0x30
[    0.782253]  [<c1048fb9>] process_one_work+0x2f9/0x650
[    0.782253]  [<c1048f81>] ? process_one_work+0x2c1/0x650
[    0.782253]  [<c104a8ef>] worker_thread+0x28f/0x610
[    0.782253]  [<c104a660>] ? cancel_delayed_work_sync+0x20/0x20
[    0.782253]  [<c1050902>] kthread+0x92/0xa0
[    0.782253]  [<c130ed9b>] ret_from_kernel_thread+0x1b/0x30
[    0.782253]  [<c1050870>] ? kthread_create_on_node+0xd0/0xd0
[    0.782253] Code: 00 b8 ad 5e 41 c1 e8 b0 fe f4 ff e8 fb b1 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.782253] EIP: [<c110a470>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.782253] CR2: 0000000000000000
[    0.810230] ---[ end trace 30f0c5539123580d ]---
[    0.815604] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c00 with usage -1

dmesg-yocto-xps-4:20131009081942:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:391


mount: mounting proc on /proc failed: No such device
[    0.510689] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.511333] IP: [<c110a470>] __fput+0x50/0x380
[    0.511670] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.511670] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.511670] Modules linked in:
[    0.511670] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #391
[    0.511670] Workqueue: events delayed_fput
[    0.511670] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.511670] EIP: 0060:[<c110a470>] EFLAGS: 00010212 CPU: 0
[    0.511670] EIP is at __fput+0x50/0x380
[    0.511670] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.511670] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.511670]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.511670] CR0: 8005003b CR2: 00000000 CR3: 0d10b000 CR4: 000006b0
[    0.511670] Stack:
[    0.511670]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.511670]  00000000 c0124540 ce867ea4 c110a7c9 c148d640 ce867efc c1048fb9 00000000
[    0.511670]  00000002 00000000 c1048f81 00000000 00000000 00000000 0019ebc7 c0083400
[    0.511670] Call Trace:
[    0.511670]  [<c110a7c9>] delayed_fput+0x29/0x30
[    0.511670]  [<c1048fb9>] process_one_work+0x2f9/0x650
[    0.511670]  [<c1048f81>] ? process_one_work+0x2c1/0x650
[    0.511670]  [<c104a8ef>] worker_thread+0x28f/0x610
[    0.511670]  [<c104a660>] ? cancel_delayed_work_sync+0x20/0x20
[    0.511670]  [<c1050902>] kthread+0x92/0xa0
[    0.511670]  [<c130ed9b>] ret_from_kernel_thread+0x1b/0x30
[    0.511670]  [<c1050870>] ? kthread_create_on_node+0xd0/0xd0
[    0.511670] Code: 00 b8 ad 5e 41 c1 e8 b0 fe f4 ff e8 fb b1 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.511670] EIP: [<c110a470>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.511670] CR2: 0000000000000000
[    0.526608] ---[ end trace 490bc283e6fc34f9 ]---
[    0.530504] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6d00 with usage -1

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-waimea-12:20131005100755:i386-randconfig-r8-1005:3.12.0-rc1-00080-gfb869b6:3"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc1-00080-gfb869b6 (kbuild@roam) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #3 Sat Oct 5 02:03:33 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
[    0.000000] BRK [0x01a68000, 0x01a68fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
[    0.000000] BRK [0x01a69000, 0x01a69fff] PGTABLE
[    0.000000] BRK [0x01a6a000, 0x01a6afff] PGTABLE
[    0.000000] BRK [0x01a6b000, 0x01a6bfff] PGTABLE
[    0.000000] BRK [0x01a6c000, 0x01a6cfff] PGTABLE
[    0.000000] BRK [0x01a6d000, 0x01a6dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128140(97%)
[    0.000000] RAMDISK: [mem 0x0fce4000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat c14b2620, node_mem_map cf=
116028
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1474dc0
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64796
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-r8-1005/tip:sched:core/.vmli=
nuz-fb869b6e91a3ac235f237f73305ecf34cdc4969b-20131005020535-7-waimea branch=
=3Dtip/sched/core BOOT_IMAGE=3D/kernel/i386-randconfig-r8-1005/fb869b6e91a3=
ac235f237f73305ecf34cdc4969b/vmlinuz-3.12.0-rc1-00080-gfb869b6
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 236440K/261744K available (3126K kernel code, 483K r=
wdata, 1340K rodata, 276K init, 5360K bss, 25304K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xfffe0000   ( 759 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc14d7000 - 0xc151c000   ( 276 kB)
[    0.000000]       .data : 0xc130deeb - 0xc14d6d80   (1827 kB)
[    0.000000]       .text : 0xc1000000 - 0xc130deeb   (3127 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1, =
Nodes=3D1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dc0092000 soft=3Dc0094000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3300.306 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 6603.63 Bogo=
MIPS (lpj=3D11001020)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006767] Security Framework initialized
[    0.007507] Mount-cache hash table entries: 512
[    0.008917] Initializing cgroup subsys perf_event
[    0.010111] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010111] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010111] tlb_flushall_shift: 6
[    0.012382] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.016756] ACPI: Core revision 20130725
[    0.019536] ACPI: All ACPI Tables successfully acquired
[    0.020070] ACPI: setting ELCR to 0200 (from 0c00)
[    0.021099] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.024712] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.026494] devtmpfs: initialized
[    0.028604] NET: Registered protocol family 16
[    0.030424] cpuidle: using governor menu
[    0.031358] ACPI: bus type PCI registered
[    0.032213] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.033343] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.034394] PCI: Using configuration type 1 for base access
[    0.036933] ACPI: Added _OSI(Module Device)
[    0.037662] ACPI: Added _OSI(Processor Device)
[    0.038412] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.039175] ACPI: Added _OSI(Processor Aggregator Device)
[    0.041960] ACPI: EC: Look up EC in DSDT
[    0.047666] ACPI: Interpreter enabled
[    0.048314] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    0.049875] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    0.050997] ACPI: (supports S0 S3 S5)
[    0.051659] ACPI: Using PIC for interrupt routing
[    0.052462] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.064708] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.065800] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.067063] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.069226] PCI host bridge to bus 0000:00
[    0.070010] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.070970] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.072028] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.073342] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.074515] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.075809] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.077477] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.080306] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.084600] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.087433] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.089022] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.090023] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.091697] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.094262] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.096680] pci 0000:00:02.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.105427] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.107193] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.109483] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.111200] pci 0000:00:03.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.119021] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.120565] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.122782] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.124536] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.132418] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.133801] pci 0000:00:05.0: [8086:2668] type 00 class 0x040300
[    0.135553] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe3fff]
[    0.141546] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.143969] pci 0000:00:06.0: reg 0x10: [io  0xc040-0xc07f]
[    0.146130] pci 0000:00:06.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.153978] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.156676] pci 0000:00:07.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.158850] pci 0000:00:07.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.167031] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.169322] pci 0000:00:08.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.171198] pci 0000:00:08.0: reg 0x14: [mem 0xfebe8000-0xfebe8fff]
[    0.179067] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.181264] pci 0000:00:09.0: reg 0x10: [io  0xc100-0xc13f]
[    0.183923] pci 0000:00:09.0: reg 0x14: [mem 0xfebe9000-0xfebe9fff]
[    0.191204] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.193962] pci 0000:00:0a.0: reg 0x10: [io  0xc140-0xc17f]
[    0.196088] pci 0000:00:0a.0: reg 0x14: [mem 0xfebea000-0xfebeafff]
[    0.203931] pci 0000:00:0b.0: [1af4:1001] type 00 class 0x010000
[    0.206247] pci 0000:00:0b.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.207886] pci 0000:00:0b.0: reg 0x14: [mem 0xfebeb000-0xfebebfff]
[    0.217014] pci 0000:00:0c.0: [8086:25ab] type 00 class 0x088000
[    0.218686] pci 0000:00:0c.0: reg 0x10: [mem 0xfebec000-0xfebec00f]
[    0.224248] pci_bus 0000:00: on NUMA node 0
[    0.226198] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.227195] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.228508] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.230431] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.231642] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.233735] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.234634] ACPI: \_SB_.PCI0: notify handler is installed
[    0.235681] Found 1 acpi root devices
[    0.236929] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.238337] vgaarb: loaded
[    0.238792] vgaarb: bridge control possible 0000:00:02.0
[    0.239743] Linux video capture interface: v2.00
[    0.240059] pps_core: LinuxPPS API ver. 1 registered
[    0.240916] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.242453] PTP clock support registered
[    0.243360] Advanced Linux Sound Architecture Driver Initialized.
[    0.244393] PCI: Using ACPI for IRQ routing
[    0.245115] PCI: pci_cache_line_size set to 64 bytes
[    0.246915] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.247938] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.249650] Switched to clocksource kvm-clock
[    0.249650] Warning: could not register annotated branches stats
[    0.279761] pnp: PnP ACPI init
[    0.280537] ACPI: bus type PNP registered
[    0.281440] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.282691] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.284052] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.285318] pnp 00:03: [dma 2]
[    0.285897] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.287363] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.288638] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.290215] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.291742] pnp: PnP ACPI: found 7 devices
[    0.292512] ACPI: bus type PNP unregistered
[    0.328748] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.329477] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.330217] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.331102] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.331884] NET: Registered protocol family 1
[    0.332469] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.333247] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.334215] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.335009] pci 0000:00:02.0: Boot video device
[    0.335714] PCI: CLS 0 bytes, default 64
[    0.336428] Unpacking initramfs...
[    0.418851] debug: unmapping init [mem 0xcfce4000-0xcffeffff]
[    0.429840] DMA-API: preallocated 65536 debug entries
[    0.430688] DMA-API: debugging enabled by kernel config
[    0.431849] NatSemi SCx200 Driver
[    0.441526] Kprobe smoke test started
[    0.446157] Kprobe smoke test passed successfully
[    0.446981] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.449475] VFS: Disk quotas dquot_6.5.2
[    0.449991] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.451502] msgmni has been set to 461
[    0.453078] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    0.453808] crc32: self tests passed, processed 225944 bytes in 140080 n=
sec
[    0.454811] crc32c: CRC_LE_BITS =3D 64
[    0.455233] crc32c: self tests passed, processed 225944 bytes in 70577 n=
sec
[    0.456243] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    0.457313] ACPI: Power Button [PWRF]
[    0.470521] HDLC line discipline maxframe=3D4096
[    0.471032] N_HDLC line discipline registered.
[    0.471552] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.496002] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    0.498202] ppdev: user-space parallel port driver
[    0.498806] nsc_gpio initializing
[    0.499252] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    0.499937] parport_pc 00:04: reported by Plug and Play ACPI
[    0.500929] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    0.502381] dummy-irq: no IRQ given.  Use irq=3DN
[    0.503148] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    0.504890] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.505526] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.566411] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    0.568218] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    0.569267] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    0.570847] mk712: device not present
[    0.571307] IR RC5 (streamzap) protocol handler initialized
[    0.571995] IR SANYO protocol handler initialized
[    0.572571] IR MCE Keyboard/mouse protocol handler initialized
[    0.573271] Registered IR keymap rc-empty
[    0.574096] input: rc-core loopback device as /devices/virtual/rc/rc0/in=
put2
[    0.574952] evbug: Connected device: input2 (rc-core loopback device at =
rc-core/virtual)
[    0.576008] rc0: rc-core loopback device as /devices/virtual/rc/rc0
[    0.577332] input: MCE IR Keyboard/Mouse (rc-loopback) as /devices/virtu=
al/input/input3
[    0.578314] evbug: Connected device: input3 (MCE IR Keyboard/Mouse (rc-l=
oopback) at /input0)
[    0.579429] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    0.580504] hdaps: supported laptop not found!
[    0.581019] hdaps: driver init failed (ret=3D-19)!
[    0.582029] IMA: No TPM chip found, activating TPM-bypass!
[    0.583512] ALSA device list:
[    0.584010]   No soundcards found.
[    0.585252] debug: unmapping init [mem 0xc14d7000-0xc151bfff]

mount: mounting proc on /proc failed: No such device
[    0.594703] BUG: unable to handle kernel NULL pointer dereference at   (=
null)
[    0.595687] IP: [<c11098e0>] __fput+0x50/0x380
[    0.596233] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
[    0.596926] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.596926] Modules linked in:
[    0.596926] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-0008=
0-gfb869b6 #3
[    0.596926] Workqueue: events delayed_fput
[    0.596926] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.596926] EIP: 0060:[<c11098e0>] EFLAGS: 00010212 CPU: 0
[    0.596926] EIP is at __fput+0x50/0x380
[    0.596926] EAX: 00000000 EBX: cd0e3600 ECX: 00000000 EDX: 0000001d
[    0.596926] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.596926]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.596926] CR0: 8005003b CR2: 00000000 CR3: 0d10b000 CR4: 000006b0
[    0.596926] Stack:
[    0.596926]  00000246 00000000 00000002 00000000 00000000 00000000 00000=
000 00000000
[    0.596926]  00000000 c0124540 ce867ea4 c1109c39 c148d640 ce867efc c1048=
c59 00000000
[    0.596926]  00000002 00000000 c1048c21 00000000 00000000 00000000 0019d=
ab7 c0083400
[    0.596926] Call Trace:
[    0.596926]  [<c1109c39>] delayed_fput+0x29/0x30
[    0.596926]  [<c1048c59>] process_one_work+0x2f9/0x640
[    0.596926]  [<c1048c21>] ? process_one_work+0x2c1/0x640
[    0.596926]  [<c104a57f>] worker_thread+0x28f/0x610
[    0.596926]  [<c104a2f0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.596926]  [<c1050522>] kthread+0x92/0xa0
[    0.596926]  [<c130cf7b>] ret_from_kernel_thread+0x1b/0x30
[    0.596926]  [<c1050490>] ? kthread_create_on_node+0xd0/0xd0
[    0.596926] Code: 00 b8 48 31 41 c1 e8 f0 05 f5 ff e8 5b a1 1f 00 8b 43 =
10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 =
<8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.596926] EIP: [<c11098e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.596926] CR2: 0000000000000000
[    0.617953] ---[ end trace 03381f1a63e10aed ]---
[    0.622129] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6d=
00 with usage -1
[    0.622129]=20
[    0.623278] Rebooting in 10 seconds..
BUG: kernel boot oops
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
8-1005/fb869b6e91a3ac235f237f73305ecf34cdc4969b/vmlinuz-3.12.0-rc1-00080-gf=
b869b6 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log=
_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk=
 sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200=
 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-=
queue/kvm/i386-randconfig-r8-1005/tip:sched:core/.vmlinuz-fb869b6e91a3ac235=
f237f73305ecf34cdc4969b-20131005020535-7-waimea branch=3Dtip/sched/core BOO=
T_IMAGE=3D/kernel/i386-randconfig-r8-1005/fb869b6e91a3ac235f237f73305ecf34c=
dc4969b/vmlinuz-3.12.0-rc1-00080-gfb869b6'  -initrd /kernel-tests/initrd/yo=
cto-minimal-i386.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00=
:00:00,model=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::8316-:22 -net nic,v=
lan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watch=
dog i6300esb -soundhw hda -drive file=3D/fs/LABEL=3DKVM/disk0-yocto-waimea-=
12,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yocto-waime=
a-12,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yocto-wai=
mea-12,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-w=
aimea-12,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto=
-waimea-12,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yoc=
to-waimea-12,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-wai=
mea-12 -serial file:/dev/shm/kboot/serial-yocto-waimea-12 -daemonize -displ=
ay none -monitor null=20

--y0ulUmNC+osPPQO6
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-fb869b6e91a3ac235f237f73305ecf34cdc4969b-i386-randconfig-r8-1005-BUG:-unable-to-handle-kernel-18490.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDgxNjQzNGVjNGE2NzRmY2RiM2MyMjIxYTZkZmZkYzhmMzQwMjA1NTAK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZmI4NjliNi4uLiBzY2hlZC93YWl0OiBDbGVh
biB1cCB3YWl0LmggZGV0YWlscyBhIGJpdApIRUFEIGlzIG5vdyBhdCA4MTY0MzRlLi4uIE1l
cmdlIGJyYW5jaCAneDg2LXNwaW5sb2Nrcy1mb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90aXAvdGlwCmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjgtMTAwNS90aXA6c2NoZWQ6
Y29yZTo4MTY0MzRlYzRhNjc0ZmNkYjNjMjIyMWE2ZGZmZGM4ZjM0MDIwNTUwOmJpc2VjdC1u
ZXQKCjIwMTMtMTAtMDgtMjI6NTk6MTYgODE2NDM0ZWM0YTY3NGZjZGIzYzIyMjFhNmRmZmRj
OGYzNDAyMDU1MCBjb21waWxpbmcKNDc4IHJlYWwgIDY1OSB1c2VyICA2OCBzeXMgIDE1Mi4w
NiUgY3B1IAlpMzg2LXJhbmRjb25maWctcjgtMTAwNQoKMjAxMy0xMC0wOC0yMzowOToyNyBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtMDMxMjAtZzgxNjQzNGUuLgkyMAkyNSBTVUND
RVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDgxNjQzNGVjNGE2NzRmY2RiM2MyMjIxYTZkZmZk
YzhmMzQwMjA1NTAKZ2l0IGJpc2VjdCBzdGFydCBmYjg2OWI2ZTkxYTNhYzIzNWYyMzdmNzMz
MDVlY2YzNGNkYzQ5NjliIDgxNjQzNGVjNGE2NzRmY2RiM2MyMjIxYTZkZmZkYzhmMzQwMjA1
NTAgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgODE2NDM0ZS4uLiBNZXJnZSBicmFu
Y2ggJ3g4Ni1zcGlubG9ja3MtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApTd2l0Y2hlZCB0byBicmFuY2ggJ21h
c3RlcicKWW91ciBicmFuY2ggaXMgYmVoaW5kICdvcmlnaW4vbWFzdGVyJyBieSA0MTIxMyBj
b21taXRzLCBhbmQgY2FuIGJlIGZhc3QtZm9yd2FyZGVkLgogICh1c2UgImdpdCBwdWxsIiB0
byB1cGRhdGUgeW91ciBsb2NhbCBicmFuY2gpCkJpc2VjdGluZzogMzQ5MyByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpClszOWVkYTJhYmE2
YmU2NDJiNzFmMmUwYWQ2MjNkY2IwOWZkOWQ3OWNmXSBNZXJnZSBicmFuY2ggJ25leHQnIG9m
IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9iZW5oL3Bv
d2VycGMKZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXI4LTEwMDUvdGlwOnNjaGVkOmNvcmU6MzllZGEyYWJhNmJlNjQyYjcxZjJlMGFkNjIzZGNi
MDlmZDlkNzljZjpiaXNlY3QtbmV0CgoyMDEzLTEwLTA4LTIzOjExOjU0IDM5ZWRhMmFiYTZi
ZTY0MmI3MWYyZTBhZDYyM2RjYjA5ZmQ5ZDc5Y2YgY29tcGlsaW5nCjUyMCByZWFsICA2NjAg
dXNlciAgNzEgc3lzICAxNDAuNzclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUKCjIw
MTMtMTAtMDgtMjM6MjQ6MzcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLTA2NzM5LWcz
OWVkYTJhLi4JNgkyNC4uLi4uLgkyNSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE3NjggcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbZjNhZDg1
N2UzZGExYWJhZWE3ODBkYzg5MmI1OTJjZDg2YzU0MWM1Ml0gbmV0X3NjaGVkOiBodGI6IGZp
eCBhIHR5cG8gaW4gaHRiX2NoYW5nZV9jbGFzcygpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yOC0x
MDA1L3RpcDpzY2hlZDpjb3JlOmYzYWQ4NTdlM2RhMWFiYWVhNzgwZGM4OTJiNTkyY2Q4NmM1
NDFjNTI6YmlzZWN0LW5ldAoKMjAxMy0xMC0wOC0yMzozMDowOSBmM2FkODU3ZTNkYTFhYmFl
YTc4MGRjODkyYjU5MmNkODZjNTQxYzUyIGNvbXBpbGluZwoyMDcgcmVhbCAgNjQ4IHVzZXIg
IDY2IHN5cyAgMzQ1LjE4JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yOC0xMDA1CgoyMDEzLTEw
LTA4LTIzOjM0OjExIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC0wODQ2NC1nZjNhZDg1
Ny4uCTgJMjMJMjQJMjUgU1VDQ0VTUwoKQmlzZWN0aW5nOiA4ODQgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbN2M5OTNlMTFhYTU5ZDlk
MWNlZmJkNmFjYzhkODRmMmQ4ZDQ2NTQ1YV0gcmJ0cmVlOiBhbGxvdyB0ZXN0cyB0byBydW4g
YXMgYnVpbHRpbgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjgtMTAwNS90aXA6c2NoZWQ6Y29yZTo3
Yzk5M2UxMWFhNTlkOWQxY2VmYmQ2YWNjOGQ4NGYyZDhkNDY1NDVhOmJpc2VjdC1uZXQKCjIw
MTMtMTAtMDgtMjM6Mzc6MTQgN2M5OTNlMTFhYTU5ZDlkMWNlZmJkNmFjYzhkODRmMmQ4ZDQ2
NTQ1YSBjb21waWxpbmcKMTAyIHJlYWwgIDY1MyB1c2VyICA2NSBzeXMgIDcwMi4wNCUgY3B1
IAlpMzg2LXJhbmRjb25maWctcjgtMTAwNQoKMjAxMy0xMC0wOC0yMzozOToxOCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjExLjAtMDkzMTctZzdjOTkzZTEuLgkxMAkxNQkyMAkyMwkyNSBT
VUNDRVNTCgpCaXNlY3Rpbmc6IDQ1NCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgOSBzdGVwcykKWzNjYzY5YjYzOGUxMWJmZGE1ZDAxM2MyYjc1YjYwOTM0
YWEwZTg4YTFdIE1lcmdlIHRhZyAnZml4ZXMtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYXJtL2FybS1zb2MKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9u
ZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLXI4LTEwMDUvdGlwOnNjaGVkOmNvcmU6M2NjNjliNjM4ZTExYmZkYTVkMDEz
YzJiNzViNjA5MzRhYTBlODhhMTpiaXNlY3QtbmV0CgoyMDEzLTEwLTA4LTIzOjQyOjUxIDNj
YzY5YjYzOGUxMWJmZGE1ZDAxM2MyYjc1YjYwOTM0YWEwZTg4YTEgY29tcGlsaW5nCjIxNCBy
ZWFsICA2NTMgdXNlciAgNjcgc3lzICAzMzUuMzAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI4
LTEwMDUKCjIwMTMtMTAtMDgtMjM6NDc6MDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4w
LTA5Nzc4LWczY2M2OWI2Li4uCTIzCTI0CTI1IFNVQ0NFU1MKCkJpc2VjdGluZzogMjI3IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbMTgz
YzQyMDMyM2E5ZTQ1YWYwZDk5NWQ3Y2JmNDE2MjIxNjk4Y2JlNF0gTWVyZ2UgYnJhbmNoICdr
Y29uZmlnJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvbW1hcmVrL2tidWlsZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjgtMTAwNS90aXA6c2NoZWQ6
Y29yZToxODNjNDIwMzIzYTllNDVhZjBkOTk1ZDdjYmY0MTYyMjE2OThjYmU0OmJpc2VjdC1u
ZXQKCjIwMTMtMTAtMDgtMjM6NTA6MDQgMTgzYzQyMDMyM2E5ZTQ1YWYwZDk5NWQ3Y2JmNDE2
MjIxNjk4Y2JlNCBjb21waWxpbmcKOTMgcmVhbCAgNTg0IHVzZXIgIDU3IHN5cyAgNjg0Ljkz
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yOC0xMDA1CgoyMDEzLTEwLTA4LTIzOjUyOjIxIGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTEuMC0xMDAwNS1nMTgzYzQyMC4uCTIzCTI0Li4JMjUg
U1VDQ0VTUwoKQmlzZWN0aW5nOiAxMDcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDcgc3RlcHMpCltjZDYxOWUyMWVhNDY4YjAyYWY5ZWVlZDc1ZWFlMjMw
N2VjN2RlMWNiXSBNZXJnZSBicmFuY2ggJ2Zvcl9saW51cycgb2YgZ2l0Oi8vY2F2YW4uY29k
b24ub3JnLnVrL3BsYXRmb3JtLWRyaXZlcnMteDg2CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yOC0x
MDA1L3RpcDpzY2hlZDpjb3JlOmNkNjE5ZTIxZWE0NjhiMDJhZjllZWVkNzVlYWUyMzA3ZWM3
ZGUxY2I6YmlzZWN0LW5ldAoKMjAxMy0xMC0wOC0yMzo1NTo1MiBjZDYxOWUyMWVhNDY4YjAy
YWY5ZWVlZDc1ZWFlMjMwN2VjN2RlMWNiIGNvbXBpbGluZwo5NSByZWFsICA2MjggdXNlciAg
NjMgc3lzICA3MjIuOTYlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUKCjIwMTMtMTAt
MDgtMjM6NTg6MTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLTEwMTI1LWdjZDYxOWUy
Li4uCTE1CTIxCTI1IFNVQ0NFU1MKCkJpc2VjdGluZzogNTIgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpCls2MmQyMjhiOGM2NzYyMzJlY2E1
NzlmOTFjYzA3ODJiMDYwYTU5MDk3XSBNZXJnZSBicmFuY2ggJ2ZpeGVzJyBvZiBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL3ZpcnQva3ZtL2t2bQpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
cjgtMTAwNS90aXA6c2NoZWQ6Y29yZTo2MmQyMjhiOGM2NzYyMzJlY2E1NzlmOTFjYzA3ODJi
MDYwYTU5MDk3OmJpc2VjdC1uZXQKCjIwMTMtMTAtMDktMDA6MDE6MTYgNjJkMjI4YjhjNjc2
MjMyZWNhNTc5ZjkxY2MwNzgyYjA2MGE1OTA5NyBjb21waWxpbmcKMjggcmVhbCAgODEgdXNl
ciAgMTcgc3lzICAzNDcuMjUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUKCjIwMTMt
MTAtMDktMDA6MDE6NTggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMS0wMDAyNy1n
NjJkMjI4Yi4uCTE2CTI1IFNVQ0NFU1MKCkJpc2VjdGluZzogMjYgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCltlYTgxMTc0Nzg5MThhNDcz
NDU4NmQzNWZmNTMwNzIxYjY4MjQyNWJlXSBzY2hlZCwgaWRsZTogRml4IHRoZSBpZGxlIHBv
bGxpbmcgc3RhdGUgbG9naWMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvdGlwOnNjaGVk
OmNvcmU6ZWE4MTE3NDc4OTE4YTQ3MzQ1ODZkMzVmZjUzMDcyMWI2ODI0MjViZTpiaXNlY3Qt
bmV0CgoyMDEzLTEwLTA5LTAwOjAzOjU4IGVhODExNzQ3ODkxOGE0NzM0NTg2ZDM1ZmY1MzA3
MjFiNjgyNDI1YmUgY29tcGlsaW5nCjEwMyByZWFsICA2NTggdXNlciAgNjcgc3lzICA2OTcu
ODYlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUKCjIwMTMtMTAtMDktMDA6MDU6NTcg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMS0wMDA1My1nZWE4MTE3NC4gVEVTVCBG
QUlMVVJFCgptb3VudDogbW91bnRpbmcgcHJvYyBvbiAvcHJvYyBmYWlsZWQ6IE5vIHN1Y2gg
ZGV2aWNlClsgICAgMC43ODcyNjNdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVM
TCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgKG51bGwpClsgICAgMC43ODg0MjldIElQOiBb
PGMxMTBhNTIwPl0gX19mcHV0KzB4NTAvMHgzODAKWyAgICAwLjc4OTEyM10gKnBkcHQgPSAw
MDAwMDAwMDAwMDAwMDAwICpwZGUgPSBmMDAwZmY1M2YwMDBmZjUzIApbICAgIDAuNzg5NDkx
XSBPb3BzOiAwMDAwIFsjMV0gREVCVUdfUEFHRUFMTE9DClsgICAgMC43ODk0OTFdIE1vZHVs
ZXMgbGlua2VkIGluOgpbICAgIDAuNzg5NDkxXSBDUFU6IDAgUElEOiAxMiBDb21tOiBrd29y
a2VyLzA6MSBOb3QgdGFpbnRlZCAzLjEyLjAtcmMxLTAwMDUzLWdlYTgxMTc0ICMzODYKWyAg
ICAwLjc4OTQ5MV0gV29ya3F1ZXVlOiBldmVudHMgZGVsYXllZF9mcHV0ClsgICAgMC43ODk0
OTFdIHRhc2s6IGMwMDM1ZjkwIHRpOiBjZTg2NjAwMCB0YXNrLnRpOiBjZTg2NjAwMApbICAg
IDAuNzg5NDkxXSBFSVA6IDAwNjA6WzxjMTEwYTUyMD5dIEVGTEFHUzogMDAwMTAyMTIgQ1BV
OiAwClsgICAgMC43ODk0OTFdIEVJUCBpcyBhdCBfX2ZwdXQrMHg1MC8weDM4MApbICAgIDAu
Nzg5NDkxXSBFQVg6IDAwMDAwMDAwIEVCWDogY2QwZTM2MDAgRUNYOiAwMDAwMDAwMCBFRFg6
IDAwMDAwMDFkClsgICAgMC43ODk0OTFdIEVTSTogMDAwMDAwMTAgRURJOiAwMDAwMDAwMCBF
QlA6IGNlODY3ZTk4IEVTUDogY2U4NjdlNzAKWyAgICAwLjc4OTQ5MV0gIERTOiAwMDdiIEVT
OiAwMDdiIEZTOiAwMDAwIEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMC43ODk0OTFdIENSMDog
ODAwNTAwM2IgQ1IyOiAwMDAwMDAwMCBDUjM6IDBkMTBhMDAwIENSNDogMDAwMDA2YjAKWyAg
ICAwLjc4OTQ5MV0gU3RhY2s6ClsgICAgMC43ODk0OTFdICAwMDAwMDI0NiAwMDAwMDAwMCAw
MDAwMDAwMiAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMApb
ICAgIDAuNzg5NDkxXSAgMDAwMDAwMDAgYzAxMjQ1NDAgY2U4NjdlYTQgYzExMGE4NzkgYzE0
OGQ2NDAgY2U4NjdlZmMgYzEwNDhmYjkgMDAwMDAwMDAKWyAgICAwLjc4OTQ5MV0gIDAwMDAw
MDAyIDAwMDAwMDAwIGMxMDQ4ZjgxIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMTll
Yzc3IGMwMDgzNDAwClsgICAgMC43ODk0OTFdIENhbGwgVHJhY2U6ClsgICAgMC43ODk0OTFd
ICBbPGMxMTBhODc5Pl0gZGVsYXllZF9mcHV0KzB4MjkvMHgzMApbICAgIDAuNzg5NDkxXSAg
WzxjMTA0OGZiOT5dIHByb2Nlc3Nfb25lX3dvcmsrMHgyZjkvMHg2NTAKWyAgICAwLjc4OTQ5
MV0gIFs8YzEwNDhmODE+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHgyYzEvMHg2NTAKWyAgICAw
Ljc4OTQ5MV0gIFs8YzEwNGE4ZWY+XSB3b3JrZXJfdGhyZWFkKzB4MjhmLzB4NjEwClsgICAg
MC43ODk0OTFdICBbPGMxMDRhNjYwPl0gPyBjYW5jZWxfZGVsYXllZF93b3JrX3N5bmMrMHgy
MC8weDIwClsgICAgMC43ODk0OTFdICBbPGMxMDUwOTAyPl0ga3RocmVhZCsweDkyLzB4YTAK
WyAgICAwLjc4OTQ5MV0gIFs8YzEzMGVkZGI+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4
MWIvMHgzMApbICAgIDAuNzg5NDkxXSAgWzxjMTA1MDg3MD5dID8ga3RocmVhZF9jcmVhdGVf
b25fbm9kZSsweGQwLzB4ZDAKWyAgICAwLjc4OTQ5MV0gQ29kZTogMDAgYjggMGQgNWYgNDEg
YzEgZTggMDAgZmUgZjQgZmYgZTggOGIgYjEgMWYgMDAgOGIgNDMgMTAgODkgYzEgODkgNDUg
ZTggOGIgNTMgNDAgODkgZDAgODMgZTAgMDIgODMgZjggMDEgMTkgZjYgODMgZTYgMDggODMg
YzYgMDggPDhiPiAwMSAyNSAwMCBmMCBmZiBmZiA2NiAzZCAwMCA0MCAwZiA4NCAyZiAwMiAw
MCAwMCA4MSBlMiAwMCAwMApbICAgIDAuNzg5NDkxXSBFSVA6IFs8YzExMGE1MjA+XSBfX2Zw
dXQrMHg1MC8weDM4MCBTUzpFU1AgMDA2ODpjZTg2N2U3MApbICAgIDAuNzg5NDkxXSBDUjI6
IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjgxNjY2Ml0gLS0tWyBlbmQgdHJhY2UgMzM0Zjc1
ZjAwOGU0NWRjMSBdLS0tClsgICAgMC44MjI4MjVdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5j
aW5nOiBDUkVEOiBwdXRfY3JlZF9yY3UoKSBzZWVzIGNkMGM2YzgwIHdpdGggdXNhZ2UgLTEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS9lYTgxMTc0Nzg5MThhNDczNDU4NmQz
NWZmNTMwNzIxYjY4MjQyNWJlL2RtZXNnLXlvY3RvLXhpYW4tMTM6MjAxMzEwMDkwMDA2MDk6
aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjMS0wMDA1My1nZWE4MTE3NDozODYK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS9lYTgxMTc0Nzg5MThhNDczNDU4NmQz
NWZmNTMwNzIxYjY4MjQyNWJlL2RtZXNnLXlvY3RvLXN0b2FrbGV5LTE6MjAxMzEwMDkwMDA2
MTI6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjMS0wMDA1My1nZWE4MTE3NDoz
ODYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS9lYTgxMTc0Nzg5MThhNDczNDU4
NmQzNWZmNTMwNzIxYjY4MjQyNWJlL2RtZXNnLXlvY3RvLXhpYW4tMjY6MjAxMzEwMDkwMDA2
MTI6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjMS0wMDA1My1nZWE4MTE3NDoz
ODYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS9lYTgxMTc0Nzg5MThhNDczNDU4
NmQzNWZmNTMwNzIxYjY4MjQyNWJlL2RtZXNnLXlvY3RvLWNhaXJvLTMxOjIwMTMxMDA5MDAw
NjE2OmkzODYtcmFuZGNvbmZpZy1yOC0xMDA1OjMuMTIuMC1yYzEtMDAwNTMtZ2VhODExNzQ6
Mzg2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvZWE4MTE3NDc4OTE4YTQ3MzQ1
ODZkMzVmZjUzMDcyMWI2ODI0MjViZS9kbWVzZy15b2N0by13YWltZWEtODoyMDEzMTAwOTA4
MDMwMjppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmMxLTAwMDUzLWdlYTgxMTc0
OjM4Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1L2VhODExNzQ3ODkxOGE0NzM0
NTg2ZDM1ZmY1MzA3MjFiNjgyNDI1YmUvZG1lc2cteW9jdG8teGlhbi00MjoyMDEzMTAwOTAw
MDYxOTppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmMxLTAwMDUzLWdlYTgxMTc0
OjM4NgowOjY6NiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAxNCBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzdl
MzExNWVmNTE0OWZjNTAyZTNhMmU4MDcxOWRiYTU0YThlNzQwOWRdIHNjaGVkL2JhbGFuY2lu
ZzogRml4IGNmc19ycS0+dGFza19oX2xvYWQgY2FsY3VsYXRpb24KcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLXI4LTEwMDUvdGlwOnNjaGVkOmNvcmU6N2UzMTE1ZWY1MTQ5ZmM1MDJlM2EyZTgwNzE5
ZGJhNTRhOGU3NDA5ZDpiaXNlY3QtbmV0CgoyMDEzLTEwLTA5LTAwOjA2OjI5IDdlMzExNWVm
NTE0OWZjNTAyZTNhMmU4MDcxOWRiYTU0YThlNzQwOWQgY29tcGlsaW5nCjEwOCByZWFsICA2
NTQgdXNlciAgNjYgc3lzICA2NjYuMDQlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUK
CjIwMTMtMTAtMDktMDA6MDg6MzAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMS0w
MDAzOC1nN2UzMTE1ZS4uCTIwCTI1IFNVQ0NFU1MKCkJpc2VjdGluZzogNyByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzdhZmYyZTNhNTZi
NzI0Yjc5ZmEyZDVhYmQxMGQ4MjMxZWY4ZmIwYzVdIHNjaGVkL2JhbGFuY2luZzogUHJldmVu
dCB0aGUgcmVzZWxlY3Rpb24gb2YgYSBwcmV2aW91cyBlbnYuZHN0X2NwdSBpZiBzb21lIHRh
c2tzIGFyZSBwaW5uZWQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvdGlwOnNjaGVkOmNv
cmU6N2FmZjJlM2E1NmI3MjRiNzlmYTJkNWFiZDEwZDgyMzFlZjhmYjBjNTpiaXNlY3QtbmV0
CgoyMDEzLTEwLTA5LTAwOjEwOjMxIDdhZmYyZTNhNTZiNzI0Yjc5ZmEyZDVhYmQxMGQ4MjMx
ZWY4ZmIwYzUgY29tcGlsaW5nCjI5IHJlYWwgIDc5IHVzZXIgIDE2IHN5cyAgMzE5Ljk1JSBj
cHUgCWkzODYtcmFuZGNvbmZpZy1yOC0xMDA1CgoyMDEzLTEwLTA5LTAwOjExOjE1IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAwNDUtZzdhZmYyZTMuLgkzCTI0CTI1IFNV
Q0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMiBzdGVwcykKWzQzMTQ4OTUxNjU2MjM4Nzk5MzdmNDZkNzY3NjczNjU0NjYy
YjU3MGNdIHNjaGVkOiBNaWNyby1vcHRpbWl6ZSBieSBkcm9wcGluZyB1bm5lY2Vzc2FyeSB0
YXNrX3JxKCkgY2FsbHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvdGlwOnNjaGVkOmNv
cmU6NDMxNDg5NTE2NTYyMzg3OTkzN2Y0NmQ3Njc2NzM2NTQ2NjJiNTcwYzpiaXNlY3QtbmV0
CgoyMDEzLTEwLTA5LTAwOjEzOjQ1IDQzMTQ4OTUxNjU2MjM4Nzk5MzdmNDZkNzY3NjczNjU0
NjYyYjU3MGMgY29tcGlsaW5nCjEwNiByZWFsICA2NDQgdXNlciAgNjYgc3lzICA2NjYuNjcl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUKCjIwMTMtMTAtMDktMDA6MTU6NDUgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMS0wMDA0OS1nNDMxNDg5NS4uCTEJNQkxNQky
MwkyNAkyNSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbYjAyMWZlM2UyNTA5NGZiZWMyMmQwZWZmODQ2
ZDJhZGVlZTFiOTczNl0gc2NoZWQsIHJjdTogTWFrZSBSQ1UgdXNlIHJlc2NoZWRfY3B1KCkK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9o
b21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvdGlwOnNjaGVkOmNvcmU6YjAyMWZlM2UyNTA5
NGZiZWMyMmQwZWZmODQ2ZDJhZGVlZTFiOTczNjpiaXNlY3QtbmV0CgoyMDEzLTEwLTA5LTAw
OjE5OjQ2IGIwMjFmZTNlMjUwOTRmYmVjMjJkMGVmZjg0NmQyYWRlZWUxYjk3MzYgY29tcGls
aW5nCjk5IHJlYWwgIDY1NyB1c2VyICA2NiBzeXMgIDcyOS42NiUgY3B1IAlpMzg2LXJhbmRj
b25maWctcjgtMTAwNQoKMjAxMy0xMC0wOS0wMDoyMTozOCBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAzLjEyLjAtcmMxLTAwMDUxLWdiMDIxZmUzLi4gVEVTVCBGQUlMVVJFCgptb3VudDogbW91
bnRpbmcgcHJvYyBvbiAvcHJvYyBmYWlsZWQ6IE5vIHN1Y2ggZGV2aWNlClsgICAgOC45Mzg5
OTFdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJl
bmNlIGF0ICAgKG51bGwpClsgICAgOC45Mzk4MzJdIElQOiBbPCAgKG51bGwpPl0gICAobnVs
bCkKWyAgICA4LjkzOTgzMl0gKnBkcHQgPSAwMDAwMDAwMDAwMDAwMDAwICpwZGUgPSBmMDAw
ZmY1M2YwMDBmZjUzIApbICAgIDguOTM5ODMyXSBPb3BzOiAwMDEwIFsjMV0gREVCVUdfUEFH
RUFMTE9DClsgICAgOC45Mzk4MzJdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDguOTM5ODMy
XSBDUFU6IDAgUElEOiA0NiBDb21tOiBtb3VudCBOb3QgdGFpbnRlZCAzLjEyLjAtcmMxLTAw
MDUxLWdiMDIxZmUzICMzOTAKWyAgICA4LjkzOTgzMl0gdGFzazogY2Q3Y2JjZDAgdGk6IGNk
MTBjMDAwIHRhc2sudGk6IGNkMTBjMDAwClsgICAgOC45Mzk4MzJdIEVJUDogMDA2MDpbPDAw
MDAwMDAwPl0gRUZMQUdTOiAwMDAwMDI0NiBDUFU6IDAKWyAgICA4LjkzOTgzMl0gRUlQIGlz
IGF0IDB4MApbICAgIDguOTM5ODMyXSBFQVg6IGNkMGUwZjAwIEVCWDogY2QwZTBlNDAgRUNY
OiAwMDAwMDAwMCBFRFg6IGNkMGUwZjAwClsgICAgOC45Mzk4MzJdIEVTSTogY2Q3Y2JmNjgg
RURJOiBjZDdjYmNkMCBFQlA6IGNkMTBkZjQ0IEVTUDogY2QxMGRmMzQKWyAgICA4LjkzOTgz
Ml0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMDAwIFNTOiAwMDY4ClsgICAg
OC45Mzk4MzJdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwMCBDUjM6IDBkMTA4MDAwIENS
NDogMDAwMDA2YjAKWyAgICA4LjkzOTgzMl0gRFIwOiAwMDAwMDAwMCBEUjE6IDAwMDAwMDAw
IERSMjogMDAwMDAwMDAgRFIzOiAwMDAwMDAwMApbICAgIDguOTM5ODMyXSBEUjY6IDAwMDAw
MDAwIERSNzogMDAwMDAwMDAKWyAgICA4LjkzOTgzMl0gU3RhY2s6ClsgICAgOC45Mzk4MzJd
ICBjMTA0ZDQ5OSBjZDdjYmY4MCBjZDBkYTkwMCBjZDdjYmNkMCBjZDEwZGY4YyBjMTAzMTIw
MiAwMDAwMDAwMCBjZDEwZGY1OApbICAgIDguOTM5ODMyXSAgYzEwNzYwN2IgY2QxMGRmNzgg
MDAwMDAwMDEgMDAwMDAxMDAgMDAwMDAwMDAgMDAwMDAwNDYgMDAwMDAwMzAgY2QwZGE5NTAK
WyAgICA4LjkzOTgzMl0gIGNkN2NiY2QwIDAwMDAwMDA0IGNkMTBkZjljIDAwMDBmZjAwIGNl
ODY3YjgwIGNkN2NiY2QwIGNkMTBkZmE0IGMxMDMyN2VhClsgICAgOC45Mzk4MzJdIENhbGwg
VHJhY2U6ClsgICAgOC45Mzk4MzJdICBbPGMxMDRkNDk5Pl0gPyB0YXNrX3dvcmtfcnVuKzB4
NzkvMHhhMApbICAgIDguOTM5ODMyXSAgWzxjMTAzMTIwMj5dIGRvX2V4aXQrMHgyZjIvMHg5
NTAKWyAgICA4LjkzOTgzMl0gIFs8YzEwNzYwN2I+XSA/IHRyYWNlX2hhcmRpcnFzX29mZisw
eGIvMHgxMApbICAgIDguOTM5ODMyXSAgWzxjMTAzMjdlYT5dIGRvX2dyb3VwX2V4aXQrMHg0
YS8weGEwClsgICAgOC45Mzk4MzJdICBbPGMxMDMyODU4Pl0gU3lTX2V4aXRfZ3JvdXArMHgx
OC8weDIwClsgICAgOC45Mzk4MzJdICBbPGMxMzA3YjE1Pl0gc3lzY2FsbF9jYWxsKzB4Ny8w
eGIKWyAgICA4LjkzOTgzMl0gQ29kZTogIEJhZCBFSVAgdmFsdWUuClsgICAgOC45Mzk4MzJd
IEVJUDogWzwwMDAwMDAwMD5dIDB4MCBTUzpFU1AgMDA2ODpjZDEwZGYzNApbICAgIDguOTM5
ODMyXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgt
MTAwNS9iMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZkMmFkZWVlMWI5NzM2L2RtZXNnLXlv
Y3RvLWF0aGVucy0xOjIwMTMxMDA5MDAyMjA1OmkzODYtcmFuZGNvbmZpZy1yOC0xMDA1OjMu
MTIuMC1yYzEtMDAwNTEtZ2IwMjFmZTM6MzkwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4
LTEwMDUvYjAyMWZlM2UyNTA5NGZiZWMyMmQwZWZmODQ2ZDJhZGVlZTFiOTczNi9kbWVzZy15
b2N0by1hdGhlbnMtMjA6MjAxMzEwMDkwMDIyMTE6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6
My4xMi4wLXJjMS0wMDA1MS1nYjAyMWZlMzozOTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
cjgtMTAwNS9iMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZkMmFkZWVlMWI5NzM2L2RtZXNn
LXlvY3RvLWJlbnMtNDoyMDEzMTAwOTAwMjIwNzppMzg2LXJhbmRjb25maWctcjgtMTAwNToz
LjEyLjAtcmMxLTAwMDUxLWdiMDIxZmUzOjM5MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1y
OC0xMDA1L2IwMjFmZTNlMjUwOTRmYmVjMjJkMGVmZjg0NmQyYWRlZWUxYjk3MzYvZG1lc2ct
eW9jdG8tY2Fpcm8tMzg6MjAxMzEwMDkwMDIyMDY6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6
My4xMi4wLXJjMS0wMDA1MS1nYjAyMWZlMzozOTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
cjgtMTAwNS9iMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZkMmFkZWVlMWI5NzM2L2RtZXNn
LXlvY3RvLWpha2V0b3duLTE4OjIwMTMxMDA5MDAyMjEwOmkzODYtcmFuZGNvbmZpZy1yOC0x
MDA1OjMuMTIuMC1yYzEtMDAwNTEtZ2IwMjFmZTM6MzkwCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXI4LTEwMDUvYjAyMWZlM2UyNTA5NGZiZWMyMmQwZWZmODQ2ZDJhZGVlZTFiOTczNi9k
bWVzZy15b2N0by1qYWtldG93bi0xOToyMDEzMTAwOTAwMjIwNDppMzg2LXJhbmRjb25maWct
cjgtMTAwNTozLjEyLjAtcmMxLTAwMDUxLWdiMDIxZmUzOjM5MAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1yOC0xMDA1L2IwMjFmZTNlMjUwOTRmYmVjMjJkMGVmZjg0NmQyYWRlZWUxYjk3
MzYvZG1lc2cteW9jdG8tamFrZXRvd24tNDU6MjAxMzEwMDkwMDIyMDg6aTM4Ni1yYW5kY29u
ZmlnLXI4LTEwMDU6My4xMi4wLXJjMS0wMDA1MS1nYjAyMWZlMzozOTAKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctcjgtMTAwNS9iMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZkMmFkZWVl
MWI5NzM2L2RtZXNnLXlvY3RvLWxrcC10dDAyLTc6MjAxMzEwMDgxNDUzMTg6aTM4Ni1yYW5k
Y29uZmlnLXI4LTEwMDU6My4xMi4wLXJjMS0wMDA1MS1nYjAyMWZlMzozOTAKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctcjgtMTAwNS9iMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZkMmFk
ZWVlMWI5NzM2L2RtZXNnLXlvY3RvLXN0b2FrbGV5LTE6MjAxMzEwMDkwMDIyMDY6aTM4Ni1y
YW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjMS0wMDA1MS1nYjAyMWZlMzozOTAKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS9iMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZk
MmFkZWVlMWI5NzM2L2RtZXNnLXlvY3RvLXhpYW4tMjoyMDEzMTAwOTAwMjIwOTppMzg2LXJh
bmRjb25maWctcjgtMTAwNTozLjEyLjAtcmMxLTAwMDUxLWdiMDIxZmUzOjM5MAova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1L2IwMjFmZTNlMjUwOTRmYmVjMjJkMGVmZjg0NmQy
YWRlZWUxYjk3MzYvZG1lc2cteW9jdG8tYW50LTI6MjAxMzEwMDkwMDIyMTI6aTM4Ni1yYW5k
Y29uZmlnLXI4LTEwMDU6My4xMi4wLXJjMS0wMDA1MS1nYjAyMWZlMzozOTAKMDoxMToxMSBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbMGM0NGMyZDBmNDU5Y2Q3
ZTI3NTI0MmI3MmY1MDAxMzdjNGZhODM0ZF0geDg2OiBVc2UgYXNtIGdvdG8gdG8gaW1wbGVt
ZW50IGJldHRlciBtb2RpZnlfYW5kX3Rlc3QoKSBmdW5jdGlvbnMKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLXI4LTEwMDUvdGlwOnNjaGVkOmNvcmU6MGM0NGMyZDBmNDU5Y2Q3ZTI3NTI0MmI3MmY1
MDAxMzdjNGZhODM0ZDpiaXNlY3QtbmV0CgoyMDEzLTEwLTA5LTAwOjIyOjQwIDBjNDRjMmQw
ZjQ1OWNkN2UyNzUyNDJiNzJmNTAwMTM3YzRmYTgzNGQgY29tcGlsaW5nCjMyIHJlYWwgIDc0
IHVzZXIgIDE1IHN5cyAgMjc2LjA2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yOC0xMDA1Cgoy
MDEzLTEwLTA5LTAwOjIzOjI0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAw
NTAtZzBjNDRjMmQuIFRFU1QgRkFJTFVSRQoKbW91bnQ6IG1vdW50aW5nIHByb2Mgb24gL3By
b2MgZmFpbGVkOiBObyBzdWNoIGRldmljZQpbICAgIDAuNTEwNjg5XSBCVUc6IHVuYWJsZSB0
byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgIChudWxsKQpb
ICAgIDAuNTExMzMzXSBJUDogWzxjMTEwYTQ3MD5dIF9fZnB1dCsweDUwLzB4MzgwClsgICAg
MC41MTE2NzBdICpwZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAw
ZmY1MyAKWyAgICAwLjUxMTY3MF0gT29wczogMDAwMCBbIzFdIERFQlVHX1BBR0VBTExPQwpb
ICAgIDAuNTExNjcwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjUxMTY3MF0gQ1BVOiAw
IFBJRDogMTIgQ29tbToga3dvcmtlci8wOjEgTm90IHRhaW50ZWQgMy4xMi4wLXJjMS0wMDA1
MC1nMGM0NGMyZCAjMzkxClsgICAgMC41MTE2NzBdIFdvcmtxdWV1ZTogZXZlbnRzIGRlbGF5
ZWRfZnB1dApbICAgIDAuNTExNjcwXSB0YXNrOiBjMDAzNWY5MCB0aTogY2U4NjYwMDAgdGFz
ay50aTogY2U4NjYwMDAKWyAgICAwLjUxMTY3MF0gRUlQOiAwMDYwOls8YzExMGE0NzA+XSBF
RkxBR1M6IDAwMDEwMjEyIENQVTogMApbICAgIDAuNTExNjcwXSBFSVAgaXMgYXQgX19mcHV0
KzB4NTAvMHgzODAKWyAgICAwLjUxMTY3MF0gRUFYOiAwMDAwMDAwMCBFQlg6IGNkMGUzMjAw
IEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAxZApbICAgIDAuNTExNjcwXSBFU0k6IDAwMDAw
MDEwIEVESTogMDAwMDAwMDAgRUJQOiBjZTg2N2U5OCBFU1A6IGNlODY3ZTcwClsgICAgMC41
MTE2NzBdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApb
ICAgIDAuNTExNjcwXSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwZDEwYjAw
MCBDUjQ6IDAwMDAwNmIwClsgICAgMC41MTE2NzBdIFN0YWNrOgpbICAgIDAuNTExNjcwXSAg
MDAwMDAyNDYgMDAwMDAwMDAgMDAwMDAwMDIgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAg
MDAwMDAwMDAgMDAwMDAwMDAKWyAgICAwLjUxMTY3MF0gIDAwMDAwMDAwIGMwMTI0NTQwIGNl
ODY3ZWE0IGMxMTBhN2M5IGMxNDhkNjQwIGNlODY3ZWZjIGMxMDQ4ZmI5IDAwMDAwMDAwClsg
ICAgMC41MTE2NzBdICAwMDAwMDAwMiAwMDAwMDAwMCBjMTA0OGY4MSAwMDAwMDAwMCAwMDAw
MDAwMCAwMDAwMDAwMCAwMDE5ZWJjNyBjMDA4MzQwMApbICAgIDAuNTExNjcwXSBDYWxsIFRy
YWNlOgpbICAgIDAuNTExNjcwXSAgWzxjMTEwYTdjOT5dIGRlbGF5ZWRfZnB1dCsweDI5LzB4
MzAKWyAgICAwLjUxMTY3MF0gIFs8YzEwNDhmYjk+XSBwcm9jZXNzX29uZV93b3JrKzB4MmY5
LzB4NjUwClsgICAgMC41MTE2NzBdICBbPGMxMDQ4ZjgxPl0gPyBwcm9jZXNzX29uZV93b3Jr
KzB4MmMxLzB4NjUwClsgICAgMC41MTE2NzBdICBbPGMxMDRhOGVmPl0gd29ya2VyX3RocmVh
ZCsweDI4Zi8weDYxMApbICAgIDAuNTExNjcwXSAgWzxjMTA0YTY2MD5dID8gY2FuY2VsX2Rl
bGF5ZWRfd29ya19zeW5jKzB4MjAvMHgyMApbICAgIDAuNTExNjcwXSAgWzxjMTA1MDkwMj5d
IGt0aHJlYWQrMHg5Mi8weGEwClsgICAgMC41MTE2NzBdICBbPGMxMzBlZDliPl0gcmV0X2Zy
b21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAgICAwLjUxMTY3MF0gIFs8YzEwNTA4NzA+
XSA/IGt0aHJlYWRfY3JlYXRlX29uX25vZGUrMHhkMC8weGQwClsgICAgMC41MTE2NzBdIENv
ZGU6IDAwIGI4IGFkIDVlIDQxIGMxIGU4IGIwIGZlIGY0IGZmIGU4IGZiIGIxIDFmIDAwIDhi
IDQzIDEwIDg5IGMxIDg5IDQ1IGU4IDhiIDUzIDQwIDg5IGQwIDgzIGUwIDAyIDgzIGY4IDAx
IDE5IGY2IDgzIGU2IDA4IDgzIGM2IDA4IDw4Yj4gMDEgMjUgMDAgZjAgZmYgZmYgNjYgM2Qg
MDAgNDAgMGYgODQgMmYgMDIgMDAgMDAgODEgZTIgMDAgMDAKWyAgICAwLjUxMTY3MF0gRUlQ
OiBbPGMxMTBhNDcwPl0gX19mcHV0KzB4NTAvMHgzODAgU1M6RVNQIDAwNjg6Y2U4NjdlNzAK
WyAgICAwLjUxMTY3MF0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC41MjY2MDhdIC0t
LVsgZW5kIHRyYWNlIDQ5MGJjMjgzZTZmYzM0ZjkgXS0tLQpbICAgIDAuNTMwNTA0XSBLZXJu
ZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQ1JFRDogcHV0X2NyZWRfcmN1KCkgc2VlcyBjZDBj
NmQwMCB3aXRoIHVzYWdlIC0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvMGM0
NGMyZDBmNDU5Y2Q3ZTI3NTI0MmI3MmY1MDAxMzdjNGZhODM0ZC9kbWVzZy15b2N0by14cHMt
NDoyMDEzMTAwOTA4MTk0MjppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmMxLTAw
MDUwLWcwYzQ0YzJkOjM5MQowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKMGM0
NGMyZDBmNDU5Y2Q3ZTI3NTI0MmI3MmY1MDAxMzdjNGZhODM0ZCBpcyB0aGUgZmlyc3QgYmFk
IGNvbW1pdApjb21taXQgMGM0NGMyZDBmNDU5Y2Q3ZTI3NTI0MmI3MmY1MDAxMzdjNGZhODM0
ZApBdXRob3I6IFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5mcmFkZWFkLm9yZz4KRGF0ZTog
ICBXZWQgU2VwIDExIDE1OjE5OjI0IDIwMTMgKzAyMDAKCiAgICB4ODY6IFVzZSBhc20gZ290
byB0byBpbXBsZW1lbnQgYmV0dGVyIG1vZGlmeV9hbmRfdGVzdCgpIGZ1bmN0aW9ucwogICAg
CiAgICBMaW51cyBzdWdnZXN0ZWQgdXNpbmcgYXNtIGdvdG8gdG8gZ2V0IHJpZCBvZiB0aGUg
dHlwaWNhbCBTRVRjYyArIFRFU1QKICAgIGluc3RydWN0aW9uIHBhaXIgLS0gd2hpY2ggYWxz
byBjbG9iYmVycyBhbiBleHRyYSByZWdpc3RlciAtLSBmb3Igb3VyCiAgICB0eXBpY2FsIG1v
ZGlmeV9hbmRfdGVzdCgpIGZ1bmN0aW9ucy4KICAgIAogICAgQmVjYXVzZSBhc20gZ290byBk
b2Vzbid0IGFsbG93IG91dHB1dCBmaWVsZHMgaXQgaGFzIHRvIGluY2x1ZGUgYW4KICAgIHVu
Y29uZGl0aW5hbCBtZW1vcnkgY2xvYmJlciB3aGVuIGl0IGNoYW5nZXMgYSBtZW1vcnkgdmFy
aWFibGUgdG8gZm9yY2UKICAgIGEgcmVsb2FkLgogICAgCiAgICBMdWNraWx5IGFsbCBhdG9t
aWMgb3BzIGFscmVhZHkgaW1wbHkgYSBjb21waWxlciBiYXJyaWVyIHRvIGdvIGFsb25nCiAg
ICB3aXRoIHRoZWlyIG1lbW9yeSBiYXJyaWVyIHNlbWFudGljcy4KICAgIAogICAgU3VnZ2Vz
dGVkLWJ5OiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+
CiAgICBTaWduZWQtb2ZmLWJ5OiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5v
cmc+CiAgICBMaW5rOiBodHRwOi8vbGttbC5rZXJuZWwub3JnL24vdGlwLTBtdG45c2l3YmVv
MWQzM2JhcDE0MjJzZUBnaXQua2VybmVsLm9yZwogICAgU2lnbmVkLW9mZi1ieTogSW5nbyBN
b2xuYXIgPG1pbmdvQGtlcm5lbC5vcmc+Cgo6MDQwMDAwIDA0MDAwMCA1MTJjNzk2NTg2NDIx
OGVmNWE0MDU2OWY4MGRkNjE3ZmM3NWI2MGY5IDIyYzUyODZjYzFhYTFlMzM2YzhiMGQ3ZWZi
YTA4ZjNmM2VmZjA2NDAgTQlhcmNoCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvdGlwOnNjaGVk
OmNvcmU6NDMxNDg5NTE2NTYyMzg3OTkzN2Y0NmQ3Njc2NzM2NTQ2NjJiNTcwYzpiaXNlY3Qt
bmV0CgoyMDEzLTEwLTA5LTAwOjIzOjU3IDQzMTQ4OTUxNjU2MjM4Nzk5MzdmNDZkNzY3Njcz
NjU0NjYyYjU3MGMgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS80MzE0
ODk1MTY1NjIzODc5OTM3ZjQ2ZDc2NzY3MzY1NDY2MmI1NzBjL3ZtbGludXotMy4xMi4wLXJj
MS0wMDA0OS1nNDMxNDg5NQoKMjAxMy0xMC0wOS0wMDoyMzo1NyBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuLgkzMQk2OQk3Mwk3NSBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvdGlwOnNjaGVkOmNvcmU6ZmI4Njli
NmU5MWEzYWMyMzVmMjM3ZjczMzA1ZWNmMzRjZGM0OTY5YjpiaXNlY3QtbmV0CiBURVNUIEZB
SUxVUkUKWyAgIDgwLjU2Nzg1Ml0gZGVidWc6IHVubWFwcGluZyBpbml0IFttZW0gMHhjMTRk
NzAwMC0weGMxNTFiZmZmXQptb2Rwcm9iZTogRkFUQUw6IENvdWxkIG5vdCBsb2FkIC9saWIv
bW9kdWxlcy8zLjEyLjAtcmMxLTAwMDgwLWdmYjg2OWI2L21vZHVsZXMuZGVwOiBObyBzdWNo
IGZpbGUgb3IgZGlyZWN0b3J5ClsgICA4MS4xMjMzOTldIEJVRzogdW5hYmxlIHRvIGhhbmRs
ZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDIwClsgICA4MS4x
MjM4OTldIElQOiBbPGMxMTBjYzE0Pl0gdmZzX2dldGF0dHIrMHgxNC8weDYwClsgICA4MS4x
MjM4OTldICpwZHB0ID0gMDAwMDAwMDAwNmQzNjAwMSAqcGRlID0gMDAwMDAwMDAwMDAwMDAw
MCAKWyAgIDgxLjEyMzg5OV0gT29wczogMDAwMCBbIzFdIERFQlVHX1BBR0VBTExPQwpbICAg
ODEuMTIzODk5XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDgxLjEyMzg5OV0gQ1BVOiAwIFBJ
RDogMzkgQ29tbTogbW9kcHJvYmUgTm90IHRhaW50ZWQgMy4xMi4wLXJjMS0wMDA4MC1nZmI4
NjliNiAjMwpbICAgODEuMTIzODk5XSB0YXNrOiBjNmMzMmI3MCB0aTogYzZkNDIwMDAgdGFz
ay50aTogYzZkNDIwMDAKWyAgIDgxLjEyMzg5OV0gRUlQOiAwMDYwOls8YzExMGNjMTQ+XSBF
RkxBR1M6IDAwMDAwMjQ2IENQVTogMApbICAgODEuMTIzODk5XSBFSVAgaXMgYXQgdmZzX2dl
dGF0dHIrMHgxNC8weDYwClsgICA4MS4xMjM4OTldIEVBWDogYzAwNjRiNDggRUJYOiBjMDA2
NGI0OCBFQ1g6IGJmODBjMGMwIEVEWDogMDAwMDAwMDAKWyAgIDgxLjEyMzg5OV0gRVNJOiBj
NmQ0M2Y1YyBFREk6IDAwMDAwMDAwIEVCUDogYzZkNDNmM2MgRVNQOiBjNmQ0M2YyYwpbICAg
ODEuMTIzODk5XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwMzMgU1M6IDAw
NjgKWyAgIDgxLjEyMzg5OV0gQ1IwOiA4MDA1MDAzMyBDUjI6IDAwMDAwMDIwIENSMzogMDZk
MWYwMDAgQ1I0OiAwMDAwMDZiMApbICAgODEuMTIzODk5XSBEUjA6IDAwMDAwMDAwIERSMTog
MDAwMDAwMDAgRFIyOiAwMDAwMDAwMCBEUjM6IDAwMDAwMDAwClsgICA4MS4xMjM4OTldIERS
NjogMDAwMDAwMDAgRFI3OiAwMDAwMDAwMApbICAgODEuMTIzODk5XSBTdGFjazoKWyAgIDgx
LjEyMzg5OV0gIGM2ZDQzZjVjIGMwMDY0YjQwIGM2ZDQzZjVjIDAwMDAwMDAwIGM2ZDQzZjU0
IGMxMTBjYzg5IDAwMDAwMDAwIGJmODBjMGMwClsgICA4MS4xMjM4OTldICBiZjgwYzM0OCAw
MDAwMjAwMCBjNmQ0M2ZhYyBjMTEwZDY5YSBjMTA5Mjg3ZSBjNmQ0MjAwMCAwMDAwMDAwMCAw
MDAwMDA0NgpbICAgODEuMTIzODk5XSAgMDAwMDAwMzAgYzEzMDVkOWUgYzZjMzJiNzAgMDgw
NTkyNmMgYzZkNDNmOWMgMDAwMDAwMDIgYzEzMGQ1ODIgMDAwMDAwMjIKWyAgIDgxLjEyMzg5
OV0gQ2FsbCBUcmFjZToKWyAgIDgxLjEyMzg5OV0gIFs8YzExMGNjODk+XSB2ZnNfZnN0YXQr
MHgyOS8weDUwClsgICA4MS4xMjM4OTldICBbPGMxMTBkNjlhPl0gU3lTX2ZzdGF0NjQrMHgx
YS8weDMwClsgICA4MS4xMjM4OTldICBbPGMxMDkyODdlPl0gPyByY3VfaXJxX2V4aXQrMHhl
ZS8weDEzMApbICAgODEuMTIzODk5XSAgWzxjMTMwNWQ5ZT5dID8gcmVzdG9yZV9hbGwrMHhm
LzB4ZgpbICAgODEuMTIzODk5XSAgWzxjMTMwZDU4Mj5dID8gZG9fSVJRKzB4NDIvMHg5NApb
ICAgODEuMTIzODk5XSAgWzxjMTE5NGQ1ND5dID8gdHJhY2VfaGFyZGlycXNfb25fdGh1bmsr
MHhjLzB4MTAKWyAgIDgxLjEyMzg5OV0gIFs8YzEzMGQwMTA+XSBzeXNlbnRlcl9kb19jYWxs
KzB4MTIvMHgzYwpbICAgODEuMTIzODk5XSBDb2RlOiA3NCA4MSBlMiBmZiAwMSAwMCAwMCA2
NiA4OSA1MCA2YyA1YiA1ZSA1ZCBjMyA5MCA4ZCBiNCAyNiAwMCAwMCAwMCAwMCA1NSA4OSBl
NSA1NyA1NiA1MyA1MSBlOCA5NCAwOCAyMCAwMCA4OSBjMyA4OSA1NSBmMCA4YiA1MCAwNCA8
OGI+IDcyIDIwIDhiIDAwIGU4IDcyIDI1IDA2IDAwIDg1IGMwIDc1IDE0IDhiIDQ2IDEwIDhi
IDc4IDNjIDg1ClsgICA4MS4xMjM4OTldIEVJUDogWzxjMTEwY2MxND5dIHZmc19nZXRhdHRy
KzB4MTQvMHg2MCBTUzpFU1AgMDA2ODpjNmQ0M2YyYwpbICAgODEuMTIzODk5XSBDUjI6IDAw
MDAwMDAwMDAwMDAwMjAKWyAgIDgxLjE4NDIzOV0gLS0tWyBlbmQgdHJhY2UgMzc5NGNiM2Ji
NjUyMDhiNSBdLS0tCi0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvZmI4Njli
NmU5MWEzYWMyMzVmMjM3ZjczMzA1ZWNmMzRjZGM0OTY5Yi9kbWVzZy15b2N0by13YWltZWEt
MTI6MjAxMzEwMDUxMDA3NTU6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjMS0w
MDA4MC1nZmI4NjliNjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvZmI4Njli
NmU5MWEzYWMyMzVmMjM3ZjczMzA1ZWNmMzRjZGM0OTY5Yi9kbWVzZy15b2N0by14cHMtNjoy
MDEzMTAwNTEwMDUzNzppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmMxLTAwMDgw
LWdmYjg2OWI2OjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS9mYjg2OWI2ZTkx
YTNhYzIzNWYyMzdmNzMzMDVlY2YzNGNkYzQ5NjliL2RtZXNnLXlvY3RvLXN0b2FrbGV5LTU6
MjAxMzEwMDgyMjU4MDE6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjMS0wMDA4
MC1nZmI4NjliNjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvZmI4NjliNmU5
MWEzYWMyMzVmMjM3ZjczMzA1ZWNmMzRjZGM0OTY5Yi9kbWVzZy15b2N0by14cHMtNDoyMDEz
MTAwNTEwMDUzMDppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmMxLTAwMDgwLWdm
Yjg2OWI2OjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS9mYjg2OWI2ZTkxYTNh
YzIzNWYyMzdmNzMzMDVlY2YzNGNkYzQ5NjliL2RtZXNnLXF1YW50YWwtYW50LTc6MjAxMzEw
MDUwMjEwMjg6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjMS0wMDA4MC1nZmI4
NjliNjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvZmI4NjliNmU5MWEzYWMy
MzVmMjM3ZjczMzA1ZWNmMzRjZGM0OTY5Yi9kbWVzZy15b2N0by1uaG00LTE6MjAxMzEwMDgx
NTAyNTQ6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjMS0wMDA4MC1nZmI4Njli
NjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvZmI4NjliNmU5MWEzYWMyMzVm
MjM3ZjczMzA1ZWNmMzRjZGM0OTY5Yi9kbWVzZy15b2N0by1sa3AtdHQwMi0xMjoyMDEzMTAw
ODEzMjg1NzppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmMxLTAwMDgwLWdmYjg2
OWI2OjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS9mYjg2OWI2ZTkxYTNhYzIz
NWYyMzdmNzMzMDVlY2YzNGNkYzQ5NjliL2RtZXNnLXlvY3RvLWpha2V0b3duLTEzOjIwMTMx
MDA4MjI1ODAzOmkzODYtcmFuZGNvbmZpZy1yOC0xMDA1OjMuMTIuMC1yYzEtMDAwODAtZ2Zi
ODY5YjY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1L2ZiODY5YjZlOTFhM2Fj
MjM1ZjIzN2Y3MzMwNWVjZjM0Y2RjNDk2OWIvZG1lc2cteW9jdG8td2FpbWVhLTE0OjIwMTMx
MDA1MTAwNTQzOmkzODYtcmFuZGNvbmZpZy1yOC0xMDA1OjMuMTIuMC1yYzEtMDAwODAtZ2Zi
ODY5YjY6MwowOjk6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRhY2hlZCBI
RUFEIGQ0Zjc2ZGZdIFJldmVydCAieDg2OiBVc2UgYXNtIGdvdG8gdG8gaW1wbGVtZW50IGJl
dHRlciBtb2RpZnlfYW5kX3Rlc3QoKSBmdW5jdGlvbnMiCiA1IGZpbGVzIGNoYW5nZWQsIDky
IGluc2VydGlvbnMoKyksIDU4IGRlbGV0aW9ucygtKQogZGVsZXRlIG1vZGUgMTAwNjQ0IGFy
Y2gveDg2L2luY2x1ZGUvYXNtL3Jtd2NjLmgKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1L3RpcDpzY2hlZDpjb3JlOmQ0Zjc2ZGY1
NGM3MjNjYmE4ODE2MGNhNDIzOGU4N2FjMGNmZmRiMTk6YmlzZWN0LW5ldAoKMjAxMy0xMC0w
OS0wMDoyNzowMSBkNGY3NmRmNTRjNzIzY2JhODgxNjBjYTQyMzhlODdhYzBjZmZkYjE5IGNv
bXBpbGluZwobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6IG1ha2UgcHJlcGFyZSBm
YWlsZWQbWzBtCjIwMTMtMTAtMDktMDA6Mjc6MDcgZDRmNzZkZjU0YzcyM2NiYTg4MTYwY2E0
MjM4ZTg3YWMwY2ZmZGIxOSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mv
d2ZnL25ldC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1
L2Q0Zjc2ZGY1NGM3MjNjYmE4ODE2MGNhNDIzOGU4N2FjMGNmZmRiMTkKCj09PT09PT09PSB1
cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1L3RpcDpzY2hlZDpjb3JlOjhi
NWVkZTY5ZDI0ZGI5MzlmNTJiNDdlZmZmZjJmNmZlMWU4M2UwOGI6YmlzZWN0LW5ldAoKMjAx
My0xMC0wOS0wMDoyNzoxMSA4YjVlZGU2OWQyNGRiOTM5ZjUyYjQ3ZWZmZmYyZjZmZTFlODNl
MDhiIGNvbXBpbGluZwoKMjAxMy0xMC0wOS0wMDoyOToyMiBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAzLjEyLjAtcmM0LTAwMDE5LWc4YjVlZGU2Li4JMwkyOQk1MQk3NC4uCTc1IFNVQ0NFU1MK
Cgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KRmV0Y2hpbmcgbmV4dApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvdGlw
OnNjaGVkOmNvcmU6YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZjpi
aXNlY3QtbmV0CgoyMDEzLTEwLTA5LTAwOjMzOjU3IGEwY2YxYWJjMjVhYzE5N2RkOTdiODU3
YzBmNjM0MTA2NmE4Y2IxY2YgY29tcGlsaW5nCgoyMDEzLTEwLTA5LTAwOjM1OjU1IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFh
Yi4gVEVTVCBGQUlMVVJFCgptb3VudDogbW91bnRpbmcgcHJvYyBvbiAvcHJvYyBmYWlsZWQ6
IE5vIHN1Y2ggZGV2aWNlClsgICAxMS40ODkyOTRdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBr
ZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgKG51bGwpClsgICAxMS40OTEy
MzJdIElQOiBbPCAgKG51bGwpPl0gICAobnVsbCkKWyAgIDExLjQ5MTIzMl0gKnBkcHQgPSAw
MDAwMDAwMDAwMDAwMDAwICpwZGUgPSBmMDAwZmY1M2YwMDBmZjUzIApbICAgMTEuNDkxMjMy
XSBPb3BzOiAwMDEwIFsjMV0gREVCVUdfUEFHRUFMTE9DClsgICAxMS40OTEyMzJdIE1vZHVs
ZXMgbGlua2VkIGluOgpbICAgMTEuNDkxMjMyXSBDUFU6IDAgUElEOiA0NiBDb21tOiBtb3Vu
dCBOb3QgdGFpbnRlZCAzLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWIg
IzM5MwpbICAgMTEuNDkxMjMyXSB0YXNrOiBjZDdjYmNkMCB0aTogY2QxMGMwMDAgdGFzay50
aTogY2QxMGMwMDAKWyAgIDExLjQ5MTIzMl0gRUlQOiAwMDYwOls8MDAwMDAwMDA+XSBFRkxB
R1M6IDAwMDAwMjQ2IENQVTogMApbICAgMTEuNDkxMjMyXSBFSVAgaXMgYXQgMHgwClsgICAx
MS40OTEyMzJdIEVBWDogY2QwZGVmMDAgRUJYOiBjZDBkZWU0MCBFQ1g6IDAwMDAwMDAwIEVE
WDogY2QwZGVmMDAKWyAgIDExLjQ5MTIzMl0gRVNJOiBjZDdjYmY2OCBFREk6IGNkN2NiY2Qw
IEVCUDogY2QxMGRmNDQgRVNQOiBjZDEwZGYzNApbICAgMTEuNDkxMjMyXSAgRFM6IDAwN2Ig
RVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwMDAgU1M6IDAwNjgKWyAgIDExLjQ5MTIzMl0gQ1Iw
OiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMGQxMDgwMDAgQ1I0OiAwMDAwMDZiMApb
ICAgMTEuNDkxMjMyXSBEUjA6IDAwMDAwMDAwIERSMTogMDAwMDAwMDAgRFIyOiAwMDAwMDAw
MCBEUjM6IDAwMDAwMDAwClsgICAxMS40OTEyMzJdIERSNjogMDAwMDAwMDAgRFI3OiAwMDAw
MDAwMApbICAgMTEuNDkxMjMyXSBTdGFjazoKWyAgIDExLjQ5MTIzMl0gIGMxMDRkM2U5IGNk
N2NiZjgwIGNkMGRhOTAwIGNkN2NiY2QwIGNkMTBkZjhjIGMxMDMxMDI5IDAwMDAwMDAwIDAw
MDAwMDAwClsgICAxMS40OTEyMzJdICBjZDBkZTI0MCBjZWU5ZTQwMCAwMDAwMDAwMSBjZDEw
ZGY4OCBjMTEwOGVhMSAwMDAwMDAwMSAwMDAwMDAwMCBjZDBkYTk1MApbICAgMTEuNDkxMjMy
XSAgY2Q3Y2JjZDAgMDgwZDMyMDggY2QxMGRmOWMgMDAwMGZmMDAgY2U4NjdiODAgY2Q3Y2Jj
ZDAgY2QxMGRmYTQgYzEwMzI1Y2EKWyAgIDExLjQ5MTIzMl0gQ2FsbCBUcmFjZToKWyAgIDEx
LjQ5MTIzMl0gIFs8YzEwNGQzZTk+XSA/IHRhc2tfd29ya19ydW4rMHg3OS8weGEwClsgICAx
MS40OTEyMzJdICBbPGMxMDMxMDI5Pl0gZG9fZXhpdCsweDJlOS8weDk0MApbICAgMTEuNDkx
MjMyXSAgWzxjMTEwOGVhMT5dID8gdmZzX3dyaXRlKzB4MWExLzB4MWMwClsgICAxMS40OTEy
MzJdICBbPGMxMDMyNWNhPl0gZG9fZ3JvdXBfZXhpdCsweDRhLzB4YTAKWyAgIDExLjQ5MTIz
Ml0gIFs8YzEwMzI2Mzg+XSBTeVNfZXhpdF9ncm91cCsweDE4LzB4MjAKWyAgIDExLjQ5MTIz
Ml0gIFs8YzEzMDkxMDU+XSBzeXNjYWxsX2NhbGwrMHg3LzB4YgpbICAgMTEuNDkxMjMyXSBD
b2RlOiAgQmFkIEVJUCB2YWx1ZS4KWyAgIDExLjQ5MTIzMl0gRUlQOiBbPDAwMDAwMDAwPl0g
MHgwIFNTOkVTUCAwMDY4OmNkMTBkZjM0ClsgICAxMS40OTEyMzJdIENSMjogMDAwMDAwMDAw
MDAwMDAwMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1L2EwY2YxYWJjMjVhYzE5
N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8tY2Fpcm8tMjg6MjAxMzEw
MDkwMDM2MDM6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjMi1uZXh0LTIwMTMw
OTI3LTAzMTAwLWdhMGNmMWFiOjM5Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1
L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8t
Y2Fpcm8tNzoyMDEzMTAwOTAwMzYwNDppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAt
cmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MzkzCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXI4LTEwMDUvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFj
Zi9kbWVzZy15b2N0by1sa3AtdHQwMi0xMzoyMDEzMTAwODE1MDcxNDppMzg2LXJhbmRjb25m
aWctcjgtMTAwNTozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6Mzkz
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4
NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1jYWlyby05OjIwMTMxMDA5MDAzNjA4
OmkzODYtcmFuZGNvbmZpZy1yOC0xMDA1OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEw
MC1nYTBjZjFhYjozOTMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS9hMGNmMWFi
YzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXdhaW1lYS0x
NToyMDEzMTAwOTA4MzI1NDppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmMyLW5l
eHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MzkzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXI4LTEwMDUvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVz
Zy15b2N0by1hbnQtMzoyMDEzMTAwOTAwMzYxMjppMzg2LXJhbmRjb25maWctcjgtMTAwNToz
LjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MzkzCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXI4LTEwMDUvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2
YThjYjFjZi9kbWVzZy15b2N0by1sa3AtdHQwMi0xMjoyMDEzMTAwODE1MDcyMTppMzg2LXJh
bmRjb25maWctcjgtMTAwNTozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2Yx
YWI6MzkzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvYTBjZjFhYmMyNWFjMTk3
ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1sa3AtdHQwMi0xMzoyMDEz
MTAwODE1MDcyNTppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmMyLW5leHQtMjAx
MzA5MjctMDMxMDAtZ2EwY2YxYWI6MzkzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEw
MDUvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0
by14cHMtMToyMDEzMTAwOTA4MzIyNjppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAt
cmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MzkzCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXI4LTEwMDUvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFj
Zi9kbWVzZy15b2N0by13YWltZWEtMTU6MjAxMzEwMDkwODMzMDU6aTM4Ni1yYW5kY29uZmln
LXI4LTEwMDU6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjM5Mwow
OjEwOjEwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgoKPT09PT09PT09IHRpcC9tYXN0
ZXIgPT09PT09PT09CkZldGNoaW5nIHRpcApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvdGlwOnNjaGVkOmNvcmU6OTdkM2FiOWIy
MjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZDpiaXNlY3QtbmV0CgoyMDEzLTEwLTA5
LTAwOjM2OjMxIDk3ZDNhYjliMjIwN2Q3MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0YmQgY29t
cGlsaW5nCgoyMDEzLTEwLTA5LTAwOjM4OjUxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIu
MC1yYzQtMDE1ODctZzk3ZDNhYjkuIFRFU1QgRkFJTFVSRQoKbW91bnQ6IG1vdW50aW5nIHBy
b2Mgb24gL3Byb2MgZmFpbGVkOiBObyBzdWNoIGRldmljZQpbICAgIDAuODE1NTM5XSBCVUc6
IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAg
IChudWxsKQpbICAgIDAuODE2NDg3XSBJUDogWzwgIChudWxsKT5dICAgKG51bGwpClsgICAg
MC44MTY0ODddICpwZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAw
ZmY1MyAKWyAgICAwLjgxNjQ4N10gT29wczogMDAxMCBbIzFdIERFQlVHX1BBR0VBTExPQwpb
ICAgIDAuODE2NDg3XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjgxNjQ4N10gQ1BVOiAw
IFBJRDogNDYgQ29tbTogbW91bnQgTm90IHRhaW50ZWQgMy4xMi4wLXJjNC0wMTU4Ny1nOTdk
M2FiOSAjMzk0ClsgICAgMC44MTY0ODddIHRhc2s6IGNkN2NiY2QwIHRpOiBjZDEwZTAwMCB0
YXNrLnRpOiBjZDEwZTAwMApbICAgIDAuODE2NDg3XSBFSVA6IDAwNjA6WzwwMDAwMDAwMD5d
IEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAgMC44MTY0ODddIEVJUCBpcyBhdCAweDAK
WyAgICAwLjgxNjQ4N10gRUFYOiBjZDBlMzUwMCBFQlg6IGNkMGUzNjAwIEVDWDogMDAwMDAw
MDAgRURYOiBjZDBlMzUwMApbICAgIDAuODE2NDg3XSBFU0k6IGNkN2NiZjY4IEVESTogY2Q3
Y2JjZDAgRUJQOiBjZDEwZmY0NCBFU1A6IGNkMTBmZjM0ClsgICAgMC44MTY0ODddICBEUzog
MDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApbICAgIDAuODE2NDg3
XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwZDEwYjAwMCBDUjQ6IDAwMDAw
NmIwClsgICAgMC44MTY0ODddIFN0YWNrOgpbICAgIDAuODE2NDg3XSAgYzEwNGQyZTkgY2Q3
Y2JmODAgY2QwZGFhMDAgY2Q3Y2JjZDAgY2QxMGZmOGMgYzEwMzEwODkgMDAwMDAwMDAgMDAw
MDAwMDAKWyAgICAwLjgxNjQ4N10gIGNlZTlkMDAwIDAwMDAwMDM1IDAwMDAwMDAxIGNkMTBm
Zjg4IGMxMTA4ZDIxIDAwMDAwMDAxIDAwMDAwMDAwIGNkMGRhYTUwClsgICAgMC44MTY0ODdd
ICBjZDdjYmNkMCAwODBkMzIwOCBjZDEwZmY5YyAwMDAwZmYwMCBjZDBlZTYwMCBjZDdjYmNk
MCBjZDEwZmZhNCBjMTAzMjYyYQpbICAgIDAuODE2NDg3XSBDYWxsIFRyYWNlOgpbICAgIDAu
ODE2NDg3XSAgWzxjMTA0ZDJlOT5dID8gdGFza193b3JrX3J1bisweDc5LzB4YTAKWyAgICAw
LjgxNjQ4N10gIFs8YzEwMzEwODk+XSBkb19leGl0KzB4MmU5LzB4OTQwClsgICAgMC44MTY0
ODddICBbPGMxMTA4ZDIxPl0gPyB2ZnNfd3JpdGUrMHgxNjEvMHgxYTAKWyAgICAwLjgxNjQ4
N10gIFs8YzEwMzI2MmE+XSBkb19ncm91cF9leGl0KzB4NGEvMHhhMApbICAgIDAuODE2NDg3
XSAgWzxjMTAzMjY5OD5dIFN5U19leGl0X2dyb3VwKzB4MTgvMHgyMApbICAgIDAuODE2NDg3
XSAgWzxjMTMwNjhmNT5dIHN5c2NhbGxfY2FsbCsweDcvMHhiClsgICAgMC44MTY0ODddIENv
ZGU6ICBCYWQgRUlQIHZhbHVlLgpbICAgIDAuODE2NDg3XSBFSVA6IFs8MDAwMDAwMDA+XSAw
eDAgU1M6RVNQIDAwNjg6Y2QxMGZmMzQKWyAgICAwLjgxNjQ4N10gQ1IyOiAwMDAwMDAwMDAw
MDAwMDAwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvOTdkM2FiOWIyMjA3ZDcy
ZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0by1jYWlyby0xMToyMDEzMTAw
OTAwMzg1ODppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmM0LTAxNTg3LWc5N2Qz
YWI5OjM5NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1Lzk3ZDNhYjliMjIwN2Q3
MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0YmQvZG1lc2cteW9jdG8tc25iLTM4OjIwMTMxMDA5
MDAzODU1OmkzODYtcmFuZGNvbmZpZy1yOC0xMDA1OjMuMTIuMC1yYzQtMDE1ODctZzk3ZDNh
Yjk6Mzk0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvOTdkM2FiOWIyMjA3ZDcy
ZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0by1sa3AtdHQwMi0xMDoyMDEz
MTAwODE1MTAwODppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmM0LTAxNTg3LWc5
N2QzYWI5OjM5NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1Lzk3ZDNhYjliMjIw
N2Q3MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0YmQvZG1lc2cteW9jdG8tYmF5LTQ6MjAxMzEw
MDkwMDM5MDc6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjNC0wMTU4Ny1nOTdk
M2FiOTozOTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS85N2QzYWI5YjIyMDdk
NzJlYjBmNzIzNDc5NjljMjg0NTYyYzM3NGJkL2RtZXNnLXlvY3RvLWNhaXJvLTMwOjIwMTMx
MDA5MDAzOTEwOmkzODYtcmFuZGNvbmZpZy1yOC0xMDA1OjMuMTIuMC1yYzQtMDE1ODctZzk3
ZDNhYjk6Mzk0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvOTdkM2FiOWIyMjA3
ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0by1jYWlyby0zNjoyMDEz
MTAwOTAwMzkwMzppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmM0LTAxNTg3LWc5
N2QzYWI5OjM5NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1Lzk3ZDNhYjliMjIw
N2Q3MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0YmQvZG1lc2cteW9jdG8tbGtwLXR0MDItMTA6
MjAxMzEwMDgxNTEwMTg6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjNC0wMTU4
Ny1nOTdkM2FiOTozOTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS85N2QzYWI5
YjIyMDdkNzJlYjBmNzIzNDc5NjljMjg0NTYyYzM3NGJkL2RtZXNnLXlvY3RvLW5obTQtNDoy
MDEzMTAwODE2NDQxMDppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmM0LTAxNTg3
LWc5N2QzYWI5OjM5NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOC0xMDA1Lzk3ZDNhYjli
MjIwN2Q3MmViMGY3MjM0Nzk2OWMyODQ1NjJjMzc0YmQvZG1lc2cteW9jdG8tc25iLTQ0OjIw
MTMxMDA5MDAzOTA1OmkzODYtcmFuZGNvbmZpZy1yOC0xMDA1OjMuMTIuMC1yYzQtMDE1ODct
Zzk3ZDNhYjk6Mzk0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI4LTEwMDUvOTdkM2FiOWIy
MjA3ZDcyZWIwZjcyMzQ3OTY5YzI4NDU2MmMzNzRiZC9kbWVzZy15b2N0by1iZW5zLTE6MjAx
MzEwMDkwMDM5MTI6aTM4Ni1yYW5kY29uZmlnLXI4LTEwMDU6My4xMi4wLXJjNC0wMTU4Ny1n
OTdkM2FiOTozOTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjgtMTAwNS85N2QzYWI5YjIy
MDdkNzJlYjBmNzIzNDc5NjljMjg0NTYyYzM3NGJkL2RtZXNnLXlvY3RvLW5obTQtNDoyMDEz
MTAwODE2NDQxOTppMzg2LXJhbmRjb25maWctcjgtMTAwNTozLjEyLjAtcmM0LTAxNTg3LWc5
N2QzYWI5OjM5NAowOjExOjExIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgo=

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc1-00080-gfb869b6"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0-rc1 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_COMPILE_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
CONFIG_MWINCHIP3D=y
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_OOSTORE=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_LONGRUN=m
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_MMIO=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_I4=y
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SCx200_DOCFLASH=m
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=m
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_PCH_PHUB is not set
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set

#
# Altera FPGA firmware download module
#
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_WISTRON_BTNS=m
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PWM_BEEPER is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_ADXL34X=m
CONFIG_INPUT_CMA3000=y
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=m
# CONFIG_SERIAL_ST_ASC is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_TS5500=m
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS1WM=m
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_ABX500_CORE=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_V4L2_INT_DEVICE=m

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
# CONFIG_LIRC is not set
# CONFIG_IR_NEC_DECODER is not set
# CONFIG_IR_RC5_DECODER is not set
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=y
CONFIG_IR_GPIO_CIR=y
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_RADIO_ADAPTERS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_ATTACH=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#

#
# Customize TV tuners
#

#
# Customise DVB Frontends
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=m
# CONFIG_SOUND_TRACEINIT is not set
CONFIG_SOUND_DMAP=y
CONFIG_SOUND_VMIDI=m
CONFIG_SOUND_TRIX=m
CONFIG_SOUND_MSS=m
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=m
CONFIG_PSS_MIXER=y
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
# CONFIG_SOUND_UART6850 is not set
CONFIG_SOUND_AEDSP16=m
CONFIG_SC6600=y
CONFIG_SC6600_JOY=y
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
# CONFIG_SOUND_KAHLUA is not set

#
# HID support
#
# CONFIG_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_OMAP_HS=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=m
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_PWM=m
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_OT200=m

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
# CONFIG_IIO_KFIFO_BUF is not set
# CONFIG_IIO_TRIGGER is not set

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_TI_AM335X_ADC=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#

#
# Digital to analog converters
#

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#

#
# Inertial measurement units
#

#
# Light sensors
#

#
# Magnetometer sensors
#

#
# Pressure sensors
#

#
# Temperature sensors
#
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=m
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_LOGFS=y
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
# CONFIG_KPROBE_EVENT is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_APPRAISE=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# CONFIG_CRYPTO_CRCT10DIF is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=m
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=m
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=m
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--y0ulUmNC+osPPQO6--
