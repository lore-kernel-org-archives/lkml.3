Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaBJLZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:25:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:26250 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbaBJLZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:25:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,817,1384329600"; 
   d="scan'208";a="472705012"
Date: Mon, 10 Feb 2014 19:25:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [process_vm_access] BUG: unable to handle kernel paging request
 at fffffff27b92dd20
Message-ID: <20140210112527.GA14259@localhost>
References: <20140210112231.GA11951@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210112231.GA11951@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 07:22:31PM +0800, Fengguang Wu wrote:
> Hi Al,
> 
> We noticed the below oops since commit 68a25f08c9bec07ad95e55a01b127168e43aed84
> ("process_vm_access: take get_user_pages/put_pages one level up")
> while running ltp tests inside kvm.
> 
> [  466.193846] BUG: unable to handle kernel paging request at fffffff27b92dd20
> [  466.195225] IP: [<ffffffff81190d7f>] put_page+0x5/0x28
> [  466.196263] PGD 220d067 PUD 0
> [  466.197137] Oops: 0000 [#1] SMP
> [  466.197261] Modules linked in: msr microcode processor
> [  466.197261] CPU: 2 PID: 30338 Comm: process_vm01 Not tainted 3.14.0-rc1-00027-g68a25f0 #1
> [  466.197261] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  466.197261] task: ffff88007c11ecc0 ti: ffff88007b92c000 task.ti: ffff88007b92c000
> [  466.197261] RIP: 0010:[<ffffffff81190d7f>]  [<ffffffff81190d7f>] put_page+0x5/0x28
> [  466.197261] RSP: 0018:ffff88007b92dc98  EFLAGS: 00010286
> [  466.197261] RAX: fffffffffffffff0 RBX: 0000000000000000 RCX: 0000000000001000
> [  466.197261] RDX: 0000000000000000 RSI: 0000000097230000 RDI: fffffff27b92dd20
> [  466.197261] RBP: ffff88007b92dde8 R08: 0000000000000000 R09: 00007fe39722f001
> [  466.197261] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007c11ecc0
> [  466.197261] R13: ffff88007b92dd40 R14: fffffffffffffff2 R15: ffff88007b92de10
> [  466.197261] FS:  00007fe397228700(0000) GS:ffff88011fd00000(0000) knlGS:0000000000000000
> [  466.197261] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  466.197261] CR2: fffffff27b92dd20 CR3: 000000007f537000 CR4: 00000000000006e0
> [  466.197261] Stack:
> [  466.197261]  ffffffff811b7ea1 ffff88007b92dd40 0000000000000000 000000000000000d
> [  466.197261]  ffffffff81f7ad76 fffffff27b92dd20 ffff88007baa4420 0000000000000001
> [  466.197261]  0000000000000000 ffff88007b92deb0 0000000000001000 0000000000000001
> [  466.197261] Call Trace:
> [  466.197261]  [<ffffffff811b7ea1>] ? process_vm_rw_core.isra.1+0x39f/0x444
> [  466.197261]  [<ffffffff811aadbb>] ? handle_mm_fault+0x9e9/0xc9c
> [  466.197261]  [<ffffffff811a65f0>] ? might_fault+0x3e/0x40
> [  466.197261]  [<ffffffff811e2264>] ? rw_copy_check_uvector+0x6f/0xfd
> [  466.197261]  [<ffffffff811b8017>] process_vm_rw+0xd1/0x117
> [  466.197261]  [<ffffffff811b05ae>] ? do_mmap_pgoff+0x2e1/0x34c
> [  466.197261]  [<ffffffff8119d9fe>] ? vm_mmap_pgoff+0x72/0x94
> [  466.197261]  [<ffffffff81a2eb5e>] ? do_page_fault+0xe/0x10
> [  466.197261]  [<ffffffff8151472b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> [  466.197261]  [<ffffffff811b8073>] SyS_process_vm_readv+0x16/0x18
> [  466.197261]  [<ffffffff81a32b29>] system_call_fastpath+0x16/0x1b

And after commit 7a94f15212 ("process_vm_access: tidy up a bit"),
the oops message changed to

[  489.753228] general protection fault: 0000 [#1] SMP 
[  489.754217] Modules linked in: msr processor
[  489.755165] CPU: 3 PID: 30485 Comm: process_vm01 Not tainted 3.14.0-rc1-00030-g7a94f15 #1
[  489.756603] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  489.756673] task: ffff88007abc1220 ti: ffff88007cf0e000 task.ti: ffff88007cf0e000
[  489.756673] RIP: 0010:[<ffffffff811908a0>]  [<ffffffff811908a0>] put_compound_page+0x39/0x1db
[  489.756673] RSP: 0018:ffff88007cf0fc70  EFLAGS: 00010282
[  489.756673] RAX: a2e9fa894cc58949 RBX: 415e415d415c415b RCX: 0000000000001000
[  489.756673] RDX: 0000000000000000 RSI: 000000001dbef000 RDI: ffffffff81512ab6
[  489.756673] RBP: ffff88007cf0fc90 R08: 0000000000000000 R09: 00007f611dbee001
[  489.756673] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81512ab6
[  489.756673] R13: ffff88007cf0fd40 R14: 00000000fffffff1 R15: fffffffffffffff2
[  489.756673] FS:  00007f611dbe7700(0000) GS:ffff88011fd80000(0000) knlGS:0000000000000000
[  489.756673] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  489.756673] CR2: 00007f611dbee000 CR3: 0000000079c80000 CR4: 00000000000006e0
[  489.756673] Stack:
[  489.756673]  ffff88007cf0fe10 ffff88007abc1220 ffff88007cf0fd40 00000000fffffff1
[  489.756673]  ffff88007cf0fca0 ffffffff81190d91 ffff88007cf0fde8 ffffffff811b7eb0
[  489.756673]  ffff88007cf0fd40 0000000000000000 ffff88007cf0fd20 ffffffff81512ab6
[  489.756673] Call Trace:
[  489.756673]  [<ffffffff81190d91>] put_page+0x17/0x28
[  489.756673]  [<ffffffff811b7eb0>] process_vm_rw_core.isra.1+0x3ae/0x40e
[  489.756673]  [<ffffffff81512ab6>] ? vsnprintf+0x3bc/0x3f7
[  489.756673]  [<ffffffff811aadbb>] ? handle_mm_fault+0x9e9/0xc9c
[  489.756673]  [<ffffffff811a65f0>] ? might_fault+0x3e/0x40
[  489.756673]  [<ffffffff811e222e>] ? rw_copy_check_uvector+0x6f/0xfd
[  489.756673]  [<ffffffff811b7fe1>] process_vm_rw+0xd1/0x117
[  489.756673]  [<ffffffff811b05ae>] ? do_mmap_pgoff+0x2e1/0x34c
[  489.756673]  [<ffffffff8119d9fe>] ? vm_mmap_pgoff+0x72/0x94
[  489.756673]  [<ffffffff81a2eb1e>] ? do_page_fault+0xe/0x10
[  489.756673]  [<ffffffff815146eb>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[  489.756673]  [<ffffffff811b803d>] SyS_process_vm_readv+0x16/0x18
[  489.756673]  [<ffffffff81a32ae9>] system_call_fastpath+0x16/0x1b
[  489.756673] Code: 54 49 89 fc 53 48 8b 07 f6 c4 80 75 0f f0 ff 4f 1c 0f 84 21 01 00 00 e9 17 01 00 00 48 8b 07 48 89 fb f6 c4 80 74 04 48 8b 5f 30 <48> 8b 13 31 c0 80 e2 80 75 10 48 89 df e8 83 e5 02 00 85 c0 0f 
[  489.756673] RIP  [<ffffffff811908a0>] put_compound_page+0x39/0x1db

Thanks,
Fengguang
