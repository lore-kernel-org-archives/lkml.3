Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaEVIwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:52:14 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60700 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaEVIwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:52:11 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, horms@verge.net.au, geert@linux-m68k.org,
        laurent.pinchart@ideasonboard.com, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Thu, 22 May 2014 17:54:09 +0900
Message-Id: <20140522085409.26279.64965.sendpatchset@w520>
In-Reply-To: <20140522085339.26279.83340.sendpatchset@w520>
References: <20140522085339.26279.83340.sendpatchset@w520>
Subject: [PATCH 03/03] staging: board: kzm9d: Board staging support for emxx_udc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm+renesas@opensource.se>

Add staging board support for the KZM9D board and add
an emxx_udc platform device to allow in-tree continous 
development of the driver on the KZM9D board.

When DT bindings are ready for the emxx_udc driver then
the platform device in the KZM9D staging board code can
easily be removed. Until then we use platform devices
to continously improve the driver and integration code.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 drivers/staging/Kconfig        |    2 ++
 drivers/staging/Makefile       |    1 +
 drivers/staging/board/Kconfig  |    7 +++++++
 drivers/staging/board/Makefile |    1 +
 drivers/staging/board/board.h  |   17 +++++++++++++++++
 drivers/staging/board/kzm9d.c  |   18 ++++++++++++++++++
 6 files changed, 46 insertions(+)

--- 0002/drivers/staging/Kconfig
+++ work/drivers/staging/Kconfig	2014-05-22 15:31:57.000000000 +0900
@@ -112,6 +112,8 @@ source "drivers/staging/media/Kconfig"
 
 source "drivers/staging/android/Kconfig"
 
+source "drivers/staging/board/Kconfig"
+
 source "drivers/staging/ozwpan/Kconfig"
 
 source "drivers/staging/gdm72xx/Kconfig"
--- 0002/drivers/staging/Makefile
+++ work/drivers/staging/Makefile	2014-05-22 15:31:57.000000000 +0900
@@ -49,6 +49,7 @@ obj-$(CONFIG_TOUCHSCREEN_CLEARPAD_TM1217
 obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4)	+= ste_rmi4/
 obj-$(CONFIG_MFD_NVEC)		+= nvec/
 obj-$(CONFIG_ANDROID)		+= android/
+obj-$(CONFIG_STAGING_BOARD)	+= board/
 obj-$(CONFIG_USB_WPAN_HCD)	+= ozwpan/
 obj-$(CONFIG_WIMAX_GDM72XX)	+= gdm72xx/
 obj-$(CONFIG_LTE_GDM724X)	+= gdm724x/
--- /dev/null
+++ work/drivers/staging/board/Kconfig	2014-05-22 15:31:58.000000000 +0900
@@ -0,0 +1,7 @@
+config STAGING_BOARD
+	boolean "Staging Board Support"
+	help
+	  Select to enable per-board staging support code.
+
+	  If in doubt, say N here.
+
--- /dev/null
+++ work/drivers/staging/board/Makefile	2014-05-22 15:31:58.000000000 +0900
@@ -0,0 +1 @@
+obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= kzm9d.o
--- /dev/null
+++ work/drivers/staging/board/board.h	2014-05-22 15:31:58.000000000 +0900
@@ -0,0 +1,17 @@
+#ifndef __BOARD_H__
+#define __BOARD_H__
+#include <linux/init.h>
+#include <linux/of.h>
+
+#define board_staging(str, fn)			\
+static int __init runtime_board_check(void)	\
+{						\
+	if (of_machine_is_compatible(str))	\
+		fn();				\
+						\
+	return 0;				\
+}						\
+						\
+late_initcall(runtime_board_check)
+
+#endif /* __BOARD_H__ */
--- /dev/null
+++ work/drivers/staging/board/kzm9d.c	2014-05-22 16:19:00.000000000 +0900
@@ -0,0 +1,18 @@
+/* Staging board support for KZM9D. Enable not-yet-DT-capable devices here. */
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include "board.h"
+
+static const struct resource usbs1_resources[] __initconst = {
+	DEFINE_RES_MEM(0xe2800000, 0x2000),
+	DEFINE_RES_IRQ(159),
+};
+
+static void __init kzm9d_init(void)
+{
+	platform_device_register_simple("emxx_udc", -1, usbs1_resources,
+					ARRAY_SIZE(usbs1_resources));
+}
+
+board_staging("renesas,kzm9d", kzm9d_init);
