Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3FAUCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 16:02:33 -0400
Received: from mout.gmx.net ([212.227.17.21]:53560 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab3FAUC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 16:02:26 -0400
X-Authenticated: #25030245
X-Provags-ID: V01U2FsdGVkX18tYOBIJIwtqHjbpQkBaCZEfqeEdVyJ6b0KK2Yz+k
	d+dPzX8fdeKZAL
From: Hannes Weisbach <hannes_weisbach@gmx.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] lp: implement proper detach function for parport_driver lp 
Date: Sat, 1 Jun 2013 22:02:21 +0200
Message-Id: <2009349A-75FD-4D5F-8F25-F8FD78F1A5D8@gmx.net>
Cc: linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>
Mime-Version: 1.0 (Apple Message framework v1085)
X-Mailer: Apple Mail (2.1085)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Weisbach <hannes_weisbach@gmx.net>

The lp pardevice driver does not have a proper detach function. Consequently, parport_unregister_device() is not called when the underlying parport driver calls parport_remove_port(). As a result, the ref count of the parport driver's module does not go to zero and the driver module cannot be unloaded.
The attached patch unregisters all lp pardevices which are on the to-be-detached parport.

Signed-off-by: Hannes Weisbach <hannes_weisbach@gmx.net>
---
Granted, for normal parport drivers this is usually not an issue, because the device does not go away. However, I am currently writing a Linux device driver for a USB to parallel port converter [0] and therefore need proper detaching. Additionally, the wrong ref count keeps me from simply rmmod my driver and insmod a new version while developing and testing.

 drivers/char/lp.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 0913d79..57e6941 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -930,7 +930,17 @@ static void lp_attach (struct parport *port)
 
 static void lp_detach (struct parport *port)
 {
-	/* Write this some day. */
+	int offset;
+
+	for (offset = 0; offset < LP_NO; offset++) {
+		if (lp_table[offset].dev == NULL)
+			continue;
+		if (lp_table[offset].dev->port == port) {
+			device_destroy(lp_class, MKDEV(LP_MAJOR, offset));
+			parport_unregister_device(lp_table[offset].dev);
+		}
+	}
+
 #ifdef CONFIG_LP_CONSOLE
 	if (console_registered == port) {
 		unregister_console(&lpcons);

