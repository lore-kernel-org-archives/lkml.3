Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaDOQ1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:27:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60230 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaDOQ1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:27:47 -0400
Date: Tue, 15 Apr 2014 09:27:33 -0700
From: tip-bot for Linus Walleij <tipbot@zytor.com>
Message-ID: <tip-f6da9fe45c3074b909084ae9da5f55034ebffeb4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, linus.walleij@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linus.walleij@linaro.org
In-Reply-To: <1397550484-7119-1-git-send-email-linus.walleij@linaro.org>
References: <1397550484-7119-1-git-send-email-linus.walleij@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irqchip: vic: Properly chain the cascaded IRQs
Git-Commit-ID: f6da9fe45c3074b909084ae9da5f55034ebffeb4
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

Commit-ID:  f6da9fe45c3074b909084ae9da5f55034ebffeb4
Gitweb:     http://git.kernel.org/tip/f6da9fe45c3074b909084ae9da5f55034ebffeb4
Author:     Linus Walleij <linus.walleij@linaro.org>
AuthorDate: Tue, 15 Apr 2014 10:28:04 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 15 Apr 2014 18:24:24 +0200

irqchip: vic: Properly chain the cascaded IRQs

We are flagging the parent IRQ as chained, then we must also
make sure to call the chained_irq_[enter|exit] functions for
things to work smoothly.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: http://lkml.kernel.org/r/1397550484-7119-1-git-send-email-linus.walleij@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-vic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index 37dab0b..7d35287 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/irqchip/chained_irq.h>
 #include <linux/irqdomain.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -228,12 +229,17 @@ static int handle_one_vic(struct vic_device *vic, struct pt_regs *regs)
 static void vic_handle_irq_cascaded(unsigned int irq, struct irq_desc *desc)
 {
 	u32 stat, hwirq;
+	struct irq_chip *host_chip = irq_desc_get_chip(desc);
 	struct vic_device *vic = irq_desc_get_handler_data(desc);
 
+	chained_irq_enter(host_chip, desc);
+
 	while ((stat = readl_relaxed(vic->base + VIC_IRQ_STATUS))) {
 		hwirq = ffs(stat) - 1;
 		generic_handle_irq(irq_find_mapping(vic->domain, hwirq));
 	}
+
+	chained_irq_exit(host_chip, desc);
 }
 
 /*
