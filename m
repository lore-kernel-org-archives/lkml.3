Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaCNMzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:55:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbaCNMzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:55:39 -0400
Date: Fri, 14 Mar 2014 05:55:23 -0700
From: tip-bot for Hans de Goede <tipbot@zytor.com>
Message-ID: <tip-56af0416b00f6edc7845a7b3f2ef179e385c8e15@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
In-Reply-To: <1394733834-26839-3-git-send-email-hdegoede@redhat.com>
References: <1394733834-26839-3-git-send-email-hdegoede@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: sun4i: Fix irq 0 not working
Git-Commit-ID: 56af0416b00f6edc7845a7b3f2ef179e385c8e15
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

Commit-ID:  56af0416b00f6edc7845a7b3f2ef179e385c8e15
Gitweb:     http://git.kernel.org/tip/56af0416b00f6edc7845a7b3f2ef179e385c8e15
Author:     Hans de Goede <hdegoede@redhat.com>
AuthorDate: Thu, 13 Mar 2014 19:03:52 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 14 Mar 2014 13:43:33 +0100

irqchip: sun4i: Fix irq 0 not working

SUN4I_IRQ_VECTOR_REG containing 0 can mean one of 3 things:

1) no more irqs pending
2) irq 0 pending
3) spurious irq

So if we immediately get a reading of 0, check the irq-pending reg
to differentiate between 2 and 3. We only do this once to avoid
the extra check in the common case of 1) hapening after having
read the vector-reg once.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@googlegroups.com
Link: http://lkml.kernel.org/r/1394733834-26839-3-git-send-email-hdegoede@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-sun4i.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index 1599955..7ae85ec 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -140,10 +140,24 @@ static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
 {
 	u32 irq, hwirq;
 
+	/*
+	 * hwirq == 0 can mean one of 3 things:
+	 * 1) no more irqs pending
+	 * 2) irq 0 pending
+	 * 3) spurious irq
+	 * So if we immediately get a reading of 0, check the irq-pending reg
+	 * to differentiate between 2 and 3. We only do this once to avoid
+	 * the extra check in the common case of 1 hapening after having
+	 * read the vector-reg once.
+	 */
 	hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
-	while (hwirq != 0) {
+	if (hwirq == 0 &&
+		  !(readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(0)) & BIT(0)))
+		return;
+
+	do {
 		irq = irq_find_mapping(sun4i_irq_domain, hwirq);
 		handle_IRQ(irq, regs);
 		hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
-	}
+	} while (hwirq != 0);
 }
