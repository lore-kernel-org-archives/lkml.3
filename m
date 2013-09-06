Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab3IFQDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:03:15 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37989 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3IFQDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:03:11 -0400
From: Yi Li <yi.li@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-uefi-internal@linaro.org, yi.li@linaro.org
Subject: [PATCH] ARM:DMI: Add dmi driver support on arm
Date: Sat,  7 Sep 2013 00:02:51 +0800
Message-Id: <1378483371-19858-2-git-send-email-yi.li@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378483371-19858-1-git-send-email-yi.li@linaro.org>
References: <1378483371-19858-1-git-send-email-yi.li@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liyi <yi.li@linaro.org>

Add dmi driver support on arm, it depends on efi runtime service
enabled.

Signed-off-by: liyi <yi.li@linaro.org>
---
 arch/arm/Kconfig           |    9 +++++++++
 arch/arm/include/asm/dmi.h |   12 ++++++++++++
 arch/arm/kernel/setup.c    |    7 ++++++-
 3 files changed, 27 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/include/asm/dmi.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e8daccd..02abb1d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1946,6 +1946,15 @@ config EFI_STUB
 	  executed directly by EFI firmware.
 	  See Documentation/efi-stub.txt for more information.
 
+config DMI
+	default y
+	bool "Enable DMI scanning" if EXPERT
+	---help---
+	  Enabled scanning of DMI to identify machine quirks. Say Y
+	  here unless you have verified that your setup is not
+	  affected by entries in the DMI blacklist. Required by EFI
+	  support.
+
 config SECCOMP
 	bool
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/arm/include/asm/dmi.h b/arch/arm/include/asm/dmi.h
new file mode 100644
index 0000000..84baf0e
--- /dev/null
+++ b/arch/arm/include/asm/dmi.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_DMI_H
+#define _ASM_DMI_H 1
+
+#include <linux/slab.h>
+#include <asm/io.h>
+#include <asm/mach/map.h>
+/* Use normal IO mappings for DMI */
+#define dmi_ioremap(x, l) __arm_ioremap((x), (l), MT_MEMORY)
+#define dmi_iounmap(x, l) __arm_iounmap((x))
+#define dmi_alloc(l) kmalloc(l, GFP_ATOMIC)
+
+#endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index a440211..2194554 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -34,13 +34,15 @@
 #ifdef CONFIG_ACPI
 #include <linux/acpi.h>
 #endif
+#ifdef CONFIG_DMI
+#include <linux/dmi.h>
+#endif
 
 #include <asm/unified.h>
 #include <asm/cp15.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/elf.h>
-#include <asm/io.h>
 #include <asm/procinfo.h>
 #include <asm/psci.h>
 #include <asm/sections.h>
@@ -1073,3 +1075,6 @@ const struct seq_operations cpuinfo_op = {
 	.stop	= c_stop,
 	.show	= c_show
 };
+#ifdef CONFIG_DMI
+	core_initcall(dmi_scan_machine);
+#endif
-- 
1.7.9.5

