Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaCaJQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:16:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41651 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaCaJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:16:38 -0400
Date: Mon, 31 Mar 2014 02:16:18 -0700
From: tip-bot for Hans de Goede <tipbot@zytor.com>
Message-ID: <tip-1b422ecd27866985b9f35d0d2b5ae6e9122dd4c0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hdegoede@redhat.com, carlo@caione.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de, carlo@caione.org
In-Reply-To: <1395939759-11135-3-git-send-email-carlo@caione.org>
References: <1395939759-11135-3-git-send-email-carlo@caione.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: sun7i/sun6i:
  Disable NMI before registering the handler
Git-Commit-ID: 1b422ecd27866985b9f35d0d2b5ae6e9122dd4c0
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

Commit-ID:  1b422ecd27866985b9f35d0d2b5ae6e9122dd4c0
Gitweb:     http://git.kernel.org/tip/1b422ecd27866985b9f35d0d2b5ae6e9122dd4c0
Author:     Hans de Goede <hdegoede@redhat.com>
AuthorDate: Thu, 27 Mar 2014 18:02:39 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Mar 2014 11:12:57 +0200

irqchip: sun7i/sun6i: Disable NMI before registering the handler

It is advisable to disable the NMI before registering the IRQ handler as
registering the IRQ handler unmasks the IRQ on the GIC, so if U-Boot has
left the NMI enabled and the NMI pin is active we will immediately get
an interrupt before any driver has claimed the downstream interrupt of
the NMI.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Carlo Caione <carlo@caione.org>
Cc: maxime.ripard@free-electrons.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@googlegroups.com
Link: http://lkml.kernel.org/r/1395939759-11135-3-git-send-email-carlo@caione.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-sunxi-nmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-sunxi-nmi.c b/drivers/irqchip/irq-sunxi-nmi.c
index 1c8566c..12f547a 100644
--- a/drivers/irqchip/irq-sunxi-nmi.c
+++ b/drivers/irqchip/irq-sunxi-nmi.c
@@ -179,12 +179,12 @@ static int __init sunxi_sc_nmi_irq_init(struct device_node *node,
 	gc->chip_types[1].regs.type		= reg_offs->ctrl;
 	gc->chip_types[1].handler		= handle_edge_irq;
 
-	irq_set_handler_data(irq, domain);
-	irq_set_chained_handler(irq, sunxi_sc_nmi_handle_irq);
-
 	sunxi_sc_nmi_write(gc, reg_offs->enable, 0);
 	sunxi_sc_nmi_write(gc, reg_offs->pend, 0x1);
 
+	irq_set_handler_data(irq, domain);
+	irq_set_chained_handler(irq, sunxi_sc_nmi_handle_irq);
+
 	return 0;
 
 fail_irqd_remove:
