Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaJWLN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:13:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbaJWLNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:13:09 -0400
Message-Id: <20141023111307.521124558@ett.arch.suse.de>
User-Agent: quilt/0.48-16.4
Date: Thu, 23 Oct 2014 13:09:26 +0200
From: trenn@suse.de
To: minyard@acm.org
Cc: martin.wilck@ts.fujitsu.com, trenn@suse.de, linux-kernel@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [patch 2/3] ipmi: Setup ipmi_devintf automatically if ipmi_msghandler gets loaded
References: <20141023110924.936986783@ett.arch.suse.de>
Content-Disposition: inline; filename=ipmi_load_all
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the ipmi_devintf to be a module, but it will automatically
be compiled into ipmi_msghandler module if IPMI_HANDLER is set.

This will allow userspace IPMI support via autoloading.
There already was a kind of autoloading mechanism (gets deleted
with this patch):
-MODULE_ALIAS("platform:ipmi_si");
But:
  - It's wrong: There are other low lever drivers which can be used by
    ipmi_devintf
  - It does not work
  - There is no need to keep ipmi_devintf as a module (resource and load time
    overhead)

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: minyard@acm.org
CC: martin.wilck@ts.fujitsu.com

Index: kernel_ipmi/drivers/char/ipmi/Kconfig
===================================================================
--- kernel_ipmi.orig/drivers/char/ipmi/Kconfig
+++ kernel_ipmi/drivers/char/ipmi/Kconfig
@@ -8,6 +8,8 @@ menuconfig IPMI_HANDLER
        help
          This enables the central IPMI message handler, required for IPMI
 	 to work.
+	 It also provides userspace interface /dev/ipmiX, so that userspace
+	 tools can query the BMC.
 
          IPMI is a standard for managing sensors (temperature,
          voltage, etc.) in a system.
@@ -37,12 +39,6 @@ config IPMI_PANIC_STRING
 	  You can fetch these events and use the sequence numbers to piece the
 	  string together.
 
-config IPMI_DEVICE_INTERFACE
-       tristate 'Device interface for IPMI'
-       help
-         This provides an IOCTL interface to the IPMI message handler so
-	 userland processes may use IPMI.  It supports poll() and select().
-
 config IPMI_SI
        tristate 'IPMI System Interface handler'
        help
Index: kernel_ipmi/drivers/char/ipmi/ipmi_devintf.c
===================================================================
--- kernel_ipmi.orig/drivers/char/ipmi/ipmi_devintf.c
+++ kernel_ipmi/drivers/char/ipmi/ipmi_devintf.c
@@ -928,7 +928,7 @@ static struct ipmi_smi_watcher smi_watch
 	.smi_gone = ipmi_smi_gone,
 };
 
-static int __init init_ipmi_devintf(void)
+int __init init_ipmi_devintf(void)
 {
 	int rv;
 
@@ -964,9 +964,8 @@ static int __init init_ipmi_devintf(void
 
 	return 0;
 }
-module_init(init_ipmi_devintf);
 
-static void __exit cleanup_ipmi(void)
+void cleanup_ipmi_dev(void)
 {
 	struct ipmi_reg_list *entry, *entry2;
 	mutex_lock(&reg_list_mutex);
@@ -980,9 +979,3 @@ static void __exit cleanup_ipmi(void)
 	ipmi_smi_watcher_unregister(&smi_watcher);
 	unregister_chrdev(ipmi_major, DEVICE_NAME);
 }
-module_exit(cleanup_ipmi);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Corey Minyard <minyard@mvista.com>");
-MODULE_DESCRIPTION("Linux device interface for the IPMI message handler.");
-MODULE_ALIAS("platform:ipmi_si");
Index: kernel_ipmi/drivers/char/ipmi/ipmi_handler.c
===================================================================
--- kernel_ipmi.orig/drivers/char/ipmi/ipmi_handler.c
+++ kernel_ipmi/drivers/char/ipmi/ipmi_handler.c
@@ -47,6 +47,8 @@
 #include <linux/rcupdate.h>
 #include <linux/interrupt.h>
 
+#include "ipmi_devintf.h"
+
 #define PFX "IPMI message handler: "
 
 #define IPMI_DRIVER_VERSION "39.2"
@@ -4560,13 +4562,24 @@ static int ipmi_init_msghandler(void)
 	return 0;
 }
 
+static void cleanup_ipmi(void);
+
 static int __init ipmi_init_msghandler_mod(void)
 {
-	ipmi_init_msghandler();
+	int ret;
+
+	ret = ipmi_init_msghandler();
+	if (ret)
+		return ret;
+	ret = init_ipmi_devintf();
+	if (ret) {
+		cleanup_ipmi();
+		return ret;
+	}
 	return 0;
 }
 
-static void __exit cleanup_ipmi(void)
+static void cleanup_ipmi(void)
 {
 	int count;
 
@@ -4605,6 +4618,7 @@ static void __exit cleanup_ipmi(void)
 	if (count != 0)
 		printk(KERN_WARNING PFX "recv message count %d at exit\n",
 		       count);
+	cleanup_ipmi_dev();
 }
 module_exit(cleanup_ipmi);
 
Index: kernel_ipmi/drivers/char/ipmi/Makefile
===================================================================
--- kernel_ipmi.orig/drivers/char/ipmi/Makefile
+++ kernel_ipmi/drivers/char/ipmi/Makefile
@@ -5,9 +5,8 @@
 ipmi_si-y := ipmi_si_intf.o ipmi_kcs_sm.o ipmi_smic_sm.o ipmi_bt_sm.o
 
 obj-$(CONFIG_IPMI_HANDLER) += ipmi_msghandler.o
-ipmi_msghandler-objs := ipmi_handler.o
+ipmi_msghandler-objs := ipmi_handler.o ipmi_devintf.o
 
-obj-$(CONFIG_IPMI_DEVICE_INTERFACE) += ipmi_devintf.o
 obj-$(CONFIG_IPMI_SI) += ipmi_si.o
 obj-$(CONFIG_IPMI_WATCHDOG) += ipmi_watchdog.o
 obj-$(CONFIG_IPMI_POWEROFF) += ipmi_poweroff.o
Index: kernel_ipmi/drivers/char/ipmi/ipmi_devintf.h
===================================================================
--- /dev/null
+++ kernel_ipmi/drivers/char/ipmi/ipmi_devintf.h
@@ -0,0 +1,38 @@
+/*
+ * ipmi_devintf.h
+ *
+ * Linux device interface header file for the IPMI message handler.
+ *
+ * Author: Thomas Renninger <trenn@suse.de>
+ * Copyright 2014 SuSE Linux GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License as published by the
+ *  Free Software Foundation; either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ *
+ *  THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ *  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
+ *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
+ *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
+ *  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+ *  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ *  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _IPMI_DEVINTF_H_
+#define _IPMI_DEVINTF_H_
+
+void cleanup_ipmi_dev(void);
+
+int init_ipmi_devintf(void);
+
+#endif /* _IPMI_DEVINTF_H_ */

