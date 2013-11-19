Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3KSLOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:14:24 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:34607 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3KSLMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:12:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
Subject: [PATCH 4/9] metag: Remove duplicate DT selection logic
Date: Tue, 19 Nov 2013 12:12:29 +0100
Message-Id: <1384859554-27268-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
References: <5283A000.8090007@gmail.com>
 <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_init_dt_scan() now takes care of falling back to the built-in DTB.
Note that we now have to check ourselves whether original_cmd_line is
a DTB or a command line, to keep command line append working.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: linux-metag@vger.kernel.org
---
Untested due to lack of cross-compiler.

 arch/metag/kernel/setup.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index 919c782f5479..e3ebfc5f5d77 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -221,6 +221,7 @@ static struct notifier_block metag_panic_block = {
 
 void __init setup_arch(char **cmdline_p)
 {
+	void *dt = NULL;
 	unsigned long start_pfn;
 	unsigned long text_start = (unsigned long)(&_stext);
 	unsigned long cpu = smp_processor_id();
@@ -242,26 +243,27 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	/* try interpreting the argument as a device tree */
-	machine_desc = setup_machine_fdt(original_cmd_line);
-	/* if it doesn't look like a device tree it must be a command line */
+	if (original_cmd_line &&
+	    be32_to_cpup((__be32 *)original_cmd_line) == OF_DT_HEADER) {
+		dt = original_cmd_line;
+		original_cmd_line = NULL;
+	}
+
+	machine_desc = setup_machine_fdt(dt);
 	if (!machine_desc) {
-#ifdef CONFIG_METAG_BUILTIN_DTB
-		/* try the embedded device tree */
-		machine_desc = setup_machine_fdt(&__dtb_start);
-		if (!machine_desc)
-			panic("Invalid embedded device tree.");
-#else
 		/* use the default machine description */
 		machine_desc = default_machine_desc();
-#endif
+	}
+
 #ifndef CONFIG_CMDLINE_FORCE
+	if (original_cmd_line) {
 		/* append the bootloader cmdline to any builtin fdt cmdline */
 		if (boot_command_line[0] && original_cmd_line[0])
 			strlcat(boot_command_line, " ", COMMAND_LINE_SIZE);
 		strlcat(boot_command_line, original_cmd_line,
 			COMMAND_LINE_SIZE);
-#endif
 	}
+#endif
 	setup_meta_clocks(machine_desc->clocks);
 
 	*cmdline_p = boot_command_line;
-- 
1.7.9.5

