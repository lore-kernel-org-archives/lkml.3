Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab3FCJOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:14:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26034 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab3FCJOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:14:34 -0400
X-IronPort-AV: E=Sophos;i="4.87,791,1363104000"; 
   d="scan'208";a="7445287"
Message-ID: <51AC5F1B.4020409@cn.fujitsu.com>
Date: Mon, 03 Jun 2013 17:17:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        git@xilinx.com
Subject: [PATCH] clk: remove the clk_notifier from clk_notifier_list before
 free it (was: Re: [BUG] zynq | CCF | SRCU)
References: <42b8bfd5-3012-4c49-b9ef-7a9beb5956f1@VA3EHSMHS041.ehs.local>
In-Reply-To: <42b8bfd5-3012-4c49-b9ef-7a9beb5956f1@VA3EHSMHS041.ehs.local>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/03 17:12:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/03 17:12:51
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 03:12 AM, Sören Brinkmann wrote:
> Hi,
> 
> we recently encountered some kernel panics when we compiled one of our
> drivers as module and tested inserting/removing the module.
> Trying to debug this issue, I could reproduce it on the mainline kernel
> with a dummy module.
> 
> What happens is, that when on driver remove clk_notifier_unregister() is
> called and no other notifier for that clock is registered, the kernel
> panics.
> I'm not sure what is going wrong here. If there is a bug (and if where)
> or I'm just using the infrastructure the wrong way,... So, any hint is
> appreciated.
> 
> I attach the output from the crashing system. The stacktrace indicates a
> crash in 'srcu_readers_seq_idx()'.
> I also attach the module I used to trigger the issue and a patch on top
> of mainline commit a93cb29acaa8f75618c3f202d1cf43c231984644 which has
> the DT modifications I need to make the module find its clock and boot
> with my initramfs.
> 
> 
> 	Thanks,
> 	Sören
> 



Hi, Sören Brinkmann

I guess:

modprobe clk_notif_dbg
modprobe clk_notif_dbg -r  # memory corrupt here
modprobe clk_notif_dbg     # access corrupted memroy, but no visiable bug
modprobe clk_notif_dbg -r  # access corrupted memroy, BUG


How the first "modprobe clk_notif_dbg -r" corrupt memroy:

=========

int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
{
	struct clk_notifier *cn = NULL;
	int ret = -EINVAL;

	if (!clk || !nb)
		return -EINVAL;

	clk_prepare_lock();

	list_for_each_entry(cn, &clk_notifier_list, node)
		if (cn->clk == clk)
			break;

	if (cn->clk == clk) {
		ret = srcu_notifier_chain_unregister(&cn->notifier_head, nb);

		clk->notifier_count--;

		/* XXX the notifier code should handle this better */
		if (!cn->notifier_head.head) {
			srcu_cleanup_notifier_head(&cn->notifier_head);

===========> the code forgot to remove @cn from the clk_notifier_list
===========> the second "modprobe clk_notif_dbg" will the same @clk and use the same corrupt @cn

			kfree(cn);
		}

	} else {
		ret = -ENOENT;
	}

	clk_prepare_unlock();

	return ret;
}

===========

Could you retry with the following patch?

Thanks,
Lai

>From 5e26b626724139070148df9f6bd0607bc7bc3812 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Mon, 3 Jun 2013 16:59:50 +0800
Subject: [PATCH] clk: remove the clk_notifier from clk_notifier_list before
 free it
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

CC: stable@kernel.org
Reported-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/clk/clk.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 934cfd1..1144e8c 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1955,6 +1955,7 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 		/* XXX the notifier code should handle this better */
 		if (!cn->notifier_head.head) {
 			srcu_cleanup_notifier_head(&cn->notifier_head);
+			list_del(&cn->node);
 			kfree(cn);
 		}
 
-- 
1.7.4.4

