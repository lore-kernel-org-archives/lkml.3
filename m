Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958AbaJDAim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:38:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbaJCVmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 3.16 147/357] usb: dwc2/gadget: delay enabling irq once hardware is configured properly
Date: Fri,  3 Oct 2014 14:28:53 -0700
Message-Id: <20141003212937.886817940@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit eb3c56c5ccdd252940cb0ec0541fcdc94894bd8d upstream.

This patch fixes kernel panic/interrupt storm/etc issues if bootloader
left s3c-hsotg module in enabled state. Now interrupt handler is enabled
only after proper configuration of hardware registers.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/gadget.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3444,13 +3444,6 @@ static int s3c_hsotg_probe(struct platfo
 
 	hsotg->irq = ret;
 
-	ret = devm_request_irq(&pdev->dev, hsotg->irq, s3c_hsotg_irq, 0,
-				dev_name(dev), hsotg);
-	if (ret < 0) {
-		dev_err(dev, "cannot claim IRQ\n");
-		goto err_clk;
-	}
-
 	dev_info(dev, "regs %p, irq %d\n", hsotg->regs, hsotg->irq);
 
 	hsotg->gadget.max_speed = USB_SPEED_HIGH;
@@ -3498,6 +3491,17 @@ static int s3c_hsotg_probe(struct platfo
 	s3c_hsotg_init(hsotg);
 	s3c_hsotg_hw_cfg(hsotg);
 
+	ret = devm_request_irq(&pdev->dev, hsotg->irq, s3c_hsotg_irq, 0,
+				dev_name(dev), hsotg);
+	if (ret < 0) {
+		s3c_hsotg_phy_disable(hsotg);
+		clk_disable_unprepare(hsotg->clk);
+		regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
+				       hsotg->supplies);
+		dev_err(dev, "cannot claim IRQ\n");
+		goto err_clk;
+	}
+
 	/* hsotg->num_of_eps holds number of EPs other than ep0 */
 
 	if (hsotg->num_of_eps == 0) {


