Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbaJ1Hep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:34:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbaJ1DlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:41:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Meelis Roos <mroos@linux.ee>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 127/146] sparc64: Fix lockdep warnings on reboot on Ultra-5
Date: Tue, 28 Oct 2014 11:34:29 +0800
Message-Id: <20141028033348.946294426@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/prom/p1275.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/sparc/prom/p1275.c
+++ b/arch/sparc/prom/p1275.c
@@ -9,6 +9,7 @@
 #include <linux/smp.h>
 #include <linux/string.h>
 #include <linux/spinlock.h>
+#include <linux/irqflags.h>
 
 #include <asm/openprom.h>
 #include <asm/oplib.h>
@@ -36,8 +37,8 @@ void p1275_cmd_direct(unsigned long *arg
 {
 	unsigned long flags;
 
-	raw_local_save_flags(flags);
-	raw_local_irq_restore((unsigned long)PIL_NMI);
+	local_save_flags(flags);
+	local_irq_restore((unsigned long)PIL_NMI);
 	raw_spin_lock(&prom_entry_lock);
 
 	prom_world(1);
@@ -45,7 +46,7 @@ void p1275_cmd_direct(unsigned long *arg
 	prom_world(0);
 
 	raw_spin_unlock(&prom_entry_lock);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 }
 
 void prom_cif_init(void *cif_handler, void *cif_stack)


