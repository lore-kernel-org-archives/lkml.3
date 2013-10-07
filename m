Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3JGQgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:36:04 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:55283 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab3JGQf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:35:59 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net
Subject: [PATCH v2 02/29] openrisc: use boot_command_line instead of private cmd_line
Date: Mon,  7 Oct 2013 11:29:10 -0500
Message-Id: <1381163377-21044-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Save some pointless copying of the kernel command line and just use
boot_command_line instead. The DT code already handles CONFIG_CMDLINE,
so a separate copy is not needed.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux@lists.openrisc.net
Reviewed-by: Grant Likely <grant.likely@linaro.org>
---
 arch/openrisc/kernel/prom.c  | 7 +------
 arch/openrisc/kernel/setup.c | 4 +---
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index a63e768..bf3fd05 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -47,8 +47,6 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 
-extern char cmd_line[COMMAND_LINE_SIZE];
-
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
 	size &= PAGE_MASK;
@@ -67,15 +65,12 @@ void __init early_init_devtree(void *params)
 	 * device-tree, including the platform type, initrd location and
 	 * size, TCE reserve, and more ...
 	 */
-	of_scan_flat_dt(early_init_dt_scan_chosen, cmd_line);
+	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
 
 	/* Scan memory nodes and rebuild MEMBLOCKs */
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 
-	/* Save command line for /proc/cmdline and then parse parameters */
-	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
-
 	memblock_allow_resize();
 
 	/* We must copy the flattend device tree from init memory to regular
diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index d7359ff..719c5c8 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -50,8 +50,6 @@
 
 #include "vmlinux.h"
 
-char __initdata cmd_line[COMMAND_LINE_SIZE] = CONFIG_CMDLINE;
-
 static unsigned long __init setup_memory(void)
 {
 	unsigned long bootmap_size;
@@ -316,7 +314,7 @@ void __init setup_arch(char **cmdline_p)
 		conswitchp = &dummy_con;
 #endif
 
-	*cmdline_p = cmd_line;
+	*cmdline_p = boot_command_line;
 
 	printk(KERN_INFO "OpenRISC Linux -- http://openrisc.net\n");
 }
-- 
1.8.1.2

