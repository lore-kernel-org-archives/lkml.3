Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab3AURRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:17:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50594 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab3AURRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:17:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
Date: Mon, 21 Jan 2013 17:16:06 +0000
Message-Id: <1358788568-11137-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:9WrQoPHRZqF9O3o5wwvPro6sz3mDwUg5W7xDkwAKbEi
 HwOmQNn2WgPzROPuvv6TSCE/uHI2ZpZ1LZshEsX/T12M9NZgDl
 XaIOIcvrffc6PqUUMIXn0HFLLNxo/T0gnskZXEoRQcIdG4gD3f
 6nMkTaiuu1ThNTGkG/I09dWAjDWPCWPdoHhlT3YOhWHa78pIRp
 Q2+pyB5epWXsMzjw9oDggQCQXyJ+5FJsYGChEbr1q1r5fjgig7
 wwNscENFCV1EY2QI8KTwMXrjQE3G+8PC3jCiThhzKzDwOdYSrm
 Rokw0o96MIZ7IqV/XqfpqNnxLACrPMNLkvelqkp4X3CseJ+Hs2
 s3KJwcY+M2DWvgHqSnI+g+aBAGkA1+LAgOZqDAv1M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In linux-3.8-rc1 it became possible to build the imx and
mvebu platforms together in a single kernel, which clashes
in the ehci driver.

Manjunath Goudar is already working on a patch to convert
both the imx and the mvebu glue drivers (along with all
the other ARM specific ones) to the new probing method,
but that will be too late to fix v3.8. This patch instead
adds yet another hack like the existing ones to allow
the ehci driver to load both back-ends.

Without this patch, building allyesconfig results in:

drivers/usb/host/ehci-hcd.c:1285:0: error: "PLATFORM_DRIVER" redefined
drivers/usb/host/ehci-hcd.c:1255:0: note: this is the location of the previous definition
In file included from drivers/usb/host/ehci-hcd.c:1254:0:
drivers/usb/host/ehci-mxc.c:280:31: warning: 'ehci_mxc_driver' defined but not used

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
---
 drivers/usb/host/ehci-hcd.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index c97503b..92e7180 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1282,7 +1282,7 @@ MODULE_LICENSE ("GPL");
 
 #ifdef CONFIG_PLAT_ORION
 #include "ehci-orion.c"
-#define	PLATFORM_DRIVER		ehci_orion_driver
+#define	ORION_PLATFORM_DRIVER		ehci_orion_driver
 #endif
 
 #ifdef CONFIG_USB_W90X900_EHCI
@@ -1353,6 +1353,7 @@ MODULE_LICENSE ("GPL");
 #if !IS_ENABLED(CONFIG_USB_EHCI_PCI) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_PLATFORM) && \
 	!defined(CONFIG_USB_CHIPIDEA_HOST) && \
+	!defined(ORION_PLATFORM_DRIVER) && \
 	!defined(PLATFORM_DRIVER) && \
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
 	!defined(OF_PLATFORM_DRIVER) && \
@@ -1393,6 +1394,12 @@ static int __init ehci_hcd_init(void)
 		goto clean0;
 #endif
 
+#ifdef ORION_PLATFORM_DRIVER
+	retval = platform_driver_register(&ORION_PLATFORM_DRIVER);
+	if (retval < 0)
+		goto clean1;
+#endif
+
 #ifdef PS3_SYSTEM_BUS_DRIVER
 	retval = ps3_ehci_driver_register(&PS3_SYSTEM_BUS_DRIVER);
 	if (retval < 0)
@@ -1424,6 +1431,10 @@ clean3:
 	ps3_ehci_driver_unregister(&PS3_SYSTEM_BUS_DRIVER);
 clean2:
 #endif
+#ifdef ORION_PLATFORM_DRIVER
+	platform_driver_unregister(&ORION_PLATFORM_DRIVER);
+clean1:
+#endif
 #ifdef PLATFORM_DRIVER
 	platform_driver_unregister(&PLATFORM_DRIVER);
 clean0:
@@ -1446,6 +1457,9 @@ static void __exit ehci_hcd_cleanup(void)
 #ifdef OF_PLATFORM_DRIVER
 	platform_driver_unregister(&OF_PLATFORM_DRIVER);
 #endif
+#ifdef ORION_PLATFORM_DRIVER
+	platform_driver_unregister(&ORION_PLATFORM_DRIVER);
+#endif
 #ifdef PLATFORM_DRIVER
 	platform_driver_unregister(&PLATFORM_DRIVER);
 #endif
-- 
1.7.10.4

