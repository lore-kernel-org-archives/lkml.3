Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3I1R4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:56:44 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:45731 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3I1R4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:56:41 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH] USB: OHCI: Check the overrides pointer for NULL in ohci_init_driver()
Date: Sat, 28 Sep 2013 19:56:29 +0200
Message-Id: <1380390989-4740-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A series of commit starting at

50a97e059b USB: OHCI: make ohci-exynos a separate driver

and ending at

b8ad5c3706 USB: OHCI: make ohci-pxa27x a separate driver

introduced the concept of separate OHCI drivers for particular
controllers. Respective drivers need to call ohci_init_driver() to
initialize hc_driver struct with generic data and to certain extent
with platform specific overrides through ohci_driver_overrides struct
passed as second argument to this function. However the code does not
check if the ohci_driver_overrides struct pointer is non-NULL, which
leads for a NULL pointer dereference for drivers that do not need any
overrides.

This patch fixes the problem by dereferencing the passed pointer to
ohci_driver_overrides struct only if it is non-NULL.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/usb/host/ohci-hcd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 21d937a..8ada13f 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1161,10 +1161,12 @@ void ohci_init_driver(struct hc_driver *drv,
 	/* Copy the generic table to drv and then apply the overrides */
 	*drv = ohci_hc_driver;
 
-	drv->product_desc = over->product_desc;
-	drv->hcd_priv_size += over->extra_priv_size;
-	if (over->reset)
-		drv->reset = over->reset;
+	if (over) {
+		drv->product_desc = over->product_desc;
+		drv->hcd_priv_size += over->extra_priv_size;
+		if (over->reset)
+			drv->reset = over->reset;
+	}
 }
 EXPORT_SYMBOL_GPL(ohci_init_driver);
 
-- 
1.8.3.2

