Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbaEDRBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:01:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaEDPlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.14 007/158] ARM: OMAP2+: INTC: Acknowledge stuck active interrupts
Date: Sun,  4 May 2014 11:38:36 -0400
Message-Id: <20140504154031.023067695@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Sørensen <stefan.sorensen@spectralink.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/irq.c |    8 ++++++++
 1 file changed, 8 insertions(+)

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


