Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab3AUVRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:17:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3AUVRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:08 -0500
Date: Mon, 21 Jan 2013 13:16:39 -0800
From: tip-bot for Jun Nakajima <jnakajim@gmail.com>
Message-ID: <tip-ddd70cf93d784af3698c86315aa0ded87ca0a0c5@git.kernel.org>
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, bruce.j.beare@intel.com, mjg59@srcf.ucam.org,
        yunhong.jiang@intel.com, xiaohui.xin@intel.com, tglx@linutronix.de,
        sheng@linux.intel.com, hpa@linux.intel.com, jnakajim@gmail.com,
        jun.nakajima@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, bruce.j.beare@intel.com, mjg59@srcf.ucam.org,
        yunhong.jiang@intel.com, xiaohui.xin@intel.com, sheng@linux.intel.com,
        tglx@linutronix.de, jnakajim@gmail.com, hpa@linux.intel.com,
        jun.nakajima@intel.com
In-Reply-To: <20130121172205.19517.22535.stgit@bob.linux.org.uk>
References: <20130121172205.19517.22535.stgit@bob.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] goldfish: platform device for x86
Git-Commit-ID: ddd70cf93d784af3698c86315aa0ded87ca0a0c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 21 Jan 2013 13:16:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddd70cf93d784af3698c86315aa0ded87ca0a0c5
Gitweb:     http://git.kernel.org/tip/ddd70cf93d784af3698c86315aa0ded87ca0a0c5
Author:     Jun Nakajima <jnakajim@gmail.com>
AuthorDate: Mon, 21 Jan 2013 17:23:09 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 21 Jan 2013 12:09:19 -0800

goldfish: platform device for x86

Based on code by Jun Nakajima but stripped of all the old x86 mach-foo
stuff and turned into a single file for the Goldfish virtual bus layer.

The actual created platform device and bus enumeration is portable between the
ARM and x86 Goldfish emulations.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Link: http://lkml.kernel.org/r/20130121172205.19517.22535.stgit@bob.linux.org.uk
Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
Signed-off-by: Xiaohui Xin <xiaohui.xin@intel.com>
Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Bruce Beare <bruce.j.beare@intel.com>
[Ported to 3.7 and reorganised so that we can keep most of the code
 shared properly]
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
---
 arch/x86/Kconfig                      | 12 +++++++++
 arch/x86/platform/Makefile            |  1 +
 arch/x86/platform/goldfish/Makefile   |  1 +
 arch/x86/platform/goldfish/goldfish.c | 51 +++++++++++++++++++++++++++++++++++
 4 files changed, 65 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79795af..46fb28c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -320,6 +320,10 @@ config X86_BIGSMP
 	---help---
 	  This option is needed for the systems that have more than 8 CPUs
 
+config GOLDFISH
+       def_bool y
+       depends on X86_GOLDFISH
+
 if X86_32
 config X86_EXTENDED_PLATFORM
 	bool "Support for extended (non-PC) x86 platforms"
@@ -402,6 +406,14 @@ config X86_UV
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
index 0000000..1693107
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
+ * Where in virtual device memory the IO devices (timers, system controllers
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
