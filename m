Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3KVXhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:37:35 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60145 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab3KVXhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:37:33 -0500
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 4/4] ACPI: Add support to force header inclusion rules for <linux/acpi.h>.
Date: Sat, 23 Nov 2013 07:37:04 +0800
Message-Id: <2930f1fabbb8319c11180c8db3d1693adc71aac1.1385163359.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1385094640.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

As there is only CONFIG_ACPI=n processing in the <linux/acpi.h>, it is not
safe to include <acpi/acpi.h>, <acpi/acpi_drivers.h> and <acpi/acpi_bus.h>
directly for source out of Linux ACPI subsystems.

This patch adds error messaging to warn developers of such wrong
inclusions.

In order not to be bisected and reverted as a wrong commit, warning
messages are carefully split into a seperate patch other than the wrong
inclusion cleanups.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/Makefile    |    2 +-
 include/acpi/acpi_bus.h         |    5 +++++
 include/acpi/acpi_drivers.h     |    5 +++++
 include/acpi/platform/aclinux.h |   10 ++++++++++
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index 4383040..7738677 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -2,7 +2,7 @@
 # Makefile for ACPICA Core interpreter
 #
 
-ccflags-y			:= -Os
+ccflags-y			:= -Os -DLINUXIZED_ACPICA
 ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
 
 # use acpi.o to put all files here into acpi.o modparam namespace
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 0af9667..0b1ea80 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -26,6 +26,11 @@
 #ifndef __ACPI_BUS_H__
 #define __ACPI_BUS_H__
 
+/* <acpi/acpi_bus.h> is not safe for CONFIG_ACPI=n environment */
+#ifndef _LINUX_ACPI_H
+#error "Please don't include <acpi/acpi_bus.h> direclty, including <linux/acpi.h> instead."
+#endif
+
 #include <linux/device.h>
 
 
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index f3f1219..f5bed3a 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -26,6 +26,11 @@
 #ifndef __ACPI_DRIVERS_H__
 #define __ACPI_DRIVERS_H__
 
+/* <acpi/acpi_drivers.h> is not safe for CONFIG_ACPI=n environment */
+#ifndef _LINUX_ACPI_H
+#error "Please don't include <acpi/acpi_drivers.h> directly, including <linux/acpi.h> instead."
+#endif
+
 
 #define ACPI_MAX_STRING			80
 
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 28f4f4d..0e05771 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -44,6 +44,16 @@
 #ifndef __ACLINUX_H__
 #define __ACLINUX_H__
 
+#ifdef __KERNEL__
+
+/* ACPICA external files should not include ACPICA headers directly. */
+
+#if !defined(LINUXIZED_ACPICA) && !defined(_LINUX_ACPI_H)
+#error "Please don't include <acpi/acpi.h> directly, including <linux/acpi.h> instead."
+#endif
+
+#endif
+
 /* Common (in-kernel/user-space) ACPICA configuration */
 
 #define ACPI_USE_SYSTEM_CLIBRARY
-- 
1.7.10

