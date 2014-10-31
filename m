Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbaJaRsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:48:11 -0400
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:54393 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932348AbaJaRsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:48:05 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] staging: comedi: split out PCI support into new module
Date: Fri, 31 Oct 2014 17:47:39 +0000
Message-Id: <1414777659-25578-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
References: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the `CONFIG_COMEDI_PCI_DRIVERS` kernel configuration option
makes the main "comedi" module depend on the PCI support in the kernel.
That's not that big a deal since PCI support in the kernel is either
built into the kernel or is absent, and is not in a separate module.
Still, not all low-level Comedi drivers need PCI support, so we could
save a bit of space by not including it.  The Comedi PCI support
functions are all in "comedi_pci.c".  Turn it into a separate module so
the support code doesn't have to be loaded unnecessarily.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/Kconfig      |  5 ++++-
 drivers/staging/comedi/Makefile     |  2 +-
 drivers/staging/comedi/comedi_pci.c | 16 ++++++++++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index a38680d..2249b97 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -563,11 +563,14 @@ config COMEDI_S526
 endif # COMEDI_ISA_DRIVERS
 
 menuconfig COMEDI_PCI_DRIVERS
-	bool "Comedi PCI drivers"
+	tristate "Comedi PCI drivers"
 	depends on PCI
 	---help---
 	  Enable support for comedi PCI drivers.
 
+	  To compile this support as a module, choose M here: the module will
+	  be called comedi_pci.
+
 if COMEDI_PCI_DRIVERS
 
 config COMEDI_8255_PCI
diff --git a/drivers/staging/comedi/Makefile b/drivers/staging/comedi/Makefile
index e28eaeb..7f9dfb3 100644
--- a/drivers/staging/comedi/Makefile
+++ b/drivers/staging/comedi/Makefile
@@ -2,10 +2,10 @@ ccflags-$(CONFIG_COMEDI_DEBUG)		:= -DDEBUG
 
 comedi-y				:= comedi_fops.o range.o drivers.o \
 					   comedi_buf.o
-comedi-$(CONFIG_COMEDI_PCI_DRIVERS)	+= comedi_pci.o
 comedi-$(CONFIG_PROC_FS)		+= proc.o
 comedi-$(CONFIG_COMPAT)			+= comedi_compat32.o
 
+obj-$(CONFIG_COMEDI_PCI_DRIVERS)	+= comedi_pci.o
 obj-$(CONFIG_COMEDI_PCMCIA_DRIVERS)	+= comedi_pcmcia.o
 obj-$(CONFIG_COMEDI_USB_DRIVERS)	+= comedi_usb.o
 
diff --git a/drivers/staging/comedi/comedi_pci.c b/drivers/staging/comedi/comedi_pci.c
index aa0795a..6ba59c9 100644
--- a/drivers/staging/comedi/comedi_pci.c
+++ b/drivers/staging/comedi/comedi_pci.c
@@ -16,6 +16,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
@@ -168,3 +169,18 @@ void comedi_pci_driver_unregister(struct comedi_driver *comedi_driver,
 	comedi_driver_unregister(comedi_driver);
 }
 EXPORT_SYMBOL_GPL(comedi_pci_driver_unregister);
+
+static int __init comedi_pci_init(void)
+{
+	return 0;
+}
+module_init(comedi_pci_init);
+
+static void __exit comedi_pci_exit(void)
+{
+}
+module_exit(comedi_pci_exit);
+
+MODULE_AUTHOR("http://www.comedi.org");
+MODULE_DESCRIPTION("Comedi PCI interface module");
+MODULE_LICENSE("GPL");
-- 
2.1.1

