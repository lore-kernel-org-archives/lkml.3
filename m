Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbbAFN7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:59:32 -0500
Received: from smtprelay4.synopsys.com ([198.182.47.9]:40494 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbbAFN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:59:30 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <robh@kernel.org>, Peter Hurley <peter@hurleysoftware.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, Jiri Slaby <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [Patch v4] ARC: Dynamically determine BASE_BAUD from DeviceTree
Date: Tue, 6 Jan 2015 19:29:07 +0530
Message-ID: <1420552747-27544-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <54ABD526.9020907@hurleysoftware.com>
References: <54ABD526.9020907@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8250 earlycon is broken on multi-platform ARC because the UART clk
value (BASE_BAUD) is fixed at build time.

Instead, determine the appropriate UART clk at runtime; parse the
devicetree early for platforms requiring alternate UART clk values
(currently only the TB10X platform).

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/serial.h | 23 +++++------------------
 arch/arc/kernel/devtree.c     | 24 ++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/arc/include/asm/serial.h b/arch/arc/include/asm/serial.h
index 602b0970a764..744a6ae15754 100644
--- a/arch/arc/include/asm/serial.h
+++ b/arch/arc/include/asm/serial.h
@@ -10,26 +10,13 @@
 #define _ASM_ARC_SERIAL_H
 
 /*
- * early-8250 requires BASE_BAUD to be defined and includes this header.
- * We put in a typical value:
- * 	(core clk / 16) - i.e. UART samples 16 times per sec.
- * Athough in multi-platform-image this might not work, specially if the
- * clk driving the UART is different.
- * We can't use DeviceTree as this is typically for early serial.
+ * early 8250 (now earlycon) requires BASE_BAUD to be defined in this header.
+ * However to still determine it dynamically (for multi-platform images)
+ * we do this in a helper by parsing the FDT early
  */
 
-#include <asm/clk.h>
+extern unsigned int __init arc_early_base_baud(void);
 
-#define BASE_BAUD	(arc_get_core_freq() / 16)
-
-/*
- * This is definitely going to break early 8250 consoles on multi-platform
- * images but hey, it won't add any code complexity for a debug feature of
- * one broken driver.
- */
-#ifdef CONFIG_ARC_PLAT_TB10X
-#undef BASE_BAUD
-#define BASE_BAUD	(arc_get_core_freq() / 16 / 3)
-#endif
+#define BASE_BAUD	arc_early_base_baud()
 
 #endif /* _ASM_ARC_SERIAL_H */
diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
index fffdb5e41b20..69a790cd9b6e 100644
--- a/arch/arc/kernel/devtree.c
+++ b/arch/arc/kernel/devtree.c
@@ -17,6 +17,28 @@
 #include <asm/clk.h>
 #include <asm/mach_desc.h>
 
+#ifdef CONFIG_SERIAL_8250_CONSOLE
+
+static unsigned int arc_base_baud;
+
+unsigned int __init arc_early_base_baud(void)
+{
+	return arc_base_baud/16;
+}
+
+static void __init arc_set_early_base_baud(unsigned long dt_root)
+{
+	unsigned int core_clk = arc_get_core_freq();
+
+	if (of_flat_dt_is_compatible(dt_root, "abilis,arc-tb10x"))
+		arc_base_baud = core_clk/3;
+	else
+		arc_base_baud = core_clk;
+}
+#else
+#define arc_set_early_base_baud(dt_root)
+#endif
+
 static const void * __init arch_get_next_mach(const char *const **match)
 {
 	static const struct machine_desc *mdesc = __arch_info_begin;
@@ -56,5 +78,7 @@ const struct machine_desc * __init setup_machine_fdt(void *dt)
 	if (clk)
 		arc_set_core_freq(of_read_ulong(clk, len/4));
 
+	arc_set_early_base_baud(dt_root);
+
 	return mdesc;
 }
-- 
1.9.1

