Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934540Ab3JPNvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:51:22 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60950 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934526Ab3JPNvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:51:17 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 3/5] efi: Add common efi_reboot() implementation
Date: Wed, 16 Oct 2013 14:50:58 +0100
Message-Id: <1381931460-6999-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The reboot functionality is the same for all EFI implementations, so
provide a wrapper that is useable by all architectures.

Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/ia64/kernel/process.c    |  2 +-
 arch/x86/kernel/reboot.c      | 14 +++++++++-----
 drivers/firmware/efi/Makefile |  2 +-
 drivers/firmware/efi/reboot.c | 25 +++++++++++++++++++++++++
 include/linux/efi.h           |  2 ++
 5 files changed, 38 insertions(+), 7 deletions(-)
 create mode 100644 drivers/firmware/efi/reboot.c

diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 55d4ba4..2b55b8e 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -662,7 +662,7 @@ void
 machine_restart (char *restart_cmd)
 {
 	(void) notify_die(DIE_MACHINE_RESTART, restart_cmd, NULL, 0, 0, 0);
-	(*efi.reset_system)(EFI_RESET_WARM, 0, 0, NULL);
+	efi_reboot(EFI_RESET_WARM);
 }
 
 void
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 563ed91..78a1c67 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -497,11 +497,15 @@ static void native_machine_emergency_restart(void)
 			break;
 
 		case BOOT_EFI:
-			if (efi_enabled(EFI_RUNTIME_SERVICES))
-				efi.reset_system(reboot_mode == REBOOT_WARM ?
-						 EFI_RESET_WARM :
-						 EFI_RESET_COLD,
-						 EFI_SUCCESS, 0, NULL);
+			if (efi_enabled(EFI_RUNTIME_SERVICES)) {
+				int mode = EFI_RESET_COLD;
+
+				if (reboot_mode == REBOOT_WARM)
+					mode = EFI_RESET_WARM;
+
+				efi_reboot(mode);
+			}
+
 			reboot_type = BOOT_KBD;
 			break;
 
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 99245ab..6375e14 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -1,6 +1,6 @@
 #
 # Makefile for linux kernel
 #
-obj-y					+= efi.o vars.o
+obj-y					+= efi.o vars.o reboot.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
new file mode 100644
index 0000000..f9f34eb
--- /dev/null
+++ b/drivers/firmware/efi/reboot.c
@@ -0,0 +1,25 @@
+/*
+ * Copyright 2013 Intel Corporation <matt.fleming@intel.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ */
+
+#include <linux/efi.h>
+
+void efi_reboot(int mode)
+{
+	switch (mode) {
+	case EFI_RESET_COLD:
+	case EFI_RESET_WARM:
+	case EFI_RESET_SHUTDOWN:
+	case EFI_RESET_PLATFORM_SPECIFIC:
+		break;
+	default:
+		printk("efi: invalid reboot mode %d\n", mode);
+		return;
+	}
+
+	efi.reset_system(mode, EFI_SUCCESS, 0, NULL);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 153df45..eed69c9 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -283,6 +283,7 @@ typedef struct {
 #define EFI_RESET_COLD 0
 #define EFI_RESET_WARM 1
 #define EFI_RESET_SHUTDOWN 2
+#define EFI_RESET_PLATFORM_SPECIFIC 3
 
 /*
  * EFI Runtime Services table
@@ -591,6 +592,7 @@ extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+extern void efi_reboot(int mode);
 #ifdef CONFIG_X86
 extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
-- 
1.8.1.4

