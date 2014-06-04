Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaFDLko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:40:44 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58908 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbaFDLgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:06 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 09/21] apbps2: use devm_irq_of_parse_and_map()
Date: Wed,  4 Jun 2014 15:13:09 +0400
Message-Id: <1401880402-30091-10-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids leak of IRQ mapping on error paths, and makes it possible
to use devm_request_irq() without facing unmap-while-handler-installed
issues.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/input/serio/apbps2.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/input/serio/apbps2.c b/drivers/input/serio/apbps2.c
index 17e01a8..e8d0b8e 100644
--- a/drivers/input/serio/apbps2.c
+++ b/drivers/input/serio/apbps2.c
@@ -155,7 +155,11 @@ static int apbps2_of_probe(struct platform_device *ofdev)
 	iowrite32be(0, &priv->regs->ctrl);
 
 	/* IRQ */
-	irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
+	irq = devm_irq_of_parse_and_map(&ofdev->dev, ofdev->dev.of_node, 0);
+	if (irq <= 0) {
+		dev_err(&ofdev->dev, "unable to locate IRQ\n");
+		return irq ? irq  : -EINVAL;
+	}
 	err = devm_request_irq(&ofdev->dev, irq, apbps2_isr,
 				IRQF_SHARED, "apbps2", priv);
 	if (err) {
-- 
1.7.10.4

