Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbaJaRsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:48:33 -0400
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:50086 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757556AbaJaRsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:48:04 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] staging: comedi: split out USB support into new module
Date: Fri, 31 Oct 2014 17:47:38 +0000
Message-Id: <1414777659-25578-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
References: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the `CONFIG_COMEDI_USB_DRIVERS` kernel configuration option
makes the main "comedi" module depend on the "usbcore" module.  But
perhaps the machine has no USB controllers (or they have been disabled),
in which case the "usbcore" module may have been pulled in
unnecessarily.  Only a few low-level Comedi drivers require USB support.
The Comedi USB support functions are all in "comedi_usb.c".  Turn it
into a separate module so we don't have to pull in the "usbcore" and
"usb_common" modules unnecessarily.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/Kconfig      |  5 ++++-
 drivers/staging/comedi/Makefile     |  2 +-
 drivers/staging/comedi/comedi_usb.c | 16 ++++++++++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 2fa5a90..a38680d 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1155,11 +1155,14 @@ config COMEDI_QUATECH_DAQP_CS
 endif # COMEDI_PCMCIA_DRIVERS
 
 menuconfig COMEDI_USB_DRIVERS
-	bool "Comedi USB drivers"
+	tristate "Comedi USB drivers"
 	depends on USB
 	---help---
 	  Enable support for comedi USB drivers.
 
+	  To compile this support as a module, choose M here: the module will
+	  be called comedi_usb.
+
 if COMEDI_USB_DRIVERS
 
 config COMEDI_DT9812
diff --git a/drivers/staging/comedi/Makefile b/drivers/staging/comedi/Makefile
index cfb121a..e28eaeb 100644
--- a/drivers/staging/comedi/Makefile
+++ b/drivers/staging/comedi/Makefile
@@ -3,11 +3,11 @@ ccflags-$(CONFIG_COMEDI_DEBUG)		:= -DDEBUG
 comedi-y				:= comedi_fops.o range.o drivers.o \
 					   comedi_buf.o
 comedi-$(CONFIG_COMEDI_PCI_DRIVERS)	+= comedi_pci.o
-comedi-$(CONFIG_COMEDI_USB_DRIVERS)	+= comedi_usb.o
 comedi-$(CONFIG_PROC_FS)		+= proc.o
 comedi-$(CONFIG_COMPAT)			+= comedi_compat32.o
 
 obj-$(CONFIG_COMEDI_PCMCIA_DRIVERS)	+= comedi_pcmcia.o
+obj-$(CONFIG_COMEDI_USB_DRIVERS)	+= comedi_usb.o
 
 obj-$(CONFIG_COMEDI)			+= comedi.o
 
diff --git a/drivers/staging/comedi/comedi_usb.c b/drivers/staging/comedi/comedi_usb.c
index 13f18be..0b862a6 100644
--- a/drivers/staging/comedi/comedi_usb.c
+++ b/drivers/staging/comedi/comedi_usb.c
@@ -16,6 +16,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/module.h>
 #include <linux/usb.h>
 
 #include "comedidev.h"
@@ -114,3 +115,18 @@ void comedi_usb_driver_unregister(struct comedi_driver *comedi_driver,
 	comedi_driver_unregister(comedi_driver);
 }
 EXPORT_SYMBOL_GPL(comedi_usb_driver_unregister);
+
+static int __init comedi_usb_init(void)
+{
+	return 0;
+}
+module_init(comedi_usb_init);
+
+static void __exit comedi_usb_exit(void)
+{
+}
+module_exit(comedi_usb_exit);
+
+MODULE_AUTHOR("http://www.comedi.org");
+MODULE_DESCRIPTION("Comedi USB interface module");
+MODULE_LICENSE("GPL");
-- 
2.1.1

