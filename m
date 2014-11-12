Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbaKLDBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:01:53 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:8589 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340AbaKLDBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:01:51 -0500
From: <chenjie6@huawei.com>
To: <linux-mtd@lists.infradead.org>
CC: <dwmw2@infradead.org>, <lizefan@huawei.com>, <kexing@huawei.com>,
        <gaozhihui@huawei.com>, <zengweilin@huawei.com>,
        <linux-kernel@vger.kernel.org>, chenjie <chenjie6@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] jffs2: fix soft lockup when read flash error
Date: Wed, 12 Nov 2014 19:01:48 +0800
Message-ID: <1415790108-17340-1-git-send-email-chenjie6@huawei.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.54.28]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenjie <chenjie6@huawei.com>

we find soft lockup when read flash error
------------------CPU#1-----------------------------------
BUG: soft lockup - CPU#1 stuck for 60009ms! [link.test:17707]
INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=247997 jiffies, g=127234, c=127233, q=373616)
Task dump for CPU 1:
link.test       R running      0 17707  17611 0x00000003
locked:
e844ea78   &inode->i_mutex  1  [<c010a518>] do_unlinkat+0x74/0x170
e873f9f8   &inode->i_mutex  1  [<c010a3e8>] vfs_unlink+0x38/0xf4
e8bc4444   &c->alloc_sem    1  [<bf051120>] jffs2_reserve_space+0x2c/0x3b4 [jffs2]
e8bc4568   &c->erase_free_sem 1  [<bf058d6c>] jffs2_erase_pending_blocks+0x20/0x860 [jffs2]
c0479d30   console_sem      1  [<c00245cc>] console_trylock+0xc/0x50
[<c02dee00>] (__schedule+0x478/0x644) from [<00000000>] (  (null))
Modules linked in: rtos_kbox_panic(O) flash(O) eth(O) mdio(O) gpio(O) watchdog(O) nfsv4 nfsv3 nfs lockd nfs_acl sunrpc xt_tcpudp ipt_REJECT iptable_filter ip_tables x_tables jffs2 cfi_cmdset_0002 cfi_probe cfi_util gen_probe cmdlinepart chipreg mtdblock mtd_blkdevs mtd uio [last unloaded: kernel_mem_manage]

CPU: 1 PID: 17707 Comm: link.test Tainted: G           O 3.10.53 #1
task: e80b6e80 ti: c8e9e000 task.ti: c8e9e000
PC is at jffs2_erase_pending_blocks+0x808/0x860 [jffs2]
LR is at jffs2_erase_pending_blocks+0x2c/0x860 [jffs2]
pc : [<bf059554>]    lr : [<bf058d78>]    psr: 60000113
sp : c8e9fdc8  ip : e80b6eb0  fp : e8bc44f8
r10: 00000000  r9 : c8e9fecc  r8 : 00000034
r7 : e8bc4520  r6 : e8bc4568  r5 : e8bc44f8  r4 : e8bc4400
r3 : 00000120  r2 : 00006a20  r1 : 00000000  r0 : e8bc4520
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 18c53c7d  Table: 9b79004a  DAC: 00000015
CPU: 1 PID: 17707 Comm: link.test Tainted: G           O 3.10.53 #1
[<c0017198>] (unwind_backtrace+0x0/0x120) from [<c0012a14>] (show_stack+0x10/0x14)
[<c0012a14>] (show_stack+0x10/0x14) from [<c008bbd4>] (watchdog_timer_fn+0x16c/0x208)
[<c008bbd4>] (watchdog_timer_fn+0x16c/0x208) from [<c0047bf4>] (__run_hrtimer+0xd4/0x1c4)
[<c0047bf4>] (__run_hrtimer+0xd4/0x1c4) from [<c00484dc>] (hrtimer_interrupt+0x128/0x2b0)
[<c00484dc>] (hrtimer_interrupt+0x128/0x2b0) from [<c0016584>] (twd_handler+0x38/0x44)
[<c0016584>] (twd_handler+0x38/0x44) from [<c008f5fc>] (handle_percpu_devid_irq+0x9c/0x124)
[<c008f5fc>] (handle_percpu_devid_irq+0x9c/0x124) from [<c008bec8>] (generic_handle_irq+0x20/0x30)
[<c008bec8>] (generic_handle_irq+0x20/0x30) from [<c000fa44>] (handle_IRQ+0xa0/0xf4)
[<c000fa44>] (handle_IRQ+0xa0/0xf4) from [<c000855c>] (gic_handle_irq+0x3c/0x60)
[<c000855c>] (gic_handle_irq+0x3c/0x60) from [<c02e0424>] (__irq_svc+0x44/0x58)
Exception stack(0xc8e9fd80 to 0xc8e9fdc8)
fd80: e8bc4520 00000000 00006a20 00000120 e8bc4400 e8bc44f8 e8bc4568 e8bc4520
fda0: 00000034 c8e9fecc 00000000 e8bc44f8 e80b6eb0 c8e9fdc8 bf058d78 bf059554
fdc0: 60000113 ffffffff
[<c02e0424>] (__irq_svc+0x44/0x58) from [<bf059554>] (jffs2_erase_pending_blocks+0x808/0x860 [jffs2])
[<bf059554>] (jffs2_erase_pending_blocks+0x808/0x860 [jffs2]) from [<bf050f04>] (jffs2_do_reserve_space+0x31c/0x47c [jffs2])
[<bf050f04>] (jffs2_do_reserve_space+0x31c/0x47c [jffs2]) from [<bf051424>] (jffs2_reserve_space+0x330/0x3b4 [jffs2])
[<bf051424>] (jffs2_reserve_space+0x330/0x3b4 [jffs2]) from [<bf054460>] (jffs2_do_unlink+0x48/0x228 [jffs2])
[<bf054460>] (jffs2_do_unlink+0x48/0x228 [jffs2]) from [<bf04e26c>] (jffs2_unlink+0x3c/0x80 [jffs2])
[<bf04e26c>] (jffs2_unlink+0x3c/0x80 [jffs2]) from [<c010a40c>] (vfs_unlink+0x5c/0xf4)
[<c010a40c>] (vfs_unlink+0x5c/0xf4) from [<c010a568>] (do_unlinkat+0xc4/0x170)
[<c010a568>] (do_unlinkat+0xc4/0x170) from [<c000f0c0>] (ret_fast_syscall+0x0/0x58)

jffs2_find_nextblock
        --->jffs2_erase_pending_blocks
        --->jffs2_mark_erased_block
                but jffs2_block_check_erase failed or jffs2_write_nand_cleanmarker failed
The jffs2_find_nextblock return -EAGAIN ,so soft lockup had occurred

Cc: <stable@vger.kernel.org> 
Signed-off-by: chenjie <chenjie6@huawei.com>

---
 fs/jffs2/nodemgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index b6bd4af..f689bb1 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -322,6 +322,7 @@ static int jffs2_find_nextblock(struct jffs2_sb_info *c)
 
 		spin_unlock(&c->erase_completion_lock);
 		/* Don't wait for it; just erase one right now */
+		cond_resched();
 		jffs2_erase_pending_blocks(c, 1);
 		spin_lock(&c->erase_completion_lock);
 
-- 
1.8.0

