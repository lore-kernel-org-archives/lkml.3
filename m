Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3EPQPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:15:17 -0400
Received: from relay1.sgi.com ([192.48.179.29]:56559 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab3EPQPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:15:10 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Miguel Boton <mboton.lkml@gmail.com>, Russ Anderson <rja@sgi.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -v11 resend 06/11] x86, prepare reboot_mode for moving to generic kernel code.
Date: Thu, 16 May 2013 11:14:45 -0500
Message-Id: <1368720890-57711-7-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368720890-57711-1-git-send-email-holt@sgi.com>
References: <1368720890-57711-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares for the moving the parsing of reboot= to the generic
kernel code by making reboot_mode into a more generic form.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Miguel Boton <mboton.lkml@gmail.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/reboot.c | 12 +++++++-----
 include/linux/reboot.h   |  5 +++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 76fa1e9..f770340 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -36,7 +36,7 @@ void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
-static int reboot_mode;
+static enum reboot_mode reboot_mode;
 enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
@@ -88,11 +88,11 @@ static int __init reboot_setup(char *str)
 
 		switch (*str) {
 		case 'w':
-			reboot_mode = 0x1234;
+			reboot_mode = REBOOT_WARM;
 			break;
 
 		case 'c':
-			reboot_mode = 0;
+			reboot_mode = REBOOT_COLD;
 			break;
 
 #ifdef CONFIG_SMP
@@ -536,6 +536,7 @@ static void native_machine_emergency_restart(void)
 	int i;
 	int attempt = 0;
 	int orig_reboot_type = reboot_type;
+	unsigned short mode;
 
 	if (reboot_emergency)
 		emergency_vmx_disable_all();
@@ -543,7 +544,8 @@ static void native_machine_emergency_restart(void)
 	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 
 	/* Tell the BIOS if we want cold or warm reboot */
-	*((unsigned short *)__va(0x472)) = reboot_mode;
+	mode = reboot_mode == REBOOT_WARM ? 0x1234 : 0;
+	*((unsigned short *)__va(0x472)) = mode;
 
 	for (;;) {
 		/* Could also try the reset bit in the Hammer NB */
@@ -585,7 +587,7 @@ static void native_machine_emergency_restart(void)
 
 		case BOOT_EFI:
 			if (efi_enabled(EFI_RUNTIME_SERVICES))
-				efi.reset_system(reboot_mode ?
+				efi.reset_system(reboot_mode == REBOOT_WARM ?
 						 EFI_RESET_WARM :
 						 EFI_RESET_COLD,
 						 EFI_SUCCESS, 0, NULL);
diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index c6eba21..37d56c3 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -10,6 +10,11 @@
 #define SYS_HALT	0x0002	/* Notify of system halt */
 #define SYS_POWER_OFF	0x0003	/* Notify of system power off */
 
+enum reboot_mode {
+	REBOOT_COLD = 0,
+	REBOOT_WARM,
+};
+
 extern int register_reboot_notifier(struct notifier_block *);
 extern int unregister_reboot_notifier(struct notifier_block *);
 
-- 
1.8.2.1

