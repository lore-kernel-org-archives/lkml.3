Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbaEBQBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:01:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44119 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbaEBPon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:44:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 032/151] usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is enabled
Date: Fri,  2 May 2014 08:37:00 -0700
Message-Id: <1399045139-4531-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/gadget/atmel_usba_udc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 2cb52e0..1e53092 100644
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
1.9.1

