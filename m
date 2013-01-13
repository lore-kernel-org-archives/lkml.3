Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3AMCIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 21:08:42 -0500
Received: from mout.gmx.net ([212.227.15.18]:62384 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab3AMCIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 21:08:41 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX186DbcUcio6eV/Hzcn/Q/c/OfNGMr6anqTylJY6vy
	4IBoFDQFatgjs/
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] staging/comedi: Add macro for registering a comedi PCMCIA driver
Date: Sun, 13 Jan 2013 03:11:06 +0100
Message-Id: <1358043073-12328-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new macro 'module_comedi_pcmcia_driver'
for comedi PCMCIA drivers which do not do anything special in module
init/exit. This eliminates a lot of boilerplate.

Adapted from 'module_comedi_pci_driver'

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/comedidev.h |   22 ++++++++++++++++++++++
 drivers/staging/comedi/drivers.c   |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 692e1e6..ccb22dd 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -41,6 +41,9 @@
 #include <linux/io.h>
 #include <linux/timer.h>
 #include <linux/pci.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/cisreg.h>
+#include <pcmcia/ds.h>
 #include <linux/usb.h>
 
 #include "comedi.h"
@@ -342,6 +345,25 @@ void comedi_pci_driver_unregister(struct comedi_driver *, struct pci_driver *);
 	module_driver(__comedi_driver, comedi_pci_driver_register, \
 			comedi_pci_driver_unregister, &(__pci_driver))
 
+int comedi_pcmcia_driver_register(struct comedi_driver *,
+					struct pcmcia_driver *);
+void comedi_pcmcia_driver_unregister(struct comedi_driver *,
+					struct pcmcia_driver *);
+
+/**
+ * module_comedi_pcmcia_driver() - Helper macro for registering a comedi PCMCIA driver
+ * @__comedi_driver: comedi_driver struct
+ * @__pcmcia_driver: pcmcia_driver struct
+ *
+ * Helper macro for comedi PCMCIA drivers which do not do anything special
+ * in module init/exit. This eliminates a lot of boilerplate. Each
+ * module may only use this macro once, and calling it replaces
+ * module_init() and module_exit()
+ */
+#define module_comedi_pcmcia_driver(__comedi_driver, __pcmcia_driver) \
+	module_driver(__comedi_driver, comedi_pcmcia_driver_register, \
+			comedi_pcmcia_driver_unregister, &(__pcmcia_driver))
+
 struct usb_driver;
 
 int comedi_usb_driver_register(struct comedi_driver *, struct usb_driver *);
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 50cf498..17a9e35 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -24,6 +24,9 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/cisreg.h>
+#include <pcmcia/ds.h>
 #include <linux/usb.h>
 #include <linux/errno.h>
 #include <linux/kconfig.h>
@@ -958,6 +961,37 @@ void comedi_pci_driver_unregister(struct comedi_driver *comedi_driver,
 }
 EXPORT_SYMBOL_GPL(comedi_pci_driver_unregister);
 
+int comedi_pcmcia_driver_register(struct comedi_driver *comedi_driver,
+		struct pcmcia_driver *pcmcia_driver)
+{
+	int ret;
+
+	ret = comedi_driver_register(comedi_driver);
+	if (ret < 0)
+		return ret;
+
+	/* FIXME: Remove this test after auditing all comedi pci drivers */
+	if (!pcmcia_driver->name)
+		pcmcia_driver->name = comedi_driver->driver_name;
+
+	ret = pcmcia_register_driver(pcmcia_driver);
+	if (ret < 0) {
+		comedi_driver_unregister(comedi_driver);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(comedi_pcmcia_driver_register);
+
+void comedi_pcmcia_driver_unregister(struct comedi_driver *comedi_driver,
+		struct pcmcia_driver *pcmcia_driver)
+{
+	pcmcia_unregister_driver(pcmcia_driver);
+	comedi_driver_unregister(comedi_driver);
+}
+EXPORT_SYMBOL_GPL(comedi_pcmcia_driver_unregister);
+
 #if IS_ENABLED(CONFIG_USB)
 
 int comedi_usb_driver_register(struct comedi_driver *comedi_driver,
-- 
1.7.8.6

