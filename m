Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3AQRdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:33:47 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55891 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3AQRdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:33:46 -0500
Subject: [PATCH 01/10] goldfish: platform device for x86
To: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
From: Alan Cox <alan@linux.intel.com>
Date: Thu, 17 Jan 2013 17:53:55 +0000
Message-ID: <20130117175338.24458.1896.stgit@bob.linux.org.uk>
In-Reply-To: <20130117175228.24458.5465.stgit@bob.linux.org.uk>
References: <20130117175228.24458.5465.stgit@bob.linux.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jun Nakajima <jnakajim@gmail.com>

Based on code by Jun Nakajima but stripped of all the old x86 mach-foo
stuff and turned into a single file for the Goldfish virtual bus layer.

The actual created platform device and bus enumeration is portable between the
ARM and x86 Goldfish emulations.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
Signed-off-by: Xiaohui Xin <xiaohui.xin@intel.com>
Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Bruce Beare <bruce.j.beare@intel.com>
[Ported to 3.7 and reorganised so that we can keep most of the code
 shared properly]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/Kconfig                      |   12 ++++++++
 arch/x86/platform/Makefile            |    1 +
 arch/x86/platform/goldfish/Makefile   |    1 +
 arch/x86/platform/goldfish/goldfish.c |   51 +++++++++++++++++++++++++++++++++
 4 files changed, 65 insertions(+)
 create mode 100644 arch/x86/platform/goldfish/Makefile
 create mode 100644 arch/x86/platform/goldfish/goldfish.c


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8c185d0..86859ec 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -322,6 +322,10 @@ config X86_BIGSMP
 	---help---
 	  This option is needed for the systems that have more than 8 CPUs
 
+config GOLDFISH
+       def_bool y
+       depends on X86_GOLDFISH
+
 if X86_32
 config X86_EXTENDED_PLATFORM
 	bool "Support for extended (non-PC) x86 platforms"
@@ -404,6 +408,14 @@ config X86_UV
 # Following is an alphabetically sorted list of 32 bit extended platforms
 # Please maintain the alphabetic order if and when there are additions
 
+config X86_GOLDFISH
+       bool "Goldfish (Virtual Platform)"
+       depends on X86_32
+       ---help---
+	 Enable support for the Goldfish virtual platform used primarily
+	 for Android development. Unless you are building for the Android
+	 Goldfish emulator say N here.
+
 config X86_INTEL_CE
 	bool "CE4100 TV platform"
 	depends on PCI
diff --git a/arch/x86/platform/Makefile b/arch/x86/platform/Makefile
index 8d87439..bfe917f 100644
--- a/arch/x86/platform/Makefile
+++ b/arch/x86/platform/Makefile
@@ -2,6 +2,7 @@
 obj-y	+= ce4100/
 obj-y	+= efi/
 obj-y	+= geode/
+obj-y	+= goldfish/
 obj-y	+= iris/
 obj-y	+= mrst/
 obj-y	+= olpc/
diff --git a/arch/x86/platform/goldfish/Makefile b/arch/x86/platform/goldfish/Makefile
new file mode 100644
index 0000000..f030b53
--- /dev/null
+++ b/arch/x86/platform/goldfish/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_GOLDFISH)	+= goldfish.o
diff --git a/arch/x86/platform/goldfish/goldfish.c b/arch/x86/platform/goldfish/goldfish.c
new file mode 100644
index 0000000..9eb156a
--- /dev/null
+++ b/arch/x86/platform/goldfish/goldfish.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (C) 2011 Intel, Inc.
+ * Copyright (C) 2013 Intel, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+
+/*
+ * Where in virtual memory the IO devices (timers, system controllers
+ * and so on)
+ */
+
+#define GOLDFISH_PDEV_BUS_BASE	(0xff001000)
+#define GOLDFISH_PDEV_BUS_END	(0xff7fffff)
+#define GOLDFISH_PDEV_BUS_IRQ	(4)
+
+#define GOLDFISH_TTY_BASE	(0x2000)
+
+static struct resource goldfish_pdev_bus_resources[] = {
+	{
+		.start  = GOLDFISH_PDEV_BUS_BASE,
+		.end    = GOLDFISH_PDEV_BUS_END,
+		.flags  = IORESOURCE_MEM,
+	},
+	{
+		.start	= GOLDFISH_PDEV_BUS_IRQ,
+		.end	= GOLDFISH_PDEV_BUS_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static int __init goldfish_init(void)
+{
+	platform_device_register_simple("goldfish_pdev_bus", -1,
+						goldfish_pdev_bus_resources, 2);
+	return 0;
+}
+device_initcall(goldfish_init);

