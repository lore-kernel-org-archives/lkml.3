Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaKOKtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 05:49:40 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:48568 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbaKOKti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 05:49:38 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] genirq: Work around __irq_set_handler vs stacked domains ordering issues
Date: Sat, 15 Nov 2014 10:49:13 +0000
Message-Id: <1416048553-29289-3-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416048553-29289-1-git-send-email-marc.zyngier@arm.com>
References: <1416048553-29289-1-git-send-email-marc.zyngier@arm.com>
X-SA-Exim-Connect-IP: 90.219.10.17
X-SA-Exim-Rcpt-To: tglx@linutronix.de, jiang.liu@linux.intel.com, yingjoe.chen@mediatek.com, bhelgaas@google.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 kernel/irq/chip.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d028b34..cad4f62 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -731,7 +731,16 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	if (!handle) {
 		handle = handle_bad_irq;
 	} else {
-		if (WARN_ON(desc->irq_data.chip == &no_irq_chip))
+		struct irq_data *irq_data = &desc->irq_data;
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+		while (irq_data) {
+			if (irq_data->chip != &no_irq_chip)
+				break;
+			irq_data = irq_data->parent_data;
+		}
+#endif
+
+		if (WARN_ON(!irq_data || irq_data->chip == &no_irq_chip))
 			goto out;
 	}
 
-- 
2.1.0

