Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab3JIBJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:09:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:58741 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3JIBJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:09:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1059,1371106800"; 
   d="scan'208";a="407986320"
Date: Wed, 9 Oct 2013 09:09:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>, Jakub Jelinek <jakub@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [x86] BUG: unable to handle kernel NULL pointer dereference at
 (null)
Message-ID: <20131009010911.GA4222@localhost>
References: <CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
 <20131008171522.GA29277@localhost>
 <CA+55aFzQC=W010GTxjXjBnsKO0CycXe7VZB+LTiNNtuBug_rbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzQC=W010GTxjXjBnsKO0CycXe7VZB+LTiNNtuBug_rbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:31:57AM -0700, Linus Torvalds wrote:
> On Tue, Oct 8, 2013 at 10:15 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >
> > [   27.865982] Kernel BUG at c10563af [verbose debug info unavailable]
> 
> Ugh, you've turned off DEBUG_BUGVERBOSE.
> 
> We probably shouldn't even allow that. The space savings aren't worth the pain.

Ah yes, will always turn it on in future. (Was randomly turned on/off due to randconfig..)

> I'm not seeing the pattern in your oopses, there's at least three
> different cases. At a guess, it's some lock - or a memory allocator -
> that is broken by the bitop breakage, and then the oopses are just
> fallout from that..

Here I got the new set of 100 dmesgs with DEBUG_BUGVERBOSE.

Summary:

     53 kernel BUG at kernel/cred.c:138!
     53 invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
     42 BUG: unable to handle kernel NULL pointer dereference at   (null)
     31 Oops: 0000 [#1] DEBUG_PAGEALLOC
     19 Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1
     13 Oops: 0010 [#1] DEBUG_PAGEALLOC
      7 Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6d00 with usage -1
      2 Oops: 0011 [#1] DEBUG_PAGEALLOC
      2 BUG: unable to handle kernel NULL pointer dereference at 00000108
      1 Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6b00 with usage -2
      1 Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6a80 with usage -2
      1 Kernel panic - not syncing: CRED: put_cred_rcu() sees c6d29280 with usage -184
      1 Kernel panic - not syncing: CRED: put_cred_rcu() sees c6d28100 with usage -233
      1 BUG: unable to handle kernel paging request at cd0dcc08
      1 BUG: unable to handle kernel paging request at cd0dc408

First oops dump in each dmesg:

dmesg-quantal-ant-12:20131009083033:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[   26.874938]   No soundcards found.
[   26.947413] debug: unmapping init [mem 0xc14df000-0xc1524fff]
modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory
[   27.189229] BUG: unable to handle kernel NULL pointer dereference at 00000108
[   27.190165] IP: [<c1109200>] rw_verify_area+0xa0/0x1b0
[   27.190529] *pdpt = 0000000006d2c001 *pde = 0000000000000000 
[   27.190529] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   27.190529] Modules linked in:
[   27.190529] CPU: 0 PID: 37 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[   27.190529] task: c6c31160 ti: c6d18000 task.ti: c6d18000
[   27.190529] EIP: 0060:[<c1109200>] EFLAGS: 00000246 CPU: 0
[   27.190529] EIP is at rw_verify_area+0xa0/0x1b0
[   27.190529] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[   27.190529] ESI: 00000000 EDI: c0064cc0 EBP: c6d19f60 ESP: c6d19f38
[   27.190529]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   27.190529] CR0: 8005003b CR2: 00000108 CR3: 06d2b000 CR4: 000006b0
[   27.190529] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   27.190529] DR6: 00000000 DR7: 00000000
[   27.190529] Stack:
[   27.190529]  00000000 c6c70c00 000000a9 00000001 00000000 00000000 00000000 0000006e
[   27.190529]  00000000 c0064cc0 c6d19f88 c1109519 0000006e 00000030 c1307b0e c6d19f98
[   27.190529]  b7772000 c0064cc0 00000000 b7772000 c6d19fac c1109b79 c6d19f98 0000006e
[   27.190529] Call Trace:
[   27.190529]  [<c1109519>] vfs_write+0xb9/0x1a0
[   27.190529]  [<c1307b0e>] ? restore_all+0xf/0xf
[   27.190529]  [<c1109b79>] SyS_write+0x49/0xa0
[   27.190529]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[   27.190529] Code: d6 c1 ee 1f 89 f2 81 e2 ff 00 00 00 31 c9 b8 04 e9 4c c1 e8 d3 ee f9 ff 89 f0 84 c0 74 0a f6 47 41 20 0f 84 03 01 00 00 8b 45 f0 <8b> 80 08 01 00 00 85 c0 74 0c 8b 45 f0 8b 40 14 f6 40 30 40 75
[   27.190529] EIP: [<c1109200>] rw_verify_area+0xa0/0x1b0 SS:ESP 0068:c6d19f38
[   27.190529] CR2: 0000000000000108
[   27.216510] ---[ end trace 22befdde0740782e ]---


dmesg-quantal-ant-13:20131009083038:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory


[   27.092532] BUG: unable to handle kernel NULL pointer dereference at 00000108
[   27.093449] IP: [<c1109200>] rw_verify_area+0xa0/0x1b0
[   27.094162] *pdpt = 0000000006d2c001 *pde = 0000000000000000 
[   27.094162] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   27.094162] Modules linked in:
[   27.094162] CPU: 0 PID: 37 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[   27.094162] task: c6c31160 ti: c6d18000 task.ti: c6d18000
[   27.094162] EIP: 0060:[<c1109200>] EFLAGS: 00000246 CPU: 0
[   27.094162] EIP is at rw_verify_area+0xa0/0x1b0
[   27.094162] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[   27.094162] ESI: 00000000 EDI: c0064cc0 EBP: c6d19f60 ESP: c6d19f38
[   27.094162]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   27.094162] CR0: 8005003b CR2: 00000108 CR3: 06d2b000 CR4: 000006b0
[   27.094162] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   27.094162] DR6: 00000000 DR7: 00000000
[   27.094162] Stack:
[   27.094162]  00000002 00000000 00000000 00000001 00000000 00000000 00000000 00000002
[   27.094162]  00000000 c0064cc0 c6d19f88 c1109519 00000002 00000000 c1307b0e c6d19f98
[   27.094162]  b7792000 c0064cc0 00000000 b7792000 c6d19fac c1109b79 c6d19f98 00000002
[   27.094162] Call Trace:
[   27.094162]  [<c1109519>] vfs_write+0xb9/0x1a0
[   27.094162]  [<c1307b0e>] ? restore_all+0xf/0xf
[   27.094162]  [<c1109b79>] SyS_write+0x49/0xa0
[   27.094162]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[   27.094162] Code: d6 c1 ee 1f 89 f2 81 e2 ff 00 00 00 31 c9 b8 04 e9 4c c1 e8 d3 ee f9 ff 89 f0 84 c0 74 0a f6 47 41 20 0f 84 03 01 00 00 8b 45 f0 <8b> 80 08 01 00 00 85 c0 74 0c 8b 45 f0 8b 40 14 f6 40 30 40 75
[   27.094162] EIP: [<c1109200>] rw_verify_area+0xa0/0x1b0 SS:ESP 0068:c6d19f38
[   27.094162] CR2: 0000000000000108
[   27.119392] ---[ end trace 2bb714af200792b7 ]---
[   27.144424] Kernel panic - not syncing: CRED: put_cred_rcu() sees c6d28100 with usage -233

dmesg-quantal-ant-9:20131009083014:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1


[   26.385658] VFS: Close: file count is 0

[   26.427323] Kernel panic - not syncing: CRED: put_cred_rcu() sees c6d29280 with usage -184
[   26.427323] 
[   26.428852] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[   26.429851]  c6d29280 c0041e6c c1301381 c0041e8c c12fdceb c1402ea8 c1533f80 00000293
[   26.429851]  c6d292d8 c6d29280 00000293 c0041ea8 c1056641 c1403e6c c6d29280 ffffff48
[   26.429851]  c6d292d8 c6d29158 c0041ebc c1092942 c0031160 00000009 c0040000 c0041ec4
[   26.429851] Call Trace:
[   26.429851]  [<c1301381>] dump_stack+0x16/0x18
[   26.429851]  [<c12fdceb>] panic+0x8c/0x17c
[   26.429851]  [<c1056641>] put_cred_rcu+0x91/0xa0
[   26.429851]  [<c1092942>] __rcu_process_callbacks+0x62/0xc0
[   26.429851]  [<c10929b2>] rcu_process_callbacks+0x12/0x20
[   26.429851]  [<c10351c8>] __do_softirq+0xc8/0x210
[   26.429851]  [<c1196294>] ? trace_hardirqs_on_thunk+0xc/0x10
[   26.429851]  [<c109313e>] ? rcu_irq_exit+0xee/0x130
[   26.429851]  [<c1035351>] ? run_ksoftirqd+0x41/0x60
[   26.429851]  [<c1035345>] run_ksoftirqd+0x35/0x60
[   26.429851]  [<c10587d3>] smpboot_thread_fn+0xf3/0x190
[   26.429851]  [<c10586e0>] ? lg_global_unlock+0x30/0x30
[   26.429851]  [<c1050c42>] kthread+0x92/0xa0
[   26.429851]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[   26.429851]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0


dmesg-quantal-bens-3:20131009082943:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    2.268582] ------------[ cut here ]------------
[    2.269353] kernel BUG at kernel/cred.c:138!
[    2.270402] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.271287] Modules linked in:
[    2.271456] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    2.271456] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    2.271456] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    2.271456] EIP is at __put_cred+0x56/0x90
[    2.271456] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    2.271456] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    2.271456]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.271456] CR0: 8005003b CR2: b779e000 CR3: 06d1e000 CR4: 000006b0
[    2.271456] Stack:
[    2.271456]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    2.271456]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    2.271456]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    2.271456] Call Trace:
[    2.271456]  [<c110a678>] file_free_rcu+0x28/0x40
[    2.271456]  [<c104d7d9>] task_work_run+0x79/0xa0
[    2.271456]  [<c10311d2>] do_exit+0x2f2/0x960
[    2.271456]  [<c110a8a6>] ? __fput+0x216/0x380
[    2.271456]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    2.271456]  [<c1032838>] SyS_exit_group+0x18/0x20
[    2.271456]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    2.271456] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    2.271456] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    2.295544] ---[ end trace a3de6cf436968a03 ]---
[    2.296305] Fixing recursive fault but reboot is needed!

dmesg-quantal-cairo-13:20131009082930:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.135621] ------------[ cut here ]------------
[    1.135783] kernel BUG at kernel/cred.c:138!
[    1.135783] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.135783] Modules linked in:
[    1.135783] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.135783] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.135783] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.135783] EIP is at __put_cred+0x56/0x90
[    1.135783] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.135783] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.135783]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.135783] CR0: 8005003b CR2: b7737000 CR3: 06d1e000 CR4: 000006b0
[    1.135783] Stack:
[    1.135783]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.135783]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.135783]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.135783] Call Trace:
[    1.135783]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.135783]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.135783]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.135783]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.135783]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.135783]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.135783]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.135783] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.135783] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.151317] ---[ end trace 38eec569d1938da4 ]---
[    1.151773] Fixing recursive fault but reboot is needed!

dmesg-quantal-cairo-22:20131009083037:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.112717] ------------[ cut here ]------------
[    1.112954] kernel BUG at kernel/cred.c:138!
[    1.112954] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.112954] Modules linked in:
[    1.112954] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.112954] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.112954] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.112954] EIP is at __put_cred+0x56/0x90
[    1.112954] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.112954] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.112954]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.112954] CR0: 8005003b CR2: b7728000 CR3: 06d1e000 CR4: 000006b0
[    1.112954] Stack:
[    1.112954]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.112954]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.112954]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.112954] Call Trace:
[    1.112954]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.112954]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.112954]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.112954]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.112954]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.112954]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.112954]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.112954] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.112954] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.128337] ---[ end trace fd184ac698a97fbc ]---
[    1.128782] Fixing recursive fault but reboot is needed!

dmesg-quantal-cairo-24:20131009083033:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.153145] ------------[ cut here ]------------
[    1.153623] kernel BUG at kernel/cred.c:138!
[    1.154236] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.154236] Modules linked in:
[    1.154236] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.154236] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.154236] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.154236] EIP is at __put_cred+0x56/0x90
[    1.154236] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.154236] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.154236]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.154236] CR0: 8005003b CR2: b777a000 CR3: 06d1e000 CR4: 000006b0
[    1.154236] Stack:
[    1.154236]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.154236]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.154236]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.154236] Call Trace:
[    1.154236]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.154236]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.154236]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.154236]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.154236]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.154236]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.154236]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.154236] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.154236] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.169448] ---[ end trace 50e2047aac671e3f ]---
[    1.169900] Fixing recursive fault but reboot is needed!

dmesg-quantal-cairo-33:20131009082955:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.123293] ------------[ cut here ]------------
[    1.123563] kernel BUG at kernel/cred.c:138!
[    1.123563] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.123563] Modules linked in:
[    1.123563] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.123563] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.123563] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.123563] EIP is at __put_cred+0x56/0x90
[    1.123563] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.123563] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.123563]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.123563] CR0: 8005003b CR2: b77ae000 CR3: 06d1e000 CR4: 000006b0
[    1.123563] Stack:
[    1.123563]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.123563]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.123563]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.123563] Call Trace:
[    1.123563]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.123563]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.123563]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.123563]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.123563]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.123563]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.123563]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.123563] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.123563] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.143604] ---[ end trace 91b0b65f94c59b56 ]---
[    1.144073] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-10:20131009083017:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.962733] ------------[ cut here ]------------
[    0.963146] kernel BUG at kernel/cred.c:138!
[    0.963693] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.964156] Modules linked in:
[    0.964437] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.964711] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.964711] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.964711] EIP is at __put_cred+0x56/0x90
[    0.964711] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.964711] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.964711]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.964711] CR0: 8005003b CR2: b77b6000 CR3: 06d1e000 CR4: 000006b0
[    0.964711] Stack:
[    0.964711]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.964711]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.964711]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.964711] Call Trace:
[    0.964711]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.964711]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.964711]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.964711]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.964711]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.964711]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.964711]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.964711] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.964711] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    0.976567] ---[ end trace 0cff5600ae12fa6a ]---
[    0.976970] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-10:20131009083046:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.998718] ------------[ cut here ]------------
[    0.999107] kernel BUG at kernel/cred.c:138!
[    0.999617] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.000053] Modules linked in:
[    1.000315] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.000917] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.001354] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.001354] EIP is at __put_cred+0x56/0x90
[    1.001354] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.001354] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.001354]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.001354] CR0: 8005003b CR2: b7725000 CR3: 06d1e000 CR4: 000006b0
[    1.001354] Stack:
[    1.001354]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.001354]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.001354]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.001354] Call Trace:
[    1.001354]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.001354]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.001354]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.001354]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.001354]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.001354]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.001354]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.001354] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.001354] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.011887] ---[ end trace 3d22c23b9f09a820 ]---
[    1.012260] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-11:20131009082919:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.888031] ------------[ cut here ]------------
[    0.888200] kernel BUG at kernel/cred.c:138!
[    0.888200] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.888200] Modules linked in:
[    0.888200] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.888200] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.888200] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.888200] EIP is at __put_cred+0x56/0x90
[    0.888200] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.888200] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.888200]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.888200] CR0: 8005003b CR2: b77d1000 CR3: 06d1e000 CR4: 000006b0
[    0.888200] Stack:
[    0.888200]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.888200]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.888200]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.888200] Call Trace:
[    0.888200]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.888200]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.888200]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.888200]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.888200]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.888200]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.888200]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.888200] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.888200] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    0.899760] ---[ end trace 9a6328c0b52429fd ]---
[    0.900100] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-11:20131009082959:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.952986] ------------[ cut here ]------------
[    0.953386] kernel BUG at kernel/cred.c:138!
[    0.953592] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.953592] Modules linked in:
[    0.953592] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.953592] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.953592] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.953592] EIP is at __put_cred+0x56/0x90
[    0.953592] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.953592] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.953592]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.953592] CR0: 8005003b CR2: b773a000 CR3: 06d1e000 CR4: 000006b0
[    0.953592] Stack:
[    0.953592]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.953592]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.953592]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.953592] Call Trace:
[    0.953592]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.953592]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.953592]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.953592]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.953592]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.953592]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.953592]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.953592] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.953592] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    0.966456] ---[ end trace c173b35c9b101412 ]---
[    0.966844] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-11:20131009083034:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.955160] ------------[ cut here ]------------
[    0.955536] kernel BUG at kernel/cred.c:138!
[    0.956108] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.956531] Modules linked in:
[    0.956809] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.957415] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.957875] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.958307] EIP is at __put_cred+0x56/0x90
[    0.958432] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.958432] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.958432]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.958432] CR0: 8005003b CR2: b775b000 CR3: 06d1e000 CR4: 000006b0
[    0.958432] Stack:
[    0.958432]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.958432]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.958432]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.958432] Call Trace:
[    0.958432]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.958432]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.958432]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.958432]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.958432]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.958432]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.958432]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.958432] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.958432] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    0.968706] ---[ end trace 2a42ce5a98fb95b1 ]---
[    0.969107] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-19:20131009083025:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.991460] ------------[ cut here ]------------
[    0.991864] kernel BUG at kernel/cred.c:138!
[    0.992413] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.992866] Modules linked in:
[    0.992985] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.992985] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.992985] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.992985] EIP is at __put_cred+0x56/0x90
[    0.992985] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.992985] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.992985]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.992985] CR0: 8005003b CR2: b77a3000 CR3: 06d1e000 CR4: 000006b0
[    0.992985] Stack:
[    0.992985]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.992985]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.992985]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.992985] Call Trace:
[    0.992985]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.992985]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.992985]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.992985]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.992985]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.992985]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.992985]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.992985] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.992985] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.005137] ---[ end trace 20d6a5e900451e9c ]---
[    1.005534] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-23:20131009083004:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.882992] ------------[ cut here ]------------
[    0.883362] kernel BUG at kernel/cred.c:138!
[    0.883483] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.883483] Modules linked in:
[    0.883483] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.883483] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.883483] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.883483] EIP is at __put_cred+0x56/0x90
[    0.883483] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.883483] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.883483]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.883483] CR0: 8005003b CR2: b775e000 CR3: 06d1e000 CR4: 000006b0
[    0.883483] Stack:
[    0.883483]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.883483]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.883483]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.883483] Call Trace:
[    0.883483]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.883483]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.883483]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.883483]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.883483]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.883483]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.883483]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.883483] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.883483] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    0.895298] ---[ end trace 5ff84eada961bbe0 ]---
[    0.895657] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-27:20131009082953:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.894829] ------------[ cut here ]------------
[    0.895201] kernel BUG at kernel/cred.c:138!
[    0.895709] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.896127] Modules linked in:
[    0.896383] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.896974] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.897393] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.897708] EIP is at __put_cred+0x56/0x90
[    0.897708] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.897708] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.897708]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.897708] CR0: 8005003b CR2: b7715000 CR3: 06d1e000 CR4: 000006b0
[    0.897708] Stack:
[    0.897708]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.897708]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.897708]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.897708] Call Trace:
[    0.897708]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.897708]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.897708]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.897708]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.897708]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.897708]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.897708]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.897708] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.897708] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    0.907572] ---[ end trace 1d83451c0cb952ef ]---
[    0.908004] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-28:20131009083000:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.988359] ------------[ cut here ]------------
[    0.988513] kernel BUG at kernel/cred.c:138!
[    0.988513] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.988513] Modules linked in:
[    0.988513] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.988513] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.988513] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.988513] EIP is at __put_cred+0x56/0x90
[    0.988513] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.988513] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.988513]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.988513] CR0: 8005003b CR2: b76f0000 CR3: 06d1e000 CR4: 000006b0
[    0.988513] Stack:
[    0.988513]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.988513]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.988513]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.988513] Call Trace:
[    0.988513]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.988513]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.988513]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.988513]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.988513]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.988513]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.988513]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.988513] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.988513] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.001452] ---[ end trace 9ac2dd9a66eec0e0 ]---
[    1.001898] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-2:20131009082911:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.108180] ------------[ cut here ]------------
[    1.108621] kernel BUG at kernel/cred.c:138!
[    1.109218] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.109715] Modules linked in:
[    1.110023] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.110711] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.111209] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.111319] EIP is at __put_cred+0x56/0x90
[    1.111319] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.111319] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.111319]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.111319] CR0: 8005003b CR2: b76f5000 CR3: 06d1e000 CR4: 000006b0
[    1.111319] Stack:
[    1.111319]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.111319]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.111319]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.111319] Call Trace:
[    1.111319]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.111319]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.111319]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.111319]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.111319]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.111319]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.111319]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.111319] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.111319] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.123117] ---[ end trace 9e8ea8004d1d2e91 ]---
[    1.123548] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-2:20131009082950:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.925433] ------------[ cut here ]------------
[    0.925785] kernel BUG at kernel/cred.c:138!
[    0.926256] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.926654] Modules linked in:
[    0.926896] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.927451] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.927943] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.928141] EIP is at __put_cred+0x56/0x90
[    0.928141] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.928141] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.928141]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.928141] CR0: 8005003b CR2: b771d000 CR3: 06d1e000 CR4: 000006b0
[    0.928141] Stack:
[    0.928141]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.928141]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.928141]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.928141] Call Trace:
[    0.928141]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.928141]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.928141]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.928141]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.928141]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.928141]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.928141]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.928141] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.928141] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    0.937198] ---[ end trace ddb5714942bd4736 ]---
[    0.937544] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-34:20131009083013:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.037940] ------------[ cut here ]------------
[    1.038094] kernel BUG at kernel/cred.c:138!
[    1.038094] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.038094] Modules linked in:
[    1.038094] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.038094] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.038094] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.038094] EIP is at __put_cred+0x56/0x90
[    1.038094] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.038094] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.038094]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.038094] CR0: 8005003b CR2: b7782000 CR3: 06d1e000 CR4: 000006b0
[    1.038094] Stack:
[    1.038094]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.038094]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.038094]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.038094] Call Trace:
[    1.038094]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.038094]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.038094]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.038094]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.038094]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.038094]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.038094]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.038094] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.038094] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.051035] ---[ end trace b78a771439c9a685 ]---
[    1.051451] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-39:20131009083045:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.015270] ------------[ cut here ]------------
[    1.015695] kernel BUG at kernel/cred.c:138!
[    1.016189] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.016189] Modules linked in:
[    1.016189] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.016189] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.016189] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.016189] EIP is at __put_cred+0x56/0x90
[    1.016189] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.016189] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.016189]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.016189] CR0: 8005003b CR2: b7775000 CR3: 06d1e000 CR4: 000006b0
[    1.016189] Stack:
[    1.016189]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.016189]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.016189]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.016189] Call Trace:
[    1.016189]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.016189]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.016189]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.016189]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.016189]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.016189]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.016189]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.016189] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.016189] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.028301] ---[ end trace 989bdfa831fbd776 ]---
[    1.028745] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-44:20131009083043:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.926919] ------------[ cut here ]------------
[    0.927291] kernel BUG at kernel/cred.c:138!
[    0.927707] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.927707] Modules linked in:
[    0.927707] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.927707] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.927707] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.927707] EIP is at __put_cred+0x56/0x90
[    0.927707] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.927707] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.927707]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.927707] CR0: 8005003b CR2: b77cb000 CR3: 06d1e000 CR4: 000006b0
[    0.927707] Stack:
[    0.927707]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.927707]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.927707]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.927707] Call Trace:
[    0.927707]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.927707]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.927707]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.927707]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.927707]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.927707]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.927707]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.927707] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.927707] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    0.939538] ---[ end trace 799bfb3cd9dae4f8 ]---
[    0.939907] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-46:20131009083026:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.939364] ------------[ cut here ]------------
[    0.939749] kernel BUG at kernel/cred.c:138!
[    0.940241] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.940433] Modules linked in:
[    0.940433] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.940433] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.940433] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.940433] EIP is at __put_cred+0x56/0x90
[    0.940433] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.940433] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.940433]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.940433] CR0: 8005003b CR2: b7772000 CR3: 06d1e000 CR4: 000006b0
[    0.940433] Stack:
[    0.940433]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.940433]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.940433]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.940433] Call Trace:
[    0.940433]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.940433]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.940433]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.940433]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.940433]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.940433]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.940433]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.940433] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.940433] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    0.951713] ---[ end trace c8ed5a640a0f5929 ]---
[    0.952074] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-47:20131009083039:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.981110] ------------[ cut here ]------------
[    0.981492] kernel BUG at kernel/cred.c:138!
[    0.982018] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.982446] Modules linked in:
[    0.982750] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.982750] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.982750] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.982750] EIP is at __put_cred+0x56/0x90
[    0.982750] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.982750] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.982750]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.982750] CR0: 8005003b CR2: b776f000 CR3: 06d1e000 CR4: 000006b0
[    0.982750] Stack:
[    0.982750]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.982750]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.982750]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.982750] Call Trace:
[    0.982750]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.982750]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.982750]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.982750]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.982750]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.982750]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.982750]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.982750] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.982750] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    0.994204] ---[ end trace 0be85597c1e160f7 ]---
[    0.994578] Fixing recursive fault but reboot is needed!

dmesg-quantal-inn-6:20131009083024:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.940191] ------------[ cut here ]------------
[    0.940466] kernel BUG at kernel/cred.c:138!
[    0.940466] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.940466] Modules linked in:
[    0.940466] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.940466] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    0.940466] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.940466] EIP is at __put_cred+0x56/0x90
[    0.940466] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    0.940466] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    0.940466]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.940466] CR0: 8005003b CR2: b7778000 CR3: 06d1e000 CR4: 000006b0
[    0.940466] Stack:
[    0.940466]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    0.940466]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    0.940466]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    0.940466] Call Trace:
[    0.940466]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.940466]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.940466]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.940466]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.940466]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.940466]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.940466]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.940466] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.940466] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    0.952421] ---[ end trace f6790d9b0982f4ad ]---
[    0.952766] Fixing recursive fault but reboot is needed!

dmesg-quantal-jaketown-14:20131009083036:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    3.729442] ------------[ cut here ]------------
[    3.731501] kernel BUG at kernel/cred.c:138!
[    3.731646] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    3.731646] Modules linked in:
[    3.731646] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    3.731646] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    3.731646] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    3.731646] EIP is at __put_cred+0x56/0x90
[    3.731646] EAX: c14c3720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    3.731646] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    3.731646]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    3.731646] CR0: 8005003b CR2: b77af000 CR3: 06d12000 CR4: 000006b0
[    3.731646] Stack:
[    3.731646]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a678 c006ed00 c6d17f44 c104d7d9
[    3.731646]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c10311d2 00000000 c6d17f80 c110a8a6
[    3.731646]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    3.731646] Call Trace:
[    3.731646]  [<c110a678>] file_free_rcu+0x28/0x40
[    3.731646]  [<c104d7d9>] task_work_run+0x79/0xa0
[    3.731646]  [<c10311d2>] do_exit+0x2f2/0x960
[    3.731646]  [<c110a8a6>] ? __fput+0x216/0x380
[    3.731646]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    3.731646]  [<c1032838>] SyS_exit_group+0x18/0x20
[    3.731646]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    3.731646] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    3.731646] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d17f18
[    3.798770] ---[ end trace d4ea3bd32256ce77 ]---
[    3.800768] Fixing recursive fault but reboot is needed!

dmesg-quantal-jaketown-24:20131009082937:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    3.101013] ------------[ cut here ]------------
[    3.102243] kernel BUG at kernel/cred.c:138!
[    3.103409] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    3.103409] Modules linked in:
[    3.103409] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    3.103409] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    3.103409] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    3.103409] EIP is at __put_cred+0x56/0x90
[    3.103409] EAX: c14c3720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    3.103409] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    3.103409]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    3.103409] CR0: 8005003b CR2: bfab1fe8 CR3: 06d12000 CR4: 000006b0
[    3.103409] Stack:
[    3.103409]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a678 c006ed00 c6d17f44 c104d7d9
[    3.103409]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c10311d2 00000000 c6d17f80 c110a8a6
[    3.103409]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    3.103409] Call Trace:
[    3.103409]  [<c110a678>] file_free_rcu+0x28/0x40
[    3.103409]  [<c104d7d9>] task_work_run+0x79/0xa0
[    3.103409]  [<c10311d2>] do_exit+0x2f2/0x960
[    3.103409]  [<c110a8a6>] ? __fput+0x216/0x380
[    3.103409]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    3.103409]  [<c1032838>] SyS_exit_group+0x18/0x20
[    3.103409]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    3.103409] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    3.103409] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d17f18
[    3.142873] ---[ end trace 93e1e854462d0bf5 ]---
[    3.144183] Fixing recursive fault but reboot is needed!

dmesg-quantal-jaketown-36:20131009082956:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    3.597372] ------------[ cut here ]------------
[    3.599193] kernel BUG at kernel/cred.c:138!
[    3.600469] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    3.600469] Modules linked in:
[    3.600469] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    3.600469] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    3.600469] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    3.600469] EIP is at __put_cred+0x56/0x90
[    3.600469] EAX: c14c3720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    3.600469] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    3.600469]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    3.600469] CR0: 8005003b CR2: b7778000 CR3: 06d12000 CR4: 000006b0
[    3.600469] Stack:
[    3.600469]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a678 c006ed00 c6d17f44 c104d7d9
[    3.600469]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c10311d2 00000000 c6d17f80 c110a8a6
[    3.600469]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    3.600469] Call Trace:
[    3.600469]  [<c110a678>] file_free_rcu+0x28/0x40
[    3.600469]  [<c104d7d9>] task_work_run+0x79/0xa0
[    3.600469]  [<c10311d2>] do_exit+0x2f2/0x960
[    3.600469]  [<c110a8a6>] ? __fput+0x216/0x380
[    3.600469]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    3.600469]  [<c1032838>] SyS_exit_group+0x18/0x20
[    3.600469]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    3.600469] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    3.600469] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d17f18
[    3.660723] ---[ end trace a74e540bbc8c14e0 ]---
[    3.662884] Fixing recursive fault but reboot is needed!

dmesg-quantal-jaketown-3:20131009083032:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    3.635049] ------------[ cut here ]------------
[    3.637062] kernel BUG at kernel/cred.c:138!
[    3.637162] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    3.637162] Modules linked in:
[    3.637162] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    3.637162] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    3.637162] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    3.637162] EIP is at __put_cred+0x56/0x90
[    3.637162] EAX: c14c3720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    3.637162] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    3.637162]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    3.637162] CR0: 8005003b CR2: b7787000 CR3: 06d12000 CR4: 000006b0
[    3.637162] Stack:
[    3.637162]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a678 c006ed00 c6d17f44 c104d7d9
[    3.637162]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c10311d2 00000000 c6d17f80 c110a8a6
[    3.637162]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    3.637162] Call Trace:
[    3.637162]  [<c110a678>] file_free_rcu+0x28/0x40
[    3.637162]  [<c104d7d9>] task_work_run+0x79/0xa0
[    3.637162]  [<c10311d2>] do_exit+0x2f2/0x960
[    3.637162]  [<c110a8a6>] ? __fput+0x216/0x380
[    3.637162]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    3.637162]  [<c1032838>] SyS_exit_group+0x18/0x20
[    3.637162]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    3.637162] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    3.637162] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d17f18
[    3.703278] ---[ end trace 6a2dbe544903d737 ]---
[    3.705295] Fixing recursive fault but reboot is needed!

dmesg-quantal-jaketown-43:20131009083041:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    3.606671] ------------[ cut here ]------------
[    3.608216] kernel BUG at kernel/cred.c:138!
[    3.608216] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    3.608216] Modules linked in:
[    3.608216] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    3.608216] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    3.608216] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    3.608216] EIP is at __put_cred+0x56/0x90
[    3.608216] EAX: c14c3720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    3.608216] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    3.608216]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    3.608216] CR0: 8005003b CR2: b77a4000 CR3: 06d12000 CR4: 000006b0
[    3.608216] Stack:
[    3.608216]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a678 c006ed00 c6d17f44 c104d7d9
[    3.608216]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c10311d2 00000000 c6d17f80 c110a8a6
[    3.608216]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    3.608216] Call Trace:
[    3.608216]  [<c110a678>] file_free_rcu+0x28/0x40
[    3.608216]  [<c104d7d9>] task_work_run+0x79/0xa0
[    3.608216]  [<c10311d2>] do_exit+0x2f2/0x960
[    3.608216]  [<c110a8a6>] ? __fput+0x216/0x380
[    3.608216]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    3.608216]  [<c1032838>] SyS_exit_group+0x18/0x20
[    3.608216]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    3.608216] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    3.608216] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d17f18
[    3.677889] ---[ end trace 3635cf3e99716285 ]---
[    3.680041] Fixing recursive fault but reboot is needed!

dmesg-quantal-jaketown-45:20131009083009:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    3.654877] ------------[ cut here ]------------
[    3.656772] kernel BUG at kernel/cred.c:138!
[    3.656772] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    3.656772] Modules linked in:
[    3.656772] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    3.656772] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    3.656772] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    3.656772] EIP is at __put_cred+0x56/0x90
[    3.656772] EAX: c14c3720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    3.656772] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    3.656772]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    3.656772] CR0: 8005003b CR2: b76f3000 CR3: 06d12000 CR4: 000006b0
[    3.656772] Stack:
[    3.656772]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a678 c006ed00 c6d17f44 c104d7d9
[    3.656772]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c10311d2 00000000 c6d17f80 c110a8a6
[    3.656772]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    3.656772] Call Trace:
[    3.656772]  [<c110a678>] file_free_rcu+0x28/0x40
[    3.656772]  [<c104d7d9>] task_work_run+0x79/0xa0
[    3.656772]  [<c10311d2>] do_exit+0x2f2/0x960
[    3.656772]  [<c110a8a6>] ? __fput+0x216/0x380
[    3.656772]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    3.656772]  [<c1032838>] SyS_exit_group+0x18/0x20
[    3.656772]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    3.656772] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    3.656772] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d17f18
[    3.722735] ---[ end trace 3f09cc8c57ae58ba ]---
[    3.724859] Fixing recursive fault but reboot is needed!

dmesg-quantal-lkp-st01-8:20131009083023:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    2.192466] ------------[ cut here ]------------
[    2.193203] kernel BUG at kernel/cred.c:138!
[    2.194201] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.194739] Modules linked in:
[    2.194739] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    2.194739] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    2.194739] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    2.194739] EIP is at __put_cred+0x56/0x90
[    2.194739] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    2.194739] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    2.194739]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.194739] CR0: 8005003b CR2: b76ee000 CR3: 06d1e000 CR4: 000006b0
[    2.194739] Stack:
[    2.194739]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    2.194739]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    2.194739]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    2.194739] Call Trace:
[    2.194739]  [<c110a678>] file_free_rcu+0x28/0x40
[    2.194739]  [<c104d7d9>] task_work_run+0x79/0xa0
[    2.194739]  [<c10311d2>] do_exit+0x2f2/0x960
[    2.194739]  [<c110a8a6>] ? __fput+0x216/0x380
[    2.194739]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    2.194739]  [<c1032838>] SyS_exit_group+0x18/0x20
[    2.194739]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    2.194739] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    2.194739] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    2.218314] ---[ end trace 366043f64f01e8ee ]---
[    2.219045] Fixing recursive fault but reboot is needed!

dmesg-quantal-lkp-tt02-15:20131008230210:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    2.379238] ------------[ cut here ]------------
[    2.380183] kernel BUG at kernel/cred.c:138!
[    2.381466] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.381912] Modules linked in:
[    2.381912] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    2.381912] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    2.381912] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    2.381912] EIP is at __put_cred+0x56/0x90
[    2.381912] EAX: c14c3720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    2.381912] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    2.381912]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.381912] CR0: 8005003b CR2: b770d000 CR3: 06d12000 CR4: 000006b0
[    2.381912] Stack:
[    2.381912]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a678 c006ed00 c6d17f44 c104d7d9
[    2.381912]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c10311d2 00000000 c6d17f80 c110a8a6
[    2.381912]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    2.381912] Call Trace:
[    2.381912]  [<c110a678>] file_free_rcu+0x28/0x40
[    2.381912]  [<c104d7d9>] task_work_run+0x79/0xa0
[    2.381912]  [<c10311d2>] do_exit+0x2f2/0x960
[    2.381912]  [<c110a8a6>] ? __fput+0x216/0x380
[    2.381912]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    2.381912]  [<c1032838>] SyS_exit_group+0x18/0x20
[    2.381912]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    2.381912] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    2.381912] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d17f18
[    2.413399] ---[ end trace a336c8b3db89df5e ]---
[    2.414332] Fixing recursive fault but reboot is needed!

dmesg-quantal-lkp-tt02-1:20131008230114:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    2.375013] ------------[ cut here ]------------
[    2.376110] kernel BUG at kernel/cred.c:138!
[    2.376223] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.376223] Modules linked in:
[    2.376223] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    2.376223] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    2.376223] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    2.376223] EIP is at __put_cred+0x56/0x90
[    2.376223] EAX: c14c3720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    2.376223] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    2.376223]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.376223] CR0: 8005003b CR2: b779c000 CR3: 06d12000 CR4: 000006b0
[    2.376223] Stack:
[    2.376223]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a678 c006ed00 c6d17f44 c104d7d9
[    2.376223]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c10311d2 00000000 c6d17f80 c110a8a6
[    2.376223]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    2.376223] Call Trace:
[    2.376223]  [<c110a678>] file_free_rcu+0x28/0x40
[    2.376223]  [<c104d7d9>] task_work_run+0x79/0xa0
[    2.376223]  [<c10311d2>] do_exit+0x2f2/0x960
[    2.376223]  [<c110a8a6>] ? __fput+0x216/0x380
[    2.376223]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    2.376223]  [<c1032838>] SyS_exit_group+0x18/0x20
[    2.376223]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    2.376223] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    2.376223] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d17f18
[    2.409111] ---[ end trace 15e91cbb155c85af ]---
[    2.410031] Fixing recursive fault but reboot is needed!

dmesg-quantal-lkp-tt02-3:20131008230155:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    2.378589] ------------[ cut here ]------------
[    2.379533] kernel BUG at kernel/cred.c:138!
[    2.380830] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.381639] Modules linked in:
[    2.381639] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    2.381639] task: c6c2a2c0 ti: c6d16000 task.ti: c6d16000
[    2.381639] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    2.381639] EIP is at __put_cred+0x56/0x90
[    2.381639] EAX: c14c3720 EBX: c6d11080 ECX: 00000000 EDX: 00000001
[    2.381639] ESI: c6c2a2c0 EDI: 00000001 EBP: c6d17f24 ESP: c6d17f18
[    2.381639]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.381639] CR0: 8005003b CR2: b779f000 CR3: 06d12000 CR4: 000006b0
[    2.381639] Stack:
[    2.381639]  c006ee00 c6c2a558 c6c2a2c0 c6d17f30 c110a678 c006ed00 c6d17f44 c104d7d9
[    2.381639]  c6c2a570 c6d18000 c6c2a2c0 c6d17f8c c10311d2 00000000 c6d17f80 c110a8a6
[    2.381639]  00000001 00000001 00000000 00000246 00000001 c6c2a558 c6d18050 c6c2a2c0
[    2.381639] Call Trace:
[    2.381639]  [<c110a678>] file_free_rcu+0x28/0x40
[    2.381639]  [<c104d7d9>] task_work_run+0x79/0xa0
[    2.381639]  [<c10311d2>] do_exit+0x2f2/0x960
[    2.381639]  [<c110a8a6>] ? __fput+0x216/0x380
[    2.381639]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    2.381639]  [<c1032838>] SyS_exit_group+0x18/0x20
[    2.381639]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    2.381639] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    2.381639] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d17f18
[    2.412645] ---[ end trace 3eed1ab81a840f9b ]---
[    2.413568] Fixing recursive fault but reboot is needed!

dmesg-quantal-nhm4-3:20131009003525:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.925097] ------------[ cut here ]------------
[    0.925493] kernel BUG at kernel/cred.c:138!
[    0.926026] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.926466] Modules linked in:
[    0.926740] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.927357] task: c6c322c0 ti: c6d2a000 task.ti: c6d2a000
[    0.927806] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.927866] EIP is at __put_cred+0x56/0x90
[    0.927866] EAX: c14c3720 EBX: c6d17400 ECX: 00000000 EDX: 00000001
[    0.927866] ESI: c6c322c0 EDI: 00000001 EBP: c6d2bf24 ESP: c6d2bf18
[    0.927866]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.927866] CR0: 8005003b CR2: bfce7ff0 CR3: 06d19000 CR4: 000006b0
[    0.927866] Stack:
[    0.927866]  c006ee00 c6c32558 c6c322c0 c6d2bf30 c110a678 c006ed00 c6d2bf44 c104d7d9
[    0.927866]  c6c32570 c6d2c000 c6c322c0 c6d2bf8c c10311d2 00000000 c6d2bf80 c110a8a6
[    0.927866]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d2c050 c6c322c0
[    0.927866] Call Trace:
[    0.927866]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.927866]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.927866]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.927866]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.927866]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.927866]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.927866]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.927866] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.927866] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d2bf18
[    0.938659] ---[ end trace 3b2f487beedf4727 ]---
[    0.939045] Fixing recursive fault but reboot is needed!

dmesg-quantal-nhm4-5:20131009003430:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.924386] ------------[ cut here ]------------
[    0.924582] kernel BUG at kernel/cred.c:138!
[    0.924582] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.924582] Modules linked in:
[    0.924582] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.924582] task: c6c322c0 ti: c6d2a000 task.ti: c6d2a000
[    0.924582] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.924582] EIP is at __put_cred+0x56/0x90
[    0.924582] EAX: c14c3720 EBX: c6d17400 ECX: 00000000 EDX: 00000001
[    0.924582] ESI: c6c322c0 EDI: 00000001 EBP: c6d2bf24 ESP: c6d2bf18
[    0.924582]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.924582] CR0: 8005003b CR2: b7793000 CR3: 06d19000 CR4: 000006b0
[    0.924582] Stack:
[    0.924582]  c006ee00 c6c32558 c6c322c0 c6d2bf30 c110a678 c006ed00 c6d2bf44 c104d7d9
[    0.924582]  c6c32570 c6d2c000 c6c322c0 c6d2bf8c c10311d2 00000000 c6d2bf80 c110a8a6
[    0.924582]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d2c050 c6c322c0
[    0.924582] Call Trace:
[    0.924582]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.924582]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.924582]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.924582]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.924582]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.924582]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.924582]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.924582] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.924582] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d2bf18
[    0.937680] ---[ end trace 7f0ecf16967dcc43 ]---
[    0.938100] Fixing recursive fault but reboot is needed!

dmesg-quantal-nhm4-5:20131009003511:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.924555] ------------[ cut here ]------------
[    0.924949] kernel BUG at kernel/cred.c:138!
[    0.925469] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.925910] Modules linked in:
[    0.926178] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.926793] task: c6c322c0 ti: c6d2a000 task.ti: c6d2a000
[    0.927232] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.927679] EIP is at __put_cred+0x56/0x90
[    0.927881] EAX: c14c3720 EBX: c6d17400 ECX: 00000000 EDX: 00000001
[    0.927881] ESI: c6c322c0 EDI: 00000001 EBP: c6d2bf24 ESP: c6d2bf18
[    0.927881]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.927881] CR0: 8005003b CR2: b7726000 CR3: 06d19000 CR4: 000006b0
[    0.927881] Stack:
[    0.927881]  c006ee00 c6c32558 c6c322c0 c6d2bf30 c110a678 c006ed00 c6d2bf44 c104d7d9
[    0.927881]  c6c32570 c6d2c000 c6c322c0 c6d2bf8c c10311d2 00000000 c6d2bf80 c110a8a6
[    0.927881]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d2c050 c6c322c0
[    0.927881] Call Trace:
[    0.927881]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.927881]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.927881]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.927881]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.927881]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.927881]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.927881]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.927881] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.927881] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d2bf18
[    0.937979] ---[ end trace 9f56434269907c1f ]---
[    0.938358] Fixing recursive fault but reboot is needed!

dmesg-quantal-roam-1:20131009083030:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.130287] ------------[ cut here ]------------
[    1.130741] kernel BUG at kernel/cred.c:138!
[    1.131345] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.131508] Modules linked in:
[    1.131508] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.131508] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.131508] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.131508] EIP is at __put_cred+0x56/0x90
[    1.131508] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.131508] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.131508]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.131508] CR0: 8005003b CR2: b77a9000 CR3: 06d1e000 CR4: 000006b0
[    1.131508] Stack:
[    1.131508]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.131508]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.131508]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.131508] Call Trace:
[    1.131508]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.131508]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.131508]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.131508]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.131508]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.131508]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.131508]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.131508] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.131508] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.145451] ---[ end trace 18ee4133d403afe6 ]---
[    1.145894] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-10:20131009082954:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.267650] ------------[ cut here ]------------
[    1.268157] kernel BUG at kernel/cred.c:138!
[    1.268839] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.269410] Modules linked in:
[    1.269757] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.270560] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.270907] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.270907] EIP is at __put_cred+0x56/0x90
[    1.270907] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.270907] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.270907]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.270907] CR0: 8005003b CR2: b76f0000 CR3: 06d1e000 CR4: 000006b0
[    1.270907] Stack:
[    1.270907]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.270907]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.270907]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.270907] Call Trace:
[    1.270907]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.270907]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.270907]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.270907]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.270907]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.270907]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.270907]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.270907] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.270907] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.285006] ---[ end trace 2a08b659136e771e ]---
[    1.285506] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-11:20131009083046:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.267812] ------------[ cut here ]------------
[    1.268328] kernel BUG at kernel/cred.c:138!
[    1.268463] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.268463] Modules linked in:
[    1.268463] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.268463] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.268463] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.268463] EIP is at __put_cred+0x56/0x90
[    1.268463] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.268463] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.268463]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.268463] CR0: 8005003b CR2: b7760000 CR3: 06d1e000 CR4: 000006b0
[    1.268463] Stack:
[    1.268463]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.268463]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.268463]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.268463] Call Trace:
[    1.268463]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.268463]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.268463]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.268463]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.268463]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.268463]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.268463]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.268463] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.268463] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.285133] ---[ end trace b2bca5ffc6ea2c3f ]---
[    1.285653] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-21:20131009082917:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.282220] ------------[ cut here ]------------
[    1.282756] kernel BUG at kernel/cred.c:138!
[    1.283288] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.283288] Modules linked in:
[    1.283288] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.283288] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.283288] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.283288] EIP is at __put_cred+0x56/0x90
[    1.283288] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.283288] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.283288]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.283288] CR0: 8005003b CR2: b775e000 CR3: 06d1e000 CR4: 000006b0
[    1.283288] Stack:
[    1.283288]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.283288]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.283288]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.283288] Call Trace:
[    1.283288]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.283288]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.283288]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.283288]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.283288]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.283288]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.283288]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.283288] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.283288] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.299898] ---[ end trace fa556be854dc3398 ]---
[    1.300431] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-24:20131009083041:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.262976] ------------[ cut here ]------------
[    1.263491] kernel BUG at kernel/cred.c:138!
[    1.263599] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.263599] Modules linked in:
[    1.263599] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.263599] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.263599] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.263599] EIP is at __put_cred+0x56/0x90
[    1.263599] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.263599] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.263599]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.263599] CR0: 8005003b CR2: bfc89ff8 CR3: 06d1e000 CR4: 000006b0
[    1.263599] Stack:
[    1.263599]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.263599]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.263599]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.263599] Call Trace:
[    1.263599]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.263599]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.263599]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.263599]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.263599]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.263599]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.263599]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.263599] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.263599] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.280144] ---[ end trace 3122307b9f7be18f ]---
[    1.280666] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-25:20131009083041:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.263536] ------------[ cut here ]------------
[    1.264035] kernel BUG at kernel/cred.c:138!
[    1.264711] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.265276] Modules linked in:
[    1.265639] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.265978] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.265978] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.265978] EIP is at __put_cred+0x56/0x90
[    1.265978] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.265978] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.265978]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.265978] CR0: 8005003b CR2: b779e000 CR3: 06d1e000 CR4: 000006b0
[    1.265978] Stack:
[    1.265978]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.265978]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.265978]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.265978] Call Trace:
[    1.265978]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.265978]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.265978]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.265978]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.265978]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.265978]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.265978]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.265978] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.265978] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.280305] ---[ end trace db43d2964c13d3c6 ]---
[    1.280794] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-31:20131009083030:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.268757] ------------[ cut here ]------------
[    1.269290] kernel BUG at kernel/cred.c:138!
[    1.269995] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.270320] Modules linked in:
[    1.270320] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.270320] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.270320] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.270320] EIP is at __put_cred+0x56/0x90
[    1.270320] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.270320] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.270320]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.270320] CR0: 8005003b CR2: b77c9000 CR3: 06d1e000 CR4: 000006b0
[    1.270320] Stack:
[    1.270320]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.270320]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.270320]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.270320] Call Trace:
[    1.270320]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.270320]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.270320]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.270320]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.270320]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.270320]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.270320]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.270320] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.270320] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.286494] ---[ end trace cfea269f1eaa7443 ]---
[    1.287052] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-33:20131009083029:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.263869] ------------[ cut here ]------------
[    1.264376] kernel BUG at kernel/cred.c:138!
[    1.265055] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.265236] Modules linked in:
[    1.265236] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.265236] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.265236] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.265236] EIP is at __put_cred+0x56/0x90
[    1.265236] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.265236] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.265236]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.265236] CR0: 8005003b CR2: b770c000 CR3: 06d1e000 CR4: 000006b0
[    1.265236] Stack:
[    1.265236]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.265236]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.265236]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.265236] Call Trace:
[    1.265236]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.265236]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.265236]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.265236]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.265236]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.265236]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.265236]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.265236] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.265236] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.280632] ---[ end trace fad9b18b03fcbc65 ]---
[    1.281122] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-35:20131009082924:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.283238] ------------[ cut here ]------------
[    1.283747] kernel BUG at kernel/cred.c:138!
[    1.284453] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.285035] Modules linked in:
[    1.285450] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.285683] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.285683] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.285683] EIP is at __put_cred+0x56/0x90
[    1.285683] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.285683] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.285683]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.285683] CR0: 8005003b CR2: b7721000 CR3: 06d1e000 CR4: 000006b0
[    1.285683] Stack:
[    1.285683]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.285683]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.285683]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.285683] Call Trace:
[    1.285683]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.285683]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.285683]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.285683]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.285683]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.285683]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.285683]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.285683] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.285683] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.300758] ---[ end trace e06a35604c6d002c ]---
[    1.301265] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-35:20131009083027:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.289153] ------------[ cut here ]------------
[    1.289669] kernel BUG at kernel/cred.c:138!
[    1.290371] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.290952] Modules linked in:
[    1.291312] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.291604] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.291604] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.291604] EIP is at __put_cred+0x56/0x90
[    1.291604] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.291604] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.291604]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.291604] CR0: 8005003b CR2: b7777000 CR3: 06d1e000 CR4: 000006b0
[    1.291604] Stack:
[    1.291604]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.291604]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.291604]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.291604] Call Trace:
[    1.291604]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.291604]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.291604]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.291604]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.291604]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.291604]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.291604]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.291604] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.291604] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.306635] ---[ end trace 2355eb76f3d67d41 ]---
[    1.307144] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-39:20131009082957:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.271515] ------------[ cut here ]------------
[    1.272027] kernel BUG at kernel/cred.c:138!
[    1.272717] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.273295] Modules linked in:
[    1.273645] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.274228] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.274228] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.274228] EIP is at __put_cred+0x56/0x90
[    1.274228] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.274228] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.274228]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.274228] CR0: 8005003b CR2: b7748000 CR3: 06d1e000 CR4: 000006b0
[    1.274228] Stack:
[    1.274228]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.274228]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.274228]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.274228] Call Trace:
[    1.274228]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.274228]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.274228]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.274228]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.274228]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.274228]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.274228]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.274228] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.274228] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.289221] ---[ end trace 0e8d6bb3d3b9eed9 ]---
[    1.289715] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-48:20131009083032:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.290473] ------------[ cut here ]------------
[    1.290999] kernel BUG at kernel/cred.c:138!
[    1.291715] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.292306] Modules linked in:
[    1.292673] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.293513] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.293631] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.293631] EIP is at __put_cred+0x56/0x90
[    1.293631] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.293631] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.293631]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.293631] CR0: 8005003b CR2: b7742000 CR3: 06d1e000 CR4: 000006b0
[    1.293631] Stack:
[    1.293631]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.293631]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.293631]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.293631] Call Trace:
[    1.293631]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.293631]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.293631]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.293631]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.293631]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.293631]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.293631]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.293631] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.293631] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.308539] ---[ end trace a20bc4a5948506b8 ]---
[    1.309055] Fixing recursive fault but reboot is needed!

dmesg-quantal-snb-8:20131009083035:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.271191] ------------[ cut here ]------------
[    1.271732] kernel BUG at kernel/cred.c:138!
[    1.272444] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.273030] Modules linked in:
[    1.273394] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.274258] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.274413] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.274413] EIP is at __put_cred+0x56/0x90
[    1.274413] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.274413] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.274413]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.274413] CR0: 8005003b CR2: b77cd000 CR3: 06d1e000 CR4: 000006b0
[    1.274413] Stack:
[    1.274413]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.274413]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.274413]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.274413] Call Trace:
[    1.274413]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.274413]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.274413]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.274413]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.274413]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.274413]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.274413]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.274413] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.274413] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.289024] ---[ end trace 98ba9fd422ad8aea ]---
[    1.289537] Fixing recursive fault but reboot is needed!

dmesg-quantal-stoakley-1:20131009082944:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    2.023245] ------------[ cut here ]------------
[    2.023898] kernel BUG at kernel/cred.c:138!
[    2.024787] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.025523] Modules linked in:
[    2.025979] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    2.026303] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    2.026303] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    2.026303] EIP is at __put_cred+0x56/0x90
[    2.026303] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    2.026303] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    2.026303]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.026303] CR0: 8005003b CR2: bfd7fffc CR3: 06d1e000 CR4: 000006b0
[    2.026303] Stack:
[    2.026303]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    2.026303]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    2.026303]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    2.026303] Call Trace:
[    2.026303]  [<c110a678>] file_free_rcu+0x28/0x40
[    2.026303]  [<c104d7d9>] task_work_run+0x79/0xa0
[    2.026303]  [<c10311d2>] do_exit+0x2f2/0x960
[    2.026303]  [<c110a8a6>] ? __fput+0x216/0x380
[    2.026303]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    2.026303]  [<c1032838>] SyS_exit_group+0x18/0x20
[    2.026303]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    2.026303] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    2.026303] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    2.045970] ---[ end trace f238037b91c10924 ]---
[    2.046641] Fixing recursive fault but reboot is needed!

dmesg-quantal-stoakley-3:20131009083031:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    2.033152] ------------[ cut here ]------------
[    2.033813] kernel BUG at kernel/cred.c:138!
[    2.034716] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    2.035103] Modules linked in:
[    2.035103] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    2.035103] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    2.035103] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    2.035103] EIP is at __put_cred+0x56/0x90
[    2.035103] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    2.035103] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    2.035103]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.035103] CR0: 8005003b CR2: b76ff000 CR3: 06d1e000 CR4: 000006b0
[    2.035103] Stack:
[    2.035103]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    2.035103]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    2.035103]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    2.035103] Call Trace:
[    2.035103]  [<c110a678>] file_free_rcu+0x28/0x40
[    2.035103]  [<c104d7d9>] task_work_run+0x79/0xa0
[    2.035103]  [<c10311d2>] do_exit+0x2f2/0x960
[    2.035103]  [<c110a8a6>] ? __fput+0x216/0x380
[    2.035103]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    2.035103]  [<c1032838>] SyS_exit_group+0x18/0x20
[    2.035103]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    2.035103] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    2.035103] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    2.056055] ---[ end trace b431bddf9fc347bf ]---
[    2.056710] Fixing recursive fault but reboot is needed!

dmesg-quantal-waimea-11:20131009162710:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    0.887588] ------------[ cut here ]------------
[    0.888068] kernel BUG at kernel/cred.c:138!
[    0.888726] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    0.889276] Modules linked in:
[    0.889554] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.889554] task: c6c322c0 ti: c6d2a000 task.ti: c6d2a000
[    0.889554] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    0.889554] EIP is at __put_cred+0x56/0x90
[    0.889554] EAX: c14c3720 EBX: c6d17400 ECX: 00000000 EDX: 00000001
[    0.889554] ESI: c6c322c0 EDI: 00000001 EBP: c6d2bf24 ESP: c6d2bf18
[    0.889554]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.889554] CR0: 8005003b CR2: b77d2000 CR3: 06d19000 CR4: 000006b0
[    0.889554] Stack:
[    0.889554]  c006ee00 c6c32558 c6c322c0 c6d2bf30 c110a678 c006ed00 c6d2bf44 c104d7d9
[    0.889554]  c6c32570 c6d2c000 c6c322c0 c6d2bf8c c10311d2 00000000 c6d2bf80 c110a8a6
[    0.889554]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d2c050 c6c322c0
[    0.889554] Call Trace:
[    0.889554]  [<c110a678>] file_free_rcu+0x28/0x40
[    0.889554]  [<c104d7d9>] task_work_run+0x79/0xa0
[    0.889554]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.889554]  [<c110a8a6>] ? __fput+0x216/0x380
[    0.889554]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.889554]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.889554]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    0.889554] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    0.889554] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d2bf18
[    0.904450] ---[ end trace 000353ff35790159 ]---
[    0.904925] Fixing recursive fault but reboot is needed!

dmesg-quantal-xian-21:20131009083032:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.240102] ------------[ cut here ]------------
[    1.240374] kernel BUG at kernel/cred.c:138!
[    1.240374] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.240374] Modules linked in:
[    1.240374] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.240374] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.240374] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.240374] EIP is at __put_cred+0x56/0x90
[    1.240374] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.240374] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.240374]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.240374] CR0: 8005003b CR2: b7710000 CR3: 06d1e000 CR4: 000006b0
[    1.240374] Stack:
[    1.240374]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.240374]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.240374]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.240374] Call Trace:
[    1.240374]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.240374]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.240374]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.240374]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.240374]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.240374]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.240374]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.240374] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.240374] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.255823] ---[ end trace d6c84abf11088fa0 ]---
[    1.256281] Fixing recursive fault but reboot is needed!

dmesg-quantal-xian-23:20131009082947:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

modprobe: FATAL: Could not load /lib/modules/3.12.0-rc1-00050-g0c44c2d/modules.dep: No such file or directory

[    1.501753] ------------[ cut here ]------------
[    1.502309] kernel BUG at kernel/cred.c:138!
[    1.503038] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    1.503719] Modules linked in:
[    1.504090] CPU: 0 PID: 36 Comm: modprobe Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.504117] task: c6c322c0 ti: c6d1a000 task.ti: c6d1a000
[    1.504117] EIP: 0060:[<c1056716>] EFLAGS: 00010202 CPU: 0
[    1.504117] EIP is at __put_cred+0x56/0x90
[    1.504117] EAX: c14c3720 EBX: c6d17380 ECX: 00000000 EDX: 00000001
[    1.504117] ESI: c6c322c0 EDI: 00000001 EBP: c6d1bf24 ESP: c6d1bf18
[    1.504117]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.504117] CR0: 8005003b CR2: b776d000 CR3: 06d1e000 CR4: 000006b0
[    1.504117] Stack:
[    1.504117]  c006ee00 c6c32558 c6c322c0 c6d1bf30 c110a678 c006ed00 c6d1bf44 c104d7d9
[    1.504117]  c6c32570 c6d1c000 c6c322c0 c6d1bf8c c10311d2 00000000 c6d1bf80 c110a8a6
[    1.504117]  00000001 00000001 00000000 00000246 00000001 c6c32558 c6d1c050 c6c322c0
[    1.504117] Call Trace:
[    1.504117]  [<c110a678>] file_free_rcu+0x28/0x40
[    1.504117]  [<c104d7d9>] task_work_run+0x79/0xa0
[    1.504117]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.504117]  [<c110a8a6>] ? __fput+0x216/0x380
[    1.504117]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.504117]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.504117]  [<c130eeb0>] sysenter_do_call+0x12/0x3c
[    1.504117] Code: 85 f6 74 02 0f 0b 8b 35 88 57 47 c1 31 c0 39 9e a4 01 00 00 0f 94 c0 89 c7 31 c9 89 fa b8 20 37 4c c1 e8 ae 19 05 00 85 ff 74 02 <0f> 0b 31 c0 3b 9e a0 01 00 00 0f 94 c0 89 c6 31 c9 89 f2 b8 0c
[    1.504117] EIP: [<c1056716>] __put_cred+0x56/0x90 SS:ESP 0068:c6d1bf18
[    1.518217] ---[ end trace 3ef53dce4d64dd7a ]---
[    1.518644] Fixing recursive fault but reboot is needed!

dmesg-yocto-ant-15:20131009082944:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    7.680434] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    8.182500] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    8.183571] IP: [<  (null)>]   (null)
[    8.184160] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    8.185292] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    8.185292] Modules linked in:
[    8.185292] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    8.185292] task: cd7cbcd0 ti: cd10c000 task.ti: cd10c000
[    8.185292] EIP: 0060:[<00000000>] EFLAGS: 00000246 CPU: 0
[    8.185292] EIP is at 0x0
[    8.185292] EAX: cd0def00 EBX: cd0dee40 ECX: 00000000 EDX: cd0def00
[    8.185292] ESI: cd7cbf68 EDI: cd7cbcd0 EBP: cd10df44 ESP: cd10df34
[    8.185292]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    8.185292] CR0: 8005003b CR2: 00000000 CR3: 0d108000 CR4: 000006b0
[    8.185292] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    8.185292] DR6: 00000000 DR7: 00000000
[    8.185292] Stack:
[    8.185292]  c104d7d9 cd7cbf80 cd0da900 cd7cbcd0 cd10df8c c10311d2 00000000 cd10df58
[    8.185292]  c10762db cd10df78 00000001 00000100 00000000 00000046 00000030 cd0da950
[    8.185292]  cd7cbcd0 ffffffff cd10df9c 0000ff00 ce867b80 cd7cbcd0 cd10dfa4 c10327ca
[    8.185292] Call Trace:
[    8.185292]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    8.185292]  [<c10311d2>] do_exit+0x2f2/0x960
[    8.185292]  [<c10762db>] ? trace_hardirqs_off+0xb/0x10
[    8.185292]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    8.185292]  [<c1032838>] SyS_exit_group+0x18/0x20
[    8.185292]  [<c1307ad5>] syscall_call+0x7/0xb
[    8.185292] Code:  Bad EIP value.
[    8.185292] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10df34
[    8.185292] CR2: 0000000000000000
[    8.206298] ---[ end trace 5ac61493344427c5 ]---
[    8.206999] Fixing recursive fault but reboot is needed!

dmesg-yocto-cairo-25:20131009083038:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.501170] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.509709] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.510451] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.510904] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.511500] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.511937] Modules linked in:
[    0.512160] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.512160] Workqueue: events delayed_fput
[    0.512160] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.512160] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.512160] EIP is at __fput+0x50/0x380
[    0.512160] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.512160] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.512160]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.512160] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.512160] Stack:
[    0.512160]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.512160]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.512160]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.512160] Call Trace:
[    0.512160]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.512160]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.512160]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.512160]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.512160]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.512160]  [<c1050c42>] kthread+0x92/0xa0
[    0.512160]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.512160]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.512160] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.512160] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.512160] CR2: 0000000000000000
[    0.527574] ---[ end trace 5cd69806bf0ab30d ]---
[    0.531770] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-inn-11:20131009082955:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.430180] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.437632] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.438241] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.438614] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.439112] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.439477] Modules linked in:
[    0.439748] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.440371] Workqueue: events delayed_fput
[    0.440719] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.440920] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.440920] EIP is at __fput+0x50/0x380
[    0.440920] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.440920] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.440920]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.440920] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.440920] Stack:
[    0.440920]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.440920]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.440920]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.440920] Call Trace:
[    0.440920]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.440920]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.440920]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.440920]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.440920]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.440920]  [<c1050c42>] kthread+0x92/0xa0
[    0.440920]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.440920]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.440920] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.440920] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.440920] CR2: 0000000000000000
[    0.452539] ---[ end trace 225518712278e9ab ]---
[    0.456251] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-inn-16:20131009082959:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.424763] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.432191] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.432798] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.433094] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.433094] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.433094] Modules linked in:
[    0.433094] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.433094] Workqueue: events delayed_fput
[    0.433094] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.433094] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.433094] EIP is at __fput+0x50/0x380
[    0.433094] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.433094] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.433094]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.433094] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.433094] Stack:
[    0.433094]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.433094]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.433094]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.433094] Call Trace:
[    0.433094]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.433094]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.433094]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.433094]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.433094]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.433094]  [<c1050c42>] kthread+0x92/0xa0
[    0.433094]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.433094]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.433094] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.433094] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.433094] CR2: 0000000000000000
[    0.446916] ---[ end trace 34a537809b14cc4f ]---
[    0.449762] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-inn-16:20131009083032:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.502675] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.511910] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.512629] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.513067] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.513647] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.513867] Modules linked in:
[    0.513867] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.513867] Workqueue: events delayed_fput
[    0.513867] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.513867] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.513867] EIP is at __fput+0x50/0x380
[    0.513867] EAX: 00000000 EBX: cd0e3600 ECX: 00000000 EDX: 0000001d
[    0.513867] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.513867]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.513867] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.513867] Stack:
[    0.513867]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.513867]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.513867]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.513867] Call Trace:
[    0.513867]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.513867]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.513867]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.513867]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.513867]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.513867]  [<c1050c42>] kthread+0x92/0xa0
[    0.513867]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.513867]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.513867] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.513867] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.513867] CR2: 0000000000000000
[    0.529167] ---[ end trace a83aad245ec4094c ]---
[    0.533890] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)

dmesg-yocto-inn-17:20131009083026:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.434086] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.441392] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.442025] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.442025] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.442025] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.442025] Modules linked in:
[    0.442025] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.442025] Workqueue: events delayed_fput
[    0.442025] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.442025] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.442025] EIP is at __fput+0x50/0x380
[    0.442025] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.442025] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.442025]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.442025] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.442025] Stack:
[    0.442025]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.442025]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.442025]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.442025] Call Trace:
[    0.442025]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.442025]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.442025]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.442025]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.442025]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.442025]  [<c1050c42>] kthread+0x92/0xa0
[    0.442025]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.442025]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.442025] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.442025] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.442025] CR2: 0000000000000000
[    0.456868] ---[ end trace f890ee58c5fab7df ]---
[    0.460395] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-inn-19:20131009083017:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.410913] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.417939] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.418185] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.418185] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.418185] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.418185] Modules linked in:
[    0.418185] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.418185] Workqueue: events delayed_fput
[    0.418185] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.418185] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.418185] EIP is at __fput+0x50/0x380
[    0.418185] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.418185] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.418185]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.418185] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.418185] Stack:
[    0.418185]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.418185]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.418185]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.418185] Call Trace:
[    0.418185]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.418185]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.418185]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.418185]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.418185]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.418185]  [<c1050c42>] kthread+0x92/0xa0
[    0.418185]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.418185]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.418185] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.418185] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.418185] CR2: 0000000000000000
[    0.432292] ---[ end trace 581eb8f1e6fe4c76 ]---
[    0.434863] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-inn-34:20131009083040:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.426450] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.433565] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.434171] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.434545] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.435027] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.435385] Modules linked in:
[    0.435656] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.435656] Workqueue: events delayed_fput
[    0.435656] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.435656] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.435656] EIP is at __fput+0x50/0x380
[    0.435656] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.435656] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.435656]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.435656] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.435656] Stack:
[    0.435656]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.435656]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.435656]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.435656] Call Trace:
[    0.435656]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.435656]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.435656]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.435656]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.435656]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.435656]  [<c1050c42>] kthread+0x92/0xa0
[    0.435656]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.435656]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.435656] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.435656] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.435656] CR2: 0000000000000000
[    0.448224] ---[ end trace 6a3e5cea92ca5442 ]---
[    0.451867] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-inn-42:20131009082955:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.408103] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.414988] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.415578] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.415938] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.416400] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.416747] Modules linked in:
[    0.416996] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.417584] Workqueue: events delayed_fput
[    0.417693] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.417693] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.417693] EIP is at __fput+0x50/0x380
[    0.417693] EAX: 00000000 EBX: cd0e3e00 ECX: 00000000 EDX: 0000001d
[    0.417693] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.417693]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.417693] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.417693] Stack:
[    0.417693]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.417693]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.417693]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.417693] Call Trace:
[    0.417693]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.417693]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.417693]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.417693]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.417693]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.417693]  [<c1050c42>] kthread+0x92/0xa0
[    0.417693]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.417693]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.417693] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.417693] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.417693] CR2: 0000000000000000
[    0.428950] ---[ end trace 2261da89eba9a6f9 ]---
[    0.432229] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-inn-46:20131009083045:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.496471] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.503853] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.504469] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.504851] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.505348] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.505721] Modules linked in:
[    0.506019] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.506160] Workqueue: events delayed_fput
[    0.506160] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.506160] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.506160] EIP is at __fput+0x50/0x380
[    0.506160] EAX: 00000000 EBX: cd0e3600 ECX: 00000000 EDX: 0000001d
[    0.506160] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.506160]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.506160] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.506160] Stack:
[    0.506160]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.506160]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.506160]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.506160] Call Trace:
[    0.506160]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.506160]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.506160]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.506160]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.506160]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.506160]  [<c1050c42>] kthread+0x92/0xa0
[    0.506160]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.506160]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.506160] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.506160] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.506160] CR2: 0000000000000000
[    0.518909] ---[ end trace 28d48498ca9ee6eb ]---
[    0.522478] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6a80 with usage -2

dmesg-yocto-inn-9:20131009083033:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.441803] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.449101] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.449725] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.450120] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.450628] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.451010] Modules linked in:
[    0.451287] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.451940] Workqueue: events delayed_fput
[    0.452298] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.452416] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.452416] EIP is at __fput+0x50/0x380
[    0.452416] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.452416] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.452416]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.452416] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.452416] Stack:
[    0.452416]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.452416]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.452416]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.452416] Call Trace:
[    0.452416]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.452416]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.452416]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.452416]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.452416]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.452416]  [<c1050c42>] kthread+0x92/0xa0
[    0.452416]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.452416]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.452416] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.452416] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.452416] CR2: 0000000000000000
[    0.464393] ---[ end trace ebfc7022f114ec65 ]---
[    0.468186] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-jaketown-12:20131009083043:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    1.551342] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    1.586132] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    1.586642] IP: [<  (null)>]   (null)
[    1.586642] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    1.586642] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    1.586642] Modules linked in:
[    1.586642] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.586642] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    1.586642] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    1.586642] EIP is at 0x0
[    1.586642] EAX: cd0dc500 EBX: cd0dce00 ECX: 00000000 EDX: cd0dc500
[    1.586642] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    1.586642]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.586642] CR0: 8005003b CR2: 00000000 CR3: 0d102000 CR4: 000006b0
[    1.586642] Stack:
[    1.586642]  c104d7d9 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c10311d2 00000000 00000000
[    1.586642]  cee9d000 00000035 00000001 cd10bf88 c11095c1 00000001 00000000 cd0d6a50
[    1.586642]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ca
[    1.586642] Call Trace:
[    1.586642]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    1.586642]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.586642]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    1.586642]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.586642]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.586642]  [<c1307ad5>] syscall_call+0x7/0xb
[    1.586642] Code:  Bad EIP value.
[    1.586642] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10bf34
[    1.586642] CR2: 0000000000000000
[    1.648930] ---[ end trace 7f02bd0664dace14 ]---
[    1.650964] Fixing recursive fault but reboot is needed!

dmesg-yocto-jaketown-15:20131009083013:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    1.530444] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    1.566314] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    1.568802] IP: [<  (null)>]   (null)
[    1.568802] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    1.568802] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    1.568802] Modules linked in:
[    1.568802] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.568802] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    1.568802] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    1.568802] EIP is at 0x0
[    1.568802] EAX: cd0dc500 EBX: cd0dce00 ECX: 00000000 EDX: cd0dc500
[    1.568802] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    1.568802]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.568802] CR0: 8005003b CR2: 00000000 CR3: 0d102000 CR4: 000006b0
[    1.568802] Stack:
[    1.568802]  c104d7d9 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c10311d2 00000000 00000000
[    1.568802]  cee9d000 00000035 00000001 cd10bf88 c11095c1 00000001 00000000 cd0d6a50
[    1.568802]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ca
[    1.568802] Call Trace:
[    1.568802]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    1.568802]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.568802]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    1.568802]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.568802]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.568802]  [<c1307ad5>] syscall_call+0x7/0xb
[    1.568802] Code:  Bad EIP value.
[    1.568802] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10bf34
[    1.568802] CR2: 0000000000000000
[    1.627698] ---[ end trace 6b2b793cd84617c3 ]---
[    1.629800] Fixing recursive fault but reboot is needed!

dmesg-yocto-jaketown-29:20131009083045:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    1.496690] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    1.531112] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    1.534201] IP: [<  (null)>]   (null)
[    1.534264] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    1.534264] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    1.534264] Modules linked in:
[    1.534264] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.534264] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    1.534264] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    1.534264] EIP is at 0x0
[    1.534264] EAX: cd0dc500 EBX: cd0dc400 ECX: 00000000 EDX: cd0dc500
[    1.534264] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    1.534264]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.534264] CR0: 8005003b CR2: 00000000 CR3: 0d102000 CR4: 000006b0
[    1.534264] Stack:
[    1.534264]  c104d7d9 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c10311d2 00000000 00000000
[    1.534264]  cee9d000 00000035 00000001 cd10bf88 c11095c1 00000001 00000000 cd0d6a50
[    1.534264]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ca
[    1.534264] Call Trace:
[    1.534264]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    1.534264]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.534264]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    1.534264]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.534264]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.534264]  [<c1307ad5>] syscall_call+0x7/0xb
[    1.534264] Code:  Bad EIP value.
[    1.534264] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10bf34
[    1.534264] CR2: 0000000000000000
[    1.589395] ---[ end trace d950a506c3655153 ]---
[    1.591408] Fixing recursive fault but reboot is needed!

dmesg-yocto-jaketown-32:20131009082958:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    1.546502] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    1.580575] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    1.581657] IP: [<  (null)>]   (null)
[    1.581657] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    1.581657] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    1.581657] Modules linked in:
[    1.581657] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.581657] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    1.581657] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    1.581657] EIP is at 0x0
[    1.581657] EAX: cd0dc500 EBX: cd0dce00 ECX: 00000000 EDX: cd0dc500
[    1.581657] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    1.581657]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.581657] CR0: 8005003b CR2: 00000000 CR3: 0d102000 CR4: 000006b0
[    1.581657] Stack:
[    1.581657]  c104d7d9 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c10311d2 00000000 00000000
[    1.581657]  cee9d000 00000035 00000001 cd10bf88 c11095c1 00000001 00000000 cd0d6a50
[    1.581657]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ca
[    1.581657] Call Trace:
[    1.581657]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    1.581657]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.581657]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    1.581657]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.581657]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.581657]  [<c1307ad5>] syscall_call+0x7/0xb
[    1.581657] Code:  Bad EIP value.
[    1.581657] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10bf34
[    1.581657] CR2: 0000000000000000
[    1.643072] ---[ end trace b28c2b43abeb7e04 ]---
[    1.645210] Fixing recursive fault but reboot is needed!

dmesg-yocto-jaketown-40:20131009082921:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    1.018438] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    1.038912] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    1.040921] IP: [<  (null)>]   (null)
[    1.041670] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    1.041670] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    1.041670] Modules linked in:
[    1.041670] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.041670] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    1.041670] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    1.041670] EIP is at 0x0
[    1.041670] EAX: cd0dc500 EBX: cd0dce00 ECX: 00000000 EDX: cd0dc500
[    1.041670] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    1.041670]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.041670] CR0: 8005003b CR2: 00000000 CR3: 0d102000 CR4: 000006b0
[    1.041670] Stack:
[    1.041670]  c104d7d9 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c10311d2 00000000 00000000
[    1.041670]  cee9d000 00000035 00000001 cd10bf88 c11095c1 00000001 00000000 cd0d6a50
[    1.041670]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ca
[    1.041670] Call Trace:
[    1.041670]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    1.041670]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.041670]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    1.041670]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.041670]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.041670]  [<c1307ad5>] syscall_call+0x7/0xb
[    1.041670] Code:  Bad EIP value.
[    1.041670] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10bf34
[    1.041670] CR2: 0000000000000000
[    1.076421] ---[ end trace 4b5bedf680260623 ]---
[    1.077673] Fixing recursive fault but reboot is needed!

dmesg-yocto-jaketown-41:20131009083036:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    1.535975] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    1.570337] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    1.571212] IP: [<  (null)>]   (null)
[    1.571212] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    1.571212] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    1.571212] Modules linked in:
[    1.571212] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.571212] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    1.571212] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    1.571212] EIP is at 0x0
[    1.571212] EAX: cd0dc500 EBX: cd0dce00 ECX: 00000000 EDX: cd0dc500
[    1.571212] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    1.571212]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.571212] CR0: 8005003b CR2: 00000000 CR3: 0d102000 CR4: 000006b0
[    1.571212] Stack:
[    1.571212]  c104d7d9 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c10311d2 00000000 00000000
[    1.571212]  cee9d000 00000035 00000001 cd10bf88 c11095c1 00000001 00000000 cd0d6a50
[    1.571212]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ca
[    1.571212] Call Trace:
[    1.571212]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    1.571212]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.571212]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    1.571212]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.571212]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.571212]  [<c1307ad5>] syscall_call+0x7/0xb
[    1.571212] Code:  Bad EIP value.
[    1.571212] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10bf34
[    1.571212] CR2: 0000000000000000
[    1.630732] ---[ end trace 72dc9de4dfb9e8df ]---
[    1.632860] Fixing recursive fault but reboot is needed!

dmesg-yocto-jaketown-46:20131009083002:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    1.567564] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    1.602275] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    1.604681] IP: [<  (null)>]   (null)
[    1.604681] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    1.604681] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    1.604681] Modules linked in:
[    1.604681] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.604681] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    1.604681] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    1.604681] EIP is at 0x0
[    1.604681] EAX: cd0dc500 EBX: cd0dce00 ECX: 00000000 EDX: cd0dc500
[    1.604681] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    1.604681]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.604681] CR0: 8005003b CR2: 00000000 CR3: 0d102000 CR4: 000006b0
[    1.604681] Stack:
[    1.604681]  c104d7d9 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c10311d2 00000000 00000000
[    1.604681]  cee9d000 00000035 00000001 cd10bf88 c11095c1 00000001 00000000 cd0d6a50
[    1.604681]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ca
[    1.604681] Call Trace:
[    1.604681]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    1.604681]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.604681]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    1.604681]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.604681]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.604681]  [<c1307ad5>] syscall_call+0x7/0xb
[    1.604681] Code:  Bad EIP value.
[    1.604681] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10bf34
[    1.604681] CR2: 0000000000000000
[    1.663708] ---[ end trace d7d60fed41220e4a ]---
[    1.665897] Fixing recursive fault but reboot is needed!

dmesg-yocto-jaketown-47:20131009083012:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    1.570224] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    1.605401] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    1.608167] IP: [<  (null)>]   (null)
[    1.608167] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    1.608167] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    1.608167] Modules linked in:
[    1.608167] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.608167] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    1.608167] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    1.608167] EIP is at 0x0
[    1.608167] EAX: cd0dc500 EBX: cd0dce00 ECX: 00000000 EDX: cd0dc500
[    1.608167] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    1.608167]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.608167] CR0: 8005003b CR2: 00000000 CR3: 0d102000 CR4: 000006b0
[    1.608167] Stack:
[    1.608167]  c104d7d9 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c10311d2 00000000 00000000
[    1.608167]  cee9d000 00000035 00000001 cd10bf88 c11095c1 00000001 00000000 cd0d6a50
[    1.608167]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ca
[    1.608167] Call Trace:
[    1.608167]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    1.608167]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.608167]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    1.608167]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.608167]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.608167]  [<c1307ad5>] syscall_call+0x7/0xb
[    1.608167] Code:  Bad EIP value.
[    1.608167] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10bf34
[    1.608167] CR2: 0000000000000000
[    1.666045] ---[ end trace db7ead92435cc1aa ]---
[    1.668186] Fixing recursive fault but reboot is needed!

dmesg-yocto-jaketown-4:20131009082939:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    1.020838] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    1.042223] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    1.044259] IP: [<  (null)>]   (null)
[    1.044958] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    1.044958] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    1.044958] Modules linked in:
[    1.044958] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    1.044958] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    1.044958] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    1.044958] EIP is at 0x0
[    1.044958] EAX: cd0dc500 EBX: cd0dce00 ECX: 00000000 EDX: cd0dc500
[    1.044958] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    1.044958]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.044958] CR0: 8005003b CR2: 00000000 CR3: 0d102000 CR4: 000006b0
[    1.044958] Stack:
[    1.044958]  c104d7d9 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c10311d2 00000000 00000000
[    1.044958]  cee9d000 00000035 00000001 cd10bf88 c11095c1 00000001 00000000 cd0d6a50
[    1.044958]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ca
[    1.044958] Call Trace:
[    1.044958]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    1.044958]  [<c10311d2>] do_exit+0x2f2/0x960
[    1.044958]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    1.044958]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    1.044958]  [<c1032838>] SyS_exit_group+0x18/0x20
[    1.044958]  [<c1307ad5>] syscall_call+0x7/0xb
[    1.044958] Code:  Bad EIP value.
[    1.044958] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10bf34
[    1.044958] CR2: 0000000000000000
[    1.079981] ---[ end trace c2310af05059d583 ]---
[    1.081346] Fixing recursive fault but reboot is needed!

dmesg-yocto-lkp-st01-2:20131009083038:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.888984] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.914539] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.915693] IP: [<  (null)>]   (null)
[    0.916157] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.916157] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    0.916157] Modules linked in:
[    0.916157] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.916157] task: cd7cbcd0 ti: cd10e000 task.ti: cd10e000
[    0.916157] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    0.916157] EIP is at 0x0
[    0.916157] EAX: cd0e3500 EBX: cd0e3e00 ECX: 00000000 EDX: cd0e3500
[    0.916157] ESI: cd7cbf68 EDI: cd7cbcd0 EBP: cd10ff44 ESP: cd10ff34
[    0.916157]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.916157] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.916157] Stack:
[    0.916157]  c104d7d9 cd7cbf80 cd0daa00 cd7cbcd0 cd10ff8c c10311d2 00000000 00000000
[    0.916157]  cee9d000 00000035 00000001 cd10ff88 c11095c1 00000001 00000000 cd0daa50
[    0.916157]  cd7cbcd0 080d3208 cd10ff9c 0000ff00 cd0ee600 cd7cbcd0 cd10ffa4 c10327ca
[    0.916157] Call Trace:
[    0.916157]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    0.916157]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.916157]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    0.916157]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.916157]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.916157]  [<c1307ad5>] syscall_call+0x7/0xb
[    0.916157] Code:  Bad EIP value.
[    0.916157] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10ff34
[    0.916157] CR2: 0000000000000000
[    0.936493] ---[ end trace f10ae585fb74f7e1 ]---
[    0.937227] Fixing recursive fault but reboot is needed!

dmesg-yocto-lkp-st01-8:20131009083013:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.889728] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.915375] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.916273] IP: [<  (null)>]   (null)
[    0.916273] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.916273] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    0.916273] Modules linked in:
[    0.916273] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.916273] task: cd7cbcd0 ti: cd10e000 task.ti: cd10e000
[    0.916273] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    0.916273] EIP is at 0x0
[    0.916273] EAX: cd0e3200 EBX: cd0e3e00 ECX: 00000000 EDX: cd0e3200
[    0.916273] ESI: cd7cbf68 EDI: cd7cbcd0 EBP: cd10ff44 ESP: cd10ff34
[    0.916273]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.916273] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.916273] Stack:
[    0.916273]  c104d7d9 cd7cbf80 cd0daa00 cd7cbcd0 cd10ff8c c10311d2 00000000 00000000
[    0.916273]  cee9d000 00000035 00000001 cd10ff88 c11095c1 00000001 00000000 cd0daa50
[    0.916273]  cd7cbcd0 080d3208 cd10ff9c 0000ff00 cd0ee600 cd7cbcd0 cd10ffa4 c10327ca
[    0.916273] Call Trace:
[    0.916273]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    0.916273]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.916273]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    0.916273]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.916273]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.916273]  [<c1307ad5>] syscall_call+0x7/0xb
[    0.916273] Code:  Bad EIP value.
[    0.916273] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10ff34
[    0.916273] CR2: 0000000000000000
[    0.937421] ---[ end trace 76773643dbf59fe6 ]---
[    0.938147] Fixing recursive fault but reboot is needed!

dmesg-yocto-lkp-tt02-19:20131008230131:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1


mount: mounting proc on /proc failed: No such device
[    0.988873] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    0.990372] BUG: unable to handle kernel paging request at cd0dcc08
[    0.991192] IP: [<cd0dcc08>] 0xcd0dcc07
[    0.991192] *pdpt = 0000000001525001 *pde = 000000000fbfc067 *pte = 800000000d0dc163 
[    0.991192] Oops: 0011 [#1] DEBUG_PAGEALLOC
[    0.991192] Modules linked in:
[    0.991192] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.991192] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    0.991192] EIP: 0060:[<cd0dcc08>] EFLAGS: 00010246 CPU: 0
[    0.991192] EIP is at 0xcd0dcc08
[    0.991192] EAX: cd0dcc00 EBX: cd0dc600 ECX: 00000000 EDX: cd0dcc00
[    0.991192] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    0.991192]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.991192] CR0: 8005003b CR2: cd0dcc08 CR3: 0d102000 CR4: 000006b0
[    0.991192] Stack:
[    0.991192]  c104d7d9 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c10311d2 00000000 00000000
[    0.991192]  cee9d000 00000035 00000001 cd10bf88 c11095c1 00000001 00000000 cd0d6a50
[    0.991192]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ca
[    0.991192] Call Trace:
[    0.991192]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    0.991192]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.991192]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    0.991192]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.991192]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.991192]  [<c1307ad5>] syscall_call+0x7/0xb
[    0.991192] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c6 0d cd 08 cc 0d cd <20> 00 00 00 4c cc 0d cd 44 cc 0d cd 48 cc 0d cd 01 00 00 00 ad
[    0.991192] EIP: [<cd0dcc08>] 0xcd0dcc08 SS:ESP 0068:cd10bf34
[    0.991192] CR2: 00000000cd0dcc08
[    0.991192] ---[ end trace c19536785f94c587 ]---
[    0.991192] Fixing recursive fault but reboot is needed!

dmesg-yocto-lkp-tt02-23:20131008230154:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1


mount: mounting proc on /proc failed: No such device
[    0.987575] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    0.988107] BUG: unable to handle kernel paging request at cd0dc408
[    0.988107] IP: [<cd0dc408>] 0xcd0dc407
[    0.988107] *pdpt = 0000000001525001 *pde = 000000000fbfc067 *pte = 800000000d0dc163 
[    0.988107] Oops: 0011 [#1] DEBUG_PAGEALLOC
[    0.988107] Modules linked in:
[    0.988107] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.988107] task: cd7c3cd0 ti: cd10a000 task.ti: cd10a000
[    0.988107] EIP: 0060:[<cd0dc408>] EFLAGS: 00010246 CPU: 0
[    0.988107] EIP is at 0xcd0dc408
[    0.988107] EAX: cd0dc400 EBX: cd0dc600 ECX: 00000000 EDX: cd0dc400
[    0.988107] ESI: cd7c3f68 EDI: cd7c3cd0 EBP: cd10bf44 ESP: cd10bf34
[    0.988107]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.988107] CR0: 8005003b CR2: cd0dc408 CR3: 0d102000 CR4: 000006b0
[    0.988107] Stack:
[    0.988107]  c104d7d9 cd7c3f80 cd0d6a00 cd7c3cd0 cd10bf8c c10311d2 00000000 00000000
[    0.988107]  cee9d000 00000035 00000001 cd10bf88 c11095c1 00000001 00000000 cd0d6a50
[    0.988107]  cd7c3cd0 080d3208 cd10bf9c 0000ff00 cd0ea600 cd7c3cd0 cd10bfa4 c10327ca
[    0.988107] Call Trace:
[    0.988107]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    0.988107]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.988107]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    0.988107]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.988107]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.988107]  [<c1307ad5>] syscall_call+0x7/0xb
[    0.988107] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c6 0d cd 08 c4 0d cd <20> 00 00 00 4c c4 0d cd 44 c4 0d cd 48 c4 0d cd 01 00 00 00 ad
[    0.988107] EIP: [<cd0dc408>] 0xcd0dc408 SS:ESP 0068:cd10bf34
[    0.988107] CR2: 00000000cd0dc408
[    0.988107] ---[ end trace 3ebf8bf531c016bd ]---
[    0.988107] Fixing recursive fault but reboot is needed!

dmesg-yocto-nhm4-1:20131009003543:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.426035] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.433333] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.433951] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.434335] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.434839] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.434880] Modules linked in:
[    0.434880] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.434880] Workqueue: events delayed_fput
[    0.434880] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.434880] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.434880] EIP is at __fput+0x50/0x380
[    0.434880] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.434880] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.434880]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.434880] CR0: 8005003b CR2: 00000000 CR3: 0d10b000 CR4: 000006b0
[    0.434880] Stack:
[    0.434880]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.434880]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.434880]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.434880] Call Trace:
[    0.434880]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.434880]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.434880]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.434880]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.434880]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.434880]  [<c1050c42>] kthread+0x92/0xa0
[    0.434880]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.434880]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.434880] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.434880] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.434880] CR2: 0000000000000000
[    0.448662] ---[ end trace 08170cf8d35771e6 ]---
[    0.451536] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6d00 with usage -1

dmesg-yocto-nhm4-2:20131009003443:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.428450] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.435717] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.436341] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.436733] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.437233] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.437609] Modules linked in:
[    0.437879] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.438404] Workqueue: events delayed_fput
[    0.438404] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.438404] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.438404] EIP is at __fput+0x50/0x380
[    0.438404] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.438404] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.438404]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.438404] CR0: 8005003b CR2: 00000000 CR3: 0d10b000 CR4: 000006b0
[    0.438404] Stack:
[    0.438404]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.438404]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.438404]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.438404] Call Trace:
[    0.438404]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.438404]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.438404]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.438404]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.438404]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.438404]  [<c1050c42>] kthread+0x92/0xa0
[    0.438404]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.438404]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.438404] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.438404] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.438404] CR2: 0000000000000000
[    0.450971] ---[ end trace dc6249fbb8b3aa6f ]---
[    0.454483] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6d00 with usage -1

dmesg-yocto-roam-19:20131009082928:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.499036] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.507597] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.508319] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.508766] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.509356] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.509787] Modules linked in:
[    0.510101] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.510745] Workqueue: events delayed_fput
[    0.510745] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.510745] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.510745] EIP is at __fput+0x50/0x380
[    0.510745] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.510745] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.510745]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.510745] CR0: 8005003b CR2: 00000000 CR3: 0d10c000 CR4: 000006b0
[    0.510745] Stack:
[    0.510745]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.510745]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.510745]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.510745] Call Trace:
[    0.510745]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.510745]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.510745]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.510745]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.510745]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.510745]  [<c1050c42>] kthread+0x92/0xa0
[    0.510745]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.510745]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.510745] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.510745] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.510745] CR2: 0000000000000000
[    0.525145] ---[ end trace 646f8ad850537230 ]---
[    0.529312] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-roam-19:20131009083028:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.499251] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.507900] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.508631] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.509091] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.509677] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.510118] Modules linked in:
[    0.510153] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.510153] Workqueue: events delayed_fput
[    0.510153] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.510153] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.510153] EIP is at __fput+0x50/0x380
[    0.510153] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.510153] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.510153]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.510153] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.510153] Stack:
[    0.510153]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.510153]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.510153]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.510153] Call Trace:
[    0.510153]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.510153]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.510153]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.510153]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.510153]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.510153]  [<c1050c42>] kthread+0x92/0xa0
[    0.510153]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.510153]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.510153] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.510153] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.510153] CR2: 0000000000000000
[    0.525438] ---[ end trace 7b73824a90479b7b ]---
[    0.529939] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-roam-31:20131009083002:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.495782] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.504013] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.504136] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.504136] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.504136] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.504136] Modules linked in:
[    0.504136] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.504136] Workqueue: events delayed_fput
[    0.504136] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.504136] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.504136] EIP is at __fput+0x50/0x380
[    0.504136] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.504136] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.504136]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.504136] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.504136] Stack:
[    0.504136]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.504136]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.504136]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.504136] Call Trace:
[    0.504136]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.504136]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.504136]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.504136]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.504136]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.504136]  [<c1050c42>] kthread+0x92/0xa0
[    0.504136]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.504136]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.504136] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.504136] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.504136] CR2: 0000000000000000
[    0.521546] ---[ end trace 39b01e980fcb1dd0 ]---
[    0.525685] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-roam-7:20131009083018:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.493942] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.502525] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.503224] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.503655] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.504223] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.504638] Modules linked in:
[    0.504940] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.505167] Workqueue: events delayed_fput
[    0.505167] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.505167] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.505167] EIP is at __fput+0x50/0x380
[    0.505167] EAX: 00000000 EBX: cd0e3100 ECX: 00000000 EDX: 0000001d
[    0.505167] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.505167]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.505167] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.505167] Stack:
[    0.505167]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.505167]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.505167]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.505167] Call Trace:
[    0.505167]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.505167]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.505167]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.505167]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.505167]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.505167]  [<c1050c42>] kthread+0x92/0xa0
[    0.505167]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.505167]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.505167] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.505167] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.505167] CR2: 0000000000000000
[    0.519574] ---[ end trace 4c42a6d58bfb847a ]---
[    0.523721] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-snb-16:20131009083047:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.562054] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.571826] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.572634] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.573140] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.573797] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.574281] Modules linked in:
[    0.574636] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.574925] Workqueue: events delayed_fput
[    0.574925] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.574925] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.574925] EIP is at __fput+0x50/0x380
[    0.574925] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.574925] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.574925]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.574925] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.574925] Stack:
[    0.574925]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.574925]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.574925]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.574925] Call Trace:
[    0.574925]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.574925]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.574925]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.574925]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.574925]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.574925]  [<c1050c42>] kthread+0x92/0xa0
[    0.574925]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.574925]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.574925] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.574925] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.574925] CR2: 0000000000000000
[    0.591274] ---[ end trace 86ab9df62a7af15b ]---
[    0.594899] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-snb-34:20131009083004:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.561343] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.571257] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.572088] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.572619] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.573285] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.573723] Modules linked in:
[    0.573723] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.573723] Workqueue: events delayed_fput
[    0.573723] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.573723] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.573723] EIP is at __fput+0x50/0x380
[    0.573723] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.573723] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.573723]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.573723] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.573723] Stack:
[    0.573723]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.573723]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.573723]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.573723] Call Trace:
[    0.573723]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.573723]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.573723]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.573723]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.573723]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.573723]  [<c1050c42>] kthread+0x92/0xa0
[    0.573723]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.573723]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.573723] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.573723] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.573723] CR2: 0000000000000000
[    0.591594] ---[ end trace ce2ea4d7239919b0 ]---
[    0.596515] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-snb-38:20131009083044:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.557316] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.567160] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.567941] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.568436] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.569076] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.569544] Modules linked in:
[    0.569887] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.570447] Workqueue: events delayed_fput
[    0.570447] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.570447] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.570447] EIP is at __fput+0x50/0x380
[    0.570447] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.570447] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.570447]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.570447] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.570447] Stack:
[    0.570447]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.570447]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.570447]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.570447] Call Trace:
[    0.570447]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.570447]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.570447]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.570447]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.570447]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.570447]  [<c1050c42>] kthread+0x92/0xa0
[    0.570447]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.570447]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.570447] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.570447] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.570447] CR2: 0000000000000000
[    0.586221] ---[ end trace e1d5a895fede2b91 ]---
[    0.590456] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-snb-40:20131009083017:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.551710] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.561097] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.561887] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.562371] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.563004] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.563467] Modules linked in:
[    0.563669] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.563669] Workqueue: events delayed_fput
[    0.563669] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.563669] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.563669] EIP is at __fput+0x50/0x380
[    0.563669] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.563669] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.563669]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.563669] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.563669] Stack:
[    0.563669]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.563669]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.563669]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.563669] Call Trace:
[    0.563669]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.563669]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.563669]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.563669]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.563669]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.563669]  [<c1050c42>] kthread+0x92/0xa0
[    0.563669]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.563669]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.563669] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.563669] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.563669] CR2: 0000000000000000
[    0.580028] ---[ end trace d9920da2f1432e39 ]---
[    0.583684] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-snb-4:20131009083037:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.565218] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.574878] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.575734] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.576267] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.576964] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.577471] Modules linked in:
[    0.577547] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.577547] Workqueue: events delayed_fput
[    0.577547] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.577547] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.577547] EIP is at __fput+0x50/0x380
[    0.577547] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.577547] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.577547]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.577547] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.577547] Stack:
[    0.577547]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.577547]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.577547]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.577547] Call Trace:
[    0.577547]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.577547]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.577547]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.577547]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.577547]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.577547]  [<c1050c42>] kthread+0x92/0xa0
[    0.577547]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.577547]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.577547] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.577547] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.577547] CR2: 0000000000000000
[    0.595690] ---[ end trace c3edee3d6a10ee16 ]---
[    0.600571] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-stoakley-6:20131009083037:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.805269] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.828029] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.829058] IP: [<  (null)>]   (null)
[    0.829589] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.829639] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    0.829639] Modules linked in:
[    0.829639] CPU: 0 PID: 46 Comm: mount Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.829639] task: cd7cbcd0 ti: cd10e000 task.ti: cd10e000
[    0.829639] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    0.829639] EIP is at 0x0
[    0.829639] EAX: cd0e3500 EBX: cd0e3e00 ECX: 00000000 EDX: cd0e3500
[    0.829639] ESI: cd7cbf68 EDI: cd7cbcd0 EBP: cd10ff44 ESP: cd10ff34
[    0.829639]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.829639] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.829639] Stack:
[    0.829639]  c104d7d9 cd7cbf80 cd0daa00 cd7cbcd0 cd10ff8c c10311d2 00000000 00000000
[    0.829639]  cee9d000 00000035 00000001 cd10ff88 c11095c1 00000001 00000000 cd0daa50
[    0.829639]  cd7cbcd0 080d3208 cd10ff9c 0000ff00 cd0ee600 cd7cbcd0 cd10ffa4 c10327ca
[    0.829639] Call Trace:
[    0.829639]  [<c104d7d9>] ? task_work_run+0x79/0xa0
[    0.829639]  [<c10311d2>] do_exit+0x2f2/0x960
[    0.829639]  [<c11095c1>] ? vfs_write+0x161/0x1a0
[    0.829639]  [<c10327ca>] do_group_exit+0x4a/0xa0
[    0.829639]  [<c1032838>] SyS_exit_group+0x18/0x20
[    0.829639]  [<c1307ad5>] syscall_call+0x7/0xb
[    0.829639] Code:  Bad EIP value.
[    0.829639] EIP: [<00000000>] 0x0 SS:ESP 0068:cd10ff34
[    0.829639] CR2: 0000000000000000
[    0.847288] ---[ end trace 98305221751e108d ]---
[    0.847937] Fixing recursive fault but reboot is needed!

dmesg-yocto-waimea-12:20131009162634:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.431392] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.438770] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.439521] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.439980] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.440584] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.440780] Modules linked in:
[    0.440780] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.440780] Workqueue: events delayed_fput
[    0.440780] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.440780] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.440780] EIP is at __fput+0x50/0x380
[    0.440780] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.440780] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.440780]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.440780] CR0: 8005003b CR2: 00000000 CR3: 0d10b000 CR4: 000006b0
[    0.440780] Stack:
[    0.440780]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.440780]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.440780]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.440780] Call Trace:
[    0.440780]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.440780]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.440780]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.440780]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.440780]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.440780]  [<c1050c42>] kthread+0x92/0xa0
[    0.440780]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.440780]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.440780] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.440780] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.440780] CR2: 0000000000000000
[    0.457515] ---[ end trace 0e5a4f7de707cf42 ]---
[    0.460786] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6d00 with usage -1

dmesg-yocto-waimea-13:20131009162615:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.435422] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.442521] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.443270] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.443728] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.444339] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.444788] Modules linked in:
[    0.445120] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.445669] Workqueue: events delayed_fput
[    0.445669] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.445669] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.445669] EIP is at __fput+0x50/0x380
[    0.445669] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.445669] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.445669]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.445669] CR0: 8005003b CR2: 00000000 CR3: 0d10d000 CR4: 000006b0
[    0.445669] Stack:
[    0.445669]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.445669]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.445669]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.445669] Call Trace:
[    0.445669]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.445669]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.445669]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.445669]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.445669]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.445669]  [<c1050c42>] kthread+0x92/0xa0
[    0.445669]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.445669]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.445669] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.445669] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.445669] CR2: 0000000000000000
[    0.461494] ---[ end trace b2929bac14a5c78d ]---
[    0.464652] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6d00 with usage -1

dmesg-yocto-waimea-3:20131009162715:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.443848] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.450955] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.451729] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.452205] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.452834] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.453299] Modules linked in:
[    0.453299] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.453299] Workqueue: events delayed_fput
[    0.453299] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.453299] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.453299] EIP is at __fput+0x50/0x380
[    0.453299] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.453299] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.453299]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.453299] CR0: 8005003b CR2: 00000000 CR3: 0d10b000 CR4: 000006b0
[    0.453299] Stack:
[    0.453299]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.453299]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.453299]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.453299] Call Trace:
[    0.453299]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.453299]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.453299]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.453299]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.453299]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.453299]  [<c1050c42>] kthread+0x92/0xa0
[    0.453299]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.453299]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.453299] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.453299] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.453299] CR2: 0000000000000000
[    0.470056] ---[ end trace c86545004fb7c1f8 ]---
[    0.473292] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6d00 with usage -1

dmesg-yocto-waimea-5:20131009162638:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.444934] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.452534] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.453092] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.453092] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.453092] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.453092] Modules linked in:
[    0.453092] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.453092] Workqueue: events delayed_fput
[    0.453092] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.453092] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.453092] EIP is at __fput+0x50/0x380
[    0.453092] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.453092] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.453092]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.453092] CR0: 8005003b CR2: 00000000 CR3: 0d10b000 CR4: 000006b0
[    0.453092] Stack:
[    0.453092]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.453092]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.453092]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.453092] Call Trace:
[    0.453092]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.453092]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.453092]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.453092]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.453092]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.453092]  [<c1050c42>] kthread+0x92/0xa0
[    0.453092]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.453092]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.453092] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.453092] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.453092] CR2: 0000000000000000
[    0.471754] ---[ end trace a80cb7a793b7b7f8 ]---
[    0.475157] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6d00 with usage -1

dmesg-yocto-xian-13:20131009083020:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.502865] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.511394] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.512125] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.512337] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.512337] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.512337] Modules linked in:
[    0.512337] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.512337] Workqueue: events delayed_fput
[    0.512337] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.512337] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.512337] EIP is at __fput+0x50/0x380
[    0.512337] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.512337] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.512337]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.512337] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.512337] Stack:
[    0.512337]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.512337]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.512337]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.512337] Call Trace:
[    0.512337]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.512337]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.512337]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.512337]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.512337]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.512337]  [<c1050c42>] kthread+0x92/0xa0
[    0.512337]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.512337]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.512337] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.512337] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.512337] CR2: 0000000000000000
[    0.529142] ---[ end trace 5a6c6b560abd06ef ]---
[    0.532351] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-xian-30:20131009082927:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.592775] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.601919] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.602633] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.603067] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.603573] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.603573] Modules linked in:
[    0.603573] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.603573] Workqueue: events delayed_fput
[    0.603573] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.603573] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.603573] EIP is at __fput+0x50/0x380
[    0.603573] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.603573] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.603573]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.603573] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.603573] Stack:
[    0.603573]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.603573]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.603573]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.603573] Call Trace:
[    0.603573]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.603573]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.603573]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.603573]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.603573]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.603573]  [<c1050c42>] kthread+0x92/0xa0
[    0.603573]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.603573]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.603573] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.603573] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.603573] CR2: 0000000000000000
[    0.619888] ---[ end trace 89172d650daf067d ]---
[    0.623592] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6c80 with usage -1

dmesg-yocto-xps-7:20131009162609:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.458692] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.466465] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.467123] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.467487] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.467998] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.468382] Modules linked in:
[    0.468434] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.468434] Workqueue: events delayed_fput
[    0.468434] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.468434] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.468434] EIP is at __fput+0x50/0x380
[    0.468434] EAX: 00000000 EBX: cd0e3200 ECX: 00000000 EDX: 0000001d
[    0.468434] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.468434]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.468434] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.468434] Stack:
[    0.468434]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.468434]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.468434]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.468434] Call Trace:
[    0.468434]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.468434]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.468434]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.468434]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.468434]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.468434]  [<c1050c42>] kthread+0x92/0xa0
[    0.468434]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.468434]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.468434] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.468434] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.468434] CR2: 0000000000000000
[    0.482193] ---[ end trace ec2a3ff42e5d2c28 ]---
[    0.485114] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6d00 with usage -1

dmesg-yocto-xps-7:20131009162631:i386-randconfig-r8-1005:3.12.0-rc1-00050-g0c44c2d:1

[    0.441321] debug: unmapping init [mem 0xc14df000-0xc1524fff]

mount: mounting proc on /proc failed: No such device
[    0.449600] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.450229] IP: [<c110a6e0>] __fput+0x50/0x380
[    0.450626] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.450913] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.450913] Modules linked in:
[    0.450913] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 3.12.0-rc1-00050-g0c44c2d #1
[    0.450913] Workqueue: events delayed_fput
[    0.450913] task: c0035f90 ti: ce866000 task.ti: ce866000
[    0.450913] EIP: 0060:[<c110a6e0>] EFLAGS: 00010212 CPU: 0
[    0.450913] EIP is at __fput+0x50/0x380
[    0.450913] EAX: 00000000 EBX: cd0e3f00 ECX: 00000000 EDX: 0000001d
[    0.450913] ESI: 00000010 EDI: 00000000 EBP: ce867e98 ESP: ce867e70
[    0.450913]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.450913] CR0: 8005003b CR2: 00000000 CR3: 0d10a000 CR4: 000006b0
[    0.450913] Stack:
[    0.450913]  00000246 00000000 00000002 00000000 00000000 00000000 00000000 00000000
[    0.450913]  00000000 c0124540 ce867ea4 c110aa39 c1495640 ce867efc c10492f9 00000000
[    0.450913]  00000002 00000000 c10492c1 00000000 00000000 00000000 0019f047 c0083400
[    0.450913] Call Trace:
[    0.450913]  [<c110aa39>] delayed_fput+0x29/0x30
[    0.450913]  [<c10492f9>] process_one_work+0x2f9/0x650
[    0.450913]  [<c10492c1>] ? process_one_work+0x2c1/0x650
[    0.450913]  [<c104ac2f>] worker_thread+0x28f/0x610
[    0.450913]  [<c104a9a0>] ? cancel_delayed_work_sync+0x20/0x20
[    0.450913]  [<c1050c42>] kthread+0x92/0xa0
[    0.450913]  [<c130ee1b>] ret_from_kernel_thread+0x1b/0x30
[    0.450913]  [<c1050bb0>] ? kthread_create_on_node+0xd0/0xd0
[    0.450913] Code: 00 b8 a0 53 41 c1 e8 80 ff f4 ff e8 1b b0 1f 00 8b 43 10 89 c1 89 45 e8 8b 53 40 89 d0 83 e0 02 83 f8 01 19 f6 83 e6 08 83 c6 08 <8b> 01 25 00 f0 ff ff 66 3d 00 40 0f 84 2f 02 00 00 81 e2 00 00
[    0.450913] EIP: [<c110a6e0>] __fput+0x50/0x380 SS:ESP 0068:ce867e70
[    0.450913] CR2: 0000000000000000
[    0.465551] ---[ end trace 060e117f1134b075 ]---
[    0.469319] Kernel panic - not syncing: CRED: put_cred_rcu() sees cd0c6b00 with usage -2
