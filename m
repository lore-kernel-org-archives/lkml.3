Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965782AbaFQQpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:45:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964930AbaFQQpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:45:45 -0400
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH] arm64: support reboot and power off via EFI runtime
Date: Tue, 17 Jun 2014 12:45:14 -0400
Message-Id: <1403023514-1352-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add handlers for arm_pm_resestart and pm_power_off which use EFI
runtime services ResetSystem call to perform the functions. These
handlers are only installed if no handler currently exists. This
allows PSCI to take priority over EFI for these functions.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/kernel/efi.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 14db1f6..e8c0476 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -19,11 +19,14 @@
 #include <linux/of_fdt.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/reboot.h>
+#include <linux/pm.h>
 
 #include <asm/cacheflush.h>
 #include <asm/efi.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/system_misc.h>
 
 struct efi_memory_map memmap;
 
@@ -467,3 +470,40 @@ static int __init arm64_enter_virtual_mode(void)
 	return 0;
 }
 early_initcall(arm64_enter_virtual_mode);
+
+static void efi_restart(enum reboot_mode reboot_mode, const char *cmd)
+{
+	int efi_mode;
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
+	efi.reset_system(efi_mode, 0, 0, NULL);
+}
+
+static void efi_power_off(void)
+{
+	efi.reset_system(EFI_RESET_SHUTDOWN, 0, 0, NULL);
+}
+
+static int __init setup_efi_reset(void)
+{
+	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
+		/*
+		 * If something (psci, etc) hasn't already registered
+		 * a handler, use EFI.
+		 */
+		if (arm_pm_restart == NULL)
+			arm_pm_restart = efi_restart;
+		if (pm_power_off == NULL)
+			pm_power_off = efi_power_off;
+	}
+	return 0;
+}
+pure_initcall(setup_efi_reset);
-- 
1.9.0

