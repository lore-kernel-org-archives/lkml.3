Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaD1Bcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42959 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        "Felipe Balbi" <balbi@ti.com>,
        "Gregory CLEMENT" <gregory.clement@free-electrons.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.981605371@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 36/94] usb: gadget: atmel_usba: fix crashed during
 stopping when DEBUG is enabled
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1875,12 +1875,13 @@ static int atmel_usba_stop(struct usb_ga
 
 	driver->unbind(&udc->gadget);
 	udc->gadget.dev.driver = NULL;
-	udc->driver = NULL;
 
 	clk_disable(udc->hclk);
 	clk_disable(udc->pclk);
 
-	DBG(DBG_GADGET, "unregistered driver `%s'\n", driver->driver.name);
+	DBG(DBG_GADGET, "unregistered driver `%s'\n", udc->driver->driver.name);
+
+	udc->driver = NULL;
 
 	return 0;
 }

