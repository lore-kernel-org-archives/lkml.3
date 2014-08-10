Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaHJT7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 15:59:44 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33701 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaHJT7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 15:59:42 -0400
Date: Mon, 11 Aug 2014 01:29:37 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] usb: phy: drop kfree of devm_kzalloc's data
Message-ID: <20140810195937.GA3923@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kfree to free data allocated with devm_kzalloc causes double frees.

The Coccinelle semantic patch that fixes this problem is as follows:

// <smpl>
@@
expression x;
@@

x = devm_kzalloc(...)
...
?-kfree(x);
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/usb/phy/phy-gpio-vbus-usb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-gpio-vbus-usb.c b/drivers/usb/phy/phy-gpio-vbus-usb.c
index ea9e705..f4b14bd 100644
--- a/drivers/usb/phy/phy-gpio-vbus-usb.c
+++ b/drivers/usb/phy/phy-gpio-vbus-usb.c
@@ -260,10 +260,8 @@ static int gpio_vbus_probe(struct platform_device *pdev)
 
 	gpio_vbus->phy.otg = devm_kzalloc(&pdev->dev, sizeof(struct usb_otg),
 					  GFP_KERNEL);
-	if (!gpio_vbus->phy.otg) {
-		kfree(gpio_vbus);
+	if (!gpio_vbus->phy.otg)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, gpio_vbus);
 	gpio_vbus->dev = &pdev->dev;
-- 
1.9.1

