Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaCNM4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:56:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbaCNM4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:56:01 -0400
Date: Fri, 14 Mar 2014 05:55:45 -0700
From: tip-bot for Hans de Goede <tipbot@zytor.com>
Message-ID: <tip-e9df9e221665d40928e25a02c2700ac12eda7270@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
In-Reply-To: <1394733834-26839-5-git-send-email-hdegoede@redhat.com>
References: <1394733834-26839-5-git-send-email-hdegoede@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: sun4i: Don't ack IRQs > 0,
  fix acking of IRQ 0
Git-Commit-ID: e9df9e221665d40928e25a02c2700ac12eda7270
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9df9e221665d40928e25a02c2700ac12eda7270
Gitweb:     http://git.kernel.org/tip/e9df9e221665d40928e25a02c2700ac12eda7270
Author:     Hans de Goede <hdegoede@redhat.com>
AuthorDate: Thu, 13 Mar 2014 19:03:54 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 14 Mar 2014 13:43:33 +0100

irqchip: sun4i: Don't ack IRQs > 0, fix acking of IRQ 0

All IRQs except for IRQ 0 seem to not need acking, so drop acking for them.

The ENMI needs to have the ack done *after* clearing the interrupt source,
otherwise we will get a spurious interrupt for each real interrupt.

So use the new IRQCHIP_EOI_THREADED flag for this in combination with
handle_fasteoi_irq. This uses a separate irq_chip struct for IRQ 0,
since we only want this behavior for IRQ 0.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@googlegroups.com
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Link: http://lkml.kernel.org/r/1394733834-26839-5-git-send-email-hdegoede@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-sun4i.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index 60a28c6..2029cc5 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -76,16 +76,29 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
 
 static struct irq_chip sun4i_irq_chip = {
 	.name		= "sun4i_irq",
-	.irq_ack	= sun4i_irq_ack,
 	.irq_mask	= sun4i_irq_mask,
 	.irq_unmask	= sun4i_irq_unmask,
 };
 
+/* IRQ 0 / the ENMI needs a late eoi call */
+static struct irq_chip sun4i_irq_chip_enmi = {
+	.name		= "sun4i_irq",
+	.irq_eoi	= sun4i_irq_ack,
+	.irq_mask	= sun4i_irq_mask,
+	.irq_unmask	= sun4i_irq_unmask,
+	.flags		= IRQCHIP_EOI_THREADED | IRQCHIP_EOI_IF_HANDLED,
+};
+
 static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
 			 irq_hw_number_t hw)
 {
-	irq_set_chip_and_handler(virq, &sun4i_irq_chip,
-				 handle_level_irq);
+	if (hw == 0)
+		irq_set_chip_and_handler(virq, &sun4i_irq_chip_enmi,
+					 handle_fasteoi_irq);
+	else
+		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
+					 handle_level_irq);
+
 	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
 
 	return 0;
