Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbaKFXL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:11:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58733 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaKFWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:24 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 037/162] sparc64: Fix lockdep warnings on reboot on Ultra-5
Date: Thu,  6 Nov 2014 14:35:01 -0800
Message-Id: <1415313426-9622-38-git-send-email-kamal@canonical.com>
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

[ Upstream commit bdcf81b658ebc4c2640c3c2c55c8b31c601b6996 ]

Inconsistently, the raw_* IRQ routines do not interact with and update
the irqflags tracing and lockdep state, whereas the raw_* spinlock
interfaces do.

This causes problems in p1275_cmd_direct() because we disable hardirqs
by hand using raw_local_irq_restore() and then do a raw_spin_lock()
which triggers a lockdep trace because the CPU's hw IRQ state doesn't
match IRQ tracing's internal software copy of that state.

The CPU's irqs are disabled, yet current->hardirqs_enabled is true.

====================
reboot: Restarting system
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:3536 check_flags+0x7c/0x240()
DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)
Modules linked in: openpromfs
CPU: 0 PID: 1 Comm: systemd-shutdow Tainted: G        W      3.17.0-dirty #145
Call Trace:
 [000000000045919c] warn_slowpath_common+0x5c/0xa0
 [0000000000459210] warn_slowpath_fmt+0x30/0x40
 [000000000048f41c] check_flags+0x7c/0x240
 [0000000000493280] lock_acquire+0x20/0x1c0
 [0000000000832b70] _raw_spin_lock+0x30/0x60
 [000000000068f2fc] p1275_cmd_direct+0x1c/0x60
 [000000000068ed28] prom_reboot+0x28/0x40
 [000000000043610c] machine_restart+0x4c/0x80
 [000000000047d2d4] kernel_restart+0x54/0x80
 [000000000047d618] SyS_reboot+0x138/0x200
 [00000000004060b4] linux_sparc_syscall32+0x34/0x60
---[ end trace 5c439fe81c05a100 ]---
possible reason: unannotated irqs-off.
irq event stamp: 2010267
hardirqs last  enabled at (2010267): [<000000000049a358>] vprintk_emit+0x4b8/0x580
hardirqs last disabled at (2010266): [<0000000000499f08>] vprintk_emit+0x68/0x580
softirqs last  enabled at (2010046): [<000000000045d278>] __do_softirq+0x378/0x4a0
softirqs last disabled at (2010039): [<000000000042bf08>] do_softirq_own_stack+0x28/0x40
Resetting ...
====================

Use local_* variables of the hw IRQ interfaces so that IRQ tracing sees
all of our changes.

Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/prom/p1275.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/prom/p1275.c b/arch/sparc/prom/p1275.c
index 04a4540..ea5b427 100644
--- a/arch/sparc/prom/p1275.c
+++ b/arch/sparc/prom/p1275.c
@@ -10,6 +10,7 @@
 #include <linux/smp.h>
 #include <linux/string.h>
 #include <linux/spinlock.h>
+#include <linux/irqflags.h>
 
 #include <asm/openprom.h>
 #include <asm/oplib.h>
@@ -37,8 +38,8 @@ void p1275_cmd_direct(unsigned long *args)
 {
 	unsigned long flags;
 
-	raw_local_save_flags(flags);
-	raw_local_irq_restore((unsigned long)PIL_NMI);
+	local_save_flags(flags);
+	local_irq_restore((unsigned long)PIL_NMI);
 	raw_spin_lock(&prom_entry_lock);
 
 	prom_world(1);
@@ -46,7 +47,7 @@ void p1275_cmd_direct(unsigned long *args)
 	prom_world(0);
 
 	raw_spin_unlock(&prom_entry_lock);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 }
 
 void prom_cif_init(void *cif_handler, void *cif_stack)
-- 
1.9.1

