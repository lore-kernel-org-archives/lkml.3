Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaKFXJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:09:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58758 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaKFWlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 036/162] sparc64: Fix reversed start/end in flush_tlb_kernel_range()
Date: Thu,  6 Nov 2014 14:35:00 -0800
Message-Id: <1415313426-9622-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 473ad7f4fb005d1bb727e4ef27d370d28703a062 ]

When we have to split up a flush request into multiple pieces
(in order to avoid the firmware range) we don't specify the
arguments in the right order for the second piece.

Fix the order, or else we get hangs as the code tries to
flush "a lot" of entries and we get lockups like this:

[ 4422.981276] NMI watchdog: BUG: soft lockup - CPU#12 stuck for 23s! [expect:117032]
[ 4422.996130] Modules linked in: ipv6 loop usb_storage igb ptp sg sr_mod ehci_pci ehci_hcd pps_core n2_rng rng_core
[ 4423.016617] CPU: 12 PID: 117032 Comm: expect Not tainted 3.17.0-rc4+ #1608
[ 4423.030331] task: fff8003cc730e220 ti: fff8003d99d54000 task.ti: fff8003d99d54000
[ 4423.045282] TSTATE: 0000000011001602 TPC: 00000000004521e8 TNPC: 00000000004521ec Y: 00000000    Not tainted
[ 4423.064905] TPC: <__flush_tlb_kernel_range+0x28/0x40>
[ 4423.074964] g0: 000000000052fd10 g1: 00000001295a8000 g2: ffffff7176ffc000 g3: 0000000000002000
[ 4423.092324] g4: fff8003cc730e220 g5: fff8003dfedcc000 g6: fff8003d99d54000 g7: 0000000000000006
[ 4423.109687] o0: 0000000000000000 o1: 0000000000000000 o2: 0000000000000003 o3: 00000000f0000000
[ 4423.127058] o4: 0000000000000080 o5: 00000001295a8000 sp: fff8003d99d56d01 ret_pc: 000000000052ff54
[ 4423.145121] RPC: <__purge_vmap_area_lazy+0x314/0x3a0>
[ 4423.155185] l0: 0000000000000000 l1: 0000000000000000 l2: 0000000000a38040 l3: 0000000000000000
[ 4423.172559] l4: fff8003dae8965e0 l5: ffffffffffffffff l6: 0000000000000000 l7: 00000000f7e2b138
[ 4423.189913] i0: fff8003d99d576a0 i1: fff8003d99d576a8 i2: fff8003d99d575e8 i3: 0000000000000000
[ 4423.207284] i4: 0000000000008008 i5: fff8003d99d575c8 i6: fff8003d99d56df1 i7: 0000000000530c24
[ 4423.224640] I7: <free_vmap_area_noflush+0x64/0x80>
[ 4423.234193] Call Trace:
[ 4423.239051]  [0000000000530c24] free_vmap_area_noflush+0x64/0x80
[ 4423.251029]  [0000000000531a7c] remove_vm_area+0x5c/0x80
[ 4423.261628]  [0000000000531b80] __vunmap+0x20/0x120
[ 4423.271352]  [000000000071cf18] n_tty_close+0x18/0x40
[ 4423.281423]  [00000000007222b0] tty_ldisc_close+0x30/0x60
[ 4423.292183]  [00000000007225a4] tty_ldisc_reinit+0x24/0xa0
[ 4423.303120]  [0000000000722ab4] tty_ldisc_hangup+0xd4/0x1e0
[ 4423.314232]  [0000000000719aa0] __tty_hangup+0x280/0x3c0
[ 4423.324835]  [0000000000724cb4] pty_close+0x134/0x1a0
[ 4423.334905]  [000000000071aa24] tty_release+0x104/0x500
[ 4423.345316]  [00000000005511d0] __fput+0x90/0x1e0
[ 4423.354701]  [000000000047fa54] task_work_run+0x94/0xe0
[ 4423.365126]  [0000000000404b44] __handle_signal+0xc/0x2c

Fixes: 4ca9a23765da ("sparc64: Guard against flushing openfirmware mappings.")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/mm/init_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index a1d48b9..1a9cc81 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2719,8 +2719,8 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 			do_flush_tlb_kernel_range(start, LOW_OBP_ADDRESS);
 		}
 		if (end > HI_OBP_ADDRESS) {
-			flush_tsb_kernel_range(end, HI_OBP_ADDRESS);
-			do_flush_tlb_kernel_range(end, HI_OBP_ADDRESS);
+			flush_tsb_kernel_range(HI_OBP_ADDRESS, end);
+			do_flush_tlb_kernel_range(HI_OBP_ADDRESS, end);
 		}
 	} else {
 		flush_tsb_kernel_range(start, end);
-- 
1.9.1

