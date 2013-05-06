Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3EFJDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:03:40 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64019 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3EFJDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:03:39 -0400
Message-ID: <1367831012.3547.2.camel@phoenix>
Subject: [PATCH] irqchip: renesas-irqc: Fix irqc_probe error handling
From: Axel Lin <axel.lin@ingics.com>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Magnus Damm <damm@opensource.se>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Date: Mon, 06 May 2013 17:03:32 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in goto err3 path is wrong because it will call fee_irq() with k == 0,
which means it does free_irq(p->irq[-1].requested_irq, &p->irq[-1]);

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/irqchip/irq-renesas-irqc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-irqc.c b/drivers/irqchip/irq-renesas-irqc.c
index 649cd69..3651f77 100644
--- a/drivers/irqchip/irq-renesas-irqc.c
+++ b/drivers/irqchip/irq-renesas-irqc.c
@@ -252,8 +252,8 @@ static int irqc_probe(struct platform_device *pdev)
 
 	return 0;
 err3:
-	for (; k >= 0; k--)
-		free_irq(p->irq[k - 1].requested_irq, &p->irq[k - 1]);
+	while (--k >= 0)
+		free_irq(p->irq[k].requested_irq, &p->irq[k]);
 
 	irq_domain_remove(p->irq_domain);
 err2:
-- 
1.8.1.2



