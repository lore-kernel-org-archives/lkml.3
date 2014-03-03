Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaCCQtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:49:03 -0500
Received: from top.free-electrons.com ([176.31.233.9]:35914 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751494AbaCCQtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:49:01 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>, Felipe Balbi <balbi@ti.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] usb: gadget: atmel_usba: Fix crashed during stopping when DEBUG is enabled
Date: Mon,  3 Mar 2014 17:48:34 +0100
Message-Id: <1393865324-27309-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debug trace in the atmel_usba_stop function made the assumption
that the driver pointer passed in parameter was not NULL. Since the
commit "usb: gadget: udc-core: fix a regression during gadget driver
unbinding", it was no more always true. This lead to a kernel crash.

This commit now use the driver pointer stored in udc which fixes this
issue.

Since the commit which have triggered this issue was backported to the
3.2 stable branch, then this one should also be backported to the same
kernel.

Fixes: 511f3c5326ea (usb: gadget: udc-core: fix a regression during gadget driver unbinding)
Cc: stable@vger.kernel.org # v3.2+
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
Changelog:
v1 -> v2
Fixed the signature block in the commit log

 drivers/usb/gadget/atmel_usba_udc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 52771d4c44bc..167843de2d8a 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1827,12 +1827,12 @@ static int atmel_usba_stop(struct usb_gadget *gadget,
 	toggle_bias(0);
 	usba_writel(udc, CTRL, USBA_DISABLE_MASK);
 
-	udc->driver = NULL;
-
 	clk_disable_unprepare(udc->hclk);
 	clk_disable_unprepare(udc->pclk);
 
-	DBG(DBG_GADGET, "unregistered driver `%s'\n", driver->driver.name);
+	DBG(DBG_GADGET, "unregistered driver `%s'\n", udc->driver->driver.name);
+
+	udc->driver = NULL;
 
 	return 0;
 }
-- 
1.8.1.2

