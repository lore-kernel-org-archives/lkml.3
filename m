Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaLCL1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:27:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbaLCL1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 014/101] sparc64: Do irq_{enter,exit}() around generic_smp_call_function*().
Date: Wed,  3 Dec 2014 12:25:36 +0100
Message-Id: <a80e35d99a6e184732ab484efd89af2b06f9e174.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit ab5c780913bca0a5763ca05dd5c2cb5cb08ccb26 ]

Otherwise rcu_irq_{enter,exit}() do not happen and we get dumps like:

====================
[  188.275021] ===============================
[  188.309351] [ INFO: suspicious RCU usage. ]
[  188.343737] 3.18.0-rc3-00068-g20f3963-dirty #54 Not tainted
[  188.394786] -------------------------------
[  188.429170] include/linux/rcupdate.h:883 rcu_read_lock() used
illegally while idle!
[  188.505235]
other info that might help us debug this:

[  188.554230]
RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 0
[  188.637587] RCU used illegally from extended quiescent state!
[  188.690684] 3 locks held by swapper/7/0:
[  188.721932]  #0:  (&x->wait#11){......}, at: [<0000000000495de8>] complete+0x8/0x60
[  188.797994]  #1:  (&p->pi_lock){-.-.-.}, at: [<000000000048510c>] try_to_wake_up+0xc/0x400
[  188.881343]  #2:  (rcu_read_lock){......}, at: [<000000000048a910>] select_task_rq_fair+0x90/0xb40
[  188.973043]stack backtrace:
[  188.993879] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 3.18.0-rc3-00068-g20f3963-dirty #54
[  189.076187] Call Trace:
[  189.089719]  [0000000000499360] lockdep_rcu_suspicious+0xe0/0x100
[  189.147035]  [000000000048a99c] select_task_rq_fair+0x11c/0xb40
[  189.202253]  [00000000004852d8] try_to_wake_up+0x1d8/0x400
[  189.252258]  [000000000048554c] default_wake_function+0xc/0x20
[  189.306435]  [0000000000495554] __wake_up_common+0x34/0x80
[  189.356448]  [00000000004955b4] __wake_up_locked+0x14/0x40
[  189.406456]  [0000000000495e08] complete+0x28/0x60
[  189.448142]  [0000000000636e28] blk_end_sync_rq+0x8/0x20
[  189.496057]  [0000000000639898] __blk_mq_end_request+0x18/0x60
[  189.550249]  [00000000006ee014] scsi_end_request+0x94/0x180
[  189.601286]  [00000000006ee334] scsi_io_completion+0x1d4/0x600
[  189.655463]  [00000000006e51c4] scsi_finish_command+0xc4/0xe0
[  189.708598]  [00000000006ed958] scsi_softirq_done+0x118/0x140
[  189.761735]  [00000000006398ec] __blk_mq_complete_request_remote+0xc/0x20
[  189.827383]  [00000000004c75d0] generic_smp_call_function_single_interrupt+0x150/0x1c0
[  189.906581]  [000000000043e514] smp_call_function_single_client+0x14/0x40
====================

Based almost entirely upon a patch by Paul E. McKenney.

Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/kernel/smp_64.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 2b4e03e9cd4b..226ff1af1d26 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -822,13 +822,17 @@ void arch_send_call_function_single_ipi(int cpu)
 void __irq_entry smp_call_function_client(int irq, struct pt_regs *regs)
 {
 	clear_softint(1 << irq);
+	irq_enter();
 	generic_smp_call_function_interrupt();
+	irq_exit();
 }
 
 void __irq_entry smp_call_function_single_client(int irq, struct pt_regs *regs)
 {
 	clear_softint(1 << irq);
+	irq_enter();
 	generic_smp_call_function_single_interrupt();
+	irq_exit();
 }
 
 static void tsb_sync(void *info)
-- 
2.1.3

