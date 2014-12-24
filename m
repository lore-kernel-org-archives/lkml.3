Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaLXHMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:12:53 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:59698 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaLXHMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:12:51 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <gregkh@linuxfoundation.org>
CC: <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robh@kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/3] ARC: runtime determine BASE_BAUD per machine
Date: Wed, 24 Dec 2014 12:42:16 +0530
Message-ID: <1419405136-14520-4-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419405136-14520-1-git-send-email-vgupta@synopsys.com>
References: <1419405136-14520-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.182]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/include/asm/serial.h | 24 ++++--------------------
 arch/arc/kernel/devtree.c     | 24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/arch/arc/include/asm/serial.h b/arch/arc/include/asm/serial.h
index 602b0970a764..a8c0b8743709 100644
--- a/arch/arc/include/asm/serial.h
+++ b/arch/arc/include/asm/serial.h
@@ -10,26 +10,10 @@
 #define _ASM_ARC_SERIAL_H
 
 /*
- * early-8250 requires BASE_BAUD to be defined and includes this header.
- * We put in a typical value:
- * 	(core clk / 16) - i.e. UART samples 16 times per sec.
- * Athough in multi-platform-image this might not work, specially if the
- * clk driving the UART is different.
- * We can't use DeviceTree as this is typically for early serial.
+ * 8250_early (now earlycon) include this hdr and expect BASE_BAUD definition
+ * for setting up uartclk.
+ * Now that is done via arch provided earlycon_base_baud() which can use FDT
+ * provided info as well to provide uartclk based on DT in use.
  */
 
-#include <asm/clk.h>
-
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
-
 #endif /* _ASM_ARC_SERIAL_H */
diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
index fffdb5e41b20..8adc5958982f 100644
--- a/arch/arc/kernel/devtree.c
+++ b/arch/arc/kernel/devtree.c
@@ -17,6 +17,28 @@
 #include <asm/clk.h>
 #include <asm/mach_desc.h>
 
+#ifdef CONFIG_SERIAL_8250_CONSOLE
+
+static unsigned int arc_base_baud;
+
+unsigned int __init serial8250_early_base_baud(char *options)
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
1.8.3.2

