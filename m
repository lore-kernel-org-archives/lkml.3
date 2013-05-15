Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab3EOP2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:28:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47964 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758243Ab3EOP2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:28:51 -0400
Date: Wed, 15 May 2013 16:28:03 +0100
From: Will Deacon <will.deacon@arm.com>
To: djbw@fb.com, vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andriy.shevchenko@linux.intel.com, viresh.kumar@linaro.org
Subject: dmatest regression in 3.10-rc1
Message-ID: <20130515152803.GL23869@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been observing a regression in the dmatest module with 3.10-rc1. It
manifests as either:

 - a spurious timeout on one or more of the channel threads
 - a complete kernel lockup (loss of console)
 - a panic (see below, noting that the callback [dmatest_callback] is
   dereferencing a NULL pointer)

If I revert 77101ce578bb ("dmatest: cancel thread immediately when asked
for") then things are rosy again, but I'm not sure if this is hiding another
problem.

I'm using 8 iterations, 8 threads per channel and a 128k buffer size,
although I've reproduced it with 1 iteration, 1 thread, default buffer size
too.

Any ideas? Some of the changes to dmatest.c since 3.9 have some fishy
looking synchronisation variables without barriers/atomic accesses, but I'm
reproducing this on a software model so I wouldn't expect too much memory
re-ordering.

Any help appreciated,

Will

--->8

[   18.911813] dmatest: thread dma0chan0-copy1 exited with status 0
[   18.911916] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[   18.911974] pgd = c0003000
[   18.912020] [00000000] *pgd=80000080004003, *pmd=00000000
[   18.912097] Internal error: Oops: 207 [#1] PREEMPT SMP ARM
[   18.912144] Modules linked in: dmatest(-)
[   18.912230] CPU: 0 PID: 651 Comm: dma2chan0-copy3 Not tainted 3.10.0-rc1+ #15
[   18.912300] task: dfac8880 ti: df37a000 task.ti: df37a000
[   18.912378] PC is at _raw_spin_lock_irqsave+0x24/0x60
[   18.912448] LR is at __wake_up+0x20/0x50
[   18.912522] pc : [<c032ec60>]    lr : [<c0044054>]    psr: a0000193
[   18.912522] sp : df37bb78  ip : 00000000  fp : df37bb9c
[   18.912616] r10: df37a000  r9 : 00000000  r8 : 00000000
[   18.912679] r7 : 00000003  r6 : 00000000  r5 : df82c000  r4 : 00000000
[   18.912749] r3 : df37a000  r2 : 00000000  r1 : 40000103  r0 : a0000113
[   18.912818] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[   18.912893] Control: 30c5387d  Table: 9f97ec80  DAC: fffffffd
[   18.912956] Process dma2chan0-copy3 (pid: 651, stack limit = 0xdf37a240)
[   18.913020] Stack: (0xdf37bb78 to 0xdf37c000)
[   18.913093] bb60:                                                       d28de712 00000001
[   18.913207] bb80: 0000006e df836878 df82c000 00000000 df82c040 df82c000 df37bbc4 c01e92d8
[   18.913322] bba0: 00000001 c0ce3a40 00000000 80000193 dfac88b8 00002e7b df82c04c 20000113
[   18.913438] bbc0: c0ce2e9c df836878 df836878 00000080 00000000 70b93fb1 8f46af61 df82c000
[   18.913551] bbe0: df82c004 00000000 c0556508 c0585d00 00000000 df37a000 00000006 c0025304
[   18.913665] bc00: 00000001 00000018 c055c09c df37a000 c055c080 40000102 00000018 c00256e0
[   18.913782] bc20: df80c950 df0850c0 e0802000 00000000 ffff90d1 00200040 df37bcec df37a000
[   18.913895] bc40: 00000060 00000000 e0802000 dfa00cc0 00000000 df0d5c00 df37bcec c0025ae8
[   18.914013] bc60: c0556e48 c000eb38 e080200c c0562820 df37bc90 c0008560 c00444b0 c032efe4
[   18.914130] bc80: 60000113 ffffffff df37bcc4 c000de80 c0ce3a40 dfac8880 df37a000 0000221b
[   18.914244] bca0: 00000000 c0ce3a40 dfacc840 00000002 dfa00cc0 00000000 df0d5c00 df37bcec
[   18.914362] bcc0: c0557a40 df37bcd8 c00444b0 c032efe4 60000113 ffffffff c0ce3a40 df37a000
[   18.914478] bce0: c0557a40 dfac8880 df37bd8c c032db74 00000001 c002bd68 c0586a54 c0586c54
[   18.914593] bd00: df37bd00 df37bd00 6475a018 00000004 00000004 c032e458 c0557a40 c0557a40
[   18.914706] bd20: 00000000 00000008 c055c08c c0025754 c05731c0 df81c840 c0ce6680 00000000
[   18.914821] bd40: ffff90cd 00200040 c01d4a84 df37a000 0000001b 00000000 e0802000 00007317
[   18.914936] bd60: c0556e48 0000001b 00000000 df37a000 80000113 ffffffff df37bdd4 c000dea0
[   18.915052] bd80: df37a000 0001beae df37bd9c c032e458 bf001fe0 bf001e70 00000000 c000deb8
[   18.915164] bda0: df15a200 dfb4ca40 0001beae 00020000 0001c8d5 00000000 0000000b 0000000c
[   18.915279] bdc0: 00007317 deea0000 0001beae 00000000 0001c8d4 df37bde8 bf001fe0 bf001e70
[   18.915393] bde0: 80000113 ffffffff 00020000 df15a200 00000000 00014b97 0000517d 00007317
[   18.915505] be00: dfb4ca40 0001beae 00000000 bf001fe0 0001beae 00000000 00000000 00000001
[   18.915618] be20: 00000080 00020000 0001beae bf002dfc dfb4c980 00000001 bf00262c 00000000
[   18.915731] be40: 00000000 00000001 00000080 ffffffff 000000c0 0000517d df37bf64 bf001cdc
[   18.915843] be60: 00014b97 00007317 dfb4ca40 00000001 0001beae 00000000 00000000 bf000e78
[   18.915954] be80: 9eea0000 00000000 df374000 00000002 9ee8517d 00000000 00000000 00000000
[   18.916066] bea0: df37401c 00000008 df37bf20 00000010 dfac8ab8 00000010 00000000 00000008
[   18.916181] bec0: df37be80 df82e014 df37be98 0000517d df37be80 df37be90 00000001 dfb4c980
[   18.916294] bee0: 00014b97 00000001 00000001 c0564504 c0591d00 00000000 00007317 df97e340
[   18.916408] bf00: 0000517d bf002dfc dfa0ac40 00000003 df37bf44 75b7c14f 00000001 df37bf20
[   18.916521] bf20: 00040004 df37bf24 df37bf24 00000007 00000007 00000000 df37bf38 df37bf38
[   18.916634] bf40: df37bf64 df161e98 00000000 df97e340 bf000b0c 00000000 00000000 00000000
[   18.916746] bf60: 00000000 c003c1a4 dfdfdfcf 00000000 dfdfdfcf df97e340 00000000 00000000
[   18.916861] bf80: df37bf80 df37bf80 00000000 00000000 df37bf90 df37bf90 df37bfac df161e98
[   18.916971] bfa0: c003c100 00000000 00000000 c000e318 00000000 00000000 00000000 00000000
[   18.917078] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   18.917189] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 dfdfdfcf cfdfdfdf
[   18.917318] [<c032ec60>] (_raw_spin_lock_irqsave+0x24/0x60) from [<c0044054>] (__wake_up+0x20/0x50)
[   18.917453] [<c0044054>] (__wake_up+0x20/0x50) from [<c01e92d8>] (pl330_tasklet+0x4c8/0x580)
[   18.917593] [<c01e92d8>] (pl330_tasklet+0x4c8/0x580) from [<c0025304>] (tasklet_action+0x74/0x100)
[   18.917734] [<c0025304>] (tasklet_action+0x74/0x100) from [<c00256e0>] (__do_softirq+0xe0/0x1b8)
[   18.917858] [<c00256e0>] (__do_softirq+0xe0/0x1b8) from [<c0025ae8>] (irq_exit+0x90/0xc8)
[   18.917972] [<c0025ae8>] (irq_exit+0x90/0xc8) from [<c000eb38>] (handle_IRQ+0x3c/0x94)
[   18.918089] [<c000eb38>] (handle_IRQ+0x3c/0x94) from [<c0008560>] (gic_handle_irq+0x28/0x5c)
[   18.918204] [<c0008560>] (gic_handle_irq+0x28/0x5c) from [<c000de80>] (__irq_svc+0x40/0x70)
[   18.918273] Exception stack(0xdf37bc90 to 0xdf37bcd8)
[   18.918357] bc80:                                     c0ce3a40 dfac8880 df37a000 0000221b
[   18.918470] bca0: 00000000 c0ce3a40 dfacc840 00000002 dfa00cc0 00000000 df0d5c00 df37bcec
[   18.918572] bcc0: c0557a40 df37bcd8 c00444b0 c032efe4 60000113 ffffffff
[   18.918697] [<c000de80>] (__irq_svc+0x40/0x70) from [<c032efe4>] (_raw_spin_unlock_irq+0x1c/0x44)
[   18.918831] [<c032efe4>] (_raw_spin_unlock_irq+0x1c/0x44) from [<c00444b0>] (finish_task_switch+0x54/0xdc)
[   18.918965] [<c00444b0>] (finish_task_switch+0x54/0xdc) from [<c032db74>] (__schedule+0x208/0x66c)
[   18.919097] [<c032db74>] (__schedule+0x208/0x66c) from [<c032e458>] (preempt_schedule_irq+0x40/0x64)
[   18.919116] dma2chan0-copy7: #1: No errors with src_off=0x5000 dst_off=0x5028 len=0x8d77 (0)
[   18.919292] [<c032e458>] (preempt_schedule_irq+0x40/0x64) from [<c000deb8>] (svc_preempt+0x8/0x18)
[   18.919431] [<c000deb8>] (svc_preempt+0x8/0x18) from [<bf001e70>] (dmatest_verify.isra.9+0x14/0xb4 [dmatest])
[   18.919499] unwind: Index not found bf001e70
[   18.919582] Code: e3c3303f e5931004 e2811001 e5831004 (e1923f9f)
[   18.919644] ---[ end trace f24842049530d274 ]---
[   18.919699] Kernel panic - not syncing: Fatal exception in interrupt
[   18.919754] CPU4: stopping
[   18.919822] CPU: 4 PID: 655 Comm: dma2chan0-copy7 Tainted: G      D      3.10.0-rc1+ #15
[   18.919949] [<c0013b50>] (unwind_backtrace+0x0/0xf8) from [<c0011434>] (show_stack+0x10/0x14)
[   18.920073] [<c0011434>] (show_stack+0x10/0x14) from [<c0012918>] (handle_IPI+0xf8/0x11c)
[   18.920183] [<c0012918>] (handle_IPI+0xf8/0x11c) from [<c000858c>] (gic_handle_irq+0x54/0x5c)
[   18.920299] [<c000858c>] (gic_handle_irq+0x54/0x5c) from [<c000de80>] (__irq_svc+0x40/0x70)
[   18.920369] Exception stack(0xdef23e18 to 0xdef23e60)
[   18.920442] 3e00:                                                       dfb4ce40 000106d3
[   18.920555] 3e20: defa0000 000015d2 00020000 00012292 00008a83 00000080 ffffffff 000000c0
[   18.920671] 3e40: 00008a83 def23f64 ffffff8e def23e60 bf000fb4 bf000fe8 80000113 ffffffff
[   18.920808] [<c000de80>] (__irq_svc+0x40/0x70) from [<bf000fe8>] (dmatest_func+0x4dc/0x12ec [dmatest])
[   18.920944] [<bf000fe8>] (dmatest_func+0x4dc/0x12ec [dmatest]) from [<c003c1a4>] (kthread+0xa4/0xb0)
[   18.921066] [<c003c1a4>] (kthread+0xa4/0xb0) from [<c000e318>] (ret_from_fork+0x14/0x3c)

