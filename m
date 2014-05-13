Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842AbaEMKkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:40:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60759 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760027AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>,
        Tony Lindgren <tony@atomide.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 011/182] ARM: OMAP2+: INTC: Acknowledge stuck active interrupts
Date: Tue, 13 May 2014 11:26:03 +0200
Message-Id: <5a3dd1ee8b3c1dc27b66ace638ebe1a0d306ea0e.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Sørensen <stefan.sorensen@spectralink.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 698b48532539484b012fb7c4176b959d32a17d00 upstream.

When an interrupt has become active on the INTC it will stay active
until it is acked, even if masked or de-asserted. The
INTC_PENDING_IRQn registers are however updated and since these are
used by omap_intc_handle_irq to determine which interrupt to handle,
it will never see the active interrupt. This will result in a storm of
useless interrupts that is only stopped when another higher priority
interrupt is asserted.

Fix by sending the INTC an acknowledge if we find no interrupts to
handle.

Signed-off-by: Stefan Sørensen <stefan.sorensen@spectralink.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-omap2/irq.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index e022a869bff2..6037a9a01ed5 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -222,6 +222,7 @@ void __init ti81xx_init_irq(void)
 static inline void omap_intc_handle_irq(void __iomem *base_addr, struct pt_regs *regs)
 {
 	u32 irqnr;
+	int handled_irq = 0;
 
 	do {
 		irqnr = readl_relaxed(base_addr + 0x98);
@@ -249,8 +250,15 @@ out:
 		if (irqnr) {
 			irqnr = irq_find_mapping(domain, irqnr);
 			handle_IRQ(irqnr, regs);
+			handled_irq = 1;
 		}
 	} while (irqnr);
+
+	/* If an irq is masked or deasserted while active, we will
+	 * keep ending up here with no irq handled. So remove it from
+	 * the INTC with an ack.*/
+	if (!handled_irq)
+		omap_ack_irq(NULL);
 }
 
 asmlinkage void __exception_irq_entry omap2_intc_handle_irq(struct pt_regs *regs)
-- 
1.9.3

