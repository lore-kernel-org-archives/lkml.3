Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaEHWYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:24:30 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43900 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbaEHWYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:24:03 -0400
From: Rob Herring <robherring2@gmail.com>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Grant Likely <grant.likely@linaro.org>, benh@kernel.crashing.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5/6] of/fdt: add FDT serial scanning for earlycon
Date: Thu,  8 May 2014 17:23:42 -0500
Message-Id: <1399587823-17701-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399587823-17701-1-git-send-email-robherring2@gmail.com>
References: <1399587823-17701-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

This adds FDT parsing of {linux,}stdout-path to setup an early serial
console. Enabling of the early console is triggered with "earlycon"
(with no options) on the kernel command line.

Platforms must either have fixmap permanent mapping support,
have a functioning ioremap when early params are parsed, or explicitly
call early_init_dt_scan_chosen_serial from architecture code.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/fdt.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index a6f83ea..1fbeab2 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/libfdt.h>
 #include <linux/debugfs.h>
+#include <linux/serial_core.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
 #include <asm/page.h>
@@ -696,6 +697,61 @@ static inline void early_init_dt_check_for_initrd(unsigned long node)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+#ifdef CONFIG_SERIAL_EARLYCON
+extern struct of_device_id __earlycon_of_table[];
+
+int __init early_init_dt_scan_chosen_serial(void)
+{
+	int offset;
+	const char *p;
+	int l;
+	const struct of_device_id *match = __earlycon_of_table;
+	const void *fdt = initial_boot_params;
+
+	offset = fdt_path_offset(fdt, "/chosen");
+	if (offset < 0)
+		offset = fdt_path_offset(fdt, "/chosen@0");
+	if (offset < 0)
+		return -ENOENT;
+
+	p = fdt_getprop(fdt, offset, "stdout-path", &l);
+	if (!p)
+		p = fdt_getprop(fdt, offset, "linux,stdout-path", &l);
+	if (!p || !l)
+		return -ENOENT;
+
+	/* Get the node specified by stdout-path */
+	offset = fdt_path_offset(fdt, p);
+	if (offset < 0)
+		return -ENODEV;
+
+	while (match->compatible) {
+		unsigned long addr;
+		if (fdt_node_check_compatible(fdt, offset, match->compatible)) {
+			match++;
+			continue;
+		}
+
+		addr = fdt_translate_address(fdt, offset);
+		if (!addr)
+			return -ENXIO;
+
+		of_setup_earlycon(addr, match->data);
+		return 0;
+	}
+	return -ENODEV;
+}
+
+static int __init setup_of_earlycon(char *buf)
+{
+	if (buf)
+		return 0;
+
+	return early_init_dt_scan_chosen_serial();
+}
+early_param("earlycon", setup_of_earlycon);
+#endif
+
 /**
  * early_init_dt_scan_root - fetch the top level address and size cells
  */
-- 
1.9.1

