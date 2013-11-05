Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3KELtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:49:04 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:57423 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3KELtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:49:01 -0500
MIME-Version: 1.0
Date: Tue, 5 Nov 2013 17:19:00 +0530
Message-ID: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com>
Subject: Boot failure on Arndale with next-20131105
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We are having a boot-time kernel panic on Samsung's Exynos5250-based
Arndale board with next-20131105. Bisect points to following commit.

<<<
commit febca1baea1cfe2d7a0271385d89b03d5fb34f94
Author: Chris Mason <chris.mason@fusionio.com>
Date:   Thu Oct 31 13:32:42 2013 -0600

    block: setup bi_vcnt on clones

    commit 9fc6286f347d changed the cloning code to make clones cheaper for
    the case where we don't need to clone the iovec array.  But,
    the new clone needs the bi_vnct from the original.

    Signed-off-by: Chris Mason <chris.mason@fusionio.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>

Reverting above commit, Arndale is able to boot again.

Excerpts from the boot log (just in case, it helps in debugging).

[    1.972062] Unable to handle kernel paging request at virtual
address 025e63a0
[    1.981164] pgd = c0004000
[    1.982375] [025e63a0] *pgd=00000000
[    1.985875] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    1.991086] Modules linked in:
[    1.994076] CPU: 0 PID: 1178 Comm: mmcqd/0 Not tainted
3.12.0-rc5-00051-gfebca1b #21
[    2.001683] task: ef3530c0 ti: ee82e000 task.ti: ee82e000
[    2.006981] PC is at dma_cache_maint_page+0x84/0x174
[    2.011842] LR is at 0x6

[    2.043532] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[    2.050708] Control: 10c5387d  Table: 4000406a  DAC: 00000015
[    2.056342] Process mmcqd/0 (pid: 1178, stack limit = 0xee82e240)
[    2.062321] Stack: (0xee82fd58 to 0xee830000)

[ ... ]

[    2.275352] [<c0015768>] (dma_cache_maint_page+0x84/0x174) from
[<c0015880>] (__dma_page_cpu_to_dev+0x28/0xa0)
[    2.285170] [<c0015880>] (__dma_page_cpu_to_dev+0x28/0xa0) from
[<c00159a4>] (arm_dma_map_page+0x6c/0x70)
[    2.294565] [<c00159a4>] (arm_dma_map_page+0x6c/0x70) from
[<c0015d28>] (arm_dma_map_sg+0x74/0xec)
[    2.303366] [<c0015d28>] (arm_dma_map_sg+0x74/0xec) from
[<c02bf534>] (dw_mci_pre_dma_transfer.isra.16+0x124/0x15c)
[    2.313614] [<c02bf534>]
(dw_mci_pre_dma_transfer.isra.16+0x124/0x15c) from [<c02bf8d4>]
(dw_mci_pre_req+0x44/0x50)
[    2.323863] [<c02bf8d4>] (dw_mci_pre_req+0x44/0x50) from
[<c02a8970>] (mmc_start_req+0x3c/0x39c)
[    2.332486] [<c02a8970>] (mmc_start_req+0x3c/0x39c) from
[<c02b606c>] (mmc_blk_issue_rw_rq+0xbc/0xa9c)
[    2.341625] [<c02b606c>] (mmc_blk_issue_rw_rq+0xbc/0xa9c) from
[<c02b6c14>] (mmc_blk_issue_rq+0x1c8/0x498)
[    2.351106] [<c02b6c14>] (mmc_blk_issue_rq+0x1c8/0x498) from
[<c02b75d4>] (mmc_queue_thread+0xa4/0x144)
[    2.360331] [<c02b75d4>] (mmc_queue_thread+0xa4/0x144) from
[<c0038614>] (kthread+0xb4/0xb8)
[    2.368616] [<c0038614>] (kthread+0xb4/0xb8) from [<c000e2f8>]
(ret_from_fork+0x14/0x3c)
[    2.376556] Code: 17e81051 10822181 e592c000 e3ccc003 (e79c2007)
[    2.382570] ---[ end trace df06b64b1b7fa443 ]---

[ ... ]

Begin: Mounting root file system ... Begin: Running /scripts/local-top ... done.
Gave up waiting for root device.  Common problems:
 - Boot args (cat /proc/cmdline)
   - Check rootdelay= (did the system wait long enough?)
   - Check root= (did the system wait for the right device?)
 - Missing modules (cat /proc/modules; ls /dev)
ALERT!  /dev/mmcblk1p3 does not exist.  Dropping to a shell!
FATAL: Could not load
/lib/modules/3.12.0-rc5-00051-gfebca1b/modules.dep: No such file or
directory
FATAL: Could not load
/lib/modules/3.12.0-rc5-00051-gfebca1b/modules.dep: No such file or
directory


-- 
Tushar Behera
