Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbaFSNke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:40:34 -0400
Received: from mail-wg0-f68.google.com ([74.125.82.68]:60787 "EHLO
	mail-wg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaFSNkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:40:31 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Mark Salter <msalter@redhat.com>,
        Aubrey Li <aubrey.li@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 1/3] efi/reboot: Add generic wrapper around EfiResetSystem()
Date: Thu, 19 Jun 2014 14:40:23 +0100
Message-Id: <1403185225-9031-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
References: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Implement efi_reboot(), which is really just a wrapper around the
EfiResetSystem() EFI runtime service, but it does at least allow us to
funnel all callers through a single location.

It also simplifies the callsites since users no longer need to check to
see whether EFI_RUNTIME_SERVICES are enabled.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

Mark, I reworked my efi_reboot() to more closely match your versino.
Since we essentially wrote the same code I'd be happy to include your
chosen Copyright notice, I just didn't want to be presumptuous and do it
on your behalf without asking.

 arch/ia64/kernel/process.c    |  2 +-
 arch/x86/kernel/reboot.c      |  6 +-----
 drivers/firmware/efi/Makefile |  2 +-
 drivers/firmware/efi/reboot.c | 25 +++++++++++++++++++++++++
 include/linux/efi.h           |  4 ++++
 5 files changed, 32 insertions(+), 7 deletions(-)
 create mode 100644 drivers/firmware/efi/reboot.c

diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 55d4ba47a907..deed6fa96bb0 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -662,7 +662,7 @@ void
 machine_restart (char *restart_cmd)
 {
 	(void) notify_die(DIE_MACHINE_RESTART, restart_cmd, NULL, 0, 0, 0);
-	(*efi.reset_system)(EFI_RESET_WARM, 0, 0, NULL);
+	efi_reboot(REBOOT_WARM, NULL);
 }
 
 void
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 52b1157c53eb..09e709fd1830 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -528,11 +528,7 @@ static void native_machine_emergency_restart(void)
 			break;
 
 		case BOOT_EFI:
-			if (efi_enabled(EFI_RUNTIME_SERVICES))
-				efi.reset_system(reboot_mode == REBOOT_WARM ?
-						 EFI_RESET_WARM :
-						 EFI_RESET_COLD,
-						 EFI_SUCCESS, 0, NULL);
+			efi_reboot(reboot_mode, NULL);
 			reboot_type = BOOT_BIOS;
 			break;
 
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 9553496b0f43..c135154ead89 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for linux kernel
 #
-obj-$(CONFIG_EFI)			+= efi.o vars.o
+obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
new file mode 100644
index 000000000000..d10acc0a0370
--- /dev/null
+++ b/drivers/firmware/efi/reboot.c
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2014 Intel Corporation; author Matt Fleming
+ */
+#include <linux/efi.h>
+#include <linux/reboot.h>
+
+void efi_reboot(enum reboot_mode reboot_mode, const char *__unused)
+{
+	int efi_mode;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return;
+
+	switch (reboot_mode) {
+	case REBOOT_WARM:
+	case REBOOT_SOFT:
+		efi_mode = EFI_RESET_WARM;
+		break;
+	default:
+		efi_mode = EFI_RESET_COLD;
+		break;
+	}
+
+	efi.reset_system(efi_mode, EFI_SUCCESS, 0, NULL);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 41bbf8ba4ba8..0958d4bb399f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -20,6 +20,7 @@
 #include <linux/ioport.h>
 #include <linux/pfn.h>
 #include <linux/pstore.h>
+#include <linux/reboot.h>
 
 #include <asm/page.h>
 
@@ -926,11 +927,14 @@ static inline bool efi_enabled(int feature)
 {
 	return test_bit(feature, &efi.flags) != 0;
 }
+extern void efi_reboot(enum reboot_mode reboot_mode, const char *__unused);
 #else
 static inline bool efi_enabled(int feature)
 {
 	return false;
 }
+static inline void
+efi_reboot(enum reboot_mode reboot_mode, const char *__unused) {}
 #endif
 
 /*
-- 
1.9.0

