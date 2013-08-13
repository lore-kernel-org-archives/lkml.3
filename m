Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab3HMQML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:12:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584Ab3HMP60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:26 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=LjfRo_k8RsgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BomuZKVk9IkA:10 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=Am4ss40yAAAA:8 a=KKAkSRfTAAAA:8 a=1gKl0x3fvTyPpExJkPYA:9 a=LI9Vle30uBYA:10 a=e_5KU5bljdMA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155824.162046727@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:56:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: <stable@kernel.org>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [03/88] clk: remove notifier from list before freeing it
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0003-clk-remove-notifier-from-list-before-freeing-it.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

[ Upstream commit 72b5322f11ff0abf6a52b3007486656578d2c982 ]

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

Cc: stable@kernel.org
Reported-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[mturquette@linaro.org: shortened $SUBJECT]
---
 drivers/clk/clk.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index efdfd00..9c3104a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1542,6 +1542,7 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 		/* XXX the notifier code should handle this better */
 		if (!cn->notifier_head.head) {
 			srcu_cleanup_notifier_head(&cn->notifier_head);
+			list_del(&cn->node);
 			kfree(cn);
 		}
 
-- 
1.7.10.4


