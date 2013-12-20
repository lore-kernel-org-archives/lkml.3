Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422661Ab3LTOXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:23:55 -0500
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:13220 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030204Ab3LTOXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:23:54 -0500
From: Aaro Koskinen <aaro.koskinen@nsn.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>
Cc: Aaro Koskinen <aaro.koskinen@nsn.com>
Subject: [PATCH] uio: fix devm_request_irq usage
Date: Fri, 20 Dec 2013 16:19:47 +0200
Message-Id: <1387549187-10068-1-git-send-email-aaro.koskinen@nsn.com>
X-Mailer: git-send-email 1.8.5.1
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1057
X-purgate-ID: 151667::1387549425-00001A6F-92379B3A/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e6789cd3dfb553077606ccafeb05e0043f072481 (uio: Simplify uio error
path by using devres functions) converted uio to use devm_request_irq().
This introduced a change in behaviour since the IRQ is associated with
the parent device instead of the created UIO device. The IRQ will remain
active after uio_unregister_device() is called, and some drivers will
crash because of this. The patch fixes this.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nsn.com>
---
 drivers/uio/uio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index f7beb6e..a673e5b 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -847,7 +847,7 @@ int __uio_register_device(struct module *owner,
 	info->uio_dev = idev;
 
 	if (info->irq && (info->irq != UIO_IRQ_CUSTOM)) {
-		ret = devm_request_irq(parent, info->irq, uio_interrupt,
+		ret = devm_request_irq(idev->dev, info->irq, uio_interrupt,
 				  info->irq_flags, info->name, idev);
 		if (ret)
 			goto err_request_irq;
-- 
1.8.5.1

