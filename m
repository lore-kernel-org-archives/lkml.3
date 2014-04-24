Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbaDXLo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:44:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46368 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbaDXIwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 030/182] usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is enabled
Date: Thu, 24 Apr 2014 09:49:15 +0100
Message-Id: <1398329507-5911-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

commit d8eb6c653ef6b323d630de3c5685478469e248bc upstream.

commit 511f3c5 (usb: gadget: udc-core: fix a regression during gadget driver
unbinding) introduced a crash when DEBUG is enabled.

The debug trace in the atmel_usba_stop function made the assumption that the
driver pointer passed in parameter was not NULL, but since the commit above,
such assumption was no longer always true.

This commit now uses the driver pointer stored in udc which fixes this
issue.

[ balbi@ti.com : improved commit log a bit ]

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/atmel_usba_udc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 1d97222..f94e68f 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1820,12 +1820,12 @@ static int atmel_usba_stop(struct usb_gadget *gadget,
 	toggle_bias(0);
 	usba_writel(udc, CTRL, USBA_DISABLE_MASK);
 
-	udc->driver = NULL;
-
 	clk_disable(udc->hclk);
 	clk_disable(udc->pclk);
 
-	DBG(DBG_GADGET, "unregistered driver `%s'\n", driver->driver.name);
+	DBG(DBG_GADGET, "unregistered driver `%s'\n", udc->driver->driver.name);
+
+	udc->driver = NULL;
 
 	return 0;
 }
-- 
1.9.1

