Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaDVU11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:27:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36781 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305AbaDVUZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:25:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 046/133] usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is enabled
Date: Tue, 22 Apr 2014 13:13:04 -0700
Message-Id: <1398197671-12786-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/gadget/atmel_usba_udc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index a7aed84..e3eb013 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1841,13 +1841,13 @@ static int atmel_usba_stop(struct usb_gadget *gadget,
 	toggle_bias(0);
 	usba_writel(udc, CTRL, USBA_DISABLE_MASK);
 
-	udc->gadget.dev.driver = NULL;
-	udc->driver = NULL;
-
 	clk_disable(udc->hclk);
 	clk_disable(udc->pclk);
 
-	DBG(DBG_GADGET, "unregistered driver `%s'\n", driver->driver.name);
+	DBG(DBG_GADGET, "unregistered driver `%s'\n", udc->driver->driver.name);
+
+	udc->gadget.dev.driver = NULL;
+	udc->driver = NULL;
 
 	return 0;
 }
-- 
1.9.1

