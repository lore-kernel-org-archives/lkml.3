Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab3KUEFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 23:05:18 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48798 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3KUEFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 23:05:16 -0500
From: Joel Fernandes <joelf@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <santosh.shilimkar@ti.com>, <balbi@ti.com>, <rnayak@ti.com>,
        <will.deacon@arm.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH] ARM: kernel: Detect DTB overwrite and error out
Date: Wed, 20 Nov 2013 22:04:04 -0600
Message-ID: <1385006644-16024-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel can silenty fail for DT-boot after the decompression stage, if DTB is
overwritten. Instead of simply failing, we detect the condition and print an
error.

One may think that it is sufficient for the bootloader to place the DTB away
from kernel, but this is not the right fix because: (1) We add more dependence
to the bootloader's stupidity (2) the decompressed kernel end address is not
known to the loader. Also, we shouldn't depend on bootloader for silently
failing us, so we detect the condition and error out.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/kernel/devtree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index f35906b..96c6964 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -21,6 +21,7 @@
 
 #include <asm/cputype.h>
 #include <asm/setup.h>
+#include <asm/sections.h>
 #include <asm/page.h>
 #include <asm/smp_plat.h>
 #include <asm/mach/arch.h>
@@ -201,6 +202,13 @@ const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 
 	devtree = phys_to_virt(dt_phys);
 
+	if ((char *)devtree <= _end) {
+		early_print("Error: Device tree overwritten by kernel image\n");
+		early_print("Please check your kernel config and/or bootloader\n");
+		while (true)
+			;
+	}
+
 	/* check device tree validity */
 	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER)
 		return NULL;
-- 
1.8.1.2

