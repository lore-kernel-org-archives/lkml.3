Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068Ab3AYFYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 00:24:01 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60084 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3AYFX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 00:23:59 -0500
Message-ID: <510216ED.1090602@wwwdotorg.org>
Date: Thu, 24 Jan 2013 21:23:57 -0800
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: Crash with 9fdb04c "async: replace list of active domains with global
 list of pending items"
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

In next-20130124, I see a crash during boot on my ARM system unless I
revert 9fdb04c "async: replace list of active domains with global list
of pending items". This was reported t me by Venu (CC'd). The kernel log
is below.

Looking at that patch, I note that __async_schedule() does:

> 	list_add_tail(&entry->domain_list, &domain->pending);
> 	if (domain->registered)
> 		list_add_tail(&entry->global_list, &async_global_pending);

... whereas async_run_entry_fn() unconditionally undoes both those
list_add_tail() calls, even if the second never executed and hence the
list entry was never initialized:

> 	list_del_init(&entry->domain_list);
> 	list_del_init(&entry->global_list);

Therefore, I think the fix is:

diff --git a/kernel/async.c b/kernel/async.c
index 6958000..3507d5a 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -137,7 +137,8 @@ static void async_run_entry_fn(struct work_struct *work)
        /* 2) remove self from the pending queues */
        spin_lock_irqsave(&async_lock, flags);
        list_del_init(&entry->domain_list);
-       list_del_init(&entry->global_list);
+       if (entry->domain->registered)
+               list_del_init(&entry->global_list);

        /* 3) free the entry */
        kfree(entry);

At least, that does prevent the crash I was seeing.

> [    1.209020] usbhid: USB HID core driver
> [    1.215662] usb 1-1: new high-speed USB device number 2 using tegra-ehci
> [    1.226634] Unable to handle kernel NULL pointer dereference at virtual address 00000004
> [    1.234707] pgd = c0004000
> [    1.237403] [00000004] *pgd=00000000
> [    1.240974] Internal error: Oops: 805 [#1] PREEMPT SMP ARM
> [    1.246444] Modules linked in:
> [    1.249495] CPU: 0    Not tainted  (3.8.0-rc4-00154-g9fdb04c #31)
> [    1.255579] PC is at async_run_entry_fn+0x94/0x188
> [    1.260357] LR is at async_run_entry_fn+0x68/0x188
> [    1.265135] pc : [<c004b424>]    lr : [<c004b3f8>]    psr: 60000193
> [    1.265135] sp : ee061ec0  ip : 00000000  fp : c074a0cc
> [    1.276587] r10: 00000000  r9 : ee2d2750  r8 : 60000113
> [    1.281796] r7 : ee2d2750  r6 : ee2d2740  r5 : c0749fc0  r4 : c074a5a8
> [    1.288306] r3 : ee2d2748  r2 : 00000000  r1 : 00000000  r0 : ee2d2740
> [    1.294817] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [    1.302193] Control: 10c5387d  Table: 0000404a  DAC: 00000015
> [    1.307923] Process kworker/u:0 (pid: 6, stack limit = 0xee060238)
> [    1.314086] Stack: (0xee061ec0 to 0xee062000)
> [    1.318433] 1ec0: c0f8b18c c06e54e8 ee061efc c0052054 c06e54e8 ee039ec0 c0749fc0 ee039ec0
> [    1.326592] 1ee0: c0749fc0 ee060000 ee04ae00 00000000 ee2d2750 c003d1c0 c0749fc0 c003f8a4
> [    1.334751] 1f00: ee2a6840 00000000 00000000 ee039ec0 c074a0cc ee060000 c074a0d4 ee039ed4
> [    1.342910] 1f20: c06e54e8 677d46cf c06d9c00 c003fab4 ee039ec0 c0749fc0 c06d9c00 c06d9c00
> [    1.351070] 1f40: ee039ec0 ee053e74 ee061f6c 00000000 ee039ec0 c003f940 00000000 00000000
> [    1.359229] 1f60: 00000000 c0044578 dfbe67df 00000000 bdfff7fd ee039ec0 00000000 00000000
> [    1.367389] 1f80: ee061f80 ee061f80 00000000 00000000 ee061f90 ee061f90 ee053e74 c00444d0
> [    1.375547] 1fa0: 00000000 00000000 00000000 c000e5b8 00000000 00000000 00000000 00000000
> [    1.383707] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    1.391866] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 a5eaafdf feb77e37
> [    1.400039] [<c004b424>] (async_run_entry_fn+0x94/0x188) from [<c003d1c0>] (process_one_work+0x128/0x400)
> [    1.409592] [<c003d1c0>] (process_one_work+0x128/0x400) from [<c003fab4>] (worker_thread+0x174/0x4a8)
> [    1.418800] [<c003fab4>] (worker_thread+0x174/0x4a8) from [<c0044578>] (kthread+0xa8/0xb4)
> [    1.427057] [<c0044578>] (kthread+0xa8/0xb4) from [<c000e5b8>] (ret_from_fork+0x14/0x3c)
> [    1.435131] Code: e596200c e5961008 e5076010 e5866004 (e5812004) 
> [    1.441224] ---[ end trace cd37b837c57b2b30 ]---
> [    1.445830] note: kworker/u:0[6] exited with preempt_count 1
> [    1.451531] Unable to handle kernel paging request at virtual address ffffffec
> [    1.458734] pgd = c0004000
> [    1.461430] [ffffffec] *pgd=2e7f5821, *pte=00000000, *ppte=00000000
> [    1.467698] Internal error: Oops: 17 [#2] PREEMPT SMP ARM
> [    1.473080] Modules linked in:
> [    1.476128] CPU: 0    Tainted: G      D       (3.8.0-rc4-00154-g9fdb04c #31)
> [    1.483163] PC is at kthread_data+0x4/0xc
> [    1.487161] LR is at wq_worker_sleeping+0xc/0xe8
> [    1.491766] pc : [<c0044798>]    lr : [<c0040170>]    psr: 00000193
> [    1.491766] sp : ee061ba0  ip : 00000000  fp : ee061c6c
> [    1.503217] r10: ee045350  r9 : ee0452d4  r8 : c06d9c40
> [    1.508426] r7 : ee060000  r6 : c0f82c40  r5 : 00000000  r4 : 00000000
> [    1.514936] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : ee045080
> [    1.521446] Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [    1.528650] Control: 10c5387d  Table: 0000404a  DAC: 00000015
> [    1.534379] Process kworker/u:0 (pid: 6, stack limit = 0xee060238)
> [    1.540541] Stack: (0xee061ba0 to 0xee062000)
> [    1.544888] 1ba0: ee045080 c04ed074 00000007 00000001 ee061bf4 00000000 c070b604 60000193
> [    1.553048] 1bc0: c070b5f0 00000004 ee004900 c06d9c40 c06d9c40 c06d9c40 ee061bf4 00000008
> [    1.561207] 1be0: ee0450e0 c06d9c40 c06d9c40 c06d9c40 c06d9c40 c06d9c40 ee047580 c07278d8
> [    1.569367] 1c00: 00000170 c00c65ec ee045080 ee042280 ee047a84 ee047580 ee045080 c002c03c
> [    1.577526] 1c20: ee061c5c 00200200 c06de040 ee03ea40 00000000 00000001 c06d8700 00000000
> [    1.585685] 1c40: ee045078 ee03ea40 ee061c8c ee045080 00000001 ee045078 ee03ea40 ee061c8c
> [    1.593845] 1c60: ee0452d4 ee0452d4 ee0452d4 c002d324 c06e8ca8 ee061c84 ee060000 00000001
> [    1.602004] 1c80: 60000193 000e000e ee061c84 ee04531c ee060000 c0726f98 ee060000 0000000b
> [    1.610163] 1ca0: c06e8ca8 00000001 ee061cff 00000000 60000193 c0011ce8 ee060238 0000000b
> [    1.618321] 1cc0: 00000004 60000193 00000000 00000008 36393565 63303032 39356520 30303136
> [    1.626482] 1ce0: 35652038 30363730 65203031 36363835 20343030 38356528 30303231 00202934
> [    1.634642] 1d00: c074a0cc c04ead30 c06179e4 ee061e78 00000004 00000000 00000805 00000000
> [    1.642802] 1d20: ee045080 00000000 c074a0cc c0019860 00000805 00000000 ee060000 ee061e78
> [    1.650962] 1d40: 00000004 c00199f0 c06d9c40 c06d9c40 491ba708 00000000 c0f81db0 00000029
> [    1.659122] 1d60: 00000800 c06d9c40 c06d9c40 c06d9c40 00004e20 00000000 47444ef8 00000000
> [    1.667281] 1d80: 00000000 c0055204 c06d9c40 00000001 c06d9c40 00000000 00000002 00000001
> [    1.675440] 1da0: 0000000a ffffffff 00000000 00000000 00000000 00000805 00000004 ee061e78
> [    1.683599] 1dc0: 00000005 c06e96c8 ee2d2750 00000000 c074a0cc c00085c4 00000000 00000002
> [    1.691757] 1de0: ee061e7c c04eb070 00000000 00000000 0001c000 00000000 00000000 00000000
> [    1.699917] 1e00: 00000002 00000000 00018f9c c05f3534 c05f3534 ffffffff c05f3534 c05f3536
> [    1.708077] 1e20: 00000002 ee2543f0 ee2540c0 c074a570 ee078e80 00000001 00000001 c0058f14
> [    1.716236] 1e40: 00000400 00000000 ee061e7c ee2540c0 00000001 00000000 00000002 00000000
> [    1.724395] 1e60: c004b424 60000193 ffffffff ee061eac 60000113 c000e138 ee2d2740 00000000
> [    1.732555] 1e80: 00000000 ee2d2748 c074a5a8 c0749fc0 ee2d2740 ee2d2750 60000113 ee2d2750
> [    1.740714] 1ea0: 00000000 c074a0cc 00000000 ee061ec0 c004b3f8 c004b424 60000193 ffffffff
> [    1.748873] 1ec0: c0f8b18c c06e54e8 ee061efc c0052054 c06e54e8 ee039ec0 c0749fc0 ee039ec0
> [    1.757032] 1ee0: c0749fc0 ee060000 ee04ae00 00000000 ee2d2750 c003d1c0 c0749fc0 c003f8a4
> [    1.765192] 1f00: ee2a6840 00000000 00000000 ee039ec0 c074a0cc ee060000 c074a0d4 ee039ed4
> [    1.773351] 1f20: c06e54e8 677d46cf c06d9c00 c003fab4 ee039ec0 c0749fc0 c06d9c00 c06d9c00
> [    1.781510] 1f40: ee039ec0 ee053e74 ee061f6c 00000000 ee039ec0 c003f940 00000000 00000000
> [    1.789669] 1f60: 00000000 c0044578 dfbe67df 00000000 bdfff7fd ee039ec0 00000000 00000000
> [    1.797829] 1f80: ee061f80 ee061f80 00000001 00010001 ee061f90 ee061f90 ee053e74 c00444d0
> [    1.805987] 1fa0: 00000000 00000000 00000000 c000e5b8 00000000 00000000 00000000 00000000
> [    1.814145] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    1.822304] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 a5eaafdf feb77e37
> [    1.830469] [<c0044798>] (kthread_data+0x4/0xc) from [<c0040170>] (wq_worker_sleeping+0xc/0xe8)
> [    1.839153] [<c0040170>] (wq_worker_sleeping+0xc/0xe8) from [<c04ed074>] (__schedule+0x4f4/0x6ec)
> [    1.848020] [<c04ed074>] (__schedule+0x4f4/0x6ec) from [<c002d324>] (do_exit+0x5ec/0x874)
> [    1.856188] [<c002d324>] (do_exit+0x5ec/0x874) from [<c0011ce8>] (die+0x1e4/0x3ac)
> [    1.863755] [<c0011ce8>] (die+0x1e4/0x3ac) from [<c0019860>] (__do_kernel_fault+0x64/0x84)
> [    1.872005] [<c0019860>] (__do_kernel_fault+0x64/0x84) from [<c00199f0>] (do_page_fault+0x170/0x3a4)
> [    1.881121] [<c00199f0>] (do_page_fault+0x170/0x3a4) from [<c00085c4>] (do_DataAbort+0x30/0x9c)
> [    1.889803] [<c00085c4>] (do_DataAbort+0x30/0x9c) from [<c000e138>] (__dabt_svc+0x38/0x60)
> [    1.898046] Exception stack(0xee061e78 to 0xee061ec0)
> [    1.903084] 1e60:                                                       ee2d2740 00000000
> [    1.911243] 1e80: 00000000 ee2d2748 c074a5a8 c0749fc0 ee2d2740 ee2d2750 60000113 ee2d2750
> [    1.919404] 1ea0: 00000000 c074a0cc 00000000 ee061ec0 c004b3f8 c004b424 60000193 ffffffff
> [    1.927565] [<c000e138>] (__dabt_svc+0x38/0x60) from [<c004b424>] (async_run_entry_fn+0x94/0x188)
> [    1.936421] [<c004b424>] (async_run_entry_fn+0x94/0x188) from [<c003d1c0>] (process_one_work+0x128/0x400)
> [    1.945970] [<c003d1c0>] (process_one_work+0x128/0x400) from [<c003fab4>] (worker_thread+0x174/0x4a8)
> [    1.955173] [<c003fab4>] (worker_thread+0x174/0x4a8) from [<c0044578>] (kthread+0xa8/0xb4)
> [    1.963423] [<c0044578>] (kthread+0xa8/0xb4) from [<c000e5b8>] (ret_from_fork+0x14/0x3c)
> [    1.971496] Code: e513001c e7e00150 e12fff1e e59032a4 (e5130014) 
> [    1.977573] ---[ end trace cd37b837c57b2b31 ]---
> [    1.982175] Fixing recursive fault but reboot is needed!
