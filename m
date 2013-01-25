Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab3AYRdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:33:11 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:49171 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab3AYRdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:33:04 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v2 1/5] arm: mvebu: Add support for local interrupt
Date: Fri, 25 Jan 2013 18:32:41 +0100
Message-Id: <1359135165-32108-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359135165-32108-1-git-send-email-gregory.clement@free-electrons.com>
References: <1359135165-32108-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MPIC allows the use of private interrupt for each CPUs. The 28th first
interrupts are per-cpu. This patch adds support to use them.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/irq-armada-370-xp.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-mvebu/irq-armada-370-xp.c b/arch/arm/mach-mvebu/irq-armada-370-xp.c
index f99a4a2..274ff58 100644
--- a/arch/arm/mach-mvebu/irq-armada-370-xp.c
+++ b/arch/arm/mach-mvebu/irq-armada-370-xp.c
@@ -145,10 +145,17 @@ static int armada_370_xp_mpic_irq_map(struct irq_domain *h,
 {
 	armada_370_xp_irq_mask(irq_get_irq_data(virq));
 	writel(hw, main_int_base + ARMADA_370_XP_INT_SET_ENABLE_OFFS);
-
-	irq_set_chip_and_handler(virq, &armada_370_xp_irq_chip,
-				 handle_level_irq);
 	irq_set_status_flags(virq, IRQ_LEVEL);
+
+	if (hw < ARMADA_370_XP_MAX_PER_CPU_IRQS) {
+		irq_set_percpu_devid(virq);
+		irq_set_chip_and_handler(virq, &armada_370_xp_irq_chip,
+					handle_percpu_devid_irq);
+
+	} else {
+		irq_set_chip_and_handler(virq, &armada_370_xp_irq_chip,
+					handle_level_irq);
+	}
 	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
 
 	return 0;
@@ -245,7 +252,7 @@ asmlinkage void __exception_irq_entry armada_370_xp_handle_irq(struct pt_regs
 		if (irqnr > 1022)
 			break;
 
-		if (irqnr >= 8) {
+		if (irqnr > 0) {
 			irqnr =	irq_find_mapping(armada_370_xp_mpic_domain,
 					irqnr);
 			handle_IRQ(irqnr, regs);
-- 
1.7.9.5

