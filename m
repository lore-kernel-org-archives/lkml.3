Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbaJaRsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:48:52 -0400
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:54393 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757537AbaJaRsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:48:03 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] staging: comedi: split out PCMCIA support into new module
Date: Fri, 31 Oct 2014 17:47:37 +0000
Message-Id: <1414777659-25578-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
References: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the `CONFIG_COMEDI_PCMCIA_DRIVERS` kernel configuration option
makes the main "comedi" module depend on the "pcmcia" module, but many
machines don't have PCMCIA slots and only a few low-level Comedi drivers
need PCMCIA support.  The Comedi PCMCIA support functions are all in
"comedi_pcmcia.c".  Turn it into a separate module so we don't have to
pull in the other PCMCIA support modules unnecessarily.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/Kconfig         |  5 ++++-
 drivers/staging/comedi/Makefile        |  3 ++-
 drivers/staging/comedi/comedi_pcmcia.c | 16 ++++++++++++++++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index d4214c0..2fa5a90 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1076,11 +1076,14 @@ config COMEDI_NI_TIOCMD
 endif # COMEDI_PCI_DRIVERS
 
 menuconfig COMEDI_PCMCIA_DRIVERS
-	bool "Comedi PCMCIA drivers"
+	tristate "Comedi PCMCIA drivers"
 	depends on PCMCIA
 	---help---
 	  Enable support for comedi PCMCIA drivers.
 
+	  To compile this support as a module, choose M here: the module will
+	  be called comedi_pcmcia.
+
 if COMEDI_PCMCIA_DRIVERS
 
 config COMEDI_CB_DAS16_CS
diff --git a/drivers/staging/comedi/Makefile b/drivers/staging/comedi/Makefile
index fae2d90..cfb121a 100644
--- a/drivers/staging/comedi/Makefile
+++ b/drivers/staging/comedi/Makefile
@@ -3,11 +3,12 @@ ccflags-$(CONFIG_COMEDI_DEBUG)		:= -DDEBUG
 comedi-y				:= comedi_fops.o range.o drivers.o \
 					   comedi_buf.o
 comedi-$(CONFIG_COMEDI_PCI_DRIVERS)	+= comedi_pci.o
-comedi-$(CONFIG_COMEDI_PCMCIA_DRIVERS)	+= comedi_pcmcia.o
 comedi-$(CONFIG_COMEDI_USB_DRIVERS)	+= comedi_usb.o
 comedi-$(CONFIG_PROC_FS)		+= proc.o
 comedi-$(CONFIG_COMPAT)			+= comedi_compat32.o
 
+obj-$(CONFIG_COMEDI_PCMCIA_DRIVERS)	+= comedi_pcmcia.o
+
 obj-$(CONFIG_COMEDI)			+= comedi.o
 
 obj-$(CONFIG_COMEDI)			+= kcomedilib/
diff --git a/drivers/staging/comedi/comedi_pcmcia.c b/drivers/staging/comedi/comedi_pcmcia.c
index 9d49d5d..0529bae 100644
--- a/drivers/staging/comedi/comedi_pcmcia.c
+++ b/drivers/staging/comedi/comedi_pcmcia.c
@@ -16,6 +16,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/module.h>
 #include <linux/kernel.h>
 
 #include <pcmcia/cistpl.h>
@@ -154,3 +155,18 @@ void comedi_pcmcia_driver_unregister(struct comedi_driver *comedi_driver,
 	comedi_driver_unregister(comedi_driver);
 }
 EXPORT_SYMBOL_GPL(comedi_pcmcia_driver_unregister);
+
+static int __init comedi_pcmcia_init(void)
+{
+	return 0;
+}
+module_init(comedi_pcmcia_init);
+
+static void __exit comedi_pcmcia_exit(void)
+{
+}
+module_exit(comedi_pcmcia_exit);
+
+MODULE_AUTHOR("http://www.comedi.org");
+MODULE_DESCRIPTION("Comedi PCMCIA interface module");
+MODULE_LICENSE("GPL");
-- 
2.1.1

