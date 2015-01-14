Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbbANVen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:34:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:6372 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbbANVem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:34:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,758,1418112000"; 
   d="scan'208";a="670013320"
From: Imre Deak <imre.deak@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] xen/xtime: remove incorrect preemption enabled assert
Date: Wed, 14 Jan 2015 13:34:32 -0800
Message-Id: <1421271272-9852-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since

commit 250a1ac685f147d4f4b2f132cfaffcce1a6792c1
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Dec 5 08:48:29 2014 +0000

    x86, smpboot: Remove pointless preempt_disable() in
    native_smp_prepare_cpus()

the assert in xen_setup_cpu_clockevents() is incorrect, causing the
following BUG:

[    0.192725] smpboot: CPU0: Intel(R) Core(TM) i7-3770S CPU @ 3.10GHz (fam: 06, model: 2e, stepping: 09)
[    0.201926] Xen: using vcpuop timer interface
[    0.204011] installing Xen timer for CPU 0
[    0.208085] ------------[ cut here ]------------
[    0.212000] kernel BUG at arch/x86/xen/time.c:461!
[    0.212000] invalid opcode: 0000 [#1] PREEMPT SMP
[    0.212000] Modules linked in:
[    0.212000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc4-imre+ #4
[    0.212000] Hardware name: Xen HVM domU, BIOS 4.1.2 10/16/2014
[    0.212000] task: ffff88003c170000 ti: ffff88003c178000 task.ti: ffff88003c178000
[    0.212000] RIP: 0010:[<ffffffff8100dc73>]  [<ffffffff8100dc73>] xen_setup_cpu_clockevents+0x23/0x50
[    0.212000] RSP: 0000:ffff88003c17be58  EFLAGS: 00010202
[    0.212000] RAX: 0000000000000246 RBX: 0000000000000000 RCX: 0000000000000000
[    0.212000] RDX: 0000000000000000 RSI: ffffffff81800240 RDI: ffff88003dc0af40
[    0.212000] RBP: ffff88003c17be68 R08: 0000000000000048 R09: 000000000000000d
[    0.212000] R10: 0000000000000000 R11: 0000000000000282 R12: 000000000000a0e8
[    0.212000] R13: 000000000000a0f0 R14: 000000000000000f R15: 000000000000000e
[    0.212000] FS:  0000000000000000(0000) GS:ffff88003dc00000(0000) knlGS:0000000000000000
[    0.212000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.212000] CR2: ffff880002ec0000 CR3: 0000000001c12000 CR4: 00000000001006f0
[    0.212000] Stack:
[    0.212000]  000000000000000f 0000000000000000 ffff88003c17be98 ffffffff81daf60d
[    0.212000]  0000000054b5c08c 000000003435ca0a 0000000000000000 0000000000000000
[    0.212000]  ffff88003c17bee8 ffffffff81dbc286 ffff88003c170000 0000200000000282
[    0.212000] Call Trace:
[    0.212000]  [<ffffffff81daf60d>] xen_time_init+0x85/0xb3
[    0.212000]  [<ffffffff81dbc286>] native_smp_prepare_cpus+0x34e/0x396
[    0.212000]  [<ffffffff81db0cc0>] xen_hvm_smp_prepare_cpus+0x9/0x27
[    0.212000]  [<ffffffff81dab20b>] kernel_init_freeable+0x120/0x26a
[    0.212000]  [<ffffffff8175c4fe>] ? kernel_init+0xe/0xf0
[    0.212000]  [<ffffffff8175c4f0>] ? rest_init+0xd0/0xd0
[    0.212000]  [<ffffffff8175c4fe>] kernel_init+0xe/0xf0
[    0.212000]  [<ffffffff8176e7bc>] ret_from_fork+0x7c/0xb0
[    0.212000]  [<ffffffff8175c4f0>] ? rest_init+0xd0/0xd0
[    0.212000] Code: 5e 41 5f 5d c3 0f 1f 00 55 48 89 e5 53 48 83 ec 08 65 8b 05 80 dd ff 7e a9 ff ff ff 7f 75 11 9c 58 66 66 90 66 90 f6 c4 02 74 05 <0f> 0b 0f 1f 00 e8 33 47 34 00 89 c0 48 c7 c3 80 ae 00 00 48 89
[    0.212000] RIP  [<ffffffff8100dc73>] xen_setup_cpu_clockevents+0x23/0x50
[    0.212000]  RSP <ffff88003c17be58>
[    0.428007] ---[ end trace 73a740f3f01d4332 ]---
[    0.432017] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 arch/x86/xen/time.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index f473d26..23019b4 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -458,8 +458,6 @@ void xen_setup_timer(int cpu)
 
 void xen_setup_cpu_clockevents(void)
 {
-	BUG_ON(preemptible());
-
 	clockevents_register_device(this_cpu_ptr(&xen_clock_events.evt));
 }
 
-- 
1.9.1

