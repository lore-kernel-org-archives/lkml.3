Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaFBPjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:39:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46302 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaFBPjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:39:45 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH-next] mfd: ab8500: fix dt irq mapping
Date: Mon, 2 Jun 2014 19:27:58 +0300
Message-ID: <1401726478-14879-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AD8500 defines itself as interrupt-controller in DT,
but it doesn't assign DT node to IRQ domain when creates it.
As result, of_irq_xx() helpers don't work because they can't
find necessary IRQ domain.

Hence, fix it by assigning AD8500 core device DT node to IRQ
domain when it's created.

This patch fixes STE u8500 Snowball boot failure reported by Kevin Hilman
https://lkml.org/lkml/2014/5/27/624

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Reported-and-tested-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/mfd/ab8500-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index a8ee4a3..cf2e6a1 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -591,7 +591,7 @@ static int ab8500_irq_init(struct ab8500 *ab8500, struct device_node *np)
 		num_irqs = AB8500_NR_IRQS;
 
 	/* If ->irq_base is zero this will give a linear mapping */
-	ab8500->domain = irq_domain_add_simple(NULL,
+	ab8500->domain = irq_domain_add_simple(ab8500->dev->of_node,
 			num_irqs, 0,
 			&ab8500_irq_ops, ab8500);
 
-- 
1.7.9.5

