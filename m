Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab3FCQuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:50:05 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:41976
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758786Ab3FCQuC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:50:02 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(z5105hzbb2dI98dI9371Ic89bh1432I4015I1447I853kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh906i192cn1155h)
Date: Mon, 3 Jun 2013 09:49:53 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>, <paulmck@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <git@xilinx.com>
Subject: Re: [PATCH] clk: remove the clk_notifier from clk_notifier_list
 before free it (was: Re: [BUG] zynq | CCF | SRCU)
References: <42b8bfd5-3012-4c49-b9ef-7a9beb5956f1@VA3EHSMHS041.ehs.local>
 <51AC5F1B.4020409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <51AC5F1B.4020409@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <b6422bc1-70b4-4942-a594-3f0e7b0fa04a@CO1EHSMHS001.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

On Mon, Jun 03, 2013 at 05:17:15PM +0800, Lai Jiangshan wrote:
> On 06/01/2013 03:12 AM, Sören Brinkmann wrote:
> > Hi,
> > 
> > we recently encountered some kernel panics when we compiled one of our
> > drivers as module and tested inserting/removing the module.
> > Trying to debug this issue, I could reproduce it on the mainline kernel
> > with a dummy module.
> > 
> > What happens is, that when on driver remove clk_notifier_unregister() is
> > called and no other notifier for that clock is registered, the kernel
> > panics.
> > I'm not sure what is going wrong here. If there is a bug (and if where)
> > or I'm just using the infrastructure the wrong way,... So, any hint is
> > appreciated.
> > 
> > I attach the output from the crashing system. The stacktrace indicates a
> > crash in 'srcu_readers_seq_idx()'.
> > I also attach the module I used to trigger the issue and a patch on top
> > of mainline commit a93cb29acaa8f75618c3f202d1cf43c231984644 which has
> > the DT modifications I need to make the module find its clock and boot
> > with my initramfs.
> > 
> > 
> > 	Thanks,
> > 	Sören
> > 
> 
> 
> 
> Hi, Sören Brinkmann
> 
> I guess:
> 
> modprobe clk_notif_dbg
> modprobe clk_notif_dbg -r  # memory corrupt here
> modprobe clk_notif_dbg     # access corrupted memroy, but no visiable bug
> modprobe clk_notif_dbg -r  # access corrupted memroy, BUG
> 
> 
> How the first "modprobe clk_notif_dbg -r" corrupt memroy:
> 
> =========
> 
> int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
> {
> 	struct clk_notifier *cn = NULL;
> 	int ret = -EINVAL;
> 
> 	if (!clk || !nb)
> 		return -EINVAL;
> 
> 	clk_prepare_lock();
> 
> 	list_for_each_entry(cn, &clk_notifier_list, node)
> 		if (cn->clk == clk)
> 			break;
> 
> 	if (cn->clk == clk) {
> 		ret = srcu_notifier_chain_unregister(&cn->notifier_head, nb);
> 
> 		clk->notifier_count--;
> 
> 		/* XXX the notifier code should handle this better */
> 		if (!cn->notifier_head.head) {
> 			srcu_cleanup_notifier_head(&cn->notifier_head);
> 
> ===========> the code forgot to remove @cn from the clk_notifier_list
> ===========> the second "modprobe clk_notif_dbg" will the same @clk and use the same corrupt @cn
> 
> 			kfree(cn);
> 		}
> 
> 	} else {
> 		ret = -ENOENT;
> 	}
> 
> 	clk_prepare_unlock();
> 
> 	return ret;
> }
> 
> ===========
> 
> Could you retry with the following patch?
Thanks for the patch. This fixes it. I can add/remove my module, and it
didn't crash since.
I had some trouble applying it though, due to some encoding hiccups. I
think the 'ö' in my name might be the culprit. I never know where things
go wrong, whether it's format-patch, or something in the email
transport, the sender or receiver side... But well, looks like full
UTF-8 support is missing somewhere.

> 
> Thanks,
> Lai
> 
> From 5e26b626724139070148df9f6bd0607bc7bc3812 Mon Sep 17 00:00:00 2001
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date: Mon, 3 Jun 2013 16:59:50 +0800
> Subject: [PATCH] clk: remove the clk_notifier from clk_notifier_list before
>  free it
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> The @cn is stay in @clk_notifier_list after it is freed, it cause
> memory corruption.
> 
> Example, if @clk is registered(first), unregistered(first),
> registered(second), unregistered(second).
> 
> The freed @cn will be used when @clk is registered(second),
> and the bug will be happened when @clk is unregistered(second):
> 
> [  517.040000] clk_notif_dbg clk_notif_dbg.1: clk_notifier_unregister()
> [  517.040000] Unable to handle kernel paging request at virtual address 00df3008
> [  517.050000] pgd = ed858000
> [  517.050000] [00df3008] *pgd=00000000
> [  517.060000] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> [  517.060000] Modules linked in: clk_notif_dbg(O-) [last unloaded: clk_notif_dbg]
> [  517.060000] CPU: 1 PID: 499 Comm: modprobe Tainted: G           O 3.10.0-rc3-00119-ga93cb29-dirty #85
> [  517.060000] task: ee1e0180 ti: ee3e6000 task.ti: ee3e6000
> [  517.060000] PC is at srcu_readers_seq_idx+0x48/0x84
> [  517.060000] LR is at srcu_readers_seq_idx+0x60/0x84
> [  517.060000] pc : [<c0052720>]    lr : [<c0052738>]    psr: 80070013
> [  517.060000] sp : ee3e7d48  ip : 00000000  fp : ee3e7d6c
> [  517.060000] r10: 00000000  r9 : ee3e6000  r8 : 00000000
> [  517.060000] r7 : ed84fe4c  r6 : c068ec90  r5 : c068e430  r4 : 00000000
> [  517.060000] r3 : 00df3000  r2 : 00000000  r1 : 00000002  r0 : 00000000
> [  517.060000] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [  517.060000] Control: 18c5387d  Table: 2d85804a  DAC: 00000015
> [  517.060000] Process modprobe (pid: 499, stack limit = 0xee3e6238)
> [  517.060000] Stack: (0xee3e7d48 to 0xee3e8000)
> ....
> [  517.060000] [<c0052720>] (srcu_readers_seq_idx+0x48/0x84) from [<c0052790>] (try_check_zero+0x34/0xfc)
> [  517.060000] [<c0052790>] (try_check_zero+0x34/0xfc) from [<c00528b0>] (srcu_advance_batches+0x58/0x114)
> [  517.060000] [<c00528b0>] (srcu_advance_batches+0x58/0x114) from [<c0052c30>] (__synchronize_srcu+0x114/0x1ac)
> [  517.060000] [<c0052c30>] (__synchronize_srcu+0x114/0x1ac) from [<c0052d14>] (synchronize_srcu+0x2c/0x34)
> [  517.060000] [<c0052d14>] (synchronize_srcu+0x2c/0x34) from [<c0053a08>] (srcu_notifier_chain_unregister+0x68/0x74)
> [  517.060000] [<c0053a08>] (srcu_notifier_chain_unregister+0x68/0x74) from [<c0375a78>] (clk_notifier_unregister+0x7c/0xc0)
> [  517.060000] [<c0375a78>] (clk_notifier_unregister+0x7c/0xc0) from [<bf008034>] (clk_notif_dbg_remove+0x34/0x9c [clk_notif_dbg])
> [  517.060000] [<bf008034>] (clk_notif_dbg_remove+0x34/0x9c [clk_notif_dbg]) from [<c02bb974>] (platform_drv_remove+0x24/0x28)
> [  517.060000] [<c02bb974>] (platform_drv_remove+0x24/0x28) from [<c02b9bf8>] (__device_release_driver+0x8c/0xd4)
> [  517.060000] [<c02b9bf8>] (__device_release_driver+0x8c/0xd4) from [<c02ba680>] (driver_detach+0x9c/0xc4)
> [  517.060000] [<c02ba680>] (driver_detach+0x9c/0xc4) from [<c02b99c4>] (bus_remove_driver+0xcc/0xfc)
> [  517.060000] [<c02b99c4>] (bus_remove_driver+0xcc/0xfc) from [<c02bace4>] (driver_unregister+0x54/0x78)
> [  517.060000] [<c02bace4>] (driver_unregister+0x54/0x78) from [<c02bbb44>] (platform_driver_unregister+0x1c/0x20)
> [  517.060000] [<c02bbb44>] (platform_driver_unregister+0x1c/0x20) from [<bf0081f8>] (clk_notif_dbg_driver_exit+0x14/0x1c [clk_notif_dbg])
> [  517.060000] [<bf0081f8>] (clk_notif_dbg_driver_exit+0x14/0x1c [clk_notif_dbg]) from [<c00835e4>] (SyS_delete_module+0x200/0x28c)
> [  517.060000] [<c00835e4>] (SyS_delete_module+0x200/0x28c) from [<c000edc0>] (ret_fast_syscall+0x0/0x48)
> [  517.060000] Code: e5973004 e7911102 e0833001 e2881002 (e7933101)
> 
> CC: stable@kernel.org
> Reported-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Sören Brinkmann <soren.brinkmann@xilinx.com>

	Sören


