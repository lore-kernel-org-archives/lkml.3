Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbaEMJzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:55:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60850 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760087AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Felipe Balbi <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 081/182] usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is enabled
Date: Tue, 13 May 2014 11:27:13 +0200
Message-Id: <ce63b7fde868349453d21392a3af78541aefe424.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/gadget/atmel_usba_udc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 2cb52e0438df..1e53092e93c5 100644
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
1.9.3

