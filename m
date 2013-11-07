Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3KGW2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:28:48 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57032 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab3KGW2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:28:40 -0500
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        platform-driver-x86@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH] platform: add chrome platform directory
Date: Thu,  7 Nov 2013 14:25:45 -0800
Message-Id: <1383863145-8826-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes sense to split out the Chromebook/Chromebox hardware platform
drivers to a separate subdirectory, since some of it will be shared
between ARM and x86.

This moves over the existing chromeos_laptop driver without making
any other changes, and adds appropriate Kconfig entries for the new
directory. It also adds a MAINTAINERS entry for the new subdir.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 MAINTAINERS                                        |  5 ++++
 drivers/platform/Kconfig                           |  1 +
 drivers/platform/Makefile                          |  1 +
 drivers/platform/chrome/Kconfig                    | 28 ++++++++++++++++++++++
 drivers/platform/chrome/Makefile                   |  2 ++
 drivers/platform/{x86 => chrome}/chromeos_laptop.c |  0
 drivers/platform/x86/Kconfig                       | 11 ---------
 drivers/platform/x86/Makefile                      |  1 -
 8 files changed, 37 insertions(+), 12 deletions(-)
 create mode 100644 drivers/platform/chrome/Kconfig
 create mode 100644 drivers/platform/chrome/Makefile
 rename drivers/platform/{x86 => chrome}/chromeos_laptop.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 831b8690cf13..07e312a3377b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2129,6 +2129,11 @@ L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/chipidea/
 
+CHROME HARDWARE PLATFORM SUPPORT
+M:	Olof Johansson <olof@lixom.net>
+S:	Maintained
+F:	drivers/platform/chrome/
+
 CISCO VIC ETHERNET NIC DRIVER
 M:	Christian Benvenuti <benve@cisco.com>
 M:	Sujith Sankar <ssujith@cisco.com>
diff --git a/drivers/platform/Kconfig b/drivers/platform/Kconfig
index 69616aeaa966..09fde58b12e0 100644
--- a/drivers/platform/Kconfig
+++ b/drivers/platform/Kconfig
@@ -5,3 +5,4 @@ if GOLDFISH
 source "drivers/platform/goldfish/Kconfig"
 endif
 
+source "drivers/platform/chrome/Kconfig"
diff --git a/drivers/platform/Makefile b/drivers/platform/Makefile
index 8a44a4cd6d1e..3656b7b17b99 100644
--- a/drivers/platform/Makefile
+++ b/drivers/platform/Makefile
@@ -5,3 +5,4 @@
 obj-$(CONFIG_X86)		+= x86/
 obj-$(CONFIG_OLPC)		+= olpc/
 obj-$(CONFIG_GOLDFISH)		+= goldfish/
+obj-$(CONFIG_CHROME_PLATFORMS)	+= chrome/
diff --git a/drivers/platform/chrome/Kconfig b/drivers/platform/chrome/Kconfig
new file mode 100644
index 000000000000..b13303e75a34
--- /dev/null
+++ b/drivers/platform/chrome/Kconfig
@@ -0,0 +1,28 @@
+#
+# Platform support for Chrome OS hardware (Chromebooks and Chromeboxes)
+#
+
+menuconfig CHROME_PLATFORMS
+	bool "Platform support for Chrome hardware"
+	depends on X86
+	---help---
+	  Say Y here to get to see options for platform support for
+	  various Chromebooks and Chromeboxes. This option alone does
+	  not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if CHROME_PLATFORMS
+
+config CHROMEOS_LAPTOP
+	tristate "Chrome OS Laptop"
+	depends on I2C
+	depends on DMI
+	---help---
+	  This driver instantiates i2c and smbus devices such as
+	  light sensors and touchpads.
+
+	  If you have a supported Chromebook, choose Y or M here.
+	  The module will be called chromeos_laptop.
+
+endif # CHROMEOS_PLATFORMS
diff --git a/drivers/platform/chrome/Makefile b/drivers/platform/chrome/Makefile
new file mode 100644
index 000000000000..015e9195e226
--- /dev/null
+++ b/drivers/platform/chrome/Makefile
@@ -0,0 +1,2 @@
+
+obj-$(CONFIG_CHROMEOS_LAPTOP)	+= chromeos_laptop.o
diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
similarity index 100%
rename from drivers/platform/x86/chromeos_laptop.c
rename to drivers/platform/chrome/chromeos_laptop.c
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index b51a7460cc49..d9dcd37b5a52 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -79,17 +79,6 @@ config ASUS_LAPTOP
 
 	  If you have an ACPI-compatible ASUS laptop, say Y or M here.
 
-config CHROMEOS_LAPTOP
-	tristate "Chrome OS Laptop"
-	depends on I2C
-	depends on DMI
-	---help---
-	  This driver instantiates i2c and smbus devices such as
-	  light sensors and touchpads.
-
-	  If you have a supported Chromebook, choose Y or M here.
-	  The module will be called chromeos_laptop.
-
 config DELL_LAPTOP
 	tristate "Dell Laptop Extras"
 	depends on X86
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 5dbe19324351..f0e6aa407ffb 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -50,7 +50,6 @@ obj-$(CONFIG_INTEL_MID_POWER_BUTTON)	+= intel_mid_powerbtn.o
 obj-$(CONFIG_INTEL_OAKTRAIL)	+= intel_oaktrail.o
 obj-$(CONFIG_SAMSUNG_Q10)	+= samsung-q10.o
 obj-$(CONFIG_APPLE_GMUX)	+= apple-gmux.o
-obj-$(CONFIG_CHROMEOS_LAPTOP)	+= chromeos_laptop.o
 obj-$(CONFIG_INTEL_RST)		+= intel-rst.o
 obj-$(CONFIG_INTEL_SMARTCONNECT)	+= intel-smartconnect.o
 
-- 
1.8.4.1.601.g02b3b1d

