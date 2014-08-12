Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaHLOAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:00:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51067 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbaHLOAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:00:08 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] mfd: arizona: Propagate irq_wake through to parent IRQ
Date: Tue, 12 Aug 2014 14:51:21 +0100
Message-Id: <1407851483-19207-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one of the internal Arizona IRQs is set as a wake source this needs
to be propogated back to the actual IRQ line that the Arizona device is
attached to.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 71e8f06..fac00b2 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -148,6 +148,13 @@ static void arizona_irq_dummy(struct irq_data *data)
 {
 }
 
+static int arizona_irq_set_wake(struct irq_data *data, unsigned int on)
+{
+	struct arizona *arizona = irq_data_get_irq_chip_data(data);
+
+	return irq_set_irq_wake(arizona->irq, on);
+}
+
 static struct irq_chip arizona_irq_chip = {
 	.name			= "arizona",
 	.irq_disable		= arizona_irq_dummy,
@@ -155,6 +162,7 @@ static struct irq_chip arizona_irq_chip = {
 	.irq_ack		= arizona_irq_dummy,
 	.irq_mask		= arizona_irq_dummy,
 	.irq_unmask		= arizona_irq_dummy,
+	.irq_set_wake		= arizona_irq_set_wake,
 };
 
 static int arizona_irq_map(struct irq_domain *h, unsigned int virq,
-- 
1.7.2.5

