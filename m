Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbaCSLhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:37:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33334 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279AbaCSLhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:37:08 -0400
Date: Wed, 19 Mar 2014 04:36:54 -0700
From: tip-bot for Hans de Goede <tipbot@zytor.com>
Message-ID: <tip-cc3b68fea29c3af018734501e166124c8eb04a6c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
In-Reply-To: <1394895894-8891-3-git-send-email-hdegoede@redhat.com>
References: <1394895894-8891-3-git-send-email-hdegoede@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: sun4i: Simplify sun4i_irq_ack
Git-Commit-ID: cc3b68fea29c3af018734501e166124c8eb04a6c
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

Commit-ID:  cc3b68fea29c3af018734501e166124c8eb04a6c
Gitweb:     http://git.kernel.org/tip/cc3b68fea29c3af018734501e166124c8eb04a6c
Author:     Hans de Goede <hdegoede@redhat.com>
AuthorDate: Sat, 15 Mar 2014 16:04:54 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Mar 2014 12:34:29 +0100

irqchip: sun4i: Simplify sun4i_irq_ack

Now that we only ack irq 0 the code can be simplified a lot.

Also switch from read / modify / write to a simple write clear:
1) This is what the android code does (it has a hack for acking irq 0
   in its unmask code doing this)

2) read / modify / write simply does not make sense for an irq status
   register like this, if the other bits are writeable (and the data sheet says
   they are not) they should be write 1 to clear, since otherwise a read /
   modify / write can race with a device raising an interrupt and then clear
   the pending bit unintentionally

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@googlegroups.com
Link: http://lkml.kernel.org/r/1394895894-8891-3-git-send-email-hdegoede@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-sun4i.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index 003a146..6fcef4a 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -41,16 +41,11 @@ static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
 static void sun4i_irq_ack(struct irq_data *irqd)
 {
 	unsigned int irq = irqd_to_hwirq(irqd);
-	unsigned int irq_off = irq % 32;
-	int reg = irq / 32;
-	u32 val;
 
 	if (irq != 0)
 		return; /* Only IRQ 0 / the ENMI needs to be acked */
 
-	val = readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
-	writel(val | (1 << irq_off),
-	       sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
+	writel(BIT(0), sun4i_irq_base + SUN4I_IRQ_PENDING_REG(0));
 }
 
 static void sun4i_irq_mask(struct irq_data *irqd)
