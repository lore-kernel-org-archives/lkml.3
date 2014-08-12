Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaHLOAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:00:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51068 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbaHLOAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:00:08 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] mfd: arizona: Avoid use of legacy IRQ mapping
Date: Tue, 12 Aug 2014 14:51:22 +0100
Message-Id: <1407851483-19207-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regmap_add_irq_chip is called from arizona_irq_init with the irq_base
specified as -1 and regmap_add_irq_chip uses if (irq_base) to check if
it should use legacy IRQ mapping. As such the irq mappings are currently
added with irq_domain_add_legacy, rather than irq_domain_add_linear.
This is clearly a typo as there is no reason why this driver can't use
irq_domain_add_linear.

This patch corrects this by passing the irq_base as zero to
regmap_add_irq_chip.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index fac00b2..b235e59 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -289,7 +289,7 @@ int arizona_irq_init(struct arizona *arizona)
 
 	ret = regmap_add_irq_chip(arizona->regmap,
 				  irq_create_mapping(arizona->virq, 0),
-				  IRQF_ONESHOT, -1, aod,
+				  IRQF_ONESHOT, 0, aod,
 				  &arizona->aod_irq_chip);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to add AOD IRQs: %d\n", ret);
@@ -298,7 +298,7 @@ int arizona_irq_init(struct arizona *arizona)
 
 	ret = regmap_add_irq_chip(arizona->regmap,
 				  irq_create_mapping(arizona->virq, 1),
-				  IRQF_ONESHOT, -1, irq,
+				  IRQF_ONESHOT, 0, irq,
 				  &arizona->irq_chip);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to add main IRQs: %d\n", ret);
-- 
1.7.2.5

