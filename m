Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaLCL7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:59:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbaLCL1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 013/101] sparc64: Fix crashes in schizo_pcierr_intr_other().
Date: Wed,  3 Dec 2014 12:25:35 +0100
Message-Id: <80059d68eda6b553d0e6e730bfb37e3c2700ce84.1417605922.git.jslaby@suse.cz>
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

[ Upstream commit 7da89a2a3776442a57e918ca0b8678d1b16a7072 ]

Meelis Roos reports crashes during bootup on a V480 that look like
this:

====================
[   61.300577] PCI: Scanning PBM /pci@9,600000
[   61.304867] schizo f009b070: PCI host bridge to bus 0003:00
[   61.310385] pci_bus 0003:00: root bus resource [io  0x7ffe9000000-0x7ffe9ffffff] (bus address [0x0000-0xffffff])
[   61.320515] pci_bus 0003:00: root bus resource [mem 0x7fb00000000-0x7fbffffffff] (bus address [0x00000000-0xffffffff])
[   61.331173] pci_bus 0003:00: root bus resource [bus 00]
[   61.385344] Unable to handle kernel NULL pointer dereference
[   61.390970] tsk->{mm,active_mm}->context = 0000000000000000
[   61.396515] tsk->{mm,active_mm}->pgd = fff000b000002000
[   61.401716]               \|/ ____ \|/
[   61.401716]               "@'/ .. \`@"
[   61.401716]               /_| \__/ |_\
[   61.401716]                  \__U_/
[   61.416362] swapper/0(0): Oops [#1]
[   61.419837] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc1-00422-g2cc9188-dirty #24
[   61.427975] task: fff000b0fd8e9c40 ti: fff000b0fd928000 task.ti: fff000b0fd928000
[   61.435426] TSTATE: 0000004480e01602 TPC: 00000000004455e4 TNPC: 00000000004455e8 Y: 00000000    Not tainted
[   61.445230] TPC: <schizo_pcierr_intr+0x104/0x560>
[   61.449897] g0: 0000000000000000 g1: 0000000000000000 g2: 0000000000a10f78 g3: 000000000000000a
[   61.458563] g4: fff000b0fd8e9c40 g5: fff000b0fdd82000 g6: fff000b0fd928000 g7: 000000000000000a
[   61.467229] o0: 000000000000003d o1: 0000000000000000 o2: 0000000000000006 o3: fff000b0ffa5fc7e
[   61.475894] o4: 0000000000060000 o5: c000000000000000 sp: fff000b0ffa5f3c1 ret_pc: 00000000004455cc
[   61.484909] RPC: <schizo_pcierr_intr+0xec/0x560>
[   61.489500] l0: fff000b0fd8e9c40 l1: 0000000000a20800 l2: 0000000000000000 l3: 000000000119a430
[   61.498164] l4: 0000000001742400 l5: 00000000011cfbe0 l6: 00000000011319c0 l7: fff000b0fd8ea348
[   61.506830] i0: 0000000000000000 i1: fff000b0fdb34000 i2: 0000000320000000 i3: 0000000000000000
[   61.515497] i4: 00060002010b003f i5: 0000040004e02000 i6: fff000b0ffa5f481 i7: 00000000004a9920
[   61.524175] I7: <handle_irq_event_percpu+0x40/0x140>
[   61.529099] Call Trace:
[   61.531531]  [00000000004a9920] handle_irq_event_percpu+0x40/0x140
[   61.537681]  [00000000004a9a58] handle_irq_event+0x38/0x80
[   61.543145]  [00000000004ac77c] handle_fasteoi_irq+0xbc/0x200
[   61.548860]  [00000000004a9084] generic_handle_irq+0x24/0x40
[   61.554500]  [000000000042be0c] handler_irq+0xac/0x100
====================

The problem is that pbm->pci_bus->self is NULL.

This code is trying to go through the standard PCI config space
interfaces to read the PCI controller's PCI_STATUS register.

This doesn't work, because we more often than not do not enumerate
the PCI controller as a bonafide PCI device during the OF device
node scan.  Therefore bus->self remains NULL.

Existing common code for PSYCHO and PSYCHO-like PCI controllers
handles this properly, by doing the config space access directly.

Do the same here, pbm->pci_ops->{read,write}().

Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/kernel/pci_schizo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/pci_schizo.c b/arch/sparc/kernel/pci_schizo.c
index 8f76f23dac38..f9c6813c132d 100644
--- a/arch/sparc/kernel/pci_schizo.c
+++ b/arch/sparc/kernel/pci_schizo.c
@@ -581,7 +581,7 @@ static irqreturn_t schizo_pcierr_intr_other(struct pci_pbm_info *pbm)
 {
 	unsigned long csr_reg, csr, csr_error_bits;
 	irqreturn_t ret = IRQ_NONE;
-	u16 stat;
+	u32 stat;
 
 	csr_reg = pbm->pbm_regs + SCHIZO_PCI_CTRL;
 	csr = upa_readq(csr_reg);
@@ -617,7 +617,7 @@ static irqreturn_t schizo_pcierr_intr_other(struct pci_pbm_info *pbm)
 			       pbm->name);
 		ret = IRQ_HANDLED;
 	}
-	pci_read_config_word(pbm->pci_bus->self, PCI_STATUS, &stat);
+	pbm->pci_ops->read(pbm->pci_bus, 0, PCI_STATUS, 2, &stat);
 	if (stat & (PCI_STATUS_PARITY |
 		    PCI_STATUS_SIG_TARGET_ABORT |
 		    PCI_STATUS_REC_TARGET_ABORT |
@@ -625,7 +625,7 @@ static irqreturn_t schizo_pcierr_intr_other(struct pci_pbm_info *pbm)
 		    PCI_STATUS_SIG_SYSTEM_ERROR)) {
 		printk("%s: PCI bus error, PCI_STATUS[%04x]\n",
 		       pbm->name, stat);
-		pci_write_config_word(pbm->pci_bus->self, PCI_STATUS, 0xffff);
+		pbm->pci_ops->write(pbm->pci_bus, 0, PCI_STATUS, 2, 0xffff);
 		ret = IRQ_HANDLED;
 	}
 	return ret;
-- 
2.1.3

