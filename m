Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3FQNuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:50:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54409 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3FQNt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:49:59 -0400
Date: Mon, 17 Jun 2013 15:49:57 +0200
From: Pavel Machek <pavel@denx.de>
To: dzu@denx.de, hjk@hansjkoch.de, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] fix UIO with device tree but no assigned interrupt
Message-ID: <20130617134957.GA15602@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device is initialized from device tree, but has no interrupt assigned,
uio will still try to request and interrupt old way, fails, and fails registration.
   
This is wrong; don't try initializing irq using platform data if device tree is
available.
    
Signed-off-by: Pavel Machek <pavel@denx.de>
Reported-by: Detlev Zundel <dzu@denx.de>
Tested-by: Detlev Zundel <dzu@denx.de>

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 8fcc2c7..f709ead 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -213,7 +213,8 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 		goto bad0;
 	}
 
-	if (!uioinfo->irq) {
+	/* interrupts from device tree are already handled above */
+	if (!pdev->dev.of_node && !uioinfo->irq) {
 		ret = platform_get_irq(pdev, 0);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get IRQ\n");

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
