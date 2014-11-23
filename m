Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaKXUUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:20:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48638 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbaKXUUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:20:33 -0500
Date: Sun, 23 Nov 2014 10:11:59 -0800
From: tip-bot for Marc Zyngier <tipbot@zytor.com>
Message-ID: <tip-f86eff222fabe30da5c536ef2b51bd98d14cfe3b@git.kernel.org>
Cc: hpa@zytor.com, mingo@kernel.org, bhelgaas@google.com,
        jiang.liu@linux.intel.com, tglx@linutronix.de, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org, yingjoe.chen@mediatek.com
Reply-To: mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de,
        jiang.liu@linux.intel.com, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        yingjoe.chen@mediatek.com
In-Reply-To: <1416048553-29289-3-git-send-email-marc.zyngier@arm.com>
References: <1416048553-29289-3-git-send-email-marc.zyngier@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/irqdomain] genirq:
  Work around __irq_set_handler vs stacked domains ordering issues
Git-Commit-ID: f86eff222fabe30da5c536ef2b51bd98d14cfe3b
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

Commit-ID:  f86eff222fabe30da5c536ef2b51bd98d14cfe3b
Gitweb:     http://git.kernel.org/tip/f86eff222fabe30da5c536ef2b51bd98d14cfe3b
Author:     Marc Zyngier <marc.zyngier@arm.com>
AuthorDate: Sat, 15 Nov 2014 10:49:13 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 23 Nov 2014 13:01:47 +0100

genirq: Work around __irq_set_handler vs stacked domains ordering issues

With the introduction of stacked domains, we have the issue that,
depending on where in the stack this is called, __irq_set_handler
will succeed or fail: If this is called from the inner irqchip,
__irq_set_handler() will fail, as it will look at the outer domain
as the (desc->irq_data.chip == &no_irq_chip) test fails (we haven't
set the top level yet).

This patch implements the following: "If there is at least one
valid irqchip in the domain, it will probably sort itself out".
This is clearly not ideal, but it is far less confusing then
crashing because the top-level domain is not up yet.

[ tglx: Added comment and a protection against chained interrupts in
  	that context ]

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Link: http://lkml.kernel.org/r/1416048553-29289-3-git-send-email-marc.zyngier@arm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 63c16d1..6f1c7a5 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -731,7 +731,30 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	if (!handle) {
 		handle = handle_bad_irq;
 	} else {
-		if (WARN_ON(desc->irq_data.chip == &no_irq_chip))
+		struct irq_data *irq_data = &desc->irq_data;
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+		/*
+		 * With hierarchical domains we might run into a
+		 * situation where the outermost chip is not yet set
+		 * up, but the inner chips are there.  Instead of
+		 * bailing we install the handler, but obviously we
+		 * cannot enable/startup the interrupt at this point.
+		 */
+		while (irq_data) {
+			if (irq_data->chip != &no_irq_chip)
+				break;
+			/*
+			 * Bail out if the outer chip is not set up
+			 * and the interrrupt supposed to be started
+			 * right away.
+			 */
+			if (WARN_ON(is_chained))
+				goto out;
+			/* Try the parent */
+			irq_data = irq_data->parent_data;
+		}
+#endif
+		if (WARN_ON(!irq_data || irq_data->chip == &no_irq_chip))
 			goto out;
 	}
 
