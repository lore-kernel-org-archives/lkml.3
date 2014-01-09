Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaAIKzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:55:42 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:29551 "EHLO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbaAIKzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:55:23 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH 3/6] usb: gadget: gr_udc: Use platform_get_irq instead of irq_of_parse_and_map
Date: Thu,  9 Jan 2014 11:54:15 +0100
Message-Id: <1389264858-32664-4-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389264858-32664-1-git-send-email-andreas@gaisler.com>
References: <1389264858-32664-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use platform_get_irq as no mapping needs to be done. No functional difference
for SPARC which is the typical environment for the driver though. Suggested by
Mark Rutland.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/usb/gadget/gr_udc.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
index e66dcf0..e471db3 100644
--- a/drivers/usb/gadget/gr_udc.c
+++ b/drivers/usb/gadget/gr_udc.c
@@ -2114,20 +2114,22 @@ static int gr_probe(struct platform_device *pdev)
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
 
-	dev->irq = irq_of_parse_and_map(dev->dev->of_node, 0);
-	if (!dev->irq) {
+	dev->irq = platform_get_irq(pdev, 0);
+	if (dev->irq <= 0) {
 		dev_err(dev->dev, "No irq found\n");
 		return -ENODEV;
 	}
 
 	/* Some core configurations has separate irqs for IN and OUT events */
-	dev->irqi = irq_of_parse_and_map(dev->dev->of_node, 1);
-	if (dev->irqi) {
-		dev->irqo = irq_of_parse_and_map(dev->dev->of_node, 2);
-		if (!dev->irqo) {
+	dev->irqi = platform_get_irq(pdev, 1);
+	if (dev->irqi > 0) {
+		dev->irqo = platform_get_irq(pdev, 2);
+		if (dev->irqo <= 0) {
 			dev_err(dev->dev, "Found irqi but not irqo\n");
 			return -ENODEV;
 		}
+	} else {
+		dev->irqi = 0;
 	}
 
 	dev->gadget.name = driver_name;
-- 
1.7.10.4

