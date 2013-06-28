Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab3F1S5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:57:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3F1S5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 041/105] clk: remove notifier from list before freeing it
Date: Fri, 28 Jun 2013 11:51:03 -0700
Message-Id: <1372445527-24414-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit 72b5322f11ff0abf6a52b3007486656578d2c982 upstream.

The @cn is stay in @clk_notifier_list after it is freed, it cause
memory corruption.

Example, if @clk is registered(first), unregistered(first),
registered(second), unregistered(second).

The freed @cn will be used when @clk is registered(second),
and the bug will be happened when @clk is unregistered(second):

[  517.040000] clk_notif_dbg clk_notif_dbg.1: clk_notifier_unregister()
[  517.040000] Unable to handle kernel paging request at virtual address 00df3008
[  517.050000] pgd = ed858000
[  517.050000] [00df3008] *pgd=00000000
[  517.060000] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[  517.060000] Modules linked in: clk_notif_dbg(O-) [last unloaded: clk_notif_dbg]
[  517.060000] CPU: 1 PID: 499 Comm: modprobe Tainted: G           O 3.10.0-rc3-00119-ga93cb29-dirty #85
[  517.060000] task: ee1e0180 ti: ee3e6000 task.ti: ee3e6000
[  517.060000] PC is at srcu_readers_seq_idx+0x48/0x84
[  517.060000] LR is at srcu_readers_seq_idx+0x60/0x84
[  517.060000] pc : [<c0052720>]    lr : [<c0052738>]    psr: 80070013
[  517.060000] sp : ee3e7d48  ip : 00000000  fp : ee3e7d6c
[  517.060000] r10: 00000000  r9 : ee3e6000  r8 : 00000000
[  517.060000] r7 : ed84fe4c  r6 : c068ec90  r5 : c068e430  r4 : 00000000
[  517.060000] r3 : 00df3000  r2 : 00000000  r1 : 00000002  r0 : 00000000
[  517.060000] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  517.060000] Control: 18c5387d  Table: 2d85804a  DAC: 00000015
[  517.060000] Process modprobe (pid: 499, stack limit = 0xee3e6238)
[  517.060000] Stack: (0xee3e7d48 to 0xee3e8000)
....
[  517.060000] [<c0052720>] (srcu_readers_seq_idx+0x48/0x84) from [<c0052790>] (try_check_zero+0x34/0xfc)
[  517.060000] [<c0052790>] (try_check_zero+0x34/0xfc) from [<c00528b0>] (srcu_advance_batches+0x58/0x114)
[  517.060000] [<c00528b0>] (srcu_advance_batches+0x58/0x114) from [<c0052c30>] (__synchronize_srcu+0x114/0x1ac)
[  517.060000] [<c0052c30>] (__synchronize_srcu+0x114/0x1ac) from [<c0052d14>] (synchronize_srcu+0x2c/0x34)
[  517.060000] [<c0052d14>] (synchronize_srcu+0x2c/0x34) from [<c0053a08>] (srcu_notifier_chain_unregister+0x68/0x74)
[  517.060000] [<c0053a08>] (srcu_notifier_chain_unregister+0x68/0x74) from [<c0375a78>] (clk_notifier_unregister+0x7c/0xc0)
[  517.060000] [<c0375a78>] (clk_notifier_unregister+0x7c/0xc0) from [<bf008034>] (clk_notif_dbg_remove+0x34/0x9c [clk_notif_dbg])
[  517.060000] [<bf008034>] (clk_notif_dbg_remove+0x34/0x9c [clk_notif_dbg]) from [<c02bb974>] (platform_drv_remove+0x24/0x28)
[  517.060000] [<c02bb974>] (platform_drv_remove+0x24/0x28) from [<c02b9bf8>] (__device_release_driver+0x8c/0xd4)
[  517.060000] [<c02b9bf8>] (__device_release_driver+0x8c/0xd4) from [<c02ba680>] (driver_detach+0x9c/0xc4)
[  517.060000] [<c02ba680>] (driver_detach+0x9c/0xc4) from [<c02b99c4>] (bus_remove_driver+0xcc/0xfc)
[  517.060000] [<c02b99c4>] (bus_remove_driver+0xcc/0xfc) from [<c02bace4>] (driver_unregister+0x54/0x78)
[  517.060000] [<c02bace4>] (driver_unregister+0x54/0x78) from [<c02bbb44>] (platform_driver_unregister+0x1c/0x20)
[  517.060000] [<c02bbb44>] (platform_driver_unregister+0x1c/0x20) from [<bf0081f8>] (clk_notif_dbg_driver_exit+0x14/0x1c [clk_notif_dbg])
[  517.060000] [<bf0081f8>] (clk_notif_dbg_driver_exit+0x14/0x1c [clk_notif_dbg]) from [<c00835e4>] (SyS_delete_module+0x200/0x28c)
[  517.060000] [<c00835e4>] (SyS_delete_module+0x200/0x28c) from [<c000edc0>] (ret_fast_syscall+0x0/0x48)
[  517.060000] Code: e5973004 e7911102 e0833001 e2881002 (e7933101)

Reported-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
[mturquette@linaro.org: shortened $SUBJECT]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/clk/clk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 251e45d..e3b8b2c 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1633,6 +1633,7 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 		/* XXX the notifier code should handle this better */
 		if (!cn->notifier_head.head) {
 			srcu_cleanup_notifier_head(&cn->notifier_head);
+			list_del(&cn->node);
 			kfree(cn);
 		}
 
-- 
1.8.1.2

