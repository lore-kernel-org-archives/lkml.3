Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaBDIZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:25:02 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48136 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaBDIYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:24:54 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: b.brezillon@overkiz.com, nicolas.ferre@atmel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2] at91: pmc: Fixed irq's name allocation for programmable clocks
Date: Tue,  4 Feb 2014 09:21:45 +0100
Message-Id: <1391502105-24612-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391445961-20755-1-git-send-email-jjhiblot@traphandler.com>
References: <1391445961-20755-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name provided to request_irq() must be valid until the irq is released.
This patch stores the name in the internal data structure.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/clk/at91/clk-programmable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
index 8e242c7..799b75c 100644
--- a/drivers/clk/at91/clk-programmable.c
+++ b/drivers/clk/at91/clk-programmable.c
@@ -44,6 +44,7 @@ struct clk_programmable {
 	u8 css;
 	u8 pres;
 	u8 slckmck;
+	char irq_name[11];
 	const struct clk_programmable_layout *layout;
 };
 
@@ -247,7 +248,6 @@ at91_clk_register_programmable(struct at91_pmc *pmc, unsigned int irq,
 	struct clk_programmable *prog;
 	struct clk *clk = NULL;
 	struct clk_init_data init;
-	char irq_name[11];
 
 	if (id > PROG_ID_MAX)
 		return ERR_PTR(-EINVAL);
@@ -269,9 +269,9 @@ at91_clk_register_programmable(struct at91_pmc *pmc, unsigned int irq,
 	prog->irq = irq;
 	init_waitqueue_head(&prog->wait);
 	irq_set_status_flags(prog->irq, IRQ_NOAUTOEN);
-	snprintf(irq_name, sizeof(irq_name), "clk-prog%d", id);
+	snprintf(prog->irq_name, sizeof(prog->irq_name), "clk-prog%d", id);
 	ret = request_irq(prog->irq, clk_programmable_irq_handler,
-			  IRQF_TRIGGER_HIGH, irq_name, prog);
+			  IRQF_TRIGGER_HIGH, prog->irq_name, prog);
 	if (ret)
 		return ERR_PTR(ret);
 
-- 
1.8.5.2

