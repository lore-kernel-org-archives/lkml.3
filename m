Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbaLJUud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:50:33 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61974 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527AbaLJUub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:50:31 -0500
Date: Wed, 10 Dec 2014 20:50:23 +0000
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 3/3] Drivers: hv: hv_balloon: Don't post pressure status
 from interrupt context
Message-ID: <20141210205023.GA1209@sucs.org>
References: <1417559331-13691-1-git-send-email-kys@microsoft.com>
 <1417559355-13730-1-git-send-email-kys@microsoft.com>
 <1417559355-13730-3-git-send-email-kys@microsoft.com>
 <20141207080433.GA4531@sucs.org>
 <BY2PR0301MB07114733895C69D3CC61A90AA0640@BY2PR0301MB0711.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY2PR0301MB07114733895C69D3CC61A90AA0640@BY2PR0301MB0711.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 06:04:35AM +0000, KY Srinivasan wrote:
> 
> Greg has not committed these patches yet. One of the patches changes the balloon floor.
> This means that the guest will not be ballooned down below the floor. Is this what you are
> seeing? In our testing we did not see anything unusual other than the floor being elevated
> (as per the design).

I applied the following:

drivers-scsi-storvsc-Fix-a-bug-in-handling-ring-buffer-failures-that-may-result-in-I-O-freeze.patch
V2-1-3-Drivers-hv-hv_balloon-Make-adjustments-in-computing-the-floor.patch
V2-2-3-Drivers-hv-hv_balloon-Fix-a-locking-bug-in-the-balloon-driver.patch
V2-3-3-Drivers-hv-hv_balloon-Don-t-post-pressure-status-from-interrupt-context.patch

Initially things looked OK but now I'm starting to see the following
which is rather worrying:

Dec 10 20:37:11 a kernel: BUG: unable to handle kernel NULL pointer dereference at           (null)
Dec 10 20:37:11 a kernel: IP: [<ffffffff811c30a0>] commit_charge+0x20/0x90
Dec 10 20:37:11 a kernel: PGD e44cb067 PUD e4495067 PMD 0 
Dec 10 20:37:11 a kernel: Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Dec 10 20:37:11 a kernel: CPU: 5 PID: 1490 Comm: ruby Not tainted 3.18.0.x86_64-01967-g86c6a2f-dirty #163
Dec 10 20:37:11 a kernel: Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
Dec 10 20:37:11 a kernel: task: ffff8800e9bce040 ti: ffff880003890000 task.ti: ffff880003890000
Dec 10 20:37:11 a kernel: RIP: 0010:[<ffffffff811c30a0>]  [<ffffffff811c30a0>] commit_charge+0x20/0x90
Dec 10 20:37:11 a kernel: RSP: 0018:ffff880003893a88  EFLAGS: 00010246
Dec 10 20:37:11 a kernel: RAX: 0000000000000000 RBX: ffffea00048d0380 RCX: 0000000000000006
Dec 10 20:37:11 a kernel: RDX: 0000000000000480 RSI: ffff880108829bd8 RDI: 000000000012340e
Dec 10 20:37:11 a kernel: RBP: ffff880003893ac8 R08: 0000000000000000 R09: 0000000000000000
Dec 10 20:37:11 a kernel: R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
Dec 10 20:37:11 a kernel: R13: ffff880108829bd8 R14: ffff880017669c58 R15: 0000000000000000
Dec 10 20:37:11 a kernel: FS:  00007f4dc62fa740(0000) GS:ffff88010d4a0000(0000) knlGS:0000000000000000
Dec 10 20:37:11 a kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec 10 20:37:11 a kernel: CR2: 0000000000000000 CR3: 00000000f1459000 CR4: 00000000000406e0
Dec 10 20:37:11 a kernel: Stack:
Dec 10 20:37:11 a kernel:  ffff8800e9bce040 ffffffff816f3950 0000000000000000 ffff880017669c58
Dec 10 20:37:11 a kernel:  ffff880003893ac8 ffffea00048d0380 ffff880108829bd8 0000000000000000
Dec 10 20:37:11 a kernel:  ffff880003893af8 ffffffff811c6b36 ffff880003893af8 ffffea00048d0380
Dec 10 20:37:11 a kernel: Call Trace:
Dec 10 20:37:11 a kernel:  [<ffffffff816f3950>] ? _raw_spin_unlock_irq+0x30/0x50
Dec 10 20:37:11 a kernel:  [<ffffffff811c6b36>] mem_cgroup_commit_charge+0x76/0x140
Dec 10 20:37:11 a kernel:  [<ffffffff8115d8d5>] __add_to_page_cache_locked+0x1e5/0x2d0
Dec 10 20:37:11 a kernel:  [<ffffffff8115dfb8>] add_to_page_cache_lru+0x28/0x80
Dec 10 20:37:11 a kernel:  [<ffffffff8115f347>] pagecache_get_page+0x197/0x220
Dec 10 20:37:11 a kernel:  [<ffffffff81160cc3>] grab_cache_page_write_begin+0x33/0x50
Dec 10 20:37:11 a kernel:  [<ffffffff81254fd7>] ext4_da_write_begin+0x157/0x340
Dec 10 20:37:11 a kernel:  [<ffffffff81160da1>] generic_perform_write+0xc1/0x1d0
Dec 10 20:37:11 a kernel:  [<ffffffff81161138>] __generic_file_write_iter+0x288/0x340
Dec 10 20:37:11 a kernel:  [<ffffffff8124a693>] ext4_file_write_iter+0x2f3/0x3b0
Dec 10 20:37:11 a kernel:  [<ffffffff811cde47>] ? vfs_write+0xa7/0x1d0
Dec 10 20:37:11 a kernel:  [<ffffffff811cdc31>] new_sync_write+0x81/0xb0
Dec 10 20:37:11 a kernel:  [<ffffffff811cde6b>] vfs_write+0xcb/0x1d0
Dec 10 20:37:11 a kernel:  [<ffffffff811ce069>] SyS_write+0x49/0xb0
Dec 10 20:37:11 a kernel:  [<ffffffff816f45a9>] system_call_fastpath+0x12/0x17
Dec 10 20:37:11 a kernel: Code: 5d c3 66 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 55 49 89 f5 41 54 41 89 d4 53 48 89 fb 48 83 ec 28 e8 90 3e 00 00 <f6> 00 01 74 1b 48 c7 c6 e0 f1 9e 81 48 89 df e8 cc 4f fc ff 0f 
Dec 10 20:37:11 a kernel: RIP  [<ffffffff811c30a0>] commit_charge+0x20/0x90
Dec 10 20:37:11 a kernel:  RSP <ffff880003893a88>
Dec 10 20:37:11 a kernel: CR2: 0000000000000000
Dec 10 20:37:11 a kernel: BUG: unable to handle kernel 
Dec 10 20:37:11 a kernel: ---[ end trace 0ae405bbdfb1f416 ]---
Dec 10 20:37:11 a kernel: NULL pointer dereference
Dec 10 20:37:11 a kernel:  at           (null)
Dec 10 20:37:11 a kernel: IP: [<ffffffff811c30a0>] commit_charge+0x20/0x90
Dec 10 20:37:11 a kernel: PGD f17d4067 PUD f1567067 PMD 0 
Dec 10 20:37:12 a kernel: Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
Dec 10 20:37:12 a kernel: CPU: 2 PID: 25465 Comm: ruby Tainted: G      D        3.18.0.x86_64-01967-g86c6a2f-dirty #163
Dec 10 20:37:12 a kernel: Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
Dec 10 20:37:12 a kernel: task: ffff880011a16040 ti: ffff880098754000 task.ti: ffff880098754000
Dec 10 20:37:12 a kernel: init_memory_mapping: [mem 0x128000000-0x12fffffff]
Dec 10 20:37:12 a kernel:  [mem 0x128000000-0x12fffffff] page 4k
Dec 10 20:37:12 a kernel:  [ffffea0004800000-ffffea00049fffff] PMD -> [ffff8800c7400000-ffff8800c75fffff] on node 0
Dec 10 20:37:12 a kernel: RIP: 0010:[<ffffffff811c30a0>]  [<ffffffff811c30a0>] commit_charge+0x20/0x90
Dec 10 20:37:12 a kernel: RSP: 0000:ffff880098757d18  EFLAGS: 00010246
Dec 10 20:37:12 a kernel: RAX: 0000000000000000 RBX: ffffea0004915300 RCX: 0000000000000001
Dec 10 20:37:12 a kernel: RDX: 0000000000000480 RSI: ffff880108829bd8 RDI: 000000000012454c
Dec 10 20:37:12 a kernel: RBP: ffff880098757d58 R08: 0000000000000006 R09: 0000000000000000
Dec 10 20:37:12 a kernel: R10: ffff880011a16040 R11: 0000000000000000 R12: 0000000000000000
Dec 10 20:37:12 a kernel: R13: ffff880108829bd8 R14: ffff8800f159a5f0 R15: ffff88006b3bc600
Dec 10 20:37:12 a kernel: FS:  00007f0836edf700(0000) GS:ffff88010d440000(0000) knlGS:0000000000000000
Dec 10 20:37:12 a kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec 10 20:37:12 a kernel: CR2: 0000000000000000 CR3: 00000000b8bfd000 CR4: 00000000000406e0
Dec 10 20:37:12 a kernel: Stack:
Dec 10 20:37:12 a kernel:  00000000811bf285 ffff88000723e118 ffff880108829bd8 ffff88000723e100
Dec 10 20:37:12 a kernel:  ffffea0004915300 ffffea0004915300 ffff880108829bd8 ffff88000613a280
Dec 10 20:37:12 a kernel:  ffff880098757d88 ffffffff811c6b36 ffffffff8118d6fc 00007f08200bea58
Dec 10 20:37:12 a kernel: Call Trace:
Dec 10 20:37:12 a kernel:  [<ffffffff811c6b36>] mem_cgroup_commit_charge+0x76/0x140
Dec 10 20:37:12 a kernel:  [<ffffffff8118d6fc>] ? handle_mm_fault+0x62c/0x12a0
Dec 10 20:37:12 a kernel:  [<ffffffff8118d742>] handle_mm_fault+0x672/0x12a0
Dec 10 20:37:12 a kernel:  [<ffffffff81041a13>] ? __do_page_fault+0x1c3/0x4f0
Dec 10 20:37:12 a kernel:  [<ffffffff81041ce0>] __do_page_fault+0x490/0x4f0
Dec 10 20:37:12 a kernel:  [<ffffffff810bf2cd>] ? trace_hardirqs_on+0xd/0x10
Dec 10 20:37:12 a kernel:  [<ffffffff816f3950>] ? _raw_spin_unlock_irq+0x30/0x50
Dec 10 20:37:12 a kernel:  [<ffffffff81097a88>] ? finish_task_switch+0x88/0x100
Dec 10 20:37:12 a kernel:  [<ffffffff81097a4a>] ? finish_task_switch+0x4a/0x100
Dec 10 20:37:12 a kernel:  [<ffffffff816ee380>] ? __schedule+0x6a0/0x830
Dec 10 20:37:12 a kernel:  [<ffffffff813b24ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Dec 10 20:37:12 a kernel:  [<ffffffff81041d92>] do_page_fault+0x22/0x30
Dec 10 20:37:12 a kernel:  [<ffffffff816f6398>] page_fault+0x28/0x30
Dec 10 20:37:12 a kernel: Code: 5d c3 66 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 55 49 89 f5 41 54 41 89 d4 53 48 89 fb 48 83 ec 28 e8 90 3e 00 00 <f6> 00 01 74 1b 48 c7 c6 e0 f1 9e 81 48 89 df e8 cc 4f fc ff 0f 
Dec 10 20:37:12 a kernel: RIP  [<ffffffff811c30a0>] commit_charge+0x20/0x90
Dec 10 20:37:12 a kernel:  RSP <ffff880098757d18>
Dec 10 20:37:12 a kernel: CR2: 0000000000000000
Dec 10 20:37:12 a kernel: ---[ end trace 0ae405bbdfb1f417 ]---
Dec 10 20:37:12 a kernel: BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:41
Dec 10 20:37:12 a kernel: in_atomic(): 1, irqs_disabled(): 1, pid: 25465, name: ruby
Dec 10 20:37:12 a kernel: INFO: lockdep is turned off.
Dec 10 20:37:12 a kernel: irq event stamp: 2431342
Dec 10 20:37:12 a kernel: hardirqs last  enabled at (2431341): [<ffffffff816f38fd>] _raw_spin_unlock_irqrestore+0x4d/0x70
Dec 10 20:37:12 a kernel: hardirqs last disabled at (2431342): [<ffffffff816f37dd>] _raw_spin_lock_irq+0x1d/0x60
Dec 10 20:37:12 a kernel: softirqs last  enabled at (2431322): [<ffffffff81078458>] __do_softirq+0x298/0x340
Dec 10 20:37:12 a kernel: softirqs last disabled at (2431317): [<ffffffff810787c8>] irq_exit+0x58/0xc0
Dec 10 20:37:12 a kernel: CPU: 2 PID: 25465 Comm: ruby Tainted: G      D        3.18.0.x86_64-01967-g86c6a2f-dirty #163
Dec 10 20:37:12 a kernel: Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
Dec 10 20:37:12 a kernel:  0000000000000029 ffff8800987578f8 ffffffff816ea99f 0000000000000000
Dec 10 20:37:12 a kernel:  ffff880011a16040 ffff880098757918 ffffffff810a2dc5 ffff880098757948
Dec 10 20:37:12 a kernel:  ffffffff819d796f ffff880098757948 ffffffff810a2e46 ffffffff82b828c2
Dec 10 20:37:12 a kernel: Call Trace:
Dec 10 20:37:12 a kernel:  [<ffffffff816ea99f>] dump_stack+0x4e/0x68
Dec 10 20:37:12 a kernel:  [<ffffffff810a2dc5>] ___might_sleep+0x115/0x120
Dec 10 20:37:12 a kernel:  [<ffffffff810a2e46>] __might_sleep+0x76/0xa0
Dec 10 20:37:12 a kernel:  [<ffffffff816f1f04>] down_read+0x24/0x70
Dec 10 20:37:12 a kernel:  [<ffffffff81082de4>] exit_signals+0x24/0x140
Dec 10 20:37:12 a kernel:  [<ffffffff81076714>] do_exit+0x134/0xa80
Dec 10 20:37:12 a kernel:  [<ffffffff810cb8cc>] ? kmsg_dump+0xfc/0x110
Dec 10 20:37:12 a kernel:  [<ffffffff810cb7f5>] ? kmsg_dump+0x25/0x110
Dec 10 20:37:12 a kernel:  [<ffffffff810064e8>] oops_end+0xa8/0xc0
Dec 10 20:37:12 a kernel:  [<ffffffff816e53bc>] no_context+0x319/0x362
Dec 10 20:37:12 a kernel:  [<ffffffff816e55d0>] __bad_area_nosemaphore+0x1cb/0x1ea
Dec 10 20:37:12 a kernel:  [<ffffffff816e5602>] bad_area_nosemaphore+0x13/0x15
Dec 10 20:37:12 a kernel:  [<ffffffff81041a3e>] __do_page_fault+0x1ee/0x4f0
Dec 10 20:37:12 a kernel:  [<ffffffff811680d5>] ? __alloc_pages_nodemask+0x225/0xaf0
Dec 10 20:37:12 a kernel:  [<ffffffff813b24ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Dec 10 20:37:12 a kernel:  [<ffffffff81041d92>] do_page_fault+0x22/0x30
Dec 10 20:37:12 a kernel:  [<ffffffff816f6398>] page_fault+0x28/0x30
Dec 10 20:37:12 a kernel:  [<ffffffff811c30a0>] ? commit_charge+0x20/0x90
Dec 10 20:37:12 a kernel:  [<ffffffff811c30a0>] ? commit_charge+0x20/0x90
Dec 10 20:37:12 a kernel:  [<ffffffff811c6b36>] mem_cgroup_commit_charge+0x76/0x140
Dec 10 20:37:12 a kernel:  [<ffffffff8118d6fc>] ? handle_mm_fault+0x62c/0x12a0
Dec 10 20:37:12 a kernel:  [<ffffffff8118d742>] handle_mm_fault+0x672/0x12a0
Dec 10 20:37:12 a kernel:  [<ffffffff81041a13>] ? __do_page_fault+0x1c3/0x4f0
Dec 10 20:37:12 a kernel:  [<ffffffff81041ce0>] __do_page_fault+0x490/0x4f0
Dec 10 20:37:12 a kernel:  [<ffffffff810bf2cd>] ? trace_hardirqs_on+0xd/0x10
Dec 10 20:37:12 a kernel:  [<ffffffff816f3950>] ? _raw_spin_unlock_irq+0x30/0x50
Dec 10 20:37:12 a kernel:  [<ffffffff81097a88>] ? finish_task_switch+0x88/0x100
Dec 10 20:37:12 a kernel:  [<ffffffff81097a4a>] ? finish_task_switch+0x4a/0x100
Dec 10 20:37:12 a kernel:  [<ffffffff816ee380>] ? __schedule+0x6a0/0x830
Dec 10 20:37:12 a kernel:  [<ffffffff813b24ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Dec 10 20:37:12 a kernel:  [<ffffffff81041d92>] do_page_fault+0x22/0x30
Dec 10 20:37:12 a kernel:  [<ffffffff816f6398>] page_fault+0x28/0x30
Dec 10 20:37:12 a kernel: note: ruby[25465] exited with preempt_count 1
Dec 10 20:37:16 a kernel: init_memory_mapping: [mem 0x130000000-0x137ffffff]
Dec 10 20:37:16 a kernel:  [mem 0x130000000-0x137ffffff] page 4k
Dec 10 20:37:16 a kernel:  [ffffea0004a00000-ffffea0004bfffff] PMD -> [ffff880093200000-ffff8800933fffff] on node 0
Dec 10 20:37:17 a kernel: BUG: unable to handle kernel NULL pointer dereference at           (null)
Dec 10 20:37:17 a kernel: IP: [<ffffffff811c30a0>] commit_charge+0x20/0x90

Are these Hyper-V related?

-- 
Sitsofe | http://sucs.org/~sits/
