Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3HPP2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:28:40 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:38529 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3HPP2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:28:02 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 2/2] usb: gadget: ffs: add ACM + FunctionFS configuration
Date: Fri, 16 Aug 2013 11:27:48 -0400
Message-Id: <1376666868-32581-3-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376666868-32581-1-git-send-email-matt.porter@linaro.org>
References: <1376666868-32581-1-git-send-email-matt.porter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds an additional configuration to g_ffs to allow for
CDC ACM support in conjuction with FunctionFS. A module
parameter is added to allow for multiple ACM ports to
be instantiated.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
---
 drivers/usb/gadget/Kconfig |    9 ++++++
 drivers/usb/gadget/g_ffs.c |   71 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 1292a82..fa3c845 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -882,6 +882,15 @@ config USB_FUNCTIONFS_RNDIS
 	help
 	  Include a configuration with RNDIS function (Ethernet) and the Filesystem.
 
+config USB_FUNCTIONFS_ACM
+	bool "Include configuration with CDC ACM (Serial)"
+	depends on USB_FUNCTIONFS
+	select USB_U_SERIAL
+	select USB_F_ACM
+	help
+	  Include a configuration with CDC ACM function (Serial) and the
+	  Function Filesystem.
+
 config USB_FUNCTIONFS_GENERIC
 	bool "Include 'pure' configuration"
 	depends on USB_FUNCTIONFS
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index 686b776..0849d3c 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -53,6 +53,14 @@ USB_ETHERNET_MODULE_PARAMETERS();
 struct eth_dev;
 #endif
 
+static int acm_ports = 1;
+#ifdef CONFIG_USB_FUNCTIONFS_ACM
+#  include "u_serial.h"
+static int acm_bind_config(struct usb_configuration *c, int ports);
+module_param(acm_ports, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(acm_ports, "Number of ACM serial ports to instantiate");
+#endif
+
 #include "f_fs.c"
 
 #define DRIVER_NAME	"g_ffs"
@@ -127,6 +135,9 @@ static struct usb_string gfs_strings[] = {
 #ifdef CONFIG_USB_FUNCTIONFS_ETH
 	{ .s = "FunctionFS + ECM" },
 #endif
+#ifdef CONFIG_USB_FUNCTIONFS_ACM
+	{ .s = "FunctionFS + ACM" },
+#endif
 #ifdef CONFIG_USB_FUNCTIONFS_GENERIC
 	{ .s = "FunctionFS" },
 #endif
@@ -145,6 +156,7 @@ struct gfs_configuration {
 	struct usb_configuration c;
 	int (*eth)(struct usb_configuration *c, u8 *ethaddr,
 			struct eth_dev *dev);
+	int (*acm)(struct usb_configuration *c, int ports);
 } gfs_configurations[] = {
 #ifdef CONFIG_USB_FUNCTIONFS_RNDIS
 	{
@@ -158,6 +170,12 @@ struct gfs_configuration {
 	},
 #endif
 
+#ifdef CONFIG_USB_FUNCTIONFS_ACM
+	{
+		.acm		= acm_bind_config,
+	},
+#endif
+
 #ifdef CONFIG_USB_FUNCTIONFS_GENERIC
 	{
 	},
@@ -456,6 +474,12 @@ static int gfs_do_config(struct usb_configuration *c)
 			return ret;
 	}
 
+	if (gc->acm) {
+		ret = gc->acm(c, acm_ports);
+		if (unlikely(ret < 0))
+			return ret;
+	}
+
 	for (i = 0; i < func_num; i++) {
 		ret = functionfs_bind_config(c->cdev, c, ffs_tab[i].ffs_data);
 		if (unlikely(ret < 0))
@@ -489,3 +513,50 @@ static int eth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN],
 }
 
 #endif
+
+#ifdef CONFIG_USB_FUNCTIONFS_ACM
+
+static struct usb_function_instance *fi[MAX_U_SERIAL_PORTS];
+static struct usb_function *f[MAX_U_SERIAL_PORTS];
+
+static int acm_bind_config(struct usb_configuration *c, int ports)
+{
+	int i, ret;
+
+	for (i = 0; i < ports; i++) {
+		fi[i] = usb_get_function_instance("acm");
+		if (IS_ERR(fi[i])) {
+			ret = PTR_ERR(fi[i]);
+			goto err_get_fi;
+		}
+
+		f[i] = usb_get_function(fi[i]);
+		if (IS_ERR(f[i])) {
+			ret = PTR_ERR(f[i]);
+			goto err_get_f;
+		}
+
+		ret = usb_add_function(c, f[i]);
+		if (ret)
+			goto err_add_f;
+	}
+
+	return 0;
+
+err_add_f:
+	usb_put_function(f[i]);
+err_get_f:
+	usb_put_function_instance(fi[i]);
+err_get_fi:
+	i--;
+	while (i >= 0) {
+		usb_remove_function(c, f[i]);
+		usb_put_function(f[i]);
+		usb_put_function_instance(fi[i]);
+		i--;
+	}
+
+	return ret;
+}
+
+#endif
-- 
1.7.9.5

