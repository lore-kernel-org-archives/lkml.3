Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3GEXjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 19:39:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35466 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3GEXjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 19:39:35 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] irqchip: gic: Don't complain in gic_get_cpumask() if UP system
Date: Fri,  5 Jul 2013 16:39:33 -0700
Message-Id: <1373067573-29946-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.2.733.gf8abaeb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a uniprocessor implementation the interrupt processor targets
registers are read-as-zero/write-ignored (RAZ/WI). Unfortunately
gic_get_cpumask() will print a critical message saying

 GIC CPU mask not found - kernel will fail to boot.

if these registers all read as zero, but there won't actually be
a problem on uniprocessor systems and the kernel will boot just
fine. Skip this check if we're running a UP kernel or if we
detect that the hardware only supports a single processor.

Cc: Nicolas Pitre <nico@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Maybe we should just drop the check entirely? It looks like it may
just be debug code that won't ever trigger in practice, even on the
11MPCore that caused this code to be introduced.

 drivers/irqchip/irq-gic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 19ceaa6..589c760 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -368,7 +368,7 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
 			break;
 	}
 
-	if (!mask)
+	if (!mask && num_possible_cpus() > 1)
 		pr_crit("GIC CPU mask not found - kernel will fail to boot.\n");
 
 	return mask;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

