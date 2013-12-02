Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3LBUII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:08:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3LBTRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josh Wu <josh.wu@atmel.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.12 071/212] mtd: atmel_nand: fix bug driver will in a dead lock if no nand detected
Date: Mon,  2 Dec 2013 11:14:22 -0800
Message-Id: <20131202191255.819566799@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Wu <josh.wu@atmel.com>

commit a749d13acd8e079ed4c77a9456d842dc94af8f17 upstream.

In the atmel driver probe function, the code shows like following:
  atmel_nand_probe(...) {
        ...

  err_nand_ioremap:
        platform_driver_unregister(&atmel_nand_nfc_driver);
        return res;
  }

If no nand flash detected, the driver probe function will goto
err_nand_ioremap label.
Then platform_driver_unregister() will be called. It will get the
lock of atmel_nand device since it is parent of nfc_device. The
problem is the lock is already hold by atmel_nand_probe itself.
So system will be in a dead lock.

This patch just simply removed to platform_driver_unregister() call.
When atmel_nand driver is quit the platform_driver_unregister() will
be called in atmel_nand_remove().

[Brian: the NAND platform probe really has no business
 registering/unregistering another driver; this fixes the deadlock, but
 we should follow up the likely racy behavior here with a better
 architecture]

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/atmel_nand.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -2177,7 +2177,6 @@ err_no_card:
 	if (host->dma_chan)
 		dma_release_channel(host->dma_chan);
 err_nand_ioremap:
-	platform_driver_unregister(&atmel_nand_nfc_driver);
 	return res;
 }
 


